from __future__ import annotations

import csv
import glob
import json
import os
import re
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

ROOT = Path("/root/aicode/stock_analysis")
STOCK_REPORT = Path("/root/aicode/stock_report")
PERIOD = "2025-12-31"
RUN_DIR = Path(os.environ["BATCH_RUN_DIR"])
BEIJING = ZoneInfo("Asia/Shanghai")


def now() -> str:
    return datetime.now(BEIJING).isoformat(timespec="seconds")


def load_owner_rows():
    rows = []
    for path in glob.glob(str(STOCK_REPORT / "data/analysis/owner_earnback/*" / PERIOD / "result.json")):
        try:
            data = json.loads(Path(path).read_text(encoding="utf-8"))
        except Exception:
            continue
        metrics = data.get("metrics") or {}
        company = data.get("company") or {}
        code = str(company.get("code") or Path(path).parts[-3]).upper()
        if not re.search(r"\.(SH|SZ|BJ)$", code):
            continue
        row = {
            "code": code,
            "name": company.get("name") or "",
            "market": company.get("market") or "A",
            "case": metrics.get("investment_case_type") or metrics.get("earnback_category") or "",
            "owner_earnback_years": metrics.get("owner_earnback_years_after_haircut") or metrics.get("owner_earnback_years"),
            "market_profit_payback_years": metrics.get("market_profit_payback_years"),
            "liquidation_discount_ratio": metrics.get("liquidation_discount_ratio"),
            "discounted_detachable_net_cash": metrics.get("discounted_detachable_net_cash") or metrics.get("detachable_net_cash"),
            "market_cap": metrics.get("market_cap"),
            "owner_result": path,
        }
        rows.append(row)
    return rows


def num(value, default=10**99):
    return value if isinstance(value, (int, float)) else default


def already_done(code: str) -> bool:
    return (STOCK_REPORT / "data/analysis/stock_research" / code / PERIOD / "report.md").exists()

rows = load_owner_rows()
profit = [r for r in rows if r["case"] == "profit_cheap" and isinstance(r["market_profit_payback_years"], (int, float))]
profit.sort(key=lambda r: (num(r["owner_earnback_years"]), r["code"]))
liq = [r for r in rows if r["case"] == "liquidation_watch" and isinstance(r["liquidation_discount_ratio"], (int, float))]
liq.sort(key=lambda r: (-r["liquidation_discount_ratio"], r["code"]))

targets = []
seen = set()
for bucket, selected in [("profit_cheap", profit[:100]), ("liquidation_watch", liq[:20])]:
    for rank, item in enumerate(selected, start=1):
        key = item["code"]
        if key in seen:
            continue
        seen.add(key)
        item = dict(item)
        item["bucket"] = bucket
        item["bucket_rank"] = rank
        targets.append(item)

(RUN_DIR / "targets.json").write_text(json.dumps(targets, ensure_ascii=False, indent=2), encoding="utf-8")
with (RUN_DIR / "targets.csv").open("w", encoding="utf-8-sig", newline="") as handle:
    fieldnames = ["bucket", "bucket_rank", "code", "name", "owner_earnback_years", "market_profit_payback_years", "liquidation_discount_ratio", "discounted_detachable_net_cash", "market_cap", "owner_result"]
    writer = csv.DictWriter(handle, fieldnames=fieldnames)
    writer.writeheader()
    for row in targets:
        writer.writerow({k: row.get(k) for k in fieldnames})

summary = {
    "created_at": now(),
    "period": PERIOD,
    "a_owner_rows": len(rows),
    "profit_available": len(profit),
    "liquidation_available": len(liq),
    "targets": len(targets),
    "done": 0,
    "skipped_existing": 0,
    "errors": 0,
    "current": None,
}
(RUN_DIR / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

results = []
for index, target in enumerate(targets, start=1):
    code = target["code"]
    name = target.get("name") or ""
    summary["current"] = {"index": index, "total": len(targets), "code": code, "name": name, "started_at": now()}
    (RUN_DIR / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    if already_done(code):
        row = {"status": "skipped_existing", "code": code, "name": name, "bucket": target["bucket"], "bucket_rank": target["bucket_rank"], "finished_at": now()}
        results.append(row)
        summary["skipped_existing"] += 1
        summary["current"] = None
        (RUN_DIR / "results.jsonl").open("a", encoding="utf-8").write(json.dumps(row, ensure_ascii=False) + "\n")
        (RUN_DIR / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
        continue
    cmd = [
        sys.executable,
        "-m",
        "stock_analysis.interfaces.cli.stock_research_report_agent",
        "--code", code,
        "--name", name,
        "--market", "A",
        "--period", PERIOD,
        "--timeout-sec", "5400",
        "--stock-report-root", str(STOCK_REPORT),
    ]
    started = time.time()
    proc = subprocess.run(cmd, cwd=ROOT, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env={**os.environ, "PYTHONPATH": "src"}, timeout=6000)
    row = {
        "status": "ok" if proc.returncode == 0 else "error",
        "returncode": proc.returncode,
        "code": code,
        "name": name,
        "bucket": target["bucket"],
        "bucket_rank": target["bucket_rank"],
        "elapsed_sec": round(time.time() - started, 1),
        "finished_at": now(),
        "stdout_tail": proc.stdout[-2000:],
        "stderr_tail": proc.stderr[-2000:],
    }
    results.append(row)
    if proc.returncode == 0:
        summary["done"] += 1
    else:
        summary["errors"] += 1
    summary["current"] = None
    with (RUN_DIR / "results.jsonl").open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(row, ensure_ascii=False) + "\n")
    (RUN_DIR / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

summary["finished_at"] = now()
summary["current"] = None
(RUN_DIR / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

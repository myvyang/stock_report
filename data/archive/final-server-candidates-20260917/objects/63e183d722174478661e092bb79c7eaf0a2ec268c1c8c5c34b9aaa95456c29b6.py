from __future__ import annotations

import csv
import glob
import json
import os
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
WAIT_PID = os.environ.get("WAIT_PID")
BEIJING = ZoneInfo("Asia/Shanghai")


def now() -> str:
    return datetime.now(BEIJING).isoformat(timespec="seconds")


def pid_alive(pid: str | None) -> bool:
    if not pid:
        return False
    return subprocess.run(["/bin/sh", "-lc", f"kill -0 {pid} 2>/dev/null"], check=False).returncode == 0


def write_summary(summary: dict) -> None:
    (RUN_DIR / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

summary = {
    "created_at": now(),
    "period": PERIOD,
    "market": "HK",
    "wait_pid": WAIT_PID,
    "phase": "waiting_for_previous_batch" if WAIT_PID else "initializing",
    "targets": 0,
    "done": 0,
    "skipped_existing": 0,
    "errors": 0,
    "current": None,
}
write_summary(summary)
while pid_alive(WAIT_PID):
    summary["phase"] = "waiting_for_previous_batch"
    summary["wait_checked_at"] = now()
    write_summary(summary)
    time.sleep(60)
summary["phase"] = "running"
summary["started_running_at"] = now()
write_summary(summary)

rows = []
for path in glob.glob(str(STOCK_REPORT / "data/analysis/owner_earnback/*" / PERIOD / "result.json")):
    try:
        data = json.loads(Path(path).read_text(encoding="utf-8"))
    except Exception:
        continue
    metrics = data.get("metrics") or {}
    company = data.get("company") or {}
    code = str(company.get("code") or Path(path).parts[-3]).upper()
    if not code.endswith(".HK"):
        continue
    rows.append({
        "code": code,
        "name": company.get("name") or "",
        "market": "HK",
        "case": metrics.get("investment_case_type") or metrics.get("earnback_category") or "",
        "owner_earnback_years": metrics.get("owner_earnback_years_after_haircut") or metrics.get("owner_earnback_years"),
        "market_profit_payback_years": metrics.get("market_profit_payback_years"),
        "liquidation_discount_ratio": metrics.get("liquidation_discount_ratio"),
        "discounted_detachable_net_cash": metrics.get("discounted_detachable_net_cash") or metrics.get("detachable_net_cash"),
        "market_cap": metrics.get("market_cap"),
        "owner_result": path,
    })


def num(value, default=10**99):
    return value if isinstance(value, (int, float)) else default

profit = [r for r in rows if r["case"] == "profit_cheap" and isinstance(r["market_profit_payback_years"], (int, float))]
profit.sort(key=lambda r: (num(r["owner_earnback_years"]), r["code"]))
liq = [r for r in rows if r["case"] == "liquidation_watch" and isinstance(r["liquidation_discount_ratio"], (int, float))]
liq.sort(key=lambda r: (-r["liquidation_discount_ratio"], r["code"]))

targets = []
seen = set()
for bucket, selected in [("profit_cheap", profit[:100]), ("liquidation_watch", liq[:20])]:
    for rank, item in enumerate(selected, start=1):
        if item["code"] in seen:
            continue
        seen.add(item["code"])
        item = dict(item)
        item["bucket"] = bucket
        item["bucket_rank"] = rank
        targets.append(item)

summary.update({
    "hk_owner_rows": len(rows),
    "profit_available": len(profit),
    "liquidation_available": len(liq),
    "targets": len(targets),
})
write_summary(summary)
(RUN_DIR / "targets.json").write_text(json.dumps(targets, ensure_ascii=False, indent=2), encoding="utf-8")
with (RUN_DIR / "targets.csv").open("w", encoding="utf-8-sig", newline="") as handle:
    fieldnames = ["bucket", "bucket_rank", "code", "name", "owner_earnback_years", "market_profit_payback_years", "liquidation_discount_ratio", "discounted_detachable_net_cash", "market_cap", "owner_result"]
    writer = csv.DictWriter(handle, fieldnames=fieldnames)
    writer.writeheader()
    for row in targets:
        writer.writerow({k: row.get(k) for k in fieldnames})


def already_done(code: str) -> bool:
    return (STOCK_REPORT / "data/analysis/stock_research" / code / PERIOD / "report.md").exists()

for index, target in enumerate(targets, start=1):
    code = target["code"]
    name = target.get("name") or ""
    summary["current"] = {"index": index, "total": len(targets), "code": code, "name": name, "started_at": now()}
    write_summary(summary)
    if already_done(code):
        row = {"status": "skipped_existing", "code": code, "name": name, "bucket": target["bucket"], "bucket_rank": target["bucket_rank"], "finished_at": now()}
        summary["skipped_existing"] += 1
        summary["current"] = None
        with (RUN_DIR / "results.jsonl").open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(row, ensure_ascii=False) + "\n")
        write_summary(summary)
        continue
    cmd = [
        sys.executable, "-m", "stock_analysis.interfaces.cli.stock_research_report_agent",
        "--code", code, "--name", name, "--market", "HK", "--period", PERIOD,
        "--timeout-sec", "5400", "--stock-report-root", str(STOCK_REPORT),
    ]
    started = time.time()
    try:
        proc = subprocess.run(cmd, cwd=ROOT, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env={**os.environ, "PYTHONPATH": "src"}, timeout=6000)
        status = "ok" if proc.returncode == 0 else "error"
        row = {
            "status": status,
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
    except subprocess.TimeoutExpired as exc:
        row = {
            "status": "error",
            "returncode": None,
            "code": code,
            "name": name,
            "bucket": target["bucket"],
            "bucket_rank": target["bucket_rank"],
            "elapsed_sec": round(time.time() - started, 1),
            "finished_at": now(),
            "stderr_tail": f"batch wrapper timeout: {exc}",
        }
    if row["status"] == "ok":
        summary["done"] += 1
    else:
        summary["errors"] += 1
    summary["current"] = None
    with (RUN_DIR / "results.jsonl").open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(row, ensure_ascii=False) + "\n")
    write_summary(summary)

summary["phase"] = "finished"
summary["finished_at"] = now()
summary["current"] = None
write_summary(summary)

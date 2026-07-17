from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import tempfile
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional
from zoneinfo import ZoneInfo

from .io import now_beijing, write_json
from .pipeline import StockReportPipeline


BEIJING = ZoneInfo("Asia/Shanghai")
DEFAULT_MODEL = "gpt-5.5"
SCENARIO_NAME = "asset_structure_review"


def _slug(value: str) -> str:
    return "".join(character.lower() if character.isalnum() else "-" for character in value).strip("-")


def _load(path: Path) -> Dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


class AssetReviewAgentRunner:
    def __init__(self, root: Path, model: str = DEFAULT_MODEL, timeout: int = 1800):
        self.root = root.resolve()
        self.model = model
        self.timeout = timeout
        self.scenario = self.root / "agent_scenarios" / SCENARIO_NAME
        self.run_root = self.root / "data/agent_runs" / SCENARIO_NAME
        self.skill_source = Path(
            "/Users/haha/aicode/stock_analysis/.agents/skills/financial-report-analysis"
        )

    def run(self, company: Dict[str, Any], period: str) -> Dict[str, Any]:
        timestamp = datetime.now(BEIJING).isoformat(timespec="seconds").replace(":", "-")
        run_dir = self.run_root / f"{timestamp}-{_slug(company['code'])}-{_slug(company['name'])}"
        self._materialize(run_dir, company, period)
        prompt = self._prompt(run_dir)
        outputs = run_dir / "outputs"
        work_root = Path(tempfile.gettempdir()) / "stock_report_asset_review" / run_dir.name
        work_root.mkdir(parents=True, exist_ok=True)
        command = [
            "codex",
            "exec",
            "--dangerously-bypass-approvals-and-sandbox",
            "--skip-git-repo-check",
            "--cd",
            str(work_root),
            "--json",
            "--model",
            self.model,
            "--output-last-message",
            str(outputs / "output.txt"),
            prompt,
        ]
        write_json(
            outputs / "metadata.json",
            {
                "created_at": now_beijing(),
                "timezone": "Asia/Shanghai",
                "runner": "codex-cli-v1",
                "model": self.model,
                "scenario": SCENARIO_NAME,
                "company": company,
                "period": period,
            },
        )
        with (outputs / "events.jsonl").open("w", encoding="utf-8") as events:
            completed = subprocess.run(
                command,
                text=True,
                stdout=events,
                stderr=subprocess.PIPE,
                timeout=self.timeout,
                check=False,
            )
        (outputs / "debug.log").write_text(completed.stderr or "", encoding="utf-8")
        if completed.returncode:
            raise RuntimeError(f"codex exited {completed.returncode}: {completed.stderr[-500:]}")
        result = self._validate(outputs)
        canonical_dir = self.root / f"data/analysis/asset_structure/{company['code']}"
        canonical_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(outputs / "result.json", canonical_dir / f"{period}-reviewed.json")
        shutil.copy2(outputs / "report.md", canonical_dir / f"{period}-reviewed.md")
        return result

    def _materialize(self, run_dir: Path, company: Dict[str, Any], period: str) -> None:
        config = run_dir / "config"
        outputs = run_dir / "outputs"
        work = run_dir / "work"
        for directory in [config / "prompts", config / "skills", outputs, work]:
            directory.mkdir(parents=True, exist_ok=True)
        for name in ["scenario.json", "system-prompt.md"]:
            shutil.copy2(self.scenario / name, config / name)
        shutil.copy2(self.scenario / "prompts/main.md", config / "prompts/main.md")
        if self.skill_source.exists():
            shutil.copytree(
                self.skill_source,
                config / "skills/financial-report-analysis",
                dirs_exist_ok=True,
            )
        sources = {
            "quarterly_analysis": self.root / f"data/analysis/asset_structure/{company['code']}/{period}.json",
            "quarterly_statement": self.root / f"data/raw/statements/{company['code']}/{period}/balance-sheet.json",
            "quarterly_filing": next(
                (self.root / f"data/raw/filings/{company['code']}/{period}").glob("*-report.pdf")
            ),
            "annual_filing": self.root / f"data/raw/filings/{company['code']}/2025-12-31/annual-report.pdf",
            "annual_review": self.root / f"data/analysis/annual_review/{company['code']}/2025-12-31/result.json",
        }
        write_json(
            config / "input.json",
            {
                "company": company,
                "period": period,
                "annual_evidence_period": "2025-12-31",
                "created_at": now_beijing(),
                "timezone": "Asia/Shanghai",
                "run_dir": str(run_dir),
                "sources": {key: str(path) for key, path in sources.items()},
            },
        )

    def _prompt(self, run_dir: Path) -> str:
        return "\n\n".join(
            [
                (run_dir / "config/system-prompt.md").read_text(encoding="utf-8"),
                (run_dir / "config/prompts/main.md").read_text(encoding="utf-8"),
                "## 本次运行",
                f"run_dir: `{run_dir}`",
                f"input_json: `{run_dir / 'config/input.json'}`",
                f"skill: `{run_dir / 'config/skills/financial-report-analysis/SKILL.md'}`",
                "先完整读取上述 skill，再开始核对。",
            ]
        )

    def _validate(self, outputs: Path) -> Dict[str, Any]:
        for name in ["result.json", "report.md", "trace.txt"]:
            if not (outputs / name).exists():
                raise ValueError(f"Agent output missing {name}")
        result = _load(outputs / "result.json")
        summary = result.get("summary") or {}
        required = ["total_assets", "funds_assets", "operating_assets", "investment_assets", "other_assets"]
        if any(not isinstance(summary.get(key), (int, float)) for key in required):
            raise ValueError("Agent result has missing/non-numeric asset summary")
        categories = sum(float(summary[key]) for key in required[1:])
        item_total = sum(float(item["amount"]) for item in result.get("items") or [])
        total = float(summary["total_assets"])
        if abs(categories - total) > 1 or abs(item_total - total) > 1:
            raise ValueError(
                f"Agent result does not reconcile: total={total}, categories={categories}, items={item_total}"
            )
        return result


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the asset-structure review agent")
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--code", action="append")
    parser.add_argument("--review-required", action="store_true")
    parser.add_argument("--workers", type=int, default=1)
    parser.add_argument("--resume", action="store_true")
    parser.add_argument("--period", default="2026-03-31")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--timeout", type=int, default=1800)
    arguments = parser.parse_args()
    pipeline = StockReportPipeline(arguments.root)
    companies = {company["code"]: company for company in pipeline.load_universe()}
    runner = AssetReviewAgentRunner(arguments.root, arguments.model, arguments.timeout)
    codes = list(arguments.code or [])
    if arguments.review_required:
        for code, company in companies.items():
            preliminary = arguments.root / f"data/analysis/asset_structure/{code}/{arguments.period}.json"
            if preliminary.exists() and _load(preliminary).get("status") == "review_required":
                codes.append(code)
    codes = list(dict.fromkeys(codes))
    if not codes:
        raise SystemExit("Provide --code or --review-required")
    if arguments.workers < 1:
        raise SystemExit("--workers must be at least 1")
    pending = []
    for code in codes:
        if code not in companies:
            raise SystemExit(f"Code not in universe: {code}")
        reviewed = arguments.root / f"data/analysis/asset_structure/{code}/{arguments.period}-reviewed.json"
        if arguments.resume and reviewed.exists():
            result = _load(reviewed)
            print(json.dumps({"company": result["company"], "status": "existing"}, ensure_ascii=False), flush=True)
        else:
            pending.append(code)
    with ThreadPoolExecutor(max_workers=min(arguments.workers, len(pending) or 1)) as executor:
        futures = {
            executor.submit(runner.run, companies[code], arguments.period): code for code in pending
        }
        for future in as_completed(futures):
            code = futures[future]
            try:
                result = future.result()
                output = {"company": result["company"], "status": result["status"]}
            except Exception as error:
                output = {"company": companies[code], "status": "error", "error": str(error)}
            print(json.dumps(output, ensure_ascii=False), flush=True)


if __name__ == "__main__":
    main()

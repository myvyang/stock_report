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
DEFAULT_ANNUAL_PERIOD = "2025-12-31"


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
        self.price_skill_source = self.root / ".agents/skills/a-share-price-fetch"

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
        if self.price_skill_source.exists():
            shutil.copytree(
                self.price_skill_source,
                config / "skills/a-share-price-fetch",
                dirs_exist_ok=True,
            )
        annual_period = DEFAULT_ANNUAL_PERIOD
        sources = {
            "annual_filing": self.root / f"data/raw/filings/{company['code']}/{annual_period}/annual-report.pdf",
            "annual_review": self.root / f"data/analysis/annual_review/{company['code']}/{annual_period}/result.json",
        }
        if period != annual_period:
            sources.update(
                {
                    "quarterly_analysis": self.root
                    / f"data/analysis/asset_structure/{company['code']}/{period}.json",
                    "quarterly_statement": self.root
                    / f"data/raw/statements/{company['code']}/{period}/balance-sheet.json",
                    "quarterly_filing": next(
                        (self.root / f"data/raw/filings/{company['code']}/{period}").glob("*-report.pdf")
                    ),
                }
            )
        write_json(
            config / "input.json",
            {
                "company": company,
                "period": period,
                "analysis_basis": "annual" if period == annual_period else "quarterly",
                "annual_evidence_period": annual_period,
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
                f"price_skill: `{run_dir / 'config/skills/a-share-price-fetch/SKILL.md'}`",
                "先完整读取上述 skills，再开始核对。",
            ]
        )

    def _validate(self, outputs: Path) -> Dict[str, Any]:
        for name in ["result.json", "report.md", "trace.txt"]:
            if not (outputs / name).exists():
                raise ValueError(f"Agent output missing {name}")
        result = _load(outputs / "result.json")
        summary = result.get("summary") or {}
        required = [
            "total_assets",
            "funds_assets",
            "operating_assets",
            "investment_assets",
            "other_assets",
            "total_liabilities",
            "financing_liabilities",
            "operating_liabilities",
            "investment_liabilities",
            "other_liabilities",
            "total_equity",
            "parent_equity",
            "minority_interest",
            "minority_interest_ratio",
            "net_funds",
            "net_operating_assets",
            "net_investment_assets",
            "other_net_assets",
            "equity_reconciliation_difference",
        ]
        if any(not isinstance(summary.get(key), (int, float)) for key in required):
            raise ValueError("Agent result has missing/non-numeric net asset summary")
        asset_categories = sum(
            float(summary[key])
            for key in ["funds_assets", "operating_assets", "investment_assets", "other_assets"]
        )
        liability_categories = sum(
            float(summary[key])
            for key in [
                "financing_liabilities",
                "operating_liabilities",
                "investment_liabilities",
                "other_liabilities",
            ]
        )
        item_total = sum(float(item["amount"]) for item in result.get("items") or [])
        liability_item_total = sum(float(item["amount"]) for item in result.get("liability_items") or [])
        for collection_name in ["items", "liability_items"]:
            for item in result.get(collection_name) or []:
                business_substance = item.get("business_substance")
                if not isinstance(business_substance, str) or not business_substance.strip():
                    raise ValueError(
                        f"Agent {collection_name} item missing business_substance: "
                        f"{item.get('source_field') or item.get('item_name')}"
                    )
        total = float(summary["total_assets"])
        liabilities = float(summary["total_liabilities"])
        equity = float(summary["total_equity"])
        parent_equity = float(summary["parent_equity"])
        minority_interest = float(summary["minority_interest"])
        net_funds = float(summary["net_funds"])
        net_operating_assets = float(summary["net_operating_assets"])
        net_investment_assets = float(summary["net_investment_assets"])
        other_net_assets = float(summary["other_net_assets"])
        if abs(asset_categories - total) > 1 or abs(item_total - total) > 1:
            raise ValueError(
                f"Agent asset result does not reconcile: total={total}, "
                f"categories={asset_categories}, items={item_total}"
            )
        if abs(liability_categories - liabilities) > 1 or abs(liability_item_total - liabilities) > 1:
            raise ValueError(
                f"Agent liability result does not reconcile: total={liabilities}, "
                f"categories={liability_categories}, items={liability_item_total}"
            )
        formula_checks = {
            "total_equity": total - liabilities - equity,
            "parent_equity": parent_equity + minority_interest - equity,
            "net_funds": float(summary["funds_assets"]) - float(summary["financing_liabilities"]) - net_funds,
            "net_operating_assets": (
                float(summary["operating_assets"])
                - float(summary["operating_liabilities"])
                - net_operating_assets
            ),
            "net_investment_assets": (
                float(summary["investment_assets"])
                - float(summary["investment_liabilities"])
                - net_investment_assets
            ),
            "other_net_assets": float(summary["other_assets"]) - float(summary["other_liabilities"]) - other_net_assets,
            "equity_reconciliation": (
                net_funds + net_operating_assets + net_investment_assets + other_net_assets - equity
            ),
        }
        failed = {key: value for key, value in formula_checks.items() if abs(value) > 1}
        if failed:
            raise ValueError(f"Agent net asset formulas do not reconcile: {failed}")
        self._validate_income_and_cash_flow(result)
        self._validate_market_price(result)
        return result

    def _validate_market_price(self, result: Dict[str, Any]) -> None:
        market_price = result.get("market_price")
        if not isinstance(market_price, dict):
            raise ValueError("Agent result missing market_price")
        if not isinstance(market_price.get("price"), (int, float)) or float(market_price["price"]) <= 0:
            raise ValueError("Agent market_price missing positive numeric price")
        for field in ["currency", "quote_time", "fetched_at", "source", "source_url"]:
            if not isinstance(market_price.get(field), str) or not market_price[field].strip():
                raise ValueError(f"Agent market_price missing {field}")

    def _validate_income_and_cash_flow(self, result: Dict[str, Any]) -> None:
        income = result.get("income_core")
        if not isinstance(income, dict):
            raise ValueError("Agent result missing income_core")
        for period_key in ["current", "comparison"]:
            values = income.get(period_key)
            if not isinstance(values, dict):
                raise ValueError(f"Agent income_core missing {period_key}")
            for field in ["operating_revenue", "operating_cost", "gross_profit", "parent_net_profit"]:
                if not isinstance(values.get(field), (int, float)):
                    raise ValueError(f"Agent income_core.{period_key} missing/non-numeric {field}")
            gross_difference = (
                float(values["operating_revenue"])
                - float(values["operating_cost"])
                - float(values["gross_profit"])
            )
            if abs(gross_difference) > 1:
                raise ValueError(
                    f"Agent income_core.{period_key} gross profit does not reconcile: {gross_difference}"
                )

        cash_flow = result.get("cash_flow_core")
        if not isinstance(cash_flow, dict):
            raise ValueError("Agent result missing cash_flow_core")
        for period_key in ["current", "comparison"]:
            values = cash_flow.get(period_key)
            if not isinstance(values, dict):
                raise ValueError(f"Agent cash_flow_core missing {period_key}")
            for field in [
                "operating_cash_flow_net",
                "investing_cash_flow_net",
                "financing_cash_flow_net",
                "cash_and_equivalents_net_increase",
            ]:
                if not isinstance(values.get(field), (int, float)):
                    raise ValueError(f"Agent cash_flow_core.{period_key} missing/non-numeric {field}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the asset-structure review agent")
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--code", action="append")
    parser.add_argument("--review-required", action="store_true")
    parser.add_argument("--workers", type=int, default=1)
    parser.add_argument("--resume", action="store_true")
    parser.add_argument("--period", default=DEFAULT_ANNUAL_PERIOD)
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

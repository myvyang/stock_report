from __future__ import annotations

import csv
import json
import shutil
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional

from .classification import classify_balance_row
from .cninfo import CninfoClient
from .eastmoney import EastmoneyClient, find_period_row
from .io import now_beijing, sha256_file, write_json


class StockReportPipeline:
    def __init__(self, root: Path):
        self.root = root.resolve()

    @property
    def universe_path(self) -> Path:
        return self.root / "data/universe/roic_top50.json"

    def import_universe(self, source_csv: Path) -> List[Dict[str, Any]]:
        with source_csv.open(encoding="utf-8-sig", newline="") as stream:
            rows = list(csv.DictReader(stream))
        if len(rows) != 50:
            raise ValueError(f"Expected ROIC Top50, got {len(rows)} rows")
        companies: List[Dict[str, Any]] = []
        for row in rows:
            companies.append(
                {
                    "rank": int(row["rank"]),
                    "code": row["code"],
                    "name": row["name"],
                    "ranking_eligible": row["ranking_eligible"].lower() == "true",
                    "ranking_exclusion_reason": row["ranking_exclusion_reason"],
                    "verified_roic": _optional_float(row["verified_roic"]),
                    "verified_cash_roic": _optional_float(row["verified_cash_roic"]),
                    "confidence": row["confidence"],
                    "review_priority": row["review_priority"],
                    "official_annual_filing_url": row["official_filing_url"],
                    "source_run_dir": row["run_dir"],
                }
            )
        document = {
            "universe_id": "a-share-roic-top50-2026-07-15-v3-gpt55",
            "description": "stock_analysis ROIC Top50；保留48个可排序样本及2个排除样本",
            "source_file": source_csv.name,
            "imported_at": now_beijing(),
            "count": len(companies),
            "companies": companies,
        }
        write_json(self.universe_path, document)
        return companies

    def load_universe(self) -> List[Dict[str, Any]]:
        return json.loads(self.universe_path.read_text(encoding="utf-8"))["companies"]

    def import_annual_reports(self, source_dir: Path) -> Dict[str, int]:
        counts = {"copied": 0, "existing": 0, "missing": 0}
        for company in self.load_universe():
            code = company["code"]
            number, exchange = code.split(".")
            source = source_dir / f"{number}_{exchange}_2025_annual_report.pdf"
            destination_dir = self.root / f"data/raw/filings/{code}/2025-12-31"
            destination = destination_dir / "annual-report.pdf"
            if not source.exists():
                counts["missing"] += 1
                continue
            destination_dir.mkdir(parents=True, exist_ok=True)
            if destination.exists() and sha256_file(destination) == sha256_file(source):
                counts["existing"] += 1
            else:
                shutil.copy2(source, destination)
                counts["copied"] += 1
            write_json(
                destination_dir / "metadata.json",
                {
                    "company": {"code": code, "name": company["name"]},
                    "report_period": "2025-12-31",
                    "report_type": "annual",
                    "source": "cninfo_official_filing",
                    "source_url": company["official_annual_filing_url"],
                    "local_file": "annual-report.pdf",
                    "sha256": sha256_file(destination),
                    "imported_at": now_beijing(),
                    "import_origin": source.name,
                },
            )
        return counts

    def import_annual_reviews(self) -> Dict[str, int]:
        counts = {"copied": 0, "missing": 0}
        for company in self.load_universe():
            run_dir = Path(company["source_run_dir"])
            source_result = run_dir / "outputs/result.json"
            source_report = run_dir / "outputs/report.md"
            destination = self.root / f"data/analysis/annual_review/{company['code']}/2025-12-31"
            if not source_result.exists():
                counts["missing"] += 1
                continue
            destination.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source_result, destination / "result.json")
            if source_report.exists():
                shutil.copy2(source_report, destination / "report.md")
            write_json(
                destination / "metadata.json",
                {
                    "company": {"code": company["code"], "name": company["name"]},
                    "analysis_period": "2025-12-31",
                    "analysis_type": "annual_roic_verification",
                    "result_sha256": sha256_file(destination / "result.json"),
                    "imported_at": now_beijing(),
                    "import_origin": run_dir.name,
                    "note": "既有年报核对证据，供最新季报资产性质复核引用；并非最新季报资产分类结果",
                },
            )
            counts["copied"] += 1
        return counts

    def fetch_latest_for_company(self, company: Dict[str, Any], year: int) -> Dict[str, Any]:
        code = company["code"]
        announcement = CninfoClient().latest_interim_report(code, year)
        title = announcement["clean_title"]
        period = f"{year}-06-30" if "半年度" in title else f"{year}-03-31"
        report_type = "half-year" if "半年度" in title else "first-quarter"
        filing_dir = self.root / f"data/raw/filings/{code}/{period}"
        pdf_path = filing_dir / f"{report_type}-report.pdf"
        if not pdf_path.exists():
            CninfoClient().download(announcement["source_url"], pdf_path)
        write_json(
            filing_dir / "metadata.json",
            {
                "company": {"code": code, "name": company["name"]},
                "report_period": period,
                "report_type": report_type,
                "title": title,
                "announcement_time_ms": announcement.get("announcementTime"),
                "source": "cninfo_official_filing",
                "source_url": announcement["source_url"],
                "local_file": pdf_path.name,
                "sha256": sha256_file(pdf_path),
                "fetched_at": now_beijing(),
            },
        )
        raw = EastmoneyClient().fetch_balance_sheet(code, [period, "2025-12-31"])
        raw["fetched_at"] = now_beijing()
        raw_path = self.root / f"data/raw/statements/{code}/{period}/balance-sheet.json"
        write_json(raw_path, raw)
        row = find_period_row(raw, period)
        self._write_normalized_facts(company, period, row, raw_path)
        return {"code": code, "name": company["name"], "period": period, "title": title}

    def analyze_company(self, company: Dict[str, Any], period: str) -> Dict[str, Any]:
        raw_path = self.root / f"data/raw/statements/{company['code']}/{period}/balance-sheet.json"
        raw = json.loads(raw_path.read_text(encoding="utf-8"))
        row = find_period_row(raw, period)
        result = classify_balance_row(company["code"], company["name"], period, row)
        result["sources"] = {
            "quarterly_statement": str(raw_path.relative_to(self.root)),
            "quarterly_filing": f"data/raw/filings/{company['code']}/{period}/metadata.json",
            "annual_filing": f"data/raw/filings/{company['code']}/2025-12-31/metadata.json",
            "annual_review": f"data/analysis/annual_review/{company['code']}/2025-12-31/result.json",
        }
        result["generated_at"] = now_beijing()
        output = self.root / f"data/analysis/asset_structure/{company['code']}/{period}.json"
        write_json(output, result)
        return result

    def run_latest(self, year: int, codes: Optional[Iterable[str]] = None) -> List[Dict[str, Any]]:
        selected = set(codes or [])
        results = []
        for company in self.load_universe():
            if selected and company["code"] not in selected:
                continue
            latest = self.fetch_latest_for_company(company, year)
            analysis = self.analyze_company(company, latest["period"])
            results.append(analysis)
        self.write_summary(results)
        return results

    def write_summary(self, results: List[Dict[str, Any]]) -> None:
        output_dir = self.root / "data/outputs"
        output_dir.mkdir(parents=True, exist_ok=True)
        rows = []
        for result in results:
            summary = result["summary"]
            total = summary["total_assets"]
            rows.append(
                {
                    "code": result["company"]["code"],
                    "name": result["company"]["name"],
                    "period": result["period"],
                    "status": result["status"],
                    **summary,
                    "funds_ratio": summary["funds_assets"] / total if total else None,
                    "operating_ratio": summary["operating_assets"] / total if total else None,
                    "investment_ratio": summary["investment_assets"] / total if total else None,
                    "other_ratio": summary["other_assets"] / total if total else None,
                    "review_flags": "；".join(result["review_flags"]),
                }
            )
        write_json(
            output_dir / "roic_top50_latest_asset_structure.json",
            {"generated_at": now_beijing(), "count": len(rows), "companies": rows},
        )
        fields = list(rows[0]) if rows else []
        with (output_dir / "roic_top50_latest_asset_structure.csv").open(
            "w", encoding="utf-8-sig", newline=""
        ) as stream:
            writer = csv.DictWriter(stream, fieldnames=fields)
            writer.writeheader()
            writer.writerows(rows)

    def _write_normalized_facts(
        self, company: Dict[str, Any], period: str, row: Dict[str, Any], raw_path: Path
    ) -> None:
        facts = []
        for key, value in row.items():
            if key.endswith("_YOY") or not isinstance(value, (int, float)):
                continue
            facts.append(
                {
                    "company_code": company["code"],
                    "report_period": period,
                    "statement": "balance_sheet",
                    "item_key": key.lower(),
                    "source_field": key,
                    "value": value,
                    "currency": "CNY",
                    "unit": "yuan",
                    "source_type": "structured_provider_raw",
                    "source_path": str(raw_path.relative_to(self.root)),
                }
            )
        write_json(
            self.root / f"data/normalized/facts/{company['code']}/{period}/balance-sheet.json",
            {"generated_at": now_beijing(), "facts": facts},
        )


def _optional_float(value: str) -> Optional[float]:
    return float(value) if value.strip() else None

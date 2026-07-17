from __future__ import annotations

import argparse
import json
from pathlib import Path

from .pipeline import StockReportPipeline


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description="Archive filings and analyze asset structure")
    result.add_argument("--root", type=Path, default=Path.cwd())
    commands = result.add_subparsers(dest="command", required=True)

    import_universe = commands.add_parser("import-universe")
    import_universe.add_argument("source_csv", type=Path)

    import_annual = commands.add_parser("import-annual")
    import_annual.add_argument("source_directory", type=Path)

    run = commands.add_parser("run-latest")
    run.add_argument("--year", type=int, default=2026)
    run.add_argument("--code", action="append", dest="codes")
    return result


def main() -> None:
    arguments = parser().parse_args()
    pipeline = StockReportPipeline(arguments.root)
    if arguments.command == "import-universe":
        output = {"companies": len(pipeline.import_universe(arguments.source_csv))}
    elif arguments.command == "import-annual":
        output = pipeline.import_annual_reports(arguments.source_directory)
    else:
        results = pipeline.run_latest(arguments.year, arguments.codes)
        output = {"companies": len(results), "periods": sorted({item["period"] for item in results})}
    print(json.dumps(output, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()

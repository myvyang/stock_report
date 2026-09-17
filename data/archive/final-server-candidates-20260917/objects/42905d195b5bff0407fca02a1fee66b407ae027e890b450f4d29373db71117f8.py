#!/usr/bin/env python3
"""Maintain one canonical source-row ledger and compile all annual fact views."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

SCRIPTS_DIR = Path(__file__).resolve().parent
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

from stock_research_tools.facts_identity import build_identity, pinned_source, year_of  # noqa: E402
from stock_research_tools.source_ledger import (  # noqa: E402
    SCHEMA_VERSION,
    TARGETS,
    compile_facts,
    load,
    recompile,
    validate_payload,
)


def write(path: Path, value: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def init_payload(args: argparse.Namespace) -> dict[str, Any]:
    identity = build_identity(
        year=args.year,
        period_end=args.period_end,
        company=load(Path(args.input)).get("company") or {},
        materials=load(Path(args.materials)),
    )
    return compile_facts(
        {
            "schema_version": SCHEMA_VERSION,
            "year": year_of(identity),
            "amount_currency": args.amount_currency,
            "amount_unit": args.amount_unit,
            "amount_scale_to_currency": args.amount_scale_to_currency,
            "identity": identity,
            "sources": [pinned_source(identity)],
            "source_rows": [],
            "conflicts": [],
            "disclosure_limitations": [],
        }
    )


def upsert_row(args: argparse.Namespace) -> None:
    path = Path(args.facts)
    payload = load(path)
    target = args.target
    if target != "memo" and target not in TARGETS:
        raise ValueError(f"unknown target {target!r}; run list-targets")
    mapping: dict[str, Any] = {"target": target}
    if target == "memo":
        if not args.exclusion_reason:
            raise ValueError("memo rows require --exclusion-reason")
        mapping["exclusion_reason"] = args.exclusion_reason
    row = {
        "row_id": args.row_id,
        "statement": args.statement,
        "period_role": args.period_role,
        "reported_item": args.reported_item,
        "amount": args.amount,
        "reporting_date": args.reporting_date,
        "source_ids": list(dict.fromkeys(args.source_id)),
        "locator": args.locator,
        "measurement": args.measurement,
        "mapping": mapping,
    }
    if args.source_line is not None:
        row["source_line"] = args.source_line
    if args.source_line_end is not None:
        row["source_line_end"] = args.source_line_end
    rows = payload.setdefault("source_rows", [])
    for index, existing in enumerate(rows):
        if existing.get("row_id") == args.row_id:
            rows[index] = row
            break
    else:
        rows.append(row)
    write(path, recompile(payload))


def remove_row(args: argparse.Namespace) -> None:
    path = Path(args.facts)
    payload = load(path)
    rows = payload.get("source_rows") or []
    remaining = [row for row in rows if row.get("row_id") != args.row_id]
    if len(remaining) == len(rows):
        raise ValueError(f"source row {args.row_id!r} does not exist")
    payload["source_rows"] = remaining
    write(path, recompile(payload))


def set_mapping(args: argparse.Namespace) -> None:
    path = Path(args.facts)
    payload = load(path)
    target = args.target
    if target != "memo" and target not in TARGETS:
        raise ValueError(f"unknown target {target!r}; run list-targets")
    for row in payload.get("source_rows") or []:
        if row.get("row_id") != args.row_id:
            continue
        row["mapping"] = {"target": target}
        if target == "memo":
            if not args.exclusion_reason:
                raise ValueError("memo rows require --exclusion-reason")
            row["mapping"]["exclusion_reason"] = args.exclusion_reason
        write(path, recompile(payload))
        return
    raise ValueError(f"source row {args.row_id!r} does not exist")


def add_conflict(args: argparse.Namespace) -> None:
    path = Path(args.facts)
    payload = load(path)
    conflict = json.loads(args.conflict_json)
    if not isinstance(conflict, dict) or not conflict.get("conflict_id"):
        raise ValueError("conflict JSON must be an object with conflict_id")
    conflicts = payload.setdefault("conflicts", [])
    conflicts = [item for item in conflicts if item.get("conflict_id") != conflict["conflict_id"]]
    conflicts.append(conflict)
    payload["conflicts"] = conflicts
    write(path, recompile(payload))


def parser() -> argparse.ArgumentParser:
    root = argparse.ArgumentParser(description=__doc__)
    commands = root.add_subparsers(dest="command", required=True)
    init = commands.add_parser("init")
    init.add_argument("--year", required=True, type=int)
    init.add_argument("--period-end", help="Fiscal period end; defaults to <year>-12-31")
    init.add_argument("--input", required=True)
    init.add_argument("--materials", required=True)
    init.add_argument("--amount-currency", required=True)
    init.add_argument("--amount-unit", required=True)
    init.add_argument("--amount-scale-to-currency", required=True, type=float)
    init.add_argument("--output", required=True)

    row = commands.add_parser("upsert-row")
    row.add_argument("--facts", required=True)
    row.add_argument("--row-id", required=True)
    row.add_argument("--statement", required=True, choices=["income", "balance", "cashflow", "equity", "note"])
    row.add_argument("--period-role", required=True, choices=["current", "begin"])
    row.add_argument("--reported-item", required=True)
    row.add_argument("--amount", required=True, type=float)
    row.add_argument("--reporting-date", required=True)
    row.add_argument("--source-id", required=True, action="append")
    row.add_argument("--locator", required=True)
    row.add_argument(
        "--measurement",
        choices=["exact", "approximate"],
        default="exact",
        help="Use approximate only when the filing itself labels the amount as approximate or rounded.",
    )
    row.add_argument("--target", required=True)
    row.add_argument("--exclusion-reason")
    row.add_argument("--source-line", type=int)
    row.add_argument("--source-line-end", type=int)

    remove = commands.add_parser("remove-row")
    remove.add_argument("--facts", required=True)
    remove.add_argument("--row-id", required=True)

    mapping = commands.add_parser("set-mapping")
    mapping.add_argument("--facts", required=True)
    mapping.add_argument("--row-id", required=True)
    mapping.add_argument("--target", required=True)
    mapping.add_argument("--exclusion-reason")

    conflict = commands.add_parser("add-conflict")
    conflict.add_argument("--facts", required=True)
    conflict.add_argument("--conflict-json", required=True)

    compile_cmd = commands.add_parser("compile")
    compile_cmd.add_argument("--facts", required=True)
    validate = commands.add_parser("validate")
    validate.add_argument("--facts", required=True)
    commands.add_parser("list-targets")
    return root


def main() -> int:
    args = parser().parse_args()
    try:
        if args.command == "init":
            output = Path(args.output)
            if output.exists():
                raise ValueError(f"refusing to overwrite {output}")
            write(output, init_payload(args))
        elif args.command == "upsert-row":
            upsert_row(args)
        elif args.command == "remove-row":
            remove_row(args)
        elif args.command == "set-mapping":
            set_mapping(args)
        elif args.command == "add-conflict":
            add_conflict(args)
        elif args.command == "compile":
            path = Path(args.facts)
            write(path, recompile(load(path)))
        elif args.command == "list-targets":
            print("\n".join(["memo", *sorted(TARGETS)]))
            return 0
        else:
            errors = validate_payload(load(Path(args.facts)))
            print(json.dumps({"status": "ok" if not errors else "error", "errors": errors}, ensure_ascii=False, indent=2))
            return 0 if not errors else 1
    except (KeyError, OSError, ValueError, json.JSONDecodeError) as exc:
        print(json.dumps({"status": "error", "errors": [str(exc)]}, ensure_ascii=False, indent=2))
        return 1
    print(json.dumps({"status": "ok", "errors": []}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

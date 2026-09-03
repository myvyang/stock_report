# Session Record: Recovered rebase conflict variants

- Time: 2026-08-03T16:54:05+08:00 Asia/Shanghai
- Window: previous record to 2026-08-03T16:54:05+08:00
- Previous Record: `.agent/records/2026-07-17T14-42-15+08-00-bootstrap-project-context.md`
- Commit: pending
- Branch: master
- Task: Inspect local rebase-conflict backup files and preserve useful stock report variants without overwriting main analysis outputs.
- Source Sessions:
  - Harness: Codex
  - Evidence: current conversation, backup directory, `origin/master`, project docs
  - Checked: `README.md`, `AGENTS.md`, `docs/data-model.md`, `project-memory/index.md`, `project-memory/status/current.md`
  - Used: `/Users/haha/aicode/stock_report_backups/rebase-conflicts-20260803-164224`
  - Unavailable: none

## Outcome

Inspected 479 backup files against `origin/master`. 437 files were byte-identical and skipped. The 42 differing files were preserved under `data/recovered/rebase-conflicts-20260803-164224/files/`, with `data/recovered/rebase-conflicts-20260803-164224/index.md` documenting affected companies, file list, and merge recommendations.

## Engineering Context

The backup differences are concentrated in `000726.SZ/2025-12-31`, `00637.HK/2024-12-31`, `00743.HK/2024-12-31`, `00811.HK/2023-12-31`, `00811.HK/2024-12-31`, and `08436.HK/2024-12-31`.

The files should not be batch-overwritten into canonical `data/analysis/` or `data/normalized/`: `000726.SZ` likely contains a newer user-approved discount policy, while `00743.HK` and `00811.HK` contain mixed local/remote improvements and material historical market-cap differences.

## Open Questions And Risks

Canonical merge should be done company by company. `00811.HK` needs historical market-cap, ex-dividend/reinvestment, and FX assumptions rechecked before replacing owner_earnback outputs.

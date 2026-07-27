# Session Record: Two annual review samples

- Time: 2026-07-17T20:02:42+08:00 Asia/Shanghai
- Window: 2026-07-17T19:06:25+08:00 to 2026-07-17T20:02:42+08:00
- Previous Record: `.agent/records/2026-07-17T19-06-25+08-00-default-annual-basis.md`
- Commit: pending commit
- Branch: main
- Task: run two companies using the default annual report basis.
- Source Sessions: current Codex conversation; local agent outputs and test output checked.

## Outcome

- Ran `PYTHONPATH=src python3 -m stock_report.asset_review_agent --root /Users/haha/aicode/stock_report --code 600132.SH --code 603444.SH --workers 2 --timeout 3600`.
- Because no `--period` was passed, both runs used the default `2025-12-31` annual basis.
- Generated reviewed outputs:
  - `data/analysis/asset_structure/600132.SH/2025-12-31-reviewed.json`
  - `data/analysis/asset_structure/600132.SH/2025-12-31-reviewed.md`
  - `data/analysis/asset_structure/603444.SH/2025-12-31-reviewed.json`
  - `data/analysis/asset_structure/603444.SH/2025-12-31-reviewed.md`
- Both runs returned `status=reviewed`.
- Verified asset/liability reconciliation, non-empty `business_substance`, income core, cash flow core, and gross profit formulas.
- Ran `PYTHONPATH=src python3 -m unittest discover -s tests`; result passed.

## Files And Context Read

- `data/raw/filings/600132.SH/2025-12-31/annual-report.pdf`
- `data/analysis/annual_review/600132.SH/2025-12-31/result.json`
- `data/raw/filings/603444.SH/2025-12-31/annual-report.pdf`
- `data/analysis/annual_review/603444.SH/2025-12-31/result.json`
- `data/analysis/asset_structure/600132.SH/2025-12-31-reviewed.md`
- `data/analysis/asset_structure/603444.SH/2025-12-31-reviewed.md`

## Engineering Facts Learned

- 重庆啤酒 annual-basis output includes a material `其他` row because other net assets are about 42% of consolidated equity, mainly goodwill and deferred tax assets net of provisions and deferred income.
- 吉比特 annual-basis output shows negative net operating assets because player充值/未摊销道具余额、薪酬和税费等经营负债 exceed operating assets.
- The agent produced correct annual data but used generic `本期/同比期` table headers initially; prompt was tightened and both reports were manually normalized to `2025 / 2024`.

## Mistakes And Corrections

- Corrected Markdown table headers to actual period labels and added top-level report titles for both outputs.

## Project Memory Candidates

- For annual reports, profit and cash flow tables should use year labels such as `2025 / 2024`, not generic `本期 / 同比期`.

## Open Questions And Risks

- Need user review of annual-basis sample wording before running the full ROIC Top50.

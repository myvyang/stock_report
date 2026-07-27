# Session Record: Default annual report basis

- Time: 2026-07-17T19:06:25+08:00 Asia/Shanghai
- Window: 2026-07-17T18:59:11+08:00 to 2026-07-17T19:06:25+08:00
- Previous Record: `.agent/records/2026-07-17T18-59-11+08-00-income-cash-flow-core.md`
- Commit: pending commit
- Branch: main
- Task: change the asset review agent default from latest quarter to annual report data.
- Source Sessions: current Codex conversation; local prompt, runner, docs and test output checked.

## Outcome

- Changed `src/stock_report/asset_review_agent.py` default period to `2025-12-31`.
- Added `analysis_basis` to generated `input.json`: `annual` for default annual period, `quarterly` for explicit quarterly periods.
- In annual mode, runner no longer requires quarterly preliminary JSON, quarterly statement JSON, or quarterly PDF.
- Updated `agent_scenarios/asset_structure_review/prompts/main.md`, `system-prompt.md`, `scenario.json`, README and data model so default analysis uses the latest annual report.
- Kept explicit quarterly mode available via `--period 2026-03-31`.
- Ran unit tests and verified the default annual filing and annual review paths exist for a sample company.

## Files And Context Read

- `src/stock_report/asset_review_agent.py`
- `agent_scenarios/asset_structure_review/prompts/main.md`
- `agent_scenarios/asset_structure_review/system-prompt.md`
- `agent_scenarios/asset_structure_review/scenario.json`
- `README.md`
- `docs/data-model.md`
- `project-memory/status/current.md`

## Engineering Facts Learned

- `data/raw/statements/` currently contains 2026Q1 balance-sheet JSON files, not 2025 annual statement JSON files.
- Annual default must therefore rely on annual PDF extraction plus `data/analysis/annual_review/<code>/2025-12-31/result.json`.

## Mistakes And Corrections

- Initial grep found lingering “latest quarter” wording in the system prompt and scenario description; those were updated to annual default with quarterly mode as an exception.

## Project Memory Candidates

- Default review basis is annual report data; quarterly review is an explicit mode.

## Open Questions And Risks

- A real annual-mode agent run should be sampled next to confirm PDF extraction and report wording work end to end under the new default.

# Session Record: Income and cash flow core tables

- Time: 2026-07-17T18:59:11+08:00 Asia/Shanghai
- Window: 2026-07-17T18:34:06+08:00 to 2026-07-17T18:59:11+08:00
- Previous Record: `.agent/records/2026-07-17T18-34-06+08-00-report-display-contract.md`
- Commit: pending commit
- Branch: main
- Task: add profit and cash flow core tables to the asset structure review agent and run one new company.
- Source Sessions: current Codex conversation; local prompt, runner, docs, sample report and test output checked.

## Outcome

- Extended `agent_scenarios/asset_structure_review/system-prompt.md` with `income_core` and `cash_flow_core` JSON sections.
- Updated `prompts/main.md` so the agent reads quarterly PDF consolidated income statement and cash flow statement, not only the balance sheet.
- Added runner validation for `income_core`, `cash_flow_core`, and gross profit formula checks.
- Updated README and `docs/data-model.md` with the three-table Markdown contract.
- Ran `688188.SH` 柏楚电子 through the updated agent; result status was `reviewed`.
- Generated `data/analysis/asset_structure/688188.SH/2026-03-31-reviewed.json` and `.md`.
- Verified gross profit formulas, cash-flow core fields, business-substance fields, and unit tests.

## Files And Context Read

- `agent_scenarios/asset_structure_review/system-prompt.md`
- `agent_scenarios/asset_structure_review/prompts/main.md`
- `src/stock_report/asset_review_agent.py`
- `README.md`
- `docs/data-model.md`
- `data/analysis/asset_structure/688188.SH/2026-03-31-reviewed.json`
- `data/analysis/asset_structure/688188.SH/2026-03-31-reviewed.md`

## Engineering Facts Learned

- 柏楚电子 2026Q1 reviewed output includes: funds assets 55.83 亿元, financing liabilities 0.12 亿元, operating assets 11.40 亿元, operating liabilities 3.71 亿元, investment assets 0.14 亿元.
- 柏楚电子 profit core: 2026Q1 revenue 5.48 亿元, gross profit 4.08 亿元, parent net profit 3.16 亿元.
- 柏楚电子 cash-flow core: operating cash flow 1.74 亿元, investing cash flow 3.04 亿元, financing cash flow -0.01 亿元, cash and equivalents net increase 4.78 亿元.
- The initial agent Markdown produced the right tables but missed section headings; the prompt and sample report were tightened to require fixed headings and unit lines.

## Mistakes And Corrections

- Corrected the display contract after observing the first new run lacked `资产负债结构 / 利润核心 / 现金流核心` headings.

## Project Memory Candidates

- Promote the three-table report contract and the hidden `operating_cost` gross-profit validation rule into durable project memory.

## Open Questions And Risks

- Future batch runs should be sampled for whether the agent consistently uses adjusted comparison periods when companies have restatements or correction announcements.

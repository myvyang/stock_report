# Session Record: User Stock Evaluations

- Time: 2026-07-23T20:50:30+08:00
- Window: after `/Users/haha/aicode/stock_report/.agent/records/2026-07-23T16-19-00+08-00-hk-owner-earnback-notes-brief-style.md` to 2026-07-23T20:50:30+08:00
- Previous Record: `/Users/haha/aicode/stock_report/.agent/records/2026-07-23T16-19-00+08-00-hk-owner-earnback-notes-brief-style.md`
- Commit: pending commit
- Branch: master
- Task: 新增一个专门记录用户对个股人工评价的文件，并记录江苏国泰、富维股份的风险判断。
- Source Sessions: Harness: Codex; Harness Evidence: runtime/developer context and Codex tool namespace; Session Sources Checked: current conversation, project entry docs, git status; Session Sources Used: current conversation and project docs; Unavailable Sources: bounded historical Codex session logs were not read because current task scope was fully covered by current conversation and project-local docs.

## Outcome

新增 `data/notes/user_stock_evaluations.md`，用于记录用户对个股的主观评价、风险标签和更新时间。

已记录：

- `002091.SZ` 江苏国泰：利润率低，大规模亏损概率大，风险高。
- `600742.SH` 富维股份：业务竞争激烈，可能转盈为亏。
- `00799.HK` IGG：游戏公司，赚钱高波动。
- `00837.HK` 谭木匠：作为 `investment_insight` 中的价值股例子，记录为 PE 较低、账上有较多高质量现金、每年稳定产生利润。

## Files And Context Read

- `README.md`
- `AGENTS.md`
- `docs/data-model.md`
- `project-memory/index.md`
- `project-memory/status/current.md`
- `data/notes/user_stock_evaluations.md`

## Engineering Facts Learned

- 用户希望把人工股票评价单独沉淀，供后续筛选、排序和个股简评复用。
- 这类评价不属于财报原始事实或 agent 自动抽取结果，应与 `annual_review`、`owner_earnback` 等自动分析产物分层保存。
- 历史港股赚钱榜备注中已有 `00799.HK IGG` 的人工备注，可合并到统一人工评价表。
- `investment_insight` skill 中已有 `00837.HK 谭木匠` 作为价值股例子，可作为人工风格标签记录，但不等同于新一轮财报复核结论。

## Mistakes And Corrections

无。

## Project Memory Candidates

- 可在后续项目对齐时考虑记录：`data/notes/user_stock_evaluations.md` 是用户人工评价的专门文件，后续输出公司简评或榜单时可读取作为人工备注。

## Open Questions And Risks

- 当前文件只记录人工评价文本和风险标签，尚未接入自动榜单输出流程。

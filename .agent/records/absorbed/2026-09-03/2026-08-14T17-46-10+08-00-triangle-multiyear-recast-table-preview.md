# Session Record: Triangle multi-year recast table preview

- Time: 2026-08-14T17:46:10+08:00 Asia/Shanghai
- Window: 2026-08-03T19:15:29+08:00 to 2026-08-14T17:46:10+08:00
- Previous Record: `.agent/records/2026-08-03T19-15-29+08-00-embodied-product-tree-root-node.md`
- Commit: pending
- Branch: `codex/triangle-multiyear-report`
- Task: 先直接调整三角轮胎深度研究报告的三表格式，待用户确认后再修改股票研究 bundle。
- Source Sessions:
  - Harness: Codex
  - Evidence: current conversation and the published v7 research result
  - Checked: `report.md`, `longitudinal-history.json`, and 2016—2025 annual `recast-statements.json`
  - Used: published 2016—2025 continuous recast ledger
  - Unavailable: none

## Outcome

- 保留2025年折算表1业务切片。
- 将折算表2改为2016—2025年各年末经济资产负债长表，将折算表3改为同期年度资金变化长表。
- 删除三表之后没有章节归属的评价性引言，使三表章节只保留表及必要的数据边界说明。
- 2016年为连续账本起点，缺少2015年同口径期初，因此不展示2016年权益变化和经济净资产增加；完整年度桥从2017年开始。

## Engineering Context

本轮只验证人读报告格式，不修改结构化结果、折算底稿、连续账本、Agent Definition或bundle。用户确认版式后，再把annual/deep展示分流沉淀到正式渲染器和协议。

## Open Questions And Risks

- 多年表采用“项目为行、年份为列”的横向宽表；需由用户确认Git Web中的实际阅读体验。
- 当前报告不再等于旧bundle生成的单年标准三表，正式化前不能把本轮手工版式当成Runner可复现产物。

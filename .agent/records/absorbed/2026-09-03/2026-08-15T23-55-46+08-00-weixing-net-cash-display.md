# Session Record: 伟星折算表净额阅读展示

- Time: 2026-08-15T23:55:46+08:00
- Window: 2026-08-14T17:46:10+08:00 exclusive to 2026-08-15T23:55:46+08:00 inclusive
- Previous Record: `.agent/records/2026-08-14T17-46-10+08-00-triangle-multiyear-recast-table-preview.md`
- Commit: pending
- Branch: master
- Task: 不重跑伟星研究，手工把已发布报告中的同本金反向流量改为净额展示。
- Source Sessions:
  - Harness: Codex
  - Evidence: 当前共享对话、伟星正式版本报告及其折算三表原始金额
  - Checked: `data/analysis/stock_research/002003.SZ/2025-12-31/report.md`及绑定版本报告
  - Used: 借还款、投资本金收付、经营资产购置处置和保证金收付按同一本金账户净额展示
  - Unavailable: none

## Outcome

正式版本和最新便利视图同步改为净额阅读展示：经营资产净转化8.4亿元、经营资产净现金投入8.7亿元、对外投资净回收0.51亿元、保证金净支付0.02亿元、借款净现金流入2.2亿元。投资收益舍入为0的动态行已移除；利息、分红和股东投入仍独立列示。底层结构化原子事实未改动。

## Engineering Context

本次只修改已发布Markdown，不重跑伟星，也不改分析版本或结构化数据。以后同类展示由`stock_analysis`报告渲染器确定性生成。

## Open Questions And Risks

none

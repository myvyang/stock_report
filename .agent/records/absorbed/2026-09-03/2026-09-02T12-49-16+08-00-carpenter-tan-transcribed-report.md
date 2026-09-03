# Session Record: 谭木匠报告收敛为转写表

- Time: 2026-09-02T12:49:16+08:00
- Window: 2026-09-02T12:33:00+08:00 to 2026-09-02T12:49:16+08:00
- Previous Record: none found in current remote master
- Commit: pending
- Branch: edit/carpenter-tan-transcribed-report
- Task: 先手工收敛谭木匠正式报告，供用户确认后再修改研究 Bundle。
- Source Sessions:
  - Harness: Codex
  - Evidence: 当前用户对正式报告展示内容的逐项确认
  - Checked: 谭木匠正式报告、stock_report入口文档和项目状态
  - Used: 当前对话与已发布报告`bf4274d347f10a6f9af1c98595b9e9a1ea5e7a76`
  - Unavailable: none

## Outcome

正式报告删除折算三表、五表固定命名、通用公式、原始字段映射、闭合校验表和Sol自审清单，改为按需增减的“转写表”。当前保留经营与自由现金流、经营资本与回报、普通股价值三张核心表，以及存在重大事项时才展示的重大调整表。归母净利润与净资产作为财报口径对照数保留。正文删除Agent模式、底稿和折算流程等内部生产信息。

## Engineering Context

机器审计所需的原始事实、字段映射、公式、闭合结果和自审仍应留在内部结构化产物，不进入投资者阅读报告。当前仅手工修改已发布报告，研究Bundle尚未同步，后续生成可能覆盖本次版式。

## Open Questions And Risks

等待用户确认当前报告展示是否符合预期；确认后再修改`stock_analysis`中的报告协议、渲染器和门禁。

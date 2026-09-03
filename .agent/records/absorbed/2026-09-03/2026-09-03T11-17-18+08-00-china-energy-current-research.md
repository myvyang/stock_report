# Session Record: 中国能建当前研究报告

- Time: 2026-09-03T11:17:18+08:00
- Window: 2026-09-03T10:50:00+08:00 to 2026-09-03T11:17:18+08:00
- Previous Record: `.agent/records/2026-09-02T18-33-22+08-00-three-current-reports.md`
- Commit: pending
- Branch: detached worktree from `origin/master`
- Task: 使用当前公司研究 Agent 完成中国能建 2025 年度研究，并进入 AH Note 发布链路。
- Source Sessions:
  - Harness: Codex
  - Evidence: 当前对话、公司研究 Bundle、2025 年年度报告、2026 年半年度报告及股本变动公告
  - Checked: 结构化模型、转写表、公开报告、价值桥、来源链接和程序校验结果
  - Used: 公司研究 Agent 正式产出的 `report.md` 与 `result.json`
  - Unavailable: 主要非全资项目公司的逐项经济价值、维持性与成长性资本开支的公司口径拆分

## Outcome

新增中国能建 `601868.SH` 的 2025 年度当前协议报告和 `stock-research-analysis-v2` 结构化结果。报告使用 2026 年半年报更新现金、债务、少数股东权益和优先索偿，并使用 2026 年 4 月定增后的总股本。

程序校验通过，实际 FCFF 的利润路径与现金流路径均为 -248.32 亿元；固定七倍标尺下普通股剩余价值为负。报告已明确该结果表示当前正常 FCFF 不足以覆盖债务和优先索偿，并非负股价预测。

## Engineering Context

本次只提升公司研究 Agent 的正式产物，没有修改研究 Bundle、旧流程或 `stock_report` 运行代码。AH Note 由当前协议的结构化结果和报告正文自动生成公开页面。

## Open Questions And Risks

少数股东价值暂用账面权益、经营必需现金为研究估计、维持性资本开支暂按折旧摊销；这三项会显著影响普通股价值桥。中国能建仍处运营资产扩张期，后续最重要的验证是投产资产回报、资本开支回落和债务增速是否形成闭环。

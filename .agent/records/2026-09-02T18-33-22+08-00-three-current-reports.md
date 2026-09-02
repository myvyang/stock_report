# Session Record: 三家公司切换到当前报告协议

- Time: 2026-09-02T18:33:22+08:00
- Window: 2026-09-02T15:27:00+08:00 to 2026-09-02T18:33:22+08:00
- Previous Record: `.agent/records/2026-09-02T15-27-00+08-00-ninebot-benchmark-equity-value.md`
- Commit: pending
- Branch: detached worktree from `origin/master`
- Task: 使谭木匠、九号公司和拼多多均可通过 AH Note 当前默认链路发布。
- Source Sessions:
  - Harness: Codex
  - Evidence: 当前对话、既有公司报告、当前公司研究 Bundle 结构化模型及验证程序
  - Checked: 三家公司正式报告、`result.json`、AH Note 当前协议准入规则
  - Used: 谭木匠既有理想表与正式报告；九号公司已验证候选模型；拼多多既有当前模型
  - Unavailable: none

## Outcome

谭木匠结构化结果迁移到 `stock-research-analysis-v2`，沿用已完成研究中的实际经营、稳定状态、投入资本和普通股价值口径，并通过当前模型校验。九号公司将新版候选报告和模型提升为正式文件；阅读表把 233% ROIC 明确标记为不可靠的公式结果，避免把接近零且高度依赖分类假设的分母解释为竞争优势。拼多多当前模型保持不变。

三家公司均通过当前协议校验、报告公开链接检查和 AH Note 发布准入检查。

## Engineering Context

AH Note 只把五项自审通过且关键计算字段完整的 `stock-research-analysis-v2` 结果作为当前协议报告。正式发布因此依赖规范化 `result.json`，不能只替换 Markdown 正文。

## Open Questions And Risks

谭木匠的稳定期参数和沉淀资金可达折扣属于研究估计；九号公司的 ROIC 公式值保留在底层模型，但不适合用于跨公司比较。

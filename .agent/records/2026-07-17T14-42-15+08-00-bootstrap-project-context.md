# Session Record: Bootstrap project context before project alignment

- Time: 2026-07-17T14:42:15+08:00 Asia/Shanghai
- Window: current repository creation to 2026-07-17T14:42:15+08:00 inclusive
- Previous Record: none
- Commit: pending commit
- Branch: `master`
- Task: 初始化 `stock_report`，用于保存 ROIC Top50 的官方原始财报、结构化报表和资金类/经营类资产分析数据
- Source Sessions: Harness: Codex Desktop；Harness Evidence: 当前运行上下文提供 Codex 工具与 workspace；Session Sources Checked: 当前对话、空仓库状态、`stock_analysis` 项目财报分析规则和 ROIC Top50 产物；Session Sources Used: 当前用户需求、`stock_analysis/.agents/skills/financial-report-analysis/references/item-dictionary-and-formulas.md`、现有 Top50 年报缓存统计；Unavailable Sources: 新仓库此前为空且没有同项目历史 session，未读取 Codex 历史日志

## Outcome

建立项目入口、数据模型、项目记忆入口、依赖和 Git LFS PDF 规则。确定最新资产分析采用“最新季报金额 + 最近年报附注”的双报告证据，并使用以下勾稽：

```text
总资产 = 资金类资产 + 经营类资产 + 投资类资产 + 其他资产
```

## Files And Context Read

- `stock_analysis/AGENTS.md`
- `stock_analysis/README.md`
- `stock_analysis/.agents/skills/financial-report-analysis/SKILL.md`
- `stock_analysis/.agents/skills/financial-report-analysis/references/item-dictionary-and-formulas.md`
- `stock_analysis/src/stock_analysis/interfaces/cli/a_share_roic_screen.py`
- `stock_analysis/data/outputs/a_share_screens/2026-07-15_A股ROIC_LLM核对_top50_v3_gpt55.csv`
- `stock_analysis/data/outputs/roic_verification_source_cache/annual_reports/`

## Engineering Facts Learned

- 来源项目已经缓存50份2025年报 PDF，合计约142MB，单文件最大约23MB。
- 本机安装 Git LFS，可用于版本化管理 PDF。
- 最新季报主表可从东方财富完整资产负债表接口获取；官方报告 PDF 由巨潮资讯保存。
- 2026Q1 缺少完整附注，因此不能仅凭季报科目名称判断定期存款、理财和战略投资性质。

## Mistakes And Corrections

- 无。目标 GitHub 仓库克隆后确认是空仓库，因此按新项目初始化，而不是迁移未知旧结构。

## Project Memory Candidates

- 双报告证据规则。
- 四类资产勾稽和不确定项目不强行分类原则。
- 原始 PDF、原始 JSON、标准化事实、分析结果必须分层保存。

## Open Questions And Risks

- 尚未实现抓取和分类流水线。
- 资金类资产中定期存款、受限资金和经营套保工具需要年报附注或 agent 判断，不能只靠固定字段映射。
- GitHub LFS 配额需要在批量推送前观察；预计首批年度报告和季报总量约200–300MB。

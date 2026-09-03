# 港股控股回本备注清单与讲解模板

时间：2026-07-23T16:19:00+08:00

## 背景

用户希望为港股控股回本赚钱榜逐只增加人工备注，并认为 IGG 的解释方式适合作为后续公司讲解参考。

## 本次新增

- 新增备注清单：
  - `data/outputs/hk_owner_earnback_notes/2025-profit-cheap-notes.md`
  - 基于 2025 top250 agent 部分完成快照，当前为已完成 `63/250` 中的 `profit_cheap` 42 家。
  - 表格保留横向可比较字段：回本年、PE、市值、折后净现金、经营价、折后现金利润、市值/现金利润和备注。
  - `00799.HK IGG` 备注已按用户要求预填为“游戏公司，赚钱高波动”。
- 新增讲解模板：
  - `docs/hk-owner-earnback-company-brief-style.md`
  - 固化“业务是什么、为什么进榜、关键风险是什么”的讲解顺序。
  - 收录 IGG 示例，作为后续讲解其他公司的参考风格。

## 后续

等 2025 top250 agent 全部跑完后，需要用完整结果刷新备注清单。

## Follow-up 2026-07-23T16:35:00+08:00

- 用户指出前 10 公司解释过于简单，未达到 IGG 示例那种“有数据、有说法”的密度。
- 已新增详细版前 10 brief：
  - `data/outputs/hk_owner_earnback_notes/2025-profit-cheap-top10-briefs.md`
  - 每家公司按固定结构写：业务收入拆分、控股回本核心数、为什么进榜、现金折扣逻辑、利润折扣逻辑、关键风险和简短备注。
- 已同步该文件到远端 `/root/aicode/stock_report/data/outputs/hk_owner_earnback_notes/2025-profit-cheap-top10-briefs.md`。

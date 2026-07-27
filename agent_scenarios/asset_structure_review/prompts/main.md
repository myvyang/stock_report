读取 `config/input.json` 指向的本地材料，完成本次公司的经营与资产负债结构复核。默认使用最近年报口径：资产负债表使用年末合并资产负债表，利润核心和现金流核心使用全年合并利润表、合并现金流量表；同比期使用上一年年报数据。

先读取 `annual_review` 中的 evidence，再用 `pdftotext -layout` 或 Python `pypdf` 定向读取本地年报 PDF 核对三张表和附注；不要联网重复下载。

先读取 `price_skill`，并运行其中的 `fetch_a_share_price.py` 获取当前股价。将脚本 JSON 输出保存到 `work/market_price.json`，并复制核心字段到 `outputs/result.json` 的 `market_price`。报告标题下方必须展示当前股价、行情时间和来源。

只有当 `input.json` 的 `analysis_basis` 为 `quarterly` 时，才读取季度初拆 JSON 和季度 PDF，并用最近年报附注判断最新季报中的混合科目。季度模式下，利润核心和现金流核心来自季度 PDF 中的合并利润表、合并现金流量表及同比期数据。

毛利用营业收入减营业成本计算。若年报、季度报告或更正公告说明同比期为调整后口径，必须使用调整后数据并在 `source_note` 和 report 中说明。

最终只能写入本次 run_dir 的 `outputs/` 和 `work/`。必须生成并重新读取确认：

- `outputs/result.json`
- `outputs/report.md`
- `outputs/trace.txt`

`report.md` 用简洁中文先列三张核心表：资产负债结构、利润核心、现金流核心；每张表后只解释重要和非常规项目。重点讲清楚这家公司靠什么产生收入和毛利、利润是否转成现金、现金流最后体现为哪些资产和负债变化，不给买卖建议。

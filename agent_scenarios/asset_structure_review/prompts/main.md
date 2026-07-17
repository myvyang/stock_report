读取 `config/input.json` 指向的本地材料，完成本次公司的资产性质复核。不要仅复述机械初拆；必须用最近年报附注判断最新季报中的混合科目，并把判断应用到最新季报余额。

先读取季度初拆 JSON，再读取既有年报核对结果中的 evidence。金额重大、证据仍不足时，用 `pdftotext -layout` 或 Python `pypdf` 定向读取本地年报 PDF；不要联网重复下载。季度 PDF 只用来交叉核对最新主表余额。

最终只能写入本次 run_dir 的 `outputs/` 和 `work/`。必须生成并重新读取确认：

- `outputs/result.json`
- `outputs/report.md`
- `outputs/trace.txt`

`report.md` 用简洁中文说明公司最新总资产、资金类资产、经营类资产、投资类资产、其他资产，各自主要构成和仍存疑点。重点解释资金类与经营类资产，不给买卖建议。

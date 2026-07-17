# Stock Report

面向上市公司财报研究的数据仓库。项目保存官方原始财报、结构化原始报表、标准化事实和可复核分析结果，首个研究对象是 `stock_analysis` 产出的 A 股 ROIC Top50。

## 当前目标

对每家公司同时使用：

- 最新季度报告：提供最新资产负债表金额；
- 最近年度报告：提供完整附注，用于判断定期存款、理财、战略投资、商誉等资产性质。

核心勾稽关系：

```text
总资产 = 资金类资产 + 经营类资产 + 投资类资产 + 其他资产
```

- 资金类资产：现金、现金等价物、可剥离存款和金融投资，不依赖主业继续经营即可变现。
- 经营类资产：应收、存货、合同资产、厂房设备、在建工程、使用权资产、无形资产等，与主业规模和盈利能力直接相关。
- 投资类资产：长期股权投资、战略股权、投资性房地产等，既非现金等价物，也不直接属于核心经营循环。
- 其他资产：商誉、递延所得税资产、待售资产和暂时无法可靠归类的项目。

不确定项目不强行分类。金额重要时保留原始科目、分类依据、替代口径和复核状态。

## 数据目录

```text
data/
├── universe/                         # 研究股票池及来源
├── raw/
│   ├── filings/<code>/<period>/      # 官方 PDF 与元数据
│   └── statements/<code>/<period>/   # 数据接口原始 JSON
├── normalized/facts/                 # 标准化报表事实
├── analysis/asset_structure/         # 单家公司资产分类结果
└── outputs/                          # Top50 汇总表和报告
```

PDF 使用 Git LFS 管理；原始 JSON 和分析 JSON 直接进入 Git。生成型 SQLite、缓存和运行日志不提交。

## 分析原则

1. 原始披露与加工结果分开保存。
2. 每个加工值保留来源报告、原始字段和分类依据。
3. 父项、子项同时保存，并运行总资产勾稽。
4. 最新季报缺少附注时，引用最近年报附注，但明确标记“沿用年报分类”。
5. 资金类资产和经营类资产是主表；投资类和其他类金额超过总资产 10% 时必须单独解释。

详细数据契约见 [docs/data-model.md](docs/data-model.md)。

## 运行

```bash
python -m venv .venv
.venv/bin/pip install -e .

stock-report import-universe /path/to/roic_top50.csv
stock-report import-annual /path/to/annual_reports
stock-report run-latest --year 2026 --code 002315.SZ
stock-report run-latest --year 2026
```

`run-latest` 会从巨潮资讯保存官方季度 PDF，从东方财富结构化接口保存未经改名的资产负债表响应，随后生成标准化事实、逐项目分类及汇总 CSV。季度主表没有附注依据的混合项目会留在“其他资产”，等待年报附注复核。

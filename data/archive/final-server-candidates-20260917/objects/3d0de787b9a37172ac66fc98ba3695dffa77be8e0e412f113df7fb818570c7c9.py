import json
from datetime import datetime
from pathlib import Path


RUN_DIR = Path("/Users/haha/aicode/stock_report/data/agent_runs/asset_structure_review/2026-07-19T11-59-46+08-00-300394-sz-天孚通信")
OUT_DIR = RUN_DIR / "outputs"
WORK_DIR = RUN_DIR / "work"
ANNUAL_PDF = "/Users/haha/aicode/stock_report/data/raw/filings/300394.SZ/2025-12-31/annual-report.pdf"
ANNUAL_REVIEW = "/Users/haha/aicode/stock_report/data/analysis/annual_review/300394.SZ/2025-12-31/result.json"


def item(source_field, item_name, amount, category, business_substance, basis, annual_evidence, method="direct", confidence="high"):
    return {
        "source_field": source_field,
        "item_name": item_name,
        "amount": round(amount, 2),
        "category": category,
        "business_substance": business_substance,
        "basis": basis,
        "annual_evidence": annual_evidence,
        "evidence_period": "2025-12-31",
        "method": method,
        "confidence": confidence,
    }


def liability_item(source_field, item_name, amount, category, business_substance, basis, annual_evidence, method="direct", confidence="high"):
    return {
        "source_field": source_field,
        "item_name": item_name,
        "amount": round(amount, 2),
        "category": category,
        "business_substance": business_substance,
        "basis": basis,
        "annual_evidence": annual_evidence,
        "evidence_period": "2025-12-31",
        "method": method,
        "confidence": confidence,
    }


items = [
    item("货币资金/现金和现金等价物构成", "可随时支付的现金及银行存款", 2863743000.22, "funds", "库存现金和可随时用于支付的银行存款，未包含受限其他货币资金。", "不依赖主业继续经营即可支取或保存，按资金类资产列示。", "年报合并资产负债表、附注七、1货币资金、七、78现金和现金等价物构成，PDF页133、180、229；受限货币资金见PDF页209"),
    item("交易性金融资产", "非固定收益性理财产品", 210053444.45, "funds", "银行浮动收益理财产品。", "可剥离金融资产，虽非现金等价物但可独立变现，按资金类资产列示。", "年报附注七、2交易性金融资产、十二、公允价值披露，PDF页180、238"),
    item("货币资金/所有权或使用权受限资产", "保函保证金", 57100000.00, "operating", "履约保函保证金，保证期间内不得支取。", "受限现金不能作为可剥离资金；该保证金与履约经营相关，按经营资产列示。", "年报附注七、31所有权或使用权受到限制的资产、七、77现金流量表项目，PDF页209、226"),
    item("应收票据", "银行承兑票据", 1877651.18, "operating", "客户结算形成的银行承兑汇票。", "销售回款链条中的票据权利，按经营资产列示。", "年报合并资产负债表及附注七、4应收票据，PDF页133、181"),
    item("应收账款", "客户货款应收账款", 1121985328.51, "operating", "已交付光通信元器件后尚未收回的客户货款。", "销售履约形成的经营性应收，按经营资产列示。", "年报合并资产负债表及附注七、5应收账款，PDF页133、182-184"),
    item("应收款项融资", "银行承兑汇票", 16802959.69, "operating", "以公允价值计量的银行承兑汇票，可背书或贴现。", "由销售结算形成，不作为可剥离资金池，按经营资产列示。", "年报合并资产负债表及附注七、7应收款项融资，PDF页133、185-186"),
    item("预付款项", "预付供应商款", 20774384.67, "operating", "向供应商预付的采购款，98.44%账龄在1年以内。", "采购循环形成的预付款，按经营资产列示。", "年报合并资产负债表及附注七、9预付款项，PDF页133、192"),
    item("其他应收款", "押金保证金、代收代付和员工备用金等", 1687322.88, "operating", "其他应收款账面价值，账面余额主要为押金及保证金、代收代付和员工备用金。", "日常经营往来形成，按经营资产列示；附注未逐项给出净额，使用报表账面价值。", "年报合并资产负债表及附注七、8其他应收款，PDF页133、187-190", confidence="medium"),
    item("存货", "原材料、在产品、库存商品和发出商品", 457195929.70, "operating", "光通信元器件生产相关原材料1.77亿元、在产品1.67亿元、库存商品0.83亿元、发出商品0.30亿元。", "生产和交付循环形成，按经营资产列示。", "年报合并资产负债表、会计政策五、17存货、附注七、10存货，PDF页133、172、192-193"),
    item("其他流动资产", "待抵扣进项税", 19430736.53, "operating", "采购和建设投入形成的待抵扣增值税进项税。", "经营采购及投入形成的税费抵扣权，按经营资产列示。", "年报合并资产负债表及附注七、13其他流动资产，PDF页133、194"),
    item("其他流动资产", "预缴所得税及其他税费", 1941979.52, "other", "预缴所得税188.07万元和预缴其他税费6.12万元。", "税务预缴权利不直接处于销售、采购、生产循环，按其他资产列示。", "年报附注七、13其他流动资产，PDF页194"),
    item("长期股权投资", "武汉光谷联营企业股权", 9305210.49, "investment", "对联营企业武汉光谷的权益法长期股权投资。", "战略股权投资，不属于资金等价物或核心经营循环，按投资类资产列示。", "年报合并资产负债表及附注七、18长期股权投资，PDF页133、198"),
    item("固定资产", "厂房建筑物和生产设备等", 1115188623.61, "operating", "期末账面价值主要为房屋建筑物5.79亿元、机器设备4.83亿元、电子设备0.45亿元等。", "用于生产商品和经营管理，按经营资产列示。", "年报合并资产负债表及附注七、21固定资产，PDF页133、199-201"),
    item("在建工程", "待安装验收设备、产业园和泰国厂房等", 202951337.39, "operating", "期末主要为待安装验收设备1.78亿元、江西天孚科技产业园0.24亿元、泰国厂房0.01亿元。", "扩产和经营设施建设形成，按经营资产列示。", "年报合并资产负债表及附注七、22在建工程，PDF页134、201-202"),
    item("使用权资产", "租赁房屋及建筑物", 4005668.21, "operating", "租赁房屋及建筑物使用权。", "经营场地租赁形成的使用权，按经营资产列示。", "年报合并资产负债表及附注七、25使用权资产，PDF页134、203-204"),
    item("无形资产", "土地使用权、专利权和其他软件等", 89803818.13, "operating", "期末账面价值主要为土地使用权0.73亿元、专利权0.05亿元、其他0.11亿元。", "用于生产和经营的土地、技术和软件权利，按经营资产列示。", "年报合并资产负债表及附注七、26无形资产，PDF页134、204-205"),
    item("商誉", "天孚精密和北极光电商誉", 29647573.18, "other", "收购形成的商誉，未计提减值。", "商誉不得归入经营资产，按其他资产列示。", "年报合并资产负债表及附注七、27商誉，PDF页134、206-207"),
    item("长期待摊费用", "厂房装修、固定资产修理、绿化工程和服务费", 9561911.21, "operating", "主要为厂房装修0.06亿元、服务费0.02亿元等待摊支出。", "经营场地和经营服务相关的长期摊销支出，按经营资产列示。", "年报合并资产负债表及附注七、28长期待摊费用，PDF页134、207"),
    item("递延所得税资产", "可抵扣暂时性差异形成的递延所得税资产", 112652527.00, "other", "主要由股价超过授予日价格超额税务抵扣、资产减值准备、股权激励费用等形成。", "税务暂时性差异资产，按其他资产列示。", "年报合并资产负债表及附注七、29递延所得税资产/负债，PDF页134、208"),
    item("其他非流动资产", "预付工程及设备款", 27778263.02, "operating", "预付的工程及设备款。", "对应经营性固定资产建设和设备采购，按经营资产列示。", "年报合并资产负债表及附注七、30其他非流动资产，PDF页134、209"),
    item("货币资金/所有权或使用权受限资产", "临时冻结账户资金", 75814642.47, "other", "因银行关联人证件到期未实时更新导致的账户资金冻结，2026年1月已解冻。", "年末不可自由支取，且冻结原因不属于经营保证金；按其他资产列示。", "年报附注七、31所有权或使用权受到限制的资产，PDF页209", confidence="medium"),
]

liability_items = [
    liability_item("一年内到期的非流动负债", "一年内到期的租赁负债", 1660054.94, "financing", "一年内需支付的租赁本金现值。", "租赁负债为有息融资性质，按融资负债列示。", "年报合并资产负债表及附注七、42一年内到期的非流动负债，PDF页134、214"),
    liability_item("租赁负债", "非流动租赁负债", 2809445.73, "financing", "一年以上应付租赁款现值扣除未确认融资费用。", "租赁负债为有息融资性质，按融资负债列示。", "年报合并资产负债表及附注七、46租赁负债，PDF页135、215"),
    liability_item("应付票据", "银行承兑汇票和信用证", 92549620.49, "operating", "采购和经营结算形成的银行承兑汇票0.90亿元及信用证0.03亿元。", "供应采购循环形成，按经营负债列示。", "年报合并资产负债表及附注七、35应付票据，PDF页134、210"),
    liability_item("应付账款", "经营性应付账款", 268373543.82, "operating", "材料、服务等经营采购形成的未付款。", "经营采购循环形成，按经营负债列示。", "年报合并资产负债表及附注七、36应付账款，PDF页134、211"),
    liability_item("应付账款", "工程性应付账款", 134182213.58, "operating", "经营性厂房、设备建设形成的工程未付款。", "对应经营资产建设，不是有息融资，按经营负债列示。", "年报附注七、36应付账款，PDF页211"),
    liability_item("合同负债", "预收货款", 160561056.09, "operating", "客户先付款后交付形成的商品交付义务。", "销售合同履约循环形成，按经营负债列示。", "年报合并资产负债表及附注七、38合同负债，PDF页134、212"),
    liability_item("应付职工薪酬", "短期薪酬和设定提存计划应付款", 96865770.77, "operating", "应付工资奖金、社保、公积金、工会经费等。", "员工薪酬随经营形成，按经营负债列示。", "年报合并资产负债表及附注七、39应付职工薪酬，PDF页134、212-213"),
    liability_item("应交税费", "增值税、企业所得税及附加税费", 131751986.09, "operating", "主要为企业所得税1.13亿元、增值税0.13亿元及附加税费。", "经营收入和利润形成的纳税义务，按经营负债列示。", "年报合并资产负债表及附注七、40应交税费，PDF页134、213"),
    liability_item("其他应付款", "押金保证金、员工报销款和代收代付款项", 3169557.19, "operating", "经营往来和员工报销形成的小额应付款。", "日常经营往来形成，按经营负债列示。", "年报合并资产负债表及附注七、37其他应付款，PDF页134、211-212"),
    liability_item("其他流动负债", "合同负债相关待转销项税额", 19896700.61, "operating", "预收货款对应的待转销项税额。", "随合同负债和交付义务形成，按经营负债列示。", "年报合并资产负债表及附注七、43其他流动负债，PDF页134、214"),
    liability_item("递延收益", "与资产相关政府补助", 23587150.86, "other", "收到与资产相关的政府补助，后续递延摊入收益。", "政府补助递延收益不属于有息融资或经营采购债务，按其他负债列示。", "年报合并资产负债表及附注七、50递延收益，PDF页135、217"),
    liability_item("递延所得税负债", "应纳税暂时性差异形成的递延所得税负债", 1217089.98, "other", "企业合并资产评估增值、固定资产加速折旧、理财公允价值变动、使用权资产税会差异形成。", "递延所得税负债按其他负债列示。", "年报合并资产负债表及附注七、29递延所得税资产/负债，PDF页135、208"),
]


def ssum(rows, category):
    return round(sum(x["amount"] for x in rows if x["category"] == category), 2)


total_assets = 6449302312.06
total_liabilities = 936624190.15
total_equity = 5512678121.91
parent_equity = 5505983414.22
minority_interest = 6694707.69

funds_assets = ssum(items, "funds")
operating_assets = ssum(items, "operating")
investment_assets = ssum(items, "investment")
other_assets = ssum(items, "other")
financing_liabilities = ssum(liability_items, "financing")
operating_liabilities = ssum(liability_items, "operating")
investment_liabilities = ssum(liability_items, "investment")
other_liabilities = ssum(liability_items, "other")

net_funds = round(funds_assets - financing_liabilities, 2)
net_operating_assets = round(operating_assets - operating_liabilities, 2)
net_investment_assets = round(investment_assets - investment_liabilities, 2)
other_net_assets = round(other_assets - other_liabilities, 2)

income_current = {
    "operating_revenue": 5163432471.16,
    "operating_cost": 2377104884.16,
    "gross_profit": round(5163432471.16 - 2377104884.16, 2),
    "parent_net_profit": 2017266034.08,
}
income_comparison = {
    "operating_revenue": 3251707626.61,
    "operating_cost": 1391184704.84,
    "gross_profit": round(3251707626.61 - 1391184704.84, 2),
    "parent_net_profit": 1343522232.87,
}

market_price = json.loads((WORK_DIR / "market_price.json").read_text(encoding="utf-8"))

result = {
    "company": {"code": "300394.SZ", "name": "天孚通信"},
    "period": "2025-12-31",
    "currency": "CNY",
    "unit": "yuan",
    "classification_version": "asset-structure-agent-v1",
    "status": "reviewed",
    "summary": {
        "total_assets": total_assets,
        "funds_assets": funds_assets,
        "operating_assets": operating_assets,
        "investment_assets": investment_assets,
        "other_assets": other_assets,
        "asset_formula_difference": round(total_assets - (funds_assets + operating_assets + investment_assets + other_assets), 2),
        "total_liabilities": total_liabilities,
        "financing_liabilities": financing_liabilities,
        "operating_liabilities": operating_liabilities,
        "investment_liabilities": investment_liabilities,
        "other_liabilities": other_liabilities,
        "liability_formula_difference": round(total_liabilities - (financing_liabilities + operating_liabilities + investment_liabilities + other_liabilities), 2),
        "total_equity": total_equity,
        "parent_equity": parent_equity,
        "minority_interest": minority_interest,
        "minority_interest_ratio": round(minority_interest / total_equity, 6),
        "net_funds": net_funds,
        "net_operating_assets": net_operating_assets,
        "net_investment_assets": net_investment_assets,
        "other_net_assets": other_net_assets,
        "equity_reconciliation_difference": round(total_equity - (net_funds + net_operating_assets + net_investment_assets + other_net_assets), 2),
        "other_net_assets_ratio_to_equity": round(other_net_assets / total_equity, 6),
        "other_net_assets_immaterial": abs(other_net_assets / total_equity) < 0.05,
    },
    "items": items,
    "liability_items": liability_items,
    "material_judgments": [
        "年报模式：资产负债表、利润核心和现金流核心均采用2025年年报合并主表；附注采用同一年度年报。",
        "货币资金拆分：现金及现金等价物28.64亿元归资金类；保函保证金0.57亿元归经营资产；临时冻结账户资金0.76亿元归其他资产。",
        "应付账款中的工程性应付1.34亿元对应经营性厂房设备建设，归经营负债而非融资负债。",
        "商誉0.30亿元按规则归其他资产，不并入经营资产。",
    ],
    "unresolved_items": [],
    "equity_perspective": {
        "total_equity": total_equity,
        "parent_equity": parent_equity,
        "minority_interest": minority_interest,
        "minority_interest_ratio": round(minority_interest / total_equity, 6),
        "note": "主分析使用合并所有者权益勾稽；少数股东权益占合并权益约0.12%，归母权益为55.06亿元。",
    },
    "income_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": income_current,
        "comparison": income_comparison,
        "gross_profit_formula_difference_current": round(income_current["gross_profit"] - (income_current["operating_revenue"] - income_current["operating_cost"]), 2),
        "gross_profit_formula_difference_comparison": round(income_comparison["gross_profit"] - (income_comparison["operating_revenue"] - income_comparison["operating_cost"]), 2),
        "source_note": "合并利润表及营业收入和营业成本附注，年报PDF页137-138、220；未发现同比期更正或调整说明。",
    },
    "cash_flow_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": {
            "operating_cash_flow_net": 1868203465.93,
            "investing_cash_flow_net": -264523942.17,
            "financing_cash_flow_net": -673129631.29,
            "cash_and_equivalents_net_increase": 885254855.87,
        },
        "comparison": {
            "operating_cash_flow_net": 1262516765.12,
            "investing_cash_flow_net": -357821990.67,
            "financing_cash_flow_net": -781992669.91,
            "cash_and_equivalents_net_increase": 150785879.74,
        },
        "source_note": "合并现金流量表及现金流量表项目附注，年报PDF页141-142、226-229。",
    },
    "market_price": {
        "code": market_price["code"],
        "name": market_price["name"],
        "currency": market_price["currency"],
        "price": market_price["price"],
        "quote_time": market_price["quote_time"],
        "fetched_at": market_price["fetched_at"],
        "source": market_price["source"],
        "source_url": market_price["source_url"],
    },
    "sources": {
        "annual_filing_local_path": ANNUAL_PDF,
        "annual_review_local_path": ANNUAL_REVIEW,
        "annual_filing_url_from_input": "https://static.cninfo.com.cn/finalpage/2026-04-08/1225082705.PDF",
        "price_skill": str(RUN_DIR / "config/skills/a-share-price-fetch/SKILL.md"),
        "market_price_json": str(WORK_DIR / "market_price.json"),
        "pdf_text_extract": str(WORK_DIR / "annual-report.txt"),
    },
    "data_quality": {
        "quarterly_filing_verified": True,
        "annual_filing_verified": True,
        "reconciliation_ok": True,
        "confidence": "high",
        "limitations": [
            "analysis_basis=annual，未使用季度报告；quarterly_filing_verified 在本次年报模式下表示不适用且未触发季度取数。",
            "其他应收款附注按账面余额披露款项性质，但未逐项分配坏账准备；本次按账面价值整体归入经营资产。",
        ],
    },
}


def yi(amount):
    return f"{amount / 100000000:.2f}"


quote_time = market_price["quote_time"].replace("T", " ")
if quote_time.endswith("+08:00"):
    quote_time = quote_time[:-6] + " +08:00"

report = f"""# 天孚通信 300394.SZ 2025 年报资产负债结构复核

当前股价：{market_price['price']:.2f} 元/股（行情时间：{quote_time}，来源：{market_price['source']}）

## 资产负债结构

单位：亿元

| 类别 | 资产端 | 负债端 |
|---|---:|---:|
| 资金 | {yi(funds_assets)} | {yi(financing_liabilities)} |
| 经营 | {yi(operating_assets)} | {yi(operating_liabilities)} |
| 投资 | {yi(investment_assets)} | {yi(investment_liabilities)} |

资金：资产端主要是可随时支付的现金及银行存款 {yi(2863743000.22)} 亿元，以及非固定收益性银行理财 {yi(210053444.45)} 亿元；负债端只有租赁负债 {yi(financing_liabilities)} 亿元，没有年末银行借款。

经营：资产端主要是客户货款应收账款 {yi(1121985328.51)} 亿元，原材料、在产品、库存商品和发出商品存货 {yi(457195929.70)} 亿元，厂房建筑物和生产设备等固定资产 {yi(1115188623.61)} 亿元，待安装设备、产业园和泰国厂房等在建工程 {yi(202951337.39)} 亿元。负债端主要是供应商和工程应付款 {yi(402555757.40)} 亿元、客户预收货款及待转销项税 {yi(180457756.70)} 亿元、应交税费 {yi(131751986.09)} 亿元和应付职工薪酬 {yi(96865770.77)} 亿元。

投资：资产端为武汉光谷联营企业长期股权投资 {yi(investment_assets)} 亿元；年末没有能直接归属于投资资产的投资性负债。

其他：其他净资产 {yi(other_net_assets)} 亿元，占合并权益 3.54%。其中临时冻结账户资金 {yi(75814642.47)} 亿元已披露 2026 年 1 月解冻，其余主要是递延所得税资产、商誉、预缴税费，以及与资产相关政府补助递延收益和递延所得税负债。

公司收入来自光互连元器件，2025 年有源光器件收入 {yi(2997945108.74)} 亿元、无源光器件收入 {yi(2084386267.76)} 亿元。年末净经营资产 {yi(net_operating_assets)} 亿元，说明利润增长同时沉淀在客户应收、生产备货、产能建设和工程设备款上；但经营负债也增加到 {yi(operating_liabilities)} 亿元，主要来自供应商、工程建设、预收货款、税费和薪酬。

## 利润核心

单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 营业收入 | {yi(income_current['operating_revenue'])} | {yi(income_comparison['operating_revenue'])} |
| 毛利 | {yi(income_current['gross_profit'])} | {yi(income_comparison['gross_profit'])} |
| 归母净利润 | {yi(income_current['parent_net_profit'])} | {yi(income_comparison['parent_net_profit'])} |

2025 年收入增长主要由 AI 算力数据中心和高速光器件需求带动，有源光器件收入增长到 {yi(2997945108.74)} 亿元。毛利按营业收入减营业成本计算为 {yi(income_current['gross_profit'])} 亿元；主营光通信元器件毛利率 53.62%，年报说明泰国工厂投产初期和高速光引擎募投项目毛利率较低，对整体毛利率有拖累。

## 现金流核心

单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 经营活动现金流净额 | {yi(1868203465.93)} | {yi(1262516765.12)} |
| 投资活动现金流净额 | {yi(-264523942.17)} | {yi(-357821990.67)} |
| 筹资活动现金流净额 | {yi(-673129631.29)} | {yi(-781992669.91)} |
| 现金及现金等价物净增加额 | {yi(885254855.87)} | {yi(150785879.74)} |

经营现金流 {yi(1868203465.93)} 亿元低于归母净利润 {yi(income_current['parent_net_profit'])} 亿元，主要是销售增长带来回款增加的同时，应收项目和存货也继续占用现金；现金流量表补充资料显示经营性应收增加 {yi(518245782.63)} 亿元、存货增加 {yi(139500038.69)} 亿元，经营性应付增加 {yi(249858814.40)} 亿元部分抵消占款。

投资现金流净流出 {yi(264523942.17)} 亿元，主要是购买结构性存款 {yi(3810000000.00)} 亿元、收回结构性存款 {yi(3950000000.00)} 亿元，以及购建长期资产支付 {yi(417510390.23)} 亿元共同作用。筹资现金流净流出 {yi(673129631.29)} 亿元，主要是分红及偿付利息 {yi(667320315.85)} 亿元、偿还债务 {yi(40000000.00)} 亿元，限制性股票归属吸收投资 {yi(35918147.44)} 亿元部分抵消。
"""


def validate(data):
    s = data["summary"]
    assert abs(sum(x["amount"] for x in data["items"]) - s["total_assets"]) <= 1
    assert abs(s["funds_assets"] + s["operating_assets"] + s["investment_assets"] + s["other_assets"] - s["total_assets"]) <= 1
    assert abs(sum(x["amount"] for x in data["liability_items"]) - s["total_liabilities"]) <= 1
    assert abs(s["financing_liabilities"] + s["operating_liabilities"] + s["investment_liabilities"] + s["other_liabilities"] - s["total_liabilities"]) <= 1
    assert abs(s["net_funds"] - (s["funds_assets"] - s["financing_liabilities"])) <= 1
    assert abs(s["net_operating_assets"] - (s["operating_assets"] - s["operating_liabilities"])) <= 1
    assert abs(s["net_investment_assets"] - (s["investment_assets"] - s["investment_liabilities"])) <= 1
    assert abs(s["other_net_assets"] - (s["other_assets"] - s["other_liabilities"])) <= 1
    assert abs(s["total_equity"] - (s["net_funds"] + s["net_operating_assets"] + s["net_investment_assets"] + s["other_net_assets"])) <= 1
    assert abs(data["income_core"]["current"]["gross_profit"] - (data["income_core"]["current"]["operating_revenue"] - data["income_core"]["current"]["operating_cost"])) <= 1
    assert abs(data["income_core"]["comparison"]["gross_profit"] - (data["income_core"]["comparison"]["operating_revenue"] - data["income_core"]["comparison"]["operating_cost"])) <= 1


OUT_DIR.mkdir(parents=True, exist_ok=True)
(OUT_DIR / "result.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
(OUT_DIR / "report.md").write_text(report, encoding="utf-8")

reloaded = json.loads((OUT_DIR / "result.json").read_text(encoding="utf-8"))
validate(reloaded)

trace = f"""run_dir: {RUN_DIR}
generated_at: {datetime.now().astimezone().isoformat(timespec='seconds')}
mode: annual
company: 300394.SZ 天孚通信

steps:
- Read financial-report-analysis skill and single-company analysis references.
- Read a-share-price-fetch skill and ran bundled fetch_a_share_price.py; raw quote saved to work/market_price.json.
- Read config/input.json and annual_review evidence before PDF checks.
- Extracted local annual-report.pdf with pypdf to work/annual-report.txt because pdftotext was unavailable.
- Verified consolidated balance sheet, income statement, cash flow statement, and key notes from local PDF text.
- Classified all asset and liability items without parent/child double counting.
- Wrote outputs/result.json and outputs/report.md.
- Re-read outputs/result.json and validated asset sum, liability sum, four category formulas, equity bridge, and gross profit formulas.

validation:
- asset_items_sum = {sum(x['amount'] for x in reloaded['items']):.2f}; total_assets = {total_assets:.2f}; difference = {reloaded['summary']['asset_formula_difference']:.2f}
- liability_items_sum = {sum(x['amount'] for x in reloaded['liability_items']):.2f}; total_liabilities = {total_liabilities:.2f}; difference = {reloaded['summary']['liability_formula_difference']:.2f}
- equity_reconciliation_difference = {reloaded['summary']['equity_reconciliation_difference']:.2f}
- gross_profit_formula_difference_current = {reloaded['income_core']['gross_profit_formula_difference_current']:.2f}
- gross_profit_formula_difference_comparison = {reloaded['income_core']['gross_profit_formula_difference_comparison']:.2f}
"""
(OUT_DIR / "trace.txt").write_text(trace, encoding="utf-8")

print("ok")

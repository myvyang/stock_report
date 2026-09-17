import json
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


RUN_DIR = Path("/Users/haha/aicode/stock_report/data/agent_runs/asset_structure_review/2026-07-19T12-31-02+08-00-605305-sh-中际联合")
OUT_DIR = RUN_DIR / "outputs"
WORK_DIR = RUN_DIR / "work"


def D(value):
    return Decimal(str(value))


def f(value):
    return float(Decimal(value).quantize(Decimal("0.01")))


def ratio(value):
    return float(Decimal(value).quantize(Decimal("0.0000000001")))


def yi(value):
    return (Decimal(value) / D("100000000")).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)


def item(source_field, item_name, amount, category, business_substance, basis, annual_evidence,
         method="direct", confidence="high"):
    return {
        "source_field": source_field,
        "item_name": item_name,
        "amount": f(amount),
        "category": category,
        "business_substance": business_substance,
        "basis": basis,
        "annual_evidence": annual_evidence,
        "evidence_period": "2025-12-31",
        "method": method,
        "confidence": confidence,
    }


def litem(source_field, item_name, amount, category, business_substance, basis, annual_evidence,
          method="direct", confidence="high"):
    return item(source_field, item_name, amount, category, business_substance, basis, annual_evidence, method, confidence)


market_price = json.loads((WORK_DIR / "market_price.json").read_text(encoding="utf-8"))
quote_time_display = market_price["quote_time"].replace("T", " ").replace("+08:00", " +08:00")

total_assets = D("3786886421.61")
total_liabilities = D("845594645.41")
total_equity = D("2941291776.20")
parent_equity = D("2939584823.89")
minority_interest = D("1706952.31")

asset_items = [
    item("balance.MONETARYFUNDS + note 七、79", "现金及现金等价物", "1027180017.96", "funds",
         "可随时用于支付的库存现金、银行存款和少量其他货币资金。",
         "现金及现金等价物不依赖主业继续经营即可保存或支取，归入资金类资产。",
         "年报第173-174页，附注七、79 现金和现金等价物的构成：期末现金及现金等价物余额 1,027,180,017.96 元。"),
    item("balance.TRADING_FINANCIAL_ASSETS", "交易性金融资产", "1067284265.57", "funds",
         "理财产品、基金投资及少量交易性权益工具。",
         "附注列示为理财产品 1,037,886,218.57 元、基金 22,369,247.00 元、权益工具 7,028,800.00 元，可剥离金融资产，归入资金类。",
         "年报第123页，附注七、2 交易性金融资产。"),
    item("balance.NOTCURRENT_ASSET_1YEAR + note 七、12", "一年内到期的债权投资", "10769856.94", "funds",
         "一年内到期的招商银行可转让大额存单。",
         "可转让大额存单属于可剥离存款类金融资产，归入资金类。",
         "年报第138-139页，附注七、12：一年内到期的债权投资为可转让大额存单。"),
    item("balance.DEBT_INVESTMENT + note 七、14", "债权投资", "20765041.11", "funds",
         "浦发银行可转让大额存单中一年以上部分。",
         "可转让大额存单属于可剥离存款类金融资产，归入资金类。",
         "年报第140页，附注七、14：债权投资为可转让大额存单。"),
    item("balance.MONETARYFUNDS + note 七、79", "不属于现金及现金等价物的货币资金", "8762698.53", "other",
         "ETC 冻结款、业务/线上收款冻结款、保函保证金等受限或暂不可变现资金。",
         "受限现金和保证金不能仅因列在货币资金中归入资金类；金额小且性质混合，归入其他资产。",
         "年报第174页，附注七、79：不属于现金及现金等价物的货币资金合计 8,762,698.53 元。"),
    item("balance.NOTES_RECEIVABLE", "应收票据", "112691942.47", "operating",
         "客户以银行承兑汇票、商业承兑汇票支付形成的经营应收票据。",
         "销售收款形成的票据，处于经营回款循环，归入经营资产。",
         "年报第123-124页，附注七、4：银行承兑票据、商业承兑票据及坏账准备。"),
    item("balance.ACCOUNTS_RECEIVABLE", "应收账款", "620797812.90", "operating",
         "向风电等客户销售高空安全作业设备和服务后形成的赊销款。",
         "销售履约后尚未收回的客户款项，归入经营资产。",
         "年报第81页合并资产负债表；第132-137页，附注七、5 应收账款。"),
    item("balance.RECEIVABLES_FINANCING", "应收款项融资", "44615838.55", "operating",
         "以公允价值计量且可背书/贴现的应收票据。",
         "附注列示项目为应收票据，来源于销售收款安排，归入经营资产。",
         "年报第130页，附注七、7 应收款项融资：分类列示为应收票据。"),
    item("balance.PREPAYMENT", "预付款项", "6829123.22", "operating",
         "向供应商预付的采购款。",
         "采购和履约循环形成的预付款，归入经营资产。",
         "年报第131-132页，附注七、8 预付款项。"),
    item("balance.OTHER_RECEIVABLES", "其他应收款", "6228983.61", "operating",
         "投标保证金、押金、代缴五险一金等经营相关往来。",
         "附注按款项性质显示主要与投标、押金和员工社保代缴有关，归入经营资产。",
         "年报第134-135页，附注七、9 其他应收款。"),
    item("balance.INVENTORY", "存货", "429785058.20", "operating",
         "原材料、在产品、库存商品、发出商品、合同履约成本和委托加工物资。",
         "生产、销售和履约循环中的备货及已发出未结转商品，归入经营资产。",
         "年报第137-138页，附注七、10 存货分类。"),
    item("balance.CONTRACT_ASSET", "合同资产", "71598077.35", "operating",
         "销售合同形成的质保金收款权。",
         "履约后尚受质保等条件约束的客户收款权，归入经营资产。",
         "年报第128-129页，附注七、6 合同资产：质保金。"),
    item("balance.OTHER_CURRENT_ASSETS", "其他流动资产", "23637430.64", "other",
         "留抵增值税和预缴税款。",
         "税项资产不直接构成经营投入或可剥离资金，归入其他资产。",
         "年报第139页，附注七、13 其他流动资产。"),
    item("balance.FIXED_ASSETS", "固定资产", "133120705.15", "operating",
         "房屋及建筑物、机器设备、运输工具和其他设备。",
         "生产、研发和经营管理使用的长期资产，归入经营资产。",
         "年报第145-146页，附注七、21 固定资产情况。"),
    item("balance.CONSTRUCTION_IN_PROGRESS", "在建工程", "96211.17", "operating",
         "提升机半自动产线项目、测试架、主机系统测试工装等。",
         "生产测试和产线相关在建项目，归入经营资产。",
         "年报第147页，附注七、22 在建工程。"),
    item("balance.RIGHT_OF_USE_ASSETS", "使用权资产", "14396900.82", "operating",
         "租入房屋及建筑物形成的使用权。",
         "经营场地租赁形成的使用权资产，归入经营资产。",
         "年报第148页，附注七、25 使用权资产。"),
    item("balance.INTANGIBLE_ASSETS", "无形资产", "131736624.03", "operating",
         "土地使用权和软件。",
         "土地及软件服务于生产经营，且商誉为零，归入经营资产。",
         "年报第149-150页，附注七、26 无形资产；附注七、27 商誉不适用。"),
    item("balance.LONG_TERM_PREPAID_EXPENSE", "长期待摊费用", "245100.04", "operating",
         "厂房及办公楼装修待摊。",
         "经营场地装修形成的待摊成本，归入经营资产。",
         "年报第150页，附注七、28 长期待摊费用。"),
    item("balance.DEFERRED_TAX_ASSETS", "递延所得税资产", "56235283.35", "other",
         "资产减值、内部交易未实现利润、预计负债等可抵扣暂时性差异形成的税项资产。",
         "递延所得税资产按规则归入其他资产。",
         "年报第151页，附注七、29 递延所得税资产。"),
    item("balance.OTHER_NONCURRENT_ASSETS", "其他非流动资产", "109450.00", "operating",
         "预付长期资产购置款。",
         "为购置长期经营资产预付的款项，归入经营资产。",
         "年报第152页，附注七、30 其他非流动资产。"),
]

liability_items = [
    litem("balance.SHORTTERM_LOAN", "短期借款", "67420016.08", "financing",
          "短期其他借款。",
          "有息融资项目，归入融资负债。",
          "年报第153页，附注七、32 短期借款。"),
    litem("balance.NOTES_PAYABLE", "应付票据", "129771850.51", "operating",
          "向供应商等开出的银行承兑汇票。",
          "采购和经营付款安排形成，归入经营负债。",
          "年报第153页，附注七、35 应付票据：银行承兑汇票。"),
    litem("balance.ACCOUNTS_PAYABLE", "应付账款", "191154081.88", "operating",
          "采购商品、接受劳务等形成的供应商应付款。",
          "采购和生产履约循环形成，归入经营负债。",
          "年报第153-154页，附注七、36 应付账款。"),
    litem("balance.CONTRACT_LIABILITIES", "合同负债", "273118134.20", "operating",
          "客户合同预收款，对应未来交付高空安全设备或服务的义务。",
          "客户先付款、公司后交付形成的经营负债。",
          "年报第154页，附注七、38 合同负债：合同预收款。"),
    litem("balance.PAYROLL_PAYABLE", "应付职工薪酬", "60148742.65", "operating",
          "工资奖金、社保、公积金等员工薪酬义务。",
          "生产、销售、研发和管理人员薪酬形成的经营负债。",
          "年报第154-155页，附注七、39 应付职工薪酬。"),
    litem("balance.TAXES_PAYABLE", "应交税费", "19016814.89", "operating",
          "增值税、企业所得税、附加税、房产税等当期税费。",
          "本期经营和利润形成的应交税费，归入经营负债。",
          "年报第155-156页，附注七、40 应交税费。"),
    litem("balance.OTHER_PAYABLES", "其他应付款", "8388430.67", "operating",
          "押金及保证金、未付报销款及其他小额往来。",
          "附注未列示应付股利或应付利息，主要为经营往来，归入经营负债。",
          "年报第156-157页，附注七、41 其他应付款。"),
    litem("balance.NONCURRENT_LIABILITY_1YEAR", "一年内到期的租赁负债", "6510020.76", "financing",
          "一年内到期的房屋建筑物租赁付款现值。",
          "租赁负债属于有息融资性质负债，归入融资负债。",
          "年报第157页，附注七、43 一年内到期的非流动负债。"),
    litem("balance.OTHER_CURRENT_LIABILITIES + note 七、44", "待转销项税", "13166484.91", "operating",
          "随合同预收款等形成的待转销项税。",
          "与经营收款和交付义务配套，归入经营负债。",
          "年报第157-158页，附注七、44 其他流动负债。"),
    litem("balance.OTHER_CURRENT_LIABILITIES + note 七、44", "期末已背书未到期且未终止确认的票据", "18722407.25", "operating",
          "已背书但未终止确认的经营性应收票据对应义务。",
          "来源于票据背书安排且无有息融资证据，归入经营负债。",
          "年报第157-158页，附注七、44；第158页受限资产附注列示用于票据背书。"),
    litem("balance.OTHER_CURRENT_LIABILITIES + note 七、44", "产品质量保证", "39345535.68", "other",
          "对已售产品质量保证形成的预计义务。",
          "质量保证义务属于预计负债性质，按规则归入其他负债。",
          "年报第157-158页，附注七、44 其他流动负债：产品质量保证。"),
    litem("balance.LEASE_LIABILITY", "租赁负债", "8833726.04", "financing",
          "一年以上到期的房屋建筑物租赁付款现值。",
          "租赁负债属于有息融资性质负债，归入融资负债。",
          "年报第161页，附注七、47 租赁负债。"),
    litem("balance.DEFERRED_INCOME", "递延收益", "783333.81", "other",
          "与资产相关的政府补助递延收益。",
          "政府补助递延收益不属于经营采购/销售循环，归入其他负债。",
          "年报第161-162页，附注七、51 递延收益。"),
    litem("balance.DEFERRED_TAX_LIABILITIES", "递延所得税负债", "9215066.08", "other",
          "固定资产加速折旧、使用权资产确认和公允价值变动形成的递延所得税负债。",
          "递延所得税负债按规则归入其他负债。",
          "年报第151页，附注七、29 递延所得税负债。"),
]

asset_by_cat = {k: sum(D(str(x["amount"])) for x in asset_items if x["category"] == k) for k in ["funds", "operating", "investment", "other"]}
liability_by_cat = {k: sum(D(str(x["amount"])) for x in liability_items if x["category"] == k) for k in ["financing", "operating", "investment", "other"]}

asset_sum = sum(D(str(x["amount"])) for x in asset_items)
liability_sum = sum(D(str(x["amount"])) for x in liability_items)

net_funds = asset_by_cat["funds"] - liability_by_cat["financing"]
net_operating_assets = asset_by_cat["operating"] - liability_by_cat["operating"]
net_investment_assets = asset_by_cat["investment"] - liability_by_cat["investment"]
other_net_assets = asset_by_cat["other"] - liability_by_cat["other"]
equity_reconciliation = net_funds + net_operating_assets + net_investment_assets + other_net_assets

revenue_2025 = D("1878483204.97")
cost_2025 = D("990440230.85")
gross_2025 = revenue_2025 - cost_2025
revenue_2024 = D("1298708903.73")
cost_2024 = D("707912863.39")
gross_2024 = revenue_2024 - cost_2024

checks = {
    "asset_items_sum": f(asset_sum),
    "asset_formula_difference": f(total_assets - asset_sum),
    "liability_items_sum": f(liability_sum),
    "liability_formula_difference": f(total_liabilities - liability_sum),
    "equity_from_balance": f(total_assets - total_liabilities),
    "equity_reconciliation_sum": f(equity_reconciliation),
    "equity_reconciliation_difference": f(total_equity - equity_reconciliation),
    "gross_profit_current": f(gross_2025),
    "gross_profit_formula_difference_current": f(revenue_2025 - cost_2025 - gross_2025),
    "gross_profit_comparison": f(gross_2024),
    "gross_profit_formula_difference_comparison": f(revenue_2024 - cost_2024 - gross_2024),
}

for key in ["asset_formula_difference", "liability_formula_difference", "equity_reconciliation_difference",
            "gross_profit_formula_difference_current", "gross_profit_formula_difference_comparison"]:
    if abs(D(str(checks[key]))) > D("1"):
        raise SystemExit(f"check failed: {key}={checks[key]}")

summary = {
    "total_assets": f(total_assets),
    "funds_assets": f(asset_by_cat["funds"]),
    "operating_assets": f(asset_by_cat["operating"]),
    "investment_assets": f(asset_by_cat["investment"]),
    "other_assets": f(asset_by_cat["other"]),
    "asset_formula_difference": f(total_assets - asset_sum),
    "total_liabilities": f(total_liabilities),
    "financing_liabilities": f(liability_by_cat["financing"]),
    "operating_liabilities": f(liability_by_cat["operating"]),
    "investment_liabilities": f(liability_by_cat["investment"]),
    "other_liabilities": f(liability_by_cat["other"]),
    "liability_formula_difference": f(total_liabilities - liability_sum),
    "total_equity": f(total_equity),
    "parent_equity": f(parent_equity),
    "minority_interest": f(minority_interest),
    "minority_interest_ratio": ratio(minority_interest / total_equity),
    "net_funds": f(net_funds),
    "net_operating_assets": f(net_operating_assets),
    "net_investment_assets": f(net_investment_assets),
    "other_net_assets": f(other_net_assets),
    "equity_reconciliation_difference": f(total_equity - equity_reconciliation),
    "other_net_assets_ratio_to_equity": ratio(other_net_assets / total_equity),
    "other_net_assets_immaterial": abs(other_net_assets / total_equity) < D("0.05"),
}

result = {
    "company": {"code": "605305.SH", "name": "中际联合"},
    "period": "2025-12-31",
    "currency": "CNY",
    "unit": "yuan",
    "classification_version": "asset-structure-agent-v1",
    "status": "reviewed",
    "summary": summary,
    "items": asset_items,
    "liability_items": liability_items,
    "material_judgments": [
        "交易性金融资产附注显示主要为理财产品和基金投资，另有少量交易性权益工具，均不依赖主业继续经营即可剥离，归入资金类资产。",
        "货币资金中不属于现金及现金等价物的 8,762,698.53 元包含冻结款、保函保证金等，未归入资金类资产。",
        "2025 年末无长期股权投资、其他权益工具投资、其他非流动金融资产和投资性房地产余额，投资类资产为 0。",
        "产品质量保证 39,345,535.68 元按预计负债性质归入其他负债；待转销项税和已背书未到期且未终止确认票据归入经营负债。",
        "其他净资产为 39,291,476.95 元，占所有者权益 1.34%，低于 5%，且主要由递延所得税、税项、受限保证金、政府补助递延收益和产品质量保证构成。"
    ],
    "unresolved_items": [],
    "equity_perspective": {
        "total_equity": f(total_equity),
        "parent_equity": f(parent_equity),
        "minority_interest": f(minority_interest),
        "minority_interest_ratio": ratio(minority_interest / total_equity),
        "note": "主分析采用合并所有者权益勾稽；少数股东权益占比约 0.06%，归母权益为 2,939,584,823.89 元。"
    },
    "income_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": {
            "operating_revenue": f(revenue_2025),
            "operating_cost": f(cost_2025),
            "gross_profit": f(gross_2025),
            "parent_net_profit": f("530336380.44"),
        },
        "comparison": {
            "operating_revenue": f(revenue_2024),
            "operating_cost": f(cost_2024),
            "gross_profit": f(gross_2024),
            "parent_net_profit": f("314804875.75"),
        },
        "gross_profit_formula_difference_current": f(D("0")),
        "gross_profit_formula_difference_comparison": f(D("0")),
        "source_note": "合并利润表年报第85-86页；营业收入和营业成本附注七、61第164-165页。毛利按营业收入减营业成本计算。"
    },
    "cash_flow_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": {
            "operating_cash_flow_net": f("270734219.20"),
            "investing_cash_flow_net": f("-82477781.60"),
            "financing_cash_flow_net": f("-67458642.71"),
            "cash_and_equivalents_net_increase": f("109913905.23"),
        },
        "comparison": {
            "operating_cash_flow_net": f("279844476.75"),
            "investing_cash_flow_net": f("-220089283.30"),
            "financing_cash_flow_net": f("-17470909.77"),
            "cash_and_equivalents_net_increase": f("51001048.84"),
        },
        "source_note": "合并现金流量表年报第88-89页；现金流量表补充资料年报第173页。"
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
        "annual_filing": {
            "local_path": "/Users/haha/aicode/stock_report/data/raw/filings/605305.SH/2025-12-31/annual-report.pdf",
            "official_url": "https://static.cninfo.com.cn/finalpage/2026-04-15/1225100599.PDF",
            "name": "中际联合2025年年度报告"
        },
        "annual_review": {
            "local_path": "/Users/haha/aicode/stock_report/data/analysis/annual_review/605305.SH/2025-12-31/result.json"
        },
        "annual_text_extract": {
            "local_path": str(WORK_DIR / "annual-report-pypdf.txt"),
            "method": "pypdf extract_text; pdftotext unavailable in runtime"
        },
        "market_price": {
            "local_path": str(WORK_DIR / "market_price.json"),
            "skill": str(RUN_DIR / "config/skills/a-share-price-fetch/SKILL.md")
        }
    },
    "data_quality": {
        "quarterly_filing_verified": True,
        "annual_filing_verified": True,
        "reconciliation_ok": True,
        "confidence": "high",
        "limitations": [
            "本次 input.json 的 analysis_basis 为 annual，未读取季度报告；quarterly_filing_verified 表示本次无需季度口径校验。",
            "货币资金中受限/暂不可变现项目金额小且性质混合，整体归入其他资产，未进一步拆入经营保证金。",
            "应收款项融资附注仅列示为应收票据，未进一步拆分银行承兑和商业承兑。"
        ]
    }
}

OUT_DIR.mkdir(parents=True, exist_ok=True)
(OUT_DIR / "result.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

report = f"""# 中际联合（605305.SH）2025 年报资产负债结构复核
当前股价：{market_price['price']:.2f} 元/股（行情时间：{quote_time_display}，来源：{market_price['source']}）

## 资产负债结构
单位：亿元

| 类别 | 资产端 | 负债端 |
|---|---:|---:|
| 资金 | {yi(asset_by_cat['funds'])} | {yi(liability_by_cat['financing'])} |
| 经营 | {yi(asset_by_cat['operating'])} | {yi(liability_by_cat['operating'])} |
| 投资 | {yi(asset_by_cat['investment'])} | {yi(liability_by_cat['investment'])} |

资金：资产端 {yi(asset_by_cat['funds'])} 亿元，主要是 {yi('1027180017.96')} 亿元现金及现金等价物、{yi('1067284265.57')} 亿元理财/基金/交易性权益工具、{yi('31534898.05')} 亿元可转让大额存单；负债端 {yi(liability_by_cat['financing'])} 亿元，主要是短期借款 {yi('67420016.08')} 亿元和租赁负债 {yi('15343746.80')} 亿元。

经营：资产端 {yi(asset_by_cat['operating'])} 亿元，主要是客户赊销和票据收款形成的应收账款 {yi('620797812.90')} 亿元、应收票据 {yi('112691942.47')} 亿元、应收款项融资 {yi('44615838.55')} 亿元，备货和履约形成的存货 {yi('429785058.20')} 亿元，以及房屋建筑物、机器设备、土地和软件等长期经营资产。存货的年报证据显示，期末主要是发出商品 {yi('269958503.83')} 亿元、库存商品 {yi('63436153.51')} 亿元、原材料 {yi('54809439.78')} 亿元和合同履约成本 {yi('31429210.29')} 亿元。负债端 {yi(liability_by_cat['operating'])} 亿元，主要是客户预付形成的合同交付义务 {yi('273118134.20')} 亿元、供应商应付票据和应付账款合计 {yi('320925932.39')} 亿元、职工薪酬和当期税费等经营义务。

投资：资产端和负债端均为 0.00 亿元；年末没有长期股权投资、其他权益工具投资、其他非流动金融资产和投资性房地产余额，也没有可识别的对应投资性负债。

按净额勾稽，期末所有者权益 {yi(total_equity)} 亿元 = 净资金 {yi(net_funds)} 亿元 + 净经营资产 {yi(net_operating_assets)} 亿元 + 净投资资产 {yi(net_investment_assets)} 亿元 + 其他净资产 {yi(other_net_assets)} 亿元。其他净资产占权益约 {((other_net_assets / total_equity) * D('100')).quantize(Decimal('0.01'))}%，低于 5%，主要是递延所得税、税项、受限保证金、政府补助递延收益和产品质量保证等常规项目。

## 利润核心
单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 营业收入 | {yi(revenue_2025)} | {yi(revenue_2024)} |
| 毛利 | {yi(gross_2025)} | {yi(gross_2024)} |
| 归母净利润 | {yi('530336380.44')} | {yi('314804875.75')} |

公司收入主要来自高空安全作业设备和服务。2025 年高空安全升降设备收入 {yi('1221163694.70')} 亿元，高空安全防护设备收入 {yi('575911337.51')} 亿元，高空安全作业服务收入 {yi('69686546.49')} 亿元；风电行业收入 {yi('1826543446.97')} 亿元，占主营业务收入约 97.85%。营业收入增长 44.64%，毛利从 {yi(gross_2024)} 亿元增至 {yi(gross_2025)} 亿元，主要来自风电需求、境内外收入增长以及外销占比提升；毛利按营业收入减营业成本计算。

## 现金流核心
单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 经营活动现金流净额 | {yi('270734219.20')} | {yi('279844476.75')} |
| 投资活动现金流净额 | {yi('-82477781.60')} | {yi('-220089283.30')} |
| 筹资活动现金流净额 | {yi('-67458642.71')} | {yi('-17470909.77')} |
| 现金及现金等价物净增加额 | {yi('109913905.23')} | {yi('51001048.84')} |

2025 年归母净利润 {yi('530336380.44')} 亿元，但经营活动现金流净额为 {yi('270734219.20')} 亿元，利润没有等额转成现金，主要被经营性应收项目增加 {yi('290286949.51')} 亿元、存货增加 {yi('39777776.72')} 亿元占用，经营性应付项目增加 {yi('34799129.26')} 亿元部分抵消。投资现金流净流出 {yi('-82477781.60')} 亿元，主要是理财和基金本金投出、收回之间的净流出及购建长期资产支付 {yi('16486550.06')} 亿元；筹资现金流净流出 {yi('-67458642.71')} 亿元，主要是借款流入 {yi('116639891.50')} 亿元、偿债 {yi('5800000.00')} 亿元、分红及利息支付 {yi('174266400.00')} 亿元和租赁付款 {yi('6032134.21')} 亿元共同作用。现金最终体现为现金及现金等价物增加 {yi('109913905.23')} 亿元，同时资金类资产仍主要沉淀在现金、理财基金和大额存单中。
"""
(OUT_DIR / "report.md").write_text(report, encoding="utf-8")

trace_lines = [
    "asset_structure_review trace",
    "company=605305.SH 中际联合",
    "period=2025-12-31",
    "basis=annual",
    "skills_read=financial-report-analysis/SKILL.md,a-share-price-fetch/SKILL.md,analysis-habits.md,report-output-contract.md",
    "annual_review_read=/Users/haha/aicode/stock_report/data/analysis/annual_review/605305.SH/2025-12-31/result.json",
    "annual_pdf=/Users/haha/aicode/stock_report/data/raw/filings/605305.SH/2025-12-31/annual-report.pdf",
    "pdf_extract=work/annual-report-pypdf.txt (pdftotext unavailable; pypdf used)",
    "market_price_raw=work/market_price.json",
    "classification=asset-structure-agent-v1",
    json.dumps(checks, ensure_ascii=False, sort_keys=True),
]
(OUT_DIR / "trace.txt").write_text("\n".join(trace_lines) + "\n", encoding="utf-8")

print(json.dumps(checks, ensure_ascii=False, indent=2))

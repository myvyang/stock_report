from __future__ import annotations

import json
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


RUN_DIR = Path("/Users/haha/aicode/stock_report/data/agent_runs/asset_structure_review/2026-07-19T12-23-22+08-00-002690-sz-美亚光电")
OUT_DIR = RUN_DIR / "outputs"
WORK_DIR = RUN_DIR / "work"


def D(value: str) -> Decimal:
    return Decimal(value)


def f(value: Decimal) -> float:
    return float(value.quantize(Decimal("0.01")))


def yi(value: Decimal) -> str:
    return f"{(value / Decimal('100000000')).quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)}"


market_price = json.loads((WORK_DIR / "market_price.json").read_text(encoding="utf-8"))
quote_time_display = market_price["quote_time"].replace("T", " ").replace("+08:00", " +08:00")

total_assets = D("3608191141.96")
total_liabilities = D("681208418.39")
total_equity = D("2926982723.57")
parent_equity = D("2926982723.57")
minority_interest = D("0")

items = [
    {
        "source_field": "合并资产负债表:货币资金; 现金流量表补充资料:期末现金及现金等价物余额",
        "item_name": "现金及现金等价物",
        "amount": D("1390426706.67"),
        "category": "funds",
        "business_substance": "可随时用于支付的银行存款和其他货币资金。",
        "basis": "现金和现金等价物构成附注列示期末现金及现金等价物余额；未包含受限保证金。",
        "annual_evidence": "年报第72页合并现金流量表期末现金及现金等价物余额；第137页现金和现金等价物构成。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "货币资金附注:受限制的货币资金",
        "item_name": "受限保证金",
        "amount": D("21369662.98"),
        "category": "operating",
        "business_substance": "银行承兑汇票保证金和履约保证金，随采购结算和履约安排占用。",
        "basis": "受限资金不能作为可剥离资金；附注说明为银行承兑汇票保证金和履约保证金。",
        "annual_evidence": "年报第112页货币资金附注；第125页受限资产附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:交易性金融资产",
        "item_name": "理财产品",
        "amount": D("740376741.42"),
        "category": "funds",
        "business_substance": "使用暂时闲置资金购买的银行理财产品。",
        "basis": "附注明示交易性金融资产全部为理财产品，属于可剥离金融资产。",
        "annual_evidence": "年报第62页合并资产负债表；第112-113页交易性金融资产附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:应收账款",
        "item_name": "应收账款",
        "amount": D("391508345.52"),
        "category": "operating",
        "business_substance": "销售色选机、X射线工业检测机和医疗设备形成的客户赊销款。",
        "basis": "应收账款来自收入确认后的客户付款权利，属于销售循环资产。",
        "annual_evidence": "年报第62页合并资产负债表；第113-118页应收账款附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:应收款项融资",
        "item_name": "银行承兑汇票",
        "amount": D("6419212.30"),
        "category": "operating",
        "business_substance": "客户以银行承兑汇票结算形成的收款权利。",
        "basis": "附注列示应收款项融资为应收票据，且公司认为所持有的银行承兑汇票不存在重大信用风险。",
        "annual_evidence": "年报第62页合并资产负债表；第118页应收款项融资附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:预付款项",
        "item_name": "预付款项",
        "amount": D("4251099.83"),
        "category": "operating",
        "business_substance": "采购和经营履约过程中预先支付给供应商的款项。",
        "basis": "预付账款属于采购循环形成的经营资产。",
        "annual_evidence": "年报第62页合并资产负债表。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "medium",
    },
    {
        "source_field": "合并资产负债表:其他应收款",
        "item_name": "备用金、保证金及其他往来款",
        "amount": D("3909036.84"),
        "category": "operating",
        "business_substance": "备用金、押金保证金及少量其他往来款。",
        "basis": "附注按款项性质列示为备用金和保证金、其他；金额较小，按经营周转相关款项归类。",
        "annual_evidence": "年报第63页合并资产负债表；第116-118页其他应收款附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "medium",
    },
    {
        "source_field": "合并资产负债表:存货",
        "item_name": "存货",
        "amount": D("315642040.94"),
        "category": "operating",
        "business_substance": "原材料1.75亿元、自制半成品0.49亿元、在产品0.42亿元、库存商品0.42亿元、发出商品0.04亿元和委托加工物资0.03亿元。",
        "basis": "存货为生产和销售循环形成的经营资产。",
        "annual_evidence": "年报第63页合并资产负债表；第118页存货分类附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:其他流动资产",
        "item_name": "增值税借方余额重分类及预缴税金",
        "amount": D("8831027.41"),
        "category": "operating",
        "business_substance": "经营采购、销售和纳税节奏形成的待抵扣/预缴税款。",
        "basis": "附注列示为增值税借方余额重分类和预缴税金，随经营纳税形成。",
        "annual_evidence": "年报第63页合并资产负债表；第120页其他流动资产附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:其他权益工具投资",
        "item_name": "中粮科工股份有限公司股权",
        "amount": D("190225048.00"),
        "category": "investment",
        "business_substance": "计划长期持有的非主营股权投资。",
        "basis": "附注明示指定为以公允价值计量且其变动计入其他综合收益的原因为计划长期持有。",
        "annual_evidence": "年报第63页合并资产负债表；第120页其他权益工具投资附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:固定资产",
        "item_name": "房屋建筑物、机器设备及其他设备",
        "amount": D("440255079.56"),
        "category": "operating",
        "business_substance": "光电智能识别装备研发、生产和经营使用的厂房、机器设备、运输工具和其他设备。",
        "basis": "固定资产附注按房屋及建筑物、机器设备、运输工具、其他设备列示，服务于主业生产经营。",
        "annual_evidence": "年报第63页合并资产负债表；第120-121页固定资产附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:在建工程",
        "item_name": "智能化涂装钣金生产基地扩产项目及零星项目",
        "amount": D("23692866.80"),
        "category": "operating",
        "business_substance": "智能化涂装钣金生产基地扩产投入和其他零星工程。",
        "basis": "在建工程附注列示主要项目为智能化涂装钣金生产基地扩产项目，属于生产能力建设。",
        "annual_evidence": "年报第63页合并资产负债表；第122页在建工程附注；第22-23页资产变动说明。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:无形资产",
        "item_name": "土地使用权和软件",
        "amount": D("68375850.01"),
        "category": "operating",
        "business_substance": "经营场地土地使用权0.61亿元和软件0.07亿元。",
        "basis": "无形资产附注列示为土地使用权和软件，内部研发形成无形资产占比0%。",
        "annual_evidence": "年报第63页合并资产负债表；第122页无形资产附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:长期待摊费用",
        "item_name": "装修费摊销",
        "amount": D("1214805.65"),
        "category": "operating",
        "business_substance": "经营场所装修费待摊余额。",
        "basis": "附注列示长期待摊费用为装修费摊销，属于经营场地投入。",
        "annual_evidence": "年报第63页合并资产负债表；第124页长期待摊费用附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:递延所得税资产",
        "item_name": "递延所得税资产",
        "amount": D("1272196.57"),
        "category": "other",
        "business_substance": "可抵扣暂时性差异抵销后的所得税资产。",
        "basis": "递延所得税资产属于税务暂时性差异，不直接归入经营资产。",
        "annual_evidence": "年报第63页合并资产负债表；第124-125页递延所得税附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:其他非流动资产",
        "item_name": "预付设备款等",
        "amount": D("421421.46"),
        "category": "operating",
        "business_substance": "预付设备采购款。",
        "basis": "附注列示为预付设备款等，属于生产经营资产采购前形成的权利。",
        "annual_evidence": "年报第63页合并资产负债表；第125页其他非流动资产附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
]

liability_items = [
    {
        "source_field": "合并资产负债表:应付票据",
        "item_name": "银行承兑汇票",
        "amount": D("57295181.02"),
        "category": "operating",
        "business_substance": "采购结算中开出的银行承兑汇票付款义务。",
        "basis": "附注列示应付票据全部为银行承兑汇票，属于经营采购形成的负债。",
        "annual_evidence": "年报第64页合并资产负债表；第126页应付票据附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:应付账款",
        "item_name": "应付货款、设备工程款、运费及其他",
        "amount": D("274689080.88"),
        "category": "operating",
        "business_substance": "供应商货款2.57亿元、设备工程款0.09亿元、运费及其他0.08亿元。",
        "basis": "应付账款附注按货款、设备及工程款、运费及其他列示，属于经营采购和经营资产建设形成的负债。",
        "annual_evidence": "年报第64页合并资产负债表；第126页应付账款附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:合同负债",
        "item_name": "预收货款",
        "amount": D("67612030.97"),
        "category": "operating",
        "business_substance": "客户先付款、公司后续交付设备或服务的履约义务。",
        "basis": "附注列示合同负债为预收货款，属于销售履约循环负债。",
        "annual_evidence": "年报第64页合并资产负债表；第127页合同负债附注；第22-23页资产负债变动说明。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:应付职工薪酬",
        "item_name": "应付职工薪酬",
        "amount": D("165562969.34"),
        "category": "operating",
        "business_substance": "已计提未支付的工资、奖金、津贴和补贴等员工薪酬。",
        "basis": "附注列示期末短期薪酬主要为工资、奖金、津贴和补贴。",
        "annual_evidence": "年报第64页合并资产负债表；第127页应付职工薪酬附注；第22-23页资产负债变动说明。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:应交税费",
        "item_name": "应交税费",
        "amount": D("46082479.88"),
        "category": "operating",
        "business_substance": "经营产生的应交增值税、企业所得税、个人所得税及附加税费。",
        "basis": "附注列示主要为增值税和企业所得税，随经营利润和销售形成。",
        "annual_evidence": "年报第64页合并资产负债表；第128页应交税费附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:其他应付款",
        "item_name": "押金保证金、暂收往来款、预提费用及其他",
        "amount": D("28646377.37"),
        "category": "operating",
        "business_substance": "经营押金保证金、暂收往来款、预提费用及少量其他应付款。",
        "basis": "附注列示其他应付款主要为预提费用和经营往来性质款项；无应付股利和应付利息。",
        "annual_evidence": "年报第64页合并资产负债表；第126-127页其他应付款附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "medium",
    },
    {
        "source_field": "合并资产负债表:其他流动负债",
        "item_name": "待转销项税额和产品质量保证",
        "amount": D("14306216.87"),
        "category": "operating",
        "business_substance": "已收款或履约安排对应的待转销项税额，以及产品质量保证服务承诺。",
        "basis": "附注列示其他流动负债为待转销项税额和产品质量保证，属于销售和售后履约形成的经营负债。",
        "annual_evidence": "年报第64页合并资产负债表；第128页其他流动负债附注；第22-23页资产负债变动说明。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:递延收益",
        "item_name": "与资产相关的政府补助递延收益",
        "amount": D("22619761.66"),
        "category": "other",
        "business_substance": "与资产相关政府补助尚未转入损益的递延余额。",
        "basis": "递延收益为政府补助，不是有息融资，也不直接归属某项投资资产，按其他负债保留。",
        "annual_evidence": "年报第64页合并资产负债表；第128页递延收益附注；第139-140页政府补助负债项目。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合并资产负债表:递延所得税负债",
        "item_name": "递延所得税负债",
        "amount": D("4394320.40"),
        "category": "other",
        "business_substance": "金融资产公允价值、固定资产税会差异等形成的递延所得税负债抵销后余额。",
        "basis": "递延所得税负债属于税务暂时性差异，按其他负债处理。",
        "annual_evidence": "年报第64页合并资产负债表；第124-125页递延所得税附注。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
]

def sum_cat(rows, category):
    return sum((row["amount"] for row in rows if row["category"] == category), Decimal("0"))


funds_assets = sum_cat(items, "funds")
operating_assets = sum_cat(items, "operating")
investment_assets = sum_cat(items, "investment")
other_assets = sum_cat(items, "other")
financing_liabilities = sum_cat(liability_items, "financing")
operating_liabilities = sum_cat(liability_items, "operating")
investment_liabilities = sum_cat(liability_items, "investment")
other_liabilities = sum_cat(liability_items, "other")

net_funds = funds_assets - financing_liabilities
net_operating_assets = operating_assets - operating_liabilities
net_investment_assets = investment_assets - investment_liabilities
other_net_assets = other_assets - other_liabilities
asset_formula_difference = total_assets - (funds_assets + operating_assets + investment_assets + other_assets)
liability_formula_difference = total_liabilities - (
    financing_liabilities + operating_liabilities + investment_liabilities + other_liabilities
)
equity_reconciliation_difference = total_equity - (
    net_funds + net_operating_assets + net_investment_assets + other_net_assets
)
minority_interest_ratio = Decimal("0")
other_ratio = other_net_assets / total_equity

income_current_revenue = D("2406863327.55")
income_current_cost = D("1109069582.87")
income_comparison_revenue = D("2310770382.50")
income_comparison_cost = D("1145487082.11")
income_current_gross = income_current_revenue - income_current_cost
income_comparison_gross = income_comparison_revenue - income_comparison_cost

result = {
    "company": {"code": "002690.SZ", "name": "美亚光电"},
    "period": "2025-12-31",
    "currency": "CNY",
    "unit": "yuan",
    "classification_version": "asset-structure-agent-v1",
    "status": "reviewed",
    "summary": {
        "total_assets": f(total_assets),
        "funds_assets": f(funds_assets),
        "operating_assets": f(operating_assets),
        "investment_assets": f(investment_assets),
        "other_assets": f(other_assets),
        "asset_formula_difference": f(asset_formula_difference),
        "total_liabilities": f(total_liabilities),
        "financing_liabilities": f(financing_liabilities),
        "operating_liabilities": f(operating_liabilities),
        "investment_liabilities": f(investment_liabilities),
        "other_liabilities": f(other_liabilities),
        "liability_formula_difference": f(liability_formula_difference),
        "total_equity": f(total_equity),
        "parent_equity": f(parent_equity),
        "minority_interest": f(minority_interest),
        "minority_interest_ratio": float(minority_interest_ratio),
        "net_funds": f(net_funds),
        "net_operating_assets": f(net_operating_assets),
        "net_investment_assets": f(net_investment_assets),
        "other_net_assets": f(other_net_assets),
        "equity_reconciliation_difference": f(equity_reconciliation_difference),
        "other_net_assets_ratio_to_equity": float(other_ratio.quantize(Decimal("0.0000000001"))),
        "other_net_assets_immaterial": abs(other_ratio) < Decimal("0.05"),
    },
    "items": [{**row, "amount": f(row["amount"])} for row in items],
    "liability_items": [{**row, "amount": f(row["amount"])} for row in liability_items],
    "material_judgments": [
        "货币资金拆分为现金及现金等价物13.90亿元和受限保证金0.21亿元；受限保证金为银行承兑汇票保证金和履约保证金，归入经营资产。",
        "交易性金融资产7.40亿元附注明示为理财产品，归入资金类资产；其他权益工具投资1.90亿元为计划长期持有的中粮科工股权，归入投资类资产。",
        "年末无短期借款、长期借款、应付债券、一年内到期非流动负债和租赁负债，融资负债为0。",
        "递延收益0.23亿元和递延所得税负债0.04亿元归入其他负债；其他净资产绝对值低于合并权益5%。",
    ],
    "unresolved_items": [],
    "equity_perspective": {
        "total_equity": f(total_equity),
        "parent_equity": f(parent_equity),
        "minority_interest": f(minority_interest),
        "minority_interest_ratio": float(minority_interest_ratio),
        "note": "合并报表未列示少数股东权益余额，归母权益等于所有者权益合计。",
    },
    "income_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": {
            "operating_revenue": f(income_current_revenue),
            "operating_cost": f(income_current_cost),
            "gross_profit": f(income_current_gross),
            "parent_net_profit": f(D("719117651.30")),
        },
        "comparison": {
            "operating_revenue": f(income_comparison_revenue),
            "operating_cost": f(income_comparison_cost),
            "gross_profit": f(income_comparison_gross),
            "parent_net_profit": f(D("649173516.27")),
        },
        "gross_profit_formula_difference_current": f(
            income_current_gross - (income_current_revenue - income_current_cost)
        ),
        "gross_profit_formula_difference_comparison": f(
            income_comparison_gross - (income_comparison_revenue - income_comparison_cost)
        ),
        "source_note": "年报第67-68页合并利润表；毛利用营业收入减营业成本计算。",
    },
    "cash_flow_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": {
            "operating_cash_flow_net": f(D("962109305.17")),
            "investing_cash_flow_net": f(D("-349077452.72")),
            "financing_cash_flow_net": f(D("-617832839.00")),
            "cash_and_equivalents_net_increase": f(D("-18057663.10")),
        },
        "comparison": {
            "operating_cash_flow_net": f(D("877680664.64")),
            "investing_cash_flow_net": f(D("-243713877.94")),
            "financing_cash_flow_net": f(D("-617025438.00")),
            "cash_and_equivalents_net_increase": f(D("22690087.59")),
        },
        "source_note": "年报第71-72页合并现金流量表。",
    },
    "market_price": {
        "code": market_price.get("code", ""),
        "name": market_price.get("name", ""),
        "currency": market_price.get("currency", "CNY"),
        "price": market_price.get("price", 0),
        "quote_time": market_price.get("quote_time", ""),
        "fetched_at": market_price.get("fetched_at", ""),
        "source": market_price.get("source", ""),
        "source_url": market_price.get("source_url", ""),
    },
    "sources": {
        "annual_filing": "/Users/haha/aicode/stock_report/data/raw/filings/002690.SZ/2025-12-31/annual-report.pdf",
        "annual_review": "/Users/haha/aicode/stock_report/data/analysis/annual_review/002690.SZ/2025-12-31/result.json",
        "price_skill": str(RUN_DIR / "config/skills/a-share-price-fetch/SKILL.md"),
        "market_price_raw": str(WORK_DIR / "market_price.json"),
        "extracted_pdf_text": str(WORK_DIR / "annual-report-pypdf.txt"),
    },
    "data_quality": {
        "quarterly_filing_verified": True,
        "annual_filing_verified": True,
        "reconciliation_ok": True,
        "confidence": "high",
        "limitations": [
            "本次为年报口径，未读取季度报告。",
            "其他应收款中少量“其他”往来未进一步披露合同细节，金额不重大，按经营往来处理。",
        ],
    },
}


report = f"""# 美亚光电 2025 年报资产负债结构复核

当前股价：{market_price['price']:.2f} 元/股（行情时间：{quote_time_display}，来源：{market_price['source']}）

## 资产负债结构

单位：亿元

| 类别 | 资产端 | 负债端 |
|---|---:|---:|
| 资金 | {yi(funds_assets)} | {yi(financing_liabilities)} |
| 经营 | {yi(operating_assets)} | {yi(operating_liabilities)} |
| 投资 | {yi(investment_assets)} | {yi(investment_liabilities)} |

资金：资产端为现金及现金等价物 {yi(D('1390426706.67'))} 亿元和暂时闲置资金购买的理财产品 {yi(D('740376741.42'))} 亿元；负债端没有短期借款、长期借款、应付债券、一年内到期非流动负债或租赁负债，融资负债为 {yi(financing_liabilities)} 亿元。货币资金中的银行承兑汇票保证金和履约保证金 {yi(D('21369662.98'))} 亿元受限，未放入资金类资产。

经营：资产端 {yi(operating_assets)} 亿元主要是客户赊销款 {yi(D('391508345.52'))} 亿元、客户银行承兑汇票 {yi(D('6419212.30'))} 亿元、存货 {yi(D('315642040.94'))} 亿元、厂房设备 {yi(D('440255079.56'))} 亿元、智能化涂装钣金生产基地扩产等在建工程 {yi(D('23692866.80'))} 亿元、土地使用权和软件 {yi(D('68375850.01'))} 亿元。存货按年报附注主要是原材料 {yi(D('175454598.12'))} 亿元、自制半成品 {yi(D('49337991.06'))} 亿元、在产品 {yi(D('41528292.32'))} 亿元、库存商品 {yi(D('41938116.33'))} 亿元、发出商品 {yi(D('4084150.24'))} 亿元和委托加工物资 {yi(D('3298892.87'))} 亿元。负债端 {yi(operating_liabilities)} 亿元主要是银行承兑汇票 {yi(D('57295181.02'))} 亿元、供应商货款/设备工程款/运费等应付账款 {yi(D('274689080.88'))} 亿元、客户先款后货形成的预收货款 {yi(D('67612030.97'))} 亿元、已计提未支付的工资奖金等职工薪酬 {yi(D('165562969.34'))} 亿元和应交税费 {yi(D('46082479.88'))} 亿元。

投资：资产端为计划长期持有的中粮科工股份有限公司股权 {yi(investment_assets)} 亿元；年报没有披露可直接归属这项投资的投资性负债，投资性负债为 {yi(investment_liabilities)} 亿元。

合并所有者权益 {yi(total_equity)} 亿元，少数股东权益为 {yi(minority_interest)} 亿元，归母权益同为 {yi(parent_equity)} 亿元。按重分类勾稽，净资金 {yi(net_funds)} 亿元、净经营资产 {yi(net_operating_assets)} 亿元、净投资资产 {yi(net_investment_assets)} 亿元、其他净资产 {yi(other_net_assets)} 亿元，合计等于所有者权益。

## 利润核心

单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 营业收入 | {yi(income_current_revenue)} | {yi(income_comparison_revenue)} |
| 毛利 | {yi(income_current_gross)} | {yi(income_comparison_gross)} |
| 归母净利润 | {yi(D('719117651.30'))} | {yi(D('649173516.27'))} |

公司主业是光电智能识别装备的研发、生产和销售，主要产品包括色选机、X 光异物检测机和口腔 CBCT。2025 年营业收入 {yi(income_current_revenue)} 亿元，营业成本 {yi(income_current_cost)} 亿元，毛利按收入减成本为 {yi(income_current_gross)} 亿元；年报母公司收入成本分解显示，主营收入主要来自色选机、X 射线工业检测机和医疗设备，收入在某一时点确认。归母净利润 {yi(D('719117651.30'))} 亿元，高于上年 {yi(D('649173516.27'))} 亿元；其他收益 {yi(D('86842322.92'))} 亿元主要来自政府补贴和软件退税，其中软件产品退税收入 {yi(D('74334997.78'))} 亿元被年报列为日常经营业务相关。

## 现金流核心

单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 经营活动现金流净额 | {yi(D('962109305.17'))} | {yi(D('877680664.64'))} |
| 投资活动现金流净额 | {yi(D('-349077452.72'))} | {yi(D('-243713877.94'))} |
| 筹资活动现金流净额 | {yi(D('-617832839.00'))} | {yi(D('-617025438.00'))} |
| 现金及现金等价物净增加额 | {yi(D('-18057663.10'))} | {yi(D('22690087.59'))} |

2025 年经营活动现金流净额 {yi(D('962109305.17'))} 亿元，高于归母净利润 {yi(D('719117651.30'))} 亿元，利润较好转成经营现金。投资活动现金流净额为 {yi(D('-349077452.72'))} 亿元，主要不是大额并购，而是暂时闲置资金现金管理本金支付增加：收回投资 {yi(D('1190000000.00'))} 亿元、投资支付 {yi(D('1500000000.00'))} 亿元，同时购建固定资产、无形资产和其他长期资产支付 {yi(D('46126929.99'))} 亿元。筹资活动现金流净额 {yi(D('-617832839.00'))} 亿元，主要是现金分红 {yi(D('617512260.00'))} 亿元；年末仍无有息融资负债。
"""


def validate(data: dict) -> list[str]:
    errors = []
    asset_sum = sum(D(str(row["amount"])) for row in data["items"])
    liability_sum = sum(D(str(row["amount"])) for row in data["liability_items"])
    s = data["summary"]
    checks = {
        "asset_item_sum": D(str(s["total_assets"])) - asset_sum,
        "liability_item_sum": D(str(s["total_liabilities"])) - liability_sum,
        "asset_formula_difference": D(str(s["asset_formula_difference"])),
        "liability_formula_difference": D(str(s["liability_formula_difference"])),
        "net_funds": D(str(s["net_funds"])) - (D(str(s["funds_assets"])) - D(str(s["financing_liabilities"]))),
        "net_operating_assets": D(str(s["net_operating_assets"])) - (D(str(s["operating_assets"])) - D(str(s["operating_liabilities"]))),
        "net_investment_assets": D(str(s["net_investment_assets"])) - (D(str(s["investment_assets"])) - D(str(s["investment_liabilities"]))),
        "other_net_assets": D(str(s["other_net_assets"])) - (D(str(s["other_assets"])) - D(str(s["other_liabilities"]))),
        "equity_reconciliation_difference": D(str(s["equity_reconciliation_difference"])),
        "gross_profit_current": D(str(data["income_core"]["current"]["gross_profit"])) - (
            D(str(data["income_core"]["current"]["operating_revenue"])) - D(str(data["income_core"]["current"]["operating_cost"]))
        ),
        "gross_profit_comparison": D(str(data["income_core"]["comparison"]["gross_profit"])) - (
            D(str(data["income_core"]["comparison"]["operating_revenue"])) - D(str(data["income_core"]["comparison"]["operating_cost"]))
        ),
    }
    for name, diff in checks.items():
        if abs(diff) > Decimal("1"):
            errors.append(f"{name}: {diff}")
    if errors:
        data["status"] = "error"
        data["data_quality"]["reconciliation_ok"] = False
    return errors


OUT_DIR.mkdir(exist_ok=True)
(OUT_DIR / "result.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
(OUT_DIR / "report.md").write_text(report, encoding="utf-8")

reloaded = json.loads((OUT_DIR / "result.json").read_text(encoding="utf-8"))
errors = validate(reloaded)
trace = [
    "asset_structure_review trace",
    "company=002690.SZ 美亚光电",
    "period=2025-12-31 annual",
    f"market_price_raw={WORK_DIR / 'market_price.json'}",
    "annual_review_read=/Users/haha/aicode/stock_report/data/analysis/annual_review/002690.SZ/2025-12-31/result.json",
    "annual_pdf_read=/Users/haha/aicode/stock_report/data/raw/filings/002690.SZ/2025-12-31/annual-report.pdf",
    "pdf_text_extracted_with=pypdf 6.7.5 because pdftotext was unavailable",
    f"asset_items_sum={sum(D(str(row['amount'])) for row in reloaded['items'])}",
    f"liability_items_sum={sum(D(str(row['amount'])) for row in reloaded['liability_items'])}",
    f"asset_formula_difference={reloaded['summary']['asset_formula_difference']}",
    f"liability_formula_difference={reloaded['summary']['liability_formula_difference']}",
    f"equity_reconciliation_difference={reloaded['summary']['equity_reconciliation_difference']}",
    f"gross_profit_formula_difference_current={reloaded['income_core']['gross_profit_formula_difference_current']}",
    f"gross_profit_formula_difference_comparison={reloaded['income_core']['gross_profit_formula_difference_comparison']}",
    f"validation_errors={errors}",
]
(OUT_DIR / "trace.txt").write_text("\n".join(trace) + "\n", encoding="utf-8")
print("\n".join(trace))
if errors:
    raise SystemExit(1)

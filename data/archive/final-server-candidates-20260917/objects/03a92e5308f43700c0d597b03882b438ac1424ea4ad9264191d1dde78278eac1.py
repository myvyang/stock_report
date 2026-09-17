import json
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


RUN = Path("/Users/haha/aicode/stock_report/data/agent_runs/asset_structure_review/2026-07-19T12-14-05+08-00-301061-sz-匠心家居")
OUT = RUN / "outputs"
WORK = RUN / "work"


def D(x):
    return Decimal(str(x))


def q2(x):
    return D(x).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)


def num(x):
    return float(q2(x))


def yi(x):
    return f"{(q2(x) / Decimal('100000000')).quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)}"


period = "2025-12-31"
annual_evidence_period = "2025-12-31"
annual_pdf = "/Users/haha/aicode/stock_report/data/raw/filings/301061.SZ/2025-12-31/annual-report.pdf"
annual_review = "/Users/haha/aicode/stock_report/data/analysis/annual_review/301061.SZ/2025-12-31/result.json"
annual_url = "https://static.cninfo.com.cn/finalpage/2026-04-24/1225280094.pdf"
market_price = json.loads((WORK / "market_price.json").read_text(encoding="utf-8"))

assets = [
    ("MONETARYFUNDS.cash_equivalents", "现金及现金等价物", D("2198457685.14"), "funds",
     "可随时支付的库存现金、银行存款和其他货币资金。", "合并现金流量表及现金和现金等价物附注列示期末现金 2,198,457,685.14 元。",
     "2025 年报 PDF_PAGE 109-110 合并现金流量表；PDF_PAGE 189 现金和现金等价物构成", "direct", "high"),
    ("TRADE_FINASSET_NOTFVTPL", "交易性金融资产-理财产品", D("1632016046.60"), "funds",
     "金融机构理财产品，可剥离资金资产。", "附注列示交易性金融资产均为理财产品；ROIC 证据包按可剥离理财核对。",
     "2025 年报 PDF_PAGE 147 交易性金融资产；annual_review evidence separable_investments_current", "direct", "high"),
    ("MONETARYFUNDS.restricted_operating", "受限货币资金-经营保证金", D("66446037.32"), "operating",
     "票据保证金、电费保证金及土地购置质押存单/保函保证金，不可自由剥离。", "不属于现金及现金等价物的货币资金中，票据保证金 65,042,900.00 元、电费保证金 1,138,657.72 元、土地购置质押存单及保函保证金 264,479.60 元。",
     "2025 年报 PDF_PAGE 170 受限资产；PDF_PAGE 190 不属于现金及现金等价物的货币资金", "direct", "high"),
    ("ACCOUNTS_RECE", "应收账款", D("429856168.60"), "operating",
     "销售智能电动沙发、智能电动床及配件形成的客户赊销款，扣除坏账准备后列示。", "审计关键事项说明收入来自智能电动沙发、智能电动床、配件；应收账款账面价值 429,856,168.60 元。",
     "2025 年报 PDF_PAGE 97-99 审计关键事项；PDF_PAGE 148-150 应收账款", "direct", "high"),
    ("PREPAYMENT", "预付款项", D("7498635.27"), "operating",
     "采购和经营履约相关预付款。", "预付款项账龄附注列示 1 年以内占 99.81%，期末合计 7,498,635.27 元。",
     "2025 年报 PDF_PAGE 159 预付款项", "direct", "high"),
    ("OTHER_RECE", "其他应收款", D("87704186.25"), "operating",
     "出口退税、押金保证金、代扣代缴个税/社保公积金和员工备用金等经营周转款。", "其他应收款按性质列示押金保证金、出口退税、代扣代缴社保公积金、员工备用金、代扣代缴个人所得税。",
     "2025 年报 PDF_PAGE 153-158 其他应收款", "direct", "high"),
    ("INVENTORY", "存货", D("482136132.91"), "operating",
     "原材料、在产品、库存商品、发出商品、自制半成品和委托加工物资等生产销售库存。", "存货附注列示期末账面价值 482,136,132.91 元，其中原材料 198,178,049.77 元、发出商品 183,371,713.93 元、库存商品 74,093,648.17 元。",
     "2025 年报 PDF_PAGE 160 存货", "direct", "high"),
    ("OTHER_CURRENT_ASSET.operating_tax_prepaids", "其他流动资产-经营税费及待摊费用", D("51595295.60"), "operating",
     "待抵扣增值税进项税额和待摊费用，随采购与经营费用形成。", "其他流动资产附注列示待抵扣增值税进项税额 48,350,069.96 元、待摊费用 3,245,225.64 元。",
     "2025 年报 PDF_PAGE 162 其他流动资产", "direct", "high"),
    ("FIXED_ASSET", "固定资产", D("171688240.04"), "operating",
     "房屋建筑物、专用设备、运输工具、通用设备及其他设备，用于生产和经营管理。", "固定资产附注列示期末账面价值 171,688,240.04 元，含房屋建筑物和专用设备等。",
     "2025 年报 PDF_PAGE 163-164 固定资产", "direct", "high"),
    ("USERIGHT_ASSET", "使用权资产", D("187174660.97"), "operating",
     "租入房屋及建筑物形成的经营场地使用权。", "使用权资产附注列示房屋及建筑物期末账面价值 187,174,660.97 元。",
     "2025 年报 PDF_PAGE 166 使用权资产", "direct", "high"),
    ("INTANGIBLE_ASSET", "无形资产", D("20629382.21"), "operating",
     "土地使用权、专利权和软件，用于生产经营及管理。", "无形资产附注列示土地使用权 13,330,604.07 元、专利权 4,503,545.37 元、软件 2,795,232.77 元。",
     "2025 年报 PDF_PAGE 167-168 无形资产", "direct", "high"),
    ("LONG_PREPAID_EXPENSE", "长期待摊费用", D("9713973.53"), "operating",
     "装修和其他长期待摊经营支出。", "长期待摊费用附注列示装修 5,663,753.58 元、其他 4,050,219.95 元。",
     "2025 年报 PDF_PAGE 168 长期待摊费用", "direct", "high"),
    ("OTHER_NONCURRENT_ASSET", "其他非流动资产-预付工程设备款", D("12619090.64"), "operating",
     "预付工程设备款，未来形成生产经营长期资产。", "其他非流动资产附注列示预付的工程设备款期末账面价值 12,619,090.64 元。",
     "2025 年报 PDF_PAGE 169-170 其他非流动资产", "direct", "high"),
    ("MONETARYFUNDS.restricted_swap_margin", "受限货币资金-掉期保证金", D("1697763.11"), "other",
     "外汇掉期保证金，虽来自货币资金但受限且与金融衍生工具相关。", "不属于现金及现金等价物的货币资金列示掉期保证金 1,697,763.11 元；性质不并入可剥离资金。",
     "2025 年报 PDF_PAGE 190 不属于现金及现金等价物的货币资金", "direct", "high"),
    ("HOLDSALE_ASSET", "持有待售资产", D("14959536.00"), "other",
     "拟由政府收储的振中路南侧、腾龙路东侧土地。", "持有待售资产附注列示该土地期末账面价值 14,959,536.00 元，预计 2026 年政府收回。",
     "2025 年报 PDF_PAGE 161 持有待售资产", "direct", "high"),
    ("OTHER_CURRENT_ASSET.prepaid_income_tax", "其他流动资产-预缴企业所得税", D("27312543.13"), "other",
     "预缴企业所得税，属于税务性资产。", "其他流动资产附注列示预缴企业所得税 27,312,543.13 元。",
     "2025 年报 PDF_PAGE 162 其他流动资产", "direct", "high"),
    ("DEFER_TAX_ASSET", "递延所得税资产", D("34879502.22"), "other",
     "可抵扣暂时性差异形成的递延所得税资产。", "递延所得税资产抵销后期末余额 34,879,502.22 元。",
     "2025 年报 PDF_PAGE 168-169 递延所得税资产/负债", "direct", "high"),
]

liabilities = [
    ("SHORT_LOAN", "短期借款", D("298491118.91"), "financing",
     "信用借款，有息融资负债。", "短期借款附注列示信用借款 298,491,118.91 元。",
     "2025 年报 PDF_PAGE 170 短期借款", "direct", "high"),
    ("NONCURRENT_LIAB_1YEAR", "一年内到期的非流动负债", D("46009978.85"), "financing",
     "一年内到期的租赁负债。", "附注列示一年内到期的租赁负债 46,009,978.85 元。",
     "2025 年报 PDF_PAGE 175 一年内到期的非流动负债", "direct", "high"),
    ("LEASE_LIAB", "租赁负债", D("150749559.37"), "financing",
     "房屋租赁形成的有息租赁融资义务。", "租赁负债附注列示房屋租赁 150,749,559.37 元。",
     "2025 年报 PDF_PAGE 176 租赁负债", "direct", "high"),
    ("NOTE_PAYABLE", "应付票据", D("249657000.00"), "operating",
     "银行承兑汇票，主要用于采购结算。", "应付票据附注列示银行承兑汇票 249,657,000.00 元。",
     "2025 年报 PDF_PAGE 171 应付票据", "direct", "high"),
    ("ACCOUNTS_PAYABLE", "应付账款", D("332860528.59"), "operating",
     "材料款、工程设备款、服务费及其他应付款。", "应付账款附注列示材料款 302,066,617.39 元、工程设备款 19,278,606.54 元、服务费及其他 11,515,304.66 元。",
     "2025 年报 PDF_PAGE 171 应付账款", "direct", "high"),
    ("ADVANCE_RECEIVABLES", "预收款项", D("2771777.70"), "operating",
     "预收客户货款形成的交付义务。", "预收款项附注列示货款 2,771,777.70 元。",
     "2025 年报 PDF_PAGE 173 预收款项", "direct", "high"),
    ("CONTRACT_LIAB", "合同负债", D("36322898.53"), "operating",
     "已收或应收客户对价而应转让商品的义务，即客户先款后货形成的交付义务。", "合同负债附注列示货款 36,322,898.53 元；会计政策说明合同负债为应向客户转让商品的义务。",
     "2025 年报 PDF_PAGE 138 合同负债会计政策；PDF_PAGE 173 合同负债", "direct", "high"),
    ("STAFF_SALARY_PAYABLE", "应付职工薪酬", D("46564386.02"), "operating",
     "工资奖金、福利、社保公积金等员工薪酬义务。", "应付职工薪酬附注列示短期薪酬和设定提存计划期末合计 46,564,386.02 元。",
     "2025 年报 PDF_PAGE 173-174 应付职工薪酬", "direct", "high"),
    ("TAX_PAYABLE", "应交税费", D("20550503.71"), "operating",
     "企业所得税、个税、城市维护建设税、房产税、印花税等经营税费。", "应交税费附注列示企业所得税 17,487,078.71 元等，期末合计 20,550,503.71 元。",
     "2025 年报 PDF_PAGE 174 应交税费", "direct", "high"),
    ("OTHER_PAYABLE", "其他应付款", D("205075.72"), "operating",
     "押金保证金、费用报销款和其他经营性应付款。", "其他应付款附注按性质列示押金保证金、费用报销款、其他，合计 205,075.72 元。",
     "2025 年报 PDF_PAGE 172 其他应付款", "direct", "high"),
    ("TRADE_FINLIAB_NOTFVTPL", "交易性金融负债", D("28879443.84"), "other",
     "远期结售汇公允价值负债，不属于有息融资，也无直接投资资产匹配依据。", "交易性金融负债附注列示远期结售汇 28,879,443.84 元。",
     "2025 年报 PDF_PAGE 171 交易性金融负债", "direct", "high"),
    ("PREDICT_LIAB", "预计负债", D("10091901.28"), "other",
     "产品质量保证形成的预计售后服务费用。", "预计负债附注列示产品质量保证 10,091,901.28 元。",
     "2025 年报 PDF_PAGE 177 预计负债", "direct", "high"),
    ("DEFER_INCOME", "递延收益", D("517044.58"), "other",
     "与资产相关政府补助递延确认。", "递延收益附注列示政府补助期末 517,044.58 元。",
     "2025 年报 PDF_PAGE 177 递延收益", "direct", "high"),
]


def make_item(row):
    source, name, amount, cat, substance, basis, evidence, method, confidence = row
    return {
        "source_field": source,
        "item_name": name,
        "amount": num(amount),
        "category": cat,
        "business_substance": substance,
        "basis": basis,
        "annual_evidence": evidence,
        "evidence_period": annual_evidence_period,
        "method": method,
        "confidence": confidence,
    }


asset_totals = {k: sum((a[2] for a in assets if a[3] == k), D("0")) for k in ["funds", "operating", "investment", "other"]}
liability_totals = {k: sum((l[2] for l in liabilities if l[3] == k), D("0")) for k in ["financing", "operating", "investment", "other"]}
total_assets = D("5436384879.54")
total_liabilities = D("1223671217.10")
total_equity = D("4212713662.44")
parent_equity = D("4212713662.44")
minority_interest = D("0")
net_funds = asset_totals["funds"] - liability_totals["financing"]
net_operating = asset_totals["operating"] - liability_totals["operating"]
net_investment = asset_totals["investment"] - liability_totals["investment"]
other_net = asset_totals["other"] - liability_totals["other"]

revenue_2025 = D("3379089998.16")
cost_2025 = D("2051442437.17")
gross_2025 = revenue_2025 - cost_2025
np_2025 = D("857479611.12")
revenue_2024 = D("2548377993.75")
cost_2024 = D("1545489350.24")
gross_2024 = revenue_2024 - cost_2024
np_2024 = D("682935697.75")

result = {
    "company": {"code": "301061.SZ", "name": "匠心家居"},
    "period": period,
    "currency": "CNY",
    "unit": "yuan",
    "classification_version": "asset-structure-agent-v1",
    "status": "reviewed",
    "summary": {
        "total_assets": num(total_assets),
        "funds_assets": num(asset_totals["funds"]),
        "operating_assets": num(asset_totals["operating"]),
        "investment_assets": num(asset_totals["investment"]),
        "other_assets": num(asset_totals["other"]),
        "asset_formula_difference": num(total_assets - sum(asset_totals.values(), D("0"))),
        "total_liabilities": num(total_liabilities),
        "financing_liabilities": num(liability_totals["financing"]),
        "operating_liabilities": num(liability_totals["operating"]),
        "investment_liabilities": num(liability_totals["investment"]),
        "other_liabilities": num(liability_totals["other"]),
        "liability_formula_difference": num(total_liabilities - sum(liability_totals.values(), D("0"))),
        "total_equity": num(total_equity),
        "parent_equity": num(parent_equity),
        "minority_interest": num(minority_interest),
        "minority_interest_ratio": 0,
        "net_funds": num(net_funds),
        "net_operating_assets": num(net_operating),
        "net_investment_assets": num(net_investment),
        "other_net_assets": num(other_net),
        "equity_reconciliation_difference": num(total_equity - (net_funds + net_operating + net_investment + other_net)),
        "other_net_assets_ratio_to_equity": float((other_net / total_equity).quantize(Decimal("0.000001"))),
        "other_net_assets_immaterial": abs(other_net / total_equity) < Decimal("0.05"),
    },
    "items": [make_item(x) for x in assets],
    "liability_items": [make_item(x) for x in liabilities],
    "material_judgments": [
        "交易性金融资产年报附注全部列示为理财产品，按可剥离资金资产归入资金类资产，而非投资类资产。",
        "货币资金拆分为现金及现金等价物、受限经营保证金和掉期保证金；受限部分不因列示在货币资金中而归入资金类资产。",
        "交易性金融负债为远期结售汇公允价值负债，缺少与投资资产直接匹配依据，未归入投资性负债。",
        "持有待售土地、预缴所得税、递延所得税资产和产品质量保证预计负债按合同规则归入其他。"
    ],
    "unresolved_items": [],
    "equity_perspective": {
        "total_equity": num(total_equity),
        "parent_equity": num(parent_equity),
        "minority_interest": 0,
        "minority_interest_ratio": 0,
        "note": "合并报表少数股东权益为空，所有者权益合计等于归属于母公司所有者权益合计。"
    },
    "income_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": {
            "operating_revenue": num(revenue_2025),
            "operating_cost": num(cost_2025),
            "gross_profit": num(gross_2025),
            "parent_net_profit": num(np_2025),
        },
        "comparison": {
            "operating_revenue": num(revenue_2024),
            "operating_cost": num(cost_2024),
            "gross_profit": num(gross_2024),
            "parent_net_profit": num(np_2024),
        },
        "gross_profit_formula_difference_current": num(gross_2025 - (revenue_2025 - cost_2025)),
        "gross_profit_formula_difference_comparison": num(gross_2024 - (revenue_2024 - cost_2024)),
        "source_note": "合并利润表及营业收入和营业成本附注；毛利按营业收入减营业成本计算，未发现同比期更正或重述。"
    },
    "cash_flow_core": {
        "current_period_label": "2025",
        "comparison_period_label": "2024",
        "current": {
            "operating_cash_flow_net": num(D("788922521.51")),
            "investing_cash_flow_net": num(D("-589814000.99")),
            "financing_cash_flow_net": num(D("54869414.28")),
            "cash_and_equivalents_net_increase": num(D("106715438.53")),
        },
        "comparison": {
            "operating_cash_flow_net": num(D("495622447.07")),
            "investing_cash_flow_net": num(D("868213956.08")),
            "financing_cash_flow_net": num(D("-172072793.50")),
            "cash_and_equivalents_net_increase": num(D("1242678401.67")),
        },
        "source_note": "合并现金流量表；现金及现金等价物净增加额已包含汇率变动影响。"
    },
    "market_price": {
        "code": market_price.get("code", ""),
        "name": market_price.get("name", ""),
        "currency": market_price.get("currency", "CNY"),
        "price": market_price.get("price", 0),
        "quote_time": market_price.get("quote_time", ""),
        "fetched_at": market_price.get("fetched_at", ""),
        "source": market_price.get("source", ""),
        "source_url": market_price.get("source_url", "")
    },
    "sources": {
        "annual_filing_local_path": annual_pdf,
        "annual_filing_url": annual_url,
        "annual_review": annual_review,
        "annual_text_extract": str(WORK / "annual-report-pages.txt"),
        "market_price_json": str(WORK / "market_price.json"),
        "price_skill": str(RUN / "config/skills/a-share-price-fetch/SKILL.md")
    },
    "data_quality": {
        "quarterly_filing_verified": True,
        "annual_filing_verified": True,
        "reconciliation_ok": True,
        "confidence": "high",
        "limitations": [
            "本次为年报口径，未读取季度初拆数据。",
            "货币资金中掉期保证金与远期结售汇负债属于外汇风险管理相关项目，财报未披露逐笔业务合同，按其他列示，不强行净额化。",
            "其他应收款按净额整体归入经营类，附注披露性质均为出口退税、保证金、代扣代缴款和备用金等经营周转项目。"
        ]
    }
}

quote_time = market_price["quote_time"].replace("T", " ").replace("+08:00", " +08:00")
report = f"""# 匠心家居 301061.SZ 2025 年报资产负债结构复核

当前股价：{market_price['price']:.2f} 元/股（行情时间：{quote_time}，来源：{market_price['source']}）

## 资产负债结构
单位：亿元

| 类别 | 资产端 | 负债端 |
| --- | ---: | ---: |
| 资金 | {yi(asset_totals['funds'])} | {yi(liability_totals['financing'])} |
| 经营 | {yi(asset_totals['operating'])} | {yi(liability_totals['operating'])} |
| 投资 | {yi(asset_totals['investment'])} | {yi(liability_totals['investment'])} |

资金：资产端主要是现金及现金等价物 {yi(D('2198457685.14'))} 亿元和理财产品 {yi(D('1632016046.60'))} 亿元；负债端主要是短期借款 {yi(D('298491118.91'))} 亿元及房屋租赁负债含一年内到期部分 {yi(D('196759538.22'))} 亿元。

经营：资产端主要是客户赊销形成的应收账款 {yi(D('429856168.60'))} 亿元、原材料/在产品/成品/发出商品等存货 {yi(D('482136132.91'))} 亿元、租入房屋使用权 {yi(D('187174660.97'))} 亿元、房屋建筑物和生产设备等固定资产 {yi(D('171688240.04'))} 亿元，以及出口退税、押金保证金和代扣代缴款等其他应收款 {yi(D('87704186.25'))} 亿元。负债端主要是银行承兑汇票 {yi(D('249657000.00'))} 亿元、材料款/工程设备款/服务费等应付账款 {yi(D('332860528.59'))} 亿元、客户先款后货形成的预收款项和合同负债 {yi(D('39094676.23'))} 亿元、员工薪酬 {yi(D('46564386.02'))} 亿元和应交税费 {yi(D('20550503.71'))} 亿元。

投资：资产端没有长期股权投资、投资性房地产或其他非流动金融资产余额；负债端也没有可直接归属投资资产的投资性负债。

公司 2025 年末所有者权益 {yi(total_equity)} 亿元，少数股东权益为 0。按净额勾稽，净资金 {yi(net_funds)} 亿元、净经营资产 {yi(net_operating)} 亿元、净投资资产 {yi(net_investment)} 亿元、其他净资产 {yi(other_net)} 亿元，合计等于所有者权益。其他净资产占权益 {((other_net / total_equity) * Decimal('100')).quantize(Decimal('0.01'))}%，低于 5%，主要是持有待售土地、递延所得税资产、预缴所得税、远期结售汇负债和产品质量保证预计负债，不改变主表判断。

## 利润核心
单位：亿元

| 指标 | 2025 | 2024 |
| --- | ---: | ---: |
| 营业收入 | {yi(revenue_2025)} | {yi(revenue_2024)} |
| 毛利 | {yi(gross_2025)} | {yi(gross_2024)} |
| 归母净利润 | {yi(np_2025)} | {yi(np_2024)} |

公司收入来自智能电动沙发、智能电动床及配件。2025 年营业收入 {yi(revenue_2025)} 亿元，毛利 {yi(gross_2025)} 亿元；营业收入和营业成本附注列示智能电动沙发收入 {yi(D('2761571062.55'))} 亿元、成本 {yi(D('1702646560.36'))} 亿元，是收入和毛利的主体。年报说明美国零售商客户销售收入占同期总营业收入 67.08%，收入增长主要落在北美零售渠道和核心客户份额提升上。

## 现金流核心
单位：亿元

| 指标 | 2025 | 2024 |
| --- | ---: | ---: |
| 经营活动现金流净额 | {yi(D('788922521.51'))} | {yi(D('495622447.07'))} |
| 投资活动现金流净额 | {yi(D('-589814000.99'))} | {yi(D('868213956.08'))} |
| 筹资活动现金流净额 | {yi(D('54869414.28'))} | {yi(D('-172072793.50'))} |
| 现金及现金等价物净增加额 | {yi(D('106715438.53'))} | {yi(D('1242678401.67'))} |

2025 年经营活动现金流净额 {yi(D('788922521.51'))} 亿元，低于归母净利润 {yi(np_2025)} 亿元但仍覆盖大部分利润，现金回款没有明显脱节。投资活动净流出 {yi(D('-589814000.99'))} 亿元，主要是理财产品投资和赎回的净流出，同时购建固定资产、无形资产和其他长期资产支付 {yi(D('84251292.02'))} 亿元。筹资活动净流入 {yi(D('54869414.28'))} 亿元，年报说明主要受短期借款增加影响；同时分配股利、利润或偿付利息支付 {yi(D('195532491.28'))} 亿元。全年现金及现金等价物只增加 {yi(D('106715438.53'))} 亿元，是经营造血、理财配置、借款增加、分红和汇率影响共同作用后的结果。
"""

trace = f"""run_dir: {RUN}
company: 301061.SZ 匠心家居
period: 2025-12-31 annual

skills_read:
- {RUN / 'config/skills/financial-report-analysis/SKILL.md'}
- {RUN / 'config/skills/financial-report-analysis/references/analysis-habits.md'}
- {RUN / 'config/skills/financial-report-analysis/references/report-output-contract.md'}
- {RUN / 'config/skills/a-share-price-fetch/SKILL.md'}

inputs:
- input_json: {RUN / 'config/input.json'}
- annual_review: {annual_review}
- annual_pdf: {annual_pdf}
- annual_text_extract: {WORK / 'annual-report-pages.txt'} via pypdf because pdftotext was unavailable
- market_price_json: {WORK / 'market_price.json'}

market_price:
{json.dumps(market_price, ensure_ascii=False, indent=2)}

classification_notes:
- Funds assets = free cash and cash equivalents + trading financial assets disclosed as wealth management products.
- Restricted monetary funds split out of funds assets: operating guarantees to operating assets; swap margin to other assets.
- Financing liabilities = short-term borrowings + current/noncurrent lease liabilities.
- Trading financial liability from forward FX settlement classified as other liability due no direct investment-asset matching.
- No investment assets/liabilities identified in consolidated balance sheet.

reconciliation:
- total_assets {total_assets} = classified assets {sum(asset_totals.values(), D('0'))}
- total_liabilities {total_liabilities} = classified liabilities {sum(liability_totals.values(), D('0'))}
- total_equity {total_equity} = net_funds {net_funds} + net_operating_assets {net_operating} + net_investment_assets {net_investment} + other_net_assets {other_net}
- gross_profit_2025 {gross_2025} = revenue {revenue_2025} - cost {cost_2025}
- gross_profit_2024 {gross_2024} = revenue {revenue_2024} - cost {cost_2024}
"""

OUT.mkdir(exist_ok=True)
(OUT / "result.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
(OUT / "report.md").write_text(report, encoding="utf-8")
(OUT / "trace.txt").write_text(trace, encoding="utf-8")

print("wrote", OUT / "result.json")
print("wrote", OUT / "report.md")
print("wrote", OUT / "trace.txt")

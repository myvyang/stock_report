#!/usr/bin/env python3
"""Rebuild the structured stock-research model through the required CLI."""

from pathlib import Path
import subprocess


ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT / ".agents/skills/stock-research/scripts/stock_research.py"
MODEL = ROOT / "outputs/analysis.json"

SOURCES = {
    2023: "古越龙山2023年年度报告（2024-03-29），https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2024-03-29/600059_20240329_S7P4.pdf",
    2024: "古越龙山2024年年度报告（2025-03-28），https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2025-03-28/600059_20250328_BT3R.pdf",
    2025: "古越龙山2025年年度报告（2026-04-23），https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2026-04-23/600059_20260423_XRGR.pdf",
}


def run(*args: object) -> None:
    subprocess.run(["python3", str(TOOL), *map(str, args)], cwd=ROOT, check=True)


def fact(fid: str, item: str, amount: float, period: str, source_year: int, locator: str,
         currency: str = "人民币", scope: str = "合并") -> None:
    run("add-fact", "--model", MODEL, "--fact-id", fid, "--reported-item", item,
        "--amount", amount, "--period", period, "--currency", currency,
        "--scope", scope, "--source", SOURCES[source_year], "--locator", locator)


def field(view: str, name: str, *, year: int | None = None, expression: str | None = None,
          value: float | None = None, basis: str, reason: str, confidence: str = "high",
          falsifiers: tuple[str, ...] = (), observed_at: str = "") -> None:
    args: list[object] = ["set-field", "--model", MODEL, "--view", view, "--field", name]
    if year is not None:
        args += ["--year", year]
    args += ["--expression", expression] if expression is not None else ["--value", value]
    args += ["--basis-type", basis, "--reason", reason, "--confidence", confidence]
    for item in falsifiers:
        args += ["--falsifier", item]
    if observed_at:
        args += ["--observed-at", observed_at]
    run(*args)


run("init", "--name", "古越龙山", "--code", "600059.SH",
    "--period-label", "2025年年度报告", "--period-end", "2025-12-31",
    "--coverage-years", "2023,2024,2025", "--financial-currency", "人民币",
    "--trading-currency", "人民币", "--security-name", "A股普通股",
    "--security-unit", "股", "--output", MODEL)

# Consolidated operating facts. Credit-loss amounts are signed as expenses; a gain is negative.
historical = {
    2023: {
        "page_pl": "PDF第71—72页，合并利润表", "page_cf": "PDF第75—76页，合并现金流量表",
        "page_da": "PDF第146—147页，现金流量表补充资料", "page_tax": "PDF第101—102页，税项",
        "revenue": 1783701654.24, "cost": 1113385430.08, "tax_surcharge": 75005066.16,
        "selling": 246735603.04, "admin": 113478887.80, "rd": 28217353.42,
        "credit": -413000.72, "fixed_da": 72759094.22, "rou_da": 2792867.69,
        "intangible_da": 9025746.00, "lt_prepaid_da": 963013.48,
        "ocf": 393399906.11, "capex_paid": 443796367.41, "disposal_cash": 351938074.60,
        "interest_expense": 211410.14, "interest_income": 43450140.55,
    },
    2024: {
        "page_pl": "PDF第72—73页，合并利润表", "page_cf": "PDF第75—76页，合并现金流量表",
        "page_da": "PDF第154页，现金流量表补充资料", "page_tax": "PDF第108页，税项",
        "revenue": 1936276884.12, "cost": 1216770073.03, "tax_surcharge": 87011694.99,
        "selling": 252228447.85, "admin": 110050978.43, "rd": 30201002.86,
        "credit": 4289350.50, "fixed_da": 86969989.91, "rou_da": 2384826.69,
        "intangible_da": 9491266.48, "lt_prepaid_da": 1994900.99,
        "ocf": 387207712.24, "capex_paid": 277031256.32, "disposal_cash": 2594813.69,
        "interest_expense": 183888.74, "interest_income": 35259514.80,
    },
    2025: {
        "page_pl": "PDF第60—61页，合并利润表", "page_cf": "PDF第63—64页，合并现金流量表",
        "page_da": "PDF第139—140页，现金流量表补充资料", "page_tax": "PDF第93—94页，税项",
        "revenue": 1830840685.49, "cost": 1141088037.03, "tax_surcharge": 97346386.45,
        "selling": 253354528.66, "admin": 108603119.07, "rd": 33983562.28,
        "credit": 3063125.76, "fixed_da": 85083466.00, "rou_da": 2413708.19,
        "intangible_da": 9490772.39, "lt_prepaid_da": 2082963.90,
        "ocf": 337308759.67, "capex_paid": 236299084.23, "disposal_cash": 54993542.19,
        "interest_expense": 251926.84, "interest_income": 34804559.86,
    },
}

for year, row in historical.items():
    period = f"{year}-01-01至{year}-12-31"
    for key, label in (("revenue", "营业收入"), ("cost", "营业成本"),
                       ("tax_surcharge", "税金及附加"), ("selling", "销售费用"),
                       ("admin", "管理费用"), ("rd", "研发费用"),
                       ("credit", "信用减值损失（按经营费用符号转写）"),
                       ("interest_expense", "利息费用"), ("interest_income", "利息收入")):
        fact(f"y{year}_{key}", label, row[key], period, year, row["page_pl"])
    for key, label in (("fixed_da", "固定资产折旧"), ("rou_da", "使用权资产摊销"),
                       ("intangible_da", "无形资产摊销"), ("lt_prepaid_da", "长期待摊费用摊销")):
        fact(f"y{year}_{key}", label, row[key], period, year, row["page_da"])
    fact(f"y{year}_ocf", "经营活动产生的现金流量净额", row["ocf"], period, year, row["page_cf"])
    fact(f"y{year}_capex_paid", "购建固定资产、无形资产和其他长期资产支付的现金",
         row["capex_paid"], period, year, row["page_cf"])
    fact(f"y{year}_disposal_cash", "处置固定资产、无形资产和其他长期资产收回的现金净额",
         row["disposal_cash"], period, year, row["page_cf"])
    fact(f"y{year}_tax_rate", "主要纳税主体企业所得税税率", 0.25, period, year,
         row["page_tax"], currency="比例")

    expense_expr = "+".join(f"y{year}_{key}" for key in ("tax_surcharge", "selling", "admin", "rd", "credit"))
    ebit_expr = f"(y{year}_revenue-y{year}_cost-({expense_expr}))"
    da_expr = "+".join(f"y{year}_{key}" for key in ("fixed_da", "rou_da", "intangible_da", "lt_prepaid_da"))
    ati_expr = f"(y{year}_interest_expense-y{year}_interest_income)*(1-y{year}_tax_rate)"
    wc_expr = f"({ebit_expr})*(1-y{year}_tax_rate)+({da_expr})-y{year}_ocf-({ati_expr})"
    field("historical", "revenue", year=year, expression=f"y{year}_revenue", basis="reported",
          reason="合并利润表营业收入。")
    field("historical", "cost_of_revenue", year=year, expression=f"y{year}_cost", basis="reported",
          reason="合并利润表营业成本。")
    field("historical", "period_operating_expenses", year=year, expression=expense_expr, basis="formula",
          reason="税金及附加、销售、管理、研发及经营性信用减值净额之和；排除财务收益、投资与资产处置。")
    field("historical", "cash_tax", year=year, expression=f"({ebit_expr})*y{year}_tax_rate", basis="formula",
          reason="按主要经营主体25%税率对重构EBIT估算经营现金税，避免资产处置等非经营损益污染。", confidence="medium")
    field("historical", "depreciation_amortization", year=year, expression=da_expr, basis="formula",
          reason="现金流量表补充资料中的固定资产、使用权资产、无形资产和长期待摊费用折旧摊销合计。")
    field("historical", "core_business_capex", year=year,
          expression=f"y{year}_capex_paid-y{year}_disposal_cash", basis="formula",
          reason="按技能规定使用经营性长期资产购建现金减处置回款；产业园是黄酒主业搬迁、提效和扩产。", confidence="medium")
    field("historical", "exploratory_business_capex", year=year, value=0, basis="estimate",
          reason="披露的重大项目均服务既有黄酒生产，未见可单独识别的新业务长期资产现金投入。", confidence="medium",
          falsifiers=("后续披露果酒、白酒、文旅等新业务项目的独立现金投入与商业化边界。",))
    field("historical", "operating_working_capital_increase", year=year, expression=wc_expr, basis="formula",
          reason="用NOPAT、折旧摊销、经营现金流及税后净利息反推，吸收经营性周转与其他非现金经营调整并完成FCFF双路径闭合。", confidence="medium")
    field("historical", "operating_cash_flow", year=year, expression=f"y{year}_ocf", basis="reported",
          reason="合并现金流量表经营活动现金流净额。")
    field("historical", "after_tax_interest_in_operating_cash_flow", year=year, expression=ati_expr, basis="formula",
          reason="经营现金流包含的税后净利息支出；公司净利息为收入，故本项为负并从经营现金流中剔除。", confidence="medium")

# Balance-sheet facts and operating-capital classification. Amounts for 2022/2023 come from the
# 2023 filing; 2024 from the 2024 filing; 2025 from the 2025 filing.
balance = {
    2022: dict(source_year=2023, locator="PDF第67—69页，合并资产负债表2022年比较数",
        ar=120156227.34, receivables_financing=10931340.00, prepayments=27451014.22,
        other_receivables=4486516.17, inventory=2134799381.25, current_maturity_assets=216374.30,
        other_current_assets=1535710.60, accounts_payable=357991928.23, contract_liabilities=176972315.91,
        employee_payable=56496756.94, taxes_payable=58223601.97, other_payables=99223437.31,
        other_current_liabilities=22976762.86, fixed_assets=1086532099.87, cip=546242985.38,
        rou_assets=4225660.13, intangible_assets=279649764.35, goodwill=21462781.98,
        lt_prepaid=1301937.14, other_noncurrent_assets=27301000.00, deferred_income=1257477.50),
    2023: dict(source_year=2023, locator="PDF第67—69页，合并资产负债表",
        ar=142956328.23, receivables_financing=29923694.00, prepayments=5924705.96,
        other_receivables=7104736.56, inventory=2003349594.42, current_maturity_assets=230922.08,
        other_current_assets=1626578.71, accounts_payable=419734785.43, contract_liabilities=167899849.47,
        employee_payable=68798994.30, taxes_payable=160215219.68, other_payables=138934696.30,
        other_current_liabilities=21837329.47, fixed_assets=1006279042.60, cip=1001714851.74,
        rou_assets=5271595.79, intangible_assets=312885436.65, goodwill=21462781.98,
        lt_prepaid=6172016.57, other_noncurrent_assets=19191000.00, deferred_income=6609549.84),
    2024: dict(source_year=2024, locator="PDF第68—70页，合并资产负债表",
        ar=212540038.98, receivables_financing=26545449.74, prepayments=4399266.90,
        other_receivables=6700277.31, inventory=1893736994.37, current_maturity_assets=0,
        other_current_assets=2334177.61, accounts_payable=518393633.71, contract_liabilities=121382591.64,
        employee_payable=75193582.66, taxes_payable=99240810.33, other_payables=143742573.04,
        other_current_liabilities=15779736.77, fixed_assets=1771435662.66, cip=375740775.47,
        rou_assets=7445665.01, intangible_assets=311785276.94, goodwill=21462781.98,
        lt_prepaid=6868840.17, other_noncurrent_assets=19191000.00, deferred_income=6481200.24),
    2025: dict(source_year=2025, locator="PDF第56—58页，合并资产负债表",
        ar=214969000.85, receivables_financing=14682120.00, prepayments=5830796.05,
        other_receivables=5474175.58, inventory=1867640131.00, current_maturity_assets=0,
        other_current_assets=1909820.87, accounts_payable=484540708.61, contract_liabilities=117863139.04,
        employee_payable=76830770.93, taxes_payable=126411256.18, other_payables=153138552.55,
        other_current_liabilities=13851666.72, fixed_assets=1937484450.87, cip=315485794.73,
        rou_assets=6122954.49, intangible_assets=297915538.64, goodwill=23209953.66,
        lt_prepaid=4659911.07, other_noncurrent_assets=31422469.20, deferred_income=17306890.48),
}

labels = {
    "ar": "应收账款", "receivables_financing": "应收款项融资", "prepayments": "预付款项",
    "other_receivables": "其他应收款", "inventory": "存货", "current_maturity_assets": "一年内到期的非流动资产",
    "other_current_assets": "其他流动资产", "accounts_payable": "应付账款", "contract_liabilities": "合同负债",
    "employee_payable": "应付职工薪酬", "taxes_payable": "应交税费", "other_payables": "其他应付款",
    "other_current_liabilities": "其他流动负债", "fixed_assets": "固定资产", "cip": "在建工程",
    "rou_assets": "使用权资产", "intangible_assets": "无形资产", "goodwill": "商誉",
    "lt_prepaid": "长期待摊费用", "other_noncurrent_assets": "其他非流动资产", "deferred_income": "递延收益",
}
asset_keys = ("ar", "receivables_financing", "prepayments", "other_receivables", "inventory",
              "current_maturity_assets", "other_current_assets")
liability_keys = ("accounts_payable", "contract_liabilities", "employee_payable", "taxes_payable",
                  "other_payables", "other_current_liabilities")
long_keys = ("fixed_assets", "cip", "rou_assets", "intangible_assets", "goodwill", "lt_prepaid", "other_noncurrent_assets")
required_cash = {2022: 130000000.0, 2023: 140000000.0, 2024: 150000000.0, 2025: 150000000.0}

for year, row in balance.items():
    for key in (*asset_keys, *liability_keys, *long_keys, "deferred_income"):
        fact(f"bs{year}_{key}", labels[key], row[key], f"{year}-12-31", row["source_year"], row["locator"])
    owc_expr = "+".join(f"bs{year}_{k}" for k in asset_keys) + "-(" + "+".join(f"bs{year}_{k}" for k in liability_keys) + ")"
    long_expr = "+".join(f"bs{year}_{k}" for k in long_keys) + f"-bs{year}_deferred_income"
    field("capital", "operating_working_capital", year=year, expression=owc_expr, basis="formula",
          reason="将酒类存货、经营应收预付减无息经营负债；其他应收应付整体纳入，因非经营部分不重大。", confidence="medium")
    field("capital", "operating_long_term_assets_net", year=year, expression=long_expr, basis="formula",
          reason="固定资产、在建工程、使用权资产、无形资产、商誉、长期待摊和经营性预付款减递延收益；非经营投资另列。", confidence="medium")
    field("capital", "required_cash", year=year, value=required_cash[year], basis="estimate",
          reason="约覆盖一个月采购、人员、营销与税费现金支出，并随经营规模由1.30亿元提升至1.50亿元。", confidence="medium",
          falsifiers=("月度现金支出、季节性备付或授信资料显示最低现金显著高于或低于该值。",))
    field("capital", "unsupported_intangible_assets", year=year, expression=f"bs{year}_goodwill", basis="formula",
          reason="商誉未披露可单独验证的现金收益来源，按项目纪律从经营投入中剔除。", confidence="high")

# Latest-year equity-value bridge facts.
fact("y2025_cash_equivalents", "期末现金及现金等价物余额", 2027905158.26, "2025-12-31", 2025,
     "PDF第140页，现金流量表补充资料")
fact("y2025_trading_financial_assets", "交易性金融资产", 86645392.20, "2025-12-31", 2025,
     "PDF第56页，合并资产负债表")
fact("y2025_long_term_equity", "长期股权投资", 4675026.32, "2025-12-31", 2025,
     "PDF第56页，合并资产负债表")
fact("y2025_investment_property", "投资性房地产", 24896571.98, "2025-12-31", 2025,
     "PDF第56页，合并资产负债表")
fact("y2025_current_lease", "一年内到期的非流动负债", 2144644.10, "2025-12-31", 2025,
     "PDF第57页，合并资产负债表")
fact("y2025_lease", "租赁负债", 3436593.80, "2025-12-31", 2025,
     "PDF第57页，合并资产负债表")
fact("y2025_minority_book", "少数股东权益", 37865421.03, "2025-12-31", 2025,
     "PDF第58页，合并资产负债表")
fact("y2025_total_shares", "期末总股本", 911542413.00, "2025-12-31", 2025,
     "PDF第2页，利润分配预案；第58页，股本")

field("equity", "excess_cash", value=1877905158.26, basis="estimate",
      reason="期末现金及现金等价物20.279亿元减经营必需现金1.50亿元；不把受限资金当作可分配现金。", confidence="medium",
      falsifiers=("产业园未支付承诺、受限资金或季节性备付需求显著超过现有披露。",))
field("equity", "non_operating_assets", expression="y2025_trading_financial_assets+y2025_long_term_equity+y2025_investment_property",
      basis="formula", reason="未参与核心FCFF的交易性金融资产、长期股权投资与投资性房地产按账面值合计。", confidence="medium")
field("equity", "financing_debt", expression="y2025_current_lease+y2025_lease", basis="formula",
      reason="公司无银行借款；按融资口径扣除一年内到期及长期租赁负债。")
field("equity", "minority_interest_value", expression="y2025_minority_book", basis="formula",
      reason="子公司独立估值资料不足，以少数股东账面权益作为经济价值替代值。", confidence="low")
field("equity", "other_priority_claims", value=0, basis="estimate",
      reason="未见优先股、永续债或尚未进入经营资本的重大优先索偿；拟分红仍归报告日普通股股东。", confidence="medium",
      falsifiers=("期后披露重大未付款资本承诺、优先工具或法律索偿。",))
field("equity", "diluted_shares", expression="y2025_total_shares", basis="reported",
      reason="回购股份拟用于员工持股或股权激励，为保守反映潜在再发行，完全摊薄股数使用法定总股本。")
field("equity", "financial_to_trading_fx", value=1, basis="estimate",
      reason="财报与A股交易均以人民币计价。", confidence="high",
      falsifiers=("证券交易币种发生变化。",))

# Stable benchmark: current revenue and margin are normalized; full industrial-park depreciation
# is matched by maintenance capex, while no perpetual working-capital growth is assumed.
field("stable", "revenue", value=1850000000, basis="estimate",
      reason="取2023—2025年17.84—19.36亿元区间的中部，不外推尚未验证的全国化目标。", confidence="medium",
      falsifiers=("连续两年收入稳定高于20亿元或低于17亿元。",))
field("stable", "cost_of_revenue", value=1156250000, basis="estimate",
      reason="对应37.5%毛利率，接近三年约37%的实际区间。", confidence="medium",
      falsifiers=("产品结构或原料价格令毛利率连续两年偏离35%—40%。",))
field("stable", "period_operating_expenses", value=488750000, basis="estimate",
      reason="使稳定EBIT约2.05亿元，位于剔除非经营收益后的三年1.93—2.36亿元区间。", confidence="medium",
      falsifiers=("产业园新增折旧或全国化营销使重构EBIT连续两年低于1.8亿元，或效率释放使其高于2.5亿元。",))
field("stable", "cash_tax", value=51250000, basis="estimate",
      reason="按稳定EBIT 2.05亿元及主要经营主体25%所得税率估算。", confidence="medium",
      falsifiers=("长期有效经营税率显著偏离25%。",))
field("stable", "depreciation_amortization", value=120000000, basis="estimate",
      reason="产业园转固后较2025年0.99亿元折旧摊销留出完整年度增量。", confidence="low",
      falsifiers=("产业园全面转固后的年度折旧摊销披露显著偏离1.2亿元。",))
field("stable", "core_business_capex", value=120000000, basis="estimate",
      reason="稳定期以折旧摊销作为维持现有黄酒产能、环保和技改的现金投入基准。", confidence="low",
      falsifiers=("产业园稳定运营后连续三年净经营资本开支显著偏离折旧摊销。",))
field("stable", "exploratory_business_capex", value=0, basis="estimate",
      reason="没有足够证据为白酒、果酒、文旅等选项设定可持续独立资本预算。", confidence="low",
      falsifiers=("公司披露可核验的新业务资本计划、商业化进度与回报。",))
field("stable", "operating_working_capital_increase", value=0, basis="estimate",
      reason="固定收入稳定状态不假设永久新增营运资金；库存释放也不永久外推。", confidence="medium",
      falsifiers=("常态库存陈化或账期结构要求每年持续净增加经营营运资金。",))

run("add-business", "--model", MODEL, "--business-id", "premium_wine", "--name", "中高档黄酒",
    "--importance", "贡献2025年72.6%收入、85.6%毛利，是品牌、年份原酒与全国化投入的主要回报来源。",
    "--confidence", "medium", "--falsifier", "按产品披露的费用、税费或现金回款显示其利润贡献显著不同。")
run("add-business", "--model", MODEL, "--business-id", "mass_and_support", "--name", "大众黄酒及生产配套",
    "--importance", "覆盖普通黄酒、少量玻璃制品及未列入主营产品表的生产配套收入，完整闭合公司合并总量。",
    "--confidence", "low", "--falsifier", "公司披露普通酒和配套业务的独立费用、税费或现金流。")

business_values = {
    "premium_wine": dict(revenue=1328589266.11, cost=738357010.83, expenses=424735166.7874846,
                         tax=41374272.12312882, ocf=288640442.9040322,
                         note="收入成本为分产品直接披露；费用、经营税和现金流按毛利/NOPAT比例分配。"),
    "mass_and_support": dict(revenue=502251419.38, cost=402731026.20, expenses=71615555.43251543,
                             tax=6976209.436871191, ocf=48668316.765967906,
                             note="普通酒毛利较薄；配套收入用于闭合合并口径，费用与现金流为低可信基准估计。"),
}
for bid, row in business_values.items():
    if bid == "premium_wine":
        rev_expr, cost_expr = "y2025_premium_revenue", "y2025_premium_cost"
    else:
        rev_expr, cost_expr = "y2025_revenue-y2025_premium_revenue", "y2025_cost-y2025_premium_cost"
    for key, value, why in (
        ("revenue", row["revenue"], "中高档酒为直接披露；大众及配套为公司合计扣除中高档酒。"),
        ("cost_of_revenue", row["cost"], "中高档酒为直接披露；大众及配套为公司合计扣除中高档酒。"),
        ("period_operating_expenses", row["expenses"], "财报未按产品拆费用，按各业务毛利占比分配，避免低毛利业务承担不现实的同收入费率。"),
        ("cash_tax", row["tax"], "按各业务重构EBIT及25%税率分配公司经营现金税。"),
        ("operating_cash_flow_contribution", row["ocf"], "按业务NOPAT占比分配合并经营现金流，保持公司总量闭合。"),
    ):
        if key in {"revenue", "cost_of_revenue"}:
            run("set-business-field", "--model", MODEL, "--business-id", bid, "--field", key,
                "--expression", rev_expr if key == "revenue" else cost_expr, "--basis-type", "formula",
                "--reason", why, "--confidence", "high" if bid == "premium_wine" else "medium")
        else:
            run("set-business-field", "--model", MODEL, "--business-id", bid, "--field", key,
                "--value", value, "--basis-type", "estimate", "--reason", why, "--confidence", "low",
                "--falsifier", "公司披露按产品的费用、税费、回款或经营现金流。")

fact("y2025_premium_revenue", "中高档酒营业收入", 1328589266.11, "2025-01-01至2025-12-31", 2025,
     "PDF第13页，主营业务分产品")
fact("y2025_premium_cost", "中高档酒营业成本", 738357010.83, "2025-01-01至2025-12-31", 2025,
     "PDF第13页，主营业务分产品")

run("set-valuation", "--model", MODEL, "--mode", "benchmark",
    "--reason", "产业园虽已投产，但全国化收入、完整年度折旧、持续资本投入与逐年FCFF路径证据不足，使用稳定经营收益八倍固定标尺。",
    "--stable-multiple", 8, "--safety-margin-ratio", 0.6)
run("add-adjustment", "--model", MODEL, "--name", "2023年沈永和酒厂拆迁处置收益",
    "--before", "资产处置收益2.562亿元计入营业利润", "--after", "从核心EBIT与稳定收益剔除",
    "--reason", "2023年报第166页披露一期拆迁确认处置收益2.549亿元；不可重复发生，但相关处置现金按净资本开支口径进入当年实际FCFF。")
run("add-adjustment", "--model", MODEL, "--name", "现金到股东可分配现金",
    "--before", "现金及现金等价物20.279亿元", "--after", "多余现金18.779亿元",
    "--reason", "保留1.50亿元经营必需现金；若产业园未付款承诺或季节性备付更高，该项需下调。")
run("add-adjustment", "--model", MODEL, "--name", "无法解释商誉",
    "--before", "账面商誉0.232亿元", "--after", "经营投入中扣除0.232亿元",
    "--reason", "未披露可单独验证的持续现金收益，不因账面存在自动赋予经营价值。")

reviews = {
    "capital_return_interpretability": "平均投入资本为约36—39亿元且口径连续，ROIC具有方向性；经营必需现金及其他应收应付分类仍属中等可信，正文不将其夸大为护城河证据。",
    "source_traceability": "三年损益、现金流与资本字段均追溯至对应年度上交所年报页码；估计项列明依据及可推翻条件。",
    "economic_classification": "财务收益、投资与资产处置从核心EBIT剔除；产业园归入现有黄酒主业，金融资产和投资物业另列非经营资产。",
    "stable_state": "稳定状态采用三年收入与利润区间、产业园投产后折旧风险和零永久营运资金增长，未机械使用单年高点或管理层目标。",
    "report_consistency": "报告重大数字、业务闭合、价值桥和中心判断均以本结构化模型为唯一数量底稿。",
}
for item, reason in reviews.items():
    run("set-review", "--model", MODEL, "--item", item, "--passed", "--reason", reason)

run("compile", "--model", MODEL)

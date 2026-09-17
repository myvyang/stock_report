#!/usr/bin/env python3
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent
TOOL = ROOT / ".agents/skills/stock-research/scripts/stock_research.py"
MODEL = ROOT / "outputs/analysis.json"


def run(*args):
    subprocess.run(["python3", str(TOOL), *map(str, args)], cwd=ROOT, check=True)


def fact(fid, item, amount, period, year, page):
    urls = {
        2023: "https://static.cninfo.com.cn/finalpage/2024-04-02/1219491122.PDF",
        2024: "https://static.cninfo.com.cn/finalpage/2025-04-22/1223194371.PDF",
        2025: "https://static.cninfo.com.cn/finalpage/2026-04-15/1225104020.PDF",
    }
    run("add-fact", "--model", MODEL, "--fact-id", fid, "--reported-item", item,
        "--amount", amount, "--period", period, "--currency", "人民币",
        "--scope", "合并", "--source", f"哈尔斯{year}年年度报告 {urls[year]}",
        "--locator", f"PDF第{page}页")


def field(view, key, *, year=None, value=None, expr=None, basis="estimate", reason, confidence="medium", falsifier=None, observed_at=None):
    args = ["set-field", "--model", MODEL, "--view", view, "--field", key]
    if year is not None:
        args += ["--year", year]
    args += (["--expression", expr] if expr is not None else ["--value", value])
    args += ["--basis-type", basis, "--reason", reason, "--confidence", confidence]
    for item in falsifier or []:
        args += ["--falsifier", item]
    if observed_at:
        args += ["--observed-at", observed_at]
    run(*args)


def business(bid, name, importance, confidence="medium", falsifier=None):
    args = ["add-business", "--model", MODEL, "--business-id", bid, "--name", name,
            "--importance", importance, "--confidence", confidence]
    for item in falsifier or []:
        args += ["--falsifier", item]
    run(*args)


def bfield(bid, key, value, reason, confidence="medium", falsifier=None):
    args = ["set-business-field", "--model", MODEL, "--business-id", bid, "--field", key,
            "--value", value, "--basis-type", "estimate", "--reason", reason,
            "--confidence", confidence]
    for item in falsifier or ["公司披露按业务模式划分的收入、成本、费用、税和经营现金流"]:
        args += ["--falsifier", item]
    run(*args)


MODEL.parent.mkdir(exist_ok=True)
run("init", "--name", "哈尔斯", "--code", "002615.SZ", "--period-label", "2025年年度报告",
    "--period-end", "2025-12-31", "--coverage-years", "2023,2024,2025",
    "--financial-currency", "人民币", "--trading-currency", "人民币",
    "--security-name", "A股普通股", "--security-unit", "股", "--output", MODEL)

# 利润表、现金流量表与现金流补充资料原始事实。
ops = {
    2023: dict(revenue=2407120446.72, cost=1656176856.04, taxes=18426831.07,
               selling=232308446.24, admin=170723416.50, rd=95480814.73,
               other_income=17780020.08, credit=-1061421.25, asset=-39338723.31,
               ocf=242663020.57, purchase_capex=193123465.80, disposal=4745885.85,
               interest_income=19441149.42, fixed_da=77031912.12, rou_da=16194736.72,
               intang_da=13844143.84, prepaid_da=2414399.83),
    2024: dict(revenue=3331522170.62, cost=2398796427.47, taxes=21038707.27,
               selling=283748167.13, admin=214438013.02, rd=122449632.64,
               other_income=13553390.43, credit=-582339.49, asset=-25520301.72,
               ocf=462832846.15, purchase_capex=546886284.16, disposal=59860612.74,
               interest_income=29405028.81, fixed_da=81932148.29, rou_da=13286158.84,
               intang_da=16123651.65, prepaid_da=2855326.90),
    2025: dict(revenue=3238218488.18, cost=2418979090.63, taxes=24874623.74,
               selling=314920360.93, admin=228376724.91, rd=136862202.03,
               other_income=12776216.26, credit=2194436.65, asset=-31476843.12,
               ocf=296566153.49, purchase_capex=509320809.14, disposal=6131578.56,
               interest_income=15682654.19, fixed_da=101885942.00, rou_da=18218171.38,
               intang_da=12576308.93, prepaid_da=4302769.68),
}
labels = {
    "revenue": "营业收入", "cost": "营业成本", "taxes": "税金及附加",
    "selling": "销售费用", "admin": "管理费用", "rd": "研发费用",
    "other_income": "其他收益", "credit": "信用减值损失/收益",
    "asset": "资产减值损失", "ocf": "经营活动产生的现金流量净额",
    "purchase_capex": "购建固定资产、无形资产和其他长期资产支付的现金",
    "disposal": "处置固定资产、无形资产和其他长期资产收回的现金净额",
    "interest_income": "利息收入", "fixed_da": "固定资产折旧",
    "rou_da": "使用权资产折旧", "intang_da": "无形资产摊销",
    "prepaid_da": "长期待摊费用摊销",
}
pages = {2023: {"main": 84, "cash": 87, "da": 162}, 2024: {"main": 79, "cash": 82, "da": 157}, 2025: {"main": 72, "cash": 75, "da": 143}}
for y, row in ops.items():
    for k, amount in row.items():
        page = pages[y]["cash"] if k in {"ocf", "purchase_capex", "disposal"} else pages[y]["da"] if k.endswith("_da") else pages[y]["main"]
        fact(f"f_{y}_{k}", labels[k], amount, f"{y}年度", y, page)

    field("historical", "revenue", year=y, expr=f"f_{y}_revenue", basis="reported", reason="合并利润表营业收入", confidence="high")
    field("historical", "cost_of_revenue", year=y, expr=f"f_{y}_cost", basis="reported", reason="合并利润表营业成本", confidence="high")
    expense_expr = f"f_{y}_taxes+f_{y}_selling+f_{y}_admin+f_{y}_rd-f_{y}_other_income-f_{y}_credit-f_{y}_asset"
    field("historical", "period_operating_expenses", year=y, expr=expense_expr, basis="formula",
          reason="税金及附加、销售、管理、研发费用，扣除其他收益并纳入日常信用与资产减值；剔除财务费用、投资收益和资产处置收益", confidence="medium")
    ebit = row["revenue"] - row["cost"] - (row["taxes"] + row["selling"] + row["admin"] + row["rd"] - row["other_income"] - row["credit"] - row["asset"])
    cash_tax = max(ebit, 0) * 0.15
    field("historical", "cash_tax", year=y, value=cash_tax, reason="以母公司高新技术企业15%税率估计无杠杆经营现金税，消除递延税与非经营损益造成的年度异常", confidence="medium",
          falsifier=["税务附注显示主要利润长期适用不同税率或现金税优惠不可持续"])
    field("historical", "depreciation_amortization", year=y,
          expr=f"f_{y}_fixed_da+f_{y}_rou_da+f_{y}_intang_da+f_{y}_prepaid_da", basis="formula",
          reason="现金流补充资料四类经营折旧摊销合计", confidence="high")
    field("historical", "core_business_capex", year=y, expr=f"f_{y}_purchase_capex-f_{y}_disposal", basis="formula",
          reason="长期资产购建现金减处置回款；泰国基地和智创园服务既有杯壶制造，归入主营业务资本开支", confidence="medium")
    field("historical", "exploratory_business_capex", year=y, value=0,
          reason="未发现可与既有杯壶制造和品牌经营可靠分离的新业务资本开支", confidence="medium",
          falsifier=["后续披露资本开支投向全新商业化业务且可单独核算"])
    field("historical", "operating_cash_flow", year=y, expr=f"f_{y}_ocf", basis="reported", reason="合并现金流量表经营现金流净额", confidence="high")
    field("historical", "after_tax_interest_in_operating_cash_flow", year=y,
          expr=f"0-f_{y}_interest_income*0.85", basis="formula", reason="剔除经营现金流中多余现金利息收入，按15%税率税后化", confidence="medium")
    da = row["fixed_da"] + row["rou_da"] + row["intang_da"] + row["prepaid_da"]
    nopat = ebit - cash_tax
    interest_adj = -row["interest_income"] * 0.85
    wc_reinvestment = nopat + da - row["ocf"] - interest_adj
    field("historical", "operating_working_capital_increase", year=y, value=wc_reinvestment,
          reason="以利润路径和剔除税后利息收入后的经营现金流反推现金性经营再投入；包含报表营运资金项目与经营性应计调整的净影响", confidence="medium",
          falsifier=["公司披露完整经营性营运资金现金变动对账并能分离准备、递延税和股份支付"])

# 资产负债表经营资本。经营营运资金按同一组经营性流动项目逐年计算。
balance = {
    2022: dict(ar=152047393.20, arf=23187627.56, pre=7282787.63, oar=12360885.29, inv=413274838.43, ca=0, oca=8828144.71,
               np=82880000, ap=366111252.58, contract=46842367.94, payroll=68837386.28, tax=20528570.62, op=29087019.31, ocl=613786.17,
               fixed=647081903.19, cip=60031018.96, rou=26648964.05, intangible=79898319.86, goodwill=17432184.24, prepaid=2760012.55, ona=3485689.81, deferred=9124256.06),
    2023: dict(ar=226090262.12, arf=113373914.35, pre=10569243.34, oar=20652820.28, inv=495384134.44, ca=52234700.79, oca=20195820.52,
               np=89124596, ap=534776162, contract=29154447.35, payroll=84502389.86, tax=13957539.92, op=22588083.75, ocl=880706.85,
               fixed=713937884.23, cip=16437968.93, rou=12902342.40, intangible=106276365.01, goodwill=17432184.24, prepaid=3579916.91, ona=33878656.52, deferred=10055685.64),
    2024: dict(ar=377043158.34, arf=17895558.86, pre=9861831.46, oar=23160651.29, inv=536589145.33, ca=0, oca=45216857.53,
               np=127314470.35, ap=742023964.03, contract=36148532.30, payroll=99497709.17, tax=19976564.48, op=33343907.27, ocl=1263515.46,
               fixed=750496140.69, cip=383274623.32, rou=63929001.83, intangible=218671794.06, goodwill=17432184.24, prepaid=6693488.91, ona=41205532.44, deferred=13756698.56),
    2025: dict(ar=303207491.09, arf=38394228.33, pre=7800584.67, oar=57512382.69, inv=639137242.02, ca=0, oca=64420388.91,
               np=171861553.01, ap=876014385.57, contract=67457693.94, payroll=110886864.09, tax=11621416.57, op=36235884.66, ocl=1298029.56,
               fixed=1101443785.53, cip=519015758.50, rou=58033603.15, intangible=211408966.39, goodwill=17432184.24, prepaid=15043020.16, ona=14561184.86, deferred=17379778.11),
}
b_labels = dict(ar="应收账款", arf="应收款项融资", pre="预付款项", oar="其他应收款", inv="存货", ca="合同资产", oca="其他流动资产",
                np="应付票据", ap="应付账款", contract="合同负债", payroll="应付职工薪酬", tax="应交税费", op="其他应付款", ocl="其他流动负债",
                fixed="固定资产", cip="在建工程", rou="使用权资产", intangible="无形资产", goodwill="商誉", prepaid="长期待摊费用", ona="其他非流动资产", deferred="递延收益")
for y, row in balance.items():
    src_year = 2023 if y in (2022, 2023) else y
    page = 79 if src_year == 2023 else 74 if src_year == 2024 else 67
    for k, amount in row.items():
        fact(f"f_{y}_{k}", b_labels[k], amount, f"{y}-12-31", src_year, page + (1 if k in {"fixed","cip","rou","intangible","goodwill","prepaid","ona"} else 0))
    assets = "+".join(f"f_{y}_{k}" for k in ("ar","arf","pre","oar","inv","ca","oca"))
    liabilities = "+".join(f"f_{y}_{k}" for k in ("np","ap","contract","payroll","tax","op","ocl"))
    field("capital", "operating_working_capital", year=y, expr=f"{assets}-({liabilities})", basis="formula",
          reason="经营性应收、预付、存货及其他流动资产减无息经营负债", confidence="medium")
    lt = "+".join(f"f_{y}_{k}" for k in ("fixed","cip","rou","intangible","goodwill","prepaid","ona"))
    field("capital", "operating_long_term_assets_net", year=y, expr=f"{lt}-f_{y}_deferred", basis="formula",
          reason="经营性长期资产减资产相关递延收益；商誉先纳入再单独剔除", confidence="medium")
    req_cash = {2022: 202000000, 2023: 186000000, 2024: 259000000, 2025: 272000000}[y]
    field("capital", "required_cash", year=y, value=req_cash,
          reason="约一个月经营现金流出，覆盖工资、采购和税费结算的最低流动性", confidence="medium",
          falsifier=["月度现金支出、季节性和可用授信资料显示显著不同的最低现金需求"])
    field("capital", "unsupported_intangible_assets", year=y, expr=f"f_{y}_goodwill", basis="reported",
          reason="商誉未能由可分离的增量经营收益解释，按纪律从投入资本中剔除", confidence="high")

# 2025年业务树：泰国收入和亏损直接披露，其余根据地区、客户集中度和组织职责估计并闭合。
fact("f_2025_thai_revenue", "哈尔斯（泰国）营业收入", 451264512.08, "2025年度", 2025, 24)
fact("f_2025_thai_profit", "哈尔斯（泰国）利润总额", -53082577.97, "2025年度", 2025, 24)
fact("f_2025_top5_sales", "前五名客户销售额", 2214843270.31, "2025年度", 2025, 17)

business("china_oem", "中国基地OEM/ODM", "核心客户订单、研发转化和中国制造交付构成收入与现金主体", "medium", ["公司披露生产基地及业务模式分部损益"])
business("thai_oem", "泰国基地OEM爬坡", "已投产海外制造基地，2025年收入4.51亿元但仍亏损", "medium", ["泰国基地披露毛利、费用及经营现金流"])
business("brands", "自有品牌OBM", "哈尔斯与SIGG面向消费者和经销渠道，承担品牌、渠道与库存风险", "low", ["公司披露OBM独立审计损益和现金流"])

business_rows = {
    "china_oem": (2206953976.10, 1643979090.63, 401540101.82, 14654894.3595, 320000000.00),
    "thai_oem": (451264512.08, 465000000.00, 40000000.00, 0.00, -65000000.00),
    "brands": (580000000.00, 310000000.00, 280000000.00, 0.00, 41566153.49),
}
for bid, (rev, cost, exp, tax, ocf) in business_rows.items():
    bfield(bid, "revenue", rev, "泰国收入直接披露；其余以合并收入、前五客户销售和渠道/地区证据残差估计")
    bfield(bid, "cost_of_revenue", cost, "以泰国爬坡低毛利、品牌较高毛利和合并成本为约束估计")
    bfield(bid, "period_operating_expenses", exp, "按OEM研发交付、泰国本地化和品牌渠道投放的资源强度分配并闭合")
    bfield(bid, "cash_tax", tax, "亏损业务不分配现金税，正EBIT业务承担公司估计经营现金税")
    bfield(bid, "operating_cash_flow_contribution", ocf, "按利润、折旧及爬坡库存/应付结构估计并闭合合并经营现金流")

# 稳定期：不采用2024高点或2025爬坡低点，使用可证伪的中枢基准。
stable = dict(revenue=3300000000, cost_of_revenue=2442000000, period_operating_expenses=620000000,
              cash_tax=35700000, depreciation_amortization=130000000, core_business_capex=150000000,
              exploratory_business_capex=0, operating_working_capital_increase=0)
stable_reasons = {
    "revenue": "以2024年33.32亿元和2025年32.38亿元为中枢，不外推管理层增长目标",
    "cost_of_revenue": "对应26%毛利率，介于2024年较好水平与2025年泰国爬坡低点之间",
    "period_operating_expenses": "保留品牌、研发与双基地组织支出，但剔除2025年部分爬坡低效",
    "cash_tax": "稳定EBIT按15%经营现金税率",
    "depreciation_amortization": "接近2025年折旧摊销并考虑新增资产全年化",
    "core_business_capex": "略高于稳定折旧，用于维持双基地、自动化和正常更新，不重复计入一次性建设高峰",
    "exploratory_business_capex": "没有可独立识别的新商业模式资本项目",
    "operating_working_capital_increase": "无增长稳定状态不假设永久新增营运资金",
}
for k, v in stable.items():
    field("stable", k, value=v, reason=stable_reasons[k], confidence="low" if k in {"cost_of_revenue","period_operating_expenses","core_business_capex"} else "medium",
          falsifier=["泰国基地达产后单位成本、品牌盈利和智创园维持投入披露改变稳定中枢"])

# 普通股价值桥，采用2025年末资产并反映报告出具前已完成的增发摊薄。
fact("f_2025_cash", "货币资金", 848486554.39, "2025-12-31", 2025, 67)
fact("f_2025_restricted_cash", "受限货币资金", 24298134.68, "2025-12-31", 2025, 21)
fact("f_2025_ltei", "长期股权投资", 16985209.47, "2025-12-31", 2025, 68)
fact("f_2025_oei", "其他权益工具投资", 269302.70, "2025-12-31", 2025, 68)
fact("f_2025_short_debt", "短期借款", 326134077.78, "2025-12-31", 2025, 68)
fact("f_2025_current_lt_debt", "一年内到期的非流动负债", 137199635.21, "2025-12-31", 2025, 69)
fact("f_2025_long_debt", "长期借款", 536732990.23, "2025-12-31", 2025, 69)
fact("f_2025_lease_debt", "租赁负债", 42698328.05, "2025-12-31", 2025, 69)
fact("f_2026_post_shares", "向特定对象发行后总股本", 559811722, "2026-04-03", 2025, 53)
fact("f_2026_net_proceeds", "向特定对象发行募集资金净额", 743031230.92, "2026-03-12", 2025, 52)

field("equity", "excess_cash", value=552188419.71,
      reason="2025年末货币资金减经营必需现金2.72亿元和受限资金0.243亿元；期后募集资金专用于智创园，不当作可分配现金", confidence="medium",
      falsifier=["募集资金用途改变并可无损分配，或最低经营现金需求显著变化"])
field("equity", "non_operating_assets", expr="f_2025_ltei+f_2025_oei", basis="formula",
      reason="未参与核心FCFF的长期股权和权益工具投资按账面净额计值", confidence="medium")
field("equity", "financing_debt", expr="f_2025_short_debt+f_2025_current_lt_debt+f_2025_long_debt+f_2025_lease_debt", basis="formula",
      reason="短期借款、一年内到期非流动负债、长期借款和租赁负债", confidence="high")
field("equity", "minority_interest_value", value=0,
      reason="2025年末少数股东权益为负且当年无少数股东损益，不给负值加回", confidence="medium",
      falsifier=["存在具有正经济价值且非上市公司全资拥有的并表业务"])
field("equity", "other_priority_claims", value=0,
      reason="年报明确2025年末无应披露重大承诺或或有事项；募集资金未计入多余现金，避免重复扣减", confidence="medium",
      falsifier=["出现未计入经营资本或融资负债的重大优先索偿"])
field("equity", "diluted_shares", expr="f_2026_post_shares", basis="reported",
      reason="报告出具前增发已经完成，按增发后注册股本体现摊薄；库存股未来用于激励，保守视作潜在摊薄", confidence="high")

run("set-valuation", "--model", MODEL, "--mode", "benchmark",
    "--reason", "泰国基地、智创园与品牌投入尚缺逐年FCFF和全部成长投入证据，采用稳定经营收益八倍固定标尺",
    "--stable-multiple", 8, "--safety-margin-ratio", 0.6)
run("add-adjustment", "--model", MODEL, "--name", "2026年期后定增",
    "--before", "2025年末4.663亿股、募集资金未到账", "--after", "完全摊薄5.598亿股；7.43亿元专户资金不列多余现金",
    "--reason", "定增在年报出具前完成，股数已增加；资金明确投入智创园，经营价值又未给项目额外上行，故不作为股东可立即取得的现金。")
run("add-adjustment", "--model", MODEL, "--name", "2023年资产处置收益",
    "--before", "利润表资产处置收益0.441亿元", "--after", "不计入核心EBIT",
    "--reason", "处置长期资产不是杯壶持续经营的订单、制造或品牌收益。")

reviews = {
    "capital_return_interpretability": "投入资本包含同口径营运资金、长期资产、必需现金并使用平均数；研发和品牌投入费用化使ROIC仅用于观察资本占用变化，不据此断言护城河。",
    "source_traceability": "全部财报直接数保存披露名称、期间、合并范围、年报URL和PDF页码。",
    "economic_classification": "财务费用、投资收益和处置收益从经营EBIT剔除；商誉、金融投资、多余现金与融资负债单独分类。",
    "stable_state": "稳定期结合2023—2025总量及2025业务结构，未机械采用2024高点或2025爬坡低点，关键假设均有推翻条件。",
    "report_consistency": "报告中心数字、业务合计、稳定收益和普通股价值均由本结构化模型生成。",
}
for item, reason in reviews.items():
    run("set-review", "--model", MODEL, "--item", item, "--passed", "--reason", reason)

run("compile", "--model", MODEL)

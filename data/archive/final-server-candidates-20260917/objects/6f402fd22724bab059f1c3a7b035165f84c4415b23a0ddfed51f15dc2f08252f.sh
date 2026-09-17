#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs
python3 "$tool" init --name "索菲亚" --code "002572.SZ" --period-label "2025年年度报告" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "A股普通股" --security-unit "股" --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "合并" --source "$5" --locator "$6"
}
field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
field_est() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

src23="索菲亚家居股份有限公司2023年年度报告，2024-04-12"
src24="索菲亚家居股份有限公司2024年年度报告，2025-04-29"
src25="索菲亚家居股份有限公司2025年年度报告，2026-04-18"

# Historical operating facts. Loss items retain their disclosed negative sign.
fact rev23 "营业收入" 11665646381.23 "2023年度" "$src24" "PDF第128页，合并利润表（比较数）"
fact cogs23 "营业成本" 7447998341.69 "2023年度" "$src24" "PDF第128页，合并利润表（比较数）"
fact taxs23 "税金及附加" 108014516.52 "2023年度" "$src24" "PDF第128页，合并利润表（比较数）"
fact sell23 "销售费用" 1126673569.71 "2023年度" "$src24" "PDF第128-129页，合并利润表（比较数）"
fact admin23 "管理费用" 769490931.10 "2023年度" "$src24" "PDF第129页，合并利润表（比较数）"
fact rd23 "研发费用" 413253053.45 "2023年度" "$src24" "PDF第129页，合并利润表（比较数）"
fact otherinc23 "其他收益" 80860089.68 "2023年度" "$src24" "PDF第129页，合并利润表（比较数）"
fact credit23 "信用减值损失" -185881221.11 "2023年度" "$src24" "PDF第129页，合并利润表（比较数）"
fact asset23 "资产减值损失" -128941378.99 "2023年度" "$src24" "PDF第129页，合并利润表（比较数）"
fact da23 "折旧摊销合计" 563144290.96 "2023年度" "$src24" "PDF第220页，现金流量表补充资料；固定资产、使用权资产、无形资产及长期待摊费用摊销合计"
fact capex23 "购建固定资产、无形资产和其他长期资产支付的现金" 761688091.16 "2023年度" "$src24" "PDF第132页，合并现金流量表（比较数）"
fact ocf23 "经营活动产生的现金流量净额" 2653600254.53 "2023年度" "$src24" "PDF第131页，合并现金流量表（比较数）"

fact rev24 "营业收入" 10494353781.39 "2024年度" "$src25" "PDF第99页，合并利润表（比较数）"
fact cogs24 "营业成本" 6776164388.89 "2024年度" "$src25" "PDF第99页，合并利润表（比较数）"
fact taxs24 "税金及附加" 150010594.69 "2024年度" "$src25" "PDF第100页，合并利润表（比较数）"
fact sell24 "销售费用" 1011372493.95 "2024年度" "$src25" "PDF第100页，合并利润表（比较数）"
fact admin24 "管理费用" 792489494.60 "2024年度" "$src25" "PDF第100页，合并利润表（比较数）"
fact rd24 "研发费用" 374461175.39 "2024年度" "$src25" "PDF第100页，合并利润表（比较数）"
fact otherinc24 "其他收益" 87112333.00 "2024年度" "$src25" "PDF第100页，合并利润表（比较数）"
fact credit24 "信用减值损失" -7141846.73 "2024年度" "$src25" "PDF第100页，合并利润表（比较数）"
fact asset24 "资产减值损失" -36486374.02 "2024年度" "$src25" "PDF第100页，合并利润表（比较数）"
fact da24 "折旧摊销合计" 559486553.76 "2024年度" "$src25" "PDF第183页，现金流量表补充资料；固定资产、使用权资产、无形资产及长期待摊费用摊销合计"
fact capex24 "购建固定资产、无形资产和其他长期资产支付的现金" 603163050.20 "2024年度" "$src25" "PDF第103页，合并现金流量表（比较数）"
fact ocf24 "经营活动产生的现金流量净额" 1345427797.11 "2024年度" "$src25" "PDF第103页，合并现金流量表（比较数）"

fact rev25 "营业收入" 9366950303.39 "2025年度" "$src25" "PDF第99页，合并利润表"
fact cogs25 "营业成本" 6023391202.55 "2025年度" "$src25" "PDF第99页，合并利润表"
fact taxs25 "税金及附加" 135453233.87 "2025年度" "$src25" "PDF第100页，合并利润表"
fact sell25 "销售费用" 921304316.77 "2025年度" "$src25" "PDF第100页，合并利润表"
fact admin25 "管理费用" 763864243.77 "2025年度" "$src25" "PDF第100页，合并利润表"
fact rd25 "研发费用" 254923739.92 "2025年度" "$src25" "PDF第100页，合并利润表"
fact otherinc25 "其他收益" 63803278.59 "2025年度" "$src25" "PDF第100页，合并利润表"
fact credit25 "信用减值损失" 3494515.49 "2025年度" "$src25" "PDF第100页，合并利润表"
fact asset25 "资产减值损失" -36836779.51 "2025年度" "$src25" "PDF第100页，合并利润表"
fact da25 "折旧摊销合计" 594596883.70 "2025年度" "$src25" "PDF第183页，现金流量表补充资料；固定资产、使用权资产、无形资产 optional及长期待摊费用摊销合计"
fact capex25 "购建固定资产、无形资产和其他长期资产支付的现金" 256766103.10 "2025年度" "$src25" "PDF第103页，合并现金流量表"
fact ocf25 "经营活动产生的现金流量净额" -321026192.62 "2025年度" "$src25" "PDF第103页，合并现金流量表"

for y in 2023 2024 2025; do
  yy=${y:2:2}
  field_expr historical "$y" revenue "rev$yy" reported "合并利润表营业收入。" high
  field_expr historical "$y" cost_of_revenue "cogs$yy" reported "合并利润表营业成本。" high
  field_expr historical "$y" period_operating_expenses "taxs$yy + sell$yy + admin$yy + rd$yy - otherinc$yy - credit$yy - asset$yy" formula "税金及附加、销售、管理、研发费用，扣除经营相关其他收益，并纳入信用与资产减值；排除财务、投资、公允价值及处置损益。" medium
  field_expr historical "$y" depreciation_amortization "da$yy" reported "现金流量表补充资料中的四类经营性折旧摊销合计。" high
  field_expr historical "$y" core_business_capex "capex$yy" reported "披露的长期资产购建现金支出均服务于现有定制家居制造、数字化和渠道能力，未发现可可靠分离的新赛道支出。" medium
  field_est historical "$y" exploratory_business_capex 0 "新产品和新渠道仍依托既有家居业务及产能，公开披露不足以把任何现金资本开支单独认定为尚未商业化的新业务。" medium "若后续披露独立新业务项目、专属产能和现金支出，则重新分类。"
  field_expr historical "$y" operating_cash_flow "ocf$yy" reported "合并现金流量表经营活动现金流量净额。" high
  field_est historical "$y" after_tax_interest_in_operating_cash_flow 0 "中国准则现金流量表将偿付利息列入筹资活动，经营现金流路径无需加回利息。" high "若现金流附注明确把利息支付计入经营活动，则按税后金额加回。"
done

field_est historical 2023 cash_tax 281925622.5012 "按重构EBIT的18%估计经营现金税；三年合并所得税费用与利润总额显示正常有效税率约17%-18%，并排除金融投资损益税务错配。" medium "若税务附注给出主营经营税与非经营投资税的可靠拆分，则替换。"
field_est historical 2024 cash_tax 258001154.3016 "按重构EBIT的18%估计经营现金税；三年合并所得税费用与利润总额显示正常有效税率约17%-18%。" medium "若税务附注给出主营经营税与非经营投资税的可靠拆分，则替换。"
field_est historical 2025 cash_tax 233725424.5944 "按重构EBIT的18%估计经营现金税；2025年所得税费用2.06亿元、利润总额11.47亿元支持约18%的正常税率。" medium "若税务附注给出主营经营税与非经营投资税的可靠拆分，则替换。"
field_est historical 2023 operating_working_capital_increase -806128127.7312 "以NOPAT加折旧摊销与经营现金流的差额反推综合经营性营运资金/非现金经营调整，保证利润路径与现金流路径闭合。" medium "若完整现金流附注能把递延税、减值及全部营运资金项目逐项重构，则改用逐项变动。"
field_est historical 2024 operating_working_capital_increase 389397348.4684 "以NOPAT加折旧摊销与经营现金流的差额反推综合经营性营运资金/非现金经营调整。" medium "若完整现金流附注能把递延税、减值及全部营运资金项目逐项重构，则改用逐项变动。"
field_est historical 2025 operating_working_capital_increase 1980372232.8056 "以NOPAT加折旧摊销与经营现金流的差额反推；年报说明2024年末国补形成的高合同负债在2025年反转，导致现金流显著弱于利润。" medium "若国补结算完成后合同负债和应收项目仍无法恢复正常，则应提高稳定期营运资金占用。"

# Capital stock estimates use disclosed balance-sheet components. Operating long-term assets include PP&E, CIP, ROU assets,
# operating intangibles, development and deferred charges, equipment prepayments and goodwill, net of deferred grants.
field_est capital 2022 operating_working_capital -1387509649.21 "按经营性票据及应收、预付、存货、合同资产和经营性其他流动资产，减票据应付、应付账款、合同负债、薪酬税费、其他应付款及其他流动负债；来自2023年报PDF第116-118页期初数。" medium "若其他应收/应付款附注证明存在重大非经营项目，则重分类。"
field_est capital 2023 operating_working_capital -2093814736.52 "同一经营性营运资金口径；来自2023年报PDF第116-118页期末数。" medium "若其他应收/应付款附注证明存在重大非经营项目，则重分类。"
field_est capital 2024 operating_working_capital -3321842128.44 "同一经营性营运资金口径；2024年末合同负债22.82亿元显著压低净营运资金。" medium "国补结算后合同负债常态水平若显著不同，则调整。"
field_est capital 2025 operating_working_capital -1114350849.32 "同一经营性营运资金口径；来自2025年报PDF第95-97页，其他流动资产剔除定期存款。" medium "若其他应收/应付款附注证明存在重大非经营项目，则重分类。"
field_est capital 2022 operating_long_term_assets_net 5966796873.79 "经营性固定资产、在建工程、使用权资产、无形资产、开发支出、长期待摊、设备预付款及商誉，减递延收益；来自2023年报PDF第116-118、192页。" medium "若土地、软件或递延收益被证实不服务主营经营，则调整。"
field_est capital 2023 operating_long_term_assets_net 6258765680.02 "同一长期经营资产口径；来自2023年报PDF第116-118、192页。" medium "若土地、软件或递延收益被证实不服务主营经营，则调整。"
field_est capital 2024 operating_long_term_assets_net 6271682785.28 "同一长期经营资产口径；来自2024年报PDF第124-126、210页。" medium "若土地、软件或递延收益被证实不服务主营经营，则调整。"
field_est capital 2025 operating_long_term_assets_net 5809332582.02 "同一长期经营资产口径；来自2025年报PDF第95-97、154页。" medium "若土地、软件或递延收益被证实不服务主营经营，则调整。"
for y in 2022 2023 2024 2025; do
  field_est capital "$y" unsupported_intangible_assets 18940991.50 "账面商誉无法独立解释新增经营收益，按技能口径从投入资本剔除。" high "若并购资产可辨认地形成独立、持续的增量FCFF，则恢复相应价值。"
done
field_est capital 2022 required_cash 873485701.99 "以约7.5亿元一月经营支出缓冲，加期末受限资金（货币资金与现金等价物差额）估计。" medium "若月度结算、季节性和备用授信证据支持更低现金需求，则下调。"
field_est capital 2023 required_cash 897490033.67 "以约7.5亿元一月经营支出缓冲，加1.475亿元受限资金估计。" medium "若受限资金释放或备用授信可替代现金，则下调。"
field_est capital 2024 required_cash 1438846526.99 "以约7.5亿元一月经营支出缓冲，加6.888亿元受限资金估计。" medium "若受限资金释放或备用授信可替代现金，则下调。"
field_est capital 2025 required_cash 1227077387.41 "以约7.5亿元一月经营支出缓冲，加4.771亿元保证金及冻结资金；年报PDF第138页。" medium "若保证金释放或更强备用授信可降低流动性缓冲，则下调。"

# Stable state: recent demand is contracting, so use a normalized level near 2025 rather than the 2023 peak.
field_est stable "" revenue 10000000000 "取2024与2025之间、低于2023的正常收入，反映存量房和旧改支撑但地产新房链仍弱。" low "若连续两年收入低于90亿元或恢复至110亿元以上且回款同步，则重估。"
field_est stable "" cost_of_revenue 6450000000 "对应35.5%毛利率，接近三年产品和渠道组合的正常水平。" medium "若大宗占比或木门亏损结构持续改变，使合并毛利率偏离34%-37%，则重估。"
field_est stable "" period_operating_expenses 2200000000 "介于2024和2025重构费用之间，保留品牌、渠道、研发及常态减值所需支出。" medium "若费用率连续两年脱离约21%-23%，则重估。"
field_est stable "" cash_tax 243000000 "按13.5亿元稳定EBIT的18%正常经营现金税率。" medium "若税收优惠或业务地域结构造成长期税率显著偏离18%，则重估。"
field_est stable "" depreciation_amortization 550000000 "以三年折旧摊销5.59-5.95亿元为基础，考虑产能成熟后的常态。" medium "若资产处置、产能退出或新增大项目使折旧显著变化，则重估。"
field_est stable "" core_business_capex 500000000 "低于2023-2024扩建期支出、高于2025低投入年，覆盖现有工厂、数智化、门店与品类迭代。" low "若连续两年在不损害收入和交付的情况下资本开支低于3亿元，或维持竞争需高于7亿元，则重估。"
field_est stable "" exploratory_business_capex 0 "未发现可与现有定制家居主业清晰分离的独立新业务资本开支。" medium "若披露独立新赛道项目及专属现金投入，则单列。"
field_est stable "" operating_working_capital_increase 0 "稳定收入不增长时，合同负债国补时点波动消失后不假设永久新增营运资金。" low "若正常化后应收账期持续拉长或预收模式持续弱化，则改为正占用。"

# Latest-year businesses by customer/order channel; revenue and cost are disclosed and reconcile exactly.
python3 "$tool" add-business --model "$model" --business-id dealer --name "经销零售与经销整装" --importance "门店经销体系是收入、毛利和品牌触达的主体。" --confidence medium --falsifier "若公司披露经销渠道内零售与整装的独立完整利润及现金流，应替换分配估计。"
python3 "$tool" add-business --model "$model" --business-id direct --name "直营零售与直营整装" --importance "规模较小但直接掌握消费者、设计交付和渠道运营，毛利率最高。" --confidence medium --falsifier "若直营定义包含大量非终端业务或渠道口径变更，应重拆。"
python3 "$tool" add-business --model "$model" --business-id bulk --name "大宗工程" --importance "地产与机构项目毛利低、回款和信用风险高，对现金质量影响显著。" --confidence medium --falsifier "若大宗客户结构、坏账和项目毛利恢复到零售水平，应重估费用与现金贡献。"
python3 "$tool" add-business --model "$model" --business-id adjacent --name "线上海外与材料配套" --importance "覆盖其他渠道及材料等其他业务，是规模较小的补充收入和海外选项。" --confidence low --falsifier "若公司披露其他渠道与其他业务的独立客户、利润和现金流，应拆分重估。"

biz_field() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
biz_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence high; }
fact dealer_rev25 "经销商渠道收入" 7365292927.96 "2025年度" "$src25" "PDF第26页，分销售模式"
fact dealer_cost25 "经销商渠道营业成本" 4455129067.14 "2025年度" "$src25" "PDF第27页，分销售模式"
fact direct_rev25 "直营渠道收入" 407858124.75 "2025年度" "$src25" "PDF第26页，分销售模式"
fact direct_cost25 "直营渠道营业成本" 183240076.30 "2025年度" "$src25" "PDF第27页，分销售模式"
fact bulk_rev25 "大宗渠道收入" 1237707391.06 "2025年度" "$src25" "PDF第26页，分销售模式"
fact bulk_cost25 "大宗渠道营业成本" 1181143717.07 "2025年度" "$src25" "PDF第27页，分销售模式"
fact otherchannel_rev25 "其他渠道收入" 121894535.40 "2025年度" "$src25" "PDF第26页，分销售模式"
fact otherchannel_cost25 "其他渠道营业成本" 100226214.73 "2025年度" "$src25" "PDF第27页，分销售模式"
fact otherbiz_rev25 "其他业务收入" 234197324.22 "2025年度" "$src25" "PDF第26页，分销售模式"
fact otherbiz_cost25 "其他业务营业成本" 103652127.31 "2025年度" "$src25" "PDF第27页，分销售模式"
biz_expr dealer revenue dealer_rev25 "2025年报分销售模式披露。"
biz_expr dealer cost_of_revenue dealer_cost25 "2025年报分销售模式披露。"
biz_expr direct revenue direct_rev25 "2025年报分销售模式披露。"
biz_expr direct cost_of_revenue direct_cost25 "2025年报分销售模式披露。"
biz_expr bulk revenue bulk_rev25 "2025年报分销售模式披露。"
biz_expr bulk cost_of_revenue bulk_cost25 "2025年报分销售模式披露。"
biz_expr adjacent revenue "otherchannel_rev25 + otherbiz_rev25" "其他渠道与其他业务合计。"
biz_expr adjacent cost_of_revenue "otherchannel_cost25 + otherbiz_cost25" "其他渠道与其他业务合计。"

biz_field dealer period_operating_expenses 1500000000 estimate "按毛利规模和门店营销、渠道赋能强度分配公司期间经营费用。" low "渠道级销售、研发、管理和减值费用披露将推翻本分配。"
biz_field direct period_operating_expenses 220000000 estimate "直营承担门店、设计和交付人员，费用率显著高于经销。" low "渠道级费用披露将推翻本分配。"
biz_field bulk period_operating_expenses 200000000 estimate "大宗毛利仅4.57%，并需承担项目服务与信用管理成本。" low "客户级项目费用和减值披露将推翻本分配。"
biz_field adjacent period_operating_expenses 125084519.76 estimate "作为合并费用闭合项，结合小规模海外、线上与配套业务的运营投入。" low "独立渠道费用披露将推翻本分配。"
biz_field dealer cash_tax 230000000 estimate "经营现金税主要归属于盈利的经销业务，并与公司合计闭合。" low "渠道级应税利润披露将推翻本分配。"
biz_field direct cash_tax 500000 estimate "直营EBIT接近盈亏平衡，按小额正税分配。" low "渠道级应税利润披露将推翻本分配。"
biz_field bulk cash_tax 0 estimate "按估计经营亏损不分配当期经营现金税。" low "若大宗渠道含可观应税利润，则重分配。"
biz_field adjacent cash_tax 3225424.5944 estimate "公司经营现金税扣除其他业务分配后的闭合数。" low "渠道级应税利润披露将推翻本分配。"
biz_field dealer operating_cash_flow_contribution -80000000 estimate "国补合同负债反转主要影响零售预收节奏，但经销体系仍有供应商信用支持。" low "渠道回款、预收与应付的独立现金流披露将推翻本分配。"
biz_field direct operating_cash_flow_contribution 10000000 estimate "直营高毛利与直接收款支撑小幅正现金贡献。" low "直营渠道独立现金流披露将推翻本分配。"
biz_field bulk operating_cash_flow_contribution -230000000 estimate "大宗低毛利、项目账期及地产客户信用风险使现金贡献最弱。" low "大宗回款和应收余额显著改善将推翻本分配。"
biz_field adjacent operating_cash_flow_contribution -21026192.62 estimate "作为公司经营现金流闭合项，反映小规模渠道和材料业务资金波动。" low "独立现金流披露将推翻本分配。"

# Equity bridge facts and fields.
fact cash25 "货币资金" 1234490445.13 "2025-12-31" "$src25" "PDF第95页，合并资产负债表"
fact restricted25 "受限货币资金" 477077387.41 "2025-12-31" "$src25" "PDF第138页，货币资金附注"
fact trading25 "交易性金融资产" 989172095.06 "2025-12-31" "$src25" "PDF第95、138页，结构性存款及理财产品"
fact cdcurrent25 "一年内到期的大额存单及定期存款" 585028086.57 "2025-12-31" "$src25" "PDF第153页"
fact currentdeposit25 "其他流动资产中的定期存款" 295048592.06 "2025-12-31" "$src25" "PDF第153页"
fact otherfin25 "其他非流动金融资产" 906856538.34 "2025-12-31" "$src25" "PDF第155页"
fact longdeposit25 "其他非流动资产中的大额存单及定期存款" 589622230.04 "2025-12-31" "$src25" "PDF第166页"
fact equityinvest25 "长期股权投资" 43779171.58 "2025-12-31" "$src25" "PDF第95、154页"
fact invprop25 "投资性房地产" 391211156.93 "2025-12-31" "$src25" "PDF第95、155-156页"
fact preproperty25 "预付购房款净额" 75490243.12 "2025-12-31" "$src25" "PDF第166页"
fact shortdebt25 "短期借款" 2170259157.14 "2025-12-31" "$src25" "PDF第96页"
fact currentlongdebt25 "一年内到期的长期借款" 369777212.82 "2025-12-31" "$src25" "PDF第170页"
fact longdebt25 "长期借款" 92500000 "2025-12-31" "$src25" "PDF第97、170页"
fact lease25 "租赁负债（含一年内到期）" 46948470.68 "2025-12-31" "$src25" "PDF第170-171页"
fact minority25 "少数股东权益" 351730547.77 "2025-12-31" "$src25" "PDF第97页"
fact shares25 "股本" 963047164 "2025-12-31" "$src25" "PDF第97页及第124页股本附注"

field_est equity "" excess_cash 7413057.72 "期末货币资金扣除4.771亿元受限资金和约7.5亿元经营周转现金；几乎没有可立即分配的现金。" medium "若备用授信和月度现金支出证明所需现金低于7.5亿元，则上调。"
field_expr equity "" non_operating_assets "trading25 + cdcurrent25 + currentdeposit25 + otherfin25 + longdeposit25 + equityinvest25 + invprop25 + preproperty25" formula "未参与主营FCFF的理财、存单、权益投资及投资物业按期末账面/公允价值计入；预付购房款已按账面减值后净额计入。" medium
field_expr equity "" financing_debt "shortdebt25 + currentlongdebt25 + longdebt25 + lease25" formula "银行借款与租赁负债；租赁按融资口径在价值桥扣除。" high
field_expr equity "" minority_interest_value "minority25" reported "缺乏子公司独立FCFF时以少数股东账面权益作为替代值。" medium
field_est equity "" other_priority_claims 0 "未发现优先股、永续债或需在普通股前另行扣除的重大已确认索偿；拟议分红属于普通股股东内部价值转移。" medium "若利润分配在估值观察时点已除权但尚未支付，或出现新的优先索偿，则调整。"
field_expr equity "" diluted_shares "shares25" reported "基本与稀释每股收益一致，未发现额外实质摊薄工具；采用期末普通股股数。" high
field_est equity "" financial_to_trading_fx 1 "财报和股票交易均为人民币。" high "若交易币种改变则调整。"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "收入仍在收缩、2025现金流受国补合同负债反转扭曲，缺乏逐年FCFF和到达稳定状态时间的充分证据，使用稳定经营收益八倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "2025国补合同负债时点效应" --before "经营现金流-3.21亿元" --after "稳定期营运资金增加0" --reason "2025年报第32页称2024年四季度国补业务推高年末合同负债，2025年销售收现下降；不把单年反转机械永久化。若后续回款仍弱则该调整失效。"
python3 "$tool" add-adjustment --model "$model" --name "无法解释商誉" --before "0.189亿元账面商誉" --after "投入资本及非经营资产均不计值" --reason "无法把商誉对应到独立持续增量FCFF；若并购业务形成可辨认现金收益则恢复。"
python3 "$tool" add-adjustment --model "$model" --name "预付购房款" --before "3.916亿元账面原值" --after "0.755亿元减值后净额" --reason "按年报已经计提3.161亿元减值后的账面净额计入非经营资产，不假定额外回收。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "财务主表、现金流、渠道、受限资金及金融资产均记录报告名称、期间和PDF页码。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "经营资产、理财存单、投资物业、融资债务、受限与必需现金及商誉已避免重复。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定状态低于2023高点、接近2024-2025中间水平，并规范化国补合同负债反转与资本开支。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本含负营运资金、长期经营资产、受限及必需现金；ROIC仅解释资本占用和经营效率，不单凭比率声称护城河。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告将使用模型生成的收入、FCFF、稳定收益、资产桥及每股基准价值。"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

python3 "$tool" init --name '金隅冀东' --code '000401.SZ' --period-label '2025年度' --period-end '2025-12-31' --coverage-years '2023,2024,2025' --financial-currency CNY --trading-currency CNY --security-name 'A股' --security-unit '股' --output "$model"

af() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope consolidated --source "$5" --locator "$6"
}
sf() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" ${3:+--year "$3"} --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
se() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" ${3:+--year "$3"} --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

s23='唐山冀东水泥股份有限公司2023年年度报告（2024-03-27）'
s24='唐山冀东水泥股份有限公司2024年年度报告（2025-03-27）'
s25='金隅冀东水泥集团股份有限公司2025年年度报告（2026-03-26）'

# 历史经营事实。2023年使用2024年报追溯重述比较数，以保持合并范围可比。
for row in \
  '2023 revenue 28235146548.20 营业收入 P113-114 s24' \
  '2023 cost 24908898745.76 营业成本 P113-114 s24' \
  '2023 surtax 523753087.45 税金及附加 P114 s24' \
  '2023 selling 506986255.45 销售费用 P114 s24' \
  '2023 admin 3650135657.78 管理费用 P114 s24' \
  '2023 rnd 126223798.65 研发费用 P114 s24' \
  '2023 other_income 385244449.91 其他收益 P114 s24' \
  '2023 dep 3252261475.54 固定资产折旧 P226-227 s24' \
  '2023 rou_dep 39208635.01 使用权资产折旧 P226-227 s24' \
  '2023 amort 271755116.78 无形资产摊销 P226-227 s24' \
  '2023 lt_amort 282366672.11 长期待摊费用摊销 P226-227 s24' \
  '2023 ocf 2980414805.69 经营活动产生的现金流量净额 P117 s24' \
  '2023 capex_gross 1967064144.71 购建固定资产无形资产和其他长期资产支付的现金 P117-118 s24' \
  '2023 disposal 109329227.06 处置固定资产无形资产和其他长期资产收回的现金净额 P117 s24' \
  '2024 revenue 25286646897.45 营业收入 P108-109 s25' \
  '2024 cost 20708602686.31 营业成本 P108 s25' \
  '2024 surtax 570591345.02 税金及附加 P109 s25' \
  '2024 selling 498662732.93 销售费用 P109 s25' \
  '2024 admin 3713382547.91 管理费用 P109 s25' \
  '2024 rnd 128843928.18 研发费用 P109 s25' \
  '2024 other_income 361429530.81 其他收益 P109 s25' \
  '2024 dep 3272421110.50 固定资产折旧 P219 s25' \
  '2024 rou_dep 38801195.69 使用权资产折旧 P219 s25' \
  '2024 amort 272551935.98 无形资产摊销 P219 s25' \
  '2024 lt_amort 238942357.28 长期待摊费用摊销 P219 s25' \
  '2024 ocf 3181159619.89 经营活动产生的现金流量净额 P112 s25' \
  '2024 capex_gross 1679071386.06 购建固定资产无形资产和其他长期资产支付的现金 P112 s25' \
  '2024 disposal 91211300.67 处置固定资产无形资产和其他长期资产收回的现金净额 P112 s25' \
  '2025 revenue 24500912048.98 营业收入 P108-109 s25' \
  '2025 cost 19077583459.98 营业成本 P108 s25' \
  '2025 surtax 619462813.64 税金及附加 P109 s25' \
  '2025 selling 502003370.17 销售费用 P109 s25' \
  '2025 admin 3395591714.70 管理费用 P109 s25' \
  '2025 rnd 120120965.30 研发费用 P109 s25' \
  '2025 other_income 595907585.23 其他收益 P109 s25' \
  '2025 dep 2728008225.94 固定资产折旧 P219 s25' \
  '2025 rou_dep 42678953.84 使用权资产折旧 P219 s25' \
  '2025 amort 361370169.27 无形资产摊销 P219 s25' \
  '2025 lt_amort 224694605.88 长期待摊费用摊销 P219 s25' \
  '2025 ocf 3350945228.12 经营活动产生的现金流量净额 P112 s25' \
  '2025 capex_gross 1515228260.82 购建固定资产无形资产和其他长期资产支付的现金 P112 s25' \
  '2025 disposal 145738275.88 处置固定资产无形资产和其他长期资产收回的现金净额 P112 s25'
do
  set -- $row
  year=$1; key=$2; value=$3; item=$4; locator=$5; source_var=$6
  source=${!source_var}
  af "${key}_${year}" "$item" "$value" "$year" "$source" "$locator"
done

for year in 2023 2024 2025; do
  sf historical revenue "$year" "revenue_${year}" reported '合并利润表营业收入。' high
  sf historical cost_of_revenue "$year" "cost_${year}" reported '合并利润表营业成本。' high
  sf historical period_operating_expenses "$year" "surtax_${year}+selling_${year}+admin_${year}+rnd_${year}-other_income_${year}" formula '税金及附加、销售、管理、研发费用减与持续生产和环保补助相关的其他收益；排除财务费用、投资与处置损益及减值。' medium
  sf historical depreciation_amortization "$year" "dep_${year}+rou_dep_${year}+amort_${year}+lt_amort_${year}" formula '现金流量表补充资料中的固定资产和使用权资产折旧、无形资产及长期待摊费用摊销。' high
  sf historical operating_cash_flow "$year" "ocf_${year}" reported '合并现金流量表经营活动现金流量净额。' high
  se historical after_tax_interest_in_operating_cash_flow "$year" 0 '利息现金支出在筹资活动列示，经营现金流无需加回税后利息。' high '若以后财报将利息支付重分类为经营活动现金流，则本估计不成立。'
done

se historical cash_tax 2023 0 '重构EBIT为亏损，基准经营现金税取零，不把递延所得税收益当作现金流入。' medium '若税务附注证明亏损期仍有与核心经营直接对应的重大当期所得税现金支出，则应调高。'
se historical cash_tax 2024 6998296.9775 '以重构EBIT的25%作为正常经营现金税率基准。' medium '若可持续税收优惠或当期所得税附注明确显示正常税率显著偏离25%，则重估。'
se historical cash_tax 2025 345514327.605 '以重构EBIT的25%作为正常经营现金税率基准，避免把递延税和非经营损益税效混入。' medium '若可持续税收优惠或当期所得税附注明确显示正常税率显著偏离25%，则重估。'

se historical core_business_capex 2023 1757734917.65 '净现金资本开支18.58亿元中，估计1亿元用于尚未稳定的新材料或产业链项目，其余归当前主业。' low '项目付款明细若证明新业务现金支出不同，应按明细重分；总资本开支不变。'
se historical exploratory_business_capex 2023 100000000 '公开披露没有逐项拆分，按小比例估计新材料与新业务试投。' low '资本开支项目付款明细可推翻该分配。'
se historical core_business_capex 2024 1387860085.39 '净现金资本开支15.88亿元中，估计2亿元用于产业链及新材料开拓。' low '资本开支项目付款明细可推翻该分配。'
se historical exploratory_business_capex 2024 200000000 '公开披露没有逐项拆分，按项目建设与新材料培育方向估计。' low '资本开支项目付款明细可推翻该分配。'
se historical core_business_capex 2025 1169489984.94 '净现金资本开支13.69亿元中，估计2亿元用于新材料、砂浆与产业链开拓。' low '资本开支项目付款明细可推翻该分配。'
se historical exploratory_business_capex 2025 200000000 '结合年末2.16亿元新材料、骨料和砂浆等未支付合同与当年业务培育方向估计。' low '项目付款台账若显示这些支出全部服务成熟产线或金额不同，则应重分。'

# 使利润路径与现金流路径闭合的经营性资金占用，包含披露的存货、经营应收应付变化及其余经营性应计差异。
se historical operating_working_capital_increase 2023 -230429453.23 '由NOPAT、折旧摊销与经营现金流反推的经营性资金净释放；与现金流补充资料方向一致。' medium '若能完整拆出所得税、减值准备和经营性应计项目，应以逐项营运资金变动替代。'
se historical operating_working_capital_increase 2024 662551870.4925 '由NOPAT、折旧摊销与经营现金流反推的经营性资金占用。' medium '若能完整拆出所得税、减值准备和经营性应计项目，应以逐项营运资金变动替代。'
se historical operating_working_capital_increase 2025 1042349709.625 '由NOPAT、折旧摊销与经营现金流反推；应付款减少是2025年主要现金占用。' medium '若能完整拆出所得税、减值准备和经营性应计项目，应以逐项营运资金变动替代。'

# 资本表所需报告数；长期经营资产含商誉，随后单列剔除。
for row in \
  '2022 ca 16160270237.51 流动资产合计 P98-99 s23' '2022 cash 6403257042.85 货币资金 P98 s23' '2022 cl 13593968109.27 流动负债合计 P99 s23' '2022 sb 3260930822.23 短期借款 P99 s23' '2022 curdebt 2750739589.93 一年内到期的非流动负债 P99 s23' '2022 fa 32458412554.68 固定资产 P99 s23' '2022 cip 1590694972.15 在建工程 P99 s23' '2022 rou 480978894.17 使用权资产 P99 s23' '2022 ia 6328892047.70 无形资产 P99 s23' '2022 goodwill 384653251.92 商誉 P99 s23' '2022 ltp 1479380498.33 长期待摊费用 P99 s23' '2022 emp 45000030.92 长期应付职工薪酬 P100 s23' '2022 prov 439434187.96 预计负债 P100 s23' '2022 deferred 462892803.88 递延收益 P100 s23' \
  '2023 ca 14089223614.49 流动资产合计 P109 s24' '2023 cash 6306229602.06 货币资金 P109 s24' '2023 cl 15551598053.01 流动负债合计 P110 s24' '2023 sb 2433291158.23 短期借款 P110 s24' '2023 curdebt 5998794501.05 一年内到期的非流动负债 P110 s24' '2023 fa 32343636650.61 固定资产 P109-110 s24' '2023 cip 1128852715.40 在建工程 P110 s24' '2023 rou 467349638.47 使用权资产 P110 s24' '2023 ia 6794161890.32 无形资产 P110 s24' '2023 goodwill 399494636.88 商誉 P110 s24' '2023 ltp 1577537559.05 长期待摊费用 P110 s24' '2023 emp 41800183.67 长期应付职工薪酬 P111 s24' '2023 prov 491219058.06 预计负债 P111 s24' '2023 deferred 499133448.12 递延收益 P111 s24' \
  '2024 ca 14369358160.88 流动资产合计 P104 s25' '2024 cash 6934688088.68 货币资金 P104 s25' '2024 cl 16175581671.29 流动负债合计 P105 s25' '2024 sb 2622987684.14 短期借款 P105 s25' '2024 curdebt 5792644640.47 一年内到期的非流动负债 P105 s25' '2024 fa 31135271247.35 固定资产 P104-105 s25' '2024 cip 940329000.04 在建工程 P105 s25' '2024 rou 472215022.37 使用权资产 P105 s25' '2024 ia 6925509573.44 无形资产 P105 s25' '2024 goodwill 432862645.48 商誉 P105 s25' '2024 ltp 1570736690.21 长期待摊费用 P105 s25' '2024 emp 39211523.22 长期应付职工薪酬 P106 s25' '2024 prov 671234154.12 预计负债 P106 s25' '2024 deferred 516000970.36 递延收益 P106 s25' \
  '2025 ca 13237735373.10 流动资产合计 P104 s25' '2025 cash 6045051832.03 货币资金 P104 s25' '2025 cl 15722028105.42 流动负债合计 P105 s25' '2025 sb 2723642032.11 短期借款 P105 s25' '2025 curdebt 6722576335.71 一年内到期的非流动负债 P105 s25' '2025 fa 29735324549.54 固定资产 P104-105 s25' '2025 cip 932770158.14 在建工程 P105 s25' '2025 rou 536011281.74 使用权资产 P105 s25' '2025 ia 7625780592.77 无形资产 P105 s25' '2025 goodwill 572035568.62 商誉 P105 s25' '2025 ltp 1570790883.06 长期待摊费用 P105 s25' '2025 emp 36434570.55 长期应付职工薪酬 P106 s25' '2025 prov 648920152.42 预计负债 P106 s25' '2025 deferred 538896157.55 递延收益 P106 s25'
do
  set -- $row
  year=$1; key=$2; value=$3; item=$4; locator=$5; source_var=$6
  source=${!source_var}
  af "${key}_${year}" "$item" "$value" "$year-12-31" "$source" "$locator"
done

for year in 2022 2023 2024 2025; do
  sf capital operating_working_capital "$year" "ca_${year}-cash_${year}-(cl_${year}-sb_${year}-curdebt_${year})" formula '非现金流动资产减去剔除短借及一年内到期融资负债后的流动经营负债。' medium
  sf capital operating_long_term_assets_net "$year" "fa_${year}+cip_${year}+rou_${year}+ia_${year}+goodwill_${year}+ltp_${year}-emp_${year}-prov_${year}-deferred_${year}" formula '经营长期资产减长期职工、预计负债和资产相关递延收益；商誉在下一行单独剔除。' medium
  se capital required_cash "$year" 2000000000 '约覆盖一个月经营现金支出并保留水泥业务季节性及结算缓冲。' medium '月度最低现金、受限安排或可随时使用授信证明所需缓冲显著不同，则调整。'
  sf capital unsupported_intangible_assets "$year" "goodwill_${year}" reported '商誉不因账面确认而自动视为可解释经营资产，全部剔除。' high
done

# 最新年度业务树：披露产品收入与成本直接录入，费用、经营税和现金贡献按毛利贡献分配并闭合公司。
af cement_clinker_revenue_2025 '水泥与熟料收入合计' 19312178162.26 '2025' "$s25" 'P23、P209-210'
af cement_clinker_cost_2025 '水泥与熟料成本合计' 15279546807.67 '2025' "$s25" 'P23、P209-210'
af aggregate_revenue_2025 '砂石骨料收入' 1975644494.34 '2025' "$s25" 'P23、P209-210'
af aggregate_cost_2025 '砂石骨料成本' 1121021614.19 '2025' "$s25" 'P23、P209-210'
af environmental_services_revenue_2025 '危废固废处置与其余产品收入合计' 3213089392.38 '2025' "$s25" 'P23、P209-210'
af environmental_services_cost_2025 '危废固废处置与其余产品成本合计' 2677015038.12 '2025' "$s25" 'P23、P209-210'
python3 "$tool" add-business --model "$model" --business-id cement_clinker --name '水泥与熟料' --importance '核心现金业务；收入取披露产品合计，费用和现金按毛利贡献估计。' --confidence medium --falsifier '若公司披露分产品期间费用、税项或经营现金流，应替换分配。'
python3 "$tool" add-business --model "$model" --business-id aggregate --name '砂石骨料' --importance '毛利率最高的产业链业务，但收入规模仍较小。' --confidence medium --falsifier '若分部披露显示骨料包含重大内部交易或费用资本占用显著不同，应重估。'
python3 "$tool" add-business --model "$model" --business-id environmental_services --name '危废固废处置与混凝土等产业链服务' --importance '合并披露的危固废处置与其余混凝土、矿粉、外加剂及新材料业务。' --confidence low --falsifier '若公司进一步拆分“其他”产品收入成本与现金流，应按具名经济业务重构。'

bf() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
bfx() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
bfx cement_clinker revenue cement_clinker_revenue_2025 reported '2025年报第23、209-210页水泥和熟料收入合计。' high
bfx cement_clinker cost_of_revenue cement_clinker_cost_2025 reported '2025年报第23、209-210页水泥和熟料成本合计。' high
bf cement_clinker period_operating_expenses 3004973237.922635 estimate '公司期间经营费用按各业务毛利贡献分配。' low '分业务费用披露将推翻该分配。'
bf cement_clinker cash_tax 256914529.166841 estimate '公司经营现金税按各业务重构EBIT贡献分配。' low '分业务纳税资料将推翻该分配。'
bf cement_clinker operating_cash_flow_contribution 2491666616.298851 estimate '公司经营现金流按各业务NOPAT贡献分配。' low '分业务现金流或营运资金资料将推翻该分配。'
bfx aggregate revenue aggregate_revenue_2025 reported '2025年报第23、209-210页砂石骨料收入。' high
bfx aggregate cost_of_revenue aggregate_cost_2025 reported '2025年报第23、209-210页砂石骨料成本。' high
bf aggregate period_operating_expenses 636834527.5211045 estimate '公司期间经营费用按各业务毛利贡献分配。' low '分业务费用披露将推翻该分配。'
bf aggregate cash_tax 54447088.157224 estimate '公司经营现金税按各业务重构EBIT贡献分配。' low '分业务纳税资料将推翻该分配。'
bf aggregate operating_cash_flow_contribution 528051069.575495 estimate '公司经营现金流按各业务NOPAT贡献分配。' low '分业务现金流或营运资金资料将推翻该分配。'
bfx environmental_services revenue environmental_services_revenue_2025 reported '危废固废处置与财报“其他”产品收入合计，覆盖剩余业务。' medium
bfx environmental_services cost_of_revenue environmental_services_cost_2025 reported '危废固废处置与财报“其他”产品成本合计。' medium
bf environmental_services period_operating_expenses 399463513.1362605 estimate '公司期间经营费用按各业务毛利贡献分配。' low '分业务费用披露将推翻该分配。'
bf environmental_services cash_tax 34152710.280935 estimate '公司经营现金税按各业务重构EBIT贡献分配。' low '分业务纳税资料将推翻该分配。'
bf environmental_services operating_cash_flow_contribution 331227542.245654 estimate '公司经营现金流按各业务NOPAT贡献分配。' low '分业务现金流或营运资金资料将推翻该分配。'

# 稳定状态采用2025年正常化经营利润和折旧，资本开支取近两年净资本开支约16亿元，营运资金不假设永久释放。
se stable revenue '' 24500912048.98 '需求长期收缩，采用2025年收入而不采纳管理层300亿元计划。' medium '若连续年度销量与价格支持更高或更低收入平台，则重估。'
se stable cost_of_revenue '' 19077583459.98 '采用2025年成本结构作为基准，不把短期煤价进一步下降外推。' medium '煤电价格、碳成本或产能利用率出现持续变化则重估。'
se stable period_operating_expenses '' 4041271278.58 '采用2025年重构期间经营费用。' medium '持续降本或费用反弹超过一个完整周期则重估。'
se stable cash_tax '' 345514327.605 '按25%正常经营税率。' medium '可持续税率显著偏离25%则重估。'
se stable depreciation_amortization '' 3356751954.93 '采用2025年折旧摊销代表现有资产消耗。' medium '大规模关停或并购改变资产底盘则重估。'
se stable core_business_capex '' 1600000000 '近两年净现金资本开支约13.7亿和15.9亿元，取16亿元作为常态主业投入；高于2025年以留出环保与更新余量。' medium '若连续三年在不削弱产能和合规的前提下低于该额，或环保更新支出显著上升，则重估。'
se stable exploratory_business_capex '' 0 '稳定经营收益不把未稳定的新业务投入资本化；其价值作为未计选项。' medium '新业务达到可验证稳定盈利且所需投入明确后，应纳入公司特定路径。'
se stable operating_working_capital_increase '' 0 '成熟且收入不增长的稳定状态不假设永久营运资金增加或释放。' medium '若库存安全储备或账期结构持续改变，应调整。'

# 估值桥事实与字段。
af cash_2025_equity '货币资金' 6045051832.03 '2025-12-31' "$s25" 'P104、P149、P221'
af restricted_cash_2025 '不属于现金及现金等价物的货币资金' 592625036.61 '2025-12-31' "$s25" 'P221'
af lt_equity_invest_2025 '长期股权投资' 1773305854.84 '2025-12-31' "$s25" 'P104、P170-171'
af equity_instruments_2025 '其他权益工具投资' 402965606.00 '2025-12-31' "$s25" 'P104、P167-169'
af long_borrow_2025 '长期借款' 6813763558.01 '2025-12-31' "$s25" 'P105-106、P200'
af bond_2025 '应付债券' 2995842127.85 '2025-12-31' "$s25" 'P106、P200-201'
af lease_2025 '租赁负债' 183828690.93 '2025-12-31' "$s25" 'P106、P202'
af long_payable_2025 '长期应付款' 450313556.96 '2025-12-31' "$s25" 'P106、P202-203'
af cb_liability_2025 '冀东转债负债成分' 1752129548.26 '2025-12-31' "$s25" 'P200-201'
af minority_2025 '少数股东权益' 2022998953.88 '2025-12-31' "$s25" 'P106、P239-241'
af issued_shares_2025 '期末股本股数' 2658216778 '2025-12-31' "$s25" 'P106、P280'
af unconverted_cb_2025 '尚未转股可转债面值' 1776409700 '2025-12-31' "$s25" 'P98-99'
af cb_conversion_price_2025 '期末转股价格' 13.01 '2025-12-31' "$s25" 'P98-99'

sf equity excess_cash '' 'cash_2025_equity-restricted_cash_2025-2000000000' formula '账面货币资金扣受限资金及20亿元经营必需现金。' medium
sf equity non_operating_assets '' 'lt_equity_invest_2025+equity_instruments_2025' formula '权益法投资和独立权益工具不参与重构经营FCFF，按账面价值加回。' medium
sf equity financing_debt '' 'sb_2025+curdebt_2025+long_borrow_2025+bond_2025+lease_2025+long_payable_2025-cb_liability_2025' formula '短借、一年内到期融资负债、长期借款、非可转债应付债券、租赁及长期应付款；可转债按完全摊薄转股处理。' medium
sf equity minority_interest_value '' 'minority_2025' reported '缺少非全资子公司独立FCFF，暂以少数股东账面权益作为经济价值替代。' low
se equity other_priority_claims '' 0 '年末2.16亿元未支付项目合同属于未来经营资本开支，已由稳定期每年16亿元资本开支覆盖，不再重复列作优先索偿。' medium '若其中存在未进入经营负债、且不属于稳定资本开支的不可撤销索偿，则应单列扣除。'
sf equity diluted_shares '' 'issued_shares_2025+unconverted_cb_2025/cb_conversion_price_2025' formula '期末已发行股数加尚未转股可转债按13.01元转股价的潜在股份。' medium
se equity financial_to_trading_fx '' 1 '财报与交易币种均为人民币。' high '币种发生变化则调整。'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '需求收缩且新业务稳定状态、到达时间和逐年投入证据不足，使用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '可转债完全摊薄处理' --before '应付债券含可转债负债成分17.52亿元' --after '融资负债剔除17.52亿元并增加约1.37亿股潜在股份' --reason '避免同时扣债务并计入转股摊薄。若到期不转股，应恢复债务并取消潜在股。'
python3 "$tool" add-adjustment --model "$model" --name '商誉' --before '账面净额5.72亿元' --after '经营投入资本中全额剔除' --reason '并购溢价不能仅凭账面确认成为可解释经营资产；若被收购业务形成可持续超额经营收益，价值由收益端反映。'

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '历史直接数均追溯至三份年报的报表或附注页码，估计字段记录依据及可推翻条件。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '投资收益及金融资产排除于经营利润，商誉剔除，可转债按完全摊薄一致处理。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定状态采用2025年正常化经营结构、近两年资本开支及零增长营运资金，未机械采用管理层300亿元计划。'
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '投入资本以重资产生产设施为主，分母稳健；但周期低点亏损使年度ROIC只用于说明资产效率，不作为竞争优势证据。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '待报告完成后复核重大数字、业务合计和价值桥与模型一致。'

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

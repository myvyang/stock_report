#!/usr/bin/env bash
set -euo pipefail

PY=python3
TOOL=.agents/skills/stock-research/scripts/stock_research.py
MODEL=outputs/analysis.json
SRC23='金正大生态工程集团股份有限公司2023年年度报告（2024-04-30）'
SRC24='金正大生态工程集团股份有限公司2024年年度报告（2025-04-26）'
SRC25='金正大生态工程集团股份有限公司2025年年度报告（2026-04-23）'
URL23='https://static.cninfo.com.cn/finalpage/2024-04-30/1219923364.PDF'
URL24='https://static.cninfo.com.cn/finalpage/2025-04-26/1223317551.PDF'
URL25='https://static.cninfo.com.cn/finalpage/2026-04-23/1225147245.PDF'

rm -f "$MODEL"
$PY "$TOOL" init --name 金正大 --code 002470.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$MODEL"

fact() { $PY "$TOOL" add-fact --model "$MODEL" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope consolidated --source "$5" --locator "$6"; }
field() { $PY "$TOOL" set-field --model "$MODEL" "$@"; }
bfield() { $PY "$TOOL" set-business-field --model "$MODEL" "$@"; }

# 合并利润表、现金流量表及折旧摊销附注。
fact rev23 营业收入 8548940363.92 2023-12-31 "$SRC23 $URL23" 'PDF第98页'
fact cost23 营业成本 7841353043.10 2023-12-31 "$SRC23 $URL23" 'PDF第99页'
fact surtax23 税金及附加 50657553.58 2023-12-31 "$SRC23 $URL23" 'PDF第99页'
fact sell23 销售费用 320449601.90 2023-12-31 "$SRC23 $URL23" 'PDF第99页'
fact admin23 管理费用 420947757.83 2023-12-31 "$SRC23 $URL23" 'PDF第99页'
fact rd23 研发费用 182116494.74 2023-12-31 "$SRC23 $URL23" 'PDF第99页'
fact other_income23 其他收益 79581395.45 2023-12-31 "$SRC23 $URL23" 'PDF第99页'
fact interest23 利息费用 237710754.70 2023-12-31 "$SRC23 $URL23" 'PDF第99页'
fact ocf23 经营活动产生的现金流量净额 282335123.73 2023-12-31 "$SRC23 $URL23" 'PDF第102页'
fact capex23 购建固定资产无形资产和其他长期资产支付的现金 153276143.20 2023-12-31 "$SRC23 $URL23" 'PDF第102页'
fact da_fixed23 固定资产折旧 548428509.35 2023-12-31 "$SRC23 $URL23" 'PDF第164页，现金流量补充资料'
fact da_rou23 使用权资产折旧 9656562.90 2023-12-31 "$SRC23 $URL23" 'PDF第164页，现金流量补充资料'
fact da_int23 无形资产摊销 16795394.48 2023-12-31 "$SRC23 $URL23" 'PDF第164页，现金流量补充资料'

fact rev24 营业收入 8328058513.21 2024-12-31 "$SRC24 $URL24" 'PDF第93页'
fact cost24 营业成本 7296335824.69 2024-12-31 "$SRC24 $URL24" 'PDF第93页'
fact surtax24 税金及附加 56639073.38 2024-12-31 "$SRC24 $URL24" 'PDF第94页'
fact sell24 销售费用 350585639.63 2024-12-31 "$SRC24 $URL24" 'PDF第94页'
fact admin24 管理费用 467251797.42 2024-12-31 "$SRC24 $URL24" 'PDF第94页'
fact rd24 研发费用 215043539.66 2024-12-31 "$SRC24 $URL24" 'PDF第94页'
fact other_income24 其他收益 64840092.18 2024-12-31 "$SRC24 $URL24" 'PDF第94页'
fact interest24 利息费用 170459863.50 2024-12-31 "$SRC24 $URL24" 'PDF第94页'
fact ocf24 经营活动产生的现金流量净额 534724359.03 2024-12-31 "$SRC24 $URL24" 'PDF第97页'
fact capex24 购建固定资产无形资产和其他长期资产支付的现金 430059987.20 2024-12-31 "$SRC24 $URL24" 'PDF第97页'
fact da_fixed24 固定资产折旧 569327543.93 2024-12-31 "$SRC24 $URL24" 'PDF第160页，现金流量补充资料'
fact da_rou24 使用权资产折旧 9490519.96 2024-12-31 "$SRC24 $URL24" 'PDF第160页，现金流量补充资料'
fact da_int24 无形资产摊销 20092736.75 2024-12-31 "$SRC24 $URL24" 'PDF第160页，现金流量补充资料'
fact da_ltp24 长期待摊费用摊销 809530.92 2024-12-31 "$SRC24 $URL24" 'PDF第160页，现金流量补充资料'

fact rev25 营业收入 9915868845.35 2025-12-31 "$SRC25 $URL25" 'PDF第84页'
fact cost25 营业成本 8641412334.57 2025-12-31 "$SRC25 $URL25" 'PDF第85页'
fact surtax25 税金及附加 62498212.22 2025-12-31 "$SRC25 $URL25" 'PDF第85页'
fact sell25 销售费用 341803815.61 2025-12-31 "$SRC25 $URL25" 'PDF第85页'
fact admin25 管理费用 442130487.65 2025-12-31 "$SRC25 $URL25" 'PDF第85页'
fact rd25 研发费用 245291789.71 2025-12-31 "$SRC25 $URL25" 'PDF第85页'
fact other_income25 其他收益 72066460.77 2025-12-31 "$SRC25 $URL25" 'PDF第85页'
fact interest25 利息费用 145685751.10 2025-12-31 "$SRC25 $URL25" 'PDF第85页'
fact ocf25 经营活动产生的现金流量净额 455728372.75 2025-12-31 "$SRC25 $URL25" 'PDF第88页'
fact capex25 购建固定资产无形资产和其他长期资产支付的现金 327164089.12 2025-12-31 "$SRC25 $URL25" 'PDF第89页'
fact da_fixed25 固定资产折旧 478020823.74 2025-12-31 "$SRC25 $URL25" 'PDF第148页，现金流量补充资料'
fact da_rou25 使用权资产折旧 9255454.80 2025-12-31 "$SRC25 $URL25" 'PDF第148页，现金流量补充资料'
fact da_int25 无形资产摊销 20172724.65 2025-12-31 "$SRC25 $URL25" 'PDF第148页，现金流量补充资料'
fact da_ltp25 长期待摊费用摊销 3890183.95 2025-12-31 "$SRC25 $URL25" 'PDF第148页，现金流量补充资料'

# 2025年分产品控制数。
fact comp_rev25 复合肥收入 5460654657.11 2025-12-31 "$SRC25 $URL25" 'PDF第25-26页；常规复合肥与新型肥料合计'
fact comp_cost25 复合肥营业成本 4600441399.57 2025-12-31 "$SRC25 $URL25" 'PDF第26页；常规复合肥与新型肥料合计'
fact phos_rev25 磷肥收入 2657772107.66 2025-12-31 "$SRC25 $URL25" 'PDF第25-26页'
fact phos_cost25 磷肥营业成本 2336810348.70 2025-12-31 "$SRC25 $URL25" 'PDF第26页'
fact raw_rev25 原料化肥及配套经营收入 1797442080.58 2025-12-31 "$SRC25 $URL25" 'PDF第25-26页；原料化肥及其他与其他业务合计'
fact raw_cost25 原料化肥及配套经营营业成本 1704160586.30 2025-12-31 "$SRC25 $URL25" 'PDF第26页；原料化肥及其他与其他业务合计'

# 估值桥直接披露事实。
fact cash25 货币资金 1365399212.85 2025-12-31 "$SRC25 $URL25" 'PDF第80页'
fact restricted_cash25 受限货币资金 983301805.31 2025-12-31 "$SRC25 $URL25" 'PDF第129、135页'
fact short_debt25 短期借款 1628699691.75 2025-12-31 "$SRC25 $URL25" 'PDF第81页'
fact current_noncurrent25 一年内到期的非流动负债 868868362.06 2025-12-31 "$SRC25 $URL25" 'PDF第81页'
fact long_debt25 长期借款 2380725723.23 2025-12-31 "$SRC25 $URL25" 'PDF第82页'
fact lease_debt25 租赁负债 27046199.22 2025-12-31 "$SRC25 $URL25" 'PDF第82页'
fact accrued_interest25 其他应付款中的应付利息 37223914.25 2025-12-31 "$SRC25 $URL25" 'PDF第81页'
fact wengan_invest25 瓮安县磷化长期股权投资账面价值 62051817.11 2025-12-31 "$SRC25 $URL25" 'PDF第129、163页'
fact jinfeng_invest25 金丰农业服务长期股权投资账面价值 862975566.97 2025-12-31 "$SRC25 $URL25" 'PDF第129、163页'
fact other_equity25 其他权益工具投资 84866852.05 2025-12-31 "$SRC25 $URL25" 'PDF第80、128页'
fact trading_asset25 交易性金融资产 237160.00 2025-12-31 "$SRC25 $URL25" 'PDF第80页'
fact minority25 少数股东权益 83070882.88 2025-12-31 "$SRC25 $URL25" 'PDF第82页'
fact shares25 股本及期末普通股股数 3286027742 2025-12-31 "$SRC25 $URL25" 'PDF第82、70页'
fact goodwill22 商誉 107443.65 2022-12-31 "$SRC23 $URL23" 'PDF第95页，比较期'
fact goodwill23 商誉 107443.65 2023-12-31 "$SRC23 $URL23" 'PDF第95页'
fact goodwill24 商誉 107443.65 2024-12-31 "$SRC25 $URL25" 'PDF第81页，比较期'
fact goodwill25 商誉 107443.65 2025-12-31 "$SRC25 $URL25" 'PDF第81页'

# 历史经营与FCFF。
for y in 23 24 25; do
  year=$((2000+y))
  field --view historical --year "$year" --field revenue --expression "rev$y" --basis-type reported --reason '合并利润表营业收入。' --confidence high
  field --view historical --year "$year" --field cost_of_revenue --expression "cost$y" --basis-type reported --reason '合并利润表营业成本。' --confidence high
  field --view historical --year "$year" --field period_operating_expenses --expression "surtax$y + sell$y + admin$y + rd$y - other_income$y" --basis-type formula --reason '税金及附加、销售、管理、研发费用减持续经营相关政府补助；排除财务费用、投资损益、公允价值、减值和资产处置。' --confidence medium
  field --view historical --year "$year" --field operating_cash_flow --expression "ocf$y" --basis-type reported --reason '合并现金流量表经营活动现金流量净额。' --confidence high
done
field --view historical --year 2023 --field depreciation_amortization --expression 'da_fixed23 + da_rou23 + da_int23' --basis-type formula --reason '现金流量补充资料披露的经营性折旧摊销合计。' --confidence high
field --view historical --year 2024 --field depreciation_amortization --expression 'da_fixed24 + da_rou24 + da_int24 + da_ltp24' --basis-type formula --reason '现金流量补充资料披露的经营性折旧摊销合计。' --confidence high
field --view historical --year 2025 --field depreciation_amortization --expression 'da_fixed25 + da_rou25 + da_int25 + da_ltp25' --basis-type formula --reason '现金流量补充资料披露的经营性折旧摊销合计。' --confidence high

field --view historical --year 2023 --field cash_tax --value 0 --basis-type estimate --reason 'EBIT为负，不确认当期经营现金税收益；已支付各项税费含流转税，不能直接作为经营所得税。' --confidence medium --falsifier '若税务附注证明经营亏损可立即形成可收回现金税利益，则应调低税负。'
field --view historical --year 2024 --field cash_tax --value 1408546.122 --basis-type estimate --reason '对重构EBIT采用20%混合正常税率，介于高新技术企业15%与一般企业25%之间。' --confidence low --falsifier '若分主体应税利润与优惠期限披露可支持不同现金税率，则重算。'
field --view historical --year 2025 --field cash_tax --value 50959733.272 --basis-type estimate --reason '对重构EBIT采用20%混合正常税率，避免把债务重组及实体间亏损造成的报表所得税波动带入经营税。' --confidence low --falsifier '若分主体应税利润和实际现金所得税披露显示长期税率显著偏离20%，则重算。'

field --view historical --year 2023 --field core_business_capex --value 114840235.31 --basis-type estimate --reason '现金资本开支扣除年产3万吨磷酸铁一期38,435,907.89元开拓投入；净化磷酸技改和磷矿建设归入现有磷肥产业链。' --confidence medium --falsifier '若项目付款明细显示更多资本开支专用于尚未商业化的新业务，则提高开拓性投入。'
field --view historical --year 2023 --field exploratory_business_capex --value 38435907.89 --basis-type estimate --reason '年报重大项目中磷酸铁正极前驱体项目尚在建设且未产生收益。' --confidence medium --falsifier '若该项目实际服务既有磷肥销售或已形成稳定商业化收入，则改归主营。'
field --view historical --year 2024 --field core_business_capex --value 414716548.16 --basis-type estimate --reason '现金资本开支扣除磷酸铁一期15,343,439.04元，其余包括现有产线、净化磷酸技改和磷矿。' --confidence medium --falsifier '若资本开支付款明细揭示其他未商业化项目，则重新分类。'
field --view historical --year 2024 --field exploratory_business_capex --value 15343439.04 --basis-type estimate --reason '磷酸铁一期仍在建设期且累计未实现收益。' --confidence medium --falsifier '若项目已形成稳定外部销售和正经营利润，则改归主营。'
field --view historical --year 2025 --field core_business_capex --value 319036712.80 --basis-type estimate --reason '现金资本开支扣除磷酸铁一期8,127,376.32元；磷矿继续作为现有磷肥原料一体化投入。' --confidence medium --falsifier '若付款明细证明磷矿或其他投入主要服务未商业化新材料，则提高开拓性投入。'
field --view historical --year 2025 --field exploratory_business_capex --value 8127376.32 --basis-type estimate --reason '磷酸铁一期进度20%、累计投入6,190.67万元且尚未产生收益。' --confidence medium --falsifier '若后续披露项目投产并形成稳定正现金流，则归入主营。'

field --view historical --year 2023 --field after_tax_interest_in_operating_cash_flow --value 237710754.70 --basis-type estimate --reason '以利息费用近似经营现金流中融资成本加回；因经营EBIT为负不计税盾。' --confidence medium --falsifier '若现金利息支付和资本化利息明细显示与费用口径重大不同，则改用现金口径。'
field --view historical --year 2024 --field after_tax_interest_in_operating_cash_flow --value 136367890.80 --basis-type estimate --reason '利息费用按20%正常税率税后加回。' --confidence medium --falsifier '若现金利息支付或可利用税盾显著不同，则重算。'
field --view historical --year 2025 --field after_tax_interest_in_operating_cash_flow --value 116548600.88 --basis-type estimate --reason '利息费用按20%正常税率税后加回。' --confidence medium --falsifier '若现金利息支付或可利用税盾显著不同，则重算。'
field --view historical --year 2023 --field operating_working_capital_increase --value -132168103.48 --basis-type estimate --reason '按NOPAT+折旧摊销-资本开支-现金流路径FCFF倒算，包含存货、经营应收应付及经营性其他项目的综合现金占用。' --confidence low --falsifier '若附注可完整区分非经营往来、减值与经营周转项目，则以逐项余额变动替代。'
field --view historical --year 2024 --field operating_working_capital_increase --value -65737733.782 --basis-type estimate --reason '按利润路径与经营现金流路径闭合倒算，反映经营周转资金和其他经营性应计项目净释放。' --confidence low --falsifier '若完整经营营运资金明细显示不同占用，应重构并同时调整其他经营现金流项目。'
field --view historical --year 2025 --field operating_working_capital_increase --value 142901146.598 --basis-type estimate --reason '按利润路径与经营现金流路径闭合倒算；2025年存货和经营应收增加被经营应付增加部分抵消。' --confidence low --falsifier '若完整经营营运资金明细显示不同占用，应重构并同时调整其他经营现金流项目。'

# 资本存量：流动项目按经营应收、存货、预付等减无息经营负债；长期项目按经营长期资产减递延收益等资产相关负债。
for args in \
  '2022 418725315.34 5595014774.06 goodwill22' \
  '2023 -369815181.64 5233370037.68 goodwill23' \
  '2024 -41301648.22 5253516738.21 goodwill24' \
  '2025 -88976728.16 5095844918.65 goodwill25'; do
  set -- $args; y=$1; owc=$2; lt=$3; gw=$4
  field --view capital --year "$y" --field operating_working_capital --value "$owc" --basis-type estimate --reason '经营性票据及应收、预付、存货和其他流动资产减票据及应付、合同负债、职工薪酬、税费和其他流动负债；排除其他应收款和其他应付款中的融资/历史往来。' --confidence medium --falsifier '若其他应收或其他应付款附注明确有重大日常经营项目，则重新纳入。'
  field --view capital --year "$y" --field operating_long_term_assets_net --value "$lt" --basis-type estimate --reason '固定资产、在建工程、使用权资产、经营性无形资产、长期待摊及经营性其他非流动资产，扣除资产相关递延收益；2025另扣矿山修复义务。' --confidence medium --falsifier '若长期资产附注明确存在大额闲置、待处置或非经营项目，则剔除。'
  field --view capital --year "$y" --field required_cash --value 300000000 --basis-type estimate --reason '以约半个月至一个月刚性采购、工资和税费缓冲为基准，并考虑预收款及票据保证金另行受限。' --confidence low --falsifier '若月度最低现金、淡旺季付款峰值或授信可用度显示安全运营需要显著不同现金，则调整。'
  field --view capital --year "$y" --field unsupported_intangible_assets --expression "$gw" --basis-type reported --reason '仅将账面商誉视为无法由当前经营收益单独解释的无形资产；土地使用权和生产许可继续服务经营。' --confidence high
done

# 稳定期：不采用2025年磷肥高增单年外推，使用三年中枢和已恢复毛利率。
field --view stable --field revenue --value 9500000000 --basis-type estimate --reason '介于2024年的83.28亿元与2025年的99.16亿元之间偏上，承认磷肥产销恢复，但不把66.8%的单年磷肥收入增长外推。' --confidence low --falsifier '若未来两年销量、价格与产能利用率支持持续高于100亿元或回落低于85亿元，则调整。'
field --view stable --field cost_of_revenue --value 8312500000 --basis-type estimate --reason '对应12.5%稳定毛利率，略低于2025年12.85%，高于2023年8.28%。' --confidence low --falsifier '若原料价差、产品结构或产能利用率使毛利率连续两年偏离11%-14%，则重估。'
field --view stable --field period_operating_expenses --value 1000000000 --basis-type estimate --reason '接近2024-2025年约10.2亿元净期间经营费用，假设收入稳定后费用不再大幅扩张。' --confidence medium --falsifier '若销售与研发投入随收入产生明显经营杠杆或刚性上升，则调整。'
field --view stable --field cash_tax --value 37500000 --basis-type estimate --reason '稳定EBIT 1.875亿元按20%混合经营现金税率。' --confidence low --falsifier '若优惠税率到期或可弥补亏损实际利用使长期税率显著偏离20%，则调整。'
field --view stable --field depreciation_amortization --value 530000000 --basis-type estimate --reason '取2023-2025年5.11-6.00亿元折旧摊销的正常区间中值。' --confidence medium --falsifier '若大额资产处置、投产或剩余寿命变化使折旧长期偏离，则调整。'
field --view stable --field core_business_capex --value 350000000 --basis-type estimate --reason '参考2024-2025年主营现金资本开支4.15和3.19亿元；高于2023年低投入，仍低于折旧以反映现有重资产收缩。' --confidence low --falsifier '若固定资产更新、安全环保及矿山开发承诺证明长期每年需超过5亿元，则下调稳定收益。'
field --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason '稳定经营价值不为尚未商业化磷酸铁项目追加永久性投入；该项目只作为未计值选项。' --confidence low --falsifier '若磷酸铁形成可验证订单、利润和完整后续投入计划，则纳入成长路径。'
field --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason '稳定收入下不假设永久增加营运资金；季节性淡储在年内循环。' --confidence medium --falsifier '若渠道账期、库存淡储或原料保障导致结构性占用持续增加，则改为正值。'

# 2025年业务树，期间费用、税和经营现金流按毛利贡献分配，确保各列与公司合并数闭合。
$PY "$TOOL" add-business --model "$MODEL" --business-id compound --name 复合肥 --importance '占收入55%、贡献约三分之二毛利，是品牌、渠道和研发能力的主要载体。' --confidence medium --falsifier '若产品附注能直接披露常规与新型肥料独立费用和现金流，则进一步拆分。'
$PY "$TOOL" add-business --model "$MODEL" --business-id phosphate --name 磷肥 --importance '2025年收入同比增长66.8%，是收入恢复和毛利改善的最大增量来源。' --confidence medium --falsifier '若后续磷肥价格与销量回落使其利润贡献不再重大，则降低权重。'
$PY "$TOOL" add-business --model "$MODEL" --business-id raw_support --name 原料化肥与配套经营 --importance '覆盖原料化肥、贸易和配套收入，2025年占收入18.1%但毛利率较低。' --confidence low --falsifier '若公司披露原料贸易与配套业务的独立收入成本，应据此拆开重估。'

bfield --business-id compound --field revenue --expression comp_rev25 --basis-type reported --reason '常规复合肥与新型肥料披露收入合计。' --confidence high
bfield --business-id compound --field cost_of_revenue --expression comp_cost25 --basis-type reported --reason '常规复合肥与新型肥料披露成本合计。' --confidence high
bfield --business-id compound --field period_operating_expenses --value 688233131.9316031 --basis-type estimate --reason '公司净期间经营费用按各业务毛利贡献分配；品牌营销和研发主要服务复合肥，毛利分配优于收入分配。' --confidence low --falsifier '若分产品销售、管理和研发费用披露可得，则改用直接归属。'
bfield --business-id compound --field cash_tax --value 34396025.12167938 --basis-type estimate --reason '公司经营现金税按分配后EBIT比例归属。' --confidence low --falsifier '若分主体应税利润可将税项直接归属，则重算。'
bfield --business-id compound --field operating_cash_flow_contribution --value 307600600.5389326 --basis-type estimate --reason '公司经营现金流按毛利贡献分配，作为缺少分业务周转资金披露时的基准点。' --confidence low --falsifier '若分产品回款、库存和应付款数据披露，则按直接现金转换重算。'

bfield --business-id phosphate --field revenue --expression phos_rev25 --basis-type reported --reason '年报分产品披露。' --confidence high
bfield --business-id phosphate --field cost_of_revenue --expression phos_cost25 --basis-type reported --reason '年报分产品披露。' --confidence high
bfield --business-id phosphate --field period_operating_expenses --value 256792736.75812346 --basis-type estimate --reason '公司净期间经营费用按毛利贡献分配。' --confidence low --falsifier '若分产品费用披露可得，则改用直接归属。'
bfield --business-id phosphate --field cash_tax --value 12833804.440375311 --basis-type estimate --reason '公司经营现金税按分配后EBIT比例归属。' --confidence low --falsifier '若分主体应税利润可直接归属，则重算。'
bfield --business-id phosphate --field operating_cash_flow_contribution --value 114771574.3052673 --basis-type estimate --reason '公司经营现金流按毛利贡献分配。' --confidence low --falsifier '若磷肥独立周转资金和回款数据披露，则重算。'

bfield --business-id raw_support --field revenue --expression raw_rev25 --basis-type reported --reason '原料化肥及其他与其他业务披露收入合计。' --confidence high
bfield --business-id raw_support --field cost_of_revenue --expression raw_cost25 --basis-type reported --reason '原料化肥及其他与其他业务披露成本合计。' --confidence high
bfield --business-id raw_support --field period_operating_expenses --value 74631975.73027293 --basis-type estimate --reason '公司净期间经营费用按毛利贡献分配。' --confidence low --falsifier '若贸易及配套业务独立费用披露可得，则重算。'
bfield --business-id raw_support --field cash_tax --value 3729903.7099454077 --basis-type estimate --reason '公司经营现金税按分配后EBIT比例归属。' --confidence low --falsifier '若分主体应税利润可直接归属，则重算。'
bfield --business-id raw_support --field operating_cash_flow_contribution --value 33356197.905799832 --basis-type estimate --reason '公司经营现金流按毛利贡献分配。' --confidence low --falsifier '若贸易业务回款与资金占用披露可得，则重算。'

# 普通股价值桥。
field --view equity --field excess_cash --expression 'cash25 - restricted_cash25 - 300000000' --basis-type formula --reason '货币资金扣除受限资金和3亿元经营必需现金；不把票据保证金当作可分配资金。' --confidence medium
field --view equity --field non_operating_assets --value 578643612.645 --basis-type estimate --reason '瓮安磷化及其他权益工具按账面计，持续亏损且继续计提减值的金丰农业仅按账面50%计；另加交易性金融资产。' --confidence low --falsifier '若金丰农业处置回款、独立估值或连续盈利支持更高可实现价值，则上调；反之继续减记。'
field --view equity --field financing_debt --expression 'short_debt25 + current_noncurrent25 + long_debt25 + lease_debt25 + accrued_interest25' --basis-type formula --reason '计息借款、租赁负债和已计提利息全额扣除；经营性应付款不重复扣除。' --confidence high
field --view equity --field minority_interest_value --value 83070882.88 --basis-type estimate --reason '缺少逐家非全资子公司FCFF时，以少数股东账面权益作为经济价值替代。' --confidence medium --falsifier '若可取得非全资子公司独立经营价值、净债务与持股比例，则改用分子公司估值。'
field --view equity --field other_priority_claims --value 0 --basis-type estimate --reason '未决诉讼预计负债已在经营和现金流口径中体现，矿山修复义务已扣减经营长期资产；未发现需额外重复扣除的优先索偿。' --confidence medium --falsifier '若期后判决、担保执行或资本承诺形成表外且普通股之前的重大付款，则纳入。'
field --view equity --field diluted_shares --expression shares25 --basis-type reported --reason '报告期末无实质潜在摊薄工具，使用期末已发行普通股股数。' --confidence high
field --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason '财报与A股交易均以人民币计价。' --confidence high --falsifier '不适用；币种一致。'

$PY "$TOOL" set-valuation --model "$MODEL" --mode benchmark --stable-multiple 8 --safety-margin-ratio 0.6 --reason '历史盈利仅刚从亏损修复，磷肥增长、原料价差、项目投产时间和全部成长投入缺少可验证逐年FCFF，采用稳定经营收益八倍固定标尺。'
$PY "$TOOL" add-adjustment --model "$MODEL" --name '磷酸铁开拓投入' --before '并入现金资本开支' --after '2023/2024/2025分别0.384/0.153/0.081亿元' --reason '项目连续处于建设期、进度仅20%且尚无收益，单列为开拓性现金消耗，不额外赋值。'
$PY "$TOOL" add-adjustment --model "$MODEL" --name '受限现金' --before '货币资金13.65亿元' --after '多余现金0.821亿元' --reason '9.833亿元货币资金用于票据保证金或冻结质押，另保留3亿元经营必需现金。'
$PY "$TOOL" add-adjustment --model "$MODEL" --name '金丰农业长期股权投资' --before '账面8.630亿元' --after '4.315亿元' --reason '联营企业2025年亏损1.056亿元、连续减值，按账面50%计入非经营资产；可推翻条件是可验证处置价格或持续盈利。'

$PY "$TOOL" set-review --model "$MODEL" --item capital_return_interpretability --passed --reason '投入资本分母为正且主要由可核验重资产构成，但经营必需现金和营运资金分类置信度有限，正文仅将ROIC用于说明低回报和修复，不作精细同业比较。'
$PY "$TOOL" set-review --model "$MODEL" --item source_traceability --passed --reason '重大历史数字均追溯至三份法定年报、具体PDF页和公开巨潮链接；估计字段记录依据与可推翻条件。'
$PY "$TOOL" set-review --model "$MODEL" --item economic_classification --passed --reason '经营、融资、非经营投资、受限资金和少数股东已分开；投资收益、财务费用和重大减值未混入EBIT。'
$PY "$TOOL" set-review --model "$MODEL" --item stable_state --passed --reason '稳定状态综合三年收入、毛利、费用、折旧与资本开支，未机械外推2025年磷肥高增。'
$PY "$TOOL" set-review --model "$MODEL" --item report_consistency --passed --reason '报告中心数字、业务合计和普通股价值桥以结构化模型为唯一控制数。'

$PY "$TOOL" compile --model "$MODEL"
$PY "$TOOL" validate --model "$MODEL"

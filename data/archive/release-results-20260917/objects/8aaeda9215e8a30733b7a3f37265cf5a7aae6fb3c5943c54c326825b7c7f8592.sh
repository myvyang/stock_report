#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
src23='苏州欧圣电气股份有限公司2023年年度报告（2024-04-17）'
src24='苏州欧圣电气股份有限公司2024年年度报告（2025-04-18）'
src25='苏州欧圣电气股份有限公司2025年年度报告（2026-04-27）'

python3 "$tool" init --name 欧圣电气 --code 301187.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency CNY --trading-currency CNY --security-name A股 --security-unit 股 --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope consolidated --source "$5" --locator "$6"; }
hf() { python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
cf() { python3 "$tool" set-field --model "$model" --view capital --year "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
sf() { python3 "$tool" set-field --model "$model" --view stable --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }
ef_reported() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --expression "$2" --basis-type reported --reason "$3" --confidence "$4"; }
ef_estimate() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }

# Historical operating facts: statutory statement lines and cash-flow-note disclosures.
fact rev23 营业收入 1216121098.37 2023 "$src23" 'PDF P102'
fact cost23 营业成本 781037082.58 2023 "$src23" 'PDF P102'
fact taxsur23 税金及附加 7864199.14 2023 "$src23" 'PDF P102'
fact sales23 销售费用 144263575.43 2023 "$src23" 'PDF P102'
fact admin23 管理费用 52072611.04 2023 "$src23" 'PDF P103'
fact rd23 研发费用 67247019.13 2023 "$src23" 'PDF P103'
fact otherinc23 其他收益 3303573.63 2023 "$src23" 'PDF P103'
fact credit23 信用减值损失 178719.75 2023 "$src23" 'PDF P103'
fact impair23 资产减值损失 -6486814.02 2023 "$src23" 'PDF P103'
fact disposal23 资产处置收益 24309.83 2023 "$src23" 'PDF P103'
fact incometax23 所得税费用 36938554.53 2023 "$src23" 'PDF P103'
fact da_fa23 固定资产折旧 15672773.57 2023 "$src23" 'PDF P174'
fact da_rou23 使用权资产折旧 1500798.23 2023 "$src23" 'PDF P174'
fact da_ia23 无形资产摊销 1930479.18 2023 "$src23" 'PDF P174'
fact capex23 购建固定资产无形资产和其他长期资产支付的现金 267698269.04 2023 "$src23" 'PDF P106'
fact cfo23 经营活动产生的现金流量净额 257531244.22 2023 "$src23" 'PDF P106'
fact interestinc23 利息收入 25099720.03 2023 "$src23" 'PDF P103'

fact rev24 营业收入 1763949390.61 2024 "$src24" 'PDF P106'
fact cost24 营业成本 1163273764.65 2024 "$src24" 'PDF P106'
fact taxsur24 税金及附加 9274096.62 2024 "$src24" 'PDF P106'
fact sales24 销售费用 185454775 2024 "$src24" 'PDF P106'
fact admin24 管理费用 79548699.14 2024 "$src24" 'PDF P106'
fact rd24 研发费用 79594107.62 2024 "$src24" 'PDF P107'
fact otherinc24 其他收益 9038148.12 2024 "$src24" 'PDF P107'
fact credit24 信用减值损失 -3853065.92 2024 "$src24" 'PDF P107'
fact impair24 资产减值损失 -52353.78 2024 "$src24" 'PDF P107'
fact disposal24 资产处置收益 -96968.60 2024 "$src24" 'PDF P107'
fact incometax24 所得税费用 29372458.89 2024 "$src24" 'PDF P107'
fact da_fa24 固定资产折旧 16830781.10 2024 "$src24" 'PDF P190'
fact da_rou24 使用权资产折旧 2106031.38 2024 "$src24" 'PDF P190'
fact da_ia24 无形资产摊销 2431215.15 2024 "$src24" 'PDF P190'
fact capex24 购建固定资产无形资产和其他长期资产支付的现金 655191549.25 2024 "$src24" 'PDF P111'
fact cfo24 经营活动产生的现金流量净额 368095820 2024 "$src24" 'PDF P111'
fact interestinc24 利息收入 22362022.38 2024 "$src24" 'PDF P107'

fact rev25 营业收入 1980781225.52 2025 "$src25" 'PDF P115'
fact cost25 营业成本 1408386807.66 2025 "$src25" 'PDF P115'
fact taxsur25 税金及附加 25907791.18 2025 "$src25" 'PDF P115'
fact sales25 销售费用 216405895.62 2025 "$src25" 'PDF P115'
fact admin25 管理费用 147832426.03 2025 "$src25" 'PDF P115'
fact rd25 研发费用 61653117.32 2025 "$src25" 'PDF P115'
fact otherinc25 其他收益 10069129.12 2025 "$src25" 'PDF P115'
fact credit25 信用减值损失 -2341459.01 2025 "$src25" 'PDF P116'
fact impair25 资产减值损失 2175752.45 2025 "$src25" 'PDF P116'
fact disposal25 资产处置收益 128513.67 2025 "$src25" 'PDF P116'
fact incometax25 所得税费用 9025919.94 2025 "$src25" 'PDF P116'
fact da_fa25 固定资产折旧 42407824.69 2025 "$src25" 'PDF P201'
fact da_rou25 使用权资产折旧 8961250.32 2025 "$src25" 'PDF P201'
fact da_ia25 无形资产摊销 14302161.25 2025 "$src25" 'PDF P201'
fact da_ltp25 长期待摊费用摊销 4026536.87 2025 "$src25" 'PDF P201'
fact capex25 购建固定资产无形资产和其他长期资产支付的现金 322566004.55 2025 "$src25" 'PDF P119'
fact cfo25 经营活动产生的现金流量净额 -42325903.92 2025 "$src25" 'PDF P119'
fact interestinc25 利息收入 12996155.29 2025 "$src25" 'PDF P115'

# Historical fields. Period expenses exclude finance and investing returns; tax and working-capital lines are research estimates.
hf 2023 revenue rev23 reported '合并利润表营业收入。' high
hf 2023 cost_of_revenue cost23 reported '合并利润表营业成本。' high
hf 2023 period_operating_expenses 'taxsur23+sales23+admin23+rd23-otherinc23-credit23-impair23-disposal23' formula '经营费用净额包含税金及附加、销售、管理、研发，并抵减持续经营相关其他收益和减值/处置净额；排除财务和投资收益。' medium
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field cash_tax --value 36938554.53 --basis-type estimate --reason '以所得税费用作为经营现金税代理；利息及理财收益相对经营利润较小。' --confidence medium --falsifier '税务附注若能拆出递延税、理财收益税和利息税盾，需重算。'
hf 2023 depreciation_amortization 'da_fa23+da_rou23+da_ia23' formula '现金流量表补充资料披露的经营性折旧摊销合计。' high
hf 2023 core_business_capex capex23 reported '购建长期经营资产现金支出，建设均服务现有空气动力和清洁设备业务。' high
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field exploratory_business_capex --value 0 --basis-type estimate --reason '护理机器人等新业务投入主要费用化研发，长期资产现金支出未披露可可靠归属的开拓性部分。' --confidence low --falsifier '若公司披露护理机器人专用设备或资本化开发支出，应重新分类。'
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field operating_working_capital_increase --value -93987033.84488194 --basis-type estimate --reason '以NOPAT、折旧摊销和经营现金流反推，包含经营应收存货应付变化及其他经营性非现金调整，以保证两条FCFF路径闭合。' --confidence medium --falsifier '取得完整经营性营运资金逐项现金变动和非现金调整后应替换。'
hf 2023 operating_cash_flow cfo23 reported '合并现金流量表经营活动现金流量净额。' high
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field after_tax_interest_in_operating_cash_flow --value -20722313.68511821 --basis-type estimate --reason '中国准则现金流将存款利息计入经营活动；按当年实际税率将税后利息收入从FCFF剔除，故为负。' --confidence medium --falsifier '若利息收现分类或税率明细表明金额不同，应调整。'

hf 2024 revenue rev24 reported '合并利润表营业收入。' high
hf 2024 cost_of_revenue cost24 reported '合并利润表营业成本。' high
hf 2024 period_operating_expenses 'taxsur24+sales24+admin24+rd24-otherinc24-credit24-impair24-disposal24' formula '经营费用净额包含税金及附加、销售、管理、研发，并抵减持续经营相关其他收益和减值/处置净额；排除财务和投资收益。' medium
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field cash_tax --value 29372458.89 --basis-type estimate --reason '以所得税费用作为经营现金税代理，低税率主要受境内外税率及优惠影响。' --confidence medium --falsifier '税务附注若能拆出递延税、理财收益税和利息税盾，需重算。'
hf 2024 depreciation_amortization 'da_fa24+da_rou24+da_ia24' formula '现金流量表补充资料披露的经营性折旧摊销合计。' high
hf 2024 core_business_capex capex24 reported '购建长期经营资产现金支出，主要为马来西亚工厂、产业园和海外仓。' high
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field exploratory_business_capex --value 0 --basis-type estimate --reason '长期资产现金支出未披露可可靠归属护理机器人等开拓业务的部分。' --confidence low --falsifier '若公司披露新业务专用设备或资本化开发支出，应重新分类。'
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field operating_working_capital_increase --value -104220946.43101825 --basis-type estimate --reason '以NOPAT、折旧摊销和经营现金流反推，包含经营性非现金调整，以保证两条FCFF路径闭合。' --confidence medium --falsifier '取得完整营运资金逐项现金变动和非现金调整后应替换。'
hf 2024 operating_cash_flow cfo24 reported '合并现金流量表经营活动现金流量净额。' high
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field after_tax_interest_in_operating_cash_flow --value -20039597.42898194 --basis-type estimate --reason '按实际税率将计入经营现金流的税后存款利息收入剔除，故为负。' --confidence medium --falsifier '若利息收现分类或适用税率明细不同，应调整。'

hf 2025 revenue rev25 reported '合并利润表营业收入。' high
hf 2025 cost_of_revenue cost25 reported '合并利润表营业成本。' high
hf 2025 period_operating_expenses 'taxsur25+sales25+admin25+rd25-otherinc25-credit25-impair25-disposal25' formula '经营费用净额包含税金及附加、销售、管理、研发，并抵减持续经营相关其他收益和减值/处置净额；排除财务、投资和公允价值损益。' medium
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field cash_tax --value 9025919.94 --basis-type estimate --reason '以所得税费用作为经营现金税代理；当年低有效税率不直接外推稳定期。' --confidence medium --falsifier '税务附注若能拆出递延税、境外优惠和非经营收益税项，需重算。'
hf 2025 depreciation_amortization 'da_fa25+da_rou25+da_ia25+da_ltp25' formula '现金流量表补充资料披露的固定资产、使用权资产、无形资产和长期待摊摊销。' high
hf 2025 core_business_capex capex25 reported '购建长期经营资产现金支出；主要建设项目服务现有清洁设备与空气动力业务。' high
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field exploratory_business_capex --value 0 --basis-type estimate --reason '护理机器人投入主要体现在研发和人员费用，长期资产现金支出无法可靠分出专属部分。' --confidence low --falsifier '若披露护理设备专用资本化投入，应重新分类。'
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field operating_working_capital_increase --value 245587184.5655083 --basis-type estimate --reason '以NOPAT、折旧摊销和经营现金流反推；存货由2.11亿元增至5.09亿元是现金占用恶化的主要可见来源。' --confidence medium --falsifier '若逐项现金流附注显示收购或非现金存货造成重大差异，应重算。'
hf 2025 operating_cash_flow cfo25 reported '合并现金流量表经营活动现金流量净额。' high
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field after_tax_interest_in_operating_cash_flow --value -11962303.515508339 --basis-type estimate --reason '按实际税率将计入经营现金流的税后存款利息收入剔除，故为负。' --confidence medium --falsifier '若利息收现分类或适用税率明细不同，应调整。'

# Capital classification, using balance-sheet operating items. Required cash is roughly one month of operating cash outflow with a growth buffer.
cf 2022 operating_working_capital -55294774.21 '应收、应收款项融资、预付、其他应收、存货和其他流动资产，扣除票据/账款、合同、职工、税费及其他经营流动负债。来源为2023年报比较期资产负债表（PDF P98-P100）。' medium '附注明细若显示其他应收/应付或其他流动资产主要为非经营性质，应重分类。'
cf 2022 operating_long_term_assets_net 337720235.21 '固定资产、在建工程、使用权资产、无形资产、商誉及其他经营长期资产，扣除递延收益。来源为2023年报PDF P98-P100。' medium '若工程预付款或递延收益存在重大非经营成分，应调整。'
cf 2022 required_cash 100000000 '约一个月经营现金支出并考虑出口结算波动。' low '若月度现金支出、季节性或可用授信表明最低现金显著不同，应调整。'
cf 2022 unsupported_intangible_assets 0 '比较期无商誉；经营无形资产为土地和软件等可解释资产。' medium '若无形资产附注明细出现不能解释的并购溢价，应扣除。'

cf 2023 operating_working_capital -194031289.22 '按经营性流动资产减经营性流动负债重构，供应商票据与应付款提供较多无息资金。来源为2023年报PDF P98-P100。' medium '其他应收应付附注明细若以非经营项目为主，应重分类。'
cf 2023 operating_long_term_assets_net 648397689.77 '固定、在建、使用权、无形、商誉和其他经营长期资产扣递延收益。来源为2023年报PDF P98-P100。' medium '若在建工程或其他非流动资产并非服务主营，应调整。'
cf 2023 required_cash 100000000 '约一个月经营现金支出并考虑出口业务季节性。' low '若月度资金峰值或授信资料表明最低现金不同，应调整。'
cf 2023 unsupported_intangible_assets 7174829.85 '当年收购形成商誉，未单独赋予经营资产价值。来源为2023年报PDF P99。' high '若被收购业务形成可验证的增量稳定FCFF，可从收益侧体现而非保留账面商誉。'

cf 2024 operating_working_capital -321381747.21 '按经营性流动资产减经营性流动负债重构。来源为2024年报PDF P102-P104。' medium '其他应收应付附注明细若以融资或非经营项目为主，应重分类。'
cf 2024 operating_long_term_assets_net 1356739441.50 '固定、在建、使用权、无形、商誉和其他经营长期资产扣递延收益；马来西亚等在建投入显著增加。来源为2024年报PDF P102-P104。' medium '项目若停建、闲置或转为非经营用途，应减值或重分类。'
cf 2024 required_cash 120000000 '收入扩大后按约一个月经营现金支出估计。' low '若月度资金峰值或授信资料表明最低现金不同，应调整。'
cf 2024 unsupported_intangible_assets 7281904.77 '商誉不直接作为可解释经营资产。来源为2024年报PDF P103。' high '被收购业务若形成可验证稳定FCFF，应从收益侧体现。'

cf 2025 operating_working_capital -340066764.04 '按经营性流动资产减经营性流动负债重构；存货上升被应付账款增加部分融资。来源为2025年报PDF P110-P112。' medium '其他应收应付或存货中收购带入的非现金部分若重大，应重分类。'
cf 2025 operating_long_term_assets_net 2028616959.86 '固定、在建、使用权、无形、商誉、长期待摊和其他经营长期资产扣递延收益；马来西亚工厂转固是主要变化。来源为2025年报PDF P111-P113。' medium '若海外产能无法达产、资产闲置或投资性用途增加，应下调。'
cf 2025 required_cash 150000000 '约一个月经营现金支出，考虑海外多实体结算和下半年销售旺季。' low '披露月度最低现金、授信可得性或现金池后应据实替换。'
cf 2025 unsupported_intangible_assets 70357170.28 '商誉不以账面值计入经营资产价值，2025年收购后显著增加。来源为2025年报PDF P111。' high '收购业务若产生可验证的持续增量FCFF，将通过稳定收益体现。'

# Stable state: benchmark, not management guidance.
sf revenue 2000000000 '以2025年约19.81亿元收入为基准，不外推高增长；核心品类成熟而工业风扇与配件增长可抵消波动。' medium '若主要客户订单或关税安排使常态收入低于18亿元或连续高于22亿元，应调整。'
sf cost_of_revenue 1350000000 '稳定毛利率取32.5%，介于2024年的34.1%和马来西亚爬坡期2025年的28.9%。' medium '若马来西亚达产后两年毛利率仍低于30%，需下调；若恢复至34%以上则上调。'
sf period_operating_expenses 360000000 '剔除2025年海外整合初期的部分冗余，但保留全球化销售管理体系；绝对额略高于2024年。' low '海外子公司持续亏损或管理费用维持2025年高位将推翻。'
sf cash_tax 43500000 '按稳定EBIT 2.9亿元的15%现金税率估计，不沿用2025年7.96%的异常低有效税率。' medium '境外利润组合和税收优惠若使长期现金税率显著偏离15%，应调整。'
sf depreciation_amortization 70000000 '马来西亚工厂等资产转固后，参考2025年约0.697亿元折旧摊销。' medium '完整产能折旧或收购无形摊销若显著变化，应更新。'
sf core_business_capex 90000000 '建设高峰结束后取略高于折旧摊销的常态更新与技改支出；不把产业园继续建设高峰永久化。' low '若产业园、仓储与自动化项目使多年现金资本开支持续超过1.5亿元，应下调稳定收益。'
sf exploratory_business_capex 0 '护理机器人等新业务没有足够资本开支拆分证据，不在稳定经营价值中另行加值。' low '若披露明确的新业务专属资本投入和商业化回报，应单列并重算。'
sf operating_working_capital_increase 0 '成熟稳定收入下不假设永久新增营运资金；2025年存货爬升视为建设/切换期占用。' low '若海外供应链结构要求持续增加库存和应收，应改为正值。'

# Latest-year business facts and estimates. Product categories are mutually exclusive and reconcile to the consolidated total.
fact vac_rev25 吸尘器收入 901274606.04 2025 "$src25" 'PDF P37'
fact vac_cost25 吸尘器营业成本 613027367.27 2025 "$src25" 'PDF P38'
fact air_rev25 空压机收入 684110419.77 2025 "$src25" 'PDF P37'
fact air_cost25 空压机营业成本 526270897.93 2025 "$src25" 'PDF P38'
fact fan_rev25 工业风扇收入 144474977.55 2025 "$src25" 'PDF P37'
fact fan_cost25 工业风扇营业成本 99991918.41 2025 "$src25" 'PDF P38'
fact adj_rev25 配件及其他品类收入 250921222.16 2025 "$src25" 'PDF P37'
fact adj_cost25 配件及其他品类营业成本 169096624.05 2025 "$src25" 'PDF P38'

python3 "$tool" add-business --model "$model" --business-id vacuums --name 干湿两用吸尘器 --importance '最大收入来源，品牌授权和ODM渠道成熟，毛利率31.98%。' --confidence medium --falsifier '若客户或产品附注显示该品类内部利润结构差异巨大，需再拆分。'
python3 "$tool" add-business --model "$model" --business-id compressors --name 小型空压机 --importance '第二大收入来源，北美DIY工具渠道为核心需求，毛利率23.07%。' --confidence medium --falsifier '若马来西亚转产后产品/地区盈利差异可可靠披露，需再拆分。'
python3 "$tool" add-business --model "$model" --business-id fans --name 工业风扇 --importance '收入同比增长92.4%，已足以改变产品结构，毛利率30.79%。' --confidence medium --falsifier '若增长为一次性订单且收入占比回落至低个位数，应并回相关清洁设备品类。'
python3 "$tool" add-business --model "$model" --business-id accessories --name 配件与护理设备等延伸品类 --importance '配件及披露口径内延伸产品占收入12.67%，含可能改变未来结构的新产品。' --confidence low --falsifier '若公司披露配件、护理机器人等各自收入成本，应按经济业务重拆。'

bf() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
bfe() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
bf vacuums revenue vac_rev25 reported '年报分产品披露。' high
bf vacuums cost_of_revenue vac_cost25 reported '年报分产品披露。' high
bfe vacuums period_operating_expenses 222465835.93077642 '公司费用按各品类毛利贡献分配，使获客、研发和管理资源更多归属毛利来源。' low '若分产品人员、渠道费和研发投入披露，应据实替换。'
bfe vacuums cash_tax 4545286.290161594 '公司经营现金税按分配后的业务EBIT占比分摊。' low '分地区税务利润披露后应据实替换。'
bfe vacuums operating_cash_flow_contribution -19258695.452735003 '公司经营现金流按收入占比分配；仅为闭合基准，不能解释品类周转差异。' low '分产品应收存货和应付数据可取得时应重算。'

bf compressors revenue air_rev25 reported '年报分产品披露。' high
bf compressors cost_of_revenue air_cost25 reported '年报分产品披露。' high
bfe compressors period_operating_expenses 121818690.5064091 '公司费用按各品类毛利贡献分配。' low '若分产品人员、渠道费和研发投入披露，应据实替换。'
bfe compressors cash_tax 2488925.193963319 '公司经营现金税按分配后的业务EBIT占比分摊。' low '分地区税务利润披露后应据实替换。'
bfe compressors operating_cash_flow_contribution -14618268.552224584 '公司经营现金流按收入占比分配。' low '分产品应收存货和应付数据可取得时应重算。'

bf fans revenue fan_rev25 reported '年报分产品披露。' high
bf fans cost_of_revenue fan_cost25 reported '年报分产品披露。' high
bfe fans period_operating_expenses 34331502.97836683 '公司费用按各品类毛利贡献分配。' low '若工业风扇独立团队和渠道费用披露，应据实替换。'
bfe fans cash_tax 701440.3319742491 '公司经营现金税按分配后的业务EBIT占比分摊。' low '分地区税务利润披露后应据实替换。'
bfe fans operating_cash_flow_contribution -3087182.9457188654 '公司经营现金流按收入占比分配。' low '分产品周转数据可取得时应重算。'

bf accessories revenue adj_rev25 reported '年报“配件及其他”分产品披露；业务名称改为具名经济内容以避免无信息占位。' high
bf accessories cost_of_revenue adj_cost25 reported '年报分产品披露。' high
bfe accessories period_operating_expenses 63151264.50444774 '公司费用按各品类毛利贡献分配。' low '若配件、护理设备等独立费用披露，应重拆。'
bfe accessories cash_tax 1290268.1239008394 '公司经营现金税按分配后的业务EBIT占比分摊。' low '分地区税务利润披露后应据实替换。'
bfe accessories operating_cash_flow_contribution -5361756.969321548 '公司经营现金流按收入占比分配。' low '分产品周转数据可取得时应重算。'

# Equity bridge facts and fields at 2025-12-31.
fact cash25 货币资金 786939702.98 2025-12-31 "$src25" 'PDF P110'
fact restricted25 受限货币资金 44514259.08 2025-12-31 "$src25" 'PDF P43'
fact trading25 交易性金融资产 123330000 2025-12-31 "$src25" 'PDF P110'
fact equityinv25 其他权益工具投资 6957366.87 2025-12-31 "$src25" 'PDF P111'
fact invprop25 投资性房地产 88032716.52 2025-12-31 "$src25" 'PDF P111'
fact shortdebt25 短期借款 582276227.63 2025-12-31 "$src25" 'PDF P112'
fact currentdebt25 一年内到期的非流动负债 121053716.83 2025-12-31 "$src25" 'PDF P112'
fact longdebt25 长期借款 415821380.30 2025-12-31 "$src25" 'PDF P113'
fact leasedebt25 租赁负债 26218737.16 2025-12-31 "$src25" 'PDF P113'
fact minority25 少数股东权益 926663.90 2025-12-31 "$src25" 'PDF P114'
fact shares25 期末总股本扣回购专户股份 254351475 2025-12-31 "$src25" 'PDF P3及P62'

ef_estimate excess_cash 592425443.90 '货币资金扣除0.445亿元受限资金和1.5亿元经营必需现金；未再扣尚未支付但已承诺建设款，因其在稳定资本开支中处理。' medium '若现金已承诺用于未入账建设款、境外不可汇回或最低经营现金更高，应下调。'
ef_reported non_operating_assets 'trading25+equityinv25+invprop25' '理财产品、其他权益工具投资和投资性房地产未进入经营FCFF，按账面金额计入。' medium
ef_reported financing_debt 'shortdebt25+currentdebt25+longdebt25+leasedebt25' '短期借款、一年内到期非流动负债、长期借款和租赁负债合计。' high
ef_estimate minority_interest_value 926663.90 '少数股东权益很小且为新设海外子公司，暂以账面权益代理经济价值。' low '若少数股东子公司形成显著盈利或持有独立资产，应单独估值。'
ef_estimate other_priority_claims 0 '未识别出在已计入经营负债、融资负债和稳定资本开支之外的重大优先索偿。' medium '若工程诉讼形成预计负债或存在已承诺未入账重大资本付款，应扣除。'
ef_reported diluted_shares shares25 '总股本扣除回购专户股份；未见可转债或期权等额外稀释工具。' medium
ef_estimate financial_to_trading_fx 1 '财报和交易币种均为人民币。' high '若证券交易币种发生变化，应使用估值日汇率。'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '缺少到达稳定状态前逐年FCFF和全部成长投入的可靠证据，使用稳定经营收益八倍统一标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '马来西亚爬坡期毛利正常化' --before '2025年毛利率28.90%' --after '稳定期毛利率32.50%' --reason '2025年7月投产后折旧和低利用率压低毛利；稳定值仍低于2023—2024年约34%—36%的水平。若达产后仍低于30%，该调整失效。'
python3 "$tool" add-adjustment --model "$model" --name '建设高峰资本开支正常化' --before '2025年现金资本开支3.23亿元' --after '稳定期主营资本开支0.90亿元' --reason '马来西亚、产业园和美国仓储处于集中建设期；稳定期保留高于折旧的更新技改支出，不永久化建设高峰。'
python3 "$tool" add-adjustment --model "$model" --name '现金可分配性' --before '货币资金7.87亿元' --after '多余现金5.92亿元' --reason '扣除受限资金0.45亿元和经营必需现金1.50亿元；诉讼冻结、员工持股专户与工程专户资金不可自由分配。'
python3 "$tool" add-adjustment --model "$model" --name '商誉不单独计值' --before '商誉0.70亿元' --after '从投入资本中剔除，普通股价值不另加' --reason '商誉为收购溢价；只有收购业务形成的持续FCFF才能通过稳定经营收益体现。'

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '2025年马来西亚资产转固导致分母剧增且费用化研发存在，ROIC仅解释资本占用变化，不直接宣称护城河。'
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '重大财务数字均记录到三期年报名称和PDF页码；估计项含理由与可推翻条件。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '财务、投资与公允价值损益从EBIT剔除；现金、金融资产、商誉和债务未重复计值。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定期同时约束收入、毛利、费用、现金税、折旧、资本开支和营运资金，并明示马来西亚达产假设。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告中心判断和重大数字将以编译后的结构化模型为唯一口径。'

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

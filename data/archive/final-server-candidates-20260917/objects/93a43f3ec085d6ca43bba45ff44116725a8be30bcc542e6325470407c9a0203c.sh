#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

python3 "$tool" init --name 冠豪高新 --code 600433.SH --period-label 2025年年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --source "$5" --locator "$6"; }
hist_expr() { python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
hist_est() { python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
cap_est() { python3 "$tool" set-field --model "$model" --view capital --year "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
stable_est() { python3 "$tool" set-field --model "$model" --view stable --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }
equity_expr() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --expression "$2" --basis-type "$3" --reason "$4" --confidence "$5"; }
equity_est() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }

src23='冠豪高新2023年年度报告（2024-03-21）'
url23='https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2024-03-21/600433_20240321_0WNA.pdf'
src24='冠豪高新2024年年度报告（2025-03-11）'
url24='https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2025-03-11/600433_20250311_FI7P.pdf'
src25='冠豪高新2025年年度报告（2026-03-11）'
url25='https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2026-03-11/600433_20260311_ZKDT.pdf'

# 经营原始事实。2023年成本和销售费用采用2024年报追溯比较数，以保持三年口径一致。
fact revenue_2023 营业收入 7403369683.68 2023 "$src24" 'PDF P099'
fact cost_2023 营业成本 6931453757.01 2023 "$src24" 'PDF P099'
fact tax_surcharges_2023 税金及附加 37661029.44 2023 "$src24" 'PDF P099'
fact selling_2023 销售费用 81463814.16 2023 "$src24" 'PDF P099'
fact admin_2023 管理费用 241306873.14 2023 "$src24" 'PDF P099'
fact rd_2023 研发费用 369235949.81 2023 "$src24" 'PDF P099'
fact other_income_2023 其他收益 51294743.75 2023 "$src24" 'PDF P099'
fact da_fixed_2023 固定资产折旧 257165808.88 2023 "$src23" 'PDF P220'
fact da_rou_2023 使用权资产摊销 11479303.92 2023 "$src23" 'PDF P220'
fact da_intangible_2023 无形资产摊销 22782562.90 2023 "$src23" 'PDF P220'
fact da_deferred_2023 长期待摊费用摊销 12536442.57 2023 "$src23" 'PDF P220'
fact gross_capex_2023 购建长期资产支付的现金 719967343.96 2023 "$src23" 'PDF P108'
fact disposal_proceeds_2023 处置长期资产收回的现金净额 4548116.00 2023 "$src23" 'PDF P108'
fact ocf_2023 经营活动产生的现金流量净额 -263051466.86 2023 "$src23" 'PDF P108'
fact interest_2023 利息费用 51930091.66 2023 "$src23" 'PDF P104'

fact revenue_2024 营业收入 7588410655.21 2024 "$src24" 'PDF P099'
fact cost_2024 营业成本 6872117589.00 2024 "$src24" 'PDF P099'
fact tax_surcharges_2024 税金及附加 32890467.02 2024 "$src24" 'PDF P099'
fact selling_2024 销售费用 70325370.35 2024 "$src24" 'PDF P099'
fact admin_2024 管理费用 210662615.32 2024 "$src24" 'PDF P099'
fact rd_2024 研发费用 364996004.99 2024 "$src24" 'PDF P099'
fact other_income_2024 其他收益 88865491.35 2024 "$src24" 'PDF P099'
fact da_fixed_2024 固定资产折旧 286509207.60 2024 "$src24" 'PDF P211'
fact da_rou_2024 使用权资产摊销 11479303.92 2024 "$src24" 'PDF P211'
fact da_intangible_2024 无形资产摊销 22553863.68 2024 "$src24" 'PDF P211'
fact da_deferred_2024 长期待摊费用摊销 8878879.00 2024 "$src24" 'PDF P211'
fact gross_capex_2024 购建长期资产支付的现金 740954256.60 2024 "$src24" 'PDF P104'
fact disposal_proceeds_2024 处置长期资产收回的现金净额 833734.85 2024 "$src24" 'PDF P103'
fact ocf_2024 经营活动产生的现金流量净额 293702098.84 2024 "$src24" 'PDF P103'
fact interest_2024 利息费用 75858503.23 2024 "$src24" 'PDF P099'

fact revenue_2025 营业收入 7151760711.36 2025 "$src25" 'PDF P084'
fact cost_2025 营业成本 6800357352.11 2025 "$src25" 'PDF P084'
fact tax_surcharges_2025 税金及附加 37992484.27 2025 "$src25" 'PDF P084'
fact selling_2025 销售费用 77707343.74 2025 "$src25" 'PDF P084'
fact admin_2025 管理费用 224745335.65 2025 "$src25" 'PDF P084'
fact rd_2025 研发费用 236087540.03 2025 "$src25" 'PDF P084'
fact other_income_2025 其他收益 32858410.59 2025 "$src25" 'PDF P084'
fact da_fixed_2025 固定资产折旧 281386615.25 2025 "$src25" 'PDF P175'
fact da_rou_2025 使用权资产摊销 8621918.52 2025 "$src25" 'PDF P175'
fact da_intangible_2025 无形资产摊销 22958088.31 2025 "$src25" 'PDF P175'
fact da_deferred_2025 长期待摊费用摊销 20051111.29 2025 "$src25" 'PDF P175'
fact gross_capex_2025 购建长期资产支付的现金 891035822.45 2025 "$src25" 'PDF P088'
fact disposal_proceeds_2025 处置长期资产收回的现金净额 470281.00 2025 "$src25" 'PDF P088'
fact ocf_2025 经营活动产生的现金流量净额 -312418334.21 2025 "$src25" 'PDF P088'
fact interest_2025 利息费用 84788834.57 2025 "$src25" 'PDF P084'

for y in 2023 2024 2025; do
  hist_expr "$y" revenue "revenue_$y" reported '合并利润表营业收入。' high
  hist_expr "$y" cost_of_revenue "cost_$y" reported '合并利润表营业成本。' high
  hist_expr "$y" period_operating_expenses "tax_surcharges_$y+selling_$y+admin_$y+rd_$y-other_income_$y" formula '经营期间费用取税金及附加、销售、管理和研发费用，扣除与经营相关的其他收益；排除财务费用、投资收益、减值和处置损益。' medium
  hist_expr "$y" depreciation_amortization "da_fixed_$y+da_rou_$y+da_intangible_$y+da_deferred_$y" formula '现金流量表补充资料所列四类折旧摊销合计。' high
  hist_expr "$y" core_business_capex "gross_capex_$y-disposal_proceeds_$y" formula '购建长期资产现金支出扣除处置回款；化机浆、新纸机、技改均服务现有纸与材料业务，归为主营业务资本开支。' medium
  hist_expr "$y" operating_cash_flow "ocf_$y" reported '合并现金流量表经营活动现金流量净额。' high
done
hist_est 2023 cash_tax 0 '重构EBIT为负，不把会计所得税收益当作可分配经营现金流。' medium '未来披露显示亏损年度仍存在无法抵扣且属于核心经营的现金所得税。'
hist_est 2024 cash_tax 18942614.982 '按重构EBIT的15%估算，匹配主要经营主体高新技术企业税率。' medium '税务附注明确显示正常经营税率显著偏离15%，或税收优惠不可持续。'
hist_est 2025 cash_tax 0 '重构EBIT为负，不将递延所得税收益作为经营现金流。' medium '未来披露显示亏损年度仍存在无法抵扣且属于核心经营的现金所得税。'
hist_est 2023 exploratory_business_capex 0 '公开材料未披露可从长期资产现金支出可靠分离的独立新业务资本开支。' low '公司披露反渗透膜、碳纸等项目的实际现金投资额。'
hist_est 2024 exploratory_business_capex 0 '公开材料未披露可从长期资产现金支出可靠分离的独立新业务资本开支。' low '公司披露反渗透膜、碳纸等项目的实际现金投资额。'
hist_est 2025 exploratory_business_capex 0 '创新中试线与新材料验证存在，但年报未给出其独立现金支出，谨慎不伪造拆分。' low '公司披露反渗透膜、碳纸等项目的实际现金投资额。'
hist_est 2023 operating_working_capital_increase 316418011.089 '用利润路径与现金流路径倒算的经营性营运资金及其他经营应计占用，使FCFF双路径闭合。' medium '逐项现金税、经营应收应付附注可形成显著不同且完整的经营营运资金变动。'
hist_est 2024 operating_working_capital_increase 78580912.5125 '用利润路径与现金流路径倒算的经营性营运资金及其他经营应计占用，使FCFF双路径闭合。' medium '逐项现金税、经营应收应付附注可形成显著不同且完整的经营营运资金变动。'
hist_est 2025 operating_working_capital_increase 381094624.3455 '用利润路径与现金流路径倒算；与现金流量表中存货增加、经营应付减少方向一致。' medium '逐项现金税、经营应收应付附注可形成显著不同且完整的经营营运资金变动。'
hist_est 2023 after_tax_interest_in_operating_cash_flow 44140577.911 '利息费用按15%税率税后加回，恢复融资前口径。' medium '实际现金利息及其税盾与利润表利息费用显著不同。'
hist_est 2024 after_tax_interest_in_operating_cash_flow 64479727.7455 '利息费用按15%税率税后加回，恢复融资前口径。' medium '实际现金利息及其税盾与利润表利息费用显著不同。'
hist_est 2025 after_tax_interest_in_operating_cash_flow 72070509.3845 '利息费用按15%税率税后加回，恢复融资前口径。' medium '实际现金利息及其税盾与利润表利息费用显著不同。'

# 资本口径：营运资金逐项重构；长期经营资产包含固定资产、在建工程、使用权资产、经营无形资产、开发支出、商誉、长期待摊及项目预付款，扣递延收益。
cap_est 2022 operating_working_capital 921105338.24 '按2023年报P099-P101的2022比较数重构经营应收、存货和经营应付净额，剔除现金与融资负债。' medium '附注明确表明大额应收、预付、其他应收或应付属于非经营。'
cap_est 2023 operating_working_capital 1465604769.61 '按2023年报P099-P101经营流动资产减经营流动负债重构。' medium '附注明确表明大额应收、预付、其他应收或应付属于非经营。'
cap_est 2024 operating_working_capital 1541297746.25 '按2024年报P095-P097重构，并剔除一年内到期定期存款1.59亿元。' medium '其他流动资产或应付款的经营分类出现重大变化。'
cap_est 2025 operating_working_capital 1445306392.93 '按2025年报P080-P082重构，并剔除一年内到期定期存款6.33亿元。' medium '其他流动资产或应付款的经营分类出现重大变化。'
cap_est 2022 operating_long_term_assets_net 4558040348.51 '由2023年报P100-P101的经营性长期资产项目合计并扣除递延收益。' medium '其他非流动资产并非项目预付款，或工程应付款需从长期资产额外扣除。'
cap_est 2023 operating_long_term_assets_net 5254828144.48 '由2023年报P100-P101的经营性长期资产项目合计并扣除递延收益。' medium '其他非流动资产并非项目预付款，或工程应付款需从长期资产额外扣除。'
cap_est 2024 operating_long_term_assets_net 5831489807.42 '由2024年报P095-P097的经营性长期资产项目合计并扣除递延收益。' medium '其他非流动资产并非项目预付款，或工程应付款需从长期资产额外扣除。'
cap_est 2025 operating_long_term_assets_net 6516531159.65 '由2025年报P080-P082的经营性长期资产项目合计并扣除递延收益。' medium '其他非流动资产并非项目预付款，或工程应付款需从长期资产额外扣除。'
for y in 2022 2023 2024 2025; do
  cap_est "$y" required_cash 600000000 '约相当于一个月现金经营支出的流动性缓冲；公司未直接披露最低经营现金。' low '月度结算、授信额度或现金转换周期证明更低或更高缓冲即可维持经营。'
done
cap_est 2022 unsupported_intangible_assets 11547305.29 '商誉不能由当前经营收益解释，从投入资本中剔除。' high '被收购业务形成可独立验证的持续超额经营收益。'
cap_est 2023 unsupported_intangible_assets 11547305.29 '商誉不能由当前经营收益解释，从投入资本中剔除。' high '被收购业务形成可独立验证的持续超额经营收益。'
cap_est 2024 unsupported_intangible_assets 11547305.29 '商誉不能由当前经营收益解释，从投入资本中剔除。' high '被收购业务形成可独立验证的持续超额经营收益。'
cap_est 2025 unsupported_intangible_assets 2418280.28 '减值后剩余商誉仍缺少独立收益证据，从投入资本中剔除。' high '被收购业务形成可独立验证的持续超额经营收益。'

# 稳定期：不假设白卡纸回到历史高景气，只给行业低谷后的温和常态化。
stable_est revenue 7400000000 '取三年收入中枢附近；特种纸销量增长与白卡纸价格压力相互抵消。' medium '新增产能稳定达产后销量或价格使常态收入持续低于70亿元或高于80亿元。'
stable_est cost_of_revenue 6808000000 '对应8.0%毛利率，低于2024年、但高于2025年关停切换和爬坡期。' low '化机浆与新纸机投产后仍无法把毛利率稳定在8%左右。'
stable_est period_operating_expenses 540000000 '接近2025年重构期间费用，保留研发和总部费用，不继续外推关停导致的研发下降。' medium '组织重构或研发强度使经常性期间费用稳定偏离5.4亿元。'
stable_est cash_tax 7800000 '稳定EBIT 0.52亿元按主要经营主体15%税率估算。' medium '高新技术税率取消或稳定期可利用亏损抵扣改变现金税负。'
stable_est depreciation_amortization 330000000 '取最近两年折旧摊销约3.3亿元的代表值。' medium '新纸机与化机浆全部转固后折旧摊销显著高于该水平。'
stable_est core_business_capex 330000000 '稳定期以折旧摊销作为主营业务长期替换投入的基准；不把建设期近9亿元支出永久化。' low '成熟运行后的环保、技改和替换现金支出持续显著高于折旧。'
stable_est exploratory_business_capex 0 '基准估值不给尚处准入验证阶段的反渗透膜支撑材、碳纸原纸额外价值或永久支出。' low '新业务形成可验证订单、利润、资本计划与持续资金需求。'
stable_est operating_working_capital_increase 0 '成熟收入中枢下不假设永久新增营运资金占用。' medium '库存、账期或原料储备在稳定收入下仍持续上升。'

# 最新年度业务：按年报两个经济行业拆分；合并口径的附营收入和成本按主营收入/成本比例归入两条业务线。
python3 "$tool" add-business --model "$model" --business-id specialty_paper --name 特种纸及纸制品 --importance '收入占比约82%，覆盖热敏、热升华和高档白卡纸；决定集团价格、浆耗、产能利用率和大部分资本占用。' --confidence medium --falsifier '公司披露足以独立拆分热敏纸与白卡纸的完整利润和现金数据。'
python3 "$tool" add-business --model "$model" --business-id specialty_materials --name 不干胶及化工特种材料 --importance '覆盖不干胶、胶乳及其他特种材料，毛利率高于纸业务但规模较小。' --confidence medium --falsifier '公司披露不干胶、化工和新材料各自完整利润与现金数据。'
biz_est() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
biz_est specialty_paper revenue 5861232593.414819 '年报P16披露特种纸主营收入57.57亿元；合并与主营差额按主营收入比例归入对应业务。' medium '附营业务可直接归属到另一业务线。'
biz_est specialty_paper cost_of_revenue 5635181555.705153 '年报P16披露特种纸主营成本55.56亿元；合并与主营差额按主营成本比例归入。' medium '附营成本可直接归属到另一业务线。'
biz_est specialty_paper period_operating_expenses 445568806.83351433 '公司费用未按业务披露，按合并收入比例分配以形成单一闭合基准。' low '公司提供分业务销售、管理、研发和其他经营收益。'
biz_est specialty_paper cash_tax 0 '该业务基准EBIT为负，不确认经营现金税。' low '业务级应纳税所得额显示有正的现金税。'
biz_est specialty_paper operating_cash_flow_contribution -256042756.06472266 '公司未披露业务现金流，按收入比例分配合并经营现金流。' low '业务级回款、库存和应付数据可直接重构现金贡献。'
biz_est specialty_materials revenue 1290528117.945181 '年报P16披露特种材料主营收入12.68亿元；合并与主营差额按主营收入比例归入。' medium '附营业务可直接归属到另一业务线。'
biz_est specialty_materials cost_of_revenue 1165175796.4048462 '年报P16披露特种材料主营成本11.49亿元；合并与主营差额按主营成本比例归入。' medium '附营成本可直接归属到另一业务线。'
biz_est specialty_materials period_operating_expenses 98105486.26648557 '公司费用未按业务披露，按合并收入比例分配以形成单一闭合基准。' low '公司提供分业务销售、管理、研发和其他经营收益。'
biz_est specialty_materials cash_tax 0 '分配后业务EBIT约0.27亿元，但公司合并经营亏损且可利用亏损，基准不确认现金税。' low '业务级税务资料证明存在不可抵扣的正现金税。'
biz_est specialty_materials operating_cash_flow_contribution -56375578.14527732 '公司未披露业务现金流，按收入比例分配合并经营现金流。' low '业务级回款、库存和应付数据可直接重构现金贡献。'

# 股权价值桥原始事实。
fact cash_2025 货币资金 740230639.05 2025 "$src25" 'PDF P080'
fact term_deposits_2025 一年内到期定期存款大额存单及利息 632885576.93 2025 "$src25" 'PDF P136'
fact restricted_cash_2025 冻结银行存款 707993.57 2025 "$src25" 'PDF P176'
fact lteq_2025 长期股权投资 672813473.39 2025 "$src25" 'PDF P080、P23'
fact financial_asset_2025 其他非流动金融资产 288700.00 2025 "$src25" 'PDF P080'
fact short_debt_2025 短期借款 1892451371.81 2025 "$src25" 'PDF P081'
fact current_long_debt_2025 一年内到期的非流动负债 526081168.87 2025 "$src25" 'PDF P081'
fact long_debt_2025 长期借款 2073910540.33 2025 "$src25" 'PDF P081'
fact lease_debt_2025 租赁负债 330217.80 2025 "$src25" 'PDF P081'
fact minority_2025 少数股东权益 1390297973.40 2025 "$src25" 'PDF P082'
fact shares_2025 期末股本 1750279233 2025 "$src25" 'PDF P082'
equity_expr excess_cash 'cash_2025+term_deposits_2025-restricted_cash_2025-600000000' formula '账面资金及一年内定期存款扣除冻结资金与6亿元经营必需现金。' medium
equity_expr non_operating_assets 'lteq_2025+financial_asset_2025' formula '诚通财务长期股权投资及独立金融资产按账面值计入；对应投资收益已从经营EBIT剔除。' medium
equity_expr financing_debt 'short_debt_2025+current_long_debt_2025+long_debt_2025+lease_debt_2025' formula '短期借款、一年内到期非流动负债、长期借款及租赁负债合计。' high
equity_est minority_interest_value 1390297973.40 '缺少子公司独立FCFF估值条件，以少数股东账面权益作为经济价值替代值。' low '主要非全资子公司的独立经营价值、债务、现金和持股比例可完成穿透估值。'
equity_est other_priority_claims 0 '未发现未在经营资本或融资负债中处理的重大优先索偿。' medium '出现已承诺未支付的大额建设款、优先股或其他股东前索偿。'
equity_expr diluted_shares shares_2025 reported '2025年末股本；报告期末未见仍需额外计入的实质潜在摊薄工具。' high

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '项目投产后的正常盈利、资本开支和营运资金证据尚不足以建立逐年成长折现路径，采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '经营利润重构' --before '利润表营业利润混入投资收益、财务费用、减值及处置损益' --after 'EBIT仅保留毛利、经营费用及经营性其他收益' --reason '避免融资、诚通财务投资回报和2025年关停减值改变核心经营判断。'
python3 "$tool" add-adjustment --model "$model" --name '资本开支净额' --before '购建长期资产现金支出' --after '扣除经营性长期资产处置回款' --reason 'FCFF采用净现金资本开支；三年项目均服务现有业务，未可靠拆出开拓性支出。'
python3 "$tool" add-adjustment --model "$model" --name '现金与定期存款可达性' --before '货币资金7.40亿元，加一年内定期存款6.33亿元' --after '多余现金7.72亿元' --reason '扣除冻结资金0.01亿元和估计经营必需现金6.00亿元。'
python3 "$tool" add-adjustment --model "$model" --name '少数股东经济价值' --before '缺少子公司独立估值' --after '按账面少数股东权益13.90亿元' --reason '并表经营现金流包含非归母部分；账面值仅是证据不足时的替代估计。'

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '历史主表、现金流补充资料、资本项目及价值桥重大金额均保存来源文件与PDF页码。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '经营EBIT排除融资、投资、减值和处置项目；现金、定期存款、诚通财务投资、融资负债和少数股东分别处理。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定状态使用三年收入中枢、温和毛利修复、正常费用和折旧水平，不采用2024单年高点或管理层远期目标。'
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '投入资本分母以经营流动与长期资产重构，规模为70亿元上下；虽含估计但不接近零，ROIC方向可解释，精确点值需谨慎。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告中心判断、重大数字和估值桥将直接采用结构化模型及程序生成转写表。'

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"


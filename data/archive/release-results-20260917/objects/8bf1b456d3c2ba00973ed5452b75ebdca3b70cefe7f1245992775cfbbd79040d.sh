#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope consolidated --source "$5" --locator "$6"
}

field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}

field_est() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

s23='安徽六国化工股份有限公司2023年年度报告（2024-04-20）'
s24='安徽六国化工股份有限公司2024年年度报告（2025-03-18）'
s25='安徽六国化工股份有限公司2025年年度报告（2026-04-21）'

# Historical operations and cash flow (yuan).
fact rev23 营业收入 6932799256.80 2023 "$s23" '第74页，合并利润表'
fact cost23 营业成本 6374556918.82 2023 "$s23" '第74页，合并利润表'
fact op23 营业利润 60576414.54 2023 "$s23" '第75页，合并利润表'
fact fin23 财务费用 23288867.28 2023 "$s23" '第74页，合并利润表'
fact invinc23 投资收益 33862027.78 2023 "$s23" '第74页，合并利润表'
fact disp23 资产处置收益 939042.29 2023 "$s23" '第75页，合并利润表'
fact tax23 当期所得税费用 6165837.42 2023 "$s23" '第160页，所得税费用附注'
fact dafa23 固定资产折旧 226174512.70 2023 "$s23" '第164页，现金流量表补充资料'
fact darou23 使用权资产摊销 917377.44 2023 "$s23" '第164页，现金流量表补充资料'
fact daia23 无形资产摊销 11917442.84 2023 "$s23" '第164页，现金流量表补充资料'
fact daltd23 长期待摊费用摊销 71379.70 2023 "$s23" '第164页，现金流量表补充资料'
fact ocf23 经营活动产生的现金流量净额 393330126.79 2023 "$s23" '第78页，合并现金流量表'
fact capexgross23 购建固定资产无形资产和其他长期资产支付的现金 532887054.49 2023 "$s23" '第78页，合并现金流量表'
fact disposalcash23 处置固定资产无形资产和其他长期资产收回的现金净额 3480890.00 2023 "$s23" '第78页，合并现金流量表'
fact explore23 湖北徽阳新能源新材料一体化项目本期增加金额 57342445.42 2023 "$s23" '第139页，重要在建工程项目本期变动情况'

fact rev24 营业收入 6251024171.70 2024 "$s24" '第82页，合并利润表'
fact cost24 营业成本 5666229901.35 2024 "$s24" '第82页，合并利润表'
fact op24 营业利润 57417995.42 2024 "$s24" '第82页，合并利润表'
fact fin24 财务费用 41748437.14 2024 "$s24" '第82页，合并利润表'
fact invinc24 投资收益 19184964.55 2024 "$s24" '第82页，合并利润表'
fact disp24 资产处置收益 115713.38 2024 "$s24" '第82页，合并利润表'
fact tax24 当期所得税费用 13133340.24 2024 "$s24" '第170页，所得税费用附注'
fact dafa24 固定资产折旧 227900730.35 2024 "$s24" '第173页，现金流量表补充资料'
fact darou24 使用权资产摊销 1116325.68 2024 "$s24" '第173页，现金流量表补充资料'
fact daia24 无形资产摊销 13338123.78 2024 "$s24" '第173页，现金流量表补充资料'
fact daltd24 长期待摊费用摊销 25017.44 2024 "$s24" '第173页，现金流量表补充资料'
fact ocf24 经营活动产生的现金流量净额 388600816.92 2024 "$s24" '第85页，合并现金流量表'
fact capexgross24 购建固定资产无形资产和其他长期资产支付的现金 439762850.60 2024 "$s24" '第85页，合并现金流量表'
fact disposalcash24 处置固定资产无形资产和其他长期资产收回的现金净额 584560.86 2024 "$s24" '第85页，合并现金流量表'
fact explore24 湖北徽阳新能源新材料一体化项目本期增加金额 176299002.75 2024 "$s24" '第145页，重要在建工程项目本期变动情况'

fact rev25 营业收入 6442322613.18 2025 "$s25" '第73页，合并利润表'
fact cost25 营业成本 6133860611.77 2025 "$s25" '第73页，合并利润表'
fact op25 营业利润 -408745023.73 2025 "$s25" '第74页，合并利润表'
fact fin25 财务费用 41697752.20 2025 "$s25" '第73页，合并利润表'
fact invinc25 投资收益 18146937.72 2025 "$s25" '第73页，合并利润表'
fact disp25 资产处置收益 8712.09 2025 "$s25" '第73页，合并利润表'
fact impair25 资产减值损失 157928427.41 2025 "$s25" '第73页，合并利润表；原表列示为负损失，此处保存损失绝对额'
fact tax25 当期所得税费用 21344723.71 2025 "$s25" '第162页，所得税费用附注'
fact dafa25 固定资产折旧 238630402.87 2025 "$s25" '第166页，现金流量表补充资料'
fact darou25 使用权资产摊销 1613512.50 2025 "$s25" '第166页，现金流量表补充资料'
fact daia25 无形资产摊销 13484384.54 2025 "$s25" '第166页，现金流量表补充资料'
fact daltd25 长期待摊费用摊销 40345.31 2025 "$s25" '第166页，现金流量表补充资料'
fact ocf25 经营活动产生的现金流量净额 43356733.89 2025 "$s25" '第76页，合并现金流量表'
fact capexgross25 购建固定资产无形资产和其他长期资产支付的现金 1382796711.79 2025 "$s25" '第76页，合并现金流量表'
fact disposalcash25 处置固定资产无形资产和其他长期资产收回的现金净额 346217.55 2025 "$s25" '第76页，合并现金流量表'
fact explore25 湖北徽阳新能源新材料一体化项目本期增加金额 966800568.74 2025 "$s25" '第137页，重要在建工程项目本期变动情况'

# Historical model fields. Operating cash tax uses current tax; 2025 EBIT excludes the disclosed large impairment.
field_expr historical 2023 revenue rev23 reported '合并利润表直接数' high
field_expr historical 2023 cost_of_revenue cost23 reported '合并利润表直接数' high
field_expr historical 2023 period_operating_expenses 'rev23-cost23-(op23+fin23-invinc23-disp23)' formula '由毛利减去剔除融资和投资收益后的EBIT重构' medium
field_expr historical 2023 cash_tax tax23 reported '以当期所得税费用近似经营现金税' medium
field_expr historical 2023 depreciation_amortization 'dafa23+darou23+daia23+daltd23' formula '经营资产折旧摊销合计' high
field_expr historical 2023 exploratory_business_capex explore23 reported '新能源新材料一体化项目本期新增投入，作为开拓性资本开支代理' medium
field_expr historical 2023 core_business_capex 'capexgross23-disposalcash23-explore23' formula '净现金资本开支扣除开拓性项目投入' medium
field_expr historical 2023 operating_cash_flow ocf23 reported '合并现金流量表直接数' high
field_est historical 2023 after_tax_interest_in_operating_cash_flow 0 '中国准则现金流量表将偿付利息列入筹资活动，经营现金流无需加回利息' high '若附注表明重大利息被计入经营现金流，则需加回税后金额'
field_expr historical 2023 operating_working_capital_increase '((op23+fin23-invinc23-disp23)-tax23)+(dafa23+darou23+daia23+daltd23)-ocf23' formula '以NOPAT加折旧摊销减经营现金流反推全部经营现金转换占用，确保利润与现金路径闭合' medium

field_expr historical 2024 revenue rev24 reported '合并利润表直接数' high
field_expr historical 2024 cost_of_revenue cost24 reported '合并利润表直接数' high
field_expr historical 2024 period_operating_expenses 'rev24-cost24-(op24+fin24-invinc24-disp24)' formula '由毛利减去剔除融资和投资收益后的EBIT重构' medium
field_expr historical 2024 cash_tax tax24 reported '以当期所得税费用近似经营现金税' medium
field_expr historical 2024 depreciation_amortization 'dafa24+darou24+daia24+daltd24' formula '经营资产折旧摊销合计' high
field_expr historical 2024 exploratory_business_capex explore24 reported '新能源新材料一体化项目本期新增投入，作为开拓性资本开支代理' medium
field_expr historical 2024 core_business_capex 'capexgross24-disposalcash24-explore24' formula '净现金资本开支扣除开拓性项目投入' medium
field_expr historical 2024 operating_cash_flow ocf24 reported '合并现金流量表直接数' high
field_est historical 2024 after_tax_interest_in_operating_cash_flow 0 '中国准则现金流量表将偿付利息列入筹资活动，经营现金流无需加回利息' high '若附注表明重大利息被计入经营现金流，则需加回税后金额'
field_expr historical 2024 operating_working_capital_increase '((op24+fin24-invinc24-disp24)-tax24)+(dafa24+darou24+daia24+daltd24)-ocf24' formula '以NOPAT加折旧摊销减经营现金流反推全部经营现金转换占用，确保利润与现金路径闭合' medium

field_expr historical 2025 revenue rev25 reported '合并利润表直接数' high
field_expr historical 2025 cost_of_revenue cost25 reported '合并利润表直接数' high
field_expr historical 2025 period_operating_expenses 'rev25-cost25-(op25+fin25-invinc25-disp25+impair25)' formula '由毛利减去调整后EBIT重构；剔除1.579亿元存货及固定资产减值' medium
field_expr historical 2025 cash_tax tax25 reported '以当期所得税费用近似经营现金税；亏损集团内仍有盈利纳税主体' medium
field_expr historical 2025 depreciation_amortization 'dafa25+darou25+daia25+daltd25' formula '经营资产折旧摊销合计' high
field_expr historical 2025 exploratory_business_capex explore25 reported '新能源新材料一体化项目本期新增投入，作为开拓性资本开支代理' medium
field_expr historical 2025 core_business_capex 'capexgross25-disposalcash25-explore25' formula '净现金资本开支扣除开拓性项目投入' medium
field_expr historical 2025 operating_cash_flow ocf25 reported '合并现金流量表直接数' high
field_est historical 2025 after_tax_interest_in_operating_cash_flow 0 '中国准则现金流量表将偿付利息列入筹资活动，经营现金流无需加回利息' high '若附注表明重大利息被计入经营现金流，则需加回税后金额'
field_expr historical 2025 operating_working_capital_increase '((op25+fin25-invinc25-disp25+impair25)-tax25)+(dafa25+darou25+daia25+daltd25)-ocf25' formula '以调整后NOPAT加折旧摊销减经营现金流反推全部经营现金转换占用，确保利润与现金路径闭合' medium

# Capital facts: operating working capital inputs and operating long-lived assets.
for row in \
  'y22_ar|应收账款|81970188.78|2022|第70页' 'y22_arf|应收款项融资|58294524.39|2022|第70页' 'y22_pre|预付款项|416336827.25|2022|第70页' 'y22_oth|其他应收款扣除应收股利|13307263.35|2022|第70页' 'y22_inv|存货|1471027320.20|2022|第70页' 'y22_oca|其他流动资产|59979612.12|2022|第70页' 'y22_np|应付票据|508312404.98|2022|第71页' 'y22_ap|应付账款|712990333.30|2022|第71页' 'y22_cl|合同负债|674928605.19|2022|第71页' 'y22_emp|应付职工薪酬|40975539.79|2022|第71页' 'y22_tax|应交税费|32232416.58|2022|第71页' 'y22_op|其他应付款|120047277.67|2022|第71页' 'y22_ocl|其他流动负债|58583651.23|2022|第71页' \
  'y22_fa|固定资产|2191659714.16|2022|第70页' 'y22_cip|在建工程|154601653.94|2022|第70页' 'y22_rou|使用权资产|18957037.86|2022|第70页' 'y22_ia|无形资产|276327684.78|2022|第70页' 'y22_ltda|长期待摊费用|124254.58|2022|第71页' 'y22_onca|其他非流动资产|55003955.35|2022|第71页' 'y22_prov|预计负债|11117675.23|2022|第72页' 'y22_def|递延收益|60955084.39|2022|第72页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; fact "$id" "$item" "$amt" "$period" "$s23" "$loc，合并资产负债表"
done

for row in \
  'y23_ar|应收账款|194682631.97|2023|第78页' 'y23_arf|应收款项融资|86514825.32|2023|第78页' 'y23_pre|预付款项|233633276.32|2023|第78页' 'y23_oth|其他应收款|6236598.95|2023|第78页' 'y23_inv|存货|1217014482.35|2023|第78页' 'y23_oca|其他流动资产|63527870.69|2023|第78页' 'y23_np|应付票据|654810000|2023|第79页' 'y23_ap|应付账款|636393460.36|2023|第79页' 'y23_cl|合同负债|430469568.45|2023|第79页' 'y23_emp|应付职工薪酬|29295173.55|2023|第79页' 'y23_tax|应交税费|35359247.52|2023|第79页' 'y23_op|其他应付款|108276659.19|2023|第79页' 'y23_ocl|其他流动负债|37278667.50|2023|第79页' \
  'y23_fa|固定资产|2387602599.52|2023|第78页' 'y23_cip|在建工程|198411972.52|2023|第78页' 'y23_rou|使用权资产|18733553.92|2023|第78页' 'y23_ia|无形资产|377289807.85|2023|第78页' 'y23_ltda|长期待摊费用|52874.88|2023|第78页' 'y23_onca|其他非流动资产|21596015.87|2023|第78页' 'y23_prov|预计负债|4741133.93|2023|第79页' 'y23_def|递延收益|92998043.52|2023|第79页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; fact "$id" "$item" "$amt" "$period" "$s24" "$loc，合并资产负债表"
done

for row in \
  'y24_ar|应收账款|123439684.22|2024|第78页' 'y24_arf|应收款项融资|89335234.04|2024|第78页' 'y24_pre|预付款项|191521093.61|2024|第78页' 'y24_oth|其他应收款扣除应收股利|3980569.51|2024|第78页' 'y24_inv|存货|1775862972.45|2024|第78页' 'y24_oca|其他流动资产|105275273.32|2024|第78页' 'y24_np|应付票据|1130935766.39|2024|第79页' 'y24_ap|应付账款|901114882.46|2024|第79页' 'y24_cl|合同负债|334576482.42|2024|第79页' 'y24_emp|应付职工薪酬|33693136.20|2024|第79页' 'y24_tax|应交税费|28089410.50|2024|第79页' 'y24_op|其他应付款|114374399.53|2024|第79页' 'y24_ocl|其他流动负债|29334213.48|2024|第79页' \
  'y24_fa|固定资产|2495970373.78|2024|第78页' 'y24_cip|在建工程|403449757.06|2024|第78页' 'y24_rou|使用权资产|17617228.24|2024|第78页' 'y24_ia|无形资产|369759621.53|2024|第78页' 'y24_ltda|长期待摊费用|27857.44|2024|第78页' 'y24_onca|其他非流动资产|25164456.50|2024|第78页' 'y24_prov|预计负债|9148509.41|2024|第79页' 'y24_def|递延收益|111622626.58|2024|第79页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; fact "$id" "$item" "$amt" "$period" "$s24" "$loc，合并资产负债表"
done

for row in \
  'y25_ar|应收账款|64278148.93|2025|第69页' 'y25_arf|应收款项融资|56804038.26|2025|第69页' 'y25_pre|预付款项|211384768.62|2025|第69页' 'y25_oth|其他应收款扣除应收股利|12159732.51|2025|第69页' 'y25_inv|存货|1340848106.79|2025|第69页' 'y25_oca|其他流动资产|140157057.70|2025|第69页' 'y25_np|应付票据|786852937.68|2025|第70页' 'y25_ap|应付账款|979970826.30|2025|第70页' 'y25_cl|合同负债|418899539.23|2025|第70页' 'y25_emp|应付职工薪酬|38285155.96|2025|第70页' 'y25_tax|应交税费|17047975.66|2025|第70页' 'y25_op|其他应付款|100539905.95|2025|第70页' 'y25_ocl|其他流动负债|55232640.25|2025|第70页' \
  'y25_fa|固定资产|2392243760.59|2025|第69页' 'y25_cip|在建工程|1728399210.85|2025|第69页' 'y25_rou|使用权资产|19976192.27|2025|第69页' 'y25_ia|无形资产|357548278.83|2025|第69页' 'y25_ltda|长期待摊费用|142306.63|2025|第69页' 'y25_onca|其他非流动资产|67738149.67|2025|第69页' 'y25_prov|预计负债|5098829.68|2025|第70页' 'y25_def|递延收益|119043099.78|2025|第70页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; fact "$id" "$item" "$amt" "$period" "$s25" "$loc，合并资产负债表"
done

for y in 22 23 24 25; do
  yr=$((2000+y))
  field_expr capital "$yr" operating_working_capital "y${y}_ar+y${y}_arf+y${y}_pre+y${y}_oth+y${y}_inv+y${y}_oca-y${y}_np-y${y}_ap-y${y}_cl-y${y}_emp-y${y}_tax-y${y}_op-y${y}_ocl" formula '经营性流动资产扣除无息经营负债；应收股利不计入经营资产' medium
  field_expr capital "$yr" operating_long_term_assets_net "y${y}_fa+y${y}_cip+y${y}_rou+y${y}_ia+y${y}_ltda+y${y}_onca-y${y}_prov-y${y}_def" formula '长期经营资产扣除预计负债与资产相关递延收益' medium
  req=400000000; [[ "$y" == 25 ]] && req=500000000
  field_est capital "$yr" required_cash "$req" '按约一个月采购、人工、税费及其他经营现金支出，并考虑季节性备货与信用证结算缓冲估计' low '若月度资金流水、可随时使用授信和采购账期证明更低或更高的最低现金需求，则调整'
  field_est capital "$yr" unsupported_intangible_assets 0 '账面无商誉；无形资产主要为服务生产的土地和经营权利，未发现无法解释的并购溢价' medium '若披露存在不再服务主营或无法由经营收益支持的无形资产，则予以剔除'
done

# Stable state: cycle-midpoint gross margin with no value assigned to the unproven Hubei project.
field_est stable '' revenue 6450000000 '以三年64.4、62.5、69.3亿元收入和现有产能为锚，取不依赖湖北徽阳全面达产的中周期收入' medium '若现有业务连续两年销量或产品价格使收入偏离该值15%以上，则重估'
field_est stable '' cost_of_revenue 5914650000 '对应8.3%中周期毛利率，介于2023、2024正常水平与2025成本冲击年度之间' low '若硫酸硫磺钾肥成本传导或出口政策使毛利率连续两年高于10%或低于6%，则重估'
field_est stable '' period_operating_expenses 520000000 '参考2023至2025剔除重大减值后的期间经营费用约5.05至5.36亿元' medium '若组织、研发或补助结构使正常费用连续两年偏离10%以上，则重估'
field_est stable '' cash_tax 2300000 '按稳定EBIT约1535万元的15%高新技术企业税率估计' low '若税收优惠、亏损结转或盈利子公司结构发生实质变化，则调整'
field_est stable '' depreciation_amortization 250000000 '接近最近三年2.39至2.54亿元折旧摊销水平' medium '湖北徽阳转固后若折旧显著增加且稳定收入利润可证实，则同步调整'
field_est stable '' core_business_capex 300000000 '高于折旧，反映重化工安全环保、技改和老旧磷肥装置持续投入，低于建设高峰实际支出' low '若连续三年维持性现金资本开支低于2.5亿元或高于4亿元且产能不变，则调整'
field_est stable '' exploratory_business_capex 0 '稳定经营收益不把未稳定盈利的新业务重复作为永久支出；项目投入已在历史现金消耗中展示' medium '若形成持续滚动的新业务投资制度，则稳定期需加入常态开拓支出'
field_est stable '' operating_working_capital_increase 0 '成熟且不增长的稳定状态不假设永久增加营运资金' medium '若长期备货或客户账期要求形成持续资本占用，则改为正值'

# Latest-year named economic businesses. Product revenue/cost is disclosed; common expenses, tax and cash are estimated to exact company totals.
python3 "$tool" add-business --model "$model" --business-id compound --name '复合肥' --importance '收入约三分之一，依赖品牌渠道和终端网点，原料以磷铵、尿素和钾盐为主' --confidence medium --falsifier '若分产品费用与回款披露显示其利润或现金贡献与按收入和毛利分配显著不同，则重估'
python3 "$tool" add-business --model "$model" --business-id phosphate --name '磷肥（磷酸一铵与磷酸二铵）' --importance '公司最大收入来源，受磷矿、硫酸、液氨、出口管控和稳价保供共同影响' --confidence medium --falsifier '若公司披露MAP与DAP独立成本费用现金流，替换当前合并估计'
python3 "$tool" add-business --model "$model" --business-id nitrogen --name '尿素与氨水' --importance '合成氨装置向内供料并对外销售氮肥和氨水，2025年仍保有正毛利' --confidence low --falsifier '若内部转移定价或独立子公司现金税披露与当前分配冲突，则重估'
python3 "$tool" add-business --model "$model" --business-id industrial --name '精制磷酸、硫酸钾及工业副产品与配套服务' --importance '承接精制磷酸新材料方向、资源综合利用产品和非产品配套收入' --confidence low --falsifier '若附注披露其他业务构成或新材料项目商业化分部数据，则按实际经济业务重新拆分'

biz_est() {
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}
}

common_falsifier='若披露分产品期间费用、纳税主体或现金流数据，则用直接数替换分配估计'
biz_est compound revenue 2139620133.81 estimate '2025年报第16页主营业务分产品收入直接数' high '若年报更正分产品收入则更新'
biz_est compound cost_of_revenue 2037762332.6164863 estimate '披露产品成本加按收入分配的运输履约成本' medium '若公司披露复合肥实际运输履约成本则替换'
biz_est compound period_operating_expenses 177928467.83257544 estimate '公司期间经营费用按收入占比分配' low "$common_falsifier"
biz_est compound cash_tax 0 estimate '合并当期税费分配给估计为正EBIT的纳税业务' low "$common_falsifier"
biz_est compound operating_cash_flow_contribution 14316906.331349937 estimate '公司经营现金流按各业务毛利贡献分配' low "$common_falsifier"

biz_est phosphate revenue 3189911435.37 estimate '2025年报第16页主营业务分产品收入直接数' high '若年报更正分产品收入则更新'
biz_est phosphate cost_of_revenue 3029601580.447463 estimate '披露产品成本加按收入分配的运输履约成本' medium '若公司披露磷肥实际运输履约成本则替换'
biz_est phosphate period_operating_expenses 265269542.59227252 estimate '公司期间经营费用按收入占比分配' low "$common_falsifier"
biz_est phosphate cash_tax 0 estimate '合并当期税费分配给估计为正EBIT的纳税业务' low "$common_falsifier"
biz_est phosphate operating_cash_flow_contribution 22532797.193980798 estimate '公司经营现金流按各业务毛利贡献分配' low "$common_falsifier"

biz_est nitrogen revenue 482036539.55 estimate '2025年报第16页尿素与氨水收入之和' high '若内部销售抵销口径变化则重估'
biz_est nitrogen cost_of_revenue 426698917.49212426 estimate '尿素与氨水披露成本加按收入分配的运输履约成本' medium '若公司披露该业务实际运输履约成本则替换'
biz_est nitrogen period_operating_expenses 40085630.886601314 estimate '公司期间经营费用按收入占比分配' low "$common_falsifier"
biz_est nitrogen cash_tax 21344723.71 estimate '合并当期所得税全部分配至估计为正EBIT的尿素与氨水业务' low "$common_falsifier"
biz_est nitrogen operating_cash_flow_contribution 7778133.263421586 estimate '公司经营现金流按各业务毛利贡献分配' low "$common_falsifier"

biz_est industrial revenue 630754504.45 estimate '磷酸、硫酸钾、其他产品及其他业务收入闭合值' medium '若其他业务附注给出经济构成则重新归类'
biz_est industrial cost_of_revenue 639797781.2139268 estimate '相关披露产品成本、其他业务成本及运输履约成本闭合值' medium '若其他业务与运输成本明细披露则重新归类'
biz_est industrial period_operating_expenses 52452854.02855064 estimate '公司期间经营费用按收入占比分配' low "$common_falsifier"
biz_est industrial cash_tax 0 estimate '合并当期税费分配给估计为正EBIT的纳税业务' low "$common_falsifier"
biz_est industrial operating_cash_flow_contribution -1271102.8987523187 estimate '公司经营现金流按各业务毛利贡献分配，负毛利业务为负贡献' low "$common_falsifier"

# Equity value bridge.
fact cash25 货币资金 1027271996.47 2025 "$s25" '第69页，合并资产负债表'
fact restricted25 受限货币资金 295588371.61 2025 "$s25" '第23页，截至报告期末主要资产受限情况'
fact equityinv25 其他权益工具投资 306250000.00 2025 "$s25" '第132页，宜昌明珠磷化工业有限公司投资'
fact lti25 长期股权投资 10616377.87 2025 "$s25" '第131页，联营企业投资'
fact shortdebt25 短期借款 1533117520.37 2025 "$s25" '第70页，合并资产负债表'
fact currentdebt25 一年内到期的非流动负债 473328962.41 2025 "$s25" '第70页，合并资产负债表'
fact longdebt25 长期借款 1110301353.20 2025 "$s25" '第70页，合并资产负债表'
fact leasedebt25 租赁负债 18761769.93 2025 "$s25" '第70页，合并资产负债表'
fact minority25 少数股东权益 479355260.56 2025 "$s25" '第71页，合并资产负债表'
fact shares25 股本 521600000 2025 "$s25" '第70页，合并资产负债表；第61页说明股份总数未变'

python3 "$tool" set-field --model "$model" --view equity --field excess_cash --expression 'cash25-restricted25-500000000' --basis-type formula --reason '货币资金扣除受限资金和估计经营必需现金' --confidence low
python3 "$tool" set-field --model "$model" --view equity --field non_operating_assets --expression 'equityinv25+lti25' --basis-type formula --reason '未计入核心FCFF的权益工具和联营企业投资按账面公允/权益法价值计入' --confidence medium
python3 "$tool" set-field --model "$model" --view equity --field financing_debt --expression 'shortdebt25+currentdebt25+longdebt25+leasedebt25' --basis-type formula --reason '计息借款、到期长期负债和租赁负债合计' --confidence high
python3 "$tool" set-field --model "$model" --view equity --field minority_interest_value --expression minority25 --basis-type reported --reason '子公司现金流无法独立估值，以少数股东账面权益作为经济价值代理' --confidence low
field_est equity '' other_priority_claims 0 '未发现未在经营资本或融资负债中处理的优先股、已宣告未付股息等重大索偿；湖北徽阳项目债务已在融资负债中' medium '若反担保被触发且形成未入账义务，或出现重大未付资本承诺，则加入扣减'
python3 "$tool" set-field --model "$model" --view equity --field diluted_shares --expression shares25 --basis-type reported --reason '报告期股份总数未变且无潜在摊薄证券' --confidence high
field_est equity '' financial_to_trading_fx 1 '财报与股票交易币种均为人民币' high '若估值或交易币种改变则更新汇率'

python3 "$tool" set-valuation --model "$model" --mode benchmark --stable-multiple 8 --safety-margin-ratio 0.6 --reason '湖北徽阳项目尚未形成完整产销、利润和逐年FCFF证据，不满足成长估值条件；采用稳定经营收益八倍固定标尺且不给项目额外价值'
python3 "$tool" add-adjustment --model "$model" --name '2025年资产减值损失' --before '1.579亿元损失计入营业利润' --after '核心经营EBIT中加回1.579亿元，稳定期另按中周期成本和费用估计' --reason '年报说明为存货跌价及固定资产减值增加，金额重大且不代表每年常态现金支出；若连续发生则不能加回'
python3 "$tool" add-adjustment --model "$model" --name '湖北徽阳开拓性资本开支' --before '2025年购建长期资产现金支出13.83亿元' --after '其中9.67亿元列为开拓性业务资本开支，项目不单独赋值' --reason '项目预算34.09亿元、年末累计投入35.20%，处于联调联试/建设阶段，稳定产销和现金回报尚未验证'
python3 "$tool" add-adjustment --model "$model" --name '货币资金可用性' --before '账面货币资金10.27亿元' --after '扣除2.96亿元受限资金及5.00亿元经营必需现金，仅2.32亿元计入多余现金' --reason '受限资金为票据及信用证保证金等；重化工采购和季节性经营仍需现金缓冲'

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '所有核心财务字段均由三份法定年报的具名事实和页码表达式形成'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '经营、非经营、融资、少数股东及受限现金分类无重复；业务树以产品需求与成本逻辑互斥覆盖公司'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定状态综合三年收入毛利费用、现有产能和项目阶段，不机械使用2025成本冲击或湖北徽阳远期目标'
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '投入资本分母为约30至44亿元且边界逐年一致；经营必需现金虽为低可信估计，但不足以改变ROIC低或为负的方向判断'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告中心数字、业务闭合、稳定收益及普通股价值桥将直接采用结构化模型输出'

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

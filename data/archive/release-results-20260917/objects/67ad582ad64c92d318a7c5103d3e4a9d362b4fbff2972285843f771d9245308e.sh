#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name "中宠股份" --code "002891.SZ" --period-label "2025年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "普通股" --security-unit "股" --output "$model"

fact() {
  local scaled
  scaled=$(awk -v value="$3" 'BEGIN { printf "%.6f", value * 100000000 }')
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$scaled" --period "$4" --currency "人民币" --scope "合并" --source "$5" --locator "$6"
}

fact_raw() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "合并" --source "$5" --locator "$6"
}

reported() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type reported --reason "$5" --confidence high
}

formula() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type formula --reason "$5" --confidence "$6"
}

estimate_year() {
  local scaled
  scaled=$(awk -v value="$4" 'BEGIN { printf "%.6f", value * 100000000 }')
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --value "$scaled" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

estimate() {
  local scaled
  scaled=$(awk -v value="$3" 'BEGIN { printf "%.6f", value * 100000000 }')
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" --value "$scaled" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"
}

formula_no_year() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" --expression "$3" --basis-type formula --reason "$4" --confidence "$5"
}

src23="中宠股份2023年年度报告（2024-04-23，https://static.cninfo.com.cn/finalpage/2024-04-23/1219735254.PDF）"
src24="中宠股份2024年年度报告（2025-04-24，https://static.cninfo.com.cn/finalpage/2025-04-24/1223233414.PDF）"
src25="中宠股份2025年年度报告（2026-04-24，https://static.cninfo.com.cn/finalpage/2026-04-24/1225158412.PDF）"

# 历史经营事实，金额统一转换为亿元。
fact rev_2023 "营业收入" 37.4720210857 "2023年度" "$src23" "PDF第94页"
fact cost_2023 "营业成本" 27.6256161142 "2023年度" "$src23" "PDF第95页"
fact op_profit_2023 "营业利润" 3.7215833079 "2023年度" "$src23" "PDF第95页"
fact fin_exp_2023 "财务费用" 0.2875858962 "2023年度" "$src23" "PDF第95页"
fact inv_income_2023 "投资收益" 0.2130676369 "2023年度" "$src23" "PDF第95页"
fact fv_gain_2023 "公允价值变动收益" 0.0207603012 "2023年度" "$src23" "PDF第95页"
fact income_tax_2023 "所得税费用" 0.7830502303 "2023年度" "$src23" "PDF第95页"
fact pretax_2023 "利润总额" 3.7029891827 "2023年度" "$src23" "PDF第95页"
fact dep_2023 "固定资产折旧" 1.0102341844 "2023年度" "$src23" "PDF第191页"
fact rou_dep_2023 "使用权资产折旧" 0.1756605050 "2023年度" "$src23" "PDF第191页"
fact amort_2023 "无形资产摊销" 0.0261807189 "2023年度" "$src23" "PDF第191页"
fact ltd_amort_2023 "长期待摊费用摊销" 0.1627993398 "2023年度" "$src23" "PDF第191页"
fact capex_2023 "购建固定资产、无形资产和其他长期资产支付的现金" 4.0682190968 "2023年度" "$src23" "PDF第99页"
fact ocf_2023 "经营活动产生的现金流量净额" 4.4702483236 "2023年度" "$src23" "PDF第98页"
fact ocf_interest_2023 "计入经营活动现金流的税后利息" 0 "2023年度" "$src23" "PDF第98-100页；利息支付列入筹资活动，经营现金流无需加回"

fact rev_2024 "营业收入" 44.6475158693 "2024年度" "$src24" "PDF第101页"
fact cost_2024 "营业成本" 32.0769470869 "2024年度" "$src24" "PDF第101页"
fact op_profit_2024 "营业利润" 5.0766415696 "2024年度" "$src24" "PDF第102页"
fact fin_exp_2024 "财务费用" 0.1768640965 "2024年度" "$src24" "PDF第102页"
fact inv_income_2024 "投资收益" 0.7245682335 "2024年度" "$src24" "PDF第102页"
fact fv_gain_2024 "公允价值变动收益" 0.0055566503 "2024年度" "$src24" "PDF第102页"
fact income_tax_2024 "所得税费用" 0.8892432776 "2024年度" "$src24" "PDF第102页"
fact pretax_2024 "利润总额" 5.0541115455 "2024年度" "$src24" "PDF第102页"
fact dep_2024 "固定资产折旧" 1.0631952327 "2024年度" "$src24" "PDF第194-195页"
fact rou_dep_2024 "使用权资产折旧" 0.2058516313 "2024年度" "$src24" "PDF第194页"
fact amort_2024 "无形资产摊销" 0.0296037778 "2024年度" "$src24" "PDF第194页"
fact ltd_amort_2024 "长期待摊费用摊销" 0.1704695097 "2024年度" "$src24" "PDF第194页"
fact capex_2024 "购建固定资产、无形资产和其他长期资产支付的现金" 2.4163213318 "2024年度" "$src24" "PDF第106页"
fact ocf_2024 "经营活动产生的现金流量净额" 4.9627713983 "2024年度" "$src24" "PDF第105页"
fact ocf_interest_2024 "计入经营活动现金流的税后利息" 0 "2024年度" "$src24" "PDF第105-107页；利息支付列入筹资活动，经营现金流无需加回"

fact rev_2025 "营业收入" 52.2146984383 "2025年度" "$src25" "PDF第100页"
fact cost_2025 "营业成本" 36.7923055826 "2025年度" "$src25" "PDF第100-101页"
fact op_profit_2025 "营业利润" 4.6344611406 "2025年度" "$src25" "PDF第101页"
fact fin_exp_2025 "财务费用" 0.2321893812 "2025年度" "$src25" "PDF第101页"
fact inv_income_2025 "投资收益" 0.7352904972 "2025年度" "$src25" "PDF第101页"
fact fv_gain_2025 "公允价值变动收益" 0.0090644324 "2025年度" "$src25" "PDF第101页"
fact income_tax_2025 "所得税费用" 0.6590069064 "2025年度" "$src25" "PDF第101页"
fact pretax_2025 "利润总额" 4.6415927633 "2025年度" "$src25" "PDF第101页"
fact dep_2025 "固定资产折旧" 1.3044802789 "2025年度" "$src25" "PDF第194-195页"
fact rou_dep_2025 "使用权资产折旧" 0.2067342585 "2025年度" "$src25" "PDF第194页"
fact amort_2025 "无形资产摊销" 0.0346488719 "2025年度" "$src25" "PDF第195页"
fact ltd_amort_2025 "长期待摊费用摊销" 0.1935715983 "2025年度" "$src25" "PDF第195页"
fact capex_2025 "购建固定资产、无形资产和其他长期资产支付的现金" 4.1867063910 "2025年度" "$src25" "PDF第104页"
fact ocf_2025 "经营活动产生的现金流量净额" 5.3445822144 "2025年度" "$src25" "PDF第103页"
fact ocf_interest_2025 "计入经营活动现金流的税后利息" 0 "2025年度" "$src25" "PDF第103-105页；利息支付列入筹资活动，经营现金流无需加回"

for y in 2023 2024 2025; do
  reported historical "$y" revenue "rev_$y" "合并利润表营业收入。"
  reported historical "$y" cost_of_revenue "cost_$y" "合并利润表营业成本。"
  formula historical "$y" period_operating_expenses "rev_$y - cost_$y - (op_profit_$y + fin_exp_$y - inv_income_$y - fv_gain_$y)" "以营业利润为起点，剔除财务费用、投资收益和公允价值变动，保留日常其他收益、减值及处置净额在经营内。" medium
  formula historical "$y" cash_tax "(op_profit_$y + fin_exp_$y - inv_income_$y - fv_gain_$y) * income_tax_$y / pretax_$y" "以当年实际所得税率作用于重构EBIT；公开披露不能逐项分离利息税盾与非经营收益税负。" medium
  formula historical "$y" depreciation_amortization "dep_$y + rou_dep_$y + amort_$y + ltd_amort_$y" "现金流量表补充资料四项折旧摊销之和。" high
  reported historical "$y" core_business_capex "capex_$y" "全部现金资本开支均服务于宠物食品现有品类、产能、仓储和供应链；未发现可可靠分离的跨行业开拓投入。"
  estimate_year historical "$y" exploratory_business_capex 0 "年报披露建设项目仍属于零食、主粮、湿粮、冻干和仓储等现有宠物食品体系，故不另列跨业务开拓性资本开支。" medium "若公司披露可核验的跨行业、新商业模式或尚未商业化技术项目现金支付，应从主营资本开支重分类。"
  reported historical "$y" operating_cash_flow "ocf_$y" "合并现金流量表经营活动现金流量净额。"
  reported historical "$y" after_tax_interest_in_operating_cash_flow "ocf_interest_$y" "中国现金流量表将偿付利息列入筹资活动，经营现金流口径不含需加回的利息。"
done

estimate_year historical 2023 operating_working_capital_increase -0.11838242664693892 "用重构NOPAT、披露折旧摊销与经营现金流倒推经营性应计资金变化，使利润路径和现金流路径闭合；负数为释放。" low "若附注能完整拆分经营性应收、存货、预付、应付及非现金经营调整，应以逐项变动替代残差。"
estimate_year historical 2024 operating_working_capital_increase 0.23386543228947818 "用重构NOPAT、披露折旧摊销与经营现金流倒推经营性应计资金变化，使利润路径和现金流路径闭合。" low "若附注能完整拆分经营性应收、存货、预付、应付及非现金经营调整，应以逐项变动替代残差。"
estimate_year historical 2025 operating_working_capital_increase -0.06812942849219918 "用重构NOPAT、披露折旧摊销与经营现金流倒推经营性应计资金变化，使利润路径和现金流路径闭合；负数为释放。" low "若附注能完整拆分经营性应收、存货、预付、应付及非现金经营调整，应以逐项变动替代残差。"

# 资本存量事实。2022期末取自2023年报比较数；2023-2025取各年期末数。
add_capital_facts() {
  local y="$1" src="$2" loc="$3"
  shift 3
  local names=(ar prepay other_receivables inventory other_current_assets notes_payable accounts_payable contract_liabilities employee_payable taxes_payable other_payables other_current_liabilities fixed_assets construction_in_progress right_of_use_assets intangible_assets goodwill long_term_prepaid other_noncurrent_assets deferred_income)
  local labels=(应收账款 预付款项 其他应收款 存货 其他流动资产 应付票据 应付账款 合同负债 应付职工薪酬 应交税费 其他应付款 其他流动负债 固定资产 在建工程 使用权资产 无形资产 商誉 长期待摊费用 其他非流动资产 递延收益)
  local i=0
  for value in "$@"; do
    fact "${names[$i]}_$y" "${labels[$i]}" "$value" "$y-12-31" "$src" "$loc"
    i=$((i+1))
  done
}

add_capital_facts 2022 "$src23" "PDF第90-92页比较数" 3.6269704962 0.0862014062 0.3237997242 6.0985497301 0.5337795620 0 3.5569957388 0.0762296055 0.8939775704 0.0609674033 0.1156551795 0.1311083790 10.1493125722 2.1882073291 0.4867001907 0.9502253896 2.2606841401 0.7888730408 0.6960390034 0.3477592256
add_capital_facts 2023 "$src23" "PDF第90-92页期末数" 4.6759367470 0.1663102741 0.0519137109 5.8046167150 0.3545014242 0 3.7791434786 0.1033910991 0.7624894419 0.1648613421 0.0812849352 0.1233870853 10.7016542669 4.6812508173 0.4868563377 0.9324257807 2.2606841401 0.6743365729 0.3095687102 0.3243251284
add_capital_facts 2024 "$src24" "PDF第97-99页期末数" 6.2748279676 0.2226941105 0.0643218685 5.7908132576 0.5960313322 0.0300000000 4.0769046008 0.1327732097 0.8571541595 0.4906158303 0.5806911358 0.1715372624 13.7373657835 1.3276929264 0.4074193328 0.9184567275 2.2606841401 0.7609021953 0.2538229965 0.3275131691
add_capital_facts 2025 "$src25" "PDF第96-98页期末数" 6.3362555108 0.2820796546 0.1007981638 6.9283499691 0.6530147864 0.2002934079 5.3560965754 0.4854134883 0.8884160475 0.3558308103 0.5352178765 0.0026941055 15.0840311235 2.6362632586 0.2888018856 1.3927659460 2.2606841401 0.6263288643 0.4205346472 0.3779654205

for y in 2022 2023 2024 2025; do
  formula capital "$y" operating_working_capital "ar_$y + prepay_$y + other_receivables_$y + inventory_$y + other_current_assets_$y - notes_payable_$y - accounts_payable_$y - contract_liabilities_$y - employee_payable_$y - taxes_payable_$y - other_payables_$y - other_current_liabilities_$y" "经营性流动资产减去无息经营流动负债；剔除现金、金融投资和融资债务。" medium
  formula capital "$y" operating_long_term_assets_net "fixed_assets_$y + construction_in_progress_$y + right_of_use_assets_$y + intangible_assets_$y + goodwill_$y + long_term_prepaid_$y + other_noncurrent_assets_$y - deferred_income_$y" "生产、仓储和品牌相关长期资产减资产相关递延收益；商誉先纳入总额，再在无法解释无形资产中扣除。" medium
  formula capital "$y" unsupported_intangible_assets "goodwill_$y" "商誉无法由当前稳定经营收益单独验证，按项目纪律全额剔除。" high
done

estimate_year capital 2022 required_cash 2.3 "约覆盖25天左右经营现金支出，用作采购、工资、税费和跨境结算缓冲。" low "若月度现金支出、季节性和受限资金明细显示更低或更高的最低现金，应调整。"
estimate_year capital 2023 required_cash 2.5 "约覆盖四周经营现金支出，用作采购、工资、税费和跨境结算缓冲。" low "若月度现金支出、季节性和受限资金明细显示更低或更高的最低现金，应调整。"
estimate_year capital 2024 required_cash 2.5 "约覆盖四周经营现金支出，用作采购、工资、税费和跨境结算缓冲。" low "若月度现金支出、季节性和受限资金明细显示更低或更高的最低现金，应调整。"
estimate_year capital 2025 required_cash 3.0 "约覆盖22天经营活动现金流出，考虑跨国工厂、肉类安全库存和多渠道结算。" low "若月度现金支出、季节性和受限资金明细显示更低或更高的最低现金，应调整。"

# 最新年度业务树：销售模式完整覆盖公司。
fact oem_rev_2025 "OEM销售收入" 28.7492474815 "2025年度" "$src25" "PDF第34-35页"
fact oem_cost_2025 "OEM销售成本" 20.7818299688 "2025年度" "$src25" "PDF第35页"
fact dealer_rev_2025 "经销销售收入" 12.6535362643 "2025年度" "$src25" "PDF第34-35页"
fact dealer_cost_2025 "经销销售成本" 9.4016352589 "2025年度" "$src25" "PDF第35页"
fact direct_rev_2025 "直销销售收入" 10.8119146925 "2025年度" "$src25" "PDF第34-35页"
fact direct_cost_2025 "直销销售成本" 6.6088403549 "2025年度" "$src25" "PDF第35页"

python3 "$tool" add-business --model "$model" --business-id oem --name "海外与大客户OEM/ODM" --importance "收入占55.06%，以客户品牌、订单生产和全球工厂交付为核心，是规模与现金基础。" --confidence medium --falsifier "若公司披露OEM中自主品牌或渠道服务占比重大，应重新划分业务边界。"
python3 "$tool" add-business --model "$model" --business-id dealer --name "品牌经销" --importance "收入占24.23%，通过宠物店、医院、商超及区域经销网络触达消费者。" --confidence medium --falsifier "若经销收入主要是代工客户转售而非公司品牌，应与OEM重新归类。"
python3 "$tool" add-business --model "$model" --business-id direct --name "品牌直销与电商" --importance "收入占20.71%且同比增长65.27%，直接承担流量投放、平台运营与库存风险，是品牌化转型的关键增量。" --confidence medium --falsifier "若平台直销费用和现金回款数据证明其已实现稳定正贡献，应上调经营利润与现金贡献。"

business_reported() {
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence high
}
business_estimate() {
  local scaled
  scaled=$(awk -v value="$3" 'BEGIN { printf "%.6f", value * 100000000 }')
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$scaled" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"
}

business_reported oem revenue oem_rev_2025 "年报按销售模式披露。"
business_reported oem cost_of_revenue oem_cost_2025 "年报按销售模式披露。"
business_reported dealer revenue dealer_rev_2025 "年报按销售模式披露。"
business_reported dealer cost_of_revenue dealer_cost_2025 "年报按销售模式披露。"
business_reported direct revenue direct_rev_2025 "年报按销售模式披露。"
business_reported direct cost_of_revenue direct_cost_2025 "年报按销售模式披露。"

business_estimate oem period_operating_expenses 3.4 "按订单驱动、客户承担终端品牌费用的较低费用率分配，公司未披露分模式期间费用。" low "分模式销售、管理、研发费用披露后替换。"
business_estimate dealer period_operating_expenses 2.4 "经销需渠道支持但终端投放弱于直销，按中等费用率分配。" low "分模式销售、管理、研发费用披露后替换。"
business_estimate direct period_operating_expenses 5.5000972635 "将品牌代言、新媒体投放、平台运营及新品推广的主要费用归入直销，并以公司重构期间费用为控制总量。" low "分渠道营销投放、平台费用和人员成本披露后替换。"
business_estimate oem cash_tax 0.5 "按正经营利润和境内外税负估计，税额与三类业务合计闭合。" low "分地区及分模式应纳税所得额披露后替换。"
business_estimate dealer cash_tax 0.0852778138921996 "按正经营利润估计并与公司经营现金税闭合。" low "分模式应纳税所得额披露后替换。"
business_estimate direct cash_tax 0 "基准点估计直销在高品牌投入下经营亏损，因此不分配当期经营现金税。" low "若分渠道利润证明直销税前盈利，应重新分配现金税。"
business_estimate oem operating_cash_flow_contribution 4.75 "订单生产、较快库存周转和客户回款形成主要现金贡献；与公司经营现金流闭合。" low "分模式应收、存货、应付与经营现金流披露后替换。"
business_estimate dealer operating_cash_flow_contribution 1.10 "经销回款与渠道库存占用并存，按正贡献估计；与公司经营现金流闭合。" low "分模式营运资金和现金流披露后替换。"
business_estimate direct operating_cash_flow_contribution -0.5054177856 "直销高速增长伴随投放、平台和自主品牌备货，估计仍消耗经营现金；作为闭合残差。" low "若直销渠道回款、投放和库存数据证明稳定正现金贡献，应上调。"

# 稳定期采用当前收入规模、30%毛利率、约20.5%期间费用率和15%经营税率，不外推扩产目标。
estimate stable revenue 52.2146984383 "采用2025年实际收入作为固定估值标尺的正常收入，不机械外推40%的主粮或65%的直销增速。" medium "若连续年度收入在无并购情况下明显高于或低于该水平，应更新。"
estimate stable cost_of_revenue 36.55028890681 "按30%正常毛利率估计，介于2024与2025结构改善趋势附近。" medium "原料、关税或渠道结构令可持续毛利率偏离30%超过2个百分点时推翻。"
estimate stable period_operating_expenses 10.7 "品牌投入成熟后较2025年略有经营杠杆，但不假设回到OEM主导时期的低费用率。" low "销售费用连续增长且不能带来留存或复购，或品牌投放显著收缩，均需重估。"
estimate stable cash_tax 0.7446614297235002 "对稳定EBIT采用15%经营现金税率，接近2025年实际税负并考虑多地区经营。" medium "境内外利润结构或税收优惠发生重大变化时调整。"
estimate stable depreciation_amortization 1.74 "接近2025年披露折旧摊销，代表现有资产基准消耗。" medium "新产能投产后折旧台阶式上升时调整。"
estimate stable core_business_capex 2.6 "高于折旧摊销，保留食品安全、自动化、全球工厂和现有品类扩产的持续投入纪律；低于建设高峰。" low "若扩产完成后的三年现金资本开支稳定低于2亿元或高于3亿元，应更新。"
estimate stable exploratory_business_capex 0 "未发现可与现有宠物食品业务可靠分离的开拓性投入；所有已披露项目作为主业扩张处理。" medium "出现跨行业或未商业化新技术项目并披露现金支出时重分类。"
estimate stable operating_working_capital_increase 0 "固定收入规模下假设正常营运资金不再永久增加，不采用2025年备货波动。" medium "稳定收入下库存天数或客户账期持续上升时改为正占用。"

# 普通股价值桥。
fact cash_2025 "货币资金" 12.7342355451 "2025-12-31" "$src25" "PDF第96页"
fact cash_equiv_2025 "现金及现金等价物期末余额" 11.1343231351 "2025-12-31" "$src25" "PDF第195页"
fact lti_2025 "长期股权投资" 3.0672128953 "2025-12-31" "$src25" "PDF第96页"
fact equity_instruments_2025 "其他权益工具投资" 0.6580078350 "2025-12-31" "$src25" "PDF第96页"
fact noncurrent_financial_2025 "其他非流动金融资产" 0.5128308274 "2025-12-31" "$src25" "PDF第96页"
fact investment_property_2025 "投资性房地产" 0.1924000312 "2025-12-31" "$src25" "PDF第96页"
fact short_debt_2025 "短期借款" 9.8840743694 "2025-12-31" "$src25" "PDF第97页"
fact current_debt_2025 "一年内到期的非流动负债" 0.1694390005 "2025-12-31" "$src25" "PDF第97页"
fact long_debt_2025 "长期借款" 0.4239145098 "2025-12-31" "$src25" "PDF第97-98页"
fact lease_debt_2025 "租赁负债" 0.1582981000 "2025-12-31" "$src25" "PDF第98页"
fact minority_book_2025 "少数股东权益" 2.1825564280 "2025-12-31" "$src25" "PDF第98页"
fact_raw shares_2025 "期末普通股股数" 304377620 "2025-12-31" "$src25" "PDF第88、186页；单位股"
fact convertible_face_2025 "尚未转股可转债面值" 4.8381540000 "2025-12-31" "$src25" "PDF第89页"
fact_raw conversion_price_2025 "中宠转2转股价" 27.46 "2025-12-31" "$src25" "PDF第88-89页；单位元/股"

estimate equity excess_cash 3.2043231351 "货币资金12.73亿元减经营必需现金3.00亿元、货币资金与现金等价物差额1.60亿元，并为截至年末尚待归还募集资金专户的4.93亿元保留资本承诺；只把剩余部分视为可分配。" low "若4.93亿元募集资金并非由现有现金恢复、项目取消或受限资金明细发生变化，应重新计算。"
formula_no_year equity non_operating_assets "lti_2025 + equity_instruments_2025 + noncurrent_financial_2025 + investment_property_2025" "剔除在经营FCFF之外的联营投资、权益工具、金融资产和投资性房地产，按账面值作为可实现价值代理。" medium
formula_no_year equity financing_debt "short_debt_2025 + current_debt_2025 + long_debt_2025 + lease_debt_2025" "假设剩余可转债全部转股，因此在完全摊薄股数中反映、此处不再重复扣除可转债负债；其余计息债务全额扣除。" medium
estimate equity minority_interest_value 2.182556428 "缺少剩余少数股东子公司的完整独立FCFF，暂以少数股东账面权益代理经济价值。" low "取得各少数股东子公司独立经营价值、债务和现金后应替换账面代理。"
estimate equity other_priority_claims 0 "未识别出在融资负债和经营资本之外需要另行扣除的重大优先索偿。" medium "若披露已宣告未付股利、重大资本承诺或担保损失且未进入其他项目，应计入。"
formula_no_year equity diluted_shares "shares_2025 + convertible_face_2025 / conversion_price_2025" "期末股数加尚未转股可转债按27.46元/股全部转换的潜在股份。" high

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "收入和主粮/直销仍在快速增长，6万吨干粮与4万吨湿粮项目尚未投产，且没有逐年FCFF、全部成长投入及稳定到达时间的充分证据，因此采用稳定经营收益八倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-adjustment --model "$model" --name "投资收益剔离经营" --before "2025年营业利润含0.735亿元投资收益" --after "重构EBIT剔除投资收益，相关4.430亿元资产在价值桥单列" --reason "避免联营及金融投资收益与资产重复计值。"
python3 "$tool" add-adjustment --model "$model" --name "商誉不作为经营投入" --before "账面商誉2.261亿元" --after "投入资本中全额剔除" --reason "无法由独立、可持续经营收益解释的并购溢价不自动形成经营资产价值。"
python3 "$tool" add-adjustment --model "$model" --name "可转债完全摊薄处理" --before "尚未转股面值4.838亿元" --after "不扣债务，增加约0.176亿潜在股" --reason "普通股价值与完全摊薄股数采用一致的假设，避免既扣债又摊薄。"
python3 "$tool" add-adjustment --model "$model" --name "募集资金与现金可达性" --before "2025年末货币资金12.734亿元" --after "多余现金仅计3.204亿元" --reason "扣除3.00亿元经营必需现金、1.60亿元非现金等价资金，并为年末尚待归还募集资金专户的4.93亿元保留用途约束。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "核心历史金额均引用三份法定年报及PDF页码，估计数另列依据和可推翻条件。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "经营资产、金融投资、融资负债、商誉、少数股东及可转债在价值桥中互斥处理。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期以当前收入和正常化利润/投入为标尺，没有机械外推主粮、直销增速或未投产项目目标。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本分母约23-30亿元且年度口径一致；经营必需现金为低可信估计，因此正文仅将ROIC用于资本效率趋势判断。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心数字和结论将以analysis.json编译结果为准。"

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

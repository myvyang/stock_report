#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name "颐海国际" --code "01579.HK" --period-label "2025年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "普通股" --security-unit "股" --output "$model"

add_fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "颐海国际集团合并" --source "$5" --locator "$6"
}

set_field_expr() {
  if [[ -n "$2" ]]; then
    python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression="$4" --basis-type "$5" --reason "$6" --confidence "$7"
  else
    python3 "$tool" set-field --model "$model" --view "$1" --field "$3" --expression="$4" --basis-type "$5" --reason "$6" --confidence "$7"
  fi
}

set_estimate() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

src23="颐海国际2023年年度报告，2024-04-25"
src24="颐海国际2024年年度报告，2025-04-25"
src25="颐海国际2025年年度报告，2026-04-24"

# 利润表、现金流及经营调整事实（金额：人民币元）
add_fact rev_2023 "Revenue" 6147573000 "2023-01-01/2023-12-31" "$src23" "PDF P221"
add_fact cost_2023 "Cost of sales" 4206269000 "2023-01-01/2023-12-31" "$src23" "PDF P221"
add_fact op_profit_2023 "Operating profit" 1194821000 "2023-01-01/2023-12-31" "$src23" "PDF P221"
add_fact fx_2023 "Net foreign exchange gains" 18872000 "2023-01-01/2023-12-31" "$src23" "PDF P318"
add_fact fv_2023 "Change in fair value of financial assets at FVTPL" 8026000 "2023-01-01/2023-12-31" "$src23" "PDF P318"
add_fact tax_paid_2023 "Income tax paid" 359051000 "2023-01-01/2023-12-31" "$src23" "PDF P223"
add_fact ppe_da_2023 "Depreciation of property, plant and equipment" 146018000 "2023-01-01/2023-12-31" "$src23" "PDF P326"
add_fact rou_da_2023 "Depreciation of right-of-use assets" 36188000 "2023-01-01/2023-12-31" "$src23" "PDF P326"
add_fact intang_da_2023 "Amortisation of intangible assets" 6510000 "2023-01-01/2023-12-31" "$src23" "PDF P326"
add_fact ppe_capex_2023 "Purchases of property, plant and equipment" 299351000 "2023-01-01/2023-12-31" "$src23" "PDF P223"
add_fact intang_capex_2023 "Purchases of intangible assets" 1611000 "2023-01-01/2023-12-31" "$src23" "PDF P223"
add_fact rou_capex_2023 "Purchases of right-of-use assets" 23388000 "2023-01-01/2023-12-31" "$src23" "PDF P223"
add_fact disposal_2023 "Proceeds from disposal of operating assets" 2393000 "2023-01-01/2023-12-31" "$src23" "PDF P223"
add_fact lease_payment_2023 "Principal and interest element of lease payments" 29138000 "2023-01-01/2023-12-31" "$src23" "PDF P223"
add_fact lease_interest_2023 "Interest on lease liabilities" 4341000 "2023-01-01/2023-12-31" "$src23" "PDF P318"
add_fact wc_inv_cash_2023 "Cash-flow change in inventories" 14478000 "2023-01-01/2023-12-31" "$src23" "PDF P326"
add_fact wc_rec_cash_2023 "Cash-flow change in receivables and other operating current assets" -112780000 "2023-01-01/2023-12-31" "$src23" "PDF P326"
add_fact wc_pay_cash_2023 "Cash-flow change in payables and contract liabilities" -19836000 "2023-01-01/2023-12-31" "$src23" "PDF P326"
add_fact ocf_2023 "Net cash generated from operating activities" 958999000 "2023-01-01/2023-12-31" "$src23" "PDF P223"
add_fact interest_received_2023 "Interest received" 73637000 "2023-01-01/2023-12-31" "$src23" "PDF P223"

add_fact rev_2024 "Revenue" 6539569000 "2024-01-01/2024-12-31" "$src24" "PDF P226"
add_fact cost_2024 "Cost of sales" 4493756000 "2024-01-01/2024-12-31" "$src24" "PDF P226"
add_fact op_profit_2024 "Operating profit" 1108343000 "2024-01-01/2024-12-31" "$src24" "PDF P226"
add_fact fx_2024 "Net foreign exchange losses (signed)" -5835000 "2024-01-01/2024-12-31" "$src24" "PDF P306"
add_fact fv_2024 "Change in fair value of financial assets at FVTPL" 13868000 "2024-01-01/2024-12-31" "$src24" "PDF P306"
add_fact tax_paid_2024 "Income tax paid" 387916000 "2024-01-01/2024-12-31" "$src24" "PDF P228"
add_fact ppe_da_2024 "Depreciation of property, plant and equipment" 166870000 "2024-01-01/2024-12-31" "$src24" "PDF P314"
add_fact rou_da_2024 "Depreciation of right-of-use assets" 32477000 "2024-01-01/2024-12-31" "$src24" "PDF P314"
add_fact intang_da_2024 "Amortisation of intangible assets" 6240000 "2024-01-01/2024-12-31" "$src24" "PDF P314"
add_fact ppe_capex_2024 "Purchases of property, plant and equipment" 252641000 "2024-01-01/2024-12-31" "$src24" "PDF P228"
add_fact intang_capex_2024 "Purchases of intangible assets" 4506000 "2024-01-01/2024-12-31" "$src24" "PDF P228"
add_fact rou_capex_2024 "Purchases of right-of-use assets" 32178000 "2024-01-01/2024-12-31" "$src24" "PDF P228"
add_fact disposal_2024 "Proceeds from disposal of operating assets" 5865000 "2024-01-01/2024-12-31" "$src24" "PDF P228"
add_fact lease_payment_2024 "Principal and interest element of lease payments" 35942000 "2024-01-01/2024-12-31" "$src24" "PDF P228"
add_fact lease_interest_2024 "Interest on lease liabilities" 4910000 "2024-01-01/2024-12-31" "$src24" "PDF P307"
add_fact wc_inv_cash_2024 "Cash-flow change in inventories" -98745000 "2024-01-01/2024-12-31" "$src24" "PDF P314"
add_fact wc_rec_cash_2024 "Cash-flow change in receivables and other operating current assets" -59256000 "2024-01-01/2024-12-31" "$src24" "PDF P314"
add_fact wc_pay_cash_2024 "Cash-flow change in payables and contract liabilities" 85165000 "2024-01-01/2024-12-31" "$src24" "PDF P314"
add_fact ocf_2024 "Net cash generated from operating activities" 917713000 "2024-01-01/2024-12-31" "$src24" "PDF P228"
add_fact interest_received_2024 "Interest received" 69938000 "2024-01-01/2024-12-31" "$src24" "PDF P228"

add_fact rev_2025 "Revenue" 6612566000 "2025-01-01/2025-12-31" "$src25" "PDF P272"
add_fact cost_2025 "Cost of sales" 4447524000 "2025-01-01/2025-12-31" "$src25" "PDF P272"
add_fact op_profit_2025 "Operating profit" 1237709000 "2025-01-01/2025-12-31" "$src25" "PDF P272"
add_fact fx_2025 "Net foreign exchange losses (signed)" -13515000 "2025-01-01/2025-12-31" "$src25" "PDF P351"
add_fact fv_2025 "Change in fair value of financial assets at FVTPL" 12867000 "2025-01-01/2025-12-31" "$src25" "PDF P351"
add_fact tax_paid_2025 "Income tax paid" 364013000 "2025-01-01/2025-12-31" "$src25" "PDF P274"
add_fact ppe_da_2025 "Depreciation of property, plant and equipment" 188911000 "2025-01-01/2025-12-31" "$src25" "PDF P360"
add_fact rou_da_2025 "Depreciation of right-of-use assets" 36522000 "2025-01-01/2025-12-31" "$src25" "PDF P360"
add_fact intang_da_2025 "Amortisation of intangible assets" 4347000 "2025-01-01/2025-12-31" "$src25" "PDF P360"
add_fact ppe_capex_2025 "Purchases of property, plant and equipment" 319944000 "2025-01-01/2025-12-31" "$src25" "PDF P274"
add_fact intang_capex_2025 "Purchases of intangible assets" 1779000 "2025-01-01/2025-12-31" "$src25" "PDF P274"
add_fact rou_capex_2025 "Purchases of right-of-use assets" 1036000 "2025-01-01/2025-12-31" "$src25" "PDF P274"
add_fact disposal_2025 "Proceeds from disposal of operating assets" 2436000 "2025-01-01/2025-12-31" "$src25" "PDF P274"
add_fact lease_payment_2025 "Principal and interest element of lease payments" 34732000 "2025-01-01/2025-12-31" "$src25" "PDF P274"
add_fact lease_interest_2025 "Interest on lease liabilities" 4538000 "2025-01-01/2025-12-31" "$src25" "PDF P352"
add_fact wc_inv_cash_2025 "Cash-flow change in inventories" -60306000 "2025-01-01/2025-12-31" "$src25" "PDF P360"
add_fact wc_rec_cash_2025 "Cash-flow change in receivables and other operating current assets" -3383000 "2025-01-01/2025-12-31" "$src25" "PDF P360"
add_fact wc_pay_cash_2025 "Cash-flow change in payables and contract liabilities" -106539000 "2025-01-01/2025-12-31" "$src25" "PDF P360"
add_fact ocf_2025 "Net cash generated from operating activities" 986438000 "2025-01-01/2025-12-31" "$src25" "PDF P274"
add_fact interest_received_2025 "Interest received" 49106000 "2025-01-01/2025-12-31" "$src25" "PDF P274"

# 历史经营字段；经营利润剔除汇兑与理财公允价值变化。
for y in 2023 2024 2025; do
  set_field_expr historical "$y" revenue "rev_$y" reported "合并损益表收入。" high
  set_field_expr historical "$y" cost_of_revenue "cost_$y" reported "合并损益表销售成本。" high
  set_field_expr historical "$y" period_operating_expenses "rev_$y-cost_$y-op_profit_$y+fx_$y+fv_$y" formula "由毛利减去剔除汇兑和理财公允价值变动后的经营利润反推；保留经营补助、废料收入与日常处置净额。" medium
  set_field_expr historical "$y" cash_tax "tax_paid_$y" reported "以现金流量表已付所得税作为经营现金税基准；利息及理财相关税项无法可靠拆分，误差由FCFF双路径校验约束。" medium
  set_field_expr historical "$y" depreciation_amortization "ppe_da_$y+rou_da_$y+intang_da_$y" formula "经营性物业设备、使用权资产和无形资产折旧摊销合计。" high
  set_field_expr historical "$y" core_business_capex "ppe_capex_$y+intang_capex_$y+rou_capex_$y-disposal_$y+lease_payment_$y-lease_interest_$y" formula "经营租赁口径：经营资产购置净额并加入租赁本金；均服务现有调味料和方便食品产供销体系。" medium
  set_estimate historical "$y" exploratory_business_capex 0 "年报未识别与现有食品业务可分离、尚未产生收入的新业务资本项目；海外厂房和渠道均属现有主业扩张。" medium "若后续披露可单独识别的预收入新业务项目、目标市场及累计投入，则改列开拓性资本开支。"
  set_field_expr historical "$y" operating_working_capital_increase "-(wc_inv_cash_$y+wc_rec_cash_$y+wc_pay_cash_$y)" formula "按现金流量附注库存、经营应收及经营应付三类变动的现金影响取反。" high
  set_field_expr historical "$y" operating_cash_flow "ocf_$y" reported "合并现金流量表经营活动现金流净额，包含已收利息。" high
  set_field_expr historical "$y" after_tax_interest_in_operating_cash_flow "-interest_received_$y" formula "将经营现金流中列示的已收利息全额剔除；现金税已用实际支付额，避免再做低可信税率调整。" medium
done

# 2022-2025经营资本事实与字段。
add_fact inv_2022 "Inventories" 387484000 "2022-12-31" "$src23" "PDF P219"
add_fact rec_2022 "Trade receivables" 155627000 "2022-12-31" "$src23" "PDF P219"
add_fact ofa_2022 "Other financial assets at amortised cost" 17383000 "2022-12-31" "$src23" "PDF P219"
add_fact oca_2022 "Other current assets" 54224000 "2022-12-31" "$src23" "PDF P219"
add_fact pay_2022 "Trade payables" 396254000 "2022-12-31" "$src23" "PDF P220"
add_fact opa_2022 "Other payables and accruals" 203915000 "2022-12-31" "$src23" "PDF P220"
add_fact contract_2022 "Contract liabilities" 102785000 "2022-12-31" "$src23" "PDF P220"
add_fact ppe_2022 "Property, plant and equipment" 1668759000 "2022-12-31" "$src23" "PDF P219"
add_fact rou_2022 "Right-of-use assets" 239270000 "2022-12-31" "$src23" "PDF P219"
add_fact intang_2022 "Intangible assets" 16883000 "2022-12-31" "$src23" "PDF P219"
add_fact onca_2022 "Other non-current assets" 121492000 "2022-12-31" "$src23" "PDF P219"
add_fact oncl_2022 "Other non-current liabilities" 25297000 "2022-12-31" "$src23" "PDF P220"

for spec in \
"2023 370532000 258125000 19509000 62358000 402788000 187020000 77351000 1808895000 226914000 11984000 119229000 33808000 P219 P220 $src23" \
"2024 465531000 285405000 17707000 96155000 482210000 180509000 95771000 1943138000 264891000 10250000 69852000 40208000 P224 P225 $src24" \
"2025 521861000 256349000 13701000 132640000 403586000 170824000 65276000 2123630000 283030000 7412000 20308000 46091000 P270 P271 $src25"; do
  read -r y inv rec ofa oca pay opa con ppe rou intang onca oncl ap lp source_name <<< "$spec"
  add_fact inv_$y "Inventories" "$inv" "$y-12-31" "$source_name" "PDF $ap"
  add_fact rec_$y "Trade receivables" "$rec" "$y-12-31" "$source_name" "PDF $ap"
  add_fact ofa_$y "Other financial assets at amortised cost" "$ofa" "$y-12-31" "$source_name" "PDF $ap"
  add_fact oca_$y "Other current assets" "$oca" "$y-12-31" "$source_name" "PDF $ap"
  add_fact pay_$y "Trade payables" "$pay" "$y-12-31" "$source_name" "PDF $lp"
  add_fact opa_$y "Other payables and accruals" "$opa" "$y-12-31" "$source_name" "PDF $lp"
  add_fact contract_$y "Contract liabilities" "$con" "$y-12-31" "$source_name" "PDF $lp"
  add_fact ppe_$y "Property, plant and equipment" "$ppe" "$y-12-31" "$source_name" "PDF $ap"
  add_fact rou_$y "Right-of-use assets" "$rou" "$y-12-31" "$source_name" "PDF $ap"
  add_fact intang_$y "Intangible assets" "$intang" "$y-12-31" "$source_name" "PDF $ap"
  add_fact onca_$y "Other non-current assets" "$onca" "$y-12-31" "$source_name" "PDF $ap"
  add_fact oncl_$y "Other non-current liabilities" "$oncl" "$y-12-31" "$source_name" "PDF $lp"
done

for y in 2022 2023 2024 2025; do
  set_field_expr capital "$y" operating_working_capital "inv_$y+rec_$y+ofa_$y+oca_$y-pay_$y-opa_$y-contract_$y" formula "库存、贸易应收、经营性其他流动资产减贸易应付、其他应付及合同负债。" high
  set_field_expr capital "$y" operating_long_term_assets_net "ppe_$y+rou_$y+intang_$y+onca_$y-oncl_$y" formula "物业设备、使用权资产、经营无形资产及其他非流动经营资产，减主要为递延资产补助的其他非流动负债。" medium
done
set_estimate capital 2022 required_cash 400000000 "约一个月现金经营支出，用于工资、采购、租赁及税费周转。" low "若公司披露日常最低现金、资金池可即时调用额度或月度季节性现金谷值，重估经营必需现金。"
set_estimate capital 2023 required_cash 410000000 "约一个月现金经营支出，用于工资、采购、租赁及税费周转。" low "若公司披露日常最低现金、资金池可即时调用额度或月度季节性现金谷值，重估经营必需现金。"
set_estimate capital 2024 required_cash 445000000 "以销售成本、经销和行政费用减折旧摊销后的约一个月支出估计。" medium "若公司披露日常最低现金、资金池可即时调用额度或月度季节性现金谷值，重估经营必需现金。"
set_estimate capital 2025 required_cash 440000000 "以销售成本、经销和行政费用减折旧摊销后的约一个月支出估计。" medium "若公司披露日常最低现金、资金池可即时调用额度或月度季节性现金谷值，重估经营必需现金。"
for y in 2022 2023 2024 2025; do
  set_field_expr capital "$y" unsupported_intangible_assets "intang_$y-intang_$y" formula "账面无商誉；小额无形资产服务现有经营，未识别无法解释的并购溢价。" high
done

# 稳定状态：当前收入规模、三年利润率中枢、常态补助与近期投入强度。
set_estimate stable "" revenue 6612566000 "收入以2025年当前规模为基准；2023-2025增速依次约0%、6.4%、1.1%，不外推增长。" medium "若第三方增长无法抵消关联方下降，或收入连续两个完整年度脱离当前规模10%以上，重估。"
set_estimate stable "" cost_of_revenue 4496544880 "采用32.0%稳定毛利率，位于2023-2025的31.3%-32.7%区间内，略低于2025原料与效率共同推动的32.7%。" medium "若原材料成本或产品/客户结构令毛利率连续两年低于30%或高于34%，重估。"
set_estimate stable "" period_operating_expenses 970000000 "以2025经销及行政费用扣除常态经营性其他收入估计，并把超出2023-2024约0.88亿元水平的补助回归。" medium "若直管直配渠道形成持续新增费用，或常态经营补助显著偏离0.9亿元，重估。"
set_estimate stable "" cash_tax 336930000 "按稳定EBIT约29.4%的现金税率，接近2025实际支付所得税/调整后EBIT。" medium "若税收优惠、境外利润结构或递延税导致三年现金税率持续偏离25%-32%，重估。"
set_estimate stable "" depreciation_amortization 230000000 "约等于2025折旧摊销，反映现有产能的常态会计损耗。" medium "若新增产能投产后折旧连续两年偏离该值15%以上，重估。"
set_estimate stable "" core_business_capex 330000000 "接近2023-2025经营口径现金资本开支均值，覆盖现有工厂、产线自动化、海外产能及渠道配套。" medium "若产能建设完成后资本开支连续两年低于2.5亿元，或新增项目令其高于4亿元，重估。"
set_estimate stable "" exploratory_business_capex 0 "未识别独立于现有食品主业的新业务资本项目，稳定经营收益不扣未证实的新业务投入。" medium "若披露独立新业务商业化路径和资本预算，单列并在稳定收益或成长路径中处理。"
set_estimate stable "" operating_working_capital_increase 0 "无增长稳定状态下营运资金不永久增加；2025增加主要来自库存与应付释放，未机械年化。" medium "若直管直配模式使营运资金占收入比例连续上升，即使收入稳定也应计入正常增加。"

# 2025核心业务：统一按客户/渠道分类，收入直接披露，成本费用和现金贡献为闭合估计。
python3 "$tool" add-business --model "$model" --business-id related_chain --name "关联餐饮连锁定制供货" --importance "海底捞、特海和蜀海按需下单；占收入27.7%，定制产品毛利显著低于第三方。" --confidence medium --falsifier "若关联方分产品成本或独立经营现金流披露与估算明显不同，重分成本费用和现金贡献。"
python3 "$tool" add-business --model "$model" --business-id consumer_retail --name "第三方消费零售渠道" --importance "经销、直营商超与电商共同触达家庭消费者，占收入67.6%；渠道由经销向两直和线上迁移。" --confidence low --falsifier "若公司披露各渠道毛利、费用或现金回款，则替换按客户毛利及渠道强度形成的基准估计。"
python3 "$tool" add-business --model "$model" --business-id foodservice_supply --name "第三方餐饮食品与专项供货" --importance "面向餐饮及食品企业的标准品/定制品与临时专项销售，占收入4.7%，但2025餐饮食品客户收入增长73.3%。" --confidence low --falsifier "若B端独立毛利、费用或专项销售客户性质披露，则重新划分业务边界和盈利。"

set_biz() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
set_biz_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression="$3" --basis-type "$4" --reason "$5" --confidence "$6"; }

add_fact related_revenue_2025 "Revenue from related-party customers" 1831057000 "2025-01-01/2025-12-31" "$src25" "PDF P32"
add_fact related_gross_hotpot_2025 "Gross profit: hot pot condiments sold to related parties" 235177000 "2025-01-01/2025-12-31" "$src25" "PDF P35"
add_fact related_gross_compound_2025 "Gross profit: compound condiments sold to related parties" 22143000 "2025-01-01/2025-12-31" "$src25" "PDF P35"
add_fact related_gross_rte_2025 "Gross profit: ready-to-eat food sold to related parties" 20358000 "2025-01-01/2025-12-31" "$src25" "PDF P35"
add_fact distributor_revenue_2025 "Revenue from distributors" 3443703000 "2025-01-01/2025-12-31" "$src25" "PDF P32"
add_fact direct_retail_revenue_2025 "Revenue from direct sales stores in malls and supermarkets" 558571000 "2025-01-01/2025-12-31" "$src25" "PDF P32"
add_fact ecommerce_revenue_2025 "Revenue from e-commerce" 464883000 "2025-01-01/2025-12-31" "$src25" "PDF P32"
add_fact food_company_revenue_2025 "Revenue from catering and food product companies" 300197000 "2025-01-01/2025-12-31" "$src25" "PDF P32"
add_fact adhoc_revenue_2025 "Revenue from ad hoc sales event" 14155000 "2025-01-01/2025-12-31" "$src25" "PDF P32"

set_biz_expr related_chain revenue "related_revenue_2025" reported "2025关联方客户渠道收入，年报PDF P32。" high
set_biz_expr related_chain cost_of_revenue "related_revenue_2025-related_gross_hotpot_2025-related_gross_compound_2025-related_gross_rte_2025" formula "关联方火锅、复调和方便食品披露毛利合计2.77678亿元，收入减毛利得成本，年报PDF P35。" high
set_biz related_chain period_operating_expenses 75000000 estimate "关联客户按需下单、定制品仓储期较长但获客费用低；按约4.1%收入分配公司期间经营费用。" low "若披露关联方渠道独立销售、管理费用，替换估计。"
set_biz related_chain cash_tax 59580000 estimate "按该业务估计EBIT占公司调整后EBIT比例分配现金税。" low "若关联业务适用税率或子公司归属披露，重新分配。"
set_biz related_chain operating_cash_flow_contribution 160000000 estimate "按估计NOPAT、定制品库存周期和关联客户回款特征分配，并闭合公司经营现金流。" low "若披露关联方应收、库存或经营现金流，替换估计。"

set_biz_expr consumer_retail revenue "distributor_revenue_2025+direct_retail_revenue_2025+ecommerce_revenue_2025" formula "经销商、直营商超和电商渠道披露收入合计，年报PDF P32。" high
set_biz consumer_retail cost_of_revenue 2659793000 estimate "以第三方分产品披露毛利为控制数，扣除餐饮食品与专项供货估计毛利后形成。" low "若披露经销、直营商超和电商各自毛利，替换估计。"
set_biz consumer_retail period_operating_expenses 805000000 estimate "绝大部分经销开支、终端运营和电商推广归于消费零售渠道；与公司费用总额闭合。" low "若渠道费用明细显示B端或关联渠道承担显著更多费用，重新分配。"
set_biz consumer_retail cash_tax 294600000 estimate "按该业务估计EBIT占公司调整后EBIT比例分配现金税。" low "若主要渠道由不同税务主体经营且税率明显不同，重新分配。"
set_biz consumer_retail operating_cash_flow_contribution 795000000 estimate "依据支付后发货、成品约7天仓储及其主要利润贡献分配，并闭合公司经营现金流。" low "若披露渠道应收、库存或现金流，替换估计。"

set_biz_expr foodservice_supply revenue "food_company_revenue_2025+adhoc_revenue_2025" formula "餐饮及食品公司3.00197亿元与一次性销售活动0.14155亿元合计，年报PDF P32。" high
set_biz foodservice_supply cost_of_revenue 234352000 estimate "按约25.4%毛利率估计，低于第三方消费零售但高于关联定制供货；与公司销售成本闭合。" low "若披露B端/专项销售毛利，替换估计。"
set_biz foodservice_supply period_operating_expenses 46685000 estimate "按定制服务、客户开发与小规模专项销售所需费用分配；与公司费用闭合。" low "若披露B端销售和研发费用，替换估计。"
set_biz foodservice_supply cash_tax 9833000 estimate "余量闭合公司现金税，约为该业务估计EBIT的29.5%。" low "若B端经营主体税率披露，重新分配。"
set_biz foodservice_supply operating_cash_flow_contribution 31438000 estimate "按估计NOPAT和B端较高定制/回款占用分配；与公司经营现金流闭合。" low "若披露B端应收、库存或现金流，替换估计。"

# 普通股价值桥。
add_fact cash_2025 "Cash and cash equivalents" 2084546000 "2025-12-31" "$src25" "PDF P270"
add_fact term_deposit_2025 "Term deposits within one year" 54461000 "2025-12-31" "$src25" "PDF P270"
add_fact restricted_cash_2025 "Restricted cash" 5023000 "2025-12-31" "$src25" "PDF P270"
add_fact fvtpl_assets_2025 "Financial assets at fair value through profit or loss" 354999000 "2025-12-31" "$src25" "PDF P270"
add_fact shares_issued_2025 "Issued ordinary shares" 1036700000 "2025-12-31" "$src25" "PDF P339"
add_fact treasury_rsu_2025 "Shares held for RSU scheme" 66568000 "2025-12-31" "$src25" "PDF P340"
add_fact nci_profit_2025 "Profit allocated to NCI" 49521000 "2025-01-01/2025-12-31" "$src25" "PDF P326"

set_field_expr equity "" excess_cash "cash_2025+term_deposit_2025-restricted_cash_2025" formula "账面现金及一年内定期存款扣受限现金后，再扣除经营必需现金0.44亿元（通过下列估值调整体现）。" medium
# 上式先得到可动用资金；随后用估计覆盖为精确扣除经营必需现金。
set_estimate equity "" excess_cash 1693984000 "现金及一年内定期存款减受限现金和4.40亿元经营必需现金；未另扣未宣派为负债的建议股息。" medium "若资金受限、汇出税费、资本承诺或最低现金需求披露增加，降低可达价值。"
set_field_expr equity "" non_operating_assets "fvtpl_assets_2025+ofa_2025" formula "未参与经营FCFF的理财金融资产及其他摊余成本金融资产，按账面值计。" medium
set_field_expr equity "" financing_debt "cash_2025-cash_2025" formula "无银行借款或债券；租赁按经营口径已进入资本开支和经营资产，不重复扣租赁负债。" high
set_estimate equity "" minority_interest_value 396168000 "以2025归属于非控股权益利润0.49521亿元的8倍估计，优于直接采用0.173亿元账面权益；主要对应馥海上海子集团40%权益。" medium "若馥海上海可持续FCFF、净债务或独立估值披露，替换利润倍数代理。"
set_field_expr equity "" other_priority_claims "cash_2025-cash_2025" formula "未识别优先股、已宣告未付股息或未进入经营资本的重大优先索偿。" medium
set_field_expr equity "" diluted_shares "shares_issued_2025-treasury_rsu_2025" formula "期末已发行股份减RSU受托人持股；2025无潜在摊薄股份。" high

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "增长路径缺少逐年FCFF、到达稳定状态时间和全部投入证据，采用稳定经营收益八倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "剔除理财与汇兑损益" --before "财报经营利润包含汇兑损益和按公允价值计入损益的金融资产变动" --after "三年EBIT均剔除上述非经营项目" --reason "对应资产在普通股价值桥作为非经营资产单独计值，避免收益与资产重复。"
python3 "$tool" add-adjustment --model "$model" --name "经营必需现金" --before "2025年现金、定期存款及受限现金合计21.44亿元" --after "其中4.40亿元归入投入资本，16.94亿元列为多余现金" --reason "约一个月现金经营支出不能在不损害工资、采购、租赁和税费结算情况下拿走。"
python3 "$tool" add-adjustment --model "$model" --name "少数股东经济价值" --before "非控股权益账面值1.73亿元" --after "按2025归属利润0.495亿元×8计3.96亿元" --reason "合并经营收益包含馥海上海子集团100%业绩，普通股价值需扣除40%非控股经济权益。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "所有公司总量、资产和股数均追溯至三份港交所年报名称、日期和PDF页码；估计另列依据与可推翻条件。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "理财、汇兑和多余现金与经营分离；租赁统一采用经营口径；业务树互斥并覆盖2025合并总量。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定状态使用三年收入、毛利和投入强度，回归异常补助且不外推增长；因渠道调整仍在进行，置信度限定为中等。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本含经营营运资金、长期资产和一个月必需现金；必需现金为估计且品牌渠道投入费用化，ROIC仅用于判断资本占用结构，不作精确竞争优势比较。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告核心数字、业务闭合、稳定经营收益和普通股价值将直接采用编译后的结构化模型。"

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

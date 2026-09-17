#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
mkdir -p outputs

python3 "$tool" init --name "我乐家居" --code "603326.SH" --period-label "2025年" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "A股普通股" --security-unit "股" --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "合并口径" --source "$5" --locator "$6"
}
field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
field_est_y() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}
stable_est() {
  python3 "$tool" set-field --model "$model" --view stable --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"
}
equity_expr() {
  python3 "$tool" set-field --model "$model" --view equity --field "$1" --expression "$2" --basis-type "$3" --reason "$4" --confidence "$5"
}
equity_est() {
  python3 "$tool" set-field --model "$model" --view equity --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"
}

s23="南京我乐家居股份有限公司2023年年度报告（2024-04-20），https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2024-04-20/603326_20240420_91G1.pdf"
s24="南京我乐家居股份有限公司2024年年度报告（2025-04-19），https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2025-04-19/603326_20250419_5XFP.pdf"
s25="南京我乐家居股份有限公司2025年年度报告（2026-03-31），https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2026-03-31/603326_20260331_O7ST.pdf"

# 历史利润、现金流及长期投入事实
fact rev_2023 "营业收入" 1711318922.99 "2023年度" "$s23" "PDF P75"
fact cost_2023 "营业成本" 919614141.65 "2023年度" "$s23" "PDF P75"
fact op_profit_2023 "营业利润" 173770028.68 "2023年度" "$s23" "PDF P76"
fact finance_exp_2023 "财务费用" 12114651.43 "2023年度" "$s23" "PDF P76"
fact inv_income_2023 "投资收益" 6854136.19 "2023年度" "$s23" "PDF P76"
fact fv_gain_2023 "公允价值变动收益" 75703.20 "2023年度" "$s23" "PDF P76"
fact disposal_gain_2023 "资产处置收益" 953066.58 "2023年度" "$s23" "PDF P76"
fact current_tax_2023 "当期所得税费用" 35602423.93 "2023年度" "$s23" "PDF P182"
fact fixed_da_2023 "固定资产折旧" 82305396.71 "2023年度" "$s23" "PDF P186"
fact intangible_da_2023 "无形资产摊销" 3881007.81 "2023年度" "$s23" "PDF P186"
fact prepaid_da_2023 "长期待摊费用摊销" 17952571.93 "2023年度" "$s23" "PDF P186"
fact ocf_2023 "经营活动产生的现金流量净额" 431398641.68 "2023年度" "$s23" "PDF P80"
fact capex_paid_2023 "购建固定资产、无形资产和其他长期资产支付的现金" 130596439.17 "2023年度" "$s23" "PDF P80"
fact asset_disposal_cash_2023 "处置固定资产、无形资产和其他长期资产收回的现金净额" 2505017.48 "2023年度" "$s23" "PDF P80"

fact rev_2024 "营业收入" 1432467926.07 "2024年度" "$s24" "PDF P79"
fact cost_2024 "营业成本" 768954618.71 "2024年度" "$s24" "PDF P79"
fact op_profit_2024 "营业利润" 153584139.08 "2024年度" "$s24" "PDF P80"
fact finance_exp_2024 "财务费用" 13229138.14 "2024年度" "$s24" "PDF P80"
fact inv_income_2024 "投资收益" 9827169.02 "2024年度" "$s24" "PDF P80"
fact fv_gain_2024 "公允价值变动收益" 37420.51 "2024年度" "$s24" "PDF P80"
fact disposal_gain_2024 "资产处置收益" -107483.49 "2024年度" "$s24" "PDF P80"
fact current_tax_2024 "当期所得税费用" 27377740.23 "2024年度" "$s24" "PDF P183"
fact fixed_da_2024 "固定资产折旧" 83675481.95 "2024年度" "$s24" "PDF P186"
fact intangible_da_2024 "无形资产摊销" 3508257.55 "2024年度" "$s24" "PDF P186"
fact prepaid_da_2024 "长期待摊费用摊销" 13720545.12 "2024年度" "$s24" "PDF P186"
fact ocf_2024 "经营活动产生的现金流量净额" 454971044.09 "2024年度" "$s24" "PDF P84"
fact capex_paid_2024 "购建固定资产、无形资产和其他长期资产支付的现金" 65505847.49 "2024年度" "$s24" "PDF P84"
fact asset_disposal_cash_2024 "处置固定资产、无形资产和其他长期资产收回的现金净额" 5536425.86 "2024年度" "$s24" "PDF P84"

fact rev_2025 "营业收入" 1450885926.67 "2025年度" "$s25" "PDF P76"
fact cost_2025 "营业成本" 779157504.22 "2025年度" "$s25" "PDF P76"
fact op_profit_2025 "营业利润" 216166594.81 "2025年度" "$s25" "PDF P77"
fact finance_exp_2025 "财务费用" 9507187.26 "2025年度" "$s25" "PDF P76"
fact inv_income_2025 "投资收益" 7718733.37 "2025年度" "$s25" "PDF P77"
fact fv_gain_2025 "公允价值变动收益" 1061.80 "2025年度" "$s25" "PDF P77"
fact disposal_gain_2025 "资产处置收益" -1821829.67 "2025年度" "$s25" "PDF P77"
fact current_tax_2025 "当期所得税费用" 43745733.10 "2025年度" "$s25" "PDF P177"
fact fixed_da_2025 "固定资产折旧" 81859791.76 "2025年度" "$s25" "PDF P180"
fact intangible_da_2025 "无形资产摊销" 3242442.15 "2025年度" "$s25" "PDF P180"
fact prepaid_da_2025 "长期待摊费用摊销" 11880673.45 "2025年度" "$s25" "PDF P181"
fact ocf_2025 "经营活动产生的现金流量净额" 124874266.58 "2025年度" "$s25" "PDF P80"
fact capex_paid_2025 "购建固定资产、无形资产和其他长期资产支付的现金" 44637254.11 "2025年度" "$s25" "PDF P81"
fact asset_disposal_cash_2025 "处置固定资产、无形资产和其他长期资产收回的现金净额" 10214457.61 "2025年度" "$s25" "PDF P81"

for y in 2023 2024 2025; do
  field_expr historical "$y" revenue "rev_${y}" reported "合并利润表营业收入。" high
  field_expr historical "$y" cost_of_revenue "cost_${y}" reported "合并利润表营业成本。" high
  ebit="op_profit_${y} + finance_exp_${y} - inv_income_${y} - fv_gain_${y} - disposal_gain_${y}"
  field_expr historical "$y" period_operating_expenses "rev_${y} - cost_${y} - (${ebit})" formula "以营业利润为起点，剔除融资、投资、公允价值和资产处置影响后重构EBIT；期间经营费用为毛利减EBIT，保留经营相关政府补助、信用与存货减值。" medium
  field_expr historical "$y" cash_tax "current_tax_${y}" reported "以当期所得税费用近似经营现金税；非经营收益规模较小。" medium
  field_expr historical "$y" depreciation_amortization "fixed_da_${y} + intangible_da_${y} + prepaid_da_${y}" formula "经营口径折旧摊销；租赁采用经营口径，排除使用权资产摊销及投资性房地产摊销。" medium
  field_expr historical "$y" core_business_capex "capex_paid_${y} - asset_disposal_cash_${y}" formula "长期资产购建现金支出扣除处置回款；公司资本项目均服务厨柜及全屋定制现有业务。" medium
  field_est_y historical "$y" exploratory_business_capex 0 "未披露独立的新业务、新技术路线或新市场长期资产投入，全部资本开支归入现有定制家居主业。" medium "若后续披露可单独识别且尚未产生稳定收入的项目现金投入，则重新分类。"
  field_expr historical "$y" operating_working_capital_increase "(${ebit}) - current_tax_${y} + fixed_da_${y} + intangible_da_${y} + prepaid_da_${y} - ocf_${y}" formula "按利润路径与现金流路径倒算经营性营运资金及其他经营应计项目变化，使FCFF双路径闭合；资产负债表营运资金方向作交叉验证。" medium
  field_expr historical "$y" operating_cash_flow "ocf_${y}" reported "合并现金流量表经营活动现金流量净额。" high
  field_expr historical "$y" after_tax_interest_in_operating_cash_flow "0" formula "中国准则现金流量表中本公司借款利息列入筹资活动，经营现金流无需加回税后利息。" high
done

# 经营性营运资金和长期资产：逐项保留原披露名称，2022为首个展示年度期初。
add_capital_facts() {
  local y="$1" src="$2" loc="$3"
  shift 3
  local names=(notes_recv ar prepay other_recv interest_recv inventory other_ca notes_pay ap contract_liab payroll tax_pay other_cl fixed_asset cip intangible prepaid_long other_nca deferred_income)
  local labels=("应收票据" "应收账款" "预付款项" "其他应收款" "其中：应收利息" "存货" "其他流动资产" "应付票据" "应付账款" "合同负债" "应付职工薪酬" "应交税费" "其他流动负债" "固定资产" "在建工程" "无形资产" "长期待摊费用" "其他非流动资产" "递延收益")
  local vals=("$@")
  for i in "${!names[@]}"; do fact "${names[$i]}_${y}" "${labels[$i]}" "${vals[$i]}" "${y}-12-31" "$src" "$loc"; done
}

add_capital_facts 2022 "$s23" "PDF P69-P71（比较期）" 6703570.30 193310062.04 9960325.89 68116777.68 0 102446573.44 19771627.05 44541195.08 144425060.77 177104294.82 35080506.16 27006102.45 28223557.95 915940305.08 21250676.25 54993402.70 35369892.64 2189654.07 14966144.68
add_capital_facts 2023 "$s23" "PDF P69-P71" 18820580.62 101633964.81 9627146.96 41561634.50 1015369.87 101496152.30 15782440.44 103307050.39 130510589.54 199325546.35 37081540.09 14511294.51 25912320.72 1000807397.93 17704862.34 55532844.03 23677376.84 18736991.86 20600596.24
add_capital_facts 2024 "$s24" "PDF P73-P75" 7164592.40 92980808.28 2168558.92 34623691.96 352698.62 100171729.85 40343770.43 70482230.60 139750028.18 375359169.98 38899851.04 23478845.06 48796691.61 963266112.71 61946.90 52688608.47 23806832.03 30757218.84 17327058.52
add_capital_facts 2025 "$s25" "PDF P70-P72" 171162.00 73846610.77 1351865.08 24185842.10 107309.59 73942645.37 31612242.45 56861250.00 164325397.38 167206620.50 38696327.59 26257192.55 22175234.24 893431496.73 509070.80 50337546.40 26764938.15 32453056.63 22317779.27

for y in 2022 2023 2024 2025; do
  field_expr capital "$y" operating_working_capital "notes_recv_${y} + ar_${y} + prepay_${y} + other_recv_${y} - interest_recv_${y} + inventory_${y} + other_ca_${y} - notes_pay_${y} - ap_${y} - contract_liab_${y} - payroll_${y} - tax_pay_${y} - other_cl_${y}" formula "经营性流动资产扣除不含融资的一般经营流动负债；排除现金、理财、债权投资、预收租金、其他应付款和一年内到期融资负债。" medium
  field_expr capital "$y" operating_long_term_assets_net "fixed_asset_${y} + cip_${y} + intangible_${y} + prepaid_long_${y} + other_nca_${y} - deferred_income_${y}" formula "现有定制家居生产与交付所需固定资产、在建工程、经营无形资产、长期待摊及其他长期资产，扣除资产相关递延收益；排除使用权资产、投资性房地产、金融资产及递延税项。" medium
done
field_est_y capital 2022 required_cash 110000000 "约覆盖一个月采购、工资及日常经营支出，并考虑定制家居订单季节性。" medium "若月度最低现金余额或已承诺备用授信证明更低需求，则下调。"
field_est_y capital 2023 required_cash 110000000 "约覆盖一个月采购、工资及日常经营支出，并考虑定制家居订单季节性。" medium "若月度最低现金余额或已承诺备用授信证明更低需求，则下调。"
field_est_y capital 2024 required_cash 105000000 "收入与经营现金支出下降后，按约一个月正常现金经营支出估计。" medium "若月度最低现金余额或已承诺备用授信证明更低需求，则下调。"
field_est_y capital 2025 required_cash 100000000 "按2025年采购、职工和其他经营现金支出约一个月的规模估计最低结算资金。" medium "若月度最低现金余额、季节性或授信证明显示需求显著不同，则调整。"
for y in 2022 2023 2024 2025; do
  field_est_y capital "$y" unsupported_intangible_assets 0 "账面无商誉；土地使用权、软件等无形资产持续服务现有生产和订单系统，没有证据表明存在无法解释的并购溢价。" medium "若披露无形资产已闲置、减值或不再服务主营，则予以剔除。"
done

# 最新年度现金、非经营金融资产、债务和股本
fact cash_2025 "货币资金" 321610712.66 "2025-12-31" "$s25" "PDF P70"
fact restricted_cash_2025 "所有权或使用权受限的货币资金" 76956608.63 "2025-12-31" "$s25" "PDF P159"
fact trading_assets_2025 "交易性金融资产" 81425171.81 "2025-12-31" "$s25" "PDF P70"
fact current_debt_invest_2025 "一年内到期的非流动资产" 149488521.13 "2025-12-31" "$s25" "PDF P70"
fact debt_invest_2025 "其他债权投资" 102060879.80 "2025-12-31" "$s25" "PDF P71"
fact other_financial_2025 "其他非流动金融资产" 9097032.09 "2025-12-31" "$s25" "PDF P71"
fact investment_property_2025 "投资性房地产" 6976578.85 "2025-12-31" "$s25" "PDF P71"
fact short_debt_2025 "短期借款" 50093333.33 "2025-12-31" "$s25" "PDF P71"
fact long_debt_2025 "长期借款" 142825133.00 "2025-12-31" "$s25" "PDF P72、P165"
fact minority_2025 "少数股东权益" 0 "2025-12-31" "$s25" "PDF P73"
fact shares_2025 "实收资本（或股本）/股份总数" 319176930 "2025-12-31" "$s25" "PDF P73"

equity_expr excess_cash "cash_2025 - restricted_cash_2025 - 100000000" formula "货币资金扣除受限资金和估计的1亿元经营必需现金；余额视为股东可达的多余现金。" medium
equity_expr non_operating_assets "trading_assets_2025 + current_debt_invest_2025 + debt_invest_2025 + other_financial_2025 + investment_property_2025" formula "未参与主营FCFF形成的理财、债权投资、其他金融资产和投资性房地产按账面价值计入；不重复加入货币资金。" medium
equity_expr financing_debt "short_debt_2025 + long_debt_2025" formula "有息银行借款；租赁采用经营口径，因此不再扣租赁负债。" high
equity_expr minority_interest_value "minority_2025" reported "合并资产负债表无少数股东权益，且合并利润表无少数股东损益。" high
equity_est other_priority_claims 0 "未见优先股、永续债、已宣告未付股利或未纳入经营资本的重大建设付款。" medium "若期后新增或披露重大优先索偿，应从普通股价值扣除。"
equity_expr diluted_shares "shares_2025" reported "2025年末无库存股余额，也未见仍具实质摊薄可能的可转债或未解锁限制性股票，使用期末股份总数。" high

# 稳定期：采用统一八倍标尺，避免把2025年营运资金波动机械外推。
stable_est revenue 1480000000 "2023-2025收入先升后降再企稳；2025零售增长抵消大宗收缩，稳定期取略高于2025、低于2023的14.8亿元。" medium "若经销门店净减少且同店收入下降，或收入持续突破16亿元，则重估。"
stable_est cost_of_revenue 799200000 "按14.8亿元收入和46.0%正常毛利率估计，略低于2025的46.30%，反映全屋占比提升与经销毛利压力并存。" medium "若全屋定制毛利率继续下降超过2个百分点或大宗恢复且毛利改善，则调整。"
stable_est period_operating_expenses 470000000 "以2025年4.52亿元为低位基准，加入正常品牌投放、门店支持和研发冗余，低于2023-2024含信用损失及股权激励的水平。" medium "若费用率连续两年低于31%且门店和收入不受损，或重新出现大额信用损失，则调整。"
stable_est cash_tax 42000000 "按稳定EBIT约2.108亿元的约20%现金税率，介于2024-2025实际税负并考虑研发加计扣除。" medium "若有效现金税率长期偏离18%-22%，则调整。"
stable_est depreciation_amortization 100000000 "以2023-2025经营口径折旧摊销1.04、1.01、0.97亿元的中枢估计。" medium "若处置产能或新增大规模生产资产使折旧显著改变，则调整。"
stable_est core_business_capex 90000000 "2023-2025净资本开支1.28、0.60、0.34亿元；稳定期取0.90亿元，接近固定资产折旧且高于近两年现金支出，避免把短期少投入外推。" medium "若固定资产更新周期、产能利用率或连续三年资本开支证明0.90亿元显著过高/过低，则调整。"
stable_est exploratory_business_capex 0 "没有可识别的独立开拓性业务长期资产计划。" medium "若公司公布具名新业务及分期资金需求，则单列。"
stable_est operating_working_capital_increase 0 "成熟定制家居收入稳定时，不假设永久新增营运资金；2025的1.48亿元占用主要来自合同负债释放，不机械外推。" medium "若稳定增长、账期或库存政策造成持续占用，则改为正值。"

# 最新年度业务树。财报“其他渠道”并入零售配套，避免使用无信息占位业务。
fact dealer_rev_2025 "经销渠道营业收入" 1121728301.92 "2025年度" "$s25" "PDF P23"
fact direct_rev_2025 "直营渠道营业收入" 247490062.07 "2025年度" "$s25" "PDF P23"
fact support_rev_2025 "其他配套渠道营业收入" 21726977.82 "2025年度" "$s25" "PDF P23"
fact engineering_rev_2025 "大宗渠道营业收入" 59940584.86 "2025年度" "$s25" "PDF P23"
fact dealer_cost_2025 "经销渠道营业成本" 616655907.25 "2025年度" "$s25" "PDF P23"
fact direct_cost_2025 "直营渠道营业成本" 90360613.62 "2025年度" "$s25" "PDF P23"
fact support_cost_2025 "其他配套渠道营业成本" 12568933.94 "2025年度" "$s25" "PDF P23"
fact engineering_cost_2025 "大宗渠道营业成本" 59572049.41 "2025年度" "$s25" "PDF P23"
python3 "$tool" add-business --model "$model" --business-id retail --name "零售渠道（经销、直营及配套）" --importance "2025年收入95.9%，经销店覆盖与直营标杆共同获得家庭客户订单，是利润和现金的主体。" --confidence medium --falsifier "若公司披露经销、直营及配套渠道的期间费用或现金流差异足以改变整体利润判断，则进一步拆分。"
python3 "$tool" add-business --model "$model" --business-id engineering --name "大宗工程" --importance "收入占比仅4.1%，但2025毛利率0.61%，且历史地产客户坏账使其对风险和现金的影响大于收入占比。" --confidence medium --falsifier "若大宗客户结构、合同现金条款和毛利率连续改善，则重估其利润与现金贡献。"

bf() {
  if [[ -n "${7:-}" ]]; then
    python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" --falsifier "$7"
  else
    python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6"
  fi
}
bf_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
bf_expr retail revenue "dealer_rev_2025 + direct_rev_2025 + support_rev_2025" reported "经销、直营及财报配套渠道收入合计，闭合公司总收入。" high
bf_expr retail cost_of_revenue "dealer_cost_2025 + direct_cost_2025 + support_cost_2025" reported "经销、直营及财报配套渠道营业成本合计。" high
bf retail period_operating_expenses 431952605.88 estimate "公司未按渠道拆期间费用；将大宗相关信用风险与履约管理费用基准估计为0.20亿元，其余归零售。" low "若渠道费用或坏账附注明确给出大宗对应金额，则按披露重分。"
bf retail cash_tax 43745733.10 estimate "大宗工程基准点经营亏损，不分配现金税；公司当期税额全部归入盈利零售渠道。" medium "若税务披露显示大宗项目形成独立应税利润，则重分。"
bf retail operating_cash_flow_contribution 154874266.58 estimate "公司经营现金流1.249亿元；基于大宗回款收缩及历史地产应收风险，估计大宗占用0.30亿元，其余归零售。" low "若渠道回款、预收和应付数据披露，则以直接渠道现金流替代。"
bf_expr engineering revenue "engineering_rev_2025" reported "2025年大宗业务收入。" high
bf_expr engineering cost_of_revenue "engineering_cost_2025" reported "2025年大宗业务营业成本。" high
bf engineering period_operating_expenses 20000000 estimate "以2025年信用减值损失0.153亿元为主要基准，并计入项目获客和履约管理，形成0.20亿元基准点。" low "若大宗对应信用减值和渠道费用披露，则按直接数据替代。"
bf engineering cash_tax 0 estimate "基准点经营亏损，无经营现金税。" medium "若大宗业务形成应税经营利润，则计入经营现金税。"
bf engineering operating_cash_flow_contribution -30000000 estimate "大宗收入同比下降62.53%，且销售商品收现下降；结合历史地产应收风险估计净占用现金0.30亿元。" low "若客户回款和合同负债按渠道披露，则按直接数据替代。"

python3 "$tool" set-valuation --model "$model" --mode benchmark --stable-multiple 8 --safety-margin-ratio 0.6 --reason "公司处于成熟定制家居行业，2025零售修复但历史收入、费用和营运资金波动较大，缺少逐年成长投入与稳定到达时间证据；使用稳定经营收益八倍固定标尺。"
python3 "$tool" add-adjustment --model "$model" --name "现金可分配口径" --before "货币资金3.216亿元" --after "多余现金1.447亿元" --reason "扣除0.770亿元受限资金和估计1.000亿元经营必需现金；若经营最低现金或受限资金解除情况变化则重估。"
python3 "$tool" add-adjustment --model "$model" --name "租赁统一采用经营口径" --before "使用权资产0.250亿元、租赁负债及一年内到期租赁负债0.217亿元" --after "均不进入投入资本和融资负债" --reason "租赁门店现金支出已通过经营费用和经营现金流体现，避免在普通股价值桥重复扣除。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "全部重大数字来自三份上交所年度报告并记录PDF页码；估计字段均列示依据和可推翻条件。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "经营、融资与非经营资产分类一致；租赁统一采用经营口径，理财和债权投资未进入经营FCFF。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本期初期末均可得，ROIC分母为正且边界一致；正文仍提示经营必需现金和经营负债分类具有估计不确定性。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期综合三年收入、毛利、费用、折旧、资本开支与渠道变化，不机械采用2025营运资金占用或近两年低资本开支。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心数字将直接引用编译后的转写表；业务合计闭合2025公司收入、成本、费用、经营税和经营现金流。"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

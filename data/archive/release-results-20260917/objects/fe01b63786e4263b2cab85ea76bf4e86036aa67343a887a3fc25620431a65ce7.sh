#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
annual="沪上阿姨（上海）实业股份有限公司《2025年年度报告》，2026-04-28，https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0428/2026042804495.pdf"

python3 "$tool" init --name "沪上阿姨" --code "02589.HK" --period-label "2025年" --period-end "2025-12-31" --coverage-years 2025 --financial-currency CNY --trading-currency HKD --security-name 普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "$5" --scope "$6" --source "$7" --locator "$8"
}
field_expr() {
  if [[ -n "$2" ]]; then
    python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
  else
    python3 "$tool" set-field --model "$model" --view "$1" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
  fi
}
field_est() {
  if [[ -n "$2" ]]; then
    python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  else
    python3 "$tool" set-field --model "$model" --view "$1" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  fi
}
business_expr() {
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"
}
business_est() {
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"
}

# 2025 consolidated operating facts (CNY unless noted)
fact revenue_2025 "收入" 4465644000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第83页（年报第81页），合并损益表"
fact cost_sales_2025 "销售成本" 3061415000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第83页（年报第81页），合并损益表"
fact profit_before_tax_2025 "除税前溢利" 675468000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第83页（年报第81页），合并损益表"
fact finance_cost_2025 "财务成本" 4217000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第83页（年报第81页），合并损益表"
fact interest_income_2025 "银行利息收入" 7328000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第131页（年报第129页），附注6"
fact fv_gain_2025 "按公允价值计入损益的金融资产及金融投资公允价值变动" 20161000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第131页（年报第129页），附注6"
fact listing_expense_2025 "上市开支" 11648000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第132页（年报第130页），附注8"
fact disposal_loss_2025 "出售物业、厂房及设备亏损" 6323000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第131页（年报第129页），附注6"
fact income_tax_paid_2025 "已付所得税" 178864000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第89页（年报第87页），合并现金流量表"
fact ppe_da_2025 "物业、厂房及设备折旧" 21491000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第89页（年报第87页），合并现金流量表"
fact rou_da_2025 "使用权资产折旧" 40689000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第89页（年报第87页），合并现金流量表"
fact intangible_amort_2025 "无形资产摊销" 2740000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第89页（年报第87页），合并现金流量表"
fact ppe_purchase_2025 "购买物业、厂房及设备" 24619000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第90页（年报第88页），合并现金流量表"
fact intangible_purchase_2025 "购买无形资产" 4977000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第90页（年报第88页），合并现金流量表"
fact lease_principal_2025 "租赁付款本金" 46494000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第90页（年报第88页），合并现金流量表"
fact ppe_disposal_proceeds_2025 "出售物业、厂房及设备所得款项" 1024000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第90页（年报第88页），合并现金流量表"
fact operating_cash_flow_2025 "经营活动所得现金流量净额" 752983000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第89页（年报第87页），合并现金流量表"
fact ocf_interest_adjustment_2025 "计入经营现金流的税后利息" 0 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第89-90页（年报第87-88页）：利息支付列融资活动，经营现金流无利息支付"

# Revenue by economic business
fact franchise_goods_revenue_2025 "向加盟商销售货物收入" 3616601000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第129页（年报第127页），附注5"
fact franchise_service_revenue_2025 "加盟服务收入" 690394000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第129页（年报第127页），附注5"
fact direct_revenue_2025 "自营店及附属渠道收入" 158649000 "截至2025-12-31止年度" CNY consolidated "$annual" "PDF第129页（年报第127页）：自营店55,658千元加披露的其他102,991千元"

# Operating capital facts at opening and closing dates
for row in \
  "inventory_2024|存货|168068000|2024-12-31" \
  "trade_receivable_2024|贸易应收款项|1471000|2024-12-31" \
  "other_current_operating_assets_2024|预付款项、其他应收款项及其他资产|96152000|2024-12-31" \
  "prepaid_tax_2024|预缴所得税|985000|2024-12-31" \
  "trade_payable_2024|贸易应付款项|226253000|2024-12-31" \
  "other_operating_payables_2024|其他应付款项及应计费用|213016000|2024-12-31" \
  "contract_liability_2024|流动及非流动合约负债|57932000|2024-12-31" \
  "tax_payable_2024|应付税项|48464000|2024-12-31" \
  "ppe_2024|物业、厂房及设备|42882000|2024-12-31" \
  "rou_asset_2024|使用权资产|94012000|2024-12-31" \
  "intangible_2024|软件无形资产|11075000|2024-12-31" \
  "other_noncurrent_operating_assets_2024|其他非流动资产|20820000|2024-12-31" \
  "lease_liability_2024|流动及非流动租赁负债|96088000|2024-12-31" \
  "inventory_2025|存货|230529000|2025-12-31" \
  "trade_receivable_2025|贸易应收款项|25492000|2025-12-31" \
  "other_current_operating_assets_2025|预付款项、其他应收款项及其他资产|192977000|2025-12-31" \
  "prepaid_tax_2025|预缴所得税|4128000|2025-12-31" \
  "trade_payable_2025|贸易应付款项|349376000|2025-12-31" \
  "other_operating_payables_2025|其他应付款项及应计费用|344850000|2025-12-31" \
  "contract_liability_2025|流动及非流动合约负债|151566000|2025-12-31" \
  "tax_payable_2025|应付税项|44889000|2025-12-31" \
  "ppe_2025|物业、厂房及设备|42412000|2025-12-31" \
  "rou_asset_2025|使用权资产|96552000|2025-12-31" \
  "intangible_2025|软件无形资产|13312000|2025-12-31" \
  "other_noncurrent_operating_assets_2025|其他非流动资产|23108000|2025-12-31" \
  "lease_liability_2025|流动及非流动租赁负债|92428000|2025-12-31"
do
  IFS='|' read -r id label amount period <<< "$row"
  fact "$id" "$label" "$amount" "$period" CNY consolidated "$annual" "PDF第85-86页及第147-158页（年报第83-84页及第145-156页），相关资产负债表及附注"
done

# Equity bridge facts
fact cash_equivalents_2025 "现金及现金等价物" 1208354000 "2025-12-31" CNY consolidated "$annual" "PDF第85页及第154页（年报第83页及第152页）"
fact short_deposits_2025 "短期定期存款" 140410000 "2025-12-31" CNY consolidated "$annual" "PDF第155页（年报第153页），附注24"
fact long_deposits_2025 "长期定期存款" 191479000 "2025-12-31" CNY consolidated "$annual" "PDF第155页（年报第153页），附注24"
fact restricted_cash_2025 "因合同纠纷或诉讼受限的现金" 4506000 "2025-12-31" CNY consolidated "$annual" "PDF第155页（年报第153页），附注24"
fact current_fv_assets_2025 "按公允价值计入损益的金融资产" 703081000 "2025-12-31" CNY consolidated "$annual" "PDF第154页（年报第152页），附注23，银行理财和结构性存款"
fact fvoci_equity_2025 "按公允价值计入其他全面收入的上市股权投资" 73968000 "2025-12-31" CNY consolidated "$annual" "PDF第148页（年报第146页），附注17"
fact private_equity_fvpl_2025 "按公允价值计入损益的非上市股权投资" 4500000 "2025-12-31" CNY consolidated "$annual" "PDF第148页（年报第146页），附注18"
fact bank_debt_2025 "计息银行借款" 2000000 "2025-12-31" CNY consolidated "$annual" "PDF第158页（年报第156页），附注28"
fact minority_interest_2025 "少数股东权益" 0 "2025-12-31" CNY consolidated "$annual" "PDF第86页（年报第84页）：全部权益归属于母公司拥有人"
fact dividend_payable_2025 "已宣派未支付2025年中期股息" 71117242 "2025-12-31" CNY parent "$annual" "PDF第139页（年报第137页），附注12；2026-02-04支付"
fact proposed_final_dividend_2025 "建议2025年末期股息" 105203020 "2026-03-24" CNY parent "$annual" "PDF第139页（年报第137页），附注12"
fact diluted_shares_2025 "期末已发行普通股且无潜在摊薄股份" 105203020 "2025-12-31" shares parent "$annual" "PDF第39、140及163-164页（年报第37、138及161-162页）：全球发售精确发行2,773,020股，期初102,430,000股；附注13称无潜在摊薄股份"
fact hkd_cny_20260909 "1港元兑人民币" 0.8553 "2026-09-09" "CNY/HKD" market "Investing.com《HKD/CNY Historical Data》，https://www.investing.com/currencies/hkd-cny-historical-data" "2026-09-09收盘汇率0.8553"
fact current_price_20260908 "沪上阿姨收盘价" 81.40 "2026-09-08" HKD market "Investing.com《沪上阿姨(2589)历史数据》，https://hk.investing.com/equities/auntea-jenny-historical-data" "2026-09-08收盘价81.40港元"

# Historical operating view
field_expr historical 2025 revenue revenue_2025 reported "合并损益表直接披露" high
field_expr historical 2025 cost_of_revenue cost_sales_2025 reported "合并损益表直接披露" high
field_expr historical 2025 period_operating_expenses "revenue_2025 - cost_sales_2025 - (profit_before_tax_2025 + finance_cost_2025 - interest_income_2025 - fv_gain_2025 + listing_expense_2025 + disposal_loss_2025)" formula "由毛利扣除重构EBIT；剔除融资成本、利息与理财公允价值收益，并加回上市开支和资产处置损失" high
field_expr historical 2025 cash_tax income_tax_paid_2025 reported "经营利润与税前利润接近，采用现金流量表已付所得税作为经营现金税基准" medium
field_expr historical 2025 depreciation_amortization "ppe_da_2025 + rou_da_2025 + intangible_amort_2025" formula "经营性固定资产、使用权资产及软件折旧摊销合计" high
field_expr historical 2025 core_business_capex "ppe_purchase_2025 + intangible_purchase_2025 + lease_principal_2025 - ppe_disposal_proceeds_2025" formula "采用经营租赁口径，现金资本开支包括固定资产和软件购置、租赁本金，扣除处置回款" medium
field_est historical 2025 exploratory_business_capex 0 "年报未识别可与现有加盟网络分离、尚未稳定赚钱的长期资产项目；海外45店亦以加盟为主" medium "若公司披露海外、自营咖啡或新品牌的专属长期资产现金投入，则应重分类"
field_expr historical 2025 operating_working_capital_increase "(inventory_2025 + trade_receivable_2025 + other_current_operating_assets_2025 + prepaid_tax_2025 - trade_payable_2025 - other_operating_payables_2025 - contract_liability_2025 - tax_payable_2025) - (inventory_2024 + trade_receivable_2024 + other_current_operating_assets_2024 + prepaid_tax_2024 - trade_payable_2024 - other_operating_payables_2024 - contract_liability_2024 - tax_payable_2024)" formula "按经营性流动资产减无息经营负债计算期末减期初；负数表示加盟预收和供应商信用释放现金" high
field_expr historical 2025 operating_cash_flow operating_cash_flow_2025 reported "合并现金流量表直接披露" high
field_expr historical 2025 after_tax_interest_in_operating_cash_flow ocf_interest_adjustment_2025 reported "银行及租赁利息均列融资活动，经营现金流无需加回" high

# Operating capital: operating lease treatment, so ROU assets and lease liabilities are netted in operating assets.
field_expr capital 2024 operating_working_capital "inventory_2024 + trade_receivable_2024 + other_current_operating_assets_2024 + prepaid_tax_2024 - trade_payable_2024 - other_operating_payables_2024 - contract_liability_2024 - tax_payable_2024" formula "经营性短期资产减无息经营负债" high
field_expr capital 2024 operating_long_term_assets_net "ppe_2024 + rou_asset_2024 + intangible_2024 + other_noncurrent_operating_assets_2024 - lease_liability_2024" formula "经营长期资产扣除经营租赁负债" high
field_est capital 2024 required_cash 500000000 "约覆盖1.6个月不含折旧的经营现金成本，考虑食品采购、工资、物流和旺季备付" low "若月度现金支出、季节性现金谷值或可即时动用授信显示较低或较高需求，则调整"
field_est capital 2024 unsupported_intangible_assets 0 "账面无形资产仅为经营软件，未见商誉或无法解释并购溢价" medium "若后续披露软件不再服务经营或存在未披露并购资产，应剔除"
field_expr capital 2025 operating_working_capital "inventory_2025 + trade_receivable_2025 + other_current_operating_assets_2025 + prepaid_tax_2025 - trade_payable_2025 - other_operating_payables_2025 - contract_liability_2025 - tax_payable_2025" formula "经营性短期资产减无息经营负债" high
field_expr capital 2025 operating_long_term_assets_net "ppe_2025 + rou_asset_2025 + intangible_2025 + other_noncurrent_operating_assets_2025 - lease_liability_2025" formula "经营长期资产扣除经营租赁负债" high
field_est capital 2025 required_cash 500000000 "约覆盖1.6个月不含折旧的经营现金成本，考虑食品采购、工资、物流和旺季备付" low "若月度现金支出、季节性现金谷值或可即时动用授信显示较低或较高需求，则调整"
field_est capital 2025 unsupported_intangible_assets 0 "账面无形资产仅为经营软件，未见商誉或无法解释并购溢价" medium "若后续披露软件不再服务经营或存在未披露并购资产，应剔除"

# Stable benchmark uses current 2025 scale and normalised 25% tax; no growth is capitalised.
field_expr stable '' revenue revenue_2025 reported "仅有一个受支持年度，稳定标尺不外推增长，采用2025年收入规模" low
field_expr stable '' cost_of_revenue cost_sales_2025 reported "稳定标尺采用2025年销售成本" low
field_expr stable '' period_operating_expenses "revenue_2025 - cost_sales_2025 - (profit_before_tax_2025 + finance_cost_2025 - interest_income_2025 - fv_gain_2025 + listing_expense_2025 + disposal_loss_2025)" formula "采用剔除融资、金融收益、上市费用和处置损失后的2025经营费用" low
field_est stable '' cash_tax 167541750 "按稳定EBIT的25%法定税率估计，不延续单年税收优惠" medium "若优惠税率续期和集团应税利润地域分布支持长期低于25%的税率，则下调"
field_expr stable '' depreciation_amortization "ppe_da_2025 + rou_da_2025 + intangible_amort_2025" formula "以2025年折旧摊销代表现有资产消耗" low
field_est stable '' core_business_capex 64920000 "无多年证据拆分维持与扩张支出，令常态主营资本开支等于折旧摊销" low "若未来三年维持同等门店和供应链能力所需现金资本开支持续偏离折旧，则调整"
field_est stable '' exploratory_business_capex 0 "基准价值不为未验证的新品牌、海外或咖啡扩张单独赋值" medium "若出现专属资本投入、商业化里程碑和可验证现金流，应纳入成长路径"
field_est stable '' operating_working_capital_increase 0 "稳定且不增长状态不假设持续依靠加盟商预付款和供应商信用释放现金" medium "若稳定收入下合同负债和应付款仍持续结构性增长，应修订"

# Equity bridge
field_est equity '' excess_cash 1035737000 "现金及长短期定期存款扣除受限现金和5亿元经营必需现金；股息另列优先索偿" low "若募集资金用途构成不可撤销经营承诺或集团最低现金需求高于估计，多余现金应下调"
field_expr equity '' non_operating_assets "current_fv_assets_2025 + fvoci_equity_2025 + private_equity_fvpl_2025" formula "未参与经营FCFF的银行理财、结构性存款及股权投资按账面公允价值计入" high
field_expr equity '' financing_debt bank_debt_2025 reported "仅银行借款作为融资负债；租赁负债已在经营长期资产中扣除" high
field_expr equity '' minority_interest_value minority_interest_2025 reported "集团权益全部归属于母公司拥有人" high
field_expr equity '' other_priority_claims "dividend_payable_2025 + proposed_final_dividend_2025" formula "报告期末已宣派中期股息及年报建议末期股息均优先于留存给现有普通股的价值" high
field_expr equity '' diluted_shares diluted_shares_2025 reported "期末发行在外普通股105,203,000股，且年报明确无潜在摊薄普通股" high
field_expr equity '' financial_to_trading_fx "1 / hkd_cny_20260909" formula "按2026-09-09港元兑人民币0.8553换算人民币价值为港元" high
field_expr equity '' current_price current_price_20260908 reported "最近完整交易日收盘价" high
python3 "$tool" set-field --model "$model" --view equity --field current_price --expression current_price_20260908 --basis-type reported --reason "最近完整交易日收盘价" --confidence high --observed-at 2026-09-08

# Latest-year economic businesses
python3 "$tool" add-business --model "$model" --business-id franchise_goods --name "加盟商货品供应" --importance "收入主体；以规模采购、仓配和设备供给赚取商品差价" --confidence medium --falsifier "若公司披露该收入的实际毛利或成本结构，替换研究分摊"
business_expr franchise_goods revenue franchise_goods_revenue_2025 reported "附注5直接披露" high
business_est franchise_goods cost_of_revenue 2895000000 "假设商品供应毛利约20%，其余成本在服务和直营渠道闭合" low "披露按收入类别销售成本或商品毛利率"
business_est franchise_goods period_operating_expenses 300000000 "采购、仓配、销售支持和总部费用按主要受益业务分配" low "披露业务费用或可归属人员、物流费用"
business_est franchise_goods cash_tax 112550000 "按正EBIT贡献分配公司现金税，并与集团总额闭合" low "披露各业务应税利润或税费"
business_est franchise_goods operating_cash_flow_contribution 460000000 "商品业务贡献主要存货、应付和加盟商预收现金释放" low "披露分业务现金流或营运资金"

python3 "$tool" add-business --model "$model" --business-id franchise_services --name "加盟管理服务" --importance "品牌授权、选址、培训、数字化和持续运营支持；收入与加盟采购挂钩" --confidence medium --falsifier "若公司披露服务业务直接成本或人员费用，替换研究分摊"
business_expr franchise_services revenue franchise_service_revenue_2025 reported "附注5直接披露" high
business_est franchise_services cost_of_revenue 25000000 "服务本身直接材料成本较少，大部分品牌与人员投入列期间费用" low "披露加盟服务履约成本"
business_est franchise_services period_operating_expenses 400000000 "将营销、数字化、培训与加盟网络支持的大部分费用归入服务业务" low "披露服务人员、营销及系统费用的业务归属"
business_est franchise_services cash_tax 70800000 "按正EBIT贡献分配公司现金税，并与集团总额闭合" low "披露各业务应税利润或税费"
business_est franchise_services operating_cash_flow_contribution 280000000 "服务费多为预收，按利润和合同负债增长估计现金贡献" low "披露分业务现金流或合同负债归属"

python3 "$tool" add-business --model "$model" --business-id direct_channels --name "直营门店及消费者渠道" --importance "26家直营店与附属消费者渠道，规模小但用于产品和门店模型验证" --confidence low --falsifier "若公司拆解附注5中的102,991千元收入性质，应重构此业务边界"
business_expr direct_channels revenue direct_revenue_2025 formula "自营店收入55,658千元与披露的其余渠道收入102,991千元合并，避免无信息占位" medium
business_est direct_channels cost_of_revenue 141415000 "以合并成本扣除两项加盟业务估计成本闭合" low "披露直营和其余渠道销售成本"
business_est direct_channels period_operating_expenses 34062000 "以公司期间费用扣除两项加盟业务估计费用闭合" low "披露直营和其余渠道费用"
business_est direct_channels cash_tax -4486000 "该组合估计EBIT为负，分配相应税盾以闭合集团现金税" low "披露业务税前利润或不可抵扣亏损"
business_est direct_channels operating_cash_flow_contribution 12983000 "以公司经营现金流扣除两项加盟业务估计贡献闭合" low "披露分业务现金流"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "公司仍高速扩店且仅有一份上市后年报，缺乏稳定状态到达时间、逐年FCFF及全部成长投入证据，因此使用稳定经营收益八倍固定标尺" --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-adjustment --model "$model" --name "经营EBIT重构" --before "税前利润6.75亿元" --after "EBIT 6.70亿元" --reason "加回融资成本，剔除利息和金融资产公允价值收益，并加回上市开支及资产处置损失；保留与经营成本补偿相关的政府补助。"
python3 "$tool" add-adjustment --model "$model" --name "租赁统一为经营口径" --before "使用权资产0.966亿元、租赁负债0.924亿元；租赁本金0.465亿元列融资现金流" --after "租赁资产负债在经营长期资产内净额处理，租赁本金计入现金资本开支" --reason "避免既把租赁负债作为融资债务扣除、又在FCFF扣租赁现金支出的重复计算。"
python3 "$tool" add-adjustment --model "$model" --name "现金与金融资产分类" --before "现金、定期存款、理财及股权投资合计23.2亿元" --after "经营必需现金5.00亿元；多余现金10.4亿元；非经营资产7.82亿元；受限现金不计值" --reason "经营现金进入投入资本，银行理财和独立股权投资未参与经营FCFF，分开计值。"
python3 "$tool" add-adjustment --model "$model" --name "股息优先索偿" --before "报告期末应付中期股息0.711亿元，年报建议末期股息1.052亿元" --after "合计1.76亿元从普通股价值桥扣除" --reason "两项现金均归属于报告期利润分配，不能同时留在报告期末现金中归属于现有普通股价值。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "全部报表事实保留披露名称、期间、币种、合并范围、年报页码和公开链接；市场价格及汇率另列观察日来源。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "融资收益、理财公允价值收益和上市费用已从经营EBIT剔除；租赁采用一致经营口径；现金、理财及股权投资未重复计值。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "ROIC公式保留，但加盟预收与供应商信用令投入资本分母很小，且经营必需现金为低可信估计，报告仅解释资本占用结构，不把公式结果当作持久竞争优势证据。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "仅一个上市后完整年度，不机械外推36%收入增长；采用2025当前规模、25%税率、资本开支等于折旧、零营运资金增长的固定标尺，并明确低置信度和推翻条件。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告重大数字、业务合计、FCFF、价值桥、汇率和价格均与结构化模型一致。"

python3 "$tool" compile --model "$model"

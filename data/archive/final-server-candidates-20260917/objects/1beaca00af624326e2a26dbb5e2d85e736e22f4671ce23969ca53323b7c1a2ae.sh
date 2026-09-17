#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs
python3 "$tool" init --name "钛能化学" --code "002145.SZ" --period-label "2025年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "普通股" --security-unit "股" --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "合并" --source "$5" --locator "$6"
}
field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
field_est() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

s23="中核华原钛白股份有限公司2023年年度报告（2024-04-18）"
s24="中核华原钛白股份有限公司2024年年度报告（2025-03-11）"
s25="钛能化学股份有限公司2025年年度报告（2026-04-29）"

# 历史利润、现金流和折旧摊销事实
fact y2023_revenue 营业收入 4946559389.00 2023 "$s23" "PDF P126"
fact y2023_cost 营业成本 4065421285.98 2023 "$s23" "PDF P126"
fact y2023_opprofit 营业利润 502597356.88 2023 "$s23" "PDF P127"
fact y2023_finexp 财务费用 -154219914.89 2023 "$s23" "PDF P127"
fact y2023_inv 投资收益 31394221.71 2023 "$s23" "PDF P127"
fact y2023_fv 公允价值变动收益 -29359082.81 2023 "$s23" "PDF P127"
fact y2023_disposal 资产处置收益 8552279.58 2023 "$s23" "PDF P127"
fact y2023_inctax 所得税费用 72552329.55 2023 "$s23" "PDF P127"
fact y2023_da_fixed 固定资产折旧 213312189.52 2023 "$s23" "PDF P204"
fact y2023_da_rou 使用权资产折旧 9102548.88 2023 "$s23" "PDF P204"
fact y2023_da_intan 无形资产摊销 16522106.34 2023 "$s23" "PDF P204"
fact y2023_da_long 长期待摊费用摊销 10975355.89 2023 "$s23" "PDF P204"
fact y2023_ocf 经营活动产生的现金流量净额 -337129504.91 2023 "$s23" "PDF P130"
fact y2023_interest_income 利息收入 209708325.71 2023 "$s23" "PDF P127"
fact y2023_capex_pay 购建固定资产无形资产和其他长期资产支付的现金 1304956698.34 2023 "$s23" "PDF P130"
fact y2023_capex_disposal 处置固定资产无形资产和其他长期资产收回的现金净额 25278136.73 2023 "$s23" "PDF P130"

fact y2024_revenue 营业收入 6874598275.40 2024 "$s24" "PDF P132"
fact y2024_cost 营业成本 5677608618.35 2024 "$s24" "PDF P132"
fact y2024_opprofit 营业利润 673008002.69 2024 "$s24" "PDF P133"
fact y2024_finexp 财务费用 -107204458.02 2024 "$s24" "PDF P132"
fact y2024_inv 投资收益 73125307.70 2024 "$s24" "PDF P132"
fact y2024_fv 公允价值变动收益 -15585451.35 2024 "$s24" "PDF P132"
fact y2024_disposal 资产处置收益 -3069323.48 2024 "$s24" "PDF P132-P133"
fact y2024_inctax 所得税费用 105378158.71 2024 "$s24" "PDF P133"
fact y2024_da_fixed 固定资产折旧 302709767.43 2024 "$s24" "PDF P204"
fact y2024_da_rou 使用权资产折旧 8769965.62 2024 "$s24" "PDF P204"
fact y2024_da_intan 无形资产摊销 32499799.87 2024 "$s24" "PDF P204"
fact y2024_da_long 长期待摊费用摊销 13479755.87 2024 "$s24" "PDF P204"
fact y2024_ocf 经营活动产生的现金流量净额 342866340.68 2024 "$s24" "PDF P136"
fact y2024_interest_income 利息收入 167872482.63 2024 "$s24" "PDF P132"
fact y2024_capex_pay 购建固定资产无形资产和其他长期资产支付的现金 641776815.70 2024 "$s24" "PDF P136"
fact y2024_capex_disposal 处置固定资产无形资产和其他长期资产收回的现金净额 8943103.03 2024 "$s24" "PDF P136"

fact y2025_revenue 营业收入 7783579654.79 2025 "$s25" "PDF P107"
fact y2025_cost 营业成本 6715903459.33 2025 "$s25" "PDF P107"
fact y2025_opprofit 营业利润 475055411.68 2025 "$s25" "PDF P108"
fact y2025_finexp 财务费用 -63609445.70 2025 "$s25" "PDF P108"
fact y2025_inv 投资收益 14715525.85 2025 "$s25" "PDF P108"
fact y2025_fv 公允价值变动收益 1537240.02 2025 "$s25" "PDF P108"
fact y2025_disposal 资产处置收益 -1363575.08 2025 "$s25" "PDF P108"
fact y2025_inctax 所得税费用 97069585.22 2025 "$s25" "PDF P108"
fact y2025_da_fixed 固定资产折旧 429991915.16 2025 "$s25" "PDF P182"
fact y2025_da_rou 使用权资产折旧 4103124.14 2025 "$s25" "PDF P182"
fact y2025_da_intan 无形资产摊销 32047714.43 2025 "$s25" "PDF P182"
fact y2025_da_long 长期待摊费用摊销 8668051.06 2025 "$s25" "PDF P182"
fact y2025_ocf 经营活动产生的现金流量净额 422196787.48 2025 "$s25" "PDF P111"
fact y2025_interest_income 利息收入 133631745.99 2025 "$s25" "PDF P108"
fact y2025_capex_pay 购建固定资产无形资产和其他长期资产支付的现金 606131112.38 2025 "$s25" "PDF P111"
fact y2025_capex_disposal 处置固定资产无形资产和其他长期资产收回的现金净额 1990223.47 2025 "$s25" "PDF P111"

for y in 2023 2024 2025; do
  field_expr historical "$y" revenue "y${y}_revenue" reported "合并利润表营业收入" high
  field_expr historical "$y" cost_of_revenue "y${y}_cost" reported "合并利润表营业成本" high
  ebit="y${y}_opprofit+y${y}_finexp-y${y}_inv-y${y}_fv-y${y}_disposal"
  field_expr historical "$y" period_operating_expenses "y${y}_revenue-y${y}_cost-(${ebit})" formula "由毛利减去剔除净融资、投资、公允价值及资产处置影响后的EBIT重构" medium
  field_expr historical "$y" depreciation_amortization "y${y}_da_fixed+y${y}_da_rou+y${y}_da_intan+y${y}_da_long" formula "现金流补充资料中的四项常规折旧摊销合计" high
  field_expr historical "$y" operating_cash_flow "y${y}_ocf" reported "合并现金流量表经营活动现金流量净额" high
done

field_est historical 2023 cash_tax 55000000 "以调整后EBIT、所得税费用和约15%主要经营主体税负估计经营现金税" medium "分主体应纳税所得额及现金税对账显示经营税负显著偏离"
field_est historical 2024 cash_tax 80000000 "以调整后EBIT、所得税费用及约15%-16%正常经营税负估计" medium "税务附注证明投资收益或递延税影响与当前估计明显不同"
field_est historical 2025 cash_tax 83000000 "以调整后EBIT及当年所得税费用估计，保留亏损主体与税收优惠影响" medium "分业务现金税或递延税明细推翻约21%的经营税负"
field_expr historical 2023 after_tax_interest_in_operating_cash_flow "0-y2023_interest_income*(1-55000000/(y2023_opprofit+y2023_finexp-y2023_inv-y2023_fv-y2023_disposal))" formula "剔除经营现金流中收到的税后利息" medium
field_expr historical 2024 after_tax_interest_in_operating_cash_flow "0-y2024_interest_income*(1-80000000/(y2024_opprofit+y2024_finexp-y2024_inv-y2024_fv-y2024_disposal))" formula "剔除经营现金流中收到的税后利息" medium
field_expr historical 2025 after_tax_interest_in_operating_cash_flow "0-y2025_interest_income*(1-83000000/(y2025_opprofit+y2025_finexp-y2025_inv-y2025_fv-y2025_disposal))" formula "剔除经营现金流中收到的税后利息" medium

# 资本开支分为已有主营产能与尚在商业化验证的新业务；合计为现金购建支出扣处置回款。
field_est historical 2023 core_business_capex 700000000 "钛白粉扩产、技改、环保安全及存量基地投入的基准估计" low "项目付款明细证明归属现有钛白粉与磷化工产能的金额不同"
field_est historical 2023 exploratory_business_capex 579678561.61 "净现金资本开支扣除主业投入，主要对应磷酸铁、资源和新产业链建设" low "逐项目现金付款表推翻分配"
field_est historical 2024 core_business_capex 450000000 "钛白粉新增产能释放及存量基地技改维护投入估计" low "逐项目现金付款和转固明细显示不同归属"
field_est historical 2024 exploratory_business_capex 182833712.67 "净现金资本开支扣除主业部分，归入尚在爬坡的新材料与磷化工建设" low "逐项目现金付款和转固明细显示不同归属"
field_est historical 2025 core_business_capex 550000000 "现金投入以已形成收入的钛白粉后处理、黄磷和存量基地为主" medium "资本开支项目明细显示超过0.54亿元直接用于未商业化新业务"
field_est historical 2025 exploratory_business_capex 54140888.91 "净现金资本开支扣除主营投入，谨慎归为新材料及新项目验证" low "项目付款明细证明该部分服务于已稳定盈利业务"

# 营运资金增加以利润路径和剔除税后利息后的现金流路径的闭合残差记录，包含表外分类差异。
field_est historical 2023 operating_working_capital_increase 1045394706.729292 "由NOPAT、折旧摊销与剔除税后利息的经营现金流反推的经营资金占用" medium "完整现金流附注可将差额归入非营运资金项目"
field_est historical 2024 operating_working_capital_increase 587534152.3406949 "由利润路径与现金流路径闭合反推，反映库存应收等综合占用" medium "完整现金流附注可将差额归入非营运资金项目"
field_est historical 2025 operating_working_capital_increase 471833189.3044872 "由利润路径与现金流路径闭合反推；库存增加是主要可见驱动" medium "完整现金流附注证明差额主要来自非经营项目"

# 资本存量：经营性短期资产减无息经营负债；长期资产已排除商誉、金融投资和递延税，并扣递延收益、长期应付款和租赁负债。
field_est capital 2022 operating_working_capital -883391454.90 "按应收票据/账款/融资、预付、存货、其他流动资产减票据/应付账款、合同负债、职工税费及其他流动负债重构" medium "附注明细显示大额项目为融资性或非经营性"
field_est capital 2023 operating_working_capital -319325917.33 "同口径重构经营性营运资金" medium "附注明细显示大额项目为融资性或非经营性"
field_est capital 2024 operating_working_capital -114596241.85 "同口径重构经营性营运资金" medium "附注明细显示大额项目为融资性或非经营性"
field_est capital 2025 operating_working_capital 61494604.62 "同口径重构；库存与应收增长使经营性营运资金转正" medium "附注明细显示大额项目为融资性或非经营性"
field_est capital 2022 operating_long_term_assets_net 4898844823.19 "固定资产、在建工程、使用权资产、经营无形资产、长期待摊和其他长期资产减对应经营负债；不含商誉与金融资产" medium "资产附注明细证明部分土地、其他非流动资产不服务经营"
field_est capital 2023 operating_long_term_assets_net 7606206148.17 "同口径重构，增长主要来自在建工程和无形资产" medium "资产附注明细证明部分项目不服务经营"
field_est capital 2024 operating_long_term_assets_net 8107494882.32 "同口径重构，主要建设项目转固后固定资产上升" medium "资产附注明细证明部分项目不服务经营"
field_est capital 2025 operating_long_term_assets_net 8193054342.56 "同口径重构，商誉及金融投资未计入经营机器" medium "资产附注明细证明部分项目不服务经营"
field_est capital 2022 required_cash 400000000 "约一个月现金经营开支与结算缓冲" low "月度采购、工资与结算数据支持明显不同的最低现金"
field_est capital 2023 required_cash 400000000 "约一个月现金经营开支与结算缓冲" low "月度采购、工资与结算数据支持明显不同的最低现金"
field_est capital 2024 required_cash 500000000 "随收入和采购规模增长提高经营现金缓冲" low "月度采购、工资与结算数据支持明显不同的最低现金"
field_est capital 2025 required_cash 600000000 "接近一个月扣除折旧后的经营成本，用于工资、采购及税费结算" medium "月度最低现金、授信及季节性资料支持明显更低或更高金额"
for y in 2022 2023 2024 2025; do
  field_est capital "$y" unsupported_intangible_assets 0 "商誉已在经营性长期资产净额之外，不再重复扣除" high "经营性长期资产口径实际包含商誉或无法解释并购溢价"
done

# 用资产负债表逐项事实覆盖上面的汇总基准，确保经营资本可以沿事实ID回溯。
capfacts() {
  local y="$1" src="$2" loc="$3"; shift 3
  local keys=(notes ar arf pre stock oca np ap contract emp taxpay ocl fixed cip rou intan dev ltd onca lease ltp deferred)
  local labels=(应收票据 应收账款 应收款项融资 预付款项 存货 其他流动资产 应付票据 应付账款 合同负债 应付职工薪酬 应交税费 其他流动负债 固定资产 在建工程 使用权资产 无形资产 开发支出 长期待摊费用 其他非流动资产 租赁负债 长期应付款 递延收益)
  local i
  for i in "${!keys[@]}"; do fact "y${y}_${keys[$i]}" "${labels[$i]}" "${1}" "$y-12-31" "$src" "$loc"; shift; done
}
capfacts 2022 "$s23" "PDF P122-P124（2023年1月1日比较数）" \
  165432093.41 700820311.03 207826937.44 142092102.32 776855844.31 54465706.20 2243287549.36 579859681.08 31100448.39 37303822.61 35261354.73 4071593.44 \
  2509265030.47 1701055683.27 25761133.47 417767833.74 147303.32 22168687.40 324305255.28 19447074.38 13702398.66 68476630.72
capfacts 2023 "$s23" "PDF P122-P124" \
  22819146.40 828881699.98 119274379.08 188847457.35 1005830901.07 84699696.36 1426930795.54 955281858.14 69154334.01 49717557.76 58356353.57 10238298.55 \
  3177312785.27 3358499632.69 31004076.30 1014440550.03 193258.31 43905580.85 67445675.30 23192320.35 4298165.92 59104924.31
capfacts 2024 "$s24" "PDF P127-P129" \
  103636957.47 966078917.35 151823007.42 158950649.19 1237655347.20 59991956.04 1547342977.71 1100163625.53 51644392.68 49728098.92 36277203.89 7576777.79 \
  6001249011.65 1138843527.06 23871110.37 928869545.79 229009.43 37155839.31 48646463.30 15853263.56 3840090.44 51676270.59
capfacts 2025 "$s25" "PDF P103-P105" \
  64741269.14 1151348015.19 233561117.82 232115717.16 1761745834.21 33343784.30 2167740983.60 1085116620.32 50814622.10 37247208.09 60897019.16 13544679.93 \
  6252237386.53 786017228.58 9302448.51 1042579580.42 172729.61 35387664.59 123209902.63 7907679.93 3461542.48 44483375.90
for y in 2022 2023 2024 2025; do
  field_expr capital "$y" operating_working_capital "y${y}_notes+y${y}_ar+y${y}_arf+y${y}_pre+y${y}_stock+y${y}_oca-y${y}_np-y${y}_ap-y${y}_contract-y${y}_emp-y${y}_taxpay-y${y}_ocl" formula "经营性短期资产减无息经营负债；其他应收应付因含股权与非经营往来未纳入" medium
  field_expr capital "$y" operating_long_term_assets_net "y${y}_fixed+y${y}_cip+y${y}_rou+y${y}_intan+y${y}_dev+y${y}_ltd+y${y}_onca-y${y}_lease-y${y}_ltp-y${y}_deferred" formula "经营长期资产扣租赁负债、长期应付款与资产相关递延收益；不含商誉、金融投资和递延税" medium
done

# 最新年度业务树事实
fact y2025_ti_revenue 钛白粉营业收入 5881752981.95 2025 "$s25" "PDF P23"
fact y2025_ti_cost 钛化工类营业成本 5341187968.67 2025 "$s25" "PDF P24"
fact y2025_phos_revenue 磷化工类营业收入 911814805.44 2025 "$s25" "PDF P23"
fact y2025_phos_cost 磷化工类营业成本 636789553.00 2025 "$s25" "PDF P24"
fact y2025_newenergy_revenue 新能源类营业收入 359608025.18 2025 "$s25" "PDF P23"
fact y2025_logistics_revenue 物流服务类营业收入 335337811.60 2025 "$s25" "PDF P23"
fact y2025_byproduct_revenue 其他产品营业收入 295066030.62 2025 "$s25" "PDF P23"

addbiz() { python3 "$tool" add-business --model "$model" --business-id "$1" --name "$2" --importance "$3" --confidence "$4" --falsifier "$5"; }
bizexpr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
bizest() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }

addbiz titanium "钛白粉" "规模最大但2025年价格与毛利承压的成熟主业。" high "产品分部口径或内部交易抵销出现重大调整"
addbiz phosphorus "磷矿与黄磷" "矿化一体的第二利润来源，黄磷仍在产能爬坡。" medium "分部成本或内部磷矿自用抵销改变利润判断"
addbiz newenergy "磷酸铁新能源材料" "收入快速放量但稳定盈利尚未验证。" low "分部利润证明已形成稳定正现金回报"
addbiz logistics "物流服务" "服务产业链并对外取得收入的轻资产配套业务。" medium "物流子公司完整报表显示经济性明显不同"
addbiz byproducts "硫酸亚铁及循环副产品" "钛白粉联产副产品，低增量成本但披露合并在其他产品。" low "其他产品明细显示主要并非循环副产品"

bizexpr titanium revenue y2025_ti_revenue reported "年报按产品披露" high
bizexpr titanium cost_of_revenue y2025_ti_cost reported "年报按钛化工行业披露" high
bizest titanium period_operating_expenses 420000000 "结合钛白粉收入规模、销售体系、研发与子公司利润分配" low "分部费用或管理口径披露"
bizest titanium cash_tax 25000000 "按该业务正EBIT及主要主体优惠税率估计" low "分部现金税披露"
bizest titanium operating_cash_flow_contribution 180000000 "按NOPAT、库存上升和应收回款占用估计" low "分部现金流量表披露"

bizexpr phosphorus revenue y2025_phos_revenue reported "年报按行业披露" high
bizexpr phosphorus cost_of_revenue y2025_phos_cost reported "年报按行业披露" high
bizest phosphorus period_operating_expenses 95000000 "结合矿山与黄磷子公司利润及集团费用分摊估计" low "分部费用披露"
bizest phosphorus cash_tax 38000000 "按正EBIT和约21%经营税率估计" low "分部现金税披露"
bizest phosphorus operating_cash_flow_contribution 170000000 "矿山高利润与黄磷爬坡、存货占用综合估计" low "分部现金流量表披露"

bizexpr newenergy revenue y2025_newenergy_revenue reported "年报按行业披露" high
bizest newenergy cost_of_revenue 300000000 "按产销4万吨左右但仍在商业化爬坡的基准毛利估计" low "新能源材料分部成本披露"
bizest newenergy period_operating_expenses 65000000 "研发、销售与产能爬坡费用基准估计" low "新能源材料分部费用披露"
bizest newenergy cash_tax -1000000 "小幅经营亏损形成的税盾估计" low "分部应纳税所得额披露"
bizest newenergy operating_cash_flow_contribution -30000000 "放量期库存、应收和客户验证占用现金" low "分部现金流量表披露"

bizexpr logistics revenue y2025_logistics_revenue reported "年报按行业披露" high
bizest logistics cost_of_revenue 285000000 "参考物流业务轻资产但竞争性服务毛利估计" low "物流分部成本披露"
bizest logistics period_operating_expenses 35000000 "按物流收入与组织复杂度估计" low "物流分部费用披露"
bizest logistics cash_tax 3000000 "按业务EBIT和正常税负估计" low "物流主体现金税披露"
bizest logistics operating_cash_flow_contribution 35000000 "按NOPAT及较短现金转换周期估计" low "物流主体现金流量表披露"

bizexpr byproducts revenue y2025_byproduct_revenue reported "年报其他产品口径，结合主营产品清单命名" medium
bizest byproducts cost_of_revenue 152925937.66 "作为联产副产品按较低增量成本估计，并用于成本闭合" low "其他产品成本明细披露"
bizest byproducts period_operating_expenses 56119420.27 "剩余集团经营费用按收入与渠道复杂度分配并闭合" low "其他产品分部费用披露"
bizest byproducts cash_tax 18000000 "按剩余正EBIT及正常税负估计并闭合" low "其他产品现金税披露"
bizest byproducts operating_cash_flow_contribution 67196787.48 "按公司经营现金流剩余贡献闭合" low "其他产品分部现金流披露"

# 稳定期：不机械外推2025低谷，也不采用管理层产量目标；不给未验证新项目单独价值。
field_est stable "" revenue 7800000000 "以2025收入规模为基点，钛白粉价格恢复与增量产能利用互相抵消" medium "持续两年以上销量、价格或产能利用率支持明显不同收入"
field_est stable "" cost_of_revenue 6591000000 "对应15.5%稳定毛利率，介于近三年总体毛利率并考虑磷化工占比上升" medium "钛白粉长期毛利维持9%附近或恢复至17%以上"
field_est stable "" period_operating_expenses 680000000 "参考2024-2025调整后经营费用约6.7-6.9亿元" medium "组织精简或新增业务费用使常态费用偏离"
field_est stable "" cash_tax 90000000 "按稳定EBIT约17%经营现金税率" medium "税收优惠到期或分部亏损抵扣导致税率显著变化"
field_est stable "" depreciation_amortization 475000000 "以2025折旧摊销为基点，近期大额转固后趋稳" medium "新转固或资产处置令常态折旧明显变化"
field_est stable "" core_business_capex 500000000 "接近当前折旧水平，覆盖设备更新、环保安全和既有产能提效" medium "多年资本开支和产能状态证明维持现有经营仅需更低投入"
field_est stable "" exploratory_business_capex 0 "稳定经营收益不扣未承诺的新业务风险投资，亦不给其单独价值" medium "已批准且收益与投入可可靠估计的新项目形成稳定路径"
field_est stable "" operating_working_capital_increase 0 "稳定且不继续增长状态下不假设永久增加营运资金" medium "库存安全水平或账期结构持续抬升"

# 普通股价值桥
fact y2025_cash 货币资金 6664460906.19 2025-12-31 "$s25" "PDF P103及P147"
fact y2025_restricted_cash 使用受限及汇回受限货币资金 679120187.24 2025-12-31 "$s25" "PDF P147-P148"
fact y2025_lteq 长期股权投资 135920169.20 2025-12-31 "$s25" "PDF P103"
fact y2025_equityinv 其他权益工具投资 268287895.98 2025-12-31 "$s25" "PDF P103"
fact y2025_trading 交易性金融资产 1981837.76 2025-12-31 "$s25" "PDF P103"
fact y2025_shortdebt 短期借款 2764285511.08 2025-12-31 "$s25" "PDF P104"
fact y2025_current_longdebt 一年内到期的长期借款 247450000.00 2025-12-31 "$s25" "PDF P171"
fact y2025_longdebt 长期借款 711900000.00 2025-12-31 "$s25" "PDF P104"
fact y2025_minority 少数股东权益 92962566.02 2025-12-31 "$s25" "PDF P105"
fact y2025_issued 股本 3806672183 2025-12-31 "$s25" "PDF P105"
fact y2025_treasury_shares 回购专用证券账户持股 220379745 2025-12-31 "$s25" "PDF P22"

field_expr equity "" excess_cash "y2025_cash-y2025_restricted_cash-600000000" formula "货币资金扣受限资金及6.00亿元经营必需现金；无未用募集资金承诺" medium
field_expr equity "" non_operating_assets "y2025_lteq+y2025_equityinv+y2025_trading" formula "未进入合并FCFF的联营及金融投资按账面值计入" medium
field_expr equity "" financing_debt "y2025_shortdebt+y2025_current_longdebt+y2025_longdebt" formula "计息银行借款；经营票据与应付款不重复扣除" high
field_expr equity "" minority_interest_value "y2025_minority" formula "缺少少数股东子公司独立估值资料，以账面权益作替代" low
field_est equity "" other_priority_claims 0 "未识别出已在经营资本和融资负债之外的重大优先索偿" medium "诉讼、资本承诺或已宣告未付分配形成重大义务"
field_expr equity "" diluted_shares "y2025_issued-y2025_treasury_shares" formula "期末已发行股本扣不参与分配的库存股，未发现实质摊薄工具" high

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "钛白粉处于价格低谷、黄磷和磷酸铁仍在爬坡，缺少逐年FCFF和完整成长投入证据，按统一纪律使用稳定经营收益八倍基准" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "商誉不作为经营资产" --before "账面商誉5.44亿元" --after "经营资产计值0" --reason "并购溢价未单独证明可脱离当前经营收益形成额外价值，且已从经营性长期资产净额排除。"
python3 "$tool" add-adjustment --model "$model" --name "现金可达性" --before "货币资金66.64亿元" --after "多余现金53.85亿元" --reason "扣除6.79亿元受限资金和6.00亿元经营必需现金；募集资金账户年末余额为零。"
python3 "$tool" add-adjustment --model "$model" --name "终止未验证扩张项目" --before "水溶肥及年产50万吨磷酸铁项目规划" --after "不赋予额外项目价值" --reason "公司因需求放缓、原料供应与成本及行业盈利低于预期而终止募投项目，剩余资金永久补流。"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本分母为约80-90亿元且口径跨期一致；但费用化研发与必需现金仍为估计，正文只把低ROIC解释为重资产回报偏低而非永久竞争劣势。"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "利润、现金流、资产负债、分部收入成本、股数与受限资金均记录年报名称、期间和PDF页码。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "商誉和金融投资排除于经营资产，票据及经营应付款不作为融资负债重复扣除，租赁资产负债采用净额经营口径。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定状态综合三年毛利、最新业务结构、产能爬坡和资本开支，不采用单年FCFF或管理层远期目标。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心数字将引用结构化模型生成的转写表，业务合计与2025公司总量闭合。"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
mkdir -p outputs
python3 "$tool" init --name "同程旅行" --code "00780.HK" --period-label "2025年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "港元" --security-name "普通股" --security-unit "股" --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "consolidated" --source "$5" --locator "$6"
}
field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
field_est() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

src23="同程旅行2023年年度报告，2024-04-26"
src24="同程旅行2024年年度报告，2025-04-28"
src25="同程旅行2025年年度报告，2026-04-28"

# 历史损益、现金流与资本开支原始事实（人民币元）。
fact rev23 "收入" 11896244000 2023 "$src23" "PDF P185"
fact cost23 "销售成本" 3158033000 2023 "$src23" "PDF P185"
fact sdev23 "服务开发开支" 1820569000 2023 "$src23" "PDF P185"
fact sm23 "销售及营销开支" 4472815000 2023 "$src23" "PDF P185"
fact admin23 "行政开支" 711194000 2023 "$src23" "PDF P185"
fact impair23 "金融资产减值亏损拨备净额" 17482000 2023 "$src23" "PDF P185"
fact taxexp23 "所得税开支" 288126000 2023 "$src23" "PDF P185"
fact pbt23 "除所得税前溢利" 1853689000 2023 "$src23" "PDF P185"
fact da23 "无形资产摊销及物业、设备、使用权资产折旧" 910716000 2023 "$src23" "PDF P31"
fact ocf23 "经营活动所得现金净额" 4003442000 2023 "$src23" "PDF P30"
fact intrecv23 "已收利息" 173038000 2023 "$src23" "PDF P192"
fact pperoucap23 "购置物业、厂房及设备以及使用权资产" 952122000 2023 "$src23" "PDF P32"
fact intcap23 "购买无形资产及结算长期应付款项" 550971000 2023 "$src23" "PDF P32"
fact leasepay23 "租赁负债付款" 62349000 2023 "$src23" "PDF P193"
fact disposal23 "出售物业、厂房及设备所得款项" 3840000 2023 "$src23" "PDF P192"

fact rev24 "收入" 17340686000 2024 "$src24" "PDF P185"
fact cost24 "销售成本" 6227199000 2024 "$src24" "PDF P185"
fact sdev24 "服务开发开支" 2000894000 2024 "$src24" "PDF P185"
fact sm24 "销售及营销开支" 5620710000 2024 "$src24" "PDF P185"
fact admin24 "行政开支" 1206179000 2024 "$src24" "PDF P185"
fact impair24 "金融资产减值亏损拨回净额" -17791000 2024 "$src24" "PDF P185"
fact taxexp24 "所得税开支" 409560000 2024 "$src24" "PDF P185"
fact pbt24 "除所得税前溢利" 2397826000 2024 "$src24" "PDF P185"
fact da24 "无形资产摊销及物业、设备、使用权资产折旧" 1082586000 2024 "$src24" "PDF P31"
fact ocf24 "经营活动所得现金净额" 2969875000 2024 "$src24" "PDF P30"
fact intrecv24 "已收利息" 180758000 2024 "$src24" "PDF P192"
fact pperoucap24 "购置物业、厂房及设备以及使用权资产" 403157000 2024 "$src24" "PDF P33"
fact intcap24 "购买无形资产及结算长期应付款项" 591082000 2024 "$src24" "PDF P33"
fact leasepay24 "租赁负债付款" 120995000 2024 "$src24" "PDF P193"
fact disposal24 "出售物业、厂房及设备所得款项" 18469000 2024 "$src24" "PDF P192"

fact rev25 "收入" 19395959000 2025 "$src25" "PDF P185"
fact cost25 "销售成本" 6538207000 2025 "$src25" "PDF P185"
fact sdev25 "服务开发开支" 2039051000 2025 "$src25" "PDF P185"
fact sm25 "销售及营销开支" 6281306000 2025 "$src25" "PDF P185"
fact admin25 "行政开支" 1265916000 2025 "$src25" "PDF P185"
fact impair25 "金融资产减值亏损拨备净额" 17101000 2025 "$src25" "PDF P185"
fact taxexp25 "所得税开支" 611898000 2025 "$src25" "PDF P185"
fact pbt25 "除所得税前溢利" 3021000000 2025 "$src25" "PDF P185"
fact da25 "无形资产摊销及物业、设备、使用权资产折旧" 1299198000 2025 "$src25" "PDF P30"
fact ocf25 "经营活动所得现金净额" 4310911000 2025 "$src25" "PDF P30"
fact intrecv25 "已收利息" 148481000 2025 "$src25" "PDF P193"
fact pperoucap25 "购置物业、厂房及设备以及使用权资产" 529650000 2025 "$src25" "PDF P32"
fact intcap25 "购买无形资产及结算长期应付款项" 627610000 2025 "$src25" "PDF P32"
fact leasepay25 "租赁负债付款" 401710000 2025 "$src25" "PDF P194"
fact disposal25 "出售物业、厂房及设备所得款项" 4693000 2025 "$src25" "PDF P193"

# 历史经营字段。EBIT剔除投资公允价值、其他收益/损失及融资项目；经营税按所得税费用乘EBIT/税前利润估计。
for y in 23 24 25; do
  yr="20$y"
  field_expr historical "$yr" revenue "rev$y" reported "合并收益表直接披露。" high
  field_expr historical "$yr" cost_of_revenue "cost$y" reported "合并收益表直接披露。" high
  field_expr historical "$yr" period_operating_expenses "sdev$y + sm$y + admin$y + impair$y" formula "服务开发、销售营销、行政及经营性金融资产减值的合计；剔除投资公允价值、其他收益/损失与融资项目。" high
  field_expr historical "$yr" cash_tax "taxexp$y * (rev$y - cost$y - sdev$y - sm$y - admin$y - impair$y) / pbt$y" formula "以报表所得税费用按重构EBIT相对税前利润调整，近似无融资和非经营收益时的经营现金税。" medium
  field_expr historical "$yr" depreciation_amortization "da$y" reported "管理层现金流桥直接披露无形资产摊销与物业、设备及使用权资产折旧合计。" high
  field_expr historical "$yr" core_business_capex "pperoucap$y + intcap$y + leasepay$y - disposal$y" formula "经营租赁口径：经营性长期资产现金购置及历史应付款结算，加租赁本金并扣资产处置回款。" medium
  field_est historical "$yr" exploratory_business_capex 0 "年报没有识别出可与既有OTA、酒店管理或度假经营可靠分开的新业务长期资产现金投入，基准归零。" low "公司披露可独立归属新产品、新市场或新技术路线的资本化现金投入。"
  field_expr historical "$yr" operating_cash_flow "ocf$y" reported "合并现金流量表直接披露。" high
  field_expr historical "$yr" after_tax_interest_in_operating_cash_flow "-intrecv$y * (1 - (taxexp$y * (rev$y - cost$y - sdev$y - sm$y - admin$y - impair$y) / pbt$y) / (rev$y - cost$y - sdev$y - sm$y - admin$y - impair$y))" formula "经营现金流含已收利息；按估计经营税率扣除税后利息收入，以回到融资前经营现金流。" medium
done

# 为使利润路径与现金流路径完全闭合，将营运资金增加定义为现金转换残差；其中包含无法可靠拆出的股份支付等非现金调整。
field_est historical 2023 operating_working_capital_increase -1497180901.3308058 "由NOPAT+折旧摊销-经营现金流-税后利息调整反推；2023年供应商应付及应计负债增长带来显著资金释放。" medium "现金流附注提供可将股份支付、汇兑及其他非现金项目逐项从营运资金变化剥离的完整对账。"
field_est historical 2024 operating_working_capital_increase 172641860.41188946 "由NOPAT+折旧摊销-经营现金流-税后利息调整反推，代表公司口径现金转换残差。" medium "现金流附注提供可将股份支付、汇兑及其他非现金项目逐项从营运资金变化剥离的完整对账。"
field_est historical 2025 operating_working_capital_increase -298096838.92154926 "由NOPAT+折旧摊销-经营现金流-税后利息调整反推；预付款下降与应付增加部分抵销应收增长。" medium "现金流附注提供可将股份支付、商誉减值及其他非现金项目逐项从营运资金变化剥离的完整对账。"

# 2022-2025经营资产原始事实。OWC采用流动经营项目；长期资产扣除租赁及长期经营负债。
capfacts() {
  local y="$1" src="$2" page="$3"
  shift 3
  local vals=("$@") names=(tr pre inv tp op cl ppe rou intan npre lln llc nop ncl good)
  local labels=("贸易应收款项" "预付款项及其他应收款项" "存货" "贸易应付款项" "其他应付款项及应计费用" "流动合同负债" "物业厂房及设备" "使用权资产" "无形资产" "非流动预付款及其他应收款" "非流动租赁负债" "流动租赁负债" "非流动其他应付款" "非流动合同负债" "商誉账面净值")
  for i in "${!names[@]}"; do fact "${names[$i]}$y" "${labels[$i]}" "${vals[$i]}" "$y" "$src" "$page"; done
}
capfacts 2022 "$src23" "PDF P188-P189、P271-P272" 888475000 2697038000 0 2521790000 3039846000 51420000 1598381000 111329000 8580738000 121488000 88391000 25038000 327446000 37904000 4266711000
capfacts 2023 "$src23" "PDF P188-P189、P271" 1218288000 4369903000 997000 4130982000 4939325000 111184000 2495259000 589251000 9580301000 792970000 420464000 40736000 74636000 32324000 5033510000
capfacts 2024 "$src25" "PDF P188-P190、P281" 1727587000 5450137000 6647000 4467130000 5154002000 274307000 3146926000 909400000 10814078000 475761000 680485000 174191000 948433000 27766000 5233150000
capfacts 2025 "$src25" "PDF P188-P190、P280" 2262971000 5692347000 11628000 4521654000 6026916000 404951000 3380486000 1451415000 12856502000 350971000 1007145000 300141000 372391000 172470000 6197142000

for y in 2022 2023 2024 2025; do
  field_expr capital "$y" operating_working_capital "tr$y + pre$y + inv$y - tp$y - op$y - cl$y" formula "流动经营应收、预付款和存货，扣贸易应付、其他流动应付及合同负债；金融投资与现金另行分类。" medium
  field_expr capital "$y" operating_long_term_assets_net "ppe$y + rou$y + intan$y + npre$y - lln$y - llc$y - nop$y - ncl$y" formula "经营性有形、使用权及无形资产和长期预付款，扣租赁负债与相关长期经营负债。" medium
  field_est capital "$y" required_cash "$([ "$y" = 2022 ] && echo 1200000000 || ([ "$y" = 2023 ] && echo 1500000000 || ([ "$y" = 2024 ] && echo 1800000000 || echo 2000000000)))" "按约1至1.5个月现金经营支出、平台结算规模及备用流动性估计；随业务规模上升。" low "公司披露可自由支配现金、日内结算峰值和最低运营现金的审计口径。"
  field_expr capital "$y" unsupported_intangible_assets "good$y" reported "商誉来自收购溢价，不能直接用当前经营能力解释，按技能规则从投入资本中剔除。" high
done

# 稳定状态：不给尚未证实的新业务额外价值，核心OTA温和增长、度假业务接近盈亏平衡，资本开支回归近年常态。
field_est stable "" revenue 20500000000 "在2025年基础上计入核心OTA低个位数增长及万达酒店全年并表，未外推历史高速增长。" medium "核心OTA收入停止增长、万达并表收入低于预期或度假收入继续显著下滑。"
field_est stable "" cost_of_revenue 6970000000 "按约66%稳定毛利率，接近2025年并表业务结构，保留度假业务较低毛利影响。" medium "酒店管理并表或度假产品采购结构令毛利率持续低于63%。"
field_est stable "" period_operating_expenses 9800000000 "营销维持品牌和流量投入，服务开发及行政费按当前规模常态化；不含投资公允价值和商誉减值。" medium "获客成本明显上升或整合协同使期间费用持续偏离该水平。"
field_est stable "" cash_tax 750000000 "按稳定EBIT约20%的经营税率估计，接近2025年重构税率。" medium "税务优惠终止、递延税逆转或境内外利润组合显著变化。"
field_est stable "" depreciation_amortization 1300000000 "沿用2025年折旧摊销规模，反映收购可识别无形资产与酒店资产的持续消耗。" medium "万达收购购买价分摊或资产使用年限重估导致年度摊销显著改变。"
field_est stable "" core_business_capex 1250000000 "取2024-2025经营性资产现金投入的常态中枢，覆盖平台、酒店及度假现有业务。" medium "酒店建设承诺或技术资本化投入使持续现金资本开支超过16亿元。"
field_est stable "" exploratory_business_capex 0 "未对缺乏独立商业化和资金需求证据的新业务赋值。" low "公司披露独立可验证的新业务投资计划、商业化里程碑和现金预算。"
field_est stable "" operating_working_capital_increase 100000000 "成熟OTA负营运资金结构下仅保留小幅随规模增长的正常占用。" low "供应商账期收紧、预付款或应收增长使长期年占用显著超过3亿元。"

# 最新年度业务：按法定分部拆分，并把未分配经营成本按收入与因果关系分配；成本、费用、税及现金流均闭合公司总量。
fact core_rev25 "核心在线旅游平台收入" 16471477000 2025 "$src25" "PDF P9"
fact tour_rev25 "度假业务收入" 2924482000 2025 "$src25" "PDF P9"
python3 "$tool" add-business --model "$model" --business-id core_ota --name "核心在线旅游平台及酒店管理" --importance "住宿、交通票务、广告、酒店管理和增值服务构成收入与利润主体；微信生态、自有App和供应端连接共同驱动。" --confidence medium --falsifier "公司披露酒店管理与OTA业务存在不可合并的客户、成本或资本占用边界。"
python3 "$tool" add-business --model "$model" --business-id tourism --name "线下旅行社及度假运营" --importance "同程旅业、景区与度假产品采用更重的采购和履约模式，2025年收入下降且分部亏损。" --confidence medium --falsifier "度假分部恢复持续盈利且现金转换显著优于当前估计。"

bus_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
bus_est() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
bus_expr core_ota revenue core_rev25 reported "法定分部收入直接披露。" high
bus_expr tourism revenue tour_rev25 reported "法定分部收入直接披露。" high
bus_est core_ota cost_of_revenue 4088207000 "按核心OTA净额佣金模式、酒店管理履约成本及集团销售成本构成估计。" low "公司披露分部销售成本或净额/总额结构足以直接重算。"
bus_est tourism cost_of_revenue 2450000000 "度假产品较多按总额确认并承担采购履约成本，估计其销售成本率显著高于OTA。" low "公司披露度假分部销售成本或产品采购毛利率。"
bus_est core_ota period_operating_expenses 8560000000 "先以分部收入减分部经营利润得到成本费用，再分配公司未分配经营项目并与合并期间费用闭合。" low "公司披露住宿、交通、酒店管理及未分配经营费用的完整分摊。"
bus_est tourism period_operating_expenses 1043374000 "以度假分部成本费用与集团总量为约束，纳入部分未分配经营项目。" low "公司披露度假分部销售成本和期间费用的完整分摊。"
bus_est core_ota cash_tax 659168285.1519364 "盈利业务承担全部估计经营税；亏损度假业务基准不确认即时税收利益。" low "税务附注披露分部应税利润与可利用亏损。"
bus_est tourism cash_tax 0 "度假业务亏损，基准不确认可即时变现的税收利益。" low "度假分部税务亏损可抵销集团当期应税利润。"
bus_est core_ota operating_cash_flow_contribution 4600000000 "核心OTA盈利和负营运资金模式贡献绝大部分现金流。" low "分部现金流披露显示核心OTA贡献低于集团经营现金流的90%。"
bus_est tourism operating_cash_flow_contribution -289089000 "度假业务亏损且采购、履约更重，基准估计为现金净消耗，使业务合计闭合公司经营现金流。" low "度假业务分部现金流披露为正且持续。"

# 股权价值桥。
fact cash25 "现金及现金等价物" 6505907000 2025 "$src25" "PDF P188"
fact restricted25 "受限制现金" 442389000 2025 "$src25" "PDF P188"
fact ltinvest25 "长期投资合计" 3356315000 2025 "$src25" "PDF P33"
fact stinvest25 "短期投资合计" 5348926000 2025 "$src25" "PDF P34"
fact borrow_n25 "非流动借款" 828307000 2025 "$src25" "PDF P189"
fact borrow_c25 "流动借款" 3271533000 2025 "$src25" "PDF P190"
fact fvliab25 "按公允价值计入损益的金融负债" 200000000 2025 "$src25" "PDF P189"
fact nci25 "非控股权益" 1018186000 2025 "$src25" "PDF P189"
fact shares25 "期末已发行普通股" 2350419839 2025 "$src25" "PDF P305"
fact options25 "期末未行使购股权" 119747133 2025 "$src25" "PDF P260"
fact rsus25 "期末未行使受限制股份单位" 20797468 2025 "$src25" "PDF P260"

field_expr equity "" excess_cash "cash25 - restricted25 - 2000000000" formula "现金扣受限现金及2025年估计经营必需现金；未对集团资金可达性另加折扣。" medium
field_expr equity "" non_operating_assets "ltinvest25 + stinvest25" formula "权益法、金融投资、定期存款和理财产品未进入重构经营利润，作为非经营资产单独计值。" medium
field_expr equity "" financing_debt "borrow_n25 + borrow_c25 + fvliab25" formula "计息借款及融资性质金融负债；租赁已采用经营口径进入资本开支和经营资产，不重复扣除。" high
field_expr equity "" minority_interest_value "nci25" reported "缺少分部独立估值所需现金流，以非控股权益账面值作为保守替代。" low
field_est equity "" other_priority_claims 0 "年报披露无重大或然负债，已宣告股息尚待股东批准，基准不重复扣除日常经营义务。" medium "出现已确定且未进入经营资本或融资负债的重大优先索偿。"
field_expr equity "" diluted_shares "shares25 + options25 + rsus25" formula "保守假设全部未行使购股权与RSU转股，且不计行权所得现金。" medium
field_est equity "" financial_to_trading_fx 1.111 "以2025年末人民币兑港元约1.111的代表汇率换算，仅用于每股价值展示。" medium "香港金管局2025-12-31人民币兑港元日终汇率与该值存在显著差异。"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "缺乏到达稳定期前逐年FCFF和全部成长投入的可靠证据，按技能纪律使用稳定经营收益八倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "2025年商誉减值" --before "其他亏损中确认4.53亿元商誉减值" --after "不进入持续经营EBIT；商誉6.20亿元从投入资本剔除" --reason "商誉是收购溢价且减值为非现金一次性项目；若度假业务持续亏损，影响应通过稳定收益下调而非重复扣减。"
python3 "$tool" add-adjustment --model "$model" --name "现金资本开支口径" --before "公司披露资本开支含25.43亿元长期投资" --after "FCFF仅纳入15.54亿元经营资产现金投入" --reason "金融投资和业务合并不属于日常经营资本开支；经营口径另加租赁本金并扣资产处置回款。"
python3 "$tool" add-adjustment --model "$model" --name "金融投资重分类" --before "长短期投资账面合计87.05亿元" --after "从投入资本剔除并在普通股价值桥单独加回87.05亿元" --reason "相关收益已从EBIT剔除，资产不能留在经营资本中，否则会混淆OTA资本效率。"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "ROIC分母扣除商誉及金融投资，但必需现金和经营负债分类含估计；正文仅用于解释轻资产与负营运资金结构，不作精确护城河结论。"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "重大报表数字、业务分部、资本开支、投资、借款及股数均记录官方年报名称、日期和PDF页码。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "投资收益和融资项目从EBIT剔除；租赁统一采用经营口径；金融投资单列，商誉从投入资本剔除。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定状态同时约束收入、毛利、费用、税、折旧、主营资本开支和营运资金；未对缺乏证据的新业务单独赋值。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心数字将直接引用编译后的结构化模型和程序生成转写表。"

python3 "$tool" compile --model "$model"

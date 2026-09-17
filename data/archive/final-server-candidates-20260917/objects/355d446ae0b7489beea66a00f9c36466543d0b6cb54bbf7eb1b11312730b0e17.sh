#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs

python3 "$tool" init --name 锌业股份 --code 000751.SZ --period-label 2025年年度报告 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope 合并 --source "$5" --locator "$6"
}
field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" ${3:+--year "$3"} --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
field_est() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" ${3:+--year "$3"} --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

src23='葫芦岛锌业股份有限公司2023年年度报告（2024-04-20）'
src24='葫芦岛锌业股份有限公司2024年年度报告（2025-04-25）'
src25='葫芦岛锌业股份有限公司2025年年度报告（2026-04-24）'

# 利润表、现金流量表和折旧摊销附注。
fact rev_2023 营业收入 15666627338.46 2023 "$src23" 'PDF P081'
fact cost_2023 营业成本 15029933328.48 2023 "$src23" 'PDF P081'
fact tax_surcharge_2023 税金及附加 80614994.89 2023 "$src23" 'PDF P082'
fact selling_2023 销售费用 5708308.80 2023 "$src23" 'PDF P082'
fact admin_2023 管理费用 197443451.89 2023 "$src23" 'PDF P082'
fact rd_2023 研发费用 19059877.12 2023 "$src23" 'PDF P082'
fact other_income_2023 其他收益 17952325.12 2023 "$src23" 'PDF P082'
fact income_tax_2023 所得税费用 26664262.72 2023 "$src24" 'PDF P076（2023年比较数）'
fact da_fixed_2023 固定资产折旧 161381643.59 2023 "$src23" 'PDF P199'
fact da_rou_2023 使用权资产折旧 1138059.83 2023 "$src23" 'PDF P199'
fact da_intangible_2023 无形资产摊销 27334227.96 2023 "$src23" 'PDF P199'
fact da_ltd_2023 长期待摊费用摊销 35671.70 2023 "$src23" 'PDF P199'
fact capex_2023 购建固定资产无形资产和其他长期资产支付的现金 185636418.84 2023 "$src23" 'PDF P085'
fact ocf_2023 经营活动产生的现金流量净额 -288562851.58 2023 "$src23" 'PDF P085'

fact rev_2024 营业收入_追溯调整后 15602690832.17 2024 "$src25" 'PDF P071；2024年比较数经解释18追溯调整'
fact cost_2024 营业成本 15081049305.03 2024 "$src24" 'PDF P075'
fact tax_surcharge_2024 税金及附加 81342214.16 2024 "$src24" 'PDF P076'
fact selling_2024 销售费用 6204158.09 2024 "$src24" 'PDF P076'
fact admin_2024 管理费用 192125039.99 2024 "$src24" 'PDF P076'
fact rd_2024 研发费用 12470935.88 2024 "$src24" 'PDF P076'
fact other_income_2024 其他收益 20795944.17 2024 "$src24" 'PDF P076'
fact income_tax_2024 所得税费用 3022566.16 2024 "$src24" 'PDF P076'
fact da_fixed_2024 固定资产折旧 152927110.46 2024 "$src24" 'PDF P189'
fact da_rou_2024 使用权资产折旧 1213147.24 2024 "$src24" 'PDF P189'
fact da_intangible_2024 无形资产摊销 27334227.96 2024 "$src24" 'PDF P189'
fact da_ltd_2024 长期待摊费用摊销 92746.41 2024 "$src24" 'PDF P189'
fact capex_2024 购建固定资产无形资产和其他长期资产支付的现金 175560835.17 2024 "$src24" 'PDF P079'
fact ocf_2024 经营活动产生的现金流量净额 -527631298.38 2024 "$src24" 'PDF P079'

fact rev_2025 营业收入 18529131568.47 2025 "$src25" 'PDF P071'
fact cost_2025 营业成本 17934701164.68 2025 "$src25" 'PDF P071'
fact tax_surcharge_2025 税金及附加 88745732.98 2025 "$src25" 'PDF P072'
fact selling_2025 销售费用 6065503.17 2025 "$src25" 'PDF P072'
fact admin_2025 管理费用 184084864.59 2025 "$src25" 'PDF P072'
fact rd_2025 研发费用 7727205.86 2025 "$src25" 'PDF P072'
fact other_income_2025 其他收益 40224796.45 2025 "$src25" 'PDF P072'
fact income_tax_2025 所得税费用 1852118.05 2025 "$src25" 'PDF P073、P169'
fact da_fixed_2025 固定资产折旧 117506703.57 2025 "$src25" 'PDF P171'
fact da_rou_2025 使用权资产折旧 1188333.47 2025 "$src25" 'PDF P171'
fact da_intangible_2025 无形资产摊销 26744132.05 2025 "$src25" 'PDF P171'
fact capex_2025 购建固定资产无形资产和其他长期资产支付的现金 295035663.76 2025 "$src25" 'PDF P075'
fact ocf_2025 经营活动产生的现金流量净额 174519308.45 2025 "$src25" 'PDF P075'

for year in 2023 2024 2025; do
  field_expr historical revenue "$year" "rev_$year" reported '采用合并利润表营业收入；2024采用最新年报追溯调整后的比较数。' high
  field_expr historical cost_of_revenue "$year" "cost_$year" reported '采用合并利润表营业成本。' high
  field_expr historical period_operating_expenses "$year" "tax_surcharge_$year + selling_$year + admin_$year + rd_$year - other_income_$year" formula '经营费用包括税金及附加、销售、管理和研发费用，并以持续性政府补助性质的其他收益抵减；排除财务费用、投资、公允价值及减值。' medium
  field_expr historical cash_tax "$year" "income_tax_$year" reported '以所得税费用作为可核验起点；税损和资源综合利用优惠使实际税率较低。' medium
  if [[ "$year" == 2025 ]]; then
    field_expr historical depreciation_amortization "$year" "da_fixed_$year + da_rou_$year + da_intangible_$year" formula '合计现金流量表补充资料中的经营性折旧和摊销。' high
  else
    field_expr historical depreciation_amortization "$year" "da_fixed_$year + da_rou_$year + da_intangible_$year + da_ltd_$year" formula '合计现金流量表补充资料中的经营性折旧和摊销。' high
  fi
  field_expr historical core_business_capex "$year" "capex_$year" reported '公司未披露独立新业务建设；购建长期经营资产现金支出全部归入现有冶炼主业的检修、环保、技改和扩能。' medium
  field_est historical exploratory_business_capex "$year" 0 '年报未识别出具备独立产品、市场和商业化路径的开拓性项目。' medium '若后续披露可独立核验的新业务项目现金投入，则需从主业资本开支中重分类。'
  field_est historical operating_working_capital_increase "$year" "$([[ "$year" == 2023 ]] && echo 803607894.34 || ([[ "$year" == 2024 ]] && echo 956471087.48 || echo 317099636.23))" '以NOPAT、折旧摊销与经营现金流的利润—现金差额反推，覆盖存货、经营应收应付以及未单列的经营性现金调整，使FCFF与现金流量表路径闭合。' medium '若公司披露按经营/融资性质拆分的完整营运资金现金变动，则以该明细替代残差法。'
  field_expr historical operating_cash_flow "$year" "ocf_$year" reported '采用合并现金流量表经营活动现金流量净额。' high
  field_est historical after_tax_interest_in_operating_cash_flow "$year" 0 '中国准则现金流量表将偿付利息列在筹资活动；经营现金流无需加回税后利息。' high '若现金流量表口径变化并把利息支付列入经营活动，则需按税后金额加回。'
done

# 资本占用：营运资金按经营应收、存货和预付款等减票据/应付/合同负债等；长期资产扣递延收益。
for row in \
  '2022 2320051752.55 2769062794.60' \
  '2023 2294228012.88 2760197586.13' \
  '2024 3050266179.32 2740705851.74' \
  '2025 3565813184.98 2909983554.92'; do
  read -r year owc lta <<<"$row"
  source="$src25"; locator='PDF P067-P069及相关附注'
  [[ "$year" == 2022 || "$year" == 2023 ]] && source="$src23" && locator='PDF P077-P079及相关附注'
  [[ "$year" == 2024 ]] && source="$src25" && locator='PDF P067-P069的追溯调整后比较数'
  field_est capital operating_working_capital "$year" "$owc" '经营性流动资产（应收、应收款项融资、预付、存货等）减票据及经营性应付、合同负债和税费等；不含现金、衍生品、短期借款及其他融资负债。' medium '若票据或其他应付款附注明确显示更多融资性质或非经营性质，需重新分类。'
  field_est capital operating_long_term_assets_net "$year" "$lta" '固定资产、在建工程、使用权资产、经营性无形资产及其他经营长期资产，扣除与资产相关的递延收益；排除投资性房地产和金融投资。' medium '若土地或其他长期资产证实不再服务冶炼主业，应移至非经营资产。'
  field_est capital required_cash "$year" 300000000 '按约6天营业成本和日常结算缓冲估计最低经营现金；公司另有大量保证金和冻结资金，不能视为可自由使用现金。' low '若月度付款峰值、授信备用额度或最低保证金要求显示现金缓冲明显不同，应调整。'
  field_est capital unsupported_intangible_assets "$year" 0 '无商誉；账面无形资产主要为持续服务生产基地的土地使用权，暂不剔除。' medium '若土地闲置、权属受限或不再服务主业，应剔除并单独估值。'
done

# 稳定期：不把2025金属价格带来的收入增长直接外推，采用三年中枢毛利率和常态资本开支。
field_est stable revenue '' 16600000000 '取2023—2025收入区间的中枢，避免把2025铜价/销量放大的185亿元收入机械年化。' medium '若连续两年正常销量和金属价格支持更高或更低收入平台，则重估。'
field_est stable cost_of_revenue '' 16019000000 '对应3.5%稳定毛利率，介于2023的4.1%与2024—2025的3.2%—3.3%。' medium '若锌铜加工费或硫酸、贵金属副产品价格持续改变综合毛利率，则重估。'
field_est stable period_operating_expenses '' 270000000 '取三年重构期间经营费用约2.46—2.85亿元的中枢。' medium '若费用结构连续两年偏离中枢，应采用新常态。'
field_est stable cash_tax '' 46650000 '按稳定EBIT 3.11亿元的15%估计，既反映资源综合利用优惠，也不永久外推接近零的当期税负。' medium '若可抵扣亏损耗尽或税收优惠取消，税率应上调；反之有长期优惠证据可下调。'
field_est stable depreciation_amortization '' 170000000 '取三年折旧摊销约1.45—1.90亿元的中枢。' medium '若2025新增固定资产投产后折旧明显改变，则更新。'
field_est stable core_business_capex '' 200000000 '参考三年现金资本开支1.76、1.86、2.95亿元，取接近历史中位数且略含环保技改余量的2亿元。' medium '若在建工程转为持续高额现金投入或管理层披露维护资本开支，则更新。'
field_est stable exploratory_business_capex '' 0 '基准估值不为缺少独立商业化证据的新业务投入赋值。' medium '若出现具名新业务、阶段性验证和完整资金计划，则另建成长路径。'
field_est stable operating_working_capital_increase '' 0 '稳定状态假设销量不再扩张，营运资金存量保持不变。' medium '若结构性库存安全水平或客户账期继续上升，应计入持续占用。'

# 最新年度六项具名产品业务，直接披露收入成本；费用、税和经营现金流按可解释基准分配并闭合。
for row in \
  'zinc 锌及锌合金 5621732714.54 5671306282.24 0 0 -24991479.463693' \
  'copper 阴极铜 8393971187.71 8536205686.16 0 0 -71704553.695896' \
  'lead 精铅 318809566.62 252450691.16 20796143.503155 156319.584600 22890695.081462' \
  'acid 硫酸 376895961.22 142638447.63 73413734.568882 551833.299764 80807838.845348' \
  'trade 有色金属贸易 437217778.97 430765418.59 2022098.950086 15199.629097 2225761.256357' \
  'recovery 贵金属及综合回收产品 3380504359.41 2901334638.90 150166533.127876 1128765.536540 165291046.426421'; do
  read -r id name rev cost expense tax ocf <<<"$row"
  python3 "$tool" add-business --model "$model" --business-id "$id" --name "$name" --importance '按产品需求、定价和副产品经济性拆分；收入成本来自2025年报P013-P015。' --confidence medium --falsifier '若公司披露产品级费用、税与现金流，则替代当前分配。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field revenue --value "$rev" --basis-type estimate --reason '2025年报P013-P015直接披露的产品收入；贵金属及综合回收产品对应财报“其他产品”的经济命名。' --confidence high --falsifier '若公司更正产品分类披露，则按更正数调整。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field cost_of_revenue --value "$cost" --basis-type estimate --reason '2025年报P014-P015直接披露的产品营业成本。' --confidence high --falsifier '若公司更正产品分类披露，则按更正数调整。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field period_operating_expenses --value "$expense" --basis-type estimate --reason '公司未披露产品级期间费用；对正毛利业务按毛利贡献分配，负毛利业务不再机械叠加共同费用。' --confidence low --falsifier '产品级销售、管理、研发或共享服务成本披露会推翻此分配。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field cash_tax --value "$tax" --basis-type estimate --reason '公司未披露产品级税负；与期间费用采用相同的正毛利贡献权重，合计闭合公司经营现金税。' --confidence low --falsifier '分产品税收优惠或纳税主体利润披露会推翻此分配。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field operating_cash_flow_contribution --value "$ocf" --basis-type estimate --reason '按产品NOPAT同比例缩放至公司经营现金流，保留锌、铜负毛利对现金的负贡献并闭合公司总量。' --confidence low --falsifier '产品级营运资金、折旧或经营现金流披露会推翻此分配。'
done

# 普通股价值桥。
field_est equity excess_cash '' 101306064.24 '2025年末货币资金14.736亿元，扣经营必需现金3亿元、冻结资金6.189亿元及保证金4.534亿元；仅余约1.013亿元视为可分配。' medium '若冻结资金解冻且证实归公司、保证金释放或最低经营现金改变，则重估。'
field_est equity non_operating_assets '' 41935000 '按投资性房地产0.412亿元、其他非流动金融资产及长期应收款约0.008亿元账面值计入；未给停产联营投资价值。' medium '若取得独立评估、处置回款或税费信息，则按可实现净额替代。'
field_est equity financing_debt '' 3695316770.30 '短期借款33.589亿元、其他应付款中对实际控制人控制企业的有息借款1.863亿元、长期应付款1.5亿元及一年内到期租赁负债约18万元；票据及经营应付已进入营运资金，避免重复扣除。' high '若供应商融资进一步从经营票据/应付重分类为借款，应增加融资负债并同步调整营运资金。'
field_est equity minority_interest_value '' 0 '合并资产负债表无少数股东权益，主要子公司为全资。' high '若后续引入子公司少数股东，则按其经济价值扣除。'
field_est equity other_priority_claims '' 0 '已识别融资债务和受限现金分别处理；未发现优先股、永续债或已宣告未付股息。' medium '若冻结资金对应未入账义务、重大资本承诺变为不可撤销付款，需增加优先索偿。'
field_expr equity diluted_shares '' shares_2025 reported '年末总股本，且无股份支付或可转换证券。' high
fact shares_2025 期末总股本 1615630595 2025 "$src25" 'PDF P002、P069'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '锌铜加工费、硫酸及贵金属副产品价格周期性强，缺少到达稳定状态前逐年FCFF证据，按技能纪律采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '2024收入追溯调整' --before '156.044亿元' --after '156.027亿元' --reason '2025年报执行企业会计准则解释第18号，对2024年营业收入比较数追溯调整；历史表采用最新口径。'
python3 "$tool" add-adjustment --model "$model" --name '受限及代收资金不计多余现金' --before '货币资金14.736亿元' --after '多余现金1.013亿元' --reason '扣除经营必需现金3亿元、冻结资金6.189亿元和票据/信用证/期货保证金4.534亿元；冻结款中主要为香港子公司代收且受政府工作事项控制。'

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '平均投入资本约54—64亿元，分母为正且主要由存货和有形冶炼资产构成；ROIC可解释为低个位数资本回报，但经营必需现金和部分负债分类仍为估计。'
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '历史总量均链接至三年法定年报的具体PDF页；估计字段记录依据、置信度和推翻条件。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '融资负债、经营票据应付、受限现金、投资性房地产和经营土地分别分类，价值桥避免重复计入。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定收入、毛利率、费用、税、折旧、资本开支和营运资金假设相互一致，并未直接外推2025价格驱动的收入高点。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '正文的历史FCFF、稳定经营收益、债务、受限现金及估值结论均以结构化模型为唯一数字底稿。'

python3 "$tool" compile --model "$model"

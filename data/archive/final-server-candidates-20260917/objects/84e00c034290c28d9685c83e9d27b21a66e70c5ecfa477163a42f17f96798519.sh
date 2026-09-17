#!/usr/bin/env bash
set -euo pipefail

MODEL=outputs/analysis.json
TOOL=.agents/skills/stock-research/scripts/stock_research.py
S23='华友钴业2023年年度报告（2024-04-20）'
S24='华友钴业2024年年度报告（2025-04-19）'
S25='华友钴业2025年年度报告（2026-04-08）'
U23='https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2024-04-20/603799_20240420_AQ6K.pdf'
U24='https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2025-04-19/603799_20250419_83HR.pdf'
U25='https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2026-04-08/603799_20260408_DWYT.pdf'

python3 "$TOOL" init --name 华友钴业 --code 603799.SH --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency CNY --trading-currency CNY --security-name A股 --security-unit 股 --output "$MODEL"

fact() { python3 "$TOOL" add-fact --model "$MODEL" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope consolidated --source "$5" --locator "$6"; }
field_expr() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
field_est() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }

# Profit, cash-flow and capex facts. Amounts retain the annual-report unit (CNY yuan).
for row in \
  '2023 rev 66304047529.81 营业收入 P110' '2023 cost 56948773263.76 营业成本 P110' '2023 op 4815214344.32 营业利润 P111' '2023 fin 1478166059.86 财务费用 P110' '2023 invinc 857352477.88 投资收益 P110-P111' '2023 fv 218765480.50 公允价值变动收益 P111' '2023 dafa 2840285201.51 固定资产折旧 P218' '2023 darou 63641583.96 使用权资产折旧 P218' '2023 daint 413584977.96 无形资产摊销 P218' '2023 dalt 19632202.53 长期待摊费用摊销 P218' '2023 ocf 3485888093.33 经营活动现金流量净额 P114' '2023 interest 1960858477.63 利息费用 P110' '2023 capex 16849177920.23 购建长期资产支付的现金 P114' \
  '2024 rev 60945563720.14 营业收入 P111' '2024 cost 50445676975.22 营业成本 P111' '2024 op 5658546199.83 营业利润 P112' '2024 fin 2069820526.37 财务费用 P111' '2024 invinc 1361818568.31 投资收益 P111' '2024 fv -61513862.54 公允价值变动收益 P112' '2024 dafa 4075458662.22 固定资产及使用权资产折旧 P221' '2024 daint 490590281.80 无形资产摊销 P221' '2024 dalt 13232183.96 长期待摊费用摊销 P221' '2024 ocf 12431110882.70 经营活动现金流量净额 P115' '2024 interest 2512552872.16 利息费用 P111' '2024 capex 6721574787.22 购建长期资产支付的现金 P115' \
  '2025 rev 81018674069.68 营业收入 P92' '2025 cost 66865106789.80 营业成本 P92' '2025 op 8383595897.06 营业利润 P93' '2025 fin 2399184377.14 财务费用 P92' '2025 invinc 934113030.42 投资收益 P93' '2025 fv 12453980.86 公允价值变动收益 P93' '2025 dafa 4529901507.60 固定资产及使用权资产折旧 P203' '2025 daint 471296255.36 无形资产摊销 P203' '2025 dalt 12241718.54 长期待摊费用摊销 P203' '2025 ocf 4011961997.48 经营活动现金流量净额 P97' '2025 interest 2271478731.52 利息费用 P92' '2025 capex 10757625082.43 购建长期资产支付的现金 P97'; do
  read -r y id amount item page <<<"$row"
  case "$y" in 2023) src="$S23"; url="$U23";; 2024) src="$S24"; url="$U24";; 2025) src="$S25"; url="$U25";; esac
  fact "${id}_${y}" "$item" "$amount" "$y" "$src；$url" "$page"
done

# Historical operating model. EBIT = reported operating profit + finance expense - investment income - fair-value gain.
for y in 2023 2024 2025; do
  field_expr historical "$y" revenue "rev_$y" reported '合并利润表营业收入。' high
  field_expr historical "$y" cost_of_revenue "cost_$y" reported '合并利润表营业成本。' high
  field_expr historical "$y" period_operating_expenses "rev_$y-cost_$y-(op_$y+fin_$y-invinc_$y-fv_$y)" formula '以营业利润加回融资费用并剔除投资收益与金融公允价值变动重构EBIT，期间经营费用为毛利减EBIT；保留经营补助、减值与处置影响。' medium
  field_expr historical "$y" depreciation_amortization "dafa_$y+daint_$y+dalt_$y${y/2023/+darou_2023}" formula '现金流量表补充资料中的经营性折旧摊销合计。' high
  field_expr historical "$y" operating_cash_flow "ocf_$y" reported '合并现金流量表经营活动现金流量净额。' high
done

# Override the accidental parameter substitution on 2024/2025 D&A and record cash-tax/cash-flow bridge estimates.
field_expr historical 2024 depreciation_amortization 'dafa_2024+daint_2024+dalt_2024' formula '现金流量表补充资料中的经营性折旧摊销合计。' high
field_expr historical 2025 depreciation_amortization 'dafa_2025+daint_2025+dalt_2025' formula '现金流量表补充资料中的经营性折旧摊销合计。' high

field_est historical 2023 cash_tax 293838847.405 '以报告利润总额对应实际所得税率作用于重构EBIT，作为经营现金税基准。' medium '若分地区税务附注明确利息税盾、权益法投资税和递延税拆分，应改用拆分后的经营现金税。'
field_est historical 2024 cash_tax 490532489.925 '以报告利润总额对应实际所得税率作用于重构EBIT，作为经营现金税基准。' medium '若分地区税务附注明确利息税盾、权益法投资税和递延税拆分，应改用拆分后的经营现金税。'
field_est historical 2025 cash_tax 955912713.530 '以报告利润总额对应实际所得税率作用于重构EBIT，作为经营现金税基准。' medium '若分地区税务附注明确利息税盾、权益法投资税和递延税拆分，应改用拆分后的经营现金税。'

field_est historical 2023 after_tax_interest_in_operating_cash_flow 1850420967.311 '利息费用按当年有效税率税后化；中国现金流量表将付息列筹资活动，因此在OCF路径加回。' medium '若公司披露实际付息及其现金流分类和税盾，应按实际现金利息替换。'
field_est historical 2024 after_tax_interest_in_operating_cash_flow 2320817449.933 '利息费用按当年有效税率税后化；中国现金流量表将付息列筹资活动，因此在OCF路径加回。' medium '若公司披露实际付息及其现金流分类和税盾，应按实际现金利息替换。'
field_est historical 2025 after_tax_interest_in_operating_cash_flow 2050729613.955 '利息费用按当年有效税率税后化；中国现金流量表将付息列筹资活动，因此在OCF路径加回。' medium '若公司披露实际付息及其现金流分类和税盾，应按实际现金利息替换。'

field_est historical 2023 operating_working_capital_increase 2924212503.024 '用NOPAT、折旧摊销、经营现金流和税后利息残差得到经营营运资金及其他经营应计占用，确保利润与现金流路径闭合。' medium '若现金流补充资料可完整剔除汇兑、减值、投资损益和经营资产处置，应改用逐项重构值。'
field_est historical 2024 operating_working_capital_increase -4235109168.377 '用NOPAT、折旧摊销、经营现金流和税后利息残差得到经营营运资金及其他经营应计释放。' medium '若现金流补充资料可完整剔除汇兑、减值、投资损益和经营资产处置，应改用逐项重构值。'
field_est historical 2025 operating_working_capital_increase 7831048419.455 '用NOPAT、折旧摊销、经营现金流和税后利息残差得到经营营运资金及其他经营应计占用。' medium '若现金流补充资料可完整剔除汇兑、减值、投资损益和经营资产处置，应改用逐项重构值。'

field_est historical 2023 core_business_capex 16000000000 '2023年大部分建设服务于既有镍钴锂资源、冶炼和材料产能；以总资本开支扣除谨慎估计的开拓性部分。' low '若项目付款明细显示更多支出对应未商业化技术或全新市场，应提高开拓性比例。'
field_est historical 2023 exploratory_business_capex 849177920.23 '将总资本开支约5%归于新区域首期产线及尚未稳定商业化技术选项。' low '若项目投产、客户认证与独立现金流证实其已属成熟主业，应重分类为主营资本开支。'
field_est historical 2024 core_business_capex 6200000000 '绝大部分建设延续既有一体化产能与配套设施。' low '若项目付款明细显示更多支出对应未商业化技术或全新市场，应提高开拓性比例。'
field_est historical 2024 exploratory_business_capex 521574787.22 '将总资本开支约8%归于欧洲首期正极材料及新体系早期投入。' low '若相关产线已稳定量产并取得正常回报，应重分类为主营资本开支。'
field_est historical 2025 core_business_capex 9800000000 'Pomalaa、华星及既有材料扩建属于已有资源与材料业务的继续扩产，计入主营资本开支。' low '若现金付款项目明细证明部分资金专用于尚未商业化的新业务，应转列开拓性资本开支。'
field_est historical 2025 exploratory_business_capex 957625082.43 '对匈牙利首期调试、固态/钠电等早期商业化配套给予约9%的开拓性资本开支基准估计。' low '若项目资本台账显示这些支出已服务成熟产品，或早期项目占比更高，应据实重分类。'

# Capital stock facts, 2022-2025. OWC uses operating receivables/inventory/prepayments less non-interest operating payables.
declare -A SRC URL PAGE
SRC[2022]="$S23"; URL[2022]="$U23"; PAGE[2022]='P106-P108（2022比较数）'
SRC[2023]="$S24"; URL[2023]="$U24"; PAGE[2023]='P107-P109（2023比较数）'
SRC[2024]="$S25"; URL[2024]="$U25"; PAGE[2024]='P88-P90（2024比较数）'
SRC[2025]="$S25"; URL[2025]="$U25"; PAGE[2025]='P88-P90'

add_cap_facts() {
  local y=$1 vals=$2; read -ra a <<<"$vals"
  local names=(ar arf pre otherrec inv oca notes ap contract employee taxpay otherpay ocl advance fa cip rou intang goodwill ltd onca grant)
  for i in "${!names[@]}"; do fact "${names[$i]}_$y" "${names[$i]}" "${a[$i]}" "$y-12-31" "${SRC[$y]}；${URL[$y]}" "${PAGE[$y]}"; done
}
add_cap_facts 2022 '8036948469.35 2437994963.68 1634719864 580628313.49 17692022676.5 2891137816.94 10782231308.54 14610891201.3 2359463860.52 685740642.95 542406489.43 4612710195.77 1546983360.95 492117670.03 26217069544.01 14281929827.36 122205035.22 4066801265.8 458415919.67 79311504.95 5994992788.87 592727660.93'
add_cap_facts 2023 '7977267961.62 2425306902.49 1810825646.66 392878676.92 15763401257.63 3733610807.82 8019127039.81 12002517679 431037852.87 648208600.82 429374847.76 2698990402.87 1433223782.84 0 46339084007.03 10819557175.49 106133724.12 3914395969.88 456351378.26 69864652.46 3851581151.15 666550531.96'
add_cap_facts 2024 '6802217530.22 1428306241.20 2950454862.65 274707951.55 17296771331.50 4512122865.97 4209819518.55 12041543179.65 867721977.01 701787373.59 623927519.98 1805454346.03 2338401435.83 0 51098211511.40 9902246502.50 58138602.83 4918247132.08 597655163.70 58106612.25 2259180048.30 714907735.45'
add_cap_facts 2025 '9342046846.38 1647571042.81 5906325334.63 420695664.15 25624157550.87 6004282129.30 7196242617.28 18208994873.11 1274805334.45 781246476.16 1110349313.42 1241610600.62 4120599011.83 852479726.74 53416454130.68 12998862681.11 44703312.68 4573099491.95 595590622.29 47715159.84 4947488551.75 772174047.21'

for y in 2022 2023 2024 2025; do
  field_expr capital "$y" operating_working_capital "ar_$y+arf_$y+pre_$y+otherrec_$y+inv_$y+oca_$y-notes_$y-ap_$y-contract_$y-employee_$y-taxpay_$y-otherpay_$y-ocl_$y-advance_$y" formula '经营应收、存货、预付及其他经营流动资产扣除无息经营负债。' medium
  field_expr capital "$y" operating_long_term_assets_net "fa_$y+cip_$y+rou_$y+intang_$y+goodwill_$y+ltd_$y+onca_$y-grant_$y" formula '固定资产、在建工程、使用权资产、无形资产、长期待摊及经营性其他非流动资产，扣除递延收益；商誉先纳入再在下一行剔除。' medium
  field_expr capital "$y" unsupported_intangible_assets "goodwill_$y" reported '商誉不能由独立可核验收益解释，全部从投入资本剔除。' high
done
field_est capital 2022 required_cash 5000000000 '约一个月现金经营支出的流动性缓冲。' low '若集团现金池、受限资金和月度付款峰值资料显示最低现金需求不同，应重估。'
field_est capital 2023 required_cash 5500000000 '约一个月现金经营支出的流动性缓冲。' low '若集团现金池、受限资金和月度付款峰值资料显示最低现金需求不同，应重估。'
field_est capital 2024 required_cash 5000000000 '约一个月现金经营支出的流动性缓冲。' low '若集团现金池、受限资金和月度付款峰值资料显示最低现金需求不同，应重估。'
field_est capital 2025 required_cash 6000000000 '考虑业务规模上升及跨境采购，以约一个月现金经营支出作为流动性缓冲。' low '若集团现金池、受限资金和月度付款峰值资料显示最低现金需求不同，应重估。'

# Stable benchmark: no company-specific growth DCF because construction timing, prices and required funding are not sufficiently evidenced.
field_est stable '' revenue 80000000000 '以2025年收入附近作为正常销量与金属价格组合，不机械外推32.9%的当年增速。' medium '若主要金属中周期价格、已签长单执行量或新增产能利用率使可持续收入偏离10%以上，应重估。'
field_est stable '' cost_of_revenue 66000000000 '采用17.5%常态毛利率，介于2024-2025并避免把钴价与镍供需单年改善完全外推。' medium '若连续两年一体化毛利率低于15%或高于20%，应更新。'
field_est stable '' period_operating_expenses 4500000000 '按近年约40-43亿元经营费用并留出规模化组织成本。' medium '若费用率或经营补助/减值的常态水平显著变化，应更新。'
field_est stable '' cash_tax 950000000 '按约10%的跨区域正常经营现金税率作用于95亿元EBIT。' low '若海外项目税收优惠到期或司法辖区利润分布改变，应更新。'
field_est stable '' depreciation_amortization 5000000000 '接近2025年折旧摊销，反映现有资产基座。' medium '若新投产项目使年度折旧摊销持续偏离10%以上，应更新。'
field_est stable '' core_business_capex 5500000000 '稳定期资本开支略高于折旧摊销，覆盖矿冶与材料产线持续环保、安全、技改和更新。' low '若成熟产能长期维持投入明显高于折旧或资产寿命资料支持更低投入，应重估。'
field_est stable '' exploratory_business_capex 0 '稳定经营收益不为尚未验证的新技术和新区域选项赋值。' medium '若项目形成可验证稳定现金流，应纳入主营业务稳定参数。'
field_est stable '' operating_working_capital_increase 500000000 '稳定状态保留少量持续增长和跨境库存占用。' low '若收入不增长时营运资本仍持续大幅增加或释放，应据转换周期更新。'

# 2025 named business tree. Disclosed industry rows are scaled to consolidated totals; shared expenses/tax/OCF follow gross-profit/NOPAT shares.
for spec in 'battery 新能源电池材料及原料 下游正极材料和中游原料转换，客户为电池及正极材料企业；直销、金属价格加技术/加工费定价。' 'metals 能源金属与资源开发 镍钴锂铜采选冶及中间品，公开金属价格挂钩；资本占用和利润贡献最大。' 'trade 贸易及综合服务 贸易、循环回收及配套服务，低毛利且回款节奏驱动现金贡献。'; do
  read -r id name importance <<<"$spec"; python3 "$TOOL" add-business --model "$MODEL" --business-id "$id" --name "$name" --importance "$importance" --confidence medium --falsifier '若公司披露消除内部交易后的新能源、新材料、资源和循环独立分部损益，应以该披露重构。'
done
biz_est() { python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
for row in \
 'battery revenue 40242643758.92281' 'battery cost_of_revenue 33584923659.02904' 'battery period_operating_expenses 2030847350.966587' 'battery cash_tax 449653374.3589906' 'battery operating_cash_flow_contribution 1887193489.9834695' \
 'metals revenue 31804720423.367374' 'metals cost_of_revenue 24708907969.638042' 'metals period_operating_expenses 2164481490.419199' 'metals cash_tax 479241537.0073687' 'metals operating_cash_flow_contribution 2011374895.2941546' \
 'trade revenue 8971309887.3898' 'trade cost_of_revenue 8571275161.132913' 'trade period_operating_expenses 122025175.57420357' 'trade cash_tax 27017802.163995177' 'trade operating_cash_flow_contribution 113393612.20237558'; do
  read -r id key val <<<"$row"
  biz_est "$id" "$key" "$val" '以年报P16分行业收入成本为锚，按对应占比吸收未进入主营业务表的营业收入/成本；共享经营费用按毛利分摊，经营税按EBIT分摊，经营现金流按NOPAT分摊并闭合合并总量。' low '若公司披露消除内部交易后的业务费用、税和现金流，应替换本分配估计。'
done

# Equity bridge facts and fields.
for row in \
 'cash25 17625647271.67 货币资金 P88' 'casheq25 11229352870.58 现金及现金等价物 P193' 'trading25 80000000 交易性金融资产 P88' 'lti25 11924720105.31 长期股权投资 P88' 'oei25 393906682.81 其他权益工具投资 P88' 'onfi25 6573600 其他非流动金融资产 P88' \
 'short25 25049841189.68 短期借款 P89' 'currentdebt25 11522509636.99 一年内到期的非流动负债 P89' 'long25 18054618081.94 长期借款 P89' 'bond25 500920684.94 应付债券 P89' 'lease25 28930679.17 租赁负债 P89' 'ltpay25 4145263634.65 长期应付款 P89及P170' 'minority25 12525302229.19 少数股东权益 P90' 'shares25 1896724497 股本 P90'; do
  read -r id amount item page <<<"$row"; fact "$id" "$item" "$amount" '2025-12-31' "$S25；$U25" "$page"
done
field_est equity '' excess_cash 5229352870.58 '以现金及现金等价物112.29亿元扣除60亿元经营必需现金；账面货币资金中63.96亿元保证金及冻结款不按可分配现金计值。' low '若项目承诺、印尼留存法规或现金池最低需求超过已估计经营现金，应下调。'
field_expr equity '' non_operating_assets 'trading25+lti25+oei25+onfi25' formula '剔除自营经营收益之外的交易性金融资产、长期股权投资及独立权益工具；按账面值计，未给未验证溢价。' medium
field_expr equity '' financing_debt 'short25+currentdebt25+long25+bond25+lease25+ltpay25' formula '计息借款、债券、租赁及售后回租等融资性长期应付款；经营应付款不重复扣除。' high
field_est equity '' minority_interest_value 12525302229.19 '缺少各并表子公司独立FCFF，暂以少数股东账面权益作为经济价值替代。' low '若取得主要印尼项目及其他子公司的独立估值、债务和现金，应改用穿透经济价值。'
field_est equity '' other_priority_claims 0 '未识别到未在融资债务、营运资金或资本开支中处理的重大普通股前置索偿。' medium '若出现已承诺未支付的大额项目款、税务追索或优先证券，应纳入。'
field_expr equity '' diluted_shares 'shares25' reported '期末股本；可转债在2025年已大部分转股，现有限制性股票已包含于股本。' medium
field_est equity '' financial_to_trading_fx 1 '财报和交易币种均为人民币。' high '交易币种发生变化时更新。'

python3 "$TOOL" set-valuation --model "$MODEL" --mode benchmark --reason '公司仍在多项目建设期，镍钴锂价格与产能爬坡对逐年FCFF影响大，尚不足以可靠确定到达稳定状态的时间与全部成长投入，故采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$TOOL" add-adjustment --model "$MODEL" --name '投资收益与联营资产' --before '2025年投资收益9.34亿元包含于财报营业利润' --after 'EBIT剔除；长期股权投资119.25亿元作为非经营资产加入价值桥' --reason '保持经营收益与资产计值边界一致，避免权益法收益与投资资产双计。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '商誉' --before '2025年账面5.96亿元' --after '从投入资本剔除且不单独赋值' --reason '无法从独立披露的持续收益解释并购溢价；经营能力只由稳定经营收益反推。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '货币资金可达性' --before '账面货币资金176.26亿元' --after '现金等价物112.29亿元减经营必需现金60亿元，多余现金52.29亿元' --reason '63.96亿元主要为承兑、信用证、借款等保证金及诉讼冻结款，不能视作可立即分配给普通股。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '少数股东索偿' --before '合并FCFF包含并表子公司100%现金流' --after '暂扣2025年少数股东账面权益125.25亿元' --reason '缺少主要海外项目穿透估值，账面权益是低可信替代值，防止把非归母现金流全额归给普通股。'

for item in source_traceability economic_classification stable_state report_consistency capital_return_interpretability; do
  case "$item" in
    source_traceability) reason='原始金额保留披露名、期间、币种、合并范围、公开文件与PDF页码。';;
    economic_classification) reason='投资收益及金融公允价值剔出EBIT，计息负债与经营应付款分开，业务树互斥并闭合公司总量。';;
    stable_state) reason='稳定参数综合三年经营、2025业务结构和建设状态，不机械外推单年增速；因成长路径证据不足使用benchmark。';;
    report_consistency) reason='报告中心数字将由结构化模型生成的转写表引用，并明确估计和反证。';;
    capital_return_interpretability) reason='投入资本分母包含营运资金、长期经营资产与经营现金，三年均为显著正数；但经营现金和资产负债分类含估计，ROIC仅用于判断资本密集度和趋势，不作精确同业比较。';;
  esac
  python3 "$TOOL" set-review --model "$MODEL" --item "$item" --passed --reason "$reason"
done

python3 "$TOOL" compile --model "$MODEL"
python3 "$TOOL" validate --model "$MODEL"
python3 "$TOOL" render --model "$MODEL" --output outputs/transcribed-tables.md

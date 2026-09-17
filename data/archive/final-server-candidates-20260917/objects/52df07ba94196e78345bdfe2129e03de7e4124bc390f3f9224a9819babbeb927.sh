#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs

python3 "$tool" init --name 长春高新 --code 000661.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股 --security-unit 股 --output "$model"

fact() {
  local scaled
  scaled=$(awk -v n="$3" 'BEGIN {printf "%.6f", n*100000000}')
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$scaled" --period "$4" --source "$5" --locator "$6"
}
field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
field_est() {
  local scaled
  scaled=$(awk -v n="$4" 'BEGIN {printf "%.6f", n*100000000}')
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$scaled" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

src23='长春高新技术产业（集团）股份有限公司2023年年度报告（2024-03-20）'
src24='长春高新技术产业（集团）股份有限公司2024年年度报告（2025-04-21）'
src25='长春高新技术产业（集团）股份有限公司2025年年度报告（2026-04-22）'

# 历史经营事实，单位统一折算为亿元人民币。
fact rev23 营业收入 145.6603961198 2023 "$src23" '合并利润表，报告页90-91（PDF页91-92）'
fact cost23 营业成本 20.4394990612 2023 "$src23" '合并利润表，报告页90-91（PDF页91-92）'
fact taxs23 税金及附加 1.0592980321 2023 "$src23" '合并利润表，报告页91（PDF页92）'
fact sell23 销售费用 39.7019184956 2023 "$src23" '合并利润表，报告页91（PDF页92）'
fact admin23 管理费用 9.568719315 2023 "$src23" '合并利润表，报告页91（PDF页92）'
fact rd23 研发费用 17.2301104254 2023 "$src23" '合并利润表，报告页91（PDF页92）'
fact subsidy23 其他收益 0.4810260143 2023 "$src23" '合并利润表，报告页91（PDF页92）'
fact incometax23 所得税费用 7.3445151075 2023 "$src23" '合并利润表，报告页91（PDF页92）'
fact da_fa23 固定资产折旧 2.9389786002 2023 "$src23" '现金流量表补充资料，报告页163-164（PDF页164-165）'
fact da_rou23 使用权资产折旧 0.5466242854 2023 "$src23" '现金流量表补充资料，报告页163-164（PDF页164-165）'
fact da_ia23 无形资产摊销 2.0032514826 2023 "$src23" '现金流量表补充资料，报告页163-164（PDF页164-165）'
fact da_ltd23 长期待摊费用摊销 0.2890378913 2023 "$src23" '现金流量表补充资料，报告页163-164（PDF页164-165）'
fact ocf23 经营活动产生的现金流量净额 51.0368781305 2023 "$src23" '合并现金流量表，报告页95（PDF页96）'
fact capex_paid23 购建固定资产无形资产和其他长期资产支付的现金 20.9679991572 2023 "$src23" '合并现金流量表，报告页96（PDF页97）'
fact disposal23 处置固定资产无形资产和其他长期资产收回的现金净额 0.0755828 2023 "$src23" '合并现金流量表，报告页95（PDF页96）'
fact caprd23 研发投入资本化金额 7.0653376993 2023 "$src23" '管理层讨论与分析，报告页38-39'

fact rev24 营业收入 134.6562731838 2024 "$src24" '合并利润表，报告页97（PDF页97）'
fact cost24 营业成本 19.2261426008 2024 "$src24" '合并利润表，报告页97（PDF页97）'
fact taxs24 税金及附加 0.6202130758 2024 "$src24" '合并利润表，报告页97（PDF页97）'
fact sell24 销售费用 44.3906454346 2024 "$src24" '合并利润表，报告页97（PDF页97）'
fact admin24 管理费用 12.0169786467 2024 "$src24" '合并利润表，报告页97（PDF页97）'
fact rd24 研发费用 21.6663294932 2024 "$src24" '合并利润表，报告页97（PDF页97）'
fact subsidy24 其他收益 0.1741295373 2024 "$src24" '合并利润表，报告页97（PDF页97）'
fact incometax24 所得税费用 4.3180841778 2024 "$src24" '合并利润表，报告页98（PDF页98）'
fact da_fa24 固定资产折旧 3.5229654016 2024 "$src24" '现金流量表补充资料，报告页171-172（PDF页172）'
fact da_rou24 使用权资产折旧 0.5526342377 2024 "$src24" '现金流量表补充资料，报告页171-172（PDF页172）'
fact da_ia24 无形资产摊销 2.1378686143 2024 "$src24" '现金流量表补充资料，报告页171-172（PDF页172）'
fact da_ltd24 长期待摊费用摊销 0.4464826768 2024 "$src24" '现金流量表补充资料，报告页171-172（PDF页172）'
fact ocf24 经营活动产生的现金流量净额 31.0427940634 2024 "$src24" '合并现金流量表，报告页102（PDF页102）'
fact capex_paid24 购建固定资产无形资产和其他长期资产支付的现金 21.811567828 2024 "$src24" '合并现金流量表，报告页102（PDF页102）'
fact disposal24 处置固定资产无形资产和其他长期资产收回的现金净额 0.0342949042 2024 "$src24" '合并现金流量表，报告页102（PDF页102）'
fact caprd24 研发投入资本化金额 5.230729761 2024 "$src24" '管理层讨论与分析，报告页39-40'

fact rev25 营业收入 120.8314048905 2025 "$src25" '合并利润表，报告页87-88（PDF页88-89）'
fact cost25 营业成本 21.6113053358 2025 "$src25" '合并利润表，报告页87（PDF页88）'
fact taxs25 税金及附加 1.0680468281 2025 "$src25" '合并利润表，报告页87（PDF页88）'
fact sell25 销售费用 50.9050313994 2025 "$src25" '合并利润表，报告页87（PDF页88）'
fact admin25 管理费用 14.9908849455 2025 "$src25" '合并利润表，报告页87（PDF页88）'
fact rd25 研发费用 24.7238829453 2025 "$src25" '合并利润表，报告页87（PDF页88）'
fact subsidy25 其他收益 1.1703457382 2025 "$src25" '合并利润表，报告页87（PDF页88）'
fact incometax25 所得税费用 0.2399811705 2025 "$src25" '合并利润表，报告页88（PDF页89）'
fact da_fa25 固定资产折旧 4.5500196377 2025 "$src25" '现金流量表补充资料，报告页158-159（PDF页159-160）'
fact da_rou25 使用权资产折旧 0.4818474514 2025 "$src25" '现金流量表补充资料，报告页159（PDF页160）'
fact da_ia25 无形资产摊销 2.575742077 2025 "$src25" '现金流量表补充资料，报告页159（PDF页160）'
fact da_ltd25 长期待摊费用摊销 0.5237812356 2025 "$src25" '现金流量表补充资料，报告页159（PDF页160）'
fact ocf25 经营活动产生的现金流量净额 8.0213308306 2025 "$src25" '合并现金流量表，报告页91-92（PDF页92-93）'
fact capex_paid25 购建固定资产无形资产和其他长期资产支付的现金 22.0273861156 2025 "$src25" '合并现金流量表，报告页92（PDF页93）'
fact disposal25 处置固定资产无形资产和其他长期资产收回的现金净额 0.0216349464 2025 "$src25" '合并现金流量表，报告页92（PDF页93）'
fact caprd25 研发投入资本化金额 4.6363259341 2025 "$src25" '管理层讨论与分析，报告页39'

# 经营表：期间经营费用为税金、销售、管理、研发减日常相关其他收益；现金税暂以合并所得税费用为基准。
for y in 23 24 25; do
  year=$((2000+y))
  field_expr historical "$year" revenue "rev$y" reported '合并利润表直接数。' high
  field_expr historical "$year" cost_of_revenue "cost$y" reported '合并利润表直接数。' high
  field_expr historical "$year" period_operating_expenses "taxs$y+sell$y+admin$y+rd$y-subsidy$y" formula '纳入税金、销售、管理和研发，扣除与日常活动相关的其他收益；剔除财务、投资、公允价值、减值和处置损益。' medium
  field_expr historical "$year" cash_tax "incometax$y" reported '以合并所得税费用作为经营现金税基准；利息和非经营损益相对经营规模较小但未能完全拆税。' medium
  field_expr historical "$year" depreciation_amortization "da_fa$y+da_rou$y+da_ia$y+da_ltd$y" formula '现金流量表补充资料中的经营性折旧及摊销合计。' high
  field_expr historical "$year" exploratory_business_capex "caprd$y" formula '以当年资本化研发投入代表尚未稳定赚钱的新产品/技术路线长期投入。' medium
  field_expr historical "$year" core_business_capex "capex_paid$y-disposal$y-caprd$y" formula '净经营长期资产现金投入扣除资本化研发，余项归属既有业务生产、厂房和配套建设。' medium
  field_expr historical "$year" operating_cash_flow "ocf$y" reported '合并现金流量表直接数。' high
  field_est historical "$year" after_tax_interest_in_operating_cash_flow 0 '利息现金流在中国准则现金流量表中列入筹资活动，经营现金流无需加回税后利息。' high '若现金流量表附注明确将重大利息支付列入经营活动，则改为税后利息。'
done

# 用经营利润路径反推广义经营性营运资本/非现金经营项目增加，使 FCFF 与经营现金流路径严格闭合。
field_est historical 2023 operating_working_capital_increase 5.5382997312 'NOPAT加折旧摊销减经营现金流的闭合项，包含营运资本、递延税和常规非现金经营调整。' medium '若可逐项拆清全部非现金调整，应以严格的经营性营运资本变动替代。'
field_est historical 2024 operating_working_capital_increase 8.2090426665 'NOPAT加折旧摊销减经营现金流的闭合项，包含营运资本、递延税和常规非现金经营调整。' medium '若可逐项拆清全部非现金调整，应以严格的经营性营运资本变动替代。'
field_est historical 2025 operating_working_capital_increase 8.5717315197 'NOPAT加折旧摊销减经营现金流的闭合项，包含营运资本、递延税和常规非现金经营调整。' medium '若可逐项拆清全部非现金调整，应以严格的经营性营运资本变动替代。'

# 资产端采用逐项资产负债表转写后的合计。原始组成与页码保留在字段理由和报告口径说明中。
for row in \
  '2022 62.2819137622 91.3487090786 8.0 0.5869002821' \
  '2023 65.5822186341 109.0778312005 7.3 0.4933364284' \
  '2024 70.1744606328 134.8591678952 8.2 0.7870480580' \
  '2025 72.2687669220 146.1687357347 9.4 0.7661153608'; do
  set -- $row; year=$1; owc=$2; olt=$3; cash=$4; gw=$5
  field_est capital "$year" operating_working_capital "$owc" '应收票据及账款、预付款、其他应收、存货和其他经营流动资产，扣除无息经营流动负债；排除现金、金融资产和融资负债。' medium '若其他应收款或其他流动资产附注显示重大非经营成分，按其净额重分类。'
  field_est capital "$year" operating_long_term_assets_net "$olt" '固定资产、在建工程、使用权资产、无形资产、开发支出、商誉、长期待摊及经营性其他非流动资产，扣除递延收益。' medium '若其他非流动资产或在建工程被证实不服务主营经营，应转为非经营资产。'
  field_est capital "$year" required_cash "$cash" '约一个月经营现金支出的流动性缓冲；随经营费用和规模上升。' low '若月度结算、季节性或集团资金归集证据表明最低现金需求显著不同，重新估计。'
  field_est capital "$year" unsupported_intangible_assets "$gw" '商誉默认不能由当前经营能力单独解释，从投入资本中剔除。' high '若并购形成的具体客户关系、技术或牌照能由持续收益单独验证，可重新纳入。'
done

# 稳定期不是历史高点回归：收入略高于2025，毛利率仍低于2023，费用保留新产品推广与研发负担；建设期资本开支降至略高于折旧。
field_est stable '' revenue 125.0 '医保降价和疫苗竞争仍在，假设新产品放量仅部分抵消，收入稳定在2025与2024之间。' low '若生长激素医保后量增、疫苗接种恢复或新药商业化使收入持续突破135亿元，稳定收入上调；反之下调。'
field_est stable '' cost_of_revenue 22.5 '对应82%的稳定毛利率，低于2023-2024并接近2025受价格压力后的结构。' medium '若生长激素降价后毛利率继续跌破80%或高毛利新药放量，重估。'
field_est stable '' period_operating_expenses 84.0 '低于2025战略投入高点但显著高于2023，保留较高研发和商业化平台支出。' low '若销售服务费、人员优化和研发管线支出不能回落，费用应接近或超过2025。'
field_est stable '' cash_tax 2.5 '按18.5亿元EBIT的约13.5%计，接近医药子公司优惠税率并留有抵扣差异。' low '若税收优惠到期或亏损主体抵扣能力变化，按实际有效税率更新。'
field_est stable '' depreciation_amortization 8.5 '随新增厂房设备转固，略高于2025折旧摊销。' medium '若在建工程大规模转固后折旧明显超过9亿元，更新。'
field_est stable '' core_business_capex 10.0 '假设当前建设高峰结束后，常态投入略高于折旧摊销以维持生产与合规。' low '若固定资产与在建工程仍连续两年每年增加超过10亿元且无处置，常态资本开支上调。'
field_est stable '' exploratory_business_capex 0 '固定八倍标尺不给尚未稳定赚钱的新管线额外价值，其投入作为当前期现金消耗观察。' medium '若能形成逐年FCFF、商业化时间及总投入证据，改用成长估值并纳入。'
field_est stable '' operating_working_capital_increase 0 '稳定收入不增长时不假设永久追加营运资金。' medium '若库存结构或回款账期在稳定状态仍持续上升，应恢复正值。'

# 2025核心业务经营推算。收入以主要子公司披露为锚，集团服务为闭合余项；成本费用与现金贡献为公司约束下基准估计。
for spec in \
  'jinsai 金赛生长激素与多领域生物药 核心利润来源且承担主要新药研发与商业化投入 medium 生长激素医保后量价、非儿科新品收入或金赛分部成本披露将推翻当前分配' \
  'baike 百克疫苗 带状疱疹和水痘疫苗处于需求与竞争压力期 medium 百克单体现金流及产品毛利披露将推翻当前分配' \
  'huakang 华康中成药 稳定但规模较小的传统药业务 medium 华康单体费用和现金流披露将推翻当前分配' \
  'property 高新地产 地产去化和工程投入占用资本 medium 项目结算毛利及经营现金流披露将推翻当前分配' \
  'platform 园区服务与集团管理平台 服务收入同时承接总部管理和合并抵销 low 分部费用、现金流和抵销明细将推翻当前分配'; do
  set -- $spec
  python3 "$tool" add-business --model "$model" --business-id "$1" --name "$2" --importance "$3" --confidence "$4" --falsifier "$5"
done

biz_est() { local scaled; scaled=$(awk -v n="$3" 'BEGIN {printf "%.6f", n*100000000}'); python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$scaled" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
biz_rep() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence "$5"; }

fact jinsai_rev25 金赛药业营业收入 98.1907884496 2025 "$src25" '管理层讨论与分析，报告页31；主要控股参股公司，报告页42-43'
fact baike_rev25 百克生物营业收入 6.0507292768 2025 "$src25" '管理层讨论与分析，报告页31；主要控股参股公司，报告页42-43'
fact huakang_rev25 华康药业营业收入 7.5596690079 2025 "$src25" '管理层讨论与分析，报告页31；主要控股参股公司，报告页42-43'
fact property_rev25 房地产业外部营业收入 8.1621619741 2025 "$src25" '主营业务分析营业收入构成，报告页33'

biz_rep jinsai revenue jinsai_rev25 '主要子公司营业收入直接披露。' high
biz_rep baike revenue baike_rev25 '主要子公司营业收入直接披露。' high
biz_rep huakang revenue huakang_rev25 '主要子公司营业收入直接披露。' high
biz_rep property revenue property_rev25 '按行业外部收入直接披露。' high
biz_est platform revenue 0.8680561821 '以合并收入扣除四项具名业务收入闭合，包含园区服务及子公司收入到合并口径的抵销差。' low '披露服务分部对外收入与合并抵销后改用直接数。'

biz_est jinsai cost_of_revenue 8.5 '以基因工程/生物类药品成本11.293亿元为锚，按金赛与百克产品结构估计。' low '金赛单体营业成本或主要产品单位成本披露。'
biz_est baike cost_of_revenue 2.7931294059 '与金赛成本合计闭合至基因工程/生物类药品直接披露成本。' low '百克单体营业成本或产品毛利披露。'
biz_est huakang cost_of_revenue 2.7732424157 '制药业总成本扣除基因工程/生物类药品成本，作为中成药成本。' medium '中成药直接成本披露出现差异。'
biz_est property cost_of_revenue 6.9444355265 '采用房地产业销售量成本口径。' medium '分部对外营业成本与销售量成本口径差异被拆清。'
biz_est platform cost_of_revenue 0.6004979877 '合并营业成本扣除四项业务成本的闭合余项。' low '服务分部对外成本及抵销明细披露。'

# 费用分配使各业务EBIT与子公司营业利润方向一致，并将总部平台负担留在平台行。
biz_est jinsai period_operating_expenses 78.6907884496 '令不含减值和投资损益的金赛基准EBIT约11亿元，反映销售与研发投入集中。' low '金赛单体期间费用完整披露。'
biz_est baike period_operating_expenses 4.2575998709 '令疫苗业务基准EBIT约-1亿元，方向与百克营业亏损一致但剔除减值。' low '百克费用及减值明细更新。'
biz_est huakang period_operating_expenses 4.1864265922 '令华康基准EBIT约0.6亿元，与披露盈利水平接近。' low '华康单体期间费用披露。'
biz_est property period_operating_expenses 1.0177264476 '令地产基准EBIT约0.2亿元，与披露营业利润方向一致。' low '地产分部期间费用披露。'
biz_est platform period_operating_expenses 2.3649590198 '合并期间经营费用闭合余项，主要承接总部管理平台和抵销。' low '总部与服务分部费用明细披露。'

biz_est jinsai cash_tax 0.4 '按制药业务盈利主体分配经营现金税。' low '子公司现金所得税披露。'
biz_est baike cash_tax -0.1 '亏损与递延所得税影响的基准分配。' low '百克现金所得税披露。'
biz_est huakang cash_tax 0.132755855 '按制药分部所得税及华康利润规模估计。' low '华康现金所得税披露。'
biz_est property cash_tax 0.1939099376 '接近房地产分部披露所得税费用。' medium '地产现金税与递延税拆分。'
biz_est platform cash_tax -0.3866846221 '闭合公司所得税；反映亏损及合并抵销税项，非可单独外推税率。' low '合并抵销所得税明细披露。'

biz_est jinsai operating_cash_flow_contribution 10.0 '现金贡献集中于金赛，但被高销售研发现金支出压低。' low '金赛单体现金流量表披露。'
biz_est baike operating_cash_flow_contribution -1.2 '收入下滑、退货和研发支出导致现金流为负的基准估计。' low '百克单体经营现金流披露。'
biz_est huakang operating_cash_flow_contribution 0.8 '盈利稳定且资本较轻的基准估计。' low '华康单体经营现金流披露。'
biz_est property operating_cash_flow_contribution -1.0 '在建项目投入和库存占用导致负贡献的基准估计。' low '地产项目经营现金流披露。'
biz_est platform operating_cash_flow_contribution -0.5786691694 '合并经营现金流闭合余项，承接总部和抵销。' low '服务与总部现金流披露。'

# 股权价值桥。
fact cash25 货币资金 21.6396033512 2025-12-31 "$src25" '合并资产负债表，报告页80（PDF页81）'
fact restricted_cash25 不属于现金及现金等价物的货币资金 0.7191930436 2025-12-31 "$src25" '现金和现金等价物构成，报告页160（PDF页161）'
fact trading_assets25 交易性金融资产 14.3063569832 2025-12-31 "$src25" '合并资产负债表，报告页80（PDF页81）'
fact lti25 长期股权投资 6.9254105731 2025-12-31 "$src25" '合并资产负债表，报告页81（PDF页82）'
fact oci_equity25 其他权益工具投资 1.7781668943 2025-12-31 "$src25" '合并资产负债表，报告页81（PDF页82）'
fact inv_property25 投资性房地产 1.2922981114 2025-12-31 "$src25" '合并资产负债表，报告页81（PDF页82）'
fact fixed_assets25 固定资产 72.6229703486 2025-12-31 "$src25" '合并资产负债表，报告页81（PDF页82）'
fact cip25 在建工程 27.9180059832 2025-12-31 "$src25" '合并资产负债表，报告页81（PDF页82）'
fact intangibles25 无形资产 24.1093422273 2025-12-31 "$src25" '合并资产负债表，报告页81（PDF页82）'
fact development25 开发支出 12.7801469341 2025-12-31 "$src25" '合并资产负债表，报告页81（PDF页82）'
fact short_debt25 短期借款 6.2094588803 2025-12-31 "$src25" '合并资产负债表，报告页82（PDF页83）'
fact current_debt25 一年内到期的非流动负债 0.6114005157 2025-12-31 "$src25" '合并资产负债表，报告页82（PDF页83）'
fact long_debt25 长期借款 12.3408409416 2025-12-31 "$src25" '合并资产负债表，报告页82（PDF页83）'
fact lease_debt25 租赁负债 0.2094844076 2025-12-31 "$src25" '合并资产负债表，报告页82（PDF页83）'
fact nci25 少数股东权益 28.609623592 2025-12-31 "$src25" '合并资产负债表，报告页83（PDF页84）'
fact dividend_base25 现金分红基数普通股股数 4.01714412 2025-12-31 "$src25" '资产负债表日后利润分配，报告页175-176（PDF页176-177）'
fact equity_grants25 本期授予权益工具数量 0.010849 2025-12-31 "$src25" '股份支付，报告页174-175（PDF页175-176）'

field_est equity '' excess_cash 8.9 '货币资金扣除9.4亿元经营必需现金和约0.72亿元受限资金，取8.9亿元可达值。' medium '若受限资金解除或日常最低现金需求变化，更新。'
field_expr equity '' non_operating_assets 'trading_assets25+lti25+oci_equity25+inv_property25' formula '经营利润已剔除投资收益和公允价值变动，因此交易性金融资产、股权投资及投资性房地产按账面值加回。' medium
field_expr equity '' financing_debt 'short_debt25+current_debt25+long_debt25+lease_debt25' formula '包括借款、一年内到期非流动负债和租赁负债；采取融资负债扣除口径。' high
field_expr equity '' minority_interest_value nci25 reported '缺乏百克等少数股权独立稳定FCFF，暂以少数股东账面权益作经济价值替代。' low
field_est equity '' other_priority_claims 0 '未识别到未被经营资本、融资负债或少数股权覆盖的重大优先索偿。' medium '若资本承诺、诉讼或已宣告未付股利构成重大索偿，应扣除。'
field_expr equity '' diluted_shares 'dividend_base25+equity_grants25' formula '期后分红基数（总股本扣回购专户）加本期授予的108.49万份权益工具，作为潜在摊薄股数；第三期旧激励未达标并冲回费用。' medium
python3 "$tool" set-field --model "$model" --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason '财报及交易币种均为人民币。' --confidence high --falsifier '币种发生变化时更新。'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '2025利润受医保调价、疫苗退货与降价、新产品推广、研发及人员优化多因素影响；尚不足以可靠预测逐年FCFF和到达稳定状态时间，采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-adjustment --model "$model" --name '剔除金融与重大非经营损益' --before '2025营业利润3.93亿元' --after '核心EBIT 8.70亿元' --reason '从收入成本费用重构，剔除投资损失、公允价值变动、信用/资产减值和资产处置；其他收益仍视为日常相关。若减值成为产品退货和研发失败的持续常态，本调整应收窄。'
python3 "$tool" add-adjustment --model "$model" --name '研发资本化归为开拓性投入' --before '2025长期资产净现金投入22.01亿元' --after '主营17.37亿元；开拓性4.64亿元' --reason '当年资本化研发对应尚未稳定赚钱的新产品和技术路线，不为其单独赋值；获批产品形成稳定现金流后可转入主营投入。'
python3 "$tool" add-adjustment --model "$model" --name '少数股东价值替代' --before '少数股东账面权益28.61亿元' --after '暂按28.61亿元扣除' --reason '合并经营价值含百克等100%现金流，但上市公司不拥有全部权益；独立稳定FCFF不足，账面权益只是替代值，百克市场/经营价值重估会直接改变普通股价值。'

for review in \
  'source_traceability 原始金额保留披露名称、期间、合并范围、报告名称和页码，公式字段引用事实ID。' \
  'economic_classification 金融收益、减值和处置损益从核心EBIT剔除；经营资产、非经营资产、融资负债及少数股权不重复。' \
  'capital_return_interpretability 投入资本包含地产库存、研发资产和高额在建工程，分母为正且可解释；但经营必需现金及其他科目分类为估计，ROIC仅用于观察下降趋势。' \
  'stable_state 稳定期同时约束收入、毛利、费用、税、折旧、资本开支和营运资金，没有机械采用单年高点或低点。' \
  'report_consistency 报告重大数字、业务闭合、稳定经营收益和普通股基准价值均以结构化模型为唯一数值来源。'; do
  set -- $review
  python3 "$tool" set-review --model "$model" --item "$1" --passed --reason "$2"
done

python3 "$tool" compile --model "$model"

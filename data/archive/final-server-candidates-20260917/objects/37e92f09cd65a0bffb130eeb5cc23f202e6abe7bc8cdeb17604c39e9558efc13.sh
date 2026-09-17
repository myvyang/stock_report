#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
src23='五粮液2023年年度报告（2024-04-29）'
src24='五粮液2024年年度报告（2025-04-26）'
src25='五粮液2025年年度报告（2026-04-30）'

python3 "$tool" init --name 五粮液 --code 000858.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope consolidated --source "$5" --locator "$6"; }
hist_expr() { python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --expression="$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
hist_est() { python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --value="$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
cap_est() { python3 "$tool" set-field --model "$model" --view capital --year "$1" --field "$2" --value="$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
stable_est() { python3 "$tool" set-field --model "$model" --view stable --field "$1" --value="$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }
equity_expr() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --expression="$2" --basis-type "$3" --reason "$4" --confidence "$5"; }
equity_est() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --value="$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }

# 历史利润、现金流与资本开支；金额统一转为亿元。
for row in \
  '2023 rev 832.7206731719 营业收入 P057-P058' '2023 cost 201.5714395221 营业成本 P058' '2023 opp 420.0366376187 营业利润 P058' '2023 fin -24.7317067627 财务费用 P058' '2023 inv 0.5761708391 投资收益 P058' '2023 ie 0.1161833887 利息费用 P058' '2023 ii 24.8795364333 利息收入 P058' '2023 ocf 417.4247990823 经营活动产生的现金流量净额 P061' '2023 capex 29.5723668234 购建固定资产无形资产和其他长期资产支付的现金 P061' '2023 disposal 0.0176598988 处置固定资产无形资产和其他长期资产收回的现金净额 P061' \
  '2024 rev 891.7517832270 营业收入 P060-P061' '2024 cost 204.6142308374 营业成本 P061' '2024 opp 442.0007571037 营业利润 P061' '2024 fin -28.3353084046 财务费用 P061' '2024 inv 0.7519910274 投资收益 P061' '2024 ie 0.4043689268 利息费用 P061' '2024 ii 28.7586341011 利息收入 P061' '2024 ocf 339.3975519278 经营活动产生的现金流量净额 P064' '2024 capex 26.6631078023 购建固定资产无形资产和其他长期资产支付的现金 P065' '2024 disposal 0.1013640118 处置固定资产无形资产和其他长期资产收回的现金净额 P065' \
  '2025 rev 405.2850977023 营业收入 P056' '2025 cost 91.0195695359 营业成本 P056' '2025 opp 122.5115101443 营业利润 P056' '2025 fin -26.6163058909 财务费用 P056' '2025 inv 1.1156848677 投资收益 P056' '2025 ie 0.2857394937 利息费用 P056' '2025 ii 26.9316476358 利息收入 P056' '2025 ocf 297.0625991913 经营活动产生的现金流量净额 P060' '2025 capex 19.6740731636 购建固定资产无形资产和其他长期资产支付的现金 P060' '2025 disposal 0.3683938635 处置固定资产无形资产和其他长期资产收回的现金净额 P060'; do
  set -- $row; y=$1; id=$2; amt=$3; item=$4; loc=$5
  if [[ $y == 2023 ]]; then src=$src23; elif [[ $y == 2024 ]]; then src=$src24; else src=$src25; fi
  fact "${id}_${y}" "$item" "$amt" "$y" "$src" "$loc"
done

# 折旧摊销和营运资金调整来自现金流量表补充资料。
for row in \
 '2023 dafix 4.4129575985 固定资产折旧 P126' '2023 darou 3.9181225729 使用权资产折旧 P126' '2023 daint 0.7386109814 无形资产摊销 P126' '2023 dalt 0.7515526676 长期待摊费用摊销 P126' '2023 wcinv -14.0557821646 存货的减少增加 P126' '2023 wcrecv 143.0979452300 经营性应收项目的减少增加 P126' '2023 wcpay -35.0233177772 经营性应付项目的增加减少 P126' \
 '2024 dafix 5.6329828379 固定资产折旧 P120' '2024 darou 4.3593137916 使用权资产折旧 P120' '2024 daint 1.4709386204 无形资产摊销 P120' '2024 dalt 0.7307741456 长期待摊费用摊销 P121' '2024 wcinv -8.4031116294 存货的减少增加 P121' '2024 wcrecv -65.2853945489 经营性应收项目的减少增加 P121' '2024 wcpay 79.0989181058 经营性应付项目的增加减少 P121' \
 '2025 dafix 5.9266402950 固定资产折旧 P116' '2025 darou 3.9713665247 使用权资产折旧 P116' '2025 daint 1.7484806589 无形资产摊销 P116' '2025 dalt 1.1032388407 长期待摊费用摊销 P116' '2025 wcinv -18.5472314948 存货的减少增加 P116' '2025 wcrecv 18.7800127104 经营性应收项目的减少增加 P116' '2025 wcpay 206.6002923992 经营性应付项目的增加减少 P116'; do
  set -- $row; y=$1; id=$2; amt=$3; item=$4; loc=$5
  if [[ $y == 2023 ]]; then src=$src23; elif [[ $y == 2024 ]]; then src=$src24; else src=$src25; fi
  fact "${id}_${y}" "$item" "$amt" "$y" "$src" "$loc"
done

for y in 2023 2024 2025; do
  hist_expr "$y" revenue "rev_$y" reported '合并利润表营业收入。' high
  hist_expr "$y" cost_of_revenue "cost_$y" reported '合并利润表营业成本。' high
  hist_expr "$y" period_operating_expenses "rev_$y-cost_$y-(opp_$y+fin_$y-inv_$y)" formula '以营业利润剔除净财务收益和投资收益重构EBIT；其他收益、减值和处置小额净额保留在经营中。' medium
  hist_expr "$y" depreciation_amortization "dafix_$y+darou_$y+daint_$y+dalt_$y" formula '现金流量表补充资料四类经营折旧摊销之和。' high
  hist_expr "$y" core_business_capex "capex_$y-disposal_$y" formula '取得经营性长期资产现金支出扣除处置回款；扩产、技改、环保及产能项目均服务现有酒类和配套业务。' high
  hist_est "$y" exploratory_business_capex 0 '未发现现金资本开支中可与现有酒类及配套生产可靠分离的新业务项目；科技创新子公司股权投入不属于长期资产现金资本开支。' medium '后续披露现金资本开支中存在具名、尚未商业化且可独立计量的新业务项目。'
  hist_expr "$y" operating_working_capital_increase "-(wcinv_$y+wcrecv_$y+wcpay_$y)" formula '按现金流量表补充资料中存货、经营性应收和经营性应付对现金流的调整数反号计算。' high
  hist_expr "$y" operating_cash_flow "ocf_$y" reported '合并现金流量表经营活动现金流量净额。' high
  hist_expr "$y" after_tax_interest_in_operating_cash_flow "(ie_$y-ii_$y)*0.75" formula '经营现金流含存款利息；按25%税率扣除净利息收入后转回融资前口径。' medium
done

# 经营现金税按利润路径与现金流路径闭合，反映实际现金税时点而非机械采用所得税费用。
hist_est 2023 cash_tax 99.7201647902 '以EBIT、折旧摊销、补充资料营运资金变动和剔除税后净利息后的经营现金流闭合。' medium '附注披露可完整区分经营所得税、利息所得税及历史补税的现金税明细。'
hist_est 2024 cash_tax 112.4203860960 '以EBIT、折旧摊销、补充资料营运资金变动和剔除税后净利息后的经营现金流闭合。' medium '附注披露可完整区分经营所得税、利息所得税及历史补税的现金税明细。'
hist_est 2025 cash_tax 37.2841669055 '以EBIT、折旧摊销、补充资料营运资金变动和剔除税后净利息后的经营现金流闭合；低于正常税率主要反映现金税时点。' medium '附注披露可完整区分经营所得税、利息所得税及历史补税的现金税明细。'

# 经营资本：营运资金含经营性应收、存货和预付款，扣除不含股利的经营性流动负债；长期资产扣递延收益。
for row in \
 '2022 102.4715194870 108.6224028799' '2023 -11.7715229360 137.3184860167' '2024 -26.6564786840 167.4440138807' '2025 -292.5054578970 178.7600903055'; do
  set -- $row; y=$1; owc=$2; lta=$3
  cap_est "$y" operating_working_capital "$owc" '由合并资产负债表经营性应收票据、应收款、应收款项融资、预付、其他应收、存货和其他流动资产，扣除票据及账款应付、预收、合同负债、职工和税费、非股利其他应付款及其他流动负债。' medium '附注证明应收款项融资、其他流动资产或监管商品款项属于融资或受托资金而非经营项目。'
  cap_est "$y" operating_long_term_assets_net "$lta" '固定资产、在建工程、使用权资产、经营性无形资产、长期待摊及其他非流动资产合计，扣除资产相关递延收益。' medium '披露其中存在可脱离主业处置的重大土地、物业或其他长期资产。'
  cap_est "$y" required_cash 50 '统一保留50亿元作为工资、采购、税费及结算缓冲，约覆盖2025年一个月非所得税经营现金支出。' low '月度最低现金、季节性结算或集团资金管制资料证明所需缓冲显著不同。'
  cap_est "$y" unsupported_intangible_assets 0.0162161953 '仅剔除账面商誉；土地使用权、专利与品牌相关无形资产继续服务经营。' medium '商誉对应业务产生可单独验证且持续的经营收益，或其他无形资产已不再服务主业。'
done

# 稳定基准不是2025年机械年化：只假设收入恢复到500亿元、EBIT率40%，仍明显低于2023-2024。
stable_est revenue 500 '行业调整后基准收入取500亿元：高于2025年405亿元低点，但远低于2023-2024年833-892亿元。' low '连续两年收入稳定在450亿元以下，或渠道动销、批价与销量证明确认更高可持续水平。'
stable_est cost_of_revenue 110 '按78%正常综合毛利率估计，接近三年披露区间且低于2025年一次性高点。' medium '产品结构或终端价格使综合毛利率连续偏离76%-80%。'
stable_est period_operating_expenses 190 '包括消费税及附加、销售管理研发和经营性其他净费用，隐含38%收入费用率，反映收入下降后的固定费用与渠道投入。' low '销售费用和税费在收入恢复后稳定显示显著更低或更高的费用率。'
stable_est cash_tax 50 '按200亿元EBIT的25%正常经营现金税率。' medium '长期有效经营税率因优惠、补税或税制改变显著偏离25%。'
stable_est depreciation_amortization 12.5 '接近2024-2025年12.2-12.7亿元折旧摊销。' medium '在建产能转固后折旧摊销稳定超过该水平20%。'
stable_est core_business_capex 18 '低于建设期近三年19-30亿元实际净资本开支，但高于折旧摊销，保留持续技改、环保和产能维护余量。' low '项目完工后的长期维护资本开支或新增扩产承诺稳定显著偏离18亿元。'
stable_est exploratory_business_capex 0 '证据不足以把科技创新等未来选项作为可持续稳定经营投入或单独价值。' medium '出现具名新业务的商业化收入、利润路径和完整资金计划。'
stable_est operating_working_capital_increase 0 '成熟且不增长的稳定状态不假设永久新增营运资金，剔除2025年监管商品款项带来的暂时现金释放。' medium '正常经营持续要求库存或账期每年净增占用现金。'

# 估值桥事实。
fact cash_2025 货币资金 1270.1444301686 2025-12-31 "$src25" P051
fact restricted_2025 银行承兑汇票保证金等 3.3448578813 2025-12-31 "$src25" P117
fact dividend_payable_2025 应付股利 55.6597664361 2025-12-31 "$src25" P052
fact lti2025 长期股权投资 22.3351441145 2025-12-31 "$src25" P051
fact onfa2025 其他非流动金融资产 0.0120000000 2025-12-31 "$src25" P051
fact current_lease_2025 一年内到期的租赁负债 3.6414947084 2025-12-31 "$src25" P052
fact long_lease_2025 租赁负债 0.4438118244 2025-12-31 "$src25" P053
fact shares_2025 股份总数 38.8160800500 2025-12-31 "$src25" P111
fact mi_profit_2023 少数股东损益 13.1019231285 2023 "$src23" P058
fact mi_profit_2024 少数股东损益 13.4028795034 2024 "$src24" P062
fact mi_profit_2025 少数股东损益 3.6285598217 2025 "$src25" P057
fact regulatory_goods_2025 监管商品款项 263.1468095600 2025-12-31 "$src25" P110
fact restricted_other_current_2025 监管受限其他流动资产 49.0697218440 2025-12-31 "$src25" P018
fact dividends_paid_2025 2025年已实施现金分红 223.0800000000 2025 "$src25" P023

equity_est excess_cash 1161.1398058512 '2025年货币资金扣50亿元经营必需现金、3.345亿元受限保证金和55.660亿元已宣告应付股利；定期存款应计利息按面值保留。' medium '资金受控、资本承诺或上划限制使可分配现金显著减少，或已支付股利使义务消失。'
equity_expr non_operating_assets 'lti2025+onfa2025' formula '长期股权投资和其他非流动金融资产的收益已从EBIT剔除，按账面值作为非经营资产基准。' medium
equity_expr financing_debt 'current_lease_2025+long_lease_2025' formula '公司无银行借款或债券；租赁采用融资口径，扣除流动与非流动租赁负债。' high
equity_est minority_interest_value 80.3556332096 '以2023-2025年少数股东损益均值10.044亿元乘8估计并表少数权益经济价值。' low '子公司层面的FCFF、净现金和持股比例资料支持更精确的逐户估值。'
equity_est other_priority_claims 0 '已宣告应付股利已从多余现金扣除，日常经营负债已进入营运资金，未识别其他重大优先索偿。' medium '出现未入表的重大税务、资本承诺、担保或优先证券。'
equity_expr diluted_shares shares_2025 reported '年末股份总数；报告未显示具实质摊薄性的期权或可转债。' high
equity_est financial_to_trading_fx 1 '财报和交易币种均为人民币。' high '交易币种或报告币种改变。'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '2025年收入、销量和库存处在急剧调整期，且监管商品款项使现金流失真；缺少逐年恢复路径和完整成长投入证据，采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '2025年监管商品款项' --before '263.15亿元经营性流动负债' --after '稳定期不延续该现金释放' --reason '该款项令2025年经营性应付项目大增并托高经营现金流，不能视作重复盈利；若后续披露其为永久无偿经营资金则推翻。'
python3 "$tool" add-adjustment --model "$model" --name '已宣告未支付股利' --before '货币资金1270.14亿元' --after '多余现金先扣55.66亿元' --reason '应付股利已属于普通股之前的确定现金义务，直接从可分配现金扣除，避免在价值桥重复扣减。'

# 2025年业务树：按产品经济性拆分，非酒类为配套产品与内部产业链对外销售。
python3 "$tool" add-business --model "$model" --business-id wuliangye --name 五粮液产品 --importance '高端主品牌，收入、毛利与品牌定价权的核心。' --confidence medium --falsifier '公司披露按产品完整期间费用、税费和现金流，显示分配显著不同。'
python3 "$tool" add-business --model "$model" --business-id other_liquor --name 其他酒产品 --importance '五粮春、五粮醇、五粮特曲、尖庄等，覆盖更宽价格带。' --confidence medium --falsifier '公司重新划分产品组合或披露该组合中存在经济性完全不同的重大业务。'
python3 "$tool" add-business --model "$model" --business-id supporting --name 包材及非酒类产品 --importance '塑料、印刷、玻瓶及其他配套产品，对外收入较小但覆盖公司剩余收入与成本。' --confidence low --falsifier '附注披露剩余收入包含规模重大的非配套独立业务。'

for spec in \
 'wuliangye revenue 279.3609972656 reported rev_wuliangye' 'wuliangye cost_of_revenue 29.1960298119 reported cost_wuliangye' \
 'other_liquor revenue 91.6789250603 reported rev_other_liquor' 'other_liquor cost_of_revenue 31.0820514436 reported cost_other_liquor'; do
 set -- $spec; b=$1; fld=$2; val=$3; typ=$4; fid=$5
 if [[ $fld == revenue ]]; then item="${b}营业收入"; else item="${b}营业成本"; fi
 fact "$fid" "$item" "$val" 2025 "$src25" P013-P014
 python3 "$tool" set-business-field --model "$model" --business-id "$b" --field "$fld" --expression "$fid" --basis-type "$typ" --reason '年报产品表直接披露。' --confidence high
done
python3 "$tool" set-business-field --model "$model" --business-id supporting --field revenue --expression 'rev_2025-rev_wuliangye-rev_other_liquor' --basis-type formula --reason '公司总收入扣除两类酒产品，覆盖非酒类配套产品。' --confidence high
python3 "$tool" set-business-field --model "$model" --business-id supporting --field cost_of_revenue --expression 'cost_2025-cost_wuliangye-cost_other_liquor' --basis-type formula --reason '公司总成本扣除两类酒产品成本。' --confidence high

biz_est() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value="$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
biz_est wuliangye period_operating_expenses 155 '消费税、销售费用和管理研发费用按产品收入、毛利及高端品牌投放强度分配，并与公司合计闭合。' low '公司披露产品级费用显示偏差超过10%。'
biz_est other_liquor period_operating_expenses 49 '按产品收入、毛利及大众价格带费用强度分配，并与公司合计闭合。' low '公司披露产品级费用显示偏差超过10%。'
biz_est supporting period_operating_expenses 15.4860087807 '公司期间经营费用扣除两类酒产品分配额，反映配套业务低毛利及管理负担。' low '公司披露非酒业务独立费用显示偏差超过10%。'
biz_est wuliangye cash_tax 34 '按估计经营利润与现金税时点分配。' low '产品级现金税或税基资料显示重大差异。'
biz_est other_liquor cash_tax 5 '按估计经营利润与现金税时点分配。' low '产品级现金税或税基资料显示重大差异。'
biz_est supporting cash_tax -1.7158330945 '公司现金税总额扣除酒类分配额；亏损业务形成当期税盾。' low '非酒类子公司税务资料显示无法使用该税盾。'
biz_est wuliangye operating_cash_flow_contribution 240 '将大部分监管商品款项和经销商预收形成的现金贡献归入主品牌，并与公司经营现金流闭合。' low '监管商品款项合同证明主要属于其他业务或须返还。'
biz_est other_liquor operating_cash_flow_contribution 50 '按收入、合同负债和回款特征估计。' low '产品级回款及营运资金披露显示重大差异。'
biz_est supporting operating_cash_flow_contribution 7.0625991913 '公司经营现金流扣除两类酒产品估计额后的闭合值。' low '非酒业务现金流附注显示重大差异。'

for item in source_traceability economic_classification stable_state capital_return_interpretability report_consistency; do
 case $item in
 source_traceability) reason='重大金额均追溯到三份法定年报的具体PDF页；研究估计均记录依据和可推翻条件。';;
 economic_classification) reason='利息与投资收益已从经营利润剔除；经营现金、非经营投资、租赁负债及少数权益不重复计量。';;
 stable_state) reason='稳定基准综合2023-2025年跨度及2025年行业调整，未机械外推单年低点或现金流释放。';;
 capital_return_interpretability) reason='ROIC保留公式结果，但2025年监管商品款项令年末投入资本为负，正文明确限制其竞争优势解释。';;
 report_consistency) reason='报告中心数字、业务合计、稳定经营收益和普通股价值均以结构化模型输出为准。';;
 esac
 python3 "$tool" set-review --model "$model" --item "$item" --passed --reason "$reason"
done

# CLI底稿使用财报原币单位；上面的录入值为亿元展示口径，在首次编译前统一还原为元（股数还原为股）。
jq '
  (.facts[]?.amount) *= 100000000 |
  (.fields.historical[][]? | select(has("value")) | .value) *= 100000000 |
  (.fields.capital[][]? | select(has("value")) | .value) *= 100000000 |
  (.fields.stable[]? | select(has("value")) | .value) *= 100000000 |
  (.fields.equity.excess_cash.value,
   .fields.equity.minority_interest_value.value,
   .fields.equity.other_priority_claims.value) *= 100000000 |
  (.businesses[].fields[]? | select(has("value")) | .value) *= 100000000
' "$model" > outputs/analysis.scaled.json
mv outputs/analysis.scaled.json "$model"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

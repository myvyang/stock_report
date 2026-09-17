#!/usr/bin/env bash
set -euo pipefail

TOOL=.agents/skills/stock-research/scripts/stock_research.py
MODEL=outputs/analysis.json
AR23='欣融国际控股有限公司《2023年度报告》（2024-04-19） https://www1.hkexnews.hk/listedco/listconews/sehk/2024/0419/2024041900655.pdf'
AR24='欣融国际控股有限公司《2024年度报告》（2025-04-17） https://www1.hkexnews.hk/listedco/listconews/sehk/2025/0417/2025041700421.pdf'
AR25='欣融国际控股有限公司《2025年度报告》（2026-04-13） https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0413/2026041300396.pdf'

af() { python3 "$TOOL" add-fact --model "$MODEL" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope '集团合并' --source "$5" --locator "$6"; }
sf() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
sfe() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }

# 损益、现金流与资本开支原始事实（人民币元）
for row in \
  '2023 rev 683591000 收入' '2023 cost 569129000 销售成本' '2023 sell 29552000 销售及分销费用' '2023 admin 46437000 行政费用' '2023 impair 11031000 金融资产减值损失' '2023 otherexp 2176000 其他费用' '2023 grant 2228000 政府补助' '2023 otherinc 259000 其他收入' '2023 taxpaid 17288000 已付所得税' '2023 dep_ppe 424000 物业厂房设备折旧' '2023 dep_rou 2397000 使用权资产折旧' '2023 amort 143000 无形资产摊销' '2023 ppe_buy 57634000 购买物业厂房设备' '2023 int_buy 197000 购买无形资产' '2023 lease_principal 2190000 租赁本金付款' '2023 ocf 50946000 经营活动现金流净额' '2023 interest_received 2600000 银行利息收入' \
  '2024 rev 661645000 收入' '2024 cost 536026000 销售成本' '2024 sell 24371000 销售及分销费用' '2024 admin 40547000 行政费用' '2024 impair 67000 金融资产减值损失' '2024 otherexp 3100000 其他费用' '2024 grant 459000 政府补助' '2024 otherinc 148000 其他收入' '2024 taxpaid 15818000 已付所得税' '2024 dep_ppe 254000 物业厂房设备折旧' '2024 dep_rou 2762000 使用权资产折旧' '2024 amort 59000 无形资产摊销' '2024 ppe_buy 48386000 购买物业厂房设备' '2024 int_buy 9000 购买无形资产' '2024 ppe_proceeds 4000 处置物业厂房设备所得' '2024 lease_principal 2409000 租赁本金付款' '2024 ocf 39031000 经营活动现金流净额' '2024 interest_received 1500000 银行利息收入' \
  '2025 rev 651482000 收入' '2025 cost 530577000 销售成本' '2025 sell 25943000 销售及分销费用' '2025 admin 39115000 行政费用' '2025 impair 137000 金融资产减值损失' '2025 otherexp 982000 其他费用' '2025 otherinc 306000 其他收入' '2025 taxpaid 18953000 已付所得税' '2025 dep_ppe 232000 物业厂房设备折旧' '2025 dep_rou 1277000 使用权资产折旧' '2025 amort 1000 无形资产摊销' '2025 ppe_buy 39610000 购买物业厂房设备' '2025 ppe_proceeds 34000 处置物业厂房设备所得' '2025 lease_principal 1292000 租赁本金付款' '2025 ocf 56764000 经营活动现金流净额' '2025 interest_received 580000 银行利息收入'
do
  set -- $row; y=$1; k=$2; a=$3; item=$4
  if [[ $y == 2023 ]]; then src=$AR24; loc='第85、90–91页（PDF第86、91–92页）'; fi
  if [[ $y == 2024 ]]; then src=$AR25; loc='第106、111–112页（PDF第107、112–113页）'; fi
  if [[ $y == 2025 ]]; then src=$AR25; loc='第106、111–112页（PDF第107、112–113页）'; fi
  af "${k}_${y}" "$item" "$a" "$y-01-01/$y-12-31" "$src" "$loc"
done

# 各年末经营营运资金与长期经营资产构成；2022 为首个展示年度期初。
for row in \
 '2022 inv 92879000 存货' '2022 ar 83281000 贸易及票据应收款' '2022 prepay 17831000 预付款及其他应收款' '2022 duefrom 5703000 应收关联方' '2022 pledge_cur 27880000 流动受限制存款' '2022 pledge_noncur 2513000 非流动受限制存款' '2022 tradepay 52359000 贸易应付款' '2022 otherpay_total 14660000 其他应付款及应计费用' '2022 project_otherpay 2155000 其他应付款' '2022 dueto 2423000 应付关联方' '2022 ppe 1543000 物业厂房设备' '2022 rou 35446000 使用权资产' '2022 intang 6000 其他无形资产' '2022 lease_cur 1020000 流动租赁负债' '2022 lease_noncur 2225000 非流动租赁负债' \
 '2023 inv 57107000 存货' '2023 ar 84341000 贸易及票据应收款' '2023 prepay 12306000 预付款及其他应收款' '2023 duefrom 5172000 应收关联方' '2023 pledge_cur 16576000 流动受限制存款' '2023 pledge_noncur 1256000 非流动受限制存款' '2023 tradepay 27457000 贸易应付款' '2023 otherpay_total 41664000 其他应付款及应计费用' '2023 project_otherpay 27801000 其他应付款' '2023 dueto 7314000 应付关联方' '2023 ppe 86227000 物业厂房设备' '2023 rou 35295000 使用权资产' '2023 intang 60000 其他无形资产' '2023 lease_cur 1267000 流动租赁负债' '2023 lease_noncur 2343000 非流动租赁负债' \
 '2024 inv 50755000 存货' '2024 ar 101562000 贸易及票据应收款' '2024 prepay 14115000 预付款及其他应收款' '2024 duefrom 1151000 应收关联方' '2024 pledge_cur 17796000 流动受限制存款' '2024 pledge_noncur 0 非流动受限制存款' '2024 tradepay 28988000 贸易应付款' '2024 otherpay_total 70041000 其他应付款及应计费用' '2024 project_otherpay 54386000 其他应付款' '2024 dueto 5494000 应付关联方' '2024 ppe 163817000 物业厂房设备' '2024 rou 33577000 使用权资产' '2024 intang 10000 其他无形资产' '2024 lease_cur 1258000 流动租赁负债' '2024 lease_noncur 1620000 非流动租赁负债' \
 '2025 inv 41708000 存货' '2025 ar 87378000 贸易应收款' '2025 prepay 17479000 预付款及其他应收款（流动及非流动）' '2025 duefrom 1219000 应收关联方' '2025 pledge_cur 19566000 流动受限制存款' '2025 pledge_noncur 0 非流动受限制存款' '2025 tradepay 28039000 贸易应付款' '2025 otherpay_total 387? 其他应付款及应计费用' \
 '2025 dueto 5155000 应付关联方' '2025 ppe 174015000 物业厂房设备' '2025 rou 32225000 使用权资产' '2025 intang 9000 其他无形资产' '2025 lease_cur 1154000 流动租赁负债' '2025 lease_noncur 1004000 非流动租赁负债' '2025 project_otherpay 23644000 工程相关其他及保证应付款' '2025 deferred_income 1200000 递延收入'
do
  set -- $row; y=$1; k=$2; a=$3; item=$4
  # 2025 otherpay_total 在下方用准确金额单列，避免 shell 行的占位值。
  [[ $a == '387?' ]] && continue
  if [[ $y == 2022 || $y == 2023 ]]; then src=$AR23; loc='第83、126页（PDF第84、127页）'; else src=$AR25; loc='第108–109、164页（PDF第109–110、165页）'; fi
  af "${k}_${y}" "$item" "$a" "$y-12-31" "$src" "$loc"
done
af otherpay_total_2025 '其他应付款及应计费用（流动及非流动）' 38819000 '2025-12-31' "$AR25" '第109、164页（PDF第110、165页）'

# 2025 年产品收入、估值桥与股本事实。
af ingredient_rev_2025 '食品配料收入' 379074000 '2025-01-01/2025-12-31' "$AR25" '第7、137页（PDF第8、138页）'
af additive_rev_2025 '食品添加剂收入' 272408000 '2025-01-01/2025-12-31' "$AR25" '第7、137页（PDF第8、138页）'
af cash_2025 '现金及现金等价物' 186819000 '2025-12-31' "$AR25" '第108页（PDF第109页）'
af time_deposit_2025 '定期存款' 30000000 '2025-12-31' "$AR25" '第108页（PDF第109页）'
af fv_investment_2025 '按公允价值计入损益的金融资产（天业创新）' 132751000 '2025-12-31' "$AR25" '第13、108页（PDF第14、109页）'
af debt_cur_2025 '流动计息银行借款' 16189000 '2025-12-31' "$AR25" '第108页（PDF第109页）'
af debt_noncur_2025 '非流动计息银行借款' 80945000 '2025-12-31' "$AR25" '第109页（PDF第110页）'
af shares_2025 '已发行普通股股数' 680000000 '2025-12-31' "$AR25" '第14、46页（PDF第15、47页）'
python3 "$TOOL" add-fact --model "$MODEL" --fact-id fx_hkd_cny_2025 --reported-item '1港元兑人民币中间价' --amount 0.9076 --period '2025-12-31' --currency CNY --scope '人民币汇率' --source '中国人民银行人民币汇率历史数据 https://wzdt.pbc.gov.cn/huilv/llChart19.jsp' --locator '2025-12-31记录'

# 历史经营字段。
for y in 2023 2024 2025; do
  sf historical "$y" revenue "rev_$y" reported '合并损益表收入。' high
  sf historical "$y" cost_of_revenue "cost_$y" reported '合并损益表销售成本。' high
  if [[ $y == 2023 ]]; then opinc='grant_2023 + otherinc_2023'; fi
  if [[ $y == 2024 ]]; then opinc='grant_2024 + otherinc_2024'; fi
  if [[ $y == 2025 ]]; then opinc='otherinc_2025'; fi
  sf historical "$y" period_operating_expenses "sell_$y + admin_$y + impair_$y + otherexp_$y - ($opinc)" formula '销售、行政、应收减值及其他经营费用，扣除政府补助/杂项经营收入；排除利息、联营损益、天业重分类与公允价值收益。' high
  sf historical "$y" cash_tax "taxpaid_$y" reported '现金流量表已付所得税作为经营现金税；非经营现金税影响不重大。' medium
  sf historical "$y" depreciation_amortization "dep_ppe_$y + dep_rou_$y + amort_$y" formula '经营性物业设备、使用权资产折旧及无形资产摊销之和。' high
  if [[ $y == 2023 ]]; then cap='ppe_buy_2023 + int_buy_2023 + lease_principal_2023'; fi
  if [[ $y == 2024 ]]; then cap='ppe_buy_2024 + int_buy_2024 - ppe_proceeds_2024 + lease_principal_2024'; fi
  if [[ $y == 2025 ]]; then cap='ppe_buy_2025 - ppe_proceeds_2025 + lease_principal_2025'; fi
  sf historical "$y" core_business_capex "$cap" formula '创新中心服务既有研发、仓储、物流、办公与现有产品扩张，连同租赁本金按经营租赁口径计入主营资本开支。' medium
  sfe historical "$y" exploratory_business_capex 0 '未见可与现有食品配料/添加剂业务可靠区分的新业务资本开支。' medium '若公司披露生产线或新业务的独立现金投入、商业化路径及当期尚未贡献收入，则重分类。'
  sf historical "$y" operating_cash_flow "ocf_$y - interest_received_$y" formula '从列报经营现金流扣除多余现金产生的银行利息，得到经营业务现金贡献。' high
  sfe historical "$y" after_tax_interest_in_operating_cash_flow 0 '银行借款利息列于融资现金流；租赁采用经营口径，故不向经营现金流加回利息。' high '若后续现金流分类显示融资债务利息包含在经营现金流，则按税后金额加回。'
done

owc_expr() { y=$1; echo "inv_$y + ar_$y + prepay_$y + duefrom_$y + pledge_cur_$y + pledge_noncur_$y - tradepay_$y - (otherpay_total_$y - project_otherpay_$y) - dueto_$y"; }
for y in 2022 2023 2024 2025; do
  sf capital "$y" operating_working_capital "$(owc_expr "$y")" formula '经营应收、存货、预付款、关联方经营往来及受限结算存款，扣除贸易及经营应付款；工程应付款另从长期资产扣除。' medium
  lta="ppe_$y + rou_$y + intang_$y - lease_cur_$y - lease_noncur_$y - project_otherpay_$y"
  [[ $y == 2025 ]] && lta="$lta - deferred_income_2025"
  sf capital "$y" operating_long_term_assets_net "$lta" formula '经营性物业设备、使用权资产和小额无形资产，扣除租赁负债、工程应付款及资产相关递延收入。' medium
  sfe capital "$y" required_cash 50000000 '约覆盖一个月采购与经营费用，并为进口采购、工资及税费结算保留缓冲。' medium '若月度现金低点、供应商付款条件或备用授信证明更低/更高资金需求，则调整。'
  sfe capital "$y" unsupported_intangible_assets 0 '账面其他无形资产极小且为经营软件/权利，不存在重大商誉或无法解释并购溢价。' high '若附注识别重大商誉、客户关系或不服务主业的无形资产，则剔除。'
done
sf historical 2023 operating_working_capital_increase "inv_2023 + ar_2023 + prepay_2023 + duefrom_2023 + pledge_cur_2023 + pledge_noncur_2023 - tradepay_2023 - (otherpay_total_2023 - project_otherpay_2023) - dueto_2023 - (inv_2022 + ar_2022 + prepay_2022 + duefrom_2022 + pledge_cur_2022 + pledge_noncur_2022 - tradepay_2022 - (otherpay_total_2022 - project_otherpay_2022) - dueto_2022)" formula '年末经营性营运资金减年初余额。' medium
sf historical 2024 operating_working_capital_increase "inv_2024 + ar_2024 + prepay_2024 + duefrom_2024 + pledge_cur_2024 + pledge_noncur_2024 - tradepay_2024 - (otherpay_total_2024 - project_otherpay_2024) - dueto_2024 - (inv_2023 + ar_2023 + prepay_2023 + duefrom_2023 + pledge_cur_2023 + pledge_noncur_2023 - tradepay_2023 - (otherpay_total_2023 - project_otherpay_2023) - dueto_2023)" formula '年末经营性营运资金减年初余额。' medium
sf historical 2025 operating_working_capital_increase "inv_2025 + ar_2025 + prepay_2025 + duefrom_2025 + pledge_cur_2025 + pledge_noncur_2025 - tradepay_2025 - (otherpay_total_2025 - project_otherpay_2025) - dueto_2025 - (inv_2024 + ar_2024 + prepay_2024 + duefrom_2024 + pledge_cur_2024 + pledge_noncur_2024 - tradepay_2024 - (otherpay_total_2024 - project_otherpay_2024) - dueto_2024)" formula '年末经营性营运资金减年初余额。' medium

# 稳定状态：收入回到近三年中枢，毛利率按近期18.5%，费用含创新中心投入后的正常组织成本。
sfe stable '' revenue 660000000 '近三年收入6.51–6.84亿元，取6.60亿元中枢，不外推管理层增长目标。' medium '若创新中心投产后连续两年收入显著偏离6.3–7.0亿元且订单证据持续，则重估。'
sfe stable '' cost_of_revenue 537900000 '按18.5%正常毛利率估计，略低于2024年18.98%并接近2025年18.56%。' medium '若高毛利产品占比或供应商采购价使两年毛利率稳定低于17%或高于20%，则重估。'
sfe stable '' period_operating_expenses 64000000 '以2024–2025年剔除非经营收益后的费用约0.64–0.66亿元为锚。' medium '若创新中心投运后的人员、研发、仓储费用连续两年显著改变费用基线，则调整。'
sfe stable '' cash_tax 17430000 '按约30%的正常经营现金税率作用于稳定EBIT。' medium '若税务优惠、递延税回转或地区利润结构使现金税率持续偏离25%–35%，则调整。'
sfe stable '' depreciation_amortization 5000000 '创新中心转固后折旧将高于2025年建设期1.51百万元，取5百万元正常水平。' low '创新中心最终转固金额与折旧年限披露后，以附注折旧替代。'
sfe stable '' core_business_capex 10000000 '建设高峰结束后，按高于正常折旧的1千万元维持、技改及小规模扩张投入。' low '若生产线后续持续需每年超过2千万元现金投入或实际维护资本显著更低，则调整。'
sfe stable '' exploratory_business_capex 0 '没有证据支持把独立新业务投入纳入已验证稳定经营收益。' medium '若披露独立新业务的投入、商业化时间与收入利润，则另行纳入成长路径。'
sfe stable '' operating_working_capital_increase 0 '收入稳定时采用零净新增营运资金，不外推2025年库存和应收释放。' medium '若稳定增长、账期或安全库存要求证明持续新增占用，则调整。'

# 业务树：产品类别互斥并覆盖公司；成本、费用、税及现金贡献为控制数下基准分配。
python3 "$TOOL" add-business --model "$MODEL" --business-id ingredients --name '食品配料分销与配方服务' --importance '收入较大、客户应用广；2025年收入增长但估计毛利率低于添加剂。' --confidence medium --falsifier '若公司披露产品类别毛利或直接成本，与本估计差异超过3个百分点则替换。'
python3 "$TOOL" add-business --model "$MODEL" --business-id additives --name '食品添加剂分销与配方服务' --importance '收入下降但估计单位毛利较高，产品结构变化直接影响集团毛利率。' --confidence low --falsifier '若公司披露产品类别毛利或费用归属，与本估计显著不同则替换。'
sbf() { python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$1" --field "$2" ${3} "$4" --basis-type "$5" --reason "$6" --confidence "$7" ${8:+--falsifier "$8"}; }
sbf ingredients revenue --expression ingredient_rev_2025 reported '年报直接披露食品配料收入。' high
sbf additives revenue --expression additive_rev_2025 reported '年报直接披露食品添加剂收入。' high
sbf ingredients cost_of_revenue --value 318099000 estimate '集团成本为硬约束；假设食品配料毛利率约16.1%，与高毛利产品占比下降的披露一致。' low '产品毛利披露或采购售价数据表明配料毛利率偏离13%–19%。'
sbf additives cost_of_revenue --value 212478000 estimate '以集团成本闭合，隐含食品添加剂毛利率约22.0%。' low '产品毛利披露或采购售价数据表明添加剂毛利率偏离19%–25%。'
sbf ingredients period_operating_expenses --value 38331000 estimate '按收入占比分配共同销售、行政、减值与其他经营净费用。' low '独立人员、仓储、研发或渠道费用披露支持不同分配。'
sbf additives period_operating_expenses --value 27540000 estimate '按收入占比分配共同销售、行政、减值与其他经营净费用，并与公司合计闭合。' low '独立人员、仓储、研发或渠道费用披露支持不同分配。'
sbf ingredients cash_tax --value 7800000 estimate '按两项业务估计EBIT占比分配集团现金税。' low '分业务税务主体、优惠或地区利润披露支持不同税负。'
sbf additives cash_tax --value 11153000 estimate '按两项业务估计EBIT占比分配集团现金税，并与公司合计闭合。' low '分业务税务主体、优惠或地区利润披露支持不同税负。'
sbf ingredients operating_cash_flow_contribution --value 32704000 estimate '按产品收入占比分配调整后经营现金流；缺少分产品回款与库存数据。' low '分产品应收、库存、付款和现金回款披露支持不同分配。'
sbf additives operating_cash_flow_contribution --value 23480000 estimate '按产品收入占比分配调整后经营现金流，并与公司合计闭合。' low '分产品应收、库存、付款和现金回款披露支持不同分配。'

# 普通股价值桥。经营必需现金不再作为多余现金重复计值。
sf equity '' excess_cash 'cash_2025 + time_deposit_2025 - 50000000' formula '现金及定期存款扣除5千万元经营必需现金；受限制存款留在经营资本。' medium
sf equity '' non_operating_assets 'fv_investment_2025' reported '天业投资持有待售且不参与食品配料分销FCFF，按报告日公允价值计入。' high
sf equity '' financing_debt 'debt_cur_2025 + debt_noncur_2025' formula '全部计息银行借款；租赁负债已净入经营长期资产。' high
sfe equity '' minority_interest_value 0 '集团全部权益归母，未披露少数股东。' high '若后续出现非全资并表附属公司，则扣除其经济价值。'
sfe equity '' other_priority_claims 0 '资本承担属于核心创新中心后续投入，已由稳定资本开支口径处理；拟派股息是股东内部转移，不重复扣除。' medium '若资本承担成为不由经营收益覆盖的不可撤销额外索偿，则扣除。'
sf equity '' diluted_shares 'shares_2025' reported '年末及年报最后实际可行日期均为6.8亿股，且无已授出购股权。' high
sf equity '' financial_to_trading_fx '1 / fx_hkd_cny_2025' formula '按2025年末人民币/港元官方中间价换算。' high

python3 "$TOOL" set-valuation --model "$MODEL" --mode benchmark --stable-multiple 8 --safety-margin-ratio 0.6 --reason '缺少创新中心投产后的逐年订单、FCFF和全部成长投入证据，采用稳定经营收益八倍固定标尺。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '剔除天业投资重分类收益' --before '2025年其他收入及收益2,673.7万元' --after '经营口径仅保留其他经营收入30.6万元' --reason '视同处置收益1,628.8万元及公允价值收益956.3万元不由食品配料/添加剂经营资产产生。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '工程应付款净额处理' --before '2025年其他应付款及应计费用3,881.9万元' --after '其中2,364.4万元从创新中心经营长期资产中扣除' --reason '避免尚未支付的工程款同时抬高经营资产和投入资本。'

for item in source_traceability economic_classification stable_state capital_return_interpretability report_consistency; do
  case $item in
    source_traceability) reason='金额均链接至三份法定年报页码或人民银行年末汇率记录。';;
    economic_classification) reason='经营利润剔除融资、联营及天业公允价值收益；工程应付款、租赁和受限资金避免重复分类。';;
    stable_state) reason='稳定状态采用三年收入与利润率中枢，并单独下调建设期资本开支，未机械外推单年增长。';;
    capital_return_interpretability) reason='投入资本分母为正且包含创新中心净资产、经营营运资金和必需现金；业务费用化研发无法单独资本化，ROIC仅作资本占用趋势判断。';;
    report_consistency) reason='报告重大数字、业务闭合和普通股价值桥将由同一结构化模型生成并复核。';;
  esac
  python3 "$TOOL" set-review --model "$MODEL" --item "$item" --passed --reason "$reason"
done

python3 "$TOOL" compile --model "$MODEL"
python3 "$TOOL" validate --model "$MODEL"
python3 "$TOOL" render --model "$MODEL" --output outputs/transcribed-tables.md

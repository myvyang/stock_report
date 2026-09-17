#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

python3 "$tool" init --name '皖能电力' --code '000543.SZ' --period-label '2025年度' --period-end '2025-12-31' --coverage-years '2023,2024,2025' --financial-currency CNY --trading-currency CNY --security-name 'A股普通股' --security-unit '股' --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope consolidated --source "$5" --locator "$6"; }
field_expr() { python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
field_est() { python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }

s23='https://static.cninfo.com.cn/finalpage/2024-04-16/1219625627.PDF'
s24='https://static.cninfo.com.cn/finalpage/2025-04-25/1223278946.PDF'
s25='https://static.cninfo.com.cn/finalpage/2026-04-24/1225170331.PDF'

# 历史经营事实（元）
for row in \
 '2023 rev 27866767123.95 营业收入 P101' '2023 cost 25951975821.71 营业成本 P101' '2023 taxadd 146284782.95 税金及附加 P101' '2023 sales 24435238.55 销售费用 P102' '2023 admin 169986226.96 管理费用 P102' '2023 rd 196666001.55 研发费用 P102' '2023 otherincome 90595167.46 其他收益 P102' '2023 creditloss -8062450.86 信用减值损失 P102' '2023 assetloss -122249767.52 资产减值损失 P102' '2023 disposal 9227059.81 资产处置收益 P102' '2023 interest 835485041.79 利息费用 P102' '2023 dep 1557334824.24 固定资产折旧 P232' '2023 leasedep 8460275.38 使用权资产折旧 P232' '2023 amort 146137450.99 无形资产摊销 P232' '2023 ltamort 5255470.04 长期待摊费用摊销 P232' '2023 ocf 1695722034.59 经营活动产生的现金流量净额 P105' '2023 capexgross 6544747297.44 购建固定资产无形资产和其他长期资产支付的现金 P106' '2023 disposalcash 18972088.11 处置长期资产收回的现金净额 P105' \
 '2024 rev 30093871084.44 营业收入 P101' '2024 cost 26466553011.30 营业成本 P101' '2024 taxadd 174395079.95 税金及附加 P101' '2024 sales 19609213.18 销售费用 P102' '2024 admin 186486913.38 管理费用 P102' '2024 rd 182166327.43 研发费用 P102' '2024 otherincome 78614056.80 其他收益 P102' '2024 creditloss -1424324.33 信用减值损失 P102' '2024 assetloss -120434535.78 资产减值损失 P102' '2024 disposal -5773482.35 资产处置收益 P102' '2024 interest 861521624.96 利息费用 P102' '2024 dep 1912757078.83 固定资产折旧 P232' '2024 leasedep 7216808.22 使用权资产折旧 P232' '2024 amort 156355126.79 无形资产摊销 P232' '2024 ltamort 5133442.37 长期待摊费用摊销 P232' '2024 ocf 3757230590.57 经营活动产生的现金流量净额 P105' '2024 capexgross 5597043276.65 购建固定资产无形资产和其他长期资产支付的现金 P106' '2024 disposalcash 14945658.64 处置长期资产收回的现金净额 P105' \
 '2025 rev 27305760344.59 营业收入 P87' '2025 cost 22863271346.52 营业成本 P87' '2025 taxadd 330147087.56 税金及附加 P87' '2025 sales 19592443.13 销售费用 P87' '2025 admin 215096950.50 管理费用 P87' '2025 rd 213127853.14 研发费用 P87' '2025 otherincome 80229278.37 其他收益 P87' '2025 creditloss -12660529.70 信用减值损失 P87' '2025 assetloss -113875585.94 资产减值损失 P87' '2025 disposal 12743544.61 资产处置收益 P88' '2025 interest 811129587.74 利息费用 P87' '2025 dep 2222539309.15 固定资产折旧 P196' '2025 leasedep 7180435.09 使用权资产折旧 P196' '2025 amort 181668081.29 无形资产摊销 P196' '2025 ltamort 4188273.23 长期待摊费用摊销 P196' '2025 ocf 5390412751.81 经营活动产生的现金流量净额 P91' '2025 capexgross 3247320956.20 购建固定资产无形资产和其他长期资产支付的现金 P91' '2025 disposalcash 7229869.70 处置长期资产收回的现金净额 P91'; do
  read -r y id amt item loc <<<"$row"; src="$s25"; [[ "$y" == 2023 ]] && src="$s24"; [[ "$y" == 2024 ]] && src="$s24"; fact "f${y}_${id}" "$item" "$amt" "$y" "$src" "$loc"
done

for y in 2023 2024 2025; do
  field_expr historical "$y" revenue "f${y}_rev" reported '合并利润表营业收入。' high
  field_expr historical "$y" cost_of_revenue "f${y}_cost" reported '合并利润表营业成本。' high
  field_expr historical "$y" period_operating_expenses "f${y}_taxadd+f${y}_sales+f${y}_admin+f${y}_rd-f${y}_otherincome-f${y}_creditloss-f${y}_assetloss-f${y}_disposal" formula '税金及附加、销售、管理、研发费用，扣其他收益并纳入经营减值和资产处置净影响；剔除财务费用与投资收益。' medium
  field_expr historical "$y" depreciation_amortization "f${y}_dep+f${y}_leasedep+f${y}_amort+f${y}_ltamort" formula '现金流量表补充资料中的经常性折旧摊销合计。' high
  field_expr historical "$y" core_business_capex "f${y}_capexgross-f${y}_disposalcash" formula '长期资产购建现金支出扣处置回款；项目均围绕发电、热力及新能源等既有经营边界。' medium
  field_est historical "$y" exploratory_business_capex 0 '未识别出氨能、聚变等前沿方向单独形成的重大现金资本开支，研发费用已计入经营费用。' medium '若后续项目资本预算披露前沿技术单独重大长期资产支出，则重分类。'
  field_expr historical "$y" operating_cash_flow "f${y}_ocf" reported '合并现金流量表经营活动现金流量净额。' high
done

field_est historical 2023 cash_tax 202000000 '按重构EBIT约15%的正常经营现金税率估计；利润表所得税受权益法投资收益与税务差异影响，不能直接照搬。' medium '若子公司税务附注可将利息税盾、递延税与权益法免税影响完整拆分，则替换。'
field_est historical 2024 cash_tax 500000000 '按重构EBIT约16.6%的正常经营现金税率估计，与当年所得税费用交叉核对。' medium '若税务附注给出经营所得现金税完整拆分，则替换。'
field_est historical 2025 cash_tax 650000000 '按重构EBIT约17.9%的正常经营现金税率估计，略高于利润表所得税费用以还原利息税盾。' medium '若税务附注给出经营所得现金税完整拆分，则替换。'
field_expr historical 2023 after_tax_interest_in_operating_cash_flow 'f2023_interest*0.8500292214' formula '经营现金流含利息支出，按估计经营税率税后加回。' medium
field_expr historical 2024 after_tax_interest_in_operating_cash_flow 'f2024_interest*0.8341978398' formula '经营现金流含利息支出，按估计经营税率税后加回。' medium
field_expr historical 2025 after_tax_interest_in_operating_cash_flow 'f2025_interest*0.8209840498' formula '经营现金流含利息支出，按估计经营税率税后加回。' medium
field_est historical 2023 operating_working_capital_increase 456208347.61 '以NOPAT+折旧摊销-经营现金流-税后利息加回反推，确保融资前现金流两条路径闭合。' medium '若经营性现金流附注能完整拆除税费、非现金及一次性项目，则改用逐科目营运资金变动。'
field_est historical 2024 operating_working_capital_increase 121194640.69 '以NOPAT+折旧摊销-经营现金流-税后利息加回反推，确保融资前现金流两条路径闭合。' medium '若经营性现金流附注能完整拆除税费、非现金及一次性项目，则改用逐科目营运资金变动。'
field_est historical 2025 operating_working_capital_increase -659799735.82 '以NOPAT+折旧摊销-经营现金流-税后利息加回反推；负数表示回款及库存释放超过经营应付款下降。' medium '若经营性现金流附注能完整拆除税费、非现金及一次性项目，则改用逐科目营运资金变动。'

# 资本存量：营运资金按经营性流动资产减经营性无息负债；长期资产净额为固定资产、在建工程、使用权/无形及其他经营长期资产扣递延收益。
field_est capital 2022 operating_working_capital -2710000000 '按2023年报比较期经营性流动项目重分类的基准点。' medium '若应付票据或其他应付款中融资性质项目的完整明细改变分类，则更新。'
field_est capital 2023 operating_working_capital -149000000 '按2023年末经营性应收、存货、预付及其他流动资产减经营性无息负债重分类。' medium '若应付票据或其他应付款中融资性质项目的完整明细改变分类，则更新。'
field_est capital 2024 operating_working_capital 2441000000 '按2024年末经营性应收、存货、预付及其他流动资产减经营性无息负债重分类。' medium '若应付票据或其他应付款中融资性质项目的完整明细改变分类，则更新。'
field_est capital 2025 operating_working_capital 1885000000 '按2025年末经营性应收、存货、预付及其他流动资产减经营性无息负债重分类。' medium '若应付票据或其他应付款中融资性质项目的完整明细改变分类，则更新。'
field_est capital 2022 operating_long_term_assets_net 31742000000 '固定资产、在建工程、使用权资产、无形资产及其他经营长期资产扣递延收益；剔除商誉、权益投资和递延税。' medium '若项目资产中含待处置或非经营土地，或递延收益归属变化，则更新。'
field_est capital 2023 operating_long_term_assets_net 34413000000 '固定资产、在建工程、使用权资产、无形资产及其他经营长期资产扣递延收益；剔除商誉、权益投资和递延税。' medium '若项目资产中含待处置或非经营土地，或递延收益归属变化，则更新。'
field_est capital 2024 operating_long_term_assets_net 37308000000 '固定资产、在建工程、使用权资产、无形资产及其他经营长期资产扣递延收益；剔除商誉、权益投资和递延税。' medium '若项目资产中含待处置或非经营土地，或递延收益归属变化，则更新。'
field_est capital 2025 operating_long_term_assets_net 38485000000 '固定资产、在建工程、使用权资产、无形资产及其他经营长期资产扣递延收益；剔除商誉、权益投资和递延税。' medium '若项目资产中含待处置或非经营土地，或递延收益归属变化，则更新。'
for pair in '2022 2000000000' '2023 2200000000' '2024 2300000000' '2025 2100000000'; do read -r y v <<<"$pair"; field_est capital "$y" required_cash "$v" '约一个月现金经营支出的流动性缓冲，结合电煤采购、工资税费和结算规模估计。' low '若月度现金支出、最低现金或受限资金明细披露，则据其替换。'; field_est capital "$y" unsupported_intangible_assets 0 '商誉未纳入经营性长期资产净额，避免重复扣除；经营性无形资产为土地使用权等生产必需项目。' medium '若经营性长期资产重分类重新纳入商誉或无法解释并购溢价，则本项相应扣除。'; done

# 稳定期基准（亿元级建设周期结束后的代表状态）
field_est stable '' revenue 28000000000 '以2023-2025收入区间和新增装机部分贡献为锚，煤炭贸易收缩抵消部分发电扩张。' medium '若新机组稳定利用小时、电价或煤炭贸易规模偏离当前区间10%以上，则重估。'
field_est stable '' cost_of_revenue 23240000000 '按约17%的正常毛利率估计；新增风光全年贡献和容量电价略抬升结构性毛利，同时不外推煤价单边下降。' medium '若燃煤成本、容量电价和新能源占比使三年正常毛利率显著偏离17%，则重估。'
field_est stable '' period_operating_expenses 800000000 '接近2025年重构经营费用，保留研发、管理及正常减值负担。' medium '若新并购项目使总部/运维固定费用显著改变，则重估。'
field_est stable '' cash_tax 750000000 '按稳定EBIT约18.9%的经营现金税率估计。' medium '若税收优惠到期或子公司盈利地域结构改变，则重估。'
field_est stable '' depreciation_amortization 2500000000 '基于2025年24.16亿元折旧摊销并考虑新增资产全年化。' medium '若2026年新增项目转固后折旧显著超出25亿元，则重估。'
field_est stable '' core_business_capex 2200000000 '建设高峰消退后，以接近折旧但略低的常态更新、环保技改和既有业务扩建现金投入估计。' low '若未来三年长期资产购建现金支出持续显著高于30亿元，则该稳定假设失效。'
field_est stable '' exploratory_business_capex 0 '前沿氨能、聚变等尚无可验证稳定商业化投入路径，不在稳定经营收益中赋值。' medium '若形成已批准、可量化的独立资本预算与订单路径，则单列。'
field_est stable '' operating_working_capital_increase 0 '稳定、不增长状态下不假设永久新增营运资金。' medium '若结算规则或煤炭库存要求造成结构性持续占用，则加入。'

# 2025业务树直接闭合披露产品行；费用按毛利、税和现金流按经营利润比例分配。
for row in 'power 发电与售电 23451689115.81 19325386612.12 high' 'coal 煤炭贸易 3110940532.73 3080649593.52 high' 'transport 运输物流 409086516.86 345146641.88 high' 'waste 环保垃圾处理 274975164.92 71435102.10 high' 'services 建造与能源技术服务 59069014.27 40653396.90 medium'; do
 read -r id name rev cost conf <<<"$row"
 fact "f2025_b_${id}_rev" "${name}收入" "$rev" 2025 "$s25" 'P186-P187'
 fact "f2025_b_${id}_cost" "${name}成本" "$cost" 2025 "$s25" 'P186-P187'
 python3 "$tool" add-business --model "$model" --business-id "$id" --name "$name" --importance '具名产品业务；按客户、定价和成本逻辑解释2025年经营结构。' --confidence "$conf" --falsifier '若公司披露分部费用、税费或现金流，应替换当前分配估计。'
 python3 "$tool" set-business-field --model "$model" --business-id "$id" --field revenue --expression "f2025_b_${id}_rev" --basis-type reported --reason '2025年报营业收入分解。' --confidence high
 python3 "$tool" set-business-field --model "$model" --business-id "$id" --field cost_of_revenue --expression "f2025_b_${id}_cost" --basis-type reported --reason '2025年报营业成本分解。' --confidence high
done
for row in \
 'power 753768547.43 603737370.78 5006759418.74' 'coal 5533369.70 4431999.83 36754320.62' 'transport 11680158.36 9355322.83 77583156.11' 'waste 37181495.38 29780837.02 246970774.85' 'services 3364056.12 2694469.54 22345081.49'; do
 read -r id exp tax cf <<<"$row"
 for spec in "period_operating_expenses $exp 按各业务毛利占比分配公司经营费用。" "cash_tax $tax 按各业务经营利润占比分配经营现金税。" "operating_cash_flow_contribution $cf 按各业务NOPAT占比分配公司经营现金流。"; do read -r key val reason <<<"$spec"; python3 "$tool" set-business-field --model "$model" --business-id "$id" --field "$key" --value "$val" --basis-type estimate --reason "$reason" --confidence low --falsifier '若公司披露分业务费用、税或现金流，应以披露替换。'; done
done

# 价值桥事实
fact f2025_cash '货币资金' 3798916130.58 '2025-12-31' "$s25" P82
fact f2025_restricted '保证金等受限货币资金' 34304966.82 '2025-12-31' "$s25" P131
fact f2025_ltie '长期股权投资' 15076867948.67 '2025-12-31' "$s25" P83
fact f2025_oei '其他权益工具投资' 4534063787.25 '2025-12-31' "$s25" P83
fact f2025_ip '投资性房地产' 12396585.54 '2025-12-31' "$s25" P83
fact f2025_divrecv '应收股利' 88608121.10 '2025-12-31' "$s25" P82
for row in 'stdebt 短期借款 3951260584.69 P83' 'currentltdebt 一年内到期的长期借款 6436791739.66 P181' 'currentbond 一年内到期的应付债券 42102082.28 P181' 'currentlease 一年内到期的租赁负债 2450887.63 P181' 'shortbond 短期应付债券 1410728383.54 P181' 'ltdebt 长期借款 20752822051.08 P84' 'bond 应付债券 5050000000 P84' 'lease 租赁负债 40667301.58 P84'; do read -r id item amt loc <<<"$row"; fact "f2025_${id}" "$item" "$amt" '2025-12-31' "$s25" "$loc"; done
fact f2025_minority '少数股东权益' 8813398722.99 '2025-12-31' "$s25" P84
fact f2025_shares '期末普通股股本股数' 2266863331 '2025-12-31' "$s25" P84

field_est equity '' excess_cash 1664615032.76 '货币资金扣约21亿元经营必需现金及3430万元受限保证金；未再扣未支付2025年度拟派股息，因该股息尚待股东会且价值归普通股股东。' low '若资本承诺或受限资金明细显示不可动用金额更高，则下调。'
field_expr equity '' non_operating_assets 'f2025_ltie+f2025_oei+f2025_ip+f2025_divrecv' formula '权益法投资、其他权益工具、投资性房地产及应收股利未进入经营FCFF，按账面金额计入。' medium
field_expr equity '' financing_debt 'f2025_stdebt+f2025_currentltdebt+f2025_currentbond+f2025_currentlease+f2025_shortbond+f2025_ltdebt+f2025_bond+f2025_lease' formula '计息借款、债券和租赁负债，避免把经营应付款重复扣除。' high
field_expr equity '' minority_interest_value 'f2025_minority' reported '缺少逐家非全资子公司可验证估值，暂以少数股东账面权益作为替代。' low
field_est equity '' other_priority_claims 0 '未识别出未包含在债务、经营负债或FCFF中的优先股、已宣告未付股息等重大优先索偿。' medium '若股东会批准的股息在估值时点已形成负债，或新增优先工具，则扣除。'
field_expr equity '' diluted_shares 'f2025_shares' reported '无股权激励或可转债等潜在摊薄工具，使用期末普通股股数。' high

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '新增装机、并购与市场化电价尚不足以可靠给出逐年FCFF和稳定到达时间，使用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '权益投资与经营分离' --before '长期股权投资及其他权益工具留在总资产' --after '合计约196.1亿元作为非经营资产单独加回' --reason '相关投资收益已从EBIT剔除，资产必须在价值桥单独计值，避免遗漏或重复。'
python3 "$tool" add-adjustment --model "$model" --name '少数股东替代计值' --before '少数股东账面权益88.13亿元' --after '暂按88.13亿元扣除' --reason '合并经营收益覆盖100%子公司，但缺乏逐家少数权益经济价值资料；账面值是可核验替代，可能低估或高估。'

for spec in \
 'source_traceability 原始财务事实均记录披露名称、期间、合并范围、公开年报链接与页码。' \
 'economic_classification 经营利润剔除融资与投资收益，经营、非经营资产和融资负债未重复计算。' \
 'stable_state 稳定期参数结合三年收入、利润率、折旧与建设高峰形成，且列出关键推翻条件。' \
 'capital_return_interpretability 投入资本边界可比但经营必需现金和部分负债分类为估计，ROIC仅用于观察资本占用改善，不作为竞争壁垒证明。' \
 'report_consistency 报告重大数字、业务闭合和价值桥均以编译后的结构化模型为准。'; do read -r item reason <<<"$spec"; python3 "$tool" set-review --model "$model" --item "$item" --passed --reason "$reason"; done

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

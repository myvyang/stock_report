#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name 天原股份 --code 002386.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency CNY --trading-currency CNY --security-name 普通股 --security-unit 股 --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope 合并 --source "$5" --locator "$6"; }
field_expr() { python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
field_est() { python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }

src23="天原股份2023年年度报告（2024-04-29）"
url23="https://static.cninfo.com.cn/finalpage/2024-04-29/1219859860.PDF"
src24="天原股份2024年年度报告（2025-04-25）"
url24="https://static.cninfo.com.cn/finalpage/2025-04-25/1223266967.PDF"
src25="天原股份2025年年度报告（2026-03-27）"
url25="https://static.cninfo.com.cn/finalpage/2026-03-27/1225033568.PDF"

# Historical operating facts, raw yuan.
fact rev23 营业收入 18366700105.94 2023 "$src24" "$url24#page=115"
fact cost23 营业成本 17767002040.87 2023 "$src24" "$url24#page=115"
fact opex23 重构期间经营费用 646885202.06 2023 "$src24" "$url24#page=115"
fact da23 折旧摊销合计 487324162.72 2023 "$src24" "$url24#page=201"
fact ocf23 经营活动现金流量净额 363136022.49 2023 "$src24" "$url24#page=118"
fact capex23 购建长期资产现金支出 1767605750.91 2023 "$src24" "$url24#page=118"
fact disposal23 处置长期资产现金回款 13826121.07 2023 "$src24" "$url24#page=118"
fact exploratory23 新能源重大项目投入 1102884590.32 2023 "$src23" "$url23#page=30"

fact rev24 营业收入 13367089763.71 2024 "$src24" "$url24#page=114"
fact cost24 营业成本 13024393277.91 2024 "$src24" "$url24#page=114"
fact opex24 重构期间经营费用 747880196.04 2024 "$src24" "$url24#page=115"
fact da24 折旧摊销合计 527149531.43 2024 "$src24" "$url24#page=201"
fact ocf24 经营活动现金流量净额 229782561.03 2024 "$src24" "$url24#page=118"
fact capex24 购建长期资产现金支出 1263320446.62 2024 "$src24" "$url24#page=118"
fact disposal24 处置长期资产现金回款 23017144.00 2024 "$src24" "$url24#page=118"
fact exploratory24 新能源重大项目投入 713958702.55 2024 "$src24" "$url24#page=27"

fact rev25 营业收入 11298928753.73 2025 "$src25" "$url25#page=112"
fact cost25 营业成本 10382867802.53 2025 "$src25" "$url25#page=112"
fact opex25 重构期间经营费用 733863885.83 2025 "$src25" "$url25#page=112"
fact da25 折旧摊销合计 579738483.70 2025 "$src25" "$url25#page=197"
fact ocf25 经营活动现金流量净额 -231505485.74 2025 "$src25" "$url25#page=115"
fact capex25 购建长期资产现金支出 1055156138.79 2025 "$src25" "$url25#page=115"
fact disposal25 处置长期资产现金回款 229268996.85 2025 "$src25" "$url25#page=115"
fact exploratory25 新能源重大项目投入 551636505.63 2025 "$src25" "$url25#page=29"

for y in 2023 2024 2025; do
  yy="${y:2:2}"
  field_expr historical "$y" revenue "rev$yy" reported "合并利润表营业收入。" high
  field_expr historical "$y" cost_of_revenue "cost$yy" reported "合并利润表营业成本。" high
  field_expr historical "$y" period_operating_expenses "opex$yy" formula "税金及附加、销售、管理、研发费用，扣除经营性其他收益并加回信用及资产减值后的净经营费用；剔除财务费用、投资、公允价值、处置及营业外项目。" medium
  field_expr historical "$y" depreciation_amortization "da$yy" formula "现金流量表补充资料中的固定资产、使用权资产折旧及无形资产、长期待摊费用摊销合计。" high
  field_expr historical "$y" operating_cash_flow "ocf$yy" reported "合并现金流量表经营活动现金流量净额。" high
  field_expr historical "$y" exploratory_business_capex "exploratory$yy" formula "以披露的新能源正极材料及前驱体重大项目当年投入作为开拓性资本开支基准。" medium
  field_expr historical "$y" core_business_capex "capex$yy-disposal$yy-exploratory$yy" formula "净长期资产现金支出扣除新能源开拓性项目投入；包括传统主业维持、扩张、矿山及配套工程。" medium
  field_est historical "$y" after_tax_interest_in_operating_cash_flow 0 "利息支付在筹资活动列报，经营现金流口径不再加回税后利息。" high "若现金流附注明确将重大利息支付列入经营活动，则需改列。"
done

field_est historical 2023 cash_tax 0 "重构EBIT为负，经营现金税取零，不把非经营投资收益相关所得税倒灌主业。" medium "若税务附注可将当年已付所得税明确归属正EBIT经营主体，则应上调。"
field_est historical 2024 cash_tax 0 "重构EBIT为负，经营现金税取零。" medium "若税务附注可将当年已付所得税明确归属正EBIT经营主体，则应上调。"
field_est historical 2025 cash_tax 27329563.07 "按2025年重构EBIT的15%估计，匹配西部开发及高新技术主体主要适用税率。" medium "若主要盈利主体不再满足15%优惠或经营税款归属显示显著不同，应重估。"
field_est historical 2023 operating_working_capital_increase 77060117.74 "以NOPAT+折旧摊销-经营现金流反推综合经营性应计占用，保证利润路径与现金流路径闭合。" medium "若能逐项拆清经营应收应付、非现金减值及税款变动，应以逐项重构替代。"
field_est historical 2024 operating_working_capital_increase -107817122.56 "以NOPAT+折旧摊销-经营现金流反推综合经营性应计释放。" medium "若能逐项拆清经营应收应付、非现金减值及税款变动，应以逐项重构替代。"
field_est historical 2025 operating_working_capital_increase 966110915.94 "以NOPAT+折旧摊销-经营现金流反推综合经营性应计占用；方向与新能源销售应收未回款披露一致。" medium "若新能源应收在期后快速回收且逐项现金流重构显示占用较低，应下调。"

# Capital facts and classifications, all in yuan. Working capital is selected operating current assets less selected operating current liabilities.
for row in \
"2022|-737229697.13|9358892715.11|1000000000|115853971.60" \
"2023|-1019226768.95|11026244869.77|1200000000|115853971.60" \
"2024|-1303317569.65|11915792336.02|1000000000|115853971.60" \
"2025|-534578266.51|12360829805.46|800000000|115853971.60"; do
  IFS='|' read -r y wc lta cash goodwill <<< "$row"
  case "$y" in
    2022|2023) cap_src="$src23"; cap_url="$url23"; cap_page=120 ;;
    2024) cap_src="$src24"; cap_url="$url24"; cap_page=110 ;;
    2025) cap_src="$src25"; cap_url="$url25"; cap_page=107 ;;
  esac
  fact "wc$y" 经营性营运资金 "$wc" "$y-12-31" "$cap_src" "$cap_url#page=$cap_page"
  fact "lta$y" 经营性长期资产净额含商誉 "$lta" "$y-12-31" "$cap_src" "$cap_url#page=$cap_page"
  fact "goodwill$y" 商誉 "$goodwill" "$y-12-31" "$cap_src" "$cap_url#page=$cap_page"
  field_expr capital "$y" operating_working_capital "wc$y" formula "经营应收、票据融资、预付、存货及其他经营流动资产减应付票据、应付账款、合同负债、职工税费及其他经营流动负债。" medium
  field_expr capital "$y" operating_long_term_assets_net "lta$y" formula "固定资产、在建工程、使用权资产、无形资产、商誉、长期待摊和其他经营非流动资产，扣除资产相关递延收益。" medium
  field_est capital "$y" required_cash "$cash" "按约一个月采购、人工、税费及结算缓冲估计；2023建设高峰取较高值，2025随收入收缩下调。" low "月度资金计划、最低现金制度或季节性数据可直接推翻该估计。"
  field_expr capital "$y" unsupported_intangible_assets "goodwill$y" formula "商誉未能由稳定经营收益单独解释，按全额剔除。" high
done

# Stable benchmark state.
field_est stable "" revenue 12000000000 "以2025年112.99亿元为低位基准，允许钛白粉及锂电已投产产能温和爬坡，但不采用管理层远期产能规划。" medium "若两年内产销量、客户认证或价格不足以支持120亿元收入，应下调。"
field_est stable "" cost_of_revenue 10800000000 "采用10%正常毛利率，介于2025年8.11%和新增产能改善后的谨慎水平。" low "若氯碱、钛白粉或磷酸铁锂长期价格成本差使毛利率低于8%，应上调成本。"
field_est stable "" period_operating_expenses 720000000 "以2023-2025重构经营费用7亿元左右为锚，假设减值回归但扩张组织费用仍存在。" medium "若持续发生重大减值、停工损失或费用率超过历史区间，应上调。"
field_est stable "" cash_tax 72000000 "按稳定EBIT 4.8亿元的15%计算，反映主要经营子公司税收优惠。" medium "税收优惠到期或盈利主体迁移至25%税率将上调税负。"
field_est stable "" depreciation_amortization 580000000 "以2025年折旧摊销5.80亿元为锚，已投产资产全年运行。" medium "新项目转固使年度折旧显著超过6亿元时应上调。"
field_est stable "" core_business_capex 600000000 "以折旧摊销略高水平作为传统主业和已投产业务正常维持及小规模扩张投入。" low "若环保、安全、矿山或钛白粉扩建持续要求超过8亿元现金投入，应上调。"
field_est stable "" exploratory_business_capex 0 "固定估值标尺不把尚未验证的新建项目持续投入计入稳定收益，也不给这些项目单独价值。" medium "若董事会已承诺且不可撤回的持续开拓投入存在，应在稳定现金流中计入。"
field_est stable "" operating_working_capital_increase 50000000 "稳定收入温和增长下保留0.5亿元正常营运资金新增占用。" low "若供应商票据融资可持续覆盖新增应收，或业务完全停止增长，应降至零。"

# Equity bridge at 2025-12-31.
fact cash25 货币资金 2500560364.71 2025-12-31 "$src25" "$url25#page=107"
fact restricted25 受限货币资金 1147074079.69 2025-12-31 "$src25" "$url25#page=155"
fact nonop25 长期股权及权益工具等非经营投资 1209843701.47 2025-12-31 "$src25" "$url25#page=107"
fact debt25 融资负债 7869130171.52 2025-12-31 "$src25" "$url25#page=108"
fact minority25 少数股东权益 85340230.95 2025-12-31 "$src25" "$url25#page=109"
fact shares25 期末普通股股数 1301647073 2025-12-31 "$src25" "$url25#page=109"
field_est equity "" excess_cash 553486285.02 "货币资金扣除受限资金及8亿元经营必需现金；不对受限保证金重复计值。" medium "若保证金可无条件释放或最低经营现金显著不同，应调整。"
field_expr equity "" non_operating_assets nonop25 formula "长期股权投资、其他权益工具和小额交易性金融资产按账面净额计值；其投资收益已从经营EBIT剔除。" medium
field_expr equity "" financing_debt debt25 formula "短期借款、一年内到期非流动负债、长期借款、应付债券及融资租赁/长期应付款合计。" high
field_est equity "" minority_interest_value 85340230.95 "子公司分部价值资料不足，以少数股东账面权益作替代。" low "若可取得少数股东对应子公司的独立FCFF估值，应替换账面值。"
field_est equity "" other_priority_claims 0 "未识别到上述债务之外的优先股、已宣告未付重大股息或独立重大优先索偿。" medium "若期后出现已承诺未支付的重大建设款或优先索偿，应计入。"
field_expr equity "" diluted_shares shares25 reported "报告期末无实质摊薄工具，使用期末普通股股数。" high

# Latest-year product businesses. Revenue and cost are directly disclosed; operating expense, tax and OCF are bounded estimates that reconcile to company totals.
python3 "$tool" add-business --model "$model" --business-id ps --name 聚苯乙烯 --importance "收入占比30%，但2025年毛利接近零。" --confidence medium --falsifier "若内部转售使产品口径并非独立经济业务，则应与供应链合并重构。"
python3 "$tool" add-business --model "$model" --business-id chlor --name 氯碱化工 --importance "传统核心现金与利润来源，烧碱高负荷运行。" --confidence medium --falsifier "若PVC与烧碱成本无法在联产品体系合理归集，应拆分联产品利润。"
python3 "$tool" add-business --model "$model" --business-id titanium --name 钛化工 --importance "氯化法钛白粉产销量增长且2025年转盈。" --confidence medium --falsifier "若新增10万吨项目资本与盈利边界变化，应单独重估。"
python3 "$tool" add-business --model "$model" --business-id lithium --name 磷酸铁锂材料 --importance "收入翻倍但毛利仅2.97%，仍处客户导入和爬坡期。" --confidence medium --falsifier "若客户结构、结算价或产线良率披露显示已稳定盈利，应上调。"
python3 "$tool" add-business --model "$model" --business-id polymer --name 高分子材料及水泥 --importance "规模较小但持续亏损并占用经营资产。" --confidence low --falsifier "若地板资产处置或产品结构调整使亏损业务退出，应重构。"
python3 "$tool" add-business --model "$model" --business-id supply --name 供应链与出口 --importance "连接原料采购和产品出口，收入大幅收缩但仍有正毛利。" --confidence low --falsifier "若贸易收入扣除口径显示大部分无商业实质，应进一步剔除。"

setbiz() {
  if [[ "$4" == reported ]]; then
    local fid="biz_${1}_${2}"
    fact "$fid" "2025分产品${2}" "$3" 2025 "$src25" "$url25#page=190"
    python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$fid" --basis-type reported --reason "$5" --confidence "$6"
  else
    python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}
  fi
}
setbiz ps revenue 3436154583.75 reported "2025年报分产品披露。" high
setbiz ps cost_of_revenue 3437726996.74 reported "2025年报分产品披露。" high
setbiz ps period_operating_expenses 210000000 estimate "按生产组织、销售与减值负担分配，保持公司费用闭合。" low "分产品管理账费用可推翻。"
setbiz ps cash_tax 0 estimate "经营亏损不计经营现金税。" medium "独立主体应税利润可推翻。"
setbiz ps operating_cash_flow_contribution -110000000 estimate "零毛利且库存/结算占用，估计为净流出。" low "分产品现金回款数据可推翻。"

setbiz chlor revenue 3224260360.17 reported "2025年报分产品披露。" high
setbiz chlor cost_of_revenue 2708610369.04 reported "2025年报分产品披露。" high
setbiz chlor period_operating_expenses 170000000 estimate "高负荷成熟装置承担主要安全环保和管理费用。" low "分部费用表可推翻。"
setbiz chlor cash_tax 18000000 estimate "将公司经营税主要分配至正EBIT业务。" low "纳税主体税表可推翻。"
setbiz chlor operating_cash_flow_contribution 200000000 estimate "海丰和锐盈利且成熟，作为主要正现金贡献。" low "子公司现金流量表可推翻。"

setbiz titanium revenue 1495899390.73 reported "2025年报分产品披露。" high
setbiz titanium cost_of_revenue 1311621601.88 reported "2025年报分产品披露。" high
setbiz titanium period_operating_expenses 120000000 estimate "按独立制造、研发和销售组织负担估计。" low "分部费用表可推翻。"
setbiz titanium cash_tax 3300000 estimate "按正EBIT业务分配公司经营现金税。" low "纳税主体税表可推翻。"
setbiz titanium operating_cash_flow_contribution 30000000 estimate "产销扩张且转盈，估计小幅正现金贡献。" low "子公司现金流量表可推翻。"

setbiz lithium revenue 1090693426.08 reported "2025年报分产品披露。" high
setbiz lithium cost_of_revenue 1058257174.43 reported "2025年报分产品披露。" high
setbiz lithium period_operating_expenses 115000000 estimate "处于产线爬坡、客户验证和研发投入期，费用率高于成熟业务。" low "分部费用表可推翻。"
setbiz lithium cash_tax 0 estimate "估计经营亏损，不计经营现金税。" medium "独立主体应税利润可推翻。"
setbiz lithium operating_cash_flow_contribution -120000000 estimate "年报明确新能源应收未回款导致经营现金流出。" low "2026年应收快速回收可推翻。"

setbiz polymer revenue 396461160.26 reported "2025年报分产品披露。" high
setbiz polymer cost_of_revenue 409617868.26 reported "2025年报分产品披露。" high
setbiz polymer period_operating_expenses 53863885.83 estimate "以天亿新材料亏损和资产减值为依据分配。" low "业务退出或分部费用表可推翻。"
setbiz polymer cash_tax 0 estimate "估计经营亏损，不计经营现金税。" medium "独立主体应税利润可推翻。"
setbiz polymer operating_cash_flow_contribution -71505485.74 estimate "负毛利与亏损主体对应现金消耗，作为闭合估计。" low "子公司现金流量表可推翻。"

setbiz supply revenue 1655459832.74 reported "2025年报分产品披露。" high
setbiz supply cost_of_revenue 1457033792.18 reported "2025年报分产品披露。" high
setbiz supply period_operating_expenses 65000000 estimate "轻资产贸易与出口组织费用按收入规模及子公司亏损分配。" low "分部费用表可推翻。"
setbiz supply cash_tax 6029563.07 estimate "余额法闭合公司经营现金税；包含集团内盈利贸易及矿电协同主体税负。" low "纳税主体税表可推翻。"
setbiz supply operating_cash_flow_contribution -160000000 estimate "贸易结算与应收占用估计为主要负现金贡献之一。" low "分部现金流量表可推翻。"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "新能源与钛化工扩建仍在爬坡，缺少到达稳定状态前逐年FCFF和全部投入的充分证据，采用稳定经营收益八倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "黄磷产能指标处置" --before "资产处置收益1.83亿元" --after "从核心经营EBIT剔除" --reason "公开挂牌出售2.5万吨/年黄磷产能指标形成的一次性收益，不代表持续经营能力；若未来形成可重复指标处置模式才应重估。"
python3 "$tool" add-adjustment --model "$model" --name "商誉" --before "账面1.16亿元" --after "经营投入资本中全额剔除" --reason "现有稳定经营收益无法单独解释收购溢价；若对应资产组形成可验证超额FCFF可恢复。"
python3 "$tool" add-adjustment --model "$model" --name "受限及必需现金" --before "货币资金25.01亿元" --after "仅5.53亿元计入多余现金" --reason "扣除11.47亿元保证金等受限资金和8亿元经营结算缓冲；最低现金或保证金释放证据会改变该值。"

for item in source_traceability economic_classification stable_state capital_return_interpretability report_consistency; do
  case "$item" in
    source_traceability) reason="重大原始金额均保存年报名称、日期、页码及公开PDF链接。";;
    economic_classification) reason="经营收益剔除融资、投资、处置与营业外项目；现金、投资和债务分类避免重复。";;
    stable_state) reason="稳定状态结合三年历史、2025业务结构和产能爬坡，未机械外推管理层远期规划。";;
    capital_return_interpretability) reason="投入资本边界完整但经营必需现金为低可信估计，ROIC仅用于说明重资产低回报结构，不作护城河判断。";;
    report_consistency) reason="报告中心数字、业务闭合和价值桥均以结构化模型编译结果为准。";;
  esac
  python3 "$tool" set-review --model "$model" --item "$item" --passed --reason "$reason"
done

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

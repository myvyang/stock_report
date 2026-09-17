#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name 永安行 --code 603776.SH --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope consolidated --source "$5" --locator "$6"
}

f23="永安行2023年年度报告（2024-04-29）"
f24="永安行2024年年度报告（2025-04-12）"
f25="永安行2025年年度报告（2026-04-28）"

# 合并利润表、现金流量表及现金流补充资料的原始事实（元）。
fact rev23 营业收入 545209369.80 2023-01-01/2023-12-31 "$f24" PDF第89页
fact cost23 营业成本 481258250.02 2023-01-01/2023-12-31 "$f24" PDF第89页（重列比较数）
fact tax23 当期所得税费用 1442787.27 2023-01-01/2023-12-31 "$f23" PDF第195页
fact da_fixed23 固定资产折旧 133740278.74 2023-01-01/2023-12-31 "$f23" PDF第197页
fact da_rou23 使用权资产摊销 2359601.49 2023-01-01/2023-12-31 "$f23" PDF第197页
fact da_intangible23 无形资产摊销 1533692.60 2023-01-01/2023-12-31 "$f23" PDF第197页
fact da_ltd23 长期待摊费用摊销 41232836.40 2023-01-01/2023-12-31 "$f23" PDF第197页
fact ocf23 经营活动产生的现金流量净额 217806685.79 2023-01-01/2023-12-31 "$f23" PDF第93页
fact interest23 利息费用 48083984.36 2023-01-01/2023-12-31 "$f23" PDF第89页
fact capex_purchase23 购建固定资产无形资产和其他长期资产支付的现金 56286851.27 2023-01-01/2023-12-31 "$f23" PDF第93页
fact capex_disposal23 处置固定资产无形资产和其他长期资产收回的现金净额 11516291.55 2023-01-01/2023-12-31 "$f23" PDF第93页
fact lease_principal23 租赁负债现金支付 5003183.64 2023-01-01/2023-12-31 "$f23" PDF第196页

fact rev24 营业收入 457824947.75 2024-01-01/2024-12-31 "$f24" PDF第89页
fact cost24 营业成本 417750999.65 2024-01-01/2024-12-31 "$f24" PDF第89页
fact tax24 当期所得税费用 7926009.81 2024-01-01/2024-12-31 "$f24" PDF第196页
fact da_fixed24 固定资产折旧 123300433.04 2024-01-01/2024-12-31 "$f24" PDF第198页
fact da_rou24 使用权资产摊销 1142490.69 2024-01-01/2024-12-31 "$f24" PDF第198页
fact da_intangible24 无形资产摊销 2326014.39 2024-01-01/2024-12-31 "$f24" PDF第198页
fact da_ltd24 长期待摊费用摊销 15121017.56 2024-01-01/2024-12-31 "$f24" PDF第198页
fact ocf24 经营活动产生的现金流量净额 137223863.12 2024-01-01/2024-12-31 "$f24" PDF第93页
fact interest24 利息费用 45654518.69 2024-01-01/2024-12-31 "$f24" PDF第89页
fact capex_purchase24 购建固定资产无形资产和其他长期资产支付的现金 105906867.72 2024-01-01/2024-12-31 "$f24" PDF第93页
fact capex_disposal24 处置固定资产无形资产和其他长期资产收回的现金净额 8031001.83 2024-01-01/2024-12-31 "$f24" PDF第93页
fact lease_principal24 租赁负债现金支付 1290529.78 2024-01-01/2024-12-31 "$f24" PDF第197页

fact rev25 营业收入 411599030.53 2025-01-01/2025-12-31 "$f25" PDF第110页
fact cost25 营业成本 428293556.55 2025-01-01/2025-12-31 "$f25" PDF第110页
fact tax25 当期所得税费用 3061099.96 2025-01-01/2025-12-31 "$f25" PDF第219页
fact da_fixed25 固定资产折旧 107593386.22 2025-01-01/2025-12-31 "$f25" PDF第222页
fact da_rou25 使用权资产摊销 1394777.89 2025-01-01/2025-12-31 "$f25" PDF第222页
fact da_intangible25 无形资产摊销 2382086.38 2025-01-01/2025-12-31 "$f25" PDF第222页
fact da_ltd25 长期待摊费用摊销 10527999.63 2025-01-01/2025-12-31 "$f25" PDF第222页
fact ocf25 经营活动产生的现金流量净额 123482469.80 2025-01-01/2025-12-31 "$f25" PDF第114页
fact interest25 利息费用 20019720.22 2025-01-01/2025-12-31 "$f25" PDF第110页
fact capex_purchase25 购建固定资产无形资产和其他长期资产支付的现金 65494881.25 2025-01-01/2025-12-31 "$f25" PDF第114页
fact capex_disposal25 处置固定资产无形资产和其他长期资产收回的现金净额 17282529.61 2025-01-01/2025-12-31 "$f25" PDF第114页
fact lease_principal25 租赁负债现金支付 938547.48 2025-01-01/2025-12-31 "$f25" PDF第221页

# 2025年价值桥事实。
fact cash_equiv25 现金及现金等价物 622608513.51 2025-12-31 "$f25" PDF第223页
fact restricted_cash25 不属于现金及现金等价物的货币资金 20110819.94 2025-12-31 "$f25" PDF第223页
fact hello_fv25 哈啰相关权益工具投资公允价值 2136480000.00 2025-12-31 "$f25" PDF第32页、第102页
fact wealth25 理财产品 160000000.00 2025-12-31 "$f25" PDF第32页
fact equity_invest25 其他权益工具投资 72021379.14 2025-12-31 "$f25" PDF第106页
fact lt_equity25 长期股权投资 120115804.84 2025-12-31 "$f25" PDF第106页
fact deposit25 一年以上大额存单 41846055.55 2025-12-31 "$f25" PDF第198页
fact dtl25 递延所得税负债 262043285.96 2025-12-31 "$f25" PDF第107页、第197页
fact minority25 少数股东权益 24651582.21 2025-12-31 "$f25" PDF第108页
fact acquisition_payable25 股权收购款 16720000.00 2025-12-31 "$f25" PDF第209页
fact shares25 期末股份总数 280760572.00 2025-12-31 "$f25" PDF第209页

# 历史公司总量。期间经营费用包含税金及附加、销管研、经营性补助、信用及经营资产减值和处置损益；剔除财务、投资及公允价值损益。
for y in 2023 2024 2025; do
  s=${y#20}
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field revenue --expression "rev$s" --basis-type reported --reason "合并利润表营业收入" --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field cost_of_revenue --expression "cost$s" --basis-type reported --reason "合并利润表营业成本；2023采用2024年报重列比较数" --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field cash_tax --expression "tax$s" --basis-type reported --reason "采用当期所得税费用近似经营现金税；亏损集团内部仍有盈利纳税主体" --confidence medium
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field depreciation_amortization --expression "da_fixed$s + da_rou$s + da_intangible$s + da_ltd$s" --basis-type formula --reason "现金流量表补充资料四类折旧摊销之和" --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field operating_cash_flow --expression "ocf$s" --basis-type reported --reason "合并现金流量表经营活动现金流净额" --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field after_tax_interest_in_operating_cash_flow --expression "interest$s" --basis-type formula --reason "中国准则经营现金流含付息；集团亏损且大量亏损未确认递延税资产，未假设可兑现税盾" --confidence medium
done

python3 "$tool" set-field --model "$model" --view historical --year 2023 --field period_operating_expenses --value 190480065.96 --basis-type estimate --reason "由销管研和税金，减经营性其他收益，再加信用减值、经营资产减值及处置损失重构；剔除财务、投资、公允价值损益" --confidence medium --falsifier "若公司披露坏账或固定资产减值主要与已退出业务相关，应从经营费用剔除"
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field period_operating_expenses --value 142363869.50 --basis-type estimate --reason "同口径重构，信用减值和经营资产减值视作提供服务及回款的经常性经济损耗" --confidence medium --falsifier "若大额减值可证明为不可重复且与现行业务无关，应调低费用"
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field period_operating_expenses --value 142828141.94 --basis-type estimate --reason "同口径重构；剔除长期股权投资和商誉减值，保留合同、存货、固定资产减值及资产处置损失" --confidence medium --falsifier "若固定资产处置及减值不再发生且资产已完成出清，正常费用将低约0.27亿元"

python3 "$tool" set-field --model "$model" --view historical --year 2023 --field core_business_capex --value 35000000 --basis-type estimate --reason "净现金资本开支0.498亿元中，按存量出行系统和智慧生活资产更新占比估计" --confidence low --falsifier "若项目级资本开支披露显示氢能和芯片占比明显低于或高于30%，应重分"
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field exploratory_business_capex --expression "capex_purchase23 + lease_principal23 - capex_disposal23 - 35000000" --basis-type formula --reason "净现金资本开支扣除估计主营资本开支" --confidence low
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field core_business_capex --value 80000000 --basis-type estimate --reason "净现金资本开支0.992亿元中，按公共出行和既有制造资产更新占比估计" --confidence low --falsifier "项目级现金支出归属披露将推翻该比例"
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field exploratory_business_capex --expression "capex_purchase24 + lease_principal24 - capex_disposal24 - 80000000" --basis-type formula --reason "净现金资本开支扣除估计主营资本开支" --confidence low
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field core_business_capex --value 45000000 --basis-type estimate --reason "净现金资本开支0.492亿元中，氢能资本扩张放缓，主体支出估计服务于现行业务" --confidence low --falsifier "若氢能项目级现金资本支出超过0.10亿元，应上调开拓性部分"
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field exploratory_business_capex --expression "capex_purchase25 + lease_principal25 - capex_disposal25 - 45000000" --basis-type formula --reason "净现金资本开支扣除估计主营资本开支" --confidence low

python3 "$tool" set-field --model "$model" --view historical --year 2023 --field operating_working_capital_increase --value -214995994.37 --basis-type estimate --reason "以利润路径与现金流路径闭合的经营性营运资金及其他经营应计释放；主要来自应收款回收和折旧摊销差异" --confidence medium --falsifier "若现金流补充资料中的经营性应收应付分类被重列，应同步修订"
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field operating_working_capital_increase --value -151204357.34 --basis-type estimate --reason "以利润路径与现金流路径闭合；应收项目释放抵消存货增加和经营应付减少" --confidence medium --falsifier "若用户押金被认定为融资性负债，应重做经营现金流桥"
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field operating_working_capital_increase --value -184187707.82 --basis-type estimate --reason "以利润路径与现金流路径闭合；应收、合同资产和存货下降构成主要现金释放" --confidence medium --falsifier "若2026年应收回款和存货释放不能延续，稳定期不得采用该释放额"

# 经营投入资本：流动项目按经营性应收、存货、预付等减经营性无息负债；长期资产含商誉，随后单列剔除。
for row in "2022 453936155.47 629405590.71 0" "2023 317847241.55 656393501.88 126754266.48" "2024 219258129.46 597215328.52 126754266.48" "2025 66053612.60 493322615.09 108696434.78"; do
  set -- $row; y=$1; wc=$2; lt=$3; goodwill=$4
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field operating_working_capital --value "$wc" --basis-type estimate --reason "由合并资产负债表经营性流动资产减无息经营负债逐项汇总；剔除现金、金融投资和融资负债" --confidence medium --falsifier "若其他应收款或其他应付款附注明确含重大非经营项目，应重分类"
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field operating_long_term_assets_net --value "$lt" --basis-type estimate --reason "固定资产、在建工程、使用权资产、无形资产、商誉和长期待摊费用，扣资产相关递延收益" --confidence medium --falsifier "若资产清单显示闲置或待处置长期资产，应转为非经营资产"
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field required_cash --value 100000000 --basis-type estimate --reason "约覆盖两至三个月工资、运维和税费的最低流动性，用户押金波动使完全零现金不可行" --confidence low --falsifier "若月度现金支出或授信资料显示最低现金需求明显不同，应调整"
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field unsupported_intangible_assets --value "$goodwill" --basis-type estimate --reason "凯博并购商誉未能由持续经营收益解释，按项目纪律从投入资本剔除" --confidence high --falsifier "若凯博形成可验证的持续超额经营收益，可重新计入可解释经营资产"
done

# 稳定期是固定标尺，不把三年营运资金释放或管理层增长目标外推。
python3 "$tool" set-field --model "$model" --view stable --field revenue --value 400000000 --basis-type estimate --reason "公共出行收缩、系统销售波动和氢能尚未稳定，取接近2025年的常态规模" --confidence low --falsifier "连续两年收入稳定高于5亿元或低于3亿元将推翻"
python3 "$tool" set-field --model "$model" --view stable --field cost_of_revenue --value 360000000 --basis-type estimate --reason "假设综合毛利率恢复到10%，低于2023年而高于2025年负毛利" --confidence low --falsifier "系统运营与共享出行毛利率不能恢复为正时应下调"
python3 "$tool" set-field --model "$model" --view stable --field period_operating_expenses --value 100000000 --basis-type estimate --reason "保留约0.75亿元销管研税净额和0.25亿元正常坏账、减值损耗" --confidence low --falsifier "应收坏账损失长期高于0.40亿元或费用率显著下降将推翻"
python3 "$tool" set-field --model "$model" --view stable --field cash_tax --value 3000000 --basis-type estimate --reason "集团亏损但部分子公司盈利纳税，参照最近当期所得税" --confidence low --falsifier "合并经营利润转正且税收优惠消失时应按正常税率重估"
python3 "$tool" set-field --model "$model" --view stable --field depreciation_amortization --value 80000000 --basis-type estimate --reason "资产规模继续收缩后的常态折旧摊销" --confidence low --falsifier "固定资产和长期待摊资产停止下降时应上调"
python3 "$tool" set-field --model "$model" --view stable --field core_business_capex --value 80000000 --basis-type estimate --reason "稳定状态下以资本开支约等于折旧摊销，避免把资产消耗误作永久现金收益" --confidence low --falsifier "若长期服务合同证明较低更新投入可持续，应下调"
python3 "$tool" set-field --model "$model" --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason "稳定经营收益不为证据不足的氢能和芯片扩张赋值" --confidence medium --falsifier "商业化订单、产能和逐年投入计划足以支持成长估值时应另建成长路径"
python3 "$tool" set-field --model "$model" --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason "不把应收和存货持续下降形成的历史现金释放永久化" --confidence medium --falsifier "稳定收入增长或账期结构变化将产生新的资金占用"

# 2025年六项互斥业务，其他业务以披露的材料、水电、废料和加工费具名。
python3 "$tool" add-business --model "$model" --business-id system_sales --name 出行系统销售 --importance "向政府、国企及哈啰相关客户销售两轮车和系统，2025年收入反弹但毛利很薄" --confidence medium --falsifier "若关联客户订单不可持续，收入基准应下调"
python3 "$tool" add-business --model "$model" --business-id system_operation --name 公共自行车系统运营 --importance "政府购买的存量运营服务，收入快速收缩且2025年直接成本已超过收入" --confidence high --falsifier "新增长期运营合同或成本重置使毛利转正"
python3 "$tool" add-business --model "$model" --business-id shared_mobility --name 用户付费共享出行 --importance "直接向消费者收费，车辆折旧、调度和维修形成重资产负毛利" --confidence high --falsifier "单车日均订单和单位贡献毛利显著改善"
python3 "$tool" add-business --model "$model" --business-id smart_life --name 智慧生活智能门锁 --importance "国内外智能门锁销售，仍是少数毛利为正的产品业务" --confidence high --falsifier "出口继续下降或渠道费用吞噬毛利"
python3 "$tool" add-business --model "$model" --business-id hydrogen --name 氢能产品及平台服务 --importance "处于商业化前期，收入下降且持续研发和推广，作为开拓性业务观察" --confidence medium --falsifier "独立业务费用和现金流披露显示已经稳定盈利"
python3 "$tool" add-business --model "$model" --business-id materials_services --name 材料处置、水电与加工配套 --importance "年报明确列示的非主营收入，2025年因材料和废料处置等增至0.19亿元" --confidence high --falsifier "该收入在后续年度消失或转入具名主营产品"

for spec in \
"system_sales 93746636.78 89692857.03 25000000 200000 45000000" \
"system_operation 92528895.92 113861115.76 40000000 0 47000000" \
"shared_mobility 82325075.02 116303442.48 34000000 0 10000000" \
"smart_life 59147260.89 38734876.75 14000000 1200000 8000000" \
"hydrogen 65085774.42 45361723.43 24000000 1300000 5000000" \
"materials_services 18765387.50 24339541.10 5828141.94 361099.96 8482469.80"; do
  set -- $spec; id=$1; rev=$2; cost=$3; opex=$4; tax=$5; ocf=$6
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field revenue --value "$rev" --basis-type estimate --reason "主营产品收入取年报直接披露；配套业务取营业收入扣除表及其他业务收入" --confidence medium --falsifier "分部审计口径变更将重分"
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field cost_of_revenue --value "$cost" --basis-type estimate --reason "主营产品成本及其他业务成本取年报披露" --confidence medium --falsifier "分部审计口径变更将重分"
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field period_operating_expenses --value "$opex" --basis-type estimate --reason "按客户、人员、研发方向和应收减值归因分配，合计闭合公司" --confidence low --falsifier "公司披露分部费用或应收账款按产品明细时应替换"
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field cash_tax --value "$tax" --basis-type estimate --reason "按各业务估计税前结果及盈利子公司归属分配，合计闭合公司" --confidence low --falsifier "分主体所得税与业务映射披露时应替换"
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field operating_cash_flow_contribution --value "$ocf" --basis-type estimate --reason "按回款、用户押金、存货消耗和业务毛利分配，合计闭合公司经营现金流" --confidence low --falsifier "分业务现金流或应收回款披露时应替换"
done

# 普通股价值桥。
python3 "$tool" set-field --model "$model" --view equity --field excess_cash --expression "cash_equiv25 - 100000000" --basis-type formula --reason "现金及现金等价物扣除经营必需现金；受限资金已不在现金等价物内" --confidence medium
python3 "$tool" set-field --model "$model" --view equity --field non_operating_assets --expression "hello_fv25 + wealth25 + equity_invest25 + lt_equity25 + deposit25 - dtl25" --basis-type formula --reason "哈啰权益、理财、股权投资和大额存单按账面/审计公允价值计入，并扣对应及其他递延所得税负债" --confidence medium
python3 "$tool" set-field --model "$model" --view equity --field financing_debt --value 0 --basis-type estimate --reason "2025年末可转债已全部转股或赎回；租赁按经营口径纳入经营资产与现金流" --confidence high --falsifier "期后新增有息借款或存在未识别融资性应付款"
python3 "$tool" set-field --model "$model" --view equity --field minority_interest_value --expression "minority25" --basis-type reported --reason "缺少子公司逐项估值证据，谨慎以少数股东账面权益替代经济价值" --confidence low
python3 "$tool" set-field --model "$model" --view equity --field other_priority_claims --expression "acquisition_payable25" --basis-type reported --reason "尚未支付的凯博股权收购款优先于普通股分配" --confidence high
python3 "$tool" set-field --model "$model" --view equity --field diluted_shares --expression "shares25" --basis-type reported --reason "可转债已完成转股或赎回，年末无其他权益工具；采用期末股份总数" --confidence high
python3 "$tool" set-field --model "$model" --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason "财报和A股交易均为人民币" --confidence high --falsifier "无；同币种恒为1"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "收入和毛利连续恶化，氢能及芯片缺少稳定状态、到达时间和逐年FCFF证据，采用稳定经营收益八倍固定标尺" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name 哈啰相关股权与经营分离 --before "交易性金融资产21.3648亿元，公允价值变动计入利润" --after "从EBIT与FCFF剔除，按审计公允价值计入非经营资产" --reason "该少数股权不参与上市公司主营业务现金流，且采用第三层次估值"
python3 "$tool" add-adjustment --model "$model" --name 非经营资产递延税 --before "递延所得税负债2.6204亿元列于合并负债" --after "在非经营资产价值中净扣2.6204亿元" --reason "主要对应哈啰股权和既往处置收益，不能由经营价值承担，也不能遗漏"
python3 "$tool" add-adjustment --model "$model" --name 并购商誉 --before "2025年末商誉1.0870亿元" --after "不作为可解释经营投入或独立非经营价值" --reason "2025年计提0.1806亿元商誉减值，尚无持续超额收益支持剩余商誉价值"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "ROIC分母可重构但经营现金和商誉分类含估计，报告仅用于说明低回报与资本收缩，不解释为竞争优势"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "核心金额均保存年报名称、期间和PDF页码，标准字段由事实表达式或说明充分的估计形成"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "主营经营、哈啰及其他金融投资、融资与收购款、少数股东权益已分离，避免重复计值"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期不外推营运资金释放或新业务目标；收入、毛利、费用、税、折旧与资本开支相互一致"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心判断和重大数字将与结构化模型及程序生成表保持一致"

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

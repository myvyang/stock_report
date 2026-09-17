#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs
python3 "$tool" init --name 宝地矿业 --code 601121.SH --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope "$5" --source "$6" --locator "$7"
}
field_expr() {
  if [[ -n "$2" ]]; then
    python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
  else
    python3 "$tool" set-field --model "$model" --view "$1" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
  fi
}
field_est() {
  if [[ -n "$2" ]]; then
    python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  else
    python3 "$tool" set-field --model "$model" --view "$1" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  fi
}

# 合并利润表、现金流量表原始事实；金额单位均为元。
for row in \
"2023 revenue 866183278.19 营业收入 P122" \
"2023 cost 544882264.63 营业成本 P122" \
"2023 surtax 46933009.41 税金及附加 P122" \
"2023 sell 2703951.14 销售费用 P122" \
"2023 admin 116162166.29 管理费用 P122" \
"2023 rd 2476328.73 研发费用 P122" \
"2023 other_income 4427180.14 其他收益 P122" \
"2023 credit 1960061.14 信用减值损失 P122" \
"2023 impairment -2978503.77 资产减值损失 P122" \
"2023 disposal 2840647.69 资产处置收益 P122" \
"2023 da_fixed 83828954.27 固定资产折旧 P238-P239" \
"2023 da_rou 622016.26 使用权资产摊销 P238-P239" \
"2023 da_intangible 19972654.37 无形资产摊销 P238-P239" \
"2023 da_deferred 17329597.99 长期待摊费用摊销 P238-P239" \
"2023 ocf 337718610.71 经营活动产生的现金流量净额 P126" \
"2023 interest 13414221.08 利息费用 P122" \
"2023 capex_gross 416944401.94 购建固定资产无形资产和其他长期资产支付的现金 P126" \
"2023 disposal_cash 9644100.00 处置长期资产收回的现金净额 P126" \
"2024 revenue 1195955614.09 营业收入 P100" \
"2024 cost 670411487.50 营业成本 P100" \
"2024 surtax 73245313.32 税金及附加 P100" \
"2024 sell 3647405.21 销售费用 P100" \
"2024 admin 146936463.51 管理费用 P100" \
"2024 rd 5505773.51 研发费用 P100" \
"2024 other_income 16583345.42 其他收益 P100" \
"2024 credit -3505879.74 信用减值损失 P101" \
"2024 impairment 766196.63 资产减值损失 P101" \
"2024 disposal 30704.16 资产处置收益 P101" \
"2024 da_fixed 120929224.57 固定资产折旧 P198-P199" \
"2024 da_rou 1561099.10 使用权资产摊销 P199" \
"2024 da_intangible 38423649.94 无形资产摊销 P199" \
"2024 da_deferred 72099001.96 长期待摊费用摊销 P199" \
"2024 ocf 444035098.36 经营活动产生的现金流量净额 P104" \
"2024 interest 7491887.07 利息费用 P100" \
"2024 capex_gross 897102293.89 购建固定资产无形资产和其他长期资产支付的现金 P105" \
"2024 disposal_cash 504800.00 处置长期资产收回的现金净额 P105" \
"2025 revenue 1611899923.46 营业收入 P110" \
"2025 cost 1030633199.80 营业成本 P110" \
"2025 surtax 92302651.79 税金及附加 P110" \
"2025 sell 3265954.27 销售费用 P110" \
"2025 admin 179914820.58 管理费用 P110" \
"2025 rd 4420435.29 研发费用 P110" \
"2025 other_income 5256325.50 其他收益 P110" \
"2025 credit 3717534.79 信用减值损失 P111" \
"2025 impairment -8847333.15 资产减值损失 P111" \
"2025 disposal 98774.40 资产处置收益 P111" \
"2025 da_fixed 118382191.51 固定资产折旧 P204" \
"2025 da_rou 2164298.84 使用权资产摊销 P204" \
"2025 da_intangible 72082036.27 无形资产摊销 P204" \
"2025 da_deferred 131434460.94 长期待摊费用摊销 P204" \
"2025 ocf 736697380.85 经营活动产生的现金流量净额 P114" \
"2025 interest 12478781.31 利息费用 P110" \
"2025 capex_gross 924569657.10 购建固定资产无形资产和其他长期资产支付的现金 P115" \
"2025 disposal_cash 1144194.00 处置长期资产收回的现金净额 P114-P115"
do
  set -- $row
  y=$1 id=$2 amount=$3 item=$4 loc=$5
  if [[ $y == 2023 ]]; then src="宝地矿业2023年年度报告（2024-04-12）"; else src="宝地矿业${y}年年度报告"; fi
  fact "${id}_${y}" "$item" "$amount" "$y" consolidated "$src" "$loc"
done

# 历史经营字段。经营现金税按主要矿山适用的15%正常税率估计；营运资金增加用现金流量表勾稽后的经营占用表示。
for y in 2023 2024 2025; do
  field_expr historical "$y" revenue "revenue_$y" reported "合并利润表营业收入" high
  field_expr historical "$y" cost_of_revenue "cost_$y" reported "合并利润表营业成本" high
  field_expr historical "$y" period_operating_expenses "surtax_$y + sell_$y + admin_$y + rd_$y - other_income_$y - credit_$y - impairment_$y - disposal_$y" formula "税金及附加、销售管理研发费用及持续经营相关其他净损益的净额；剔除财务费用和投资收益" medium
  field_expr historical "$y" depreciation_amortization "da_fixed_$y + da_rou_$y + da_intangible_$y + da_deferred_$y" formula "现金流量表补充资料中的经营性折旧摊销合计" high
  field_expr historical "$y" operating_cash_flow "ocf_$y" reported "合并现金流量表经营活动现金流量净额" high
  field_expr historical "$y" after_tax_interest_in_operating_cash_flow "interest_$y * 0.85" formula "利息费用按15%税率税后加回以形成融资前现金流" medium
done

field_est historical 2023 cash_tax 23891241.4785 "EBIT按15%主要经营税率估计正常经营现金税" medium "若税务附注明确持续适用税率或不可抵扣项目使长期现金税率显著偏离15%，需重估"
field_est historical 2024 cash_tax 46512530.6265 "EBIT按15%主要经营税率估计正常经营现金税" medium "若税务附注明确持续适用税率或不可抵扣项目使长期现金税率显著偏离15%，需重估"
field_est historical 2025 cash_tax 45238224.4905 "EBIT按15%主要经营税率估计正常经营现金税" medium "若税务附注明确持续适用税率或不可抵扣项目使长期现金税率显著偏离15%，需重估"

field_est historical 2023 core_business_capex 307300301.94 "净现金资本开支扣除哈西亚图新产品线建设的基准分配" low "若项目现金支付台账显示哈西亚图当年投入并非1亿元，则在总资本开支不变下重分"
field_est historical 2023 exploratory_business_capex 100000000 "哈西亚图铁多金属矿在尚未形成金多金属矿粉收入阶段的建设投入基准估计" low "若项目现金支付台账披露实际年度建设支出，则以台账替代"
field_est historical 2024 core_business_capex 746597493.89 "净现金资本开支扣除哈西亚图新产品线建设的基准分配" low "若项目现金支付台账显示哈西亚图当年投入并非1.5亿元，则在总资本开支不变下重分"
field_est historical 2024 exploratory_business_capex 150000000 "哈西亚图铁多金属矿在金多金属矿粉商业销售前的建设投入基准估计" low "若项目现金支付台账披露实际年度建设支出，则以台账替代"
field_est historical 2025 core_business_capex 873425463.10 "净现金资本开支中铁矿采选改扩建与已投产矿山投入的基准估计" low "若项目现金支付台账显示哈西亚图未稳定业务投入与5000万元显著不同，则重分"
field_est historical 2025 exploratory_business_capex 50000000 "金多金属矿粉首年商业化尚未稳定，保留5000万元建设投入为开拓性基准估计" low "若哈西亚图现金支出台账证明全部投入均服务已稳定产能，则归入主营资本开支"

field_est historical 2023 operating_working_capital_increase -91983774.0265 "由NOPAT、折旧摊销、经营现金流和税后利息勾稽得到，主要反映存货及经营应收应付释放" medium "若经营营运资金附注可完整剔除矿权应付款、税款时点和其他非现金项目，则用直接变动替代"
field_est historical 2024 operating_working_capital_increase 46180780.084 "由NOPAT、折旧摊销、经营现金流和税后利息勾稽得到，主要反映存货及经营应收应付占用" medium "若经营营运资金附注可完整剔除矿权应付款、税款时点和其他非现金项目，则用直接变动替代"
field_est historical 2025 operating_working_capital_increase -166890418.624 "由NOPAT、折旧摊销、经营现金流和税后利息勾稽得到；与现金流补充资料披露的约1.63亿元营运资金释放接近" medium "若经营营运资金附注可完整剔除票据融资还原与税款时点，则用直接变动替代"

# 经营资本：营运资金剔除矿权价款、借款和金融资产；长期经营资产扣除未付矿业权价款、弃置义务及资产相关递延收益。
field_est capital 2022 operating_working_capital 102676097.53 "2022年经营性应收、存货和预付等减经营性应付；将随后重分类为长期应付款的矿权价款从应付账款剔除" low "若2022年应付账款附注能精确拆出矿权价款及工程款，则按明细重算"
field_est capital 2023 operating_working_capital -59887389.10 "经营性应收票据账款、预付、存货和其他经营流动资产减票据应付、应付账款、合同负债、薪酬税费及其他流动经营负债" medium "若其他应付款中存在可确认的经营款项或融资款项，应重新分类"
field_est capital 2024 operating_working_capital -56902286.34 "同口径经营性流动资产减经营性流动负债" medium "若票据融资还原项目被证明不应净额处理，应重新分类"
field_est capital 2025 operating_working_capital -453359837.78 "同口径经营性流动资产减经营性流动负债；应付票据增长使供应商资金占用明显上升" medium "若应付票据主要为融资性票据而非采购结算，应转入融资负债并重算"

field_est capital 2022 operating_long_term_assets_net 2094241632.25 "固定资产、在建工程、使用权资产、矿权等无形资产、长期待摊及其他经营长期资产，扣除未付矿权价款、预计负债和递延收益" medium "若其他非流动资产或长期应付款明细显示非经营内容，应重新分类"
field_est capital 2023 operating_long_term_assets_net 2440434716.34 "同口径经营长期资产净额" medium "若其他非流动资产或长期应付款明细显示非经营内容，应重新分类"
field_est capital 2024 operating_long_term_assets_net 3091891675.28 "同口径经营长期资产净额" medium "若其他非流动资产或长期应付款明细显示非经营内容，应重新分类"
field_est capital 2025 operating_long_term_assets_net 3912677748.87 "同口径经营长期资产净额；固定资产和长期待摊增加反映矿山投产及剥离投入" medium "若其他非流动资产或长期应付款明细显示非经营内容，应重新分类"

for row in "2022 70000000" "2023 80000000" "2024 90000000" "2025 100000000"; do set -- $row; field_est capital "$1" required_cash "$2" "按约一个月至一个半月采购、工资、税费与日常费用支出估计经营最低现金" low "若月度现金支出、季节性或可动用授信表明最低流动性显著不同，则重估"; done
field_est capital 2022 unsupported_intangible_assets 0 "无商誉；矿业权直接支持采选经营，不作为无法解释无形资产剔除" medium "若矿业权对应矿山停产或无法续证，则相关账面值应剔除"
for y in 2023 2024 2025; do field_est capital "$y" unsupported_intangible_assets 6450990.44 "商誉默认不能由当前经营收益单独解释，全部剔除；矿业权保留为经营资产" high "若商誉对应业务可形成可验证的独立稳定收益，方可恢复"; done

# 稳定状态只锚定已投产业务，不给尚在建设的500万吨级扩张产能提前计值。
field_est stable '' revenue 1580000000 "按2025年约220万吨常态铁精粉销量、约660元/吨正常单价，加首年已验证的金多金属矿粉与配套收入估计" low "若连续两年销量、品位或含税结算价显著偏离该组合，则重估"
field_est stable '' cost_of_revenue 954000000 "按2024-2025吨矿成本及金多金属矿粉已披露成本正常化" low "若新增矿山完全成本或金属回收率披露后显著不同，则重估"
field_est stable '' period_operating_expenses 250000000 "剔除并购和建设阶段波动后，保留资源税、管理销售研发及持续经营其他净费用" low "若资源税或总部人员成本在稳产后持续高于该水平，则上调"
field_est stable '' cash_tax 56400000 "稳定EBIT 3.76亿元按15%经营现金税率" medium "若税收优惠到期或新矿适用25%税率，应上调"
field_est stable '' depreciation_amortization 300000000 "参考2024-2025折旧、矿权及剥离摊销，按当前已投产资产正常化" low "若剥离摊销与产量匹配后长期高于3亿元，则上调"
field_est stable '' core_business_capex 350000000 "以当前矿山折旧摊销为底并保留安全环保、井巷及剥离的持续现金投入" low "若成熟矿山三年现金资本开支持续低于折旧摊销且储量不下降，则下调"
field_est stable '' exploratory_business_capex 0 "稳定状态不持续承担尚未商业化的新业务投入" medium "若公司形成持续矿权竞拍或新金属勘探预算，则不再为零"
field_est stable '' operating_working_capital_increase 0 "不假设成熟不增长状态永久依靠增加应付票据释放现金" medium "若稳定销量仍需结构性增加库存或客户账期，则上调"

# 2025年业务树，完全覆盖合并收入、成本、期间经营费用、经营税和经营现金流。
python3 "$tool" add-business --model "$model" --business-id iron --name 铁精粉采选与直销 --importance "收入主体，面向新疆及周边钢厂直销，价格受铁矿石市场和品位影响" --confidence high --falsifier "若公司披露按矿山或客户的独立经营分部，应改按新证据重构"
python3 "$tool" add-business --model "$model" --business-id polymetal --name 金多金属矿粉采选与直销 --importance "哈西亚图2025年新投产业务，毛利率高但产销历史仅一年" --confidence medium --falsifier "若后续金属回收率、品位或结算系数不能维持，应下调稳定贡献"
python3 "$tool" add-business --model "$model" --business-id support --name 矿山配套运输与副产品 --importance "覆盖合并口径其他业务收入，包括矿山运输和副产品等配套活动" --confidence low --falsifier "若其他业务附注明确披露不同经济业务及成本，应据此重新命名和分配"

biz() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
biz_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence "$5"; }
fact iron_revenue_2025 铁精粉营业收入 1469396364.72 2025 consolidated "宝地矿业2025年年度报告" P196
fact iron_cost_2025 铁精粉营业成本 979087952.96 2025 consolidated "宝地矿业2025年年度报告" P196
fact polymetal_revenue_2025 金多金属矿粉营业收入 128451390.19 2025 consolidated "宝地矿业2025年年度报告" P196
fact polymetal_cost_2025 金多金属矿粉营业成本 50947892.32 2025 consolidated "宝地矿业2025年年度报告" P196
fact support_revenue_2025 其他业务收入 14052168.55 2025 consolidated "宝地矿业2025年年度报告" P196
fact support_cost_2025 其他业务成本 597354.52 2025 consolidated "宝地矿业2025年年度报告" P196
biz_expr iron revenue iron_revenue_2025 "2025年报按产品披露铁精粉收入（P196）" high
biz_expr iron cost_of_revenue iron_cost_2025 "2025年报按产品披露铁精粉成本（P196）" high
biz iron period_operating_expenses 250000000 estimate "按铁精粉收入规模、资源税和组织资源占用分配公司经营费用" low "若分矿种费用和资源税明细披露，则按明细替代"
biz iron cash_tax 36046261.764 estimate "业务EBIT按15%正常经营税率" medium "若该业务实际适用税率显著偏离15%，则重估"
biz iron operating_cash_flow_contribution 600000000 estimate "以回款、库存下降和票据结算对公司经营现金流的主导贡献估计" low "若分产品现金流或应收应付明细披露，则按明细替代"

biz_expr polymetal revenue polymetal_revenue_2025 "2025年报按产品披露金多金属矿粉收入（P196）" high
biz_expr polymetal cost_of_revenue polymetal_cost_2025 "2025年报按产品披露金多金属矿粉成本（P196）" high
biz polymetal period_operating_expenses 25000000 estimate "按哈西亚图首年投产组织、销售和资源相关费用基准分配" low "若哈西亚图分部费用披露，则按实际替代"
biz polymetal cash_tax 7875524.6805 estimate "业务EBIT按15%正常经营税率" medium "若哈西亚图税率或不可抵扣项目显著不同，则重估"
biz polymetal operating_cash_flow_contribution 125000000 estimate "首年客户现款结算及高毛利形成的现金贡献基准点" low "若客户应收与合同结算明细显示回款明显较弱，则下调"

biz_expr support revenue support_revenue_2025 "2025年报披露其他业务收入（P196）" high
biz_expr support cost_of_revenue support_cost_2025 "2025年报披露其他业务成本（P196）" high
biz support period_operating_expenses 4678560.39 estimate "以公司总期间经营费用扣除两项主要产品分配额闭合" low "若运输与副产品费用明细披露，则按明细替代"
biz support cash_tax 1316438.046 estimate "业务EBIT按15%正常经营税率" medium "若该配套业务税率显著偏离15%，则重估"
biz support operating_cash_flow_contribution 11697380.85 estimate "公司经营现金流扣除两项主要产品贡献后的闭合估计" low "若分业务现金流披露，则按直接数据替代"

# 普通股价值桥，以2025-12-31合并范围和当日8亿股为一致边界。
fact cash_2025 货币资金 1089959469.93 2025-12-31 consolidated "宝地矿业2025年年度报告" P106
fact restricted_cash_2025 受限货币资金 57312186.13 2025-12-31 consolidated "宝地矿业2025年年度报告" P184
fact trading_assets_2025 交易性金融资产 330888494.00 2025-12-31 consolidated "宝地矿业2025年年度报告" P106
fact long_term_equity_2025 长期股权投资 270238160.52 2025-12-31 consolidated "宝地矿业2025年年度报告" P106
fact financing_debt_2025 银行借款及租赁融资负债 856252567.32 2025-12-31 consolidated "宝地矿业2025年年度报告" P107,P189-P191
fact minority_profit_2025 少数股东损益 100734290.15 2025 consolidated "宝地矿业2025年年度报告" P111
fact shares_2025 期末普通股股本 800000000 2025-12-31 parent "宝地矿业2025年年度报告" P108

field_est equity '' excess_cash 0 "现金及结构性存款均低于备战、松湖等已批准在建项目尚需投入，按2025年末边界不作为可无损分回股东的多余现金" medium "若公司取消或外部融资完全覆盖已批准项目，并将资金分红，则应恢复多余现金价值"
field_expr equity '' non_operating_assets "long_term_equity_2025" reported "长期股权投资未参与合并经营现金流，按账面价值作为可核验基准" medium
field_expr equity '' financing_debt "financing_debt_2025" formula "短期借款、长期借款、一年内到期长期借款及租赁负债合计；矿业权未付款已从经营长期资产扣除" medium
field_est equity '' minority_interest_value 805874321.20 "2025年少数股东损益1.007亿元按同一8倍稳定收益标尺估计其经济价值" low "若能取得天华与备战分矿山稳定FCFF、债务和现金，则以子公司价值替代"
field_est equity '' other_priority_claims 0 "矿业权价款已从经营长期资产扣除，已宣告未支付股利在年末不存在，避免重复扣除" medium "若发现年末已形成但未入账的重大资本或税务义务，则补列"
field_expr equity '' diluted_shares "shares_2025" reported "2025年末无潜在摊薄工具；期后并购与配套融资增发属于不同合并范围，正文单独提示" high
field_est equity '' financial_to_trading_fx 1 "财报与交易币种均为人民币" high "若交易币种变化则调整"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "在建项目到达稳定状态时间、逐年FCFF和全部后续投入证据不足；按当前已投产业务的稳定经营收益八倍形成固定标尺，不提前计入扩产上行" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "在建项目资金可达性" --before "货币资金10.90亿元、交易性金融资产3.31亿元" --after "多余现金0；长期股权投资2.70亿元单列" --reason "备战与松湖等已批准项目未完工投资远高于现有资金，资金不能在不损害建设计划下直接分回股东；若项目取消或融资覆盖并实际分红则推翻。"
python3 "$tool" add-adjustment --model "$model" --name "未付矿业权价款" --before "长期应付款及一年内到期部分合计10.52亿元" --after "从经营性长期资产净额扣除" --reason "该负债对应探矿权和矿业权出让收益，是取得经营资产尚未支付的对价，不作为融资负债再次扣除。"
python3 "$tool" add-adjustment --model "$model" --name "期后葱岭能源交易" --before "2025年末股本8.00亿股、葱岭能源13%按权益法计量" --after "估值桥保持2025年末边界；不混入期后新增1.842亿股及取得剩余87%股权" --reason "交割及增发发生于2026年，若只替换股数而不并入标的资产、现金和债务会造成范围错配。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "历史主表字段均引用年报页码与事实ID；研究估计记录依据、可信度和可推翻条件。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "矿权及剥离资产归入经营资产，长期股权投资单列非经营资产，未付矿权价款从经营资产净额扣除，融资负债避免重复。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定状态基于当前已投产业务的正常量价成本，不机械采用2025高现金流，也不提前计入备战和孜洛依北远期产能。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本分母含经营营运资金、矿山长期资产和经营必需现金；2022矿权应付款重分类不确定性已降低置信度，ROIC只用于观察资本消耗趋势。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心数字、业务闭合、稳定经营收益和普通股价值均取自同一结构化模型。"

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

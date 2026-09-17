#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

python3 "$tool" init --name 鲁北化工 --code 600727.SH --period-label 2025年年度 \
  --period-end 2025-12-31 --coverage-years 2023,2024,2025 \
  --financial-currency 人民币 --trading-currency 人民币 \
  --security-name A股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" \
    --amount "$3" --period "$4" --currency 人民币 --scope consolidated \
    --source "$5" --locator "$6"
}

field_expr() {
  if [[ -n "$2" ]]; then
    python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" \
      --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
  else
    python3 "$tool" set-field --model "$model" --view "$1" --field "$3" \
      --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
  fi
}

field_est() {
  if [[ -n "$2" ]]; then
    python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" \
      --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  else
    python3 "$tool" set-field --model "$model" --view "$1" --field "$3" \
      --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  fi
}

source23='鲁北化工2023年年度报告（2024-03-07）'
source24='鲁北化工2024年年度报告（2025-03-20）'
source25='鲁北化工2025年年度报告（2026-03-31）'

# 合并利润表、现金流量表和现金流补充资料。
fact rev23 营业收入 4994153276.73 2023 "$source23" 'PDF第87页'
fact cost23 营业成本 4596497854.06 2023 "$source23" 'PDF第87页'
fact op_profit23 营业利润 182461733.56 2023 "$source23" 'PDF第88页'
fact finance23 财务费用 -2585870.48 2023 "$source23" 'PDF第87页'
fact invest23 投资收益 692244.99 2023 "$source23" 'PDF第87页'
fact fair23 公允价值变动收益 1159313.90 2023 "$source23" 'PDF第88页'
fact disposal23 资产处置收益 83597.84 2023 "$source23" 'PDF第88页'
fact tax23 所得税费用 27290312.16 2023 "$source23" 'PDF第88页'
fact da23 折旧摊销合计 279928296.33 2023 "$source23" 'PDF第200页；固定资产折旧、无形资产及长期待摊费用摊销合计'
fact capex_paid23 购建固定资产无形资产和其他长期资产支付的现金 370269833.92 2023 "$source23" 'PDF第92页'
fact asset_sale23 处置固定资产无形资产和其他长期资产收回的现金净额 85783016.21 2023 "$source23" 'PDF第92页'
fact cfo23 经营活动产生的现金流量净额 147512455.61 2023 "$source23" 'PDF第91页'
fact interest23 利息费用 15970609.03 2023 "$source23" 'PDF第87页'

fact rev24 营业收入 5746398663.56 2024 "$source24" 'PDF第86页'
fact cost24 营业成本 5053253793.49 2024 "$source24" 'PDF第86页'
fact op_profit24 营业利润 420777443.87 2024 "$source24" 'PDF第87页'
fact finance24 财务费用 -288023.53 2024 "$source24" 'PDF第86页'
fact invest24 投资收益 -1382314.87 2024 "$source24" 'PDF第86页'
fact fair24 公允价值变动收益 751786.46 2024 "$source24" 'PDF第87页'
fact disposal24 资产处置收益 -14639417.46 2024 "$source24" 'PDF第87页'
fact tax24 所得税费用 64642909.20 2024 "$source24" 'PDF第87页'
fact da24 折旧摊销合计 269764147.64 2024 "$source24" 'PDF第203页；固定资产、使用权资产、无形资产及长期待摊费用折旧摊销合计'
fact capex_paid24 购建固定资产无形资产和其他长期资产支付的现金 381918427.91 2024 "$source24" 'PDF第91页'
fact asset_sale24 处置固定资产无形资产和其他长期资产收回的现金净额 2875.00 2024 "$source24" 'PDF第90页'
fact cfo24 经营活动产生的现金流量净额 195658053.87 2024 "$source24" 'PDF第90页'
fact interest24 利息费用 15384604.05 2024 "$source24" 'PDF第86页'

fact rev25 营业收入 5089332103.99 2025 "$source25" 'PDF第80页'
fact cost25 营业成本 4644710191.68 2025 "$source25" 'PDF第80页'
fact op_profit25 营业利润 152636400.84 2025 "$source25" 'PDF第81页'
fact finance25 财务费用 13313269.10 2025 "$source25" 'PDF第81页'
fact invest25 投资收益 -44429.99 2025 "$source25" 'PDF第81页'
fact fair25 公允价值变动收益 3943.33 2025 "$source25" 'PDF第81页'
fact disposal25 资产处置收益 4157782.34 2025 "$source25" 'PDF第81页'
fact tax25 所得税费用 44369253.35 2025 "$source25" 'PDF第81页'
fact da25 折旧摊销合计 268545932.59 2025 "$source25" 'PDF第204页；固定资产、使用权资产、无形资产及长期待摊费用折旧摊销合计'
fact capex_paid25 购建固定资产无形资产和其他长期资产支付的现金 480693239.22 2025 "$source25" 'PDF第85页'
fact asset_sale25 处置固定资产无形资产和其他长期资产收回的现金净额 13790431.56 2025 "$source25" 'PDF第85页'
fact cfo25 经营活动产生的现金流量净额 70559289.86 2025 "$source25" 'PDF第85页'
fact interest25 利息费用 25501770.86 2025 "$source25" 'PDF第81页'

# 经营资本分类汇总：金额均由相应年度合并资产负债表列示项目逐项加减，理由在字段中保留。
fact owc22 '经营性流动资产减经营性流动负债（转写汇总）' -2457631038.09 2022 "$source23" 'PDF第83-84页'
fact owc23 '经营性流动资产减经营性流动负债（转写汇总）' -605832663.59 2023 "$source23" 'PDF第83-84页'
fact owc24 '经营性流动资产减经营性流动负债（转写汇总）' -133912859.30 2024 "$source24" 'PDF第82-83页'
fact owc25 '经营性流动资产减经营性流动负债（转写汇总）' 204033054.89 2025 "$source25" 'PDF第76-77页'
fact olt22 '经营性长期资产净额（转写汇总，含商誉待另行剔除）' 4099757673.73 2022 "$source23" 'PDF第83-84页'
fact olt23 '经营性长期资产净额（转写汇总，含商誉待另行剔除）' 4187032082.00 2023 "$source23" 'PDF第83-84页'
fact olt24 '经营性长期资产净额（转写汇总，含商誉待另行剔除）' 4190968151.11 2024 "$source24" 'PDF第82-83页'
fact olt25 '经营性长期资产净额（转写汇总，含商誉待另行剔除）' 4537035302.83 2025 "$source25" 'PDF第76-77页'
fact goodwill22 商誉 173606348.10 2022 "$source23" 'PDF第83页'
fact goodwill23 商誉 173606348.10 2023 "$source23" 'PDF第83页'
fact goodwill24 商誉 173606348.10 2024 "$source24" 'PDF第82页'
fact goodwill25 商誉 173606348.10 2025 "$source25" 'PDF第77页'

# 2025年普通股价值桥。
fact cash25 货币资金 2536318152.80 2025-12-31 "$source25" 'PDF第76页'
fact restricted25 其他货币资金主要为授信融资相关保证金 1280751530.57 2025-12-31 "$source25" 'PDF第138页'
fact short_debt25 短期借款 2770975603.04 2025-12-31 "$source25" 'PDF第77页'
fact current_noncurrent25 一年内到期的非流动负债 219940586.39 2025-12-31 "$source25" 'PDF第77页'
fact long_debt25 长期借款 624781977.26 2025-12-31 "$source25" 'PDF第77页'
fact lease_debt25 租赁负债 46944073.07 2025-12-31 "$source25" 'PDF第77页'
fact trading_assets25 交易性金融资产 14003943.33 2025-12-31 "$source25" 'PDF第76页'
fact equity_invest25 其他权益工具投资 29721864.20 2025-12-31 "$source25" 'PDF第76页'
fact other_financial25 其他非流动金融资产 30010431.91 2025-12-31 "$source25" 'PDF第76页'
fact investment_property25 投资性房地产 10141702.36 2025-12-31 "$source25" 'PDF第76页'
fact long_equity25 长期股权投资 31845281.52 2025-12-31 "$source25" 'PDF第76页'
fact one_year_assets25 一年内到期的非流动资产 25000000.00 2025-12-31 "$source25" 'PDF第76页'
fact minority_equity25 少数股东权益 364990462.47 2025-12-31 "$source25" 'PDF第78页'
fact jinyi_minority25 锦亿科技期末少数股东权益 313907441.28 2025-12-31 "$source25" 'PDF第211页'
fact jinyi_cfo25 锦亿科技经营现金流 122730203.38 2025 "$source25" 'PDF第212页'
fact minority_dividend25 应付少数股东股利 72075000.00 2025-12-31 "$source25" 'PDF第77页'
fact shares25 期末普通股股本 528583135 2025-12-31 "$source25" 'PDF第78页'

# 最新年度分产品披露。
fact tio2_rev25 钛白粉营业收入 3129634273.96 2025 "$source25" 'PDF第20页'
fact tio2_cost25 钛白粉营业成本 3104188743.35 2025 "$source25" 'PDF第20页'
fact methane_rev25 甲烷氯化物营业收入 695188617.37 2025 "$source25" 'PDF第20页'
fact methane_cost25 甲烷氯化物营业成本 536448442.35 2025 "$source25" 'PDF第20页'
fact fertilizer_rev25 化肥营业收入 398997970.03 2025 "$source25" 'PDF第20页'
fact fertilizer_cost25 化肥营业成本 365260973.57 2025 "$source25" 'PDF第20页'
fact cement_rev25 水泥营业收入 53917905.26 2025 "$source25" 'PDF第20页'
fact cement_cost25 水泥营业成本 61269135.57 2025 "$source25" 'PDF第20页'
fact salt_rev25 原盐营业收入 108629016.85 2025 "$source25" 'PDF第20页'
fact salt_cost25 原盐营业成本 73736256.71 2025 "$source25" 'PDF第20页'
fact bromine_rev25 溴素营业收入 73812792.94 2025 "$source25" 'PDF第20页'
fact bromine_cost25 溴素营业成本 34761101.96 2025 "$source25" 'PDF第20页'

# 历史公司经营总量。EBIT剔除净融资、投资、公允价值和资产处置损益，保留经营补助及经营减值。
for y in 23 24 25; do
  year=$((2000+y))
  field_expr historical "$year" revenue "rev$y" reported '合并利润表营业收入。' high
  field_expr historical "$year" cost_of_revenue "cost$y" reported '合并利润表营业成本。' high
  field_expr historical "$year" period_operating_expenses "rev$y-cost$y-(op_profit$y-invest$y-fair$y-disposal$y+finance$y)" formula '毛利减去剔除融资及非经营投资处置损益后的EBIT。' medium
  field_expr historical "$year" cash_tax "tax$y" reported '以所得税费用作为经营现金税代理；融资税盾金额相对经营规模不大。' medium
  field_expr historical "$year" depreciation_amortization "da$y" reported '现金流量表补充资料中的折旧摊销合计。' high
  field_expr historical "$year" core_business_capex "capex_paid$y-asset_sale$y" formula '现金购建长期资产支出扣除经营长期资产处置回款；项目均延续既有化工及循环产业链。' medium
  field_est historical "$year" exploratory_business_capex 0 '未发现脱离现有钛白粉、酸肥水泥、盐化工链条的新业务现金项目。' medium '若项目清单披露面向新市场且尚无现有收入的新业务现金支出，则应重分类。'
  field_expr historical "$year" operating_cash_flow "cfo$y" reported '合并现金流量表经营活动现金流量净额。' high
done
field_est historical 2023 after_tax_interest_in_operating_cash_flow 13521192.65 '利息费用按当年所得税费用/EBIT代理税率税后化。' medium '若披露经营现金流中的利息现金额和对应税盾，改用直接金额。'
field_est historical 2024 after_tax_interest_in_operating_cash_flow 13102400.55 '利息费用按当年所得税费用/EBIT代理税率税后化。' medium '若披露经营现金流中的利息现金额和对应税盾，改用直接金额。'
field_est historical 2025 after_tax_interest_in_operating_cash_flow 18510005.04 '利息费用按当年所得税费用/EBIT代理税率税后化。' medium '若披露经营现金流中的利息现金额和对应税盾，改用直接金额。'
field_est historical 2023 operating_working_capital_increase 269545019.68 '由NOPAT、折旧摊销、经营现金流及税后利息倒算，吸收减值、递延税和营运项目的合并现金差异。' medium '若逐项现金流披露可完整重构经营营运资金变化，应以逐项结果替代。'
field_est historical 2024 operating_working_capital_increase 432120216.43 '由NOPAT、折旧摊销、经营现金流及税后利息倒算，吸收减值、递延税和营运项目的合并现金差异。' medium '若逐项现金流披露可完整重构经营营运资金变化，应以逐项结果替代。'
field_est historical 2025 operating_working_capital_increase 296939763.73 '由NOPAT、折旧摊销、经营现金流及税后利息倒算，吸收减值、递延税和营运项目的合并现金差异。' medium '若逐项现金流披露可完整重构经营营运资金变化，应以逐项结果替代。'

# 投入资本：应收、票据、预付、存货等减应付、合同负债及经营应计；融资借款和现金均排除。
for y in 2022 2023 2024 2025; do
  yy=${y:2:2}
  field_expr capital "$y" operating_working_capital "owc$yy" formula '按合并资产负债表逐项重构；应付股利和融资负债不作为经营负债。' medium
  field_expr capital "$y" operating_long_term_assets_net "olt$yy" formula '固定资产、在建工程、使用权资产、无形资产、商誉和长期待摊费用，扣资产相关递延收益。' medium
  field_est capital "$y" required_cash 400000000 '约覆盖一个月采购、工资、税费及结算缓冲；连续年度统一口径以避免景气波动伪装成资本效率。' medium '若月度现金支出、季节性和授信可用额度披露显示最低现金显著不同，需重估。'
  field_expr capital "$y" unsupported_intangible_assets "goodwill$yy" formula '锦亿科技收购商誉不按账面额自动作为经营资产，价值从经营收益反推。' high
done

# 稳定状态采用三年加权经营中枢，正常营运资金不增长，资本开支略高于折旧以覆盖环保和技改。
field_est stable '' revenue 5276628014.76 '2023-2025收入算术平均，避免把2024景气较好年份机械外推。' medium '若钛白粉新增6万吨投产后销量、价格和订单连续两个完整年度脱离此中枢，则重估。'
field_est stable '' cost_of_revenue 4764820613.08 '2023-2025营业成本算术平均，对应约9.7%的周期中枢毛利率。' medium '若主要产品价差连续两个完整年度稳定在显著不同水平，则重估。'
field_est stable '' period_operating_expenses 253296586.08 '三年重构期间经营费用均值，包含正常研发、销售与管理负担。' medium '若新增产能稳定运行后费用率结构性改变，则重估。'
field_est stable '' cash_tax 46531946.81 '对稳定EBIT采用18%经营现金税率，位于近三年实际税负区间内。' medium '税收优惠终止、盈利子公司结构变化或现金税率长期偏离18%时重估。'
field_est stable '' depreciation_amortization 272746125.52 '2023-2025折旧摊销均值。' medium '6万吨氯化法扩建转固后折旧显著提高时重估。'
field_est stable '' core_business_capex 280000000 '接近三年折旧均值并增加环保技改缓冲，低于2024-2025建设高峰现金支出。' low '若扩建后仍需每年超过3.5亿元才可维持产能与合规，则提高常态资本开支。'
field_est stable '' exploratory_business_capex 0 '基准价值不为证据不足的新业务选项单独计值。' medium '出现具名新业务、商业化订单及独立资金计划后再纳入成长路径。'
field_est stable '' operating_working_capital_increase 0 '零增长稳定状态下不假设永久新增营运资金。' medium '若长期库存安全水平或客户账期结构性上升，则改为正值。'

# 2025业务树。期间费用按收入分配；现金税只分配给正EBIT业务。
business() {
  python3 "$tool" add-business --model "$model" --business-id "$1" --name "$2" --importance "$3" \
    --confidence "$4" --falsifier "$5"
}
bexpr() {
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" \
    --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"
}
best() {
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" \
    --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"
}

business tio2 钛白粉 '收入与资产占用最大，硫酸法20万吨和氯化法6万吨均接近满负荷。' high '若分产品披露口径不含钛白粉相关副产品，需调整业务边界。'
business methane 甲烷氯化物 '锦亿科技37万吨产能、华南区域优势，是集团主要利润来源。' high '若锦亿科技单体披露与产品表无法对应，需重估费用和现金贡献。'
business fert_cement 磷肥—硫酸—水泥循环链 '化肥和水泥以副产石膏循环联产，需求与装置经济性不可完全割裂。' medium '若公司披露两套装置能够独立停产且成本完全可分，应拆成两项业务。'
business salt_bromine 海水制盐与提溴 '共享海水梯级利用资源，溴素高毛利但产量受季节和卤水约束。' medium '若提溴不再依赖制盐卤水体系，应重新拆分。'
business materials 硫酸亚铁、铝盐与配套材料 '具名承接钛白副产物、氯化铝、编织袋、工程维修及未列入主营产品表的配套销售。' low '若附注进一步拆出配套销售的收入成本和利润，应改用直接数据。'

bexpr tio2 revenue tio2_rev25 reported '2025年分产品披露。' high
bexpr tio2 cost_of_revenue tio2_cost25 reported '2025年分产品披露。' high
bexpr methane revenue methane_rev25 reported '2025年分产品披露。' high
bexpr methane cost_of_revenue methane_cost25 reported '2025年分产品披露。' high
bexpr fert_cement revenue 'fertilizer_rev25+cement_rev25' formula '联产链合并化肥与水泥产品披露。' high
bexpr fert_cement cost_of_revenue 'fertilizer_cost25+cement_cost25' formula '联产链合并化肥与水泥产品披露。' high
bexpr salt_bromine revenue 'salt_rev25+bromine_rev25' formula '海水梯级利用链合并原盐与溴素。' high
bexpr salt_bromine cost_of_revenue 'salt_cost25+bromine_cost25' formula '海水梯级利用链合并原盐与溴素。' high
bexpr materials revenue 'rev25-tio2_rev25-methane_rev25-fertilizer_rev25-cement_rev25-salt_rev25-bromine_rev25' formula '以公司收入扣除其余具名业务，覆盖硫酸亚铁、铝盐、配套材料及非主营销售。' medium
bexpr materials cost_of_revenue 'cost25-tio2_cost25-methane_cost25-fertilizer_cost25-cement_cost25-salt_cost25-bromine_cost25' formula '以公司营业成本扣除其余具名业务。' medium

best tio2 period_operating_expenses 173898611.54 '公司期间经营费用按业务收入占比分配；钛白业务销售和组织负担未单独披露。' low '分业务销售、管理和研发费用披露将推翻比例分配。'
best methane period_operating_expenses 38628262.84 '公司期间经营费用按业务收入占比分配。' low '锦亿科技完整费用表可替代比例分配。'
best fert_cement period_operating_expenses 25166340.52 '公司期间经营费用按业务收入占比分配。' low '联产链独立费用披露可替代比例分配。'
best salt_bromine period_operating_expenses 10137407.32 '公司期间经营费用按业务收入占比分配。' low '盐业独立费用披露可替代比例分配。'
best materials period_operating_expenses 34958915.83 '公司期间经营费用按业务收入占比分配，并以14.08元舍入差闭合公司总额。' low '配套材料独立费用披露可替代比例分配。'
best tio2 cash_tax 0 '钛白粉基准点EBIT为负，不分配当期经营现金税。' low '钛白子公司现金纳税明细显示重大当期税款时重估。'
best methane cash_tax 17175396.18 '公司经营现金税按正EBIT贡献分配。' low '锦亿科技现金纳税明细可替代分配。'
best fert_cement cash_tax 174371.70 '公司经营现金税按正EBIT贡献分配。' low '联产链现金纳税明细可替代分配。'
best salt_bromine cash_tax 9124084.66 '公司经营现金税按正EBIT贡献分配。' low '盐业现金纳税明细可替代分配。'
best materials cash_tax 17895400.81 '公司经营现金税按正EBIT贡献分配。' low '配套材料现金纳税明细可替代分配。'
best tio2 operating_cash_flow_contribution -120000000 '钛白粉毛利接近零且扩产、库存和应收占用现金，估计为主要现金拖累。' low '若钛白子公司现金流量表显示经营现金流显著为正，则重估。'
bexpr methane operating_cash_flow_contribution jinyi_cfo25 reported '锦亿科技单体经营现金流，作为甲烷氯化物贡献的直接代理。' medium
best fert_cement operating_cash_flow_contribution -10000000 '低毛利联产链并有库存及检修占用，基准估计小幅流出。' low '联产装置独立现金流或营运资金明细可推翻。'
best salt_bromine operating_cash_flow_contribution 30000000 '溴素高毛利部分抵消原盐库存上升，基准估计保持正贡献。' low '盐业独立现金流或库存账龄可推翻。'
best materials operating_cash_flow_contribution 47829086.48 '作为闭合项承接硫酸亚铁、铝盐和配套销售回款，确保合计等于公司经营现金流。' low '具名配套业务现金流披露将替代闭合估计。'

python3 "$tool" set-valuation --model "$model" --mode benchmark \
  --reason '周期化工业务缺少逐年可验证的稳定价差和扩建后FCFF路径，使用稳定经营收益八倍固定标尺。' \
  --stable-multiple 8 --safety-margin-ratio 0.6

field_expr equity '' excess_cash 'cash25-restricted25-400000000' formula '货币资金扣授信保证金和经营必需现金；受限保证金不视为股东可提取。' medium
field_expr equity '' non_operating_assets 'trading_assets25+equity_invest25+other_financial25+investment_property25+long_equity25+one_year_assets25' formula '未参与核心FCFF的金融投资、投资物业和长期股权投资按账面额计入。' medium
field_expr equity '' financing_debt 'short_debt25+current_noncurrent25+long_debt25+lease_debt25' formula '短期借款、一年内到期非流动负债、长期借款和长期租赁负债。' high
field_est equity '' minority_interest_value 532185418.44 '锦亿科技49%少数权益按2025经营现金流八倍计值，其他少数权益暂按账面额；避免只扣账面权益低估优先索偿。' low '锦亿科技独立稳定FCFF、净债务或少数股权交易价格披露后应替代。'
field_expr equity '' other_priority_claims minority_dividend25 reported '已列入负债、应付给少数股东的股利先于普通股可分配现金。' high
field_expr equity '' diluted_shares shares25 reported '无优先股、可转债或股权激励，使用期末已发行A股。' high
field_est equity '' financial_to_trading_fx 1 '财报和交易均为人民币。' high '交易币种改变时调整。'

python3 "$tool" add-adjustment --model "$model" --name '锦亿科技商誉' \
  --before '账面商誉1.736亿元' --after '从投入资本中全额剔除，经营能力仅通过稳定收益计值' \
  --reason '收购溢价不能因留在资产负债表就自动增加经营价值；2025年审计仍将其列为关键审计事项。'
python3 "$tool" add-adjustment --model "$model" --name '受限保证金的股东可达性' \
  --before '货币资金25.36亿元' --after '扣除12.81亿元授信融资相关保证金及4.00亿元经营必需现金后，8.56亿元计入多余现金' \
  --reason '保证金服务于融资和票据安排，不能在不解除相应约束的情况下分配给普通股股东。'
python3 "$tool" add-adjustment --model "$model" --name '少数股东经济价值' \
  --before '少数股东账面权益3.65亿元' --after '估计5.32亿元' \
  --reason '锦亿科技是盈利和现金贡献核心，按其经营现金流八倍的49%计值；其他少数权益暂按账面额。'

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '合并报表、附注和业务数据均保留年度报告页码与披露名称。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '融资债务、受限资金、非经营金融资产、商誉及少数权益分别处理，无重复加减。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定状态基于三年周期中枢并对建设期资本开支和零增长营运资金作独立判断。'
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '投入资本分母包含经营营运资金、长期资产和必需现金，并明确商誉剔除；但跨年票据融资重分类使ROIC仅适合观察资本占用趋势。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告核心数字将直接引用程序编译结果。'

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

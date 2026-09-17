#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope "合并" --source "$5" --locator "$6"
}
field() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7" ${8:+--falsifier "$8"}
}
estimate() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

s23='河南豫光金铅股份有限公司2023年年度报告（2024-04-13）'
s24='河南豫光金铅股份有限公司2024年年度报告（2025-04-26）'
s25='河南豫光金铅股份有限公司2025年年度报告（2026-04-18）'

fact rev23 营业收入 32145290242.95 2023 "$s24" '第80页，合并利润表'
fact cost23 营业成本 30634299537.32 2023 "$s24" '第80页，合并利润表'
fact op23 营业利润 665401805.33 2023 "$s24" '第81页，合并利润表'
fact fin23 财务费用 304222513.48 2023 "$s24" '第80-81页，合并利润表'
fact inv23 投资收益 28744438.18 2023 "$s24" '第81页，合并利润表'
fact fv23 公允价值变动收益 48342878.84 2023 "$s24" '第81页，合并利润表'
fact taxexp23 所得税费用 67658628.38 2023 "$s24" '第81页，合并利润表'
fact pretax23 利润总额 647720407.94 2023 "$s24" '第81页，合并利润表'
fact ocf23 经营活动产生的现金流量净额 93823203.82 2023 "$s24" '第84页，合并现金流量表'
fact int23 利息费用 308326021.86 2023 "$s24" '第80页，合并利润表'
fact dep23 固定资产折旧 271376316.04 2023 "$s24" '第171-172页，现金流量表补充资料'
fact rou23 使用权资产摊销 2410770.03 2023 "$s24" '第171-172页，现金流量表补充资料'
fact amort23 无形资产摊销 9413697.23 2023 "$s24" '第172页，现金流量表补充资料'
fact ltd23 长期待摊费用摊销 651365.41 2023 "$s24" '第172页，现金流量表补充资料'
fact capex23 购建固定资产无形资产和其他长期资产支付的现金 307767598.20 2023 "$s24" '第84页，合并现金流量表'

fact rev24 营业收入 39344538440.86 2024 "$s25" '第75页，合并利润表'
fact cost24 营业成本 37016175783.72 2024 "$s25" '第75页，合并利润表'
fact op24 营业利润 974720508.92 2024 "$s25" '第76页，合并利润表'
fact fin24 财务费用 457278760.02 2024 "$s25" '第75页，合并利润表'
fact inv24 投资收益 -49508677.61 2024 "$s25" '第75页，合并利润表'
fact fv24 公允价值变动收益 461418.99 2024 "$s25" '第76页，合并利润表'
fact ocf24 经营活动产生的现金流量净额 741872382.43 2024 "$s25" '第79页，合并现金流量表'
fact dep24 固定资产折旧 281713172.84 2024 "$s25" '第162页，现金流量表补充资料'
fact rou24 使用权资产摊销 3392572.36 2024 "$s25" '第162页，现金流量表补充资料'
fact amort24 无形资产摊销 8775968.76 2024 "$s25" '第162页，现金流量表补充资料'
fact ltd24 长期待摊费用摊销 1647696.67 2024 "$s25" '第162页，现金流量表补充资料'
fact capex24 购建固定资产无形资产和其他长期资产支付的现金 470448010.84 2024 "$s25" '第79页，合并现金流量表'

fact rev25 营业收入 49553593201.18 2025 "$s25" '第75页，合并利润表'
fact cost25 营业成本 47011739389.97 2025 "$s25" '第75页，合并利润表'
fact op25 营业利润 1107992851.04 2025 "$s25" '第76页，合并利润表'
fact fin25 财务费用 437942492.30 2025 "$s25" '第75页，合并利润表'
fact inv25 投资收益 -165168640.31 2025 "$s25" '第75-76页，合并利润表'
fact fv25 公允价值变动收益 -208581120.20 2025 "$s25" '第76页，合并利润表'
fact ocf25 经营活动产生的现金流量净额 510154447.40 2025 "$s25" '第79页，合并现金流量表'
fact dep25 固定资产折旧 297247329.74 2025 "$s25" '第162页，现金流量表补充资料'
fact rou25 使用权资产摊销 3082478.49 2025 "$s25" '第162页，现金流量表补充资料'
fact amort25 无形资产摊销 8815316.16 2025 "$s25" '第162页，现金流量表补充资料'
fact ltd25 长期待摊费用摊销 1649117.24 2025 "$s25" '第162页，现金流量表补充资料'
fact capex25 购建固定资产无形资产和其他长期资产支付的现金 405384655.04 2025 "$s25" '第79页，合并现金流量表'
fact cash25 货币资金 2003792696.57 2025 "$s25" '第71页，合并资产负债表'
fact restricted25 非现金等价物货币资金 325815751.81 2025 "$s25" '第164页，货币资金附注与现金等价物差额'
fact lti25 长期股权投资 75086810.53 2025 "$s25" '第71页，合并资产负债表'
fact eqi25 其他权益工具投资 22300058.43 2025 "$s25" '第71页，合并资产负债表'
fact ip25 投资性房地产 34755357.90 2025 "$s25" '第71页，合并资产负债表'
fact debt25 融资负债合计 12180307475.33 2025 "$s25" '第72页；短期借款、一年内到期非流动负债、长期借款及租赁负债合计'
fact mi25 少数股东权益 358195.86 2025 "$s25" '第73页，合并资产负债表'
fact shares25 期末普通股股本 1209262698 2025 "$s25" '第73页，合并资产负债表；第61-63页股本变动'

for y in 2023 2024 2025; do
  yy=${y:2}
  field historical "$y" revenue "rev$yy" reported '合并利润表直接数。' high
  field historical "$y" cost_of_revenue "cost$yy" reported '合并利润表直接数。' high
  field historical "$y" period_operating_expenses "rev$yy-cost$yy-op$yy-fin$yy+inv$yy+fv$yy" formula '以营业利润加回财务费用并剔除投资及公允价值损益重构EBIT，再由毛利倒算净期间经营费用；库存减值、政府补助等经营项目仍留在经营利润中。' medium
  field historical "$y" depreciation_amortization "dep$yy+rou$yy+amort$yy+ltd$yy" formula '现金流量表补充资料中的固定资产折旧、使用权资产、无形资产及长期待摊费用摊销合计。' high
  field historical "$y" operating_cash_flow "ocf$yy" reported '合并现金流量表直接数。' high
done

estimate historical 2023 cash_tax 93231321.075 '以2023年合并实际所得税率10.45%作用于重构EBIT，消除融资结构差异。' medium '若税收优惠不具持续性或递延税与现金税差异重大，应改用正常税率重估。'
estimate historical 2024 cash_tax 254291178.204 '以2024年合并实际所得税率17.17%作用于重构EBIT。' medium '若递延税、历史补税或经营补助税务处理重大，应重估。'
estimate historical 2025 cash_tax 421087913.710 '以2025年合并实际所得税率21.94%作用于重构EBIT。' medium '若现金税与所得税费用长期背离，应按税务现金口径重估。'
estimate historical 2023 after_tax_interest_in_operating_cash_flow 276119354.481 '利息费用按合并实际税率扣税后加回，用于从CFO桥接融资前FCFF。' medium '若利息现金支付与费用差异重大，应按已付利息重估。'
estimate historical 2024 after_tax_interest_in_operating_cash_flow 262383349.109 '利息费用按合并实际税率扣税后加回。' medium '若资本化利息或应付利息变化重大，应按现金支付重估。'
estimate historical 2025 after_tax_interest_in_operating_cash_flow 256823063.429 '利息费用按合并实际税率扣税后加回。' medium '若资本化利息或应付利息变化重大，应按现金支付重估。'
estimate historical 2023 operating_working_capital_increase 713215271.124 '由NOPAT+折旧摊销-CFO-税后利息倒算，以确保利润路径与现金流路径闭合；主要反映存货占用。' medium '若能取得完整经营性项目现金变动及非现金重分类表，应改为逐项直接计算。'
estimate historical 2024 operating_working_capital_increase 518029028.447 '由NOPAT+折旧摊销-CFO-税后利息倒算。' medium '若能取得完整经营性项目现金变动及非现金重分类表，应改为逐项直接计算。'
estimate historical 2025 operating_working_capital_increase 1042413920.942 '由NOPAT+折旧摊销-CFO-税后利息倒算；当年存货余额增加36.08亿元是主要现金压力。' medium '若存货增长主要由非现金价格重估或套保结算造成，应重估。'
estimate historical 2023 core_business_capex 257767598.20 '将铅铜冶炼、循环利用、环保技改等既有业务投入归为主营资本开支。' medium '项目明细若显示更多支出属于尚未商业化新材料，应下调并转入开拓性资本开支。'
estimate historical 2023 exploratory_business_capex 50000000 '铜箔及新型材料等尚未稳定盈利项目的保守估计。' low '若项目现金支出明细证明金额不同，应据实重分。'
estimate historical 2024 core_business_capex 390448010.84 '现金资本开支扣除估计的新材料项目投入。' medium '项目现金支出明细可推翻本拆分。'
estimate historical 2024 exploratory_business_capex 80000000 '铜箔、新型电接触材料等尚未稳定盈利项目估计。' low '项目现金支出明细可推翻本拆分。'
estimate historical 2025 core_business_capex 356258436.11 '现金资本开支扣除铜箔及新型电接触材料在建工程本期增加额。' medium '若工程付款与在建工程增加时点差异重大，应重估。'
estimate historical 2025 exploratory_business_capex 49126218.93 '按年产1万吨铜箔及200吨新型电接触材料项目本期在建工程增加额估计。' medium '若相关支出已形成稳定商业收入，应改列主营资本开支。'

estimate capital 2022 operating_working_capital 6335852036.94 '按应收票据、应收账款、应收款项融资、预付、其他应收、存货及其他流动资产减经营性流动负债重分类。' medium '若其他应收付款或票据具有融资性质，应调整。'
estimate capital 2023 operating_working_capital 7250607015.20 '同口径经营性流动资产减经营性流动负债。' medium '若套保保证金应归入经营营运资金，应调整。'
estimate capital 2024 operating_working_capital 9151941245.03 '同口径经营性流动资产减经营性流动负债。' medium '若其他应收付款或票据具有融资性质，应调整。'
estimate capital 2025 operating_working_capital 12798004396.63 '同口径经营性流动资产减经营性流动负债；存货130.66亿元为主。' medium '若15.93亿元其他应收款主要为可收回非经营保证金，应重分类。'
estimate capital 2022 operating_long_term_assets_net 3679908965.25 '固定资产、在建工程、使用权资产、无形资产和长期待摊费用，减递延收益及长期应付款。' medium '若长期应付款为融资债务或投资性房地产服务主营，应调整。'
estimate capital 2023 operating_long_term_assets_net 3846096153.90 '同口径经营性长期资产净额。' medium '资产用途或负债性质的进一步披露可推翻。'
estimate capital 2024 operating_long_term_assets_net 3946038725.10 '同口径经营性长期资产净额。' medium '资产用途或负债性质的进一步披露可推翻。'
estimate capital 2025 operating_long_term_assets_net 4552008833.40 '同口径经营性长期资产净额。' medium '资产用途或负债性质的进一步披露可推翻。'
estimate capital 2022 required_cash 550000000 '约为年度收入2%的最低结算与采购缓冲，并参考历史现金低点。' low '月度现金支出、授信可用额或季节性资料可推翻。'
estimate capital 2023 required_cash 643000000 '约为收入2%的最低经营现金。' low '月度现金支出或授信资料可推翻。'
estimate capital 2024 required_cash 787000000 '约为收入2%的最低经营现金。' low '月度现金支出或授信资料可推翻。'
estimate capital 2025 required_cash 991000000 '约为收入2%的最低经营现金；高价金属采购使流动性需求较高。' low '月度现金支出、供应商账期或授信资料可推翻。'
for y in 2022 2023 2024 2025; do estimate capital "$y" unsupported_intangible_assets 0 '账面无商誉；现有无形资产主要服务冶炼经营，未另扣无法解释溢价。' medium '若无形资产附注显示停用或不可收益项目，应扣除。'; done

estimate stable '' revenue 49500000000 '采用2025年规模附近；2026年管理层计划铅、金、银产量继续小幅提升，但不外推金属价格上涨。' medium '若主要产量持续低于2025年或金银价格显著回落，应下调。'
estimate stable '' cost_of_revenue 46777500000 '采用5.5%正常毛利率，接近2024—2025两年毛利率中枢，避免采用单项产品价格高点。' low '加工费、原料供应或套保损失使毛利率长期低于5%，应下调。'
estimate stable '' period_operating_expenses 700000000 '参考三年重构净期间经营费用6.18—8.47亿元，并取规模提升后的7亿元。' medium '政府补助退坡或环保处置费上升使净费用超过9亿元，应上调。'
estimate stable '' cash_tax 404500000 '按稳定EBIT约20%的正常经营现金税估计。' medium '税率优惠或递延税长期变化可推翻。'
estimate stable '' depreciation_amortization 310000000 '采用2025年折旧摊销约3.11亿元作为成熟产能基准。' medium '新增转固使折旧显著增加时应上调。'
estimate stable '' core_business_capex 450000000 '高于折旧，反映重资产冶炼的安全、环保、技改和持续更新需求。' low '若连续多年维持性支出显著低于或高于该数，应重估。'
estimate stable '' exploratory_business_capex 0 '基准估值不为尚未验证的新材料项目持续投入赋值。' medium '若新业务形成稳定订单和利润，应连同投入纳入稳定状态。'
estimate stable '' operating_working_capital_increase 0 '稳定规模下不假定永久新增营运资金；现有高额存货已体现在经营资产和债务中。' medium '若销量或正常库存持续扩张，应改为正数。'

estimate equity '' excess_cash 686976944.76 '货币资金20.04亿元减经营必需现金9.91亿元及受限/非现金等价物3.26亿元。' medium '若资金受限、套保保证金或资本承诺增加，应下调。'
field equity '' non_operating_assets 'lti25+eqi25+ip25' formula '长期股权投资、其他权益工具投资和投资性房地产按账面价值计入，未假设处置溢价。' medium
field equity '' financing_debt 'debt25' reported '短期借款、一年内到期非流动负债、长期借款及租赁负债合计。' high
field equity '' minority_interest_value 'mi25' reported '少数股东权益极小，使用账面值替代经济价值。' medium
estimate equity '' other_priority_claims 0 '未发现未被融资负债或经营资本处理的重大优先索偿。' medium '若存在未入表环保、税务或重大资本付款义务，应加入。'
field equity '' diluted_shares 'shares25' reported '可转债于2025年完成转股/赎回，期末股本作为完全摊薄股数。' high
estimate equity '' financial_to_trading_fx 1 '财报和交易币种均为人民币。' high '若交易币种改变则需换算。'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '公司为强周期、重资本冶炼企业，金属价格、加工费、套保与营运资金需求不足以支持逐年成长折现；采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-business --model "$model" --business-id lead --name '铅产品冶炼与销售' --importance '收入占21%，且2025年毛利为负，是规模与资本占用最大的风险源之一。' --confidence medium --falsifier '若公司披露铅产品含副产品内部结算后的完整利润，需重估费用与现金贡献。'
python3 "$tool" add-business --model "$model" --business-id copper --name '铜产品冶炼与销售' --importance '收入占25%，低毛利、原料价格和加工费敏感。' --confidence medium --falsifier '若铜箔等深加工收入已大量计入铜产品，应另行拆分。'
python3 "$tool" add-business --model "$model" --business-id gold --name '黄金产品冶炼与销售' --importance '收入占22%，贡献公司最大单项产品毛利。' --confidence medium --falsifier '若黄金毛利主要来自一次性库存价差或套保，应下调稳定贡献。'
python3 "$tool" add-business --model "$model" --business-id silver --name '白银产品冶炼与销售' --importance '收入占28%，价格波动和工业需求同时影响利润。' --confidence medium --falsifier '若白银价格回落或原料计价条款压缩加工收益，应重估。'
python3 "$tool" add-business --model "$model" --business-id recovery --name '锌锑硫酸及稀散金属综合回收' --importance '收入占比不高但毛利贡献大，体现多金属回收能力。' --confidence low --falsifier '若附产品成本分摊改变或补助退坡，毛利与现金贡献会显著下降。'

biz() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
bizexpr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence high; }
fact leadrev25 铅产品营业收入 10494845284.89 2025 "$s25" '第16页，主营业务分产品'
fact leadcost25 铅产品营业成本 11004349239.15 2025 "$s25" '第16页，主营业务分产品'
fact copperrev25 铜产品营业收入 12194245727.07 2025 "$s25" '第16页，主营业务分产品'
fact coppercost25 铜产品营业成本 11868273132.86 2025 "$s25" '第16页，主营业务分产品'
fact goldrev25 金产品营业收入 10674634979.10 2025 "$s25" '第16页，主营业务分产品'
fact goldcost25 金产品营业成本 9459814152.35 2025 "$s25" '第16页，主营业务分产品'
fact silverrev25 银产品营业收入 13740112422.10 2025 "$s25" '第16页，主营业务分产品'
fact silvercost25 银产品营业成本 13283035416.68 2025 "$s25" '第16页，主营业务分产品'
for row in \
 'lead revenue leadrev25' 'lead cost_of_revenue leadcost25' \
 'copper revenue copperrev25' 'copper cost_of_revenue coppercost25' \
 'gold revenue goldrev25' 'gold cost_of_revenue goldcost25' \
 'silver revenue silverrev25' 'silver cost_of_revenue silvercost25'; do
  set -- $row; bizexpr "$1" "$2" "$3" '2025年报第16页分产品直接披露。'
done
biz recovery revenue 2449754788.02 estimate '锌、硫酸、锑、披露其他及主营外收入的闭合值。' medium '若公司披露稀散金属独立收入，应重新拆分。'
biz recovery cost_of_revenue 1396267448.93 estimate '锌、硫酸、锑、披露其他及主营外成本的闭合值。' medium '若成本分摊政策变化，应重新拆分。'

for row in \
 'lead 131767726.677946 0 -218302558.001945' \
 'copper 153104499.817799 28424011.544029 49171846.677963' \
 'gold 134025070.987755 177710937.038650 307429334.368440' \
 'silver 172513584.432369 46789628.772155 80943270.394446' \
 'recovery 30757825.444131 168163336.354803 290912553.961095'; do
  set -- $row
  biz "$1" period_operating_expenses "$2" estimate '公司净期间经营费用按业务收入占比分配。' low '若分产品费用、补助和减值披露，应据实替换。'
  biz "$1" cash_tax "$3" estimate '经营现金税仅向正EBIT业务按EBIT比例分配，并闭合公司总额。' low '分业务税率或税收优惠资料可推翻。'
  biz "$1" operating_cash_flow_contribution "$4" estimate '按分业务NOPAT相对权重分配公司CFO，允许亏损铅业务为负，并精确闭合。' low '分产品回款、库存和应付账期资料可推翻。'
done

python3 "$tool" add-adjustment --model "$model" --name '营运资金现金消耗' --before '2025年经营现金流5.10亿元' --after '利润路径倒算营运资金增加10.42亿元' --reason '归母净利润8.60亿元并未等额形成现金；存货增加36.08亿元，部分由应付款和借款支撑。'
python3 "$tool" add-adjustment --model "$model" --name '多余现金' --before '货币资金20.04亿元' --after '可计入普通股价值6.87亿元' --reason '扣除9.91亿元经营必需现金和3.26亿元受限或非现金等价物资金。'
python3 "$tool" add-adjustment --model "$model" --name '新材料项目' --before '铜箔及新型电接触材料2025年在建工程增加0.49亿元' --after '作为开拓性资本开支消耗，不单独加值' --reason '尚缺稳定订单、利润与完整后续投入证据。'

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '重大财务数字均保存披露名称、年度、币种、合并范围及年报页码。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '套保损益与投资收益从EBIT剔除；经营性资产、非经营投资和融资负债未重复计值。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定期结合三年毛利、2025产能和2026产量计划，不机械采用单一年度FCFF。'
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason 'ROIC分母含高额存货及经营现金估计，正文仅用于说明资本占用与回报变化，不宣称形成可持续护城河。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告中心数字将直接引用编译后的转写表，并说明低置信估计和推翻条件。'

python3 "$tool" compile --model "$model"

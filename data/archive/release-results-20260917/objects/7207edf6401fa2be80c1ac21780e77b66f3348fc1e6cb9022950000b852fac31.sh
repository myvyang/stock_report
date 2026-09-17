#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "$5" --scope consolidated --source "$6" --locator "$7"
}
field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}
field_est() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}
stable_est() {
  python3 "$tool" set-field --model "$model" --view stable --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"
}
equity_expr() {
  python3 "$tool" set-field --model "$model" --view equity --field "$1" --expression "$2" --basis-type "$3" --reason "$4" --confidence "$5"
}
equity_est() {
  python3 "$tool" set-field --model "$model" --view equity --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"
}

src23="海昌海洋公园控股有限公司2023年度报告（2024-03-26）"
src24="海昌海洋公园控股有限公司2024年度报告（2025-03-28）"
src25="海昌海洋公园控股有限公司2025年度报告（2026-03-31）"

# 历史经营事实，金额均由财报人民币千元换算为人民币元。
fact rev23 收入 1816842000 2023 CNY "$src23" "PDF p.122，合并损益表"
fact cost23 销售成本 1359387000 2023 CNY "$src23" "PDF p.122，合并损益表"
fact sell23 销售及分销开支 139222000 2023 CNY "$src23" "PDF p.122，合并损益表"
fact admin23 行政费用 469794000 2023 CNY "$src23" "PDF p.122，合并损益表"
fact finimp_rev23 金融及合约资产减值拨回净额 8091000 2023 CNY "$src23" "PDF p.122，合并损益表"
fact otherexp23 其他费用 26551000 2023 CNY "$src23" "PDF p.122，合并损益表"
fact gov23 政府补贴收入 58870000 2023 CNY "$src23" "PDF p.211，附注6"
fact insurance23 保险索偿收入 10654000 2023 CNY "$src23" "PDF p.211，附注6"
fact otherop23 其他收入中的其他 30021000 2023 CNY "$src23" "PDF p.211，附注6"
fact da_ppe23 物業廠房設備折旧 331385000 2023 CNY "$src23" "PDF p.128，合并现金流量表"
fact da_rou23 使用权资产折旧 65572000 2023 CNY "$src23" "PDF p.128，合并现金流量表"
fact amort23 无形资产摊销 8288000 2023 CNY "$src23" "PDF p.128，合并现金流量表"
fact ocf23 经营活动产生的净现金流量 533558000 2023 CNY "$src23" "PDF p.129，合并现金流量表"
fact op_interest23 经营活动内已付利息 10815000 2023 CNY "$src23" "PDF p.129，合并现金流量表"
fact cash_ppe23 购买物業廠房及設備 1319874000 2023 CNY "$src23" "PDF p.129，合并现金流量表"
fact cash_int23 新增无形资产 18745000 2023 CNY "$src23" "PDF p.129，合并现金流量表"
fact disposal_ppe23 出售长期经营资产回款 4117000 2023 CNY "$src23" "PDF p.129，合并现金流量表"

fact rev24 收入 1818358000 2024 CNY "$src24" "PDF p.118，合并损益表"
fact cost24 销售成本 1399393000 2024 CNY "$src24" "PDF p.118，合并损益表"
fact sell24 销售及分销开支 170225000 2024 CNY "$src24" "PDF p.118，合并损益表"
fact admin24 行政费用 719290000 2024 CNY "$src24" "PDF p.118，合并损益表"
fact finimp_rev24 金融资产减值拨回净额 450000 2024 CNY "$src24" "PDF p.118，合并损益表"
fact otherexp24 其他费用 48151000 2024 CNY "$src24" "PDF p.118，合并损益表"
fact gov24 政府补贴收入 37609000 2024 CNY "$src24" "PDF p.192，附注6"
fact insurance24 保险索偿收入 6631000 2024 CNY "$src24" "PDF p.192，附注6"
fact otherop24 其他收入中的其他 9591000 2024 CNY "$src24" "PDF p.192，附注6"
fact da_ppe24 物業廠房設備折旧 319350000 2024 CNY "$src24" "PDF p.124，合并现金流量表"
fact da_rou24 使用权资产折旧 66039000 2024 CNY "$src24" "PDF p.124，合并现金流量表"
fact amort24 无形资产摊销 5078000 2024 CNY "$src24" "PDF p.124，合并现金流量表"
fact ocf24 经营活动产生的净现金流量 121591000 2024 CNY "$src24" "PDF p.125，合并现金流量表"
fact op_interest24 经营活动内已付利息 8971000 2024 CNY "$src24" "PDF p.125，合并现金流量表"
fact cash_ppe24 购买物業廠房及設備 486785000 2024 CNY "$src24" "PDF p.125，合并现金流量表"
fact cash_int24 新增无形资产 3968000 2024 CNY "$src24" "PDF p.125，合并现金流量表"
fact cash_longprepay24 长期预付款现金增加 725701000 2024 CNY "$src24" "PDF p.125，合并现金流量表"

fact rev25 收入 1549161000 2025 CNY "$src25" "PDF p.127（年报页125），合并损益表"
fact cost25 销售成本 1245530000 2025 CNY "$src25" "PDF p.127（年报页125），合并损益表"
fact sell25 销售及分销开支 180067000 2025 CNY "$src25" "PDF p.127（年报页125），合并损益表"
fact admin25 行政费用 621585000 2025 CNY "$src25" "PDF p.127（年报页125），合并损益表"
fact finimp25 金融资产减值拨备净额 33317000 2025 CNY "$src25" "PDF p.127（年报页125），合并损益表"
fact otherexp25 其他费用 40256000 2025 CNY "$src25" "PDF p.127（年报页125），合并损益表"
fact gov25 政府补贴收入 32262000 2025 CNY "$src25" "PDF p.203（年报页201），附注6"
fact insurance25 保险索偿收入 13478000 2025 CNY "$src25" "PDF p.203（年报页201），附注6"
fact otherop25 其他收入中的其他 7448000 2025 CNY "$src25" "PDF p.203（年报页201），附注6"
fact da_ppe25 物業廠房設備折旧 329852000 2025 CNY "$src25" "PDF p.133（年报页131），合并现金流量表"
fact da_rou25 使用权资产折旧 61639000 2025 CNY "$src25" "PDF p.133（年报页131），合并现金流量表"
fact amort25 无形资产摊销 3874000 2025 CNY "$src25" "PDF p.133（年报页131），合并现金流量表"
fact ocf25 经营活动所用净现金流量 -216060000 2025 CNY "$src25" "PDF p.134（年报页132），合并现金流量表"
fact op_interest25 经营活动内已付利息 14211000 2025 CNY "$src25" "PDF p.134（年报页132），合并现金流量表"
fact cash_ppe25 购买物業廠房及設備 135203000 2025 CNY "$src25" "PDF p.134（年报页132），合并现金流量表"
fact cash_rou25 收购使用权资产付款 100694000 2025 CNY "$src25" "PDF p.134（年报页132），合并现金流量表"
fact cash_int25 新增无形资产 1191000 2025 CNY "$src25" "PDF p.134（年报页132），合并现金流量表"

# 历史经营字段。经营现金税在EBIT为负时以零处理；营运资金增加为现金流路径闭合的研究估计。
field_expr historical 2023 revenue rev23 reported "直接取合并收入" high
field_expr historical 2023 cost_of_revenue cost23 reported "直接取合并销售成本" high
field_expr historical 2023 period_operating_expenses 'sell23+admin23-finimp_rev23+otherexp23-gov23-insurance23-otherop23' formula "销售、行政、减值及其他经营开支扣除持续经营相关补贴、保险和杂项收入；剔除利息、投资收益、金融负债修改、投资物业公允价值及联营处置" medium
field_est historical 2023 cash_tax 0 "EBIT为负，无由经营利润产生的正现金税" medium "若税务附注显示当期存在与正经营利润直接对应且不可退回的现金税，则改按该税额"
field_expr historical 2023 depreciation_amortization 'da_ppe23+da_rou23+amort23' formula "现金流量表非现金调整合计" high
field_est historical 2023 core_business_capex 334502000 "现金资本开支合计13.345亿元中，约3.345亿元归于既有公园改造、设备更新及经营无形资产" low "若项目付款明细显示郑州一期等新开项目现金支出低于10亿元，则重分主营与开拓资本开支"
field_est historical 2023 exploratory_business_capex 1000000000 "郑州公园一期于2023年开业且当年公园建设为主要资本用途，将约10亿元列为开拓性投入" low "若公司披露2023年郑州项目现金付款或既有公园维持投入明细，则按项目重分"
field_est historical 2023 operating_working_capital_increase -209604000 "以调整后NOPAT、折旧摊销、经营现金流及经营内利息闭合现金流路径；包含非现金经营调整，不能视作纯资产负债表周转变化" low "若公司披露可逐项对账的经营营运资金现金变动及非现金经营调整，则改用该明细"
field_expr historical 2023 operating_cash_flow ocf23 reported "合并现金流量表经营活动净现金流" high
field_expr historical 2023 after_tax_interest_in_operating_cash_flow op_interest23 reported "经营现金流内列报的利息在融资前口径加回；EBIT为负未设税盾" high

field_expr historical 2024 revenue rev24 reported "直接取合并收入" high
field_expr historical 2024 cost_of_revenue cost24 reported "直接取合并销售成本" high
field_expr historical 2024 period_operating_expenses 'sell24+admin24-finimp_rev24+otherexp24-gov24-insurance24-otherop24' formula "持续经营净期间费用，剔除利息、投资物业公允价值及提前终止租赁收益" medium
field_est historical 2024 cash_tax 0 "EBIT为负，无由经营利润产生的正现金税" medium "若税务附注显示当期存在与正经营利润直接对应且不可退回的现金税，则改按该税额"
field_expr historical 2024 depreciation_amortization 'da_ppe24+da_rou24+amort24' formula "现金流量表非现金调整合计" high
field_est historical 2024 core_business_capex 446805000 "现金资本开支12.165亿元中，约4.468亿元归于既有公园改造、设备与无形资产" low "若郑州二期之外的项目现金付款明细显示不同数额，则重分"
field_est historical 2024 exploratory_business_capex 769649000 "郑州二期建设预付款约7.14亿元并结合OAAS项目投入，列为开拓性资本开支" medium "若郑州二期转为稳定盈利主业或披露项目现金付款明细，则重分"
field_est historical 2024 operating_working_capital_increase -209592000 "以调整后NOPAT、折旧摊销、经营现金流及经营内利息闭合现金流路径；包含非现金经营调整" low "若公司披露可逐项对账的经营营运资金现金变动及非现金经营调整，则改用该明细"
field_expr historical 2024 operating_cash_flow ocf24 reported "合并现金流量表经营活动净现金流" high
field_expr historical 2024 after_tax_interest_in_operating_cash_flow op_interest24 reported "经营现金流内列报的利息在融资前口径加回；EBIT为负未设税盾" high

field_expr historical 2025 revenue rev25 reported "直接取合并收入" high
field_expr historical 2025 cost_of_revenue cost25 reported "直接取合并销售成本" high
field_expr historical 2025 period_operating_expenses 'sell25+admin25+finimp25+otherexp25-gov25-insurance25-otherop25' formula "持续经营净期间费用；剔除利息、投资物业公允价值、金融资产公允价值及提前终止租赁收益" medium
field_est historical 2025 cash_tax 0 "EBIT为负，无由经营利润产生的正现金税；报表所得税抵免主要来自递延税" medium "若税务附注显示当期存在与正经营利润直接对应且不可退回的现金税，则改按该税额"
field_expr historical 2025 depreciation_amortization 'da_ppe25+da_rou25+amort25' formula "现金流量表非现金调整合计，不含资本化折旧" high
field_est historical 2025 core_business_capex 139298000 "现金资本开支2.371亿元中，将公园改造、设施更新和经营无形资产约1.393亿元归于既有主营" low "若现金付款按项目拆分显示既有公园投入不同，则重分"
field_est historical 2025 exploratory_business_capex 97790000 "OAAS分部、物业开发及新项目现金投入约0.978亿元，视为尚未稳定盈利的开拓性资本开支" low "若项目现金付款明细显示OAAS、物业开发及新项目实际投入不同，则重分"
field_est historical 2025 operating_working_capital_increase 78808000 "以调整后NOPAT、折旧摊销、经营现金流及经营内利息闭合现金流路径；包含非现金经营调整" low "若公司披露可逐项对账的经营营运资金现金变动及非现金经营调整，则改用该明细"
field_expr historical 2025 operating_cash_flow ocf25 reported "合并现金流量表经营活动净现金流" high
field_expr historical 2025 after_tax_interest_in_operating_cash_flow op_interest25 reported "经营现金流内列报的利息在融资前口径加回；EBIT为负未设税盾" high

# 资本存量事实和字段。投资物业因租金计入公园收入，归入经营长期资产；待售/开发物业和金融资产另列非经营资产。
for y in 2022 2023 2024 2025; do :; done
fact inv22 存货 31743000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact bio22 生物资产 6980000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact trade_rec22 贸易应收款项 47597000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact prepay_cur22 预付款及其他应收款项 990898000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact trade_pay22 贸易应付款项 649989000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact other_pay_cur22 其他应付款及应计费用 444302000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact advance22 来自客户垫款 10847000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact ppe22 物業廠房及設備 5166069000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact iprop22 投资物业 122477000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact rou22 使用权资产 1476716000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact intang22 无形资产 11683000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact longpre22 长期预付款应收款及按金 217648000 2022 CNY "$src23" "PDF p.124，2022比较财务状况表"
fact grants22 政府补贴负债 418481000 2022 CNY "$src23" "PDF pp.124-125，2022比较财务状况表"
fact longpay22 长期应付款 666761000 2022 CNY "$src23" "PDF p.125，2022比较财务状况表"

fact inv23 存货 54137000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact bio23 生物资产 7005000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact trade_rec23 贸易应收款项 46209000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact prepay_cur23 预付款及其他应收款项 395687000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact trade_pay23 贸易应付款项 735561000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact other_pay_cur23 其他应付款及应计费用 681465000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact advance23 来自客户垫款 11349000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact ppe23 物業廠房及設備 6523087000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact iprop23 投资物业 257349000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact rou23 使用权资产 1484515000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact intang23 无形资产 22140000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact longpre23 长期预付款应收款及按金 146630000 2023 CNY "$src23" "PDF p.124，财务状况表"
fact grants23 政府补贴负债 404522000 2023 CNY "$src23" "PDF pp.124-125，财务状况表"
fact longpay23 长期应付款 771141000 2023 CNY "$src23" "PDF p.125，财务状况表"

fact inv24 存货 62070000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact bio24 生物资产 4071000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact trade_rec24 贸易应收款项 50622000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact prepay_cur24 预付款及其他应收款项 227334000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact trade_pay24 贸易及票据应付款 1035049000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact other_pay_cur24 其他应付款及应计费用 755433000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact advance24 来自客户垫款 10337000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact ppe24 物業廠房及設備 6237390000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact iprop24 投资物业 745500000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact rou24 使用权资产 1592207000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact intang24 无形资产 21030000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact longpre24 长期预付款应收款及按金 872331000 2024 CNY "$src24" "PDF p.120，财务状况表"
fact grants24 政府补贴负债 390630000 2024 CNY "$src24" "PDF pp.120-121，财务状况表"
fact longpay24 长期应付款 23575000 2024 CNY "$src24" "PDF p.121，财务状况表"

fact inv25 存货 71754000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact bio25 生物资产 3642000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact trade_rec25 贸易应收款项 56800000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact prepay_cur25 预付款及其他应收款项 166049000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact trade_pay25 贸易及票据应付款 1026118000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact other_pay_cur25 其他应付款及应计费用 606603000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact advance25 来自客户垫款 40469000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact ppe25 物業廠房及設備 6394952000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact iprop25 投资物业 569603000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact rou25 使用权资产 1544466000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact intang25 无形资产 18228000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact longpre25 长期预付款 489142000 2025 CNY "$src25" "PDF p.129（年报页127），财务状况表及附注23"
fact grants25 政府补贴负债 377162000 2025 CNY "$src25" "PDF p.263（年报页261），附注30"
fact longpay25 长期应付款 0 2025 CNY "$src25" "PDF p.130（年报页128），财务状况表"

for y in 2022 2023 2024 2025; do
  yy=${y:2:2}
  field_expr capital "$y" operating_working_capital "inv${yy}+bio${yy}+trade_rec${yy}+prepay_cur${yy}-trade_pay${yy}-other_pay_cur${yy}-advance${yy}" formula "经营性流动资产减无息经营负债；预付款及其他应收、其他应付款缺少完整经济分类，故解释力有限" low
  field_expr capital "$y" operating_long_term_assets_net "ppe${yy}+iprop${yy}+rou${yy}+intang${yy}+longpre${yy}-grants${yy}-longpay${yy}" formula "经营长期资产扣除资产相关政府补贴及长期应付款；投资物业租金计入公园收入，故保留在经营资产" medium
  if [ "$y" = 2022 ]; then rc=250000000; else rc=300000000; fi
  field_est capital "$y" required_cash "$rc" "按约两个月现金经营支出、文旅淡旺季和高杠杆备用流动性估计" low "若公司披露月度最低运营现金、受限账户或集中资金池可用额度，则据此重估"
  field_expr capital "$y" unsupported_intangible_assets "intang${yy}" reported "账面无形资产未披露足以单独解释持续收益的项目，保守全额剔除" medium
done

# 稳定期不是管理层远期目标，而是三年经营事实下的固定比较标尺。
stable_est revenue 1820000000 "取2023-2024约18.2亿元收入平台，未外推尚未证实的北京等新项目" low "若存量公园连续两年恢复客流和客单价、收入稳定高于20亿元，则上调"
stable_est cost_of_revenue 1365000000 "按约25%正常毛利率估计，略高于2024-2025而接近2023恢复水平" low "若存量公园连续两年毛利率低于22%或高于28%，则改用新常态"
stable_est period_operating_expenses 550000000 "以2023年净期间费用约5.28亿元为下限，并为持续营销、总部和正常信用损失留缓冲；剔除重大减值及公允价值波动" low "若重组后连续两年经审计期间经营费用稳定低于5亿元或高于6亿元，则调整"
stable_est cash_tax 0 "稳定EBIT仍为负，不确认经营现金税" medium "若稳定状态形成正EBIT，则按可持续现金税率计税"
stable_est depreciation_amortization 390000000 "接近2023-2025现金流量表折旧摊销水平" medium "若资产处置或新增项目使年度折旧摊销偏离3.5至4.3亿元区间，则调整"
stable_est core_business_capex 400000000 "重资产公园的常态主营资本开支至少接近折旧摊销，以维持设施、安全、动物保育和内容更新" low "若公司披露分园区维持性资本开支且长期低于或高于4亿元，则改用披露"
stable_est exploratory_business_capex 0 "固定估值标尺不为尚未稳定盈利的新项目赋值，稳定期仅保留主业常态投入" medium "若新项目形成可验证的稳定收入、利润和完整投资需求，则纳入稳定经营"
stable_est operating_working_capital_increase 0 "不假设成熟收入平台永久释放或占用营运资金" medium "若合同负债、票务预收或OAAS账期呈现持续结构性变化，则调整"

# 最新年度业务树。分部毛利为直接披露；期间费用与现金流按驱动因素做闭合估计。
fact park_rev25 公园营运分部收入 1477135000 2025 CNY "$src25" "PDF p.193（年报页191），附注5"
fact park_gp25 公园营运分部业绩即毛利 291656000 2025 CNY "$src25" "PDF p.193（年报页191），附注5"
fact oaas_rev25 运营即服务分部收入 72026000 2025 CNY "$src25" "PDF p.193（年报页191），附注5"
fact oaas_gp25 运营即服务分部业绩即毛利 11975000 2025 CNY "$src25" "PDF p.193（年报页191），附注5"

python3 "$tool" add-business --model "$model" --business-id park --name "主题公园、酒店及园区配套经营" --importance "收入与资产占用绝对核心；游客为门票、园内消费、商品、酒店和租赁场景付款" --confidence high --falsifier "若公司按项目披露显示酒店或配套物业具有独立客户、定价和成本体系且足以改变利润判断，则进一步拆分"
python3 "$tool" add-business --model "$model" --business-id oaas --name "运营即服务（OAAS）" --importance "向政府或项目业主输出规划、建设、动物保育和运营管理能力，是轻资产扩张主线但当前规模较小" --confidence medium --falsifier "若北京等项目合同显示集团承担主要建设资本或收入并非服务费，则应重分类为重资产项目"
python3 "$tool" add-business --model "$model" --business-id property --name "存量物业开发与资产盘活" --importance "当年无收入但占用3.02亿元发展中物业并发生资本投入，影响现金与资产价值" --confidence medium --falsifier "若发展中物业已被纳入公园二期或出租经营并由公园现金流回收，则并回公园业务"

bfield_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
bfield_est() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }

bfield_expr park revenue park_rev25 reported "附注5公园营运分部收入" high
bfield_expr park cost_of_revenue 'park_rev25-park_gp25' formula "分部收入减分部业绩（毛利）" high
bfield_est park period_operating_expenses 740000000 "按员工、营销、总部管理及资产使用主要服务公园的因果关系分配公司净期间费用" low "若公司披露分部EBIT或费用归属，则改用披露"
bfield_est park cash_tax 0 "分部EBIT为负" medium "若分部形成正EBIT并产生现金税，则计税"
bfield_est park operating_cash_flow_contribution -150000000 "依据公园EBIT、折旧规模、合同负债增加及公司现金流闭合估计" low "若公司披露分部经营现金流，则改用披露"

bfield_expr oaas revenue oaas_rev25 reported "附注5运营即服务分部收入" high
bfield_expr oaas cost_of_revenue 'oaas_rev25-oaas_gp25' formula "分部收入减分部业绩（毛利）" high
bfield_est oaas period_operating_expenses 45000000 "按项目人员与开发活动分配期间费用，令业务树闭合" low "若公司披露OAAS分部EBIT或费用归属，则改用披露"
bfield_est oaas cash_tax 0 "分部EBIT为负" medium "若分部形成正EBIT并产生现金税，则计税"
bfield_est oaas operating_cash_flow_contribution -20000000 "按低毛利、项目开发和回款节奏估计，并与公司经营现金流闭合" low "若公司披露OAAS分部经营现金流或项目回款，则改用披露"

bfield_est property revenue 0 "附注5物业营运分部当年收入为零" high "若年报更正或后续重述2025年物业收入，则更新"
bfield_est property cost_of_revenue 0 "无物业收入对应销售成本；当年资产撇减进入期间经营费用" medium "若披露物业销售成本，则更新"
bfield_est property period_operating_expenses 37037000 "将发展中及待售物业撇减与资产盘活相关费用归入该业务，并作为闭合估计" low "若公司披露物业分部费用或撇减归属，则改用披露"
bfield_est property cash_tax 0 "无收入且经营亏损" high "若物业处置产生应税利润，则计税"
bfield_est property operating_cash_flow_contribution -46060000 "按发展中物业现金增加及公司经营现金流闭合估计" low "若公司披露物业分部经营现金流，则改用披露"

# 权益价值桥。
fact cash25 现金及现金等价物 1057624000 2025-12-31 CNY "$src25" "PDF p.129（年报页127）及p.253（年报页251），财务状况表/附注25"
fact restricted25 冻结或受限制银行余额 16544000 2025-12-31 CNY "$src25" "PDF p.253（年报页251），附注25"
fact commitments25 已订约资本承担 330375000 2025-12-31 CNY "$src25" "PDF p.271（年报页269），附注35"
fact fvtpl25 透过损益按公允价值列账金融资产 95796000 2025-12-31 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact propdev25 发展中物业 301845000 2025-12-31 CNY "$src25" "PDF p.129（年报页127），财务状况表"
fact landpre25 土地预付款 63700000 2025-12-31 CNY "$src25" "PDF p.246（年报页244），附注23"
fact assocrec25 应收出售联营公司股权款 9600000 2025-12-31 CNY "$src25" "PDF p.246（年报页244），附注23"
fact borrow25 计息银行及其他借款 5652453000 2025-12-31 CNY "$src25" "PDF pp.129-130及p.258，财务状况表/附注29"
fact lease_debt25 租赁负债 213464000 2025-12-31 CNY "$src25" "PDF pp.129-130及p.260，财务状况表/附注29"
fact nci25 非控股权益账面值 64853000 2025-12-31 CNY "$src25" "PDF p.130（年报页128），财务状况表"
fact issued25 年末已发行普通股 13214002000 2025-12-31 shares "$src25" "PDF p.264（年报页262），附注31"
fact trustee25 股份奖励计划受托人持有股份 9910000 2026-04-29 shares "$src25" "PDF p.77（年报页75），董事会报告"
fact issue_hkd25 股份认购所得款项总额 2295000000 2025-10-17 HKD "$src25" "PDF p.264（年报页262），附注31"
fact issue_rmb25 股份认购所得款项总额人民币约数 1984324000 2025-10-17 CNY "$src25" "PDF p.264（年报页262），附注31"

equity_est excess_cash 410705000 "现金10.576亿元扣除经营必需现金3亿元、冻结0.165亿元及已订约资本承担3.304亿元；其余才视为可分配" low "若资本承担取消、项目融资完全覆盖或公司披露更高最低经营现金，则相应重估"
equity_expr non_operating_assets 'fvtpl25+propdev25+landpre25+assocrec25' formula "未进入核心FCFF的金融资产、无收入的发展中物业、土地预付款及联营处置应收款按账面值计入" low
equity_expr financing_debt 'borrow25+lease_debt25' formula "融资口径包含计息借款与租赁负债；FCFF未扣租赁本金" high
equity_est minority_interest_value 64853000 "缺少非全资子公司独立估值，使用非控股权益账面值作为替代" low "若披露大连老虎滩等非全资子公司的独立现金流、债务与估值，则改用经济价值"
equity_est other_priority_claims 0 "供应商索偿已全额计入应付款，不重复扣除；资本承担已从多余现金中扣除" medium "若出现未入账优先股、已宣告股息或重大未拨备索偿，则新增"
equity_est diluted_shares 13204092000 "已发行132.14002亿股扣除股份奖励计划受托人持有0.09910亿股；期末无未行使购股权" medium "若受托股份具有经济参与权、被注销或期后授出购股权，则调整"
equity_expr financial_to_trading_fx 'issue_hkd25/issue_rmb25' formula "以2025年10月17日同一股份认购交易披露的港元和人民币总额推导近似换算率" medium

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "三年实际EBIT持续为负，OAAS和新项目缺少逐年FCFF、到达稳定期时间和完整投入证据，故仅用稳定经营收益八倍固定标尺；负值表示现有经营未覆盖资本成本，并非可交易的负企业价值" --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-adjustment --model "$model" --name "投资物业公允价值变动" --before "2025年损失1.759亿元" --after "核心EBIT中剔除" --reason "未产生当期经营现金流，且投资物业租金收入已单独计入收入；不以估值波动替代公园经营判断。若物业实际出售，处置现金另行确认。"
python3 "$tool" add-adjustment --model "$model" --name "现金可达性与资本承担" --before "账面现金10.576亿元" --after "多余现金4.107亿元" --reason "扣除经营必需现金3亿元、冻结资金0.165亿元和已订约资本承担3.304亿元；若承诺取消或项目融资覆盖，可释放相应金额。"
python3 "$tool" add-adjustment --model "$model" --name "未稳定项目" --before "郑州二期、北京项目等远期规划" --after "不单独加值" --reason "项目尚缺稳定收入、逐年FCFF和完整剩余投入证据；其已付投入留在经营资产或现金流，未付承诺从可分配现金扣除。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "重大金额均保留披露名称、期间、币种、合并范围、年报名称及PDF页码；估计单列依据和推翻条件。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "利息、金融资产与投资物业公允价值、联营处置等非经营项已从EBIT剔除；租金收入对应投资物业保留在经营资产；开发物业和金融资产进入非经营资产。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期综合2023-2025收入、毛利、费用、折旧与重资产维持投入，未机械外推单年或管理层项目目标，并保留低置信度和反证。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "ROIC分母含大量低置信度周转分类及费用化能力投入，报告仅将其用于说明重资产占用与持续负回报，不作竞争优势比较。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告重大数字、业务闭合、稳定经营收益和普通股价值均以结构化模型为唯一口径。"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

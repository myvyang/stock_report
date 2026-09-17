#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs
python3 "$tool" init --name 柳钢股份 --code 601003.SH --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope "$5" --source "$6" --locator "$7"; }
field_expr() { python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
field_est() { python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }

s23='柳州钢铁股份有限公司2023年年度报告（2024-04-27）'
s24='柳州钢铁股份有限公司2024年年度报告（2025-04-27）'
s25='柳州钢铁股份有限公司2025年年度报告（2026-04-28）'

# 合并经营事实
fact rev23 营业收入 79664570904.61 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第72页，合并利润表'
fact cost23 营业成本 78027363149.88 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第72页，合并利润表'
fact opp23 营业利润 -1512553401.31 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第72页，合并利润表'
fact fin23 财务费用 889794455.98 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第72页，合并利润表'
fact inv23 投资收益 551354.29 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第72页，合并利润表'
fact disp23 资产处置收益 78407.08 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第72页，合并利润表'
fact dafa23 固定资产折旧 2832863698.80 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第170页，现金流量表补充资料'
fact darou23 使用权资产摊销 35451831.48 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第170页，现金流量表补充资料'
fact daia23 无形资产摊销 32784136.70 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第170页，现金流量表补充资料'
fact ocf23 经营活动产生的现金流量净额 252128076.90 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第75页，合并现金流量表'
fact capex23 购建固定资产无形资产和其他长期资产支付的现金 1821890883.88 2023-01-01/2023-12-31 consolidated "$s23" 'PDF第75页，合并现金流量表'

fact rev24 营业收入 70132260562.73 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第69页，合并利润表'
fact cost24 营业成本 67506717003.02 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第69页，合并利润表'
fact opp24 营业利润 -615577419.98 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第70页，合并利润表'
fact fin24 财务费用 952174340.89 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第69页，合并利润表'
fact inv24 投资收益 310362.34 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第69页，合并利润表'
fact fv24 公允价值变动收益 -1056539.98 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第70页，合并利润表'
fact disp24 资产处置收益 17746941.61 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第70页，合并利润表'
fact dafa24 固定资产折旧 2475815835.31 2024-01-01/2024-12-31 consolidated "$s25" 'PDF第145页，现金流量表补充资料上期金额'
fact darou24 使用权资产摊销 35451831.48 2024-01-01/2024-12-31 consolidated "$s25" 'PDF第145页，现金流量表补充资料上期金额'
fact daia24 无形资产摊销 52837509.28 2024-01-01/2024-12-31 consolidated "$s25" 'PDF第145页，现金流量表补充资料上期金额'
fact ocf24 经营活动产生的现金流量净额 2591153688.46 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第72页，合并现金流量表'
fact capex24 购建固定资产无形资产和其他长期资产支付的现金 2195913956.78 2024-01-01/2024-12-31 consolidated "$s24" 'PDF第73页，合并现金流量表'

fact rev25 营业收入 68891055214.72 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第72页，合并利润表'
fact cost25 营业成本 64955025162.85 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第72页，合并利润表'
fact opp25 营业利润 1567526272.19 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第73页，合并利润表'
fact fin25 财务费用 913572220.83 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第72页，合并利润表'
fact inv25 投资收益 1750017.61 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第73页，合并利润表'
fact fv25 公允价值变动收益 8315640.29 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第73页，合并利润表'
fact disp25 资产处置收益 -1562971.96 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第73页，合并利润表'
fact dafa25 固定资产折旧 2812637935.63 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第145页，现金流量表补充资料'
fact darou25 使用权资产摊销 35451831.20 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第145页，现金流量表补充资料'
fact daia25 无形资产摊销 64612729.85 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第145页，现金流量表补充资料'
fact ocf25 经营活动产生的现金流量净额 4470311999.25 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第76页，合并现金流量表'
fact capex25 购建固定资产无形资产和其他长期资产支付的现金 1229649776.75 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第76页，合并现金流量表'

for y in 2023 2024 2025; do
  yy=${y:2:2}
  field_expr historical "$y" revenue "rev${yy}" reported '采用合并利润表营业收入。' high
  field_expr historical "$y" cost_of_revenue "cost${yy}" reported '采用合并利润表营业成本。' high
done
field_expr historical 2023 period_operating_expenses 'rev23-cost23-(opp23+fin23-inv23-disp23)' formula '以营业利润加回财务费用并剔除投资及资产处置收益重构EBIT，再倒算期间经营费用；信用及资产减值、其他收益保留在经营口径。' medium
field_expr historical 2024 period_operating_expenses 'rev24-cost24-(opp24+fin24-inv24-fv24-disp24)' formula '以营业利润加回财务费用并剔除投资、公允价值及资产处置收益重构EBIT，再倒算期间经营费用。' medium
field_expr historical 2025 period_operating_expenses 'rev25-cost25-(opp25+fin25-inv25-fv25-disp25)' formula '以营业利润加回财务费用并剔除投资、公允价值及资产处置收益重构EBIT，再倒算期间经营费用。' medium
for y in 2023 2024 2025; do
  yy=${y:2:2}
  field_est historical "$y" cash_tax 0 '当期经营利润处于亏损或由历史税损及加计扣除覆盖；2025年所得税费用全部为递延所得税，历史期经营现金税取零。' medium '若税务附注明确存在由当期经营EBIT形成的现金所得税，则应按该金额重算。'
  field_expr historical "$y" depreciation_amortization "dafa${yy}+darou${yy}+daia${yy}" formula '合计固定资产折旧、使用权资产摊销和无形资产摊销。' high
  field_expr historical "$y" core_business_capex "capex${yy}" reported '钢铁主业技改、环保、提效和既有产能建设均服务已产生收入的现有业务，归入主营业务资本开支。' medium
  field_est historical "$y" exploratory_business_capex 0 '未发现脱离现有钢铁产品、具有独立商业化路径的新业务资本开支。' medium '若后续披露可独立识别的新业务项目现金投入，则应重分类。'
  field_expr historical "$y" operating_cash_flow "ocf${yy}" reported '采用合并现金流量表经营活动现金流量净额。' high
  field_est historical "$y" after_tax_interest_in_operating_cash_flow 0 '中国准则报表将偿付利息列于筹资活动，经营现金流无需加回税后利息。' high '若现金流附注明确将利息支付计入经营活动，则需加回税后金额。'
done
field_est historical 2023 operating_working_capital_increase 2025582883.38 '以NOPAT+折旧摊销-经营现金流倒推经营性营运资金及其他经营现金调整的合计占用，使利润路径与现金流路径闭合。' medium '若可逐项重构的营运资金变动及非现金调整与该倒推值显著不同，应替换为逐项结果。'
field_est historical 2024 operating_working_capital_increase 292547644.55 '以NOPAT+折旧摊销-经营现金流倒推经营性营运资金及其他经营现金调整的合计占用，使利润路径与现金流路径闭合。' medium '若可逐项重构的营运资金变动及非现金调整与该倒推值显著不同，应替换为逐项结果。'
field_est historical 2025 operating_working_capital_increase 914986304.51 '以NOPAT+折旧摊销-经营现金流倒推经营性营运资金及其他经营现金调整的合计占用，使利润路径与现金流路径闭合。' medium '若可逐项重构的营运资金变动及非现金调整与该倒推值显著不同，应替换为逐项结果。'

# 经营资产分类：流动经营资产减无息经营负债；长期经营资产扣递延收益、递延税负债等。
field_est capital 2022 operating_working_capital -3794921768.25 '按2023年报合并资产负债表第68-69页，将票据应收、应收账款、应收款项融资、预付、其他应收、存货及其他流动资产减经营性应付项目逐项重分类。' medium '若其他应收/应付附注明确有大额融资或非经营项目，应相应重分类。'
field_est capital 2023 operating_working_capital -2834455944.04 '按2023年报合并资产负债表第68-69页逐项重分类计算。' medium '若其他应收/应付附注明确有大额融资或非经营项目，应相应重分类。'
field_est capital 2024 operating_working_capital -4846592451.68 '按2024年报合并资产负债表第65-67页逐项重分类计算。' medium '若其他应收/应付附注明确有大额融资或非经营项目，应相应重分类。'
field_est capital 2025 operating_working_capital -4834170039.42 '按2025年报合并资产负债表第68-70页逐项重分类计算。' medium '若其他应收/应付附注明确有大额融资或非经营项目，应相应重分类。'
field_est capital 2022 operating_long_term_assets_net 47765582401.47 '固定资产、在建工程、使用权资产、无形资产、递延所得税资产和其他经营长期资产，扣递延收益与递延所得税负债。' medium '若投资性资产或资产相关负债的经营归属被新附注明确，应重新分类。'
field_est capital 2023 operating_long_term_assets_net 48418096179.03 '固定资产、在建工程、使用权资产、无形资产、递延所得税资产和其他经营长期资产，扣递延收益、递延所得税负债和预计负债。' medium '若投资性资产或资产相关负债的经营归属被新附注明确，应重新分类。'
field_est capital 2024 operating_long_term_assets_net 50495044954.28 '固定资产、在建工程、使用权资产、无形资产、递延所得税资产和其他经营长期资产，扣递延收益与递延所得税负债。' medium '若投资性资产或资产相关负债的经营归属被新附注明确，应重新分类。'
field_est capital 2025 operating_long_term_assets_net 49561439319.67 '固定资产、在建工程、使用权资产、无形资产、递延所得税资产和其他经营长期资产，扣递延收益、递延所得税负债及预收租金。' medium '若投资性资产或资产相关负债的经营归属被新附注明确，应重新分类。'
field_est capital 2022 required_cash 2500000000 '约覆盖半个月原燃料、人工与税费现金支出，作为重工业连续生产的最低流动性。' low '若公司披露最低现金政策或可用授信足以支持更低现金，应调整。'
field_est capital 2023 required_cash 2400000000 '约覆盖半个月原燃料、人工与税费现金支出，随经营规模调整。' low '若公司披露最低现金政策或可用授信足以支持更低现金，应调整。'
field_est capital 2024 required_cash 2200000000 '约覆盖半个月原燃料、人工与税费现金支出，随经营规模调整。' low '若公司披露最低现金政策或可用授信足以支持更低现金，应调整。'
field_est capital 2025 required_cash 2100000000 '约覆盖半个月原燃料、人工与税费现金支出，考虑供应商信用但保留连续生产缓冲。' low '若公司披露最低现金政策或可用授信足以支持更低现金，应调整。'
for y in 2022 2023 2024 2025; do
  field_est capital "$y" unsupported_intangible_assets 0 '账面无商誉；土地使用权等无形资产服务现有两基地生产，未发现无法解释的并购溢价。' medium '若无形资产附注出现不服务主营或已减值项目，应予剔除。'
done

# 稳定期：三年周期中位与2025改善之间的审慎常态，不采用管理层1800万吨目标直接外推。
field_est stable '' revenue 70000000000 '以三年收入区间688.9亿至796.6亿元为基础，考虑钢价中枢下移和产量恢复，取700亿元常态收入。' medium '若未来两年在同口径下收入持续低于650亿元或高于780亿元，应重估。'
field_est stable '' cost_of_revenue 66850000000 '取4.5%常态毛利率，位于2024年3.74%与2025年5.71%之间，低于单年修复高点。' medium '若原燃料—钢价价差连续两年显著偏离4.5%毛利率，应重估。'
field_est stable '' period_operating_expenses 1800000000 '以三年重构经营费用约14.6亿至23.1亿元为基础，取18亿元，保留正常研发、管理、税费及经营性补助净额。' medium '若费用结构或政府补助连续两年使净经营费用偏离15亿至22亿元，应重估。'
field_est stable '' cash_tax 202500000 '按稳定EBIT 13.5亿元的15%估计，参照广西钢铁高新技术企业税率并考虑集团税损与加计扣除。' low '若税收优惠失效或现金有效税率稳定接近25%，应上调税负。'
field_est stable '' depreciation_amortization 2850000000 '取近三年折旧摊销约25.6亿至29.1亿元的正常水平。' medium '若大规模转固或资产处置使折旧持续偏离，应调整。'
field_est stable '' core_business_capex 2850000000 '重资产钢铁业务长期维持、环保和技改投入不应低于正常折旧，取与折旧相当。' medium '若连续多年在维持产能和合规前提下资本开支显著低于折旧，或新增强制环保投入，则调整。'
field_est stable '' exploratory_business_capex 0 '未对新业务选项赋值，稳定经营仅覆盖现有钢铁体系。' medium '若出现具备独立订单、产能、商业化路径的新业务，应另列成长投入。'
field_est stable '' operating_working_capital_increase 0 '成熟且不增长的稳定状态不假设永久新增营运资金。' medium '若产量结构变化导致库存或账期持续上升，应计入正的常态占用。'

# 价值桥事实与字段
fact cash25 货币资金 3204328850.44 2025-12-31 consolidated "$s25" 'PDF第68页，合并资产负债表'
fact restricted25 受限货币资金 75240157.43 2025-12-31 consolidated "$s25" 'PDF第19页，主要资产受限情况'
fact debt_short25 短期借款 1594130498.32 2025-12-31 consolidated "$s25" 'PDF第69页，合并资产负债表'
fact debt_current25 一年内到期的非流动负债 4811873671.09 2025-12-31 consolidated "$s25" 'PDF第69页，合并资产负债表'
fact debt_long25 长期借款 18076118379.55 2025-12-31 consolidated "$s25" 'PDF第69页，合并资产负债表'
fact bonds25 应付债券 999686227.17 2025-12-31 consolidated "$s25" 'PDF第69页，合并资产负债表'
fact lease25 租赁负债 265866.98 2025-12-31 consolidated "$s25" 'PDF第69页，合并资产负债表'
fact ltp25 融资性长期应付款 233333333.31 2025-12-31 consolidated "$s25" 'PDF第69页及第147页，售后租回融资'
fact ip25 投资性房地产 167157046.16 2025-12-31 consolidated "$s25" 'PDF第69页，合并资产负债表'
fact ltei25 长期股权投资 46507938.81 2025-12-31 consolidated "$s25" 'PDF第69页，合并资产负债表'
fact deriv25 衍生金融资产 227000 2025-12-31 consolidated "$s25" 'PDF第68页，合并资产负债表'
fact newcash26 定向增发募集资金净额 297744950.37 2026-03-07 parent "$s25" 'PDF第56页，期后定向增发'
fact shares26 期后总股本 2634221771 2026-04-28 parent "$s25" 'PDF第2页及第56页'
fact dividend26 2025年度拟派现金红利 263422177.10 2026-04-28 parent "$s25" 'PDF第2页，利润分配预案'
field_est equity '' excess_cash 1326833643.38 '期末货币资金减经营必需现金及受限资金，再加2026年3月定增募集资金净额；未发现集团资金使用重大限制。' low '若募集资金已被不可撤销地承诺用于经营项目，或最低现金需求更高，应下调。'
field_est equity '' non_operating_assets 180638785.74 '投资性房地产按账面八折计值，加长期股权投资与衍生金融资产；反映处置税费、流动性与租赁收益重复风险。' low '若有独立评估或处置价格，或租金已完整计入稳定FCFF，应据此调整。'
field_expr equity '' financing_debt 'debt_short25+debt_current25+debt_long25+bonds25+lease25+ltp25' formula '合计借款、债券、租赁负债及售后租回形成的融资性长期应付款。' high
field_est equity '' minority_interest_value 0 '广西钢铁少数股东账面权益131.03亿元不直接视作经济价值；在稳定经营收益八倍口径下，合并经营价值不足覆盖合并融资负债，少数股权经济价值按有限责任下限取零，避免与债务重复扣减。' low '若广西钢铁独立稳定FCFF、债务与多余现金证明其普通股经济价值为正，应按54.48%扣除。'
field_expr equity '' other_priority_claims 'dividend26' reported '2025年度利润分配预案在普通股估值中作为已提出的优先现金流出。' medium
field_expr equity '' diluted_shares 'shares26' reported '采用年报发布日前已完成定增后的总股本，定增净现金同步进入价值桥。' high
field_est equity '' financial_to_trading_fx 1 '财报与交易均为人民币。' high '若交易币种改变，应按估值日汇率换算。'

# 2025核心业务：五类钢材直接采用产品披露，配套业务承接公司合并总量与主营产品表的差额。
addbiz() { python3 "$tool" add-business --model "$model" --business-id "$1" --name "$2" --importance "$3" --confidence "$4" --falsifier "$5"; }
biz() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
bizexpr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence "$5"; }
fact br_plate 宽厚板主营业务收入 10011455200 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact bc_plate 宽厚板主营业务成本 9244018700 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact br_bar 棒线材主营业务收入 14916794800 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact bc_bar 棒线材主营业务成本 14485634700 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact br_cold 冷轧卷主营业务收入 12603718300 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact bc_cold 冷轧卷主营业务成本 11792494200 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact br_hot 热轧卷主营业务收入 3577984700 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact bc_hot 热轧卷主营业务成本 3378612700 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact br_billet 钢坯主营业务收入 22031434400 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
fact bc_billet 钢坯主营业务成本 20784335200 2025-01-01/2025-12-31 consolidated "$s25" 'PDF第14页，主营业务分产品表'
addbiz plate 宽厚板 '2025年收入100.11亿元，3800mm产线放量，服务船舶海工、风电与工程机械。' medium '若公司披露合并口径分产品费用和现金流，应替换分摊估计。'
addbiz bar 棒线材 '收入149.17亿元，仍是最大成材品类之一，区内建筑钢市占率高。' medium '若公司披露合并口径分产品费用和现金流，应替换分摊估计。'
addbiz cold 冷轧卷 '收入126.04亿元，面向汽车、家电等制造业客户，是高端化核心。' medium '若公司披露合并口径分产品费用和现金流，应替换分摊估计。'
addbiz hot 热轧卷 '收入35.78亿元，2025年销量及收入明显收缩。' medium '若公司披露合并口径分产品费用和现金流，应替换分摊估计。'
addbiz billet 钢坯 '收入220.31亿元，是最大收入品类且盈利受原燃料价差驱动。' medium '若公司披露合并口径分产品费用和现金流，应替换分摊估计。'
addbiz energy 能源化工、冶金副产品与配套服务 '承接能源化工产品及主营产品表与合并口径差额，确保业务树覆盖公司。' low '若公司拆分非主营收入成本，应细分或重新归属。'

for row in \
  'plate 10011455200 9244018700 285336453.228603 0 871609349.878442' \
  'bar 14916794800 14485634700 160307326.674832 0 489686344.674151' \
  'cold 12603718300 11792494200 301616886.175684 0 921340736.864515' \
  'hot 3577984700 3378612700 74127435.107782 0 226435020.101291' \
  'billet 22031434400 20784335200 463677271.738089 0 1416382101.901493' \
  'energy 5749667814.72 5269929662.85 178368871.865010 0 544858445.830109'; do
  read -r id r c e t cash <<<"$row"
  if [[ "$id" == energy ]]; then
    conf=low; reason='收入和成本为合并总量扣除五类已披露钢材后的差额；费用按毛利占比分摊，现金流按NOPAT占比分摊。'; fals='若公司披露配套业务明细，应替换差额法。'
    biz "$id" revenue "$r" estimate "$reason" "$conf" "$fals"
    biz "$id" cost_of_revenue "$c" estimate "$reason" "$conf" "$fals"
  else
    conf=medium; reason='收入和成本来自2025年报第14页分产品主营业务表；费用按毛利占比分摊，现金流按NOPAT占比分摊。'; fals='若公司披露分产品费用和现金流，应替换分摊值。'
    bizexpr "$id" revenue "br_${id}" '采用2025年报主营业务分产品收入。' high
    bizexpr "$id" cost_of_revenue "bc_${id}" '采用2025年报主营业务分产品成本。' high
  fi
  biz "$id" period_operating_expenses "$e" estimate "$reason" "$conf" "$fals"
  biz "$id" cash_tax "$t" estimate '公司历史经营现金税取零，并按各业务EBIT占比分摊为零。' medium '若当期经营产生现金所得税，应按业务利润占比分摊。'
  biz "$id" operating_cash_flow_contribution "$cash" estimate "$reason" "$conf" "$fals"
done

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '钢铁强周期、价格受市场决定，且缺少到达稳定状态前逐年FCFF和完整成长投入证据，采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '投资性房地产及金融投资可实现价值' --before '2.14亿元账面金额' --after '1.81亿元' --reason '投资性房地产按八折计值，再加长期股权投资和衍生金融资产，反映税费、流动性及租赁收益重复风险；独立评估或成交价会推翻折扣。'
python3 "$tool" add-adjustment --model "$model" --name '广西钢铁少数股东权益' --before '131.03亿元账面权益' --after '0亿元经济价值' --reason '固定八倍经营标尺下合并经营价值不足覆盖融资负债，少数股权按有限责任下限取零；若子公司独立FCFF证明正权益价值则重估。'
python3 "$tool" add-adjustment --model "$model" --name '期后定增及分红预案' --before '年末25.63亿股；未含期后现金' --after '26.34亿股；加2.98亿元净现金并扣2.63亿元拟分红' --reason '2026年3月定增已完成，股份与净现金同步纳入，2025年度分红预案作为优先现金流出。'

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '收入、成本、现金流、折旧摊销、资本开支、债务、股本及业务产品数据均保存原披露名称、期间、合并范围和PDF页码。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '金融收益从EBIT剔除，经营与非经营资产、经营现金与多余现金、融资负债、少数股东和期后股本分别分类，业务行闭合到合并总量。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定期使用三年区间、2025产品结构改善及重资产维持投入形成，不机械外推单年利润或管理层产量目标。'
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '投入资本分母约450亿至480亿元且主要由可核验固定资产和在建工程构成；经营必需现金虽为低可信估计但对分母影响有限，ROIC仅用于判断资产效率。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告核心数字、业务闭合、稳定经营收益及普通股价值均以结构化模型的未舍入结果为准。'

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

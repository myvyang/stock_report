#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

fact() { python3 "$tool" add-fact --model "$model" "$@"; }
field() { python3 "$tool" set-field --model "$model" "$@"; }
business() { python3 "$tool" add-business --model "$model" "$@"; }
bfield() { python3 "$tool" set-business-field --model "$model" "$@"; }

src23='首创证券股份有限公司2023年年度报告（2024-04-13）'
src24='首创证券股份有限公司2024年年度报告（2025-04-12）'
src25='首创证券股份有限公司2025年年度报告（2026-03-21）'

fact --fact-id rev23 --reported-item 营业总收入 --amount 1926579845.32 --period 2023年度 --source "$src23" --locator '第138页，合并利润表'
fact --fact-id opex23 --reported-item 营业总支出 --amount 1125871193.57 --period 2023年度 --source "$src23" --locator '第138页，合并利润表'
fact --fact-id tax23 --reported-item 所得税费用 --amount 91468067.04 --period 2023年度 --source "$src23" --locator '第138页，合并利润表'
fact --fact-id da23 --reported-item 折旧及摊销 --amount 101422706.84 --period 2023年度 --source "$src23" --locator '第223页，业务及管理费附注（折旧费、无形资产及长期待摊费用摊销合计）'
fact --fact-id capex23 --reported-item 购建固定资产无形资产和其他长期资产支付的现金 --amount 82339334.95 --period 2023年度 --source "$src23" --locator '第141页，合并现金流量表'
fact --fact-id ocf_reported23 --reported-item 经营活动产生的现金流量净额 --amount -665194128.85 --period 2023年度 --source "$src23" --locator '第22页，主要会计数据'
fact --fact-id equity22 --reported-item 归属于母公司所有者权益合计 --amount 12095234720.63 --period 2022-12-31 --source "$src23" --locator '第25页，合并财务报表主要项目会计数据（重述后）'
fact --fact-id equity23 --reported-item 归属于母公司所有者权益合计 --amount 12346813526.95 --period 2023-12-31 --source "$src23" --locator '第25页，合并财务报表主要项目会计数据'

fact --fact-id rev24 --reported-item 营业总收入 --amount 2417574505.90 --period 2024年度 --source "$src24" --locator '第122页，合并利润表'
fact --fact-id opex24 --reported-item 营业总支出 --amount 1274364573.35 --period 2024年度 --source "$src24" --locator '第122页，合并利润表'
fact --fact-id tax24 --reported-item 所得税费用 --amount 153139783.86 --period 2024年度 --source "$src24" --locator '第122页，合并利润表'
fact --fact-id da24 --reported-item 折旧及摊销 --amount 114796715.63 --period 2024年度 --source "$src24" --locator '第209页，业务及管理费附注'
fact --fact-id capex24 --reported-item 购建固定资产无形资产和其他长期资产支付的现金 --amount 100354830.66 --period 2024年度 --source "$src24" --locator '第127页，合并现金流量表'
fact --fact-id ocf_reported24 --reported-item 经营活动产生的现金流量净额 --amount 413729424.16 --period 2024年度 --source "$src24" --locator '第22页，主要会计数据'
fact --fact-id equity24 --reported-item 归属于母公司所有者权益合计 --amount 13229202180.51 --period 2024-12-31 --source "$src24" --locator '第25页，合并财务报表主要项目会计数据'

fact --fact-id rev25 --reported-item 营业总收入 --amount 2528400797.67 --period 2025年度 --source "$src25" --locator '第117页，合并利润表'
fact --fact-id opex25 --reported-item 营业总支出 --amount 1253952904.25 --period 2025年度 --source "$src25" --locator '第117页，合并利润表'
fact --fact-id tax25 --reported-item 所得税费用 --amount 210397330.05 --period 2025年度 --source "$src25" --locator '第117页，合并利润表'
fact --fact-id da25 --reported-item 折旧及摊销 --amount 116332919.44 --period 2025年度 --source "$src25" --locator '第210页，业务及管理费附注'
fact --fact-id capex25 --reported-item 购建固定资产无形资产和其他长期资产支付的现金 --amount 179000405.54 --period 2025年度 --source "$src25" --locator '第121页，合并现金流量表'
fact --fact-id ocf_reported25 --reported-item 经营活动产生的现金流量净额 --amount 738101737.82 --period 2025年度 --source "$src25" --locator '第21页，主要会计数据'
fact --fact-id equity25 --reported-item 归属于母公司所有者权益合计 --amount 13755592861.26 --period 2025-12-31 --source "$src25" --locator '第25页，合并财务报表主要项目会计数据'
fact --fact-id minority25 --reported-item 少数股东权益 --amount 15717238.03 --period 2025-12-31 --source "$src25" --locator '第25页，合并财务报表主要项目会计数据'
fact --fact-id netcapital25 --reported-item 母公司净资本 --amount 12119129027.19 --period 2025-12-31 --scope parent --source "$src25" --locator '第22页，母公司风险控制指标'
fact --fact-id riskreserve25 --reported-item 各项风险资本准备之和 --amount 5482496405.90 --period 2025-12-31 --scope parent --source "$src25" --locator '第22页，母公司风险控制指标'
fact --fact-id shares25 --reported-item 股本 --amount 2733333800 --period 2025-12-31 --source "$src25" --locator '第25页，合并财务报表主要项目会计数据'
fact --fact-id dividend25 --reported-item 2025年度现金分红金额 --amount 459200078.40 --period 2025年度 --source "$src25" --locator '第70页，利润分配预案（含已实施中期分红）'

for y in 2023 2024 2025; do
  field --view historical --year "$y" --field revenue --expression "rev${y:2:2}" --basis-type reported --reason '合并利润表营业总收入；利息净收入、手续费净收入和投资收益均为券商日常经营收入。' --confidence high
  field --view historical --year "$y" --field cost_of_revenue --expression "opex${y:2:2}" --basis-type reported --reason '券商无工业企业式营业成本，本表把合并营业总支出作为直接经营成本。' --confidence high
  field --view historical --year "$y" --field period_operating_expenses --value 0 --basis-type estimate --reason '业务及管理费已经包含在营业总支出，为避免重复扣除，期间经营费用单列为零。' --confidence high --falsifier '若后续专用券商模板允许把营业总支出进一步拆为履约成本与期间费用，应重列但不改变营业利润。'
  field --view historical --year "$y" --field cash_tax --expression "tax${y:2:2}" --basis-type reported --reason '采用合并利润表所得税费用作为税后营业利润的税负近似。' --confidence medium
  field --view historical --year "$y" --field depreciation_amortization --expression "da${y:2:2}" --basis-type reported --reason '业务及管理费附注中的折旧和摊销合计。' --confidence high
  field --view historical --year "$y" --field core_business_capex --expression "capex${y:2:2}" --basis-type reported --reason '购建固定资产、无形资产和其他长期资产现金支出均视为现有证券业务系统、办公和牌照能力投入。' --confidence medium
  field --view historical --year "$y" --field exploratory_business_capex --value 0 --basis-type estimate --reason '年报没有识别可单独归属尚未稳定盈利新业务的长期资产现金投入。' --confidence medium --falsifier '若项目级资本开支披露显示用于独立新业务且尚未形成收入，应从主营资本开支转列。'
done

field --view historical --year 2023 --field operating_working_capital_increase --value 19083371.89 --basis-type estimate --reason '券商经营现金流受客户资金和交易头寸驱动，不具工业企业含义；以折旧摊销减资本开支作为权益收益代理的配平项。' --confidence low --falsifier '若取得监管资本变动和股东可分配现金的完整专用对账，应替换本配平项。'
field --view historical --year 2024 --field operating_working_capital_increase --value 14441884.97 --basis-type estimate --reason '券商经营现金流受客户资金和交易头寸驱动，不具工业企业含义；以折旧摊销减资本开支作为权益收益代理的配平项。' --confidence low --falsifier '若取得监管资本变动和股东可分配现金的完整专用对账，应替换本配平项。'
field --view historical --year 2025 --field operating_working_capital_increase --value -62667486.10 --basis-type estimate --reason '券商经营现金流受客户资金和交易头寸驱动，不具工业企业含义；以折旧摊销减资本开支作为权益收益代理的配平项。' --confidence low --falsifier '若取得监管资本变动和股东可分配现金的完整专用对账，应替换本配平项。'
field --view historical --year 2023 --field operating_cash_flow --expression 'rev23-opex23-tax23' --basis-type estimate --reason '采用税后营业利润作为券商股东口径经营现金贡献代理，避免把客户资金和证券头寸变动当作可分配现金。' --confidence medium --falsifier '若监管资本增量长期显著高于税后利润留存，应下调。'
field --view historical --year 2024 --field operating_cash_flow --expression 'rev24-opex24-tax24' --basis-type estimate --reason '采用税后营业利润作为券商股东口径经营现金贡献代理，避免把客户资金和证券头寸变动当作可分配现金。' --confidence medium --falsifier '若监管资本增量长期显著高于税后利润留存，应下调。'
field --view historical --year 2025 --field operating_cash_flow --expression 'rev25-opex25-tax25' --basis-type estimate --reason '采用税后营业利润作为券商股东口径经营现金贡献代理，避免把客户资金和证券头寸变动当作可分配现金。' --confidence medium --falsifier '若监管资本增量长期显著高于税后利润留存，应下调。'
for y in 2023 2024 2025; do
  field --view historical --year "$y" --field after_tax_interest_in_operating_cash_flow --expression "capex${y:2:2}" --basis-type estimate --reason '该字段仅作通用脚本的权益收益代理对账：以资本开支同额技术性加回，使现金流路径回到税后营业利润；并非把券商利息视为非经营。' --confidence low --falsifier '专用券商模板无需此技术性对账项时应删除。'
done

for pair in '2022 equity22' '2023 equity23' '2024 equity24' '2025 equity25'; do
  set -- $pair; y=$1; ref=$2
  field --view capital --year "$y" --field operating_working_capital --value 0 --basis-type estimate --reason '券商金融资产负债是主营经营载体，不按工业营运资金拆分。' --confidence high --falsifier '若专用模板要求拆分监管资本构成，则改用净资本明细。'
  field --view capital --year "$y" --field operating_long_term_assets_net --expression "$ref" --basis-type formula --reason '以归母权益作为承担证券业务风险的投入资本代理；专用券商视角下比固定资产更有经济意义。' --confidence medium
  field --view capital --year "$y" --field required_cash --value 0 --basis-type estimate --reason '经营所需流动性已包含于监管权益资本代理，不重复加计现金。' --confidence medium --falsifier '若改用资产端净资本构成，应另估经营必需现金。'
  field --view capital --year "$y" --field unsupported_intangible_assets --value 0 --basis-type estimate --reason '投入资本采用归母权益总额；商誉不另行剔除以避免与权益收益口径不一致，估值亦不单独赋值。' --confidence medium --falsifier '若商誉减值或相关子公司收益无法支持账面权益，应扣除。'
done

field --view stable --field revenue --value 2290858382.963333 --basis-type estimate --reason '采用2023—2025三年营业总收入均值，平衡2024年资管业绩报酬高点与2025年自营投资高点。' --confidence medium --falsifier '若投资收益或资管业绩报酬在完整周期中持续偏离三年均值，应重估。'
field --view stable --field cost_of_revenue --value 1218062890.39 --basis-type estimate --reason '采用三年营业总支出均值，保留当前人员、合规、系统及信用成本。' --confidence medium --falsifier '若费用率在业务结构变化后持续偏离三年均值，应重估。'
field --view stable --field period_operating_expenses --value 0 --basis-type estimate --reason '营业总支出已覆盖期间经营费用，避免重复扣除。' --confidence high --falsifier '专用模板重分类时同步调整成本但不改变营业利润。'
field --view stable --field cash_tax --value 151668393.65 --basis-type estimate --reason '采用三年所得税费用均值，含非应税金融资产收益造成的实际税负结构。' --confidence medium --falsifier '若税法或免税投资收益占比显著改变，应重估。'
field --view stable --field depreciation_amortization --value 115000000 --basis-type estimate --reason '取近两年折旧摊销约1.15亿元作为常态。' --confidence medium --falsifier '若自有办公资产和信息系统投产后折旧显著增加，应上调。'
field --view stable --field core_business_capex --value 115000000 --basis-type estimate --reason '长期以折旧摊销匹配现有业务资本开支，避免把2025年单年1.79亿元直接外推。' --confidence medium --falsifier '若未来三年持续资本开支显著超过折旧且无法带来更高收益，应下调稳定经营收益。'
field --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason '未识别可独立估值的新业务资本开支。' --confidence medium --falsifier '出现具名新业务项目及明确资金计划时重列。'
field --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason '稳定状态下用权益收益口径，不把客户资金和自营证券头寸变动视作永久营运资金占用。' --confidence medium --falsifier '若监管资本要求随收入增长持续提高，应计入所需权益资本增量。'

business --business-id asset_management --name 资产管理类业务 --importance '管理规模增长但业绩报酬周期性强；2025年收入显著回落。' --confidence medium --falsifier '产品费率、业绩报酬与管理规模的持续披露可改变盈利判断。'
business --business-id investing --name 投资类业务 --importance '2025年收入占比超过六成，是利润核心也是市场波动主要来源。' --confidence medium --falsifier '若风险敞口、投资回报或资本占用披露显示收益不可重复，应下调。'
business --business-id investment_banking --name 投资银行类业务 --importance '股债承销与ABS形成订单，收入规模较小但客户协同重要。' --confidence medium --falsifier '项目储备转化率和承销费率持续下降将推翻稳定性判断。'
business --business-id wealth --name 财富管理类业务 --importance '经纪、投顾、两融和期货连接客户流量，2025年交易回暖改善收入。' --confidence medium --falsifier '成交活跃度或两融余额回落且投顾收入无法接替时应下调。'

ids=(asset_management investing investment_banking wealth)
revs=(443838587.8368498 1446770803.4683175 175585197.77438962 462206208.59044325)
costs=(223068506.10084432 354372972.27302754 139723774.01568782 536787651.86044025)
taxes=(36446712.330880836 180342867.074092 5920326.636795622 -12312575.991768405)
cash=(184323369.40512463 912054964.121198 29941097.12190618 -62268867.278228596)
for i in 0 1 2 3; do
  id=${ids[$i]}
  bfield --business-id "$id" --field revenue --value "${revs[$i]}" --basis-type estimate --reason '在年报具名分部收入基础上按正收入比例分摊总部及跨业务抵销，使业务树闭合到合并总收入。' --confidence medium --falsifier '若公司披露总部及抵销归属，则按直接归属重列。'
  bfield --business-id "$id" --field cost_of_revenue --value "${costs[$i]}" --basis-type estimate --reason '在年报具名分部营业支出基础上按正收入比例分摊总部成本，使业务树闭合到合并营业总支出。' --confidence medium --falsifier '若公司披露总部成本驱动与业务归属，则按直接归属重列。'
  bfield --business-id "$id" --field period_operating_expenses --value 0 --basis-type estimate --reason '分部营业支出已覆盖期间费用，避免重复扣除。' --confidence high --falsifier '若专用分部披露能区分直接成本和期间费用，可重分类。'
  bfield --business-id "$id" --field cash_tax --value "${taxes[$i]}" --basis-type estimate --reason '按各业务调整后营业利润比例分配公司所得税；亏损业务确认税盾。' --confidence low --falsifier '分部税务主体或免税收益明细披露后应重列。'
  bfield --business-id "$id" --field operating_cash_flow_contribution --value "${cash[$i]}" --basis-type estimate --reason '采用分部税后营业利润作为券商股东口径现金贡献代理。' --confidence low --falsifier '若监管资本占用和现金分配能按分部取得，应替换为资本调整后贡献。'
done

field --view equity --field excess_cash --value 1154136215.39 --basis-type estimate --reason '以2025年母公司净资本减各项风险资本准备之和的200%作为审慎可释放资本代理。' --confidence low --falsifier '若监管目标、压力测试或业务扩张要求覆盖率长期高于200%，应减少或取消该项。'
field --view equity --field non_operating_assets --value 0 --basis-type estimate --reason '长期股权投资和金融资产收益均进入营业收入，不再重复加回；商誉不单独赋值。' --confidence medium --falsifier '若剥离资产的收益已从稳定经营收益剔除，可按可实现净值加回。'
field --view equity --field financing_debt --value 0 --basis-type estimate --reason '证券公司短融、拆入、回购和债券是自营及资本中介业务经营资金，利息已进入净收入；在权益收益模型中不重复扣债。' --confidence high --falsifier '若识别与证券经营无关的独立融资，应扣除。'
field --view equity --field minority_interest_value --expression minority25 --basis-type formula --reason '以少数股东账面权益近似经济价值，金额不重大。' --confidence medium
field --view equity --field other_priority_claims --value 0 --basis-type estimate --reason '未发现优先股、永续债或未计入收益口径的重大优先索偿。' --confidence medium --falsifier '若期后新增优先工具或重大未决索偿，应扣除。'
field --view equity --field diluted_shares --expression shares25 --basis-type reported --reason '期末股本；报告未显示潜在稀释普通股工具。' --confidence high
field --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason '财报币种与A股交易币种均为人民币。' --confidence high --falsifier '若改用其他币种展示，则按估值日汇率换算。'

python3 "$tool" set-valuation --model "$model" --mode benchmark --stable-multiple 8 --safety-margin-ratio 0.6 --reason '投资收益和资管业绩报酬周期性明显，缺少可验证的逐年成长路径；采用三年标准化税后营业利润八倍作为固定标尺。'
python3 "$tool" add-adjustment --model "$model" --name '经营现金口径' --before '2025年报经营活动现金流7.38亿元' --after '税后营业利润代理10.64亿元' --reason '券商现金流量表受客户资金、回购、拆入和自营金融资产变动主导，不代表股东可分配现金。'
python3 "$tool" add-adjustment --model "$model" --name '总部与跨业务抵销' --before '2025年分部“其他”收入-1.88亿元、支出2.98亿元' --after '按具名业务正收入比例分配' --reason '满足互斥且覆盖公司的业务树要求，不把无经济含义的“其他”作为核心业务。'
python3 "$tool" add-adjustment --model "$model" --name '可释放监管资本' --before '母公司净资本121.19亿元；风险资本准备54.82亿元' --after '按200%覆盖率估计11.54亿元' --reason '只把高于审慎覆盖率的资本作为股东价值加项；该项受监管、压力测试和扩张计划约束。'

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason 'ROIC实质为税后营业利润除平均归母权益的券商ROE代理，不用于与工业企业ROIC横比。'
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '重大直接数均记录年报名称、日期、页码、期间和合并范围。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '融资负债和金融资产按券商经营属性处理；客户资金不视为股东现金，商誉不另行赋值。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定收益采用三年税后营业利润均值，并用折旧匹配常态资本开支，避免单年自营或业绩报酬高点。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告中心数字、业务结构、稳定收益与普通股价值均来自本模型。'

python3 "$tool" compile --model "$model"

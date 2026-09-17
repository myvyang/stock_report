#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
s23='深圳市特发服务股份有限公司2023年年度报告（2024-04-22） https://static.cninfo.com.cn/finalpage/2024-04-22/1219703216.PDF'
s24='深圳市特发服务股份有限公司2024年年度报告（2025-04-21） https://static.cninfo.com.cn/finalpage/2025-04-21/1223151849.PDF'
s25='深圳市特发服务股份有限公司2025年年度报告（2026-04-21） https://static.cninfo.com.cn/finalpage/2026-04-21/1225133300.PDF'

mkdir -p outputs
python3 "$tool" init --name 特发服务 --code 300917.SZ --period-label 2025年年度报告 \
  --period-end 2025-12-31 --coverage-years 2023,2024,2025 \
  --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

af() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope consolidated --source "$5" --locator "$6"; }
sf() { python3 "$tool" set-field --model "$model" "$@"; }

# 利润和现金流控制数
af h23_rev 营业收入 2447601179.81 2023年度 "$s23" '第97页，合并利润表'
af h23_cost 营业成本 2149253817.62 2023年度 "$s23" '第97页，合并利润表'
af h23_tax_surcharge 税金及附加 10836777.60 2023年度 "$s23" '第97页，合并利润表'
af h23_sales 销售费用 18505665.54 2023年度 "$s23" '第97页，合并利润表'
af h23_admin 管理费用 129160192.51 2023年度 "$s23" '第97页，合并利润表'
af h23_rd 研发费用 5118710.22 2023年度 "$s23" '第97页，合并利润表'
af h23_credit_gain 信用减值收益 1144142.53 2023年度 "$s23" '第98页，合并利润表'
af h23_da_fixed 固定资产折旧 13788384.87 2023年度 "$s23" '第186页，现金流量表补充资料'
af h23_da_rou 使用权资产折旧 11519271.84 2023年度 "$s23" '第186页，现金流量表补充资料'
af h23_da_intangible 无形资产摊销 970299.49 2023年度 "$s23" '第186页，现金流量表补充资料'
af h23_da_ltd 长期待摊费用摊销 2817792.31 2023年度 "$s23" '第186页，现金流量表补充资料'
af h23_capex_gross 购建长期资产支付的现金 14276859.58 2023年度 "$s23" '第101页，合并现金流量表'
af h23_disposal 处置长期资产收回的现金净额 936939.96 2023年度 "$s23" '第101页，合并现金流量表'
af h23_lease_cash 支付租赁负债本金和利息 11953075.22 2023年度 "$s23" '第187页，与筹资活动有关的现金'
af h23_ocf 经营活动产生的现金流量净额 212325585.40 2023年度 "$s23" '第101页，合并现金流量表'
af h23_zero_interest 经营现金流中的税后利息调整 0 2023年度 "$s23" '第101页及第187页；利息与租赁付款列在筹资活动，经营现金流无需反加'

af h24_rev 营业收入 2863615951.63 2024年度 "$s24" '第86页，合并利润表'
af h24_cost 营业成本 2526293700.36 2024年度 "$s24" '第86页，合并利润表'
af h24_tax_surcharge 税金及附加 11859885.79 2024年度 "$s24" '第87页，合并利润表'
af h24_sales 销售费用 17572981.60 2024年度 "$s24" '第87页，合并利润表'
af h24_admin 管理费用 142318228.68 2024年度 "$s24" '第87页，合并利润表'
af h24_rd 研发费用 5009115.13 2024年度 "$s24" '第87页，合并利润表'
af h24_credit_loss 信用减值损失 6650469.76 2024年度 "$s24" '第87页，合并利润表'
af h24_da_fixed 固定资产折旧 19140887.76 2024年度 "$s24" '第173页，现金流量表补充资料'
af h24_da_rou 使用权资产折旧 14813159.47 2024年度 "$s24" '第173页，现金流量表补充资料'
af h24_da_intangible 无形资产摊销 1171427.83 2024年度 "$s24" '第173页，现金流量表补充资料'
af h24_da_ltd 长期待摊费用摊销 4278439.65 2024年度 "$s24" '第173页，现金流量表补充资料'
af h24_capex_gross 购建长期资产支付的现金 11016380.66 2024年度 "$s24" '第91页，合并现金流量表'
af h24_disposal 处置长期资产收回的现金净额 279213.44 2024年度 "$s24" '第91页，合并现金流量表'
af h24_lease_cash 支付租赁负债本金和利息 14473329.37 2024年度 "$s24" '第173页，与筹资活动有关的现金'
af h24_ocf 经营活动产生的现金流量净额 122392766.94 2024年度 "$s24" '第90页，合并现金流量表'
af h24_zero_interest 经营现金流中的税后利息调整 0 2024年度 "$s24" '第90页及第173页；利息与租赁付款列在筹资活动，经营现金流无需反加'

af h25_rev 营业收入 2972343254.39 2025年度 "$s25" '第95页，合并利润表'
af h25_cost 营业成本 2619882946.90 2025年度 "$s25" '第95页，合并利润表'
af h25_tax_surcharge 税金及附加 14206445.88 2025年度 "$s25" '第95页，合并利润表'
af h25_sales 销售费用 18608766.14 2025年度 "$s25" '第95页，合并利润表'
af h25_admin 管理费用 145311121.38 2025年度 "$s25" '第95页，合并利润表'
af h25_rd 研发费用 5549013.31 2025年度 "$s25" '第95页，合并利润表'
af h25_credit_loss 信用减值损失 4933101.14 2025年度 "$s25" '第95页，合并利润表'
af h25_da_fixed 固定资产折旧 17394654.26 2025年度 "$s25" '第176页，现金流量表补充资料'
af h25_da_rou 使用权资产折旧 17923840.01 2025年度 "$s25" '第176页，现金流量表补充资料'
af h25_da_intangible 无形资产摊销 1298932.88 2025年度 "$s25" '第176页，现金流量表补充资料'
af h25_da_ltd 长期待摊费用摊销 4012309.29 2025年度 "$s25" '第176页，现金流量表补充资料'
af h25_capex_gross 购建长期资产支付的现金 6983422.77 2025年度 "$s25" '第99页，合并现金流量表'
af h25_disposal 处置长期资产收回的现金净额 646846.67 2025年度 "$s25" '第99页，合并现金流量表'
af h25_lease_cash 支付租赁负债本金和利息 16611276.56 2025年度 "$s25" '第176页，与筹资活动有关的现金'
af h25_ocf 经营活动产生的现金流量净额 168842832.39 2025年度 "$s25" '第99页，合并现金流量表'
af h25_zero_interest 经营现金流中的税后利息调整 0 2025年度 "$s25" '第99页及第176页；利息与租赁付款列在筹资活动，经营现金流无需反加'

for y in 23 24 25; do
  sf --view historical --year "20$y" --field revenue --expression "h${y}_rev" --basis-type reported --reason '合并利润表营业收入。' --confidence high
  sf --view historical --year "20$y" --field cost_of_revenue --expression "h${y}_cost" --basis-type reported --reason '合并利润表营业成本。' --confidence high
  if [ "$y" = 23 ]; then opex="h23_tax_surcharge + h23_sales + h23_admin + h23_rd - h23_credit_gain"; else opex="h${y}_tax_surcharge + h${y}_sales + h${y}_admin + h${y}_rd + h${y}_credit_loss"; fi
  sf --view historical --year "20$y" --field period_operating_expenses --expression "$opex" --basis-type formula --reason '税金及附加、销售、管理、研发及经营性信用损失的净额；剔除财务、理财、联营、公允价值和处置损益。' --confidence high
  sf --view historical --year "20$y" --field cash_tax --value 0 --basis-type estimate --reason '临时值，后续按重构EBIT的25%正常经营税率覆盖。' --confidence medium --falsifier '税收优惠或不可抵扣费用导致长期现金税率显著偏离25%。'
  sf --view historical --year "20$y" --field depreciation_amortization --expression "h${y}_da_fixed + h${y}_da_rou + h${y}_da_intangible + h${y}_da_ltd" --basis-type formula --reason '经营性固定资产、使用权资产、无形资产和长期待摊费用的折旧摊销合计。' --confidence high
  sf --view historical --year "20$y" --field core_business_capex --expression "h${y}_capex_gross - h${y}_disposal + h${y}_lease_cash" --basis-type formula --reason '经营租赁口径：长期资产购建净支出加租赁现金付款，全部服务现有物业和政务业务。' --confidence high
  sf --view historical --year "20$y" --field exploratory_business_capex --value 0 --basis-type estimate --reason '股权收购和理财不属于现金资本开支；未识别出可可靠单列的新技术或新业务长期资产支出。' --confidence medium --falsifier '后续披露长期资产购建中包含尚未商业化新业务的明确金额。'
  sf --view historical --year "20$y" --field operating_working_capital_increase --value 0 --basis-type estimate --reason '临时值，后续以NOPAT、折旧摊销与经营现金流的现金转换差额覆盖。' --confidence medium --falsifier '现金流补充资料出现非营运资金的大额经常调整。'
  sf --view historical --year "20$y" --field operating_cash_flow --expression "h${y}_ocf" --basis-type reported --reason '合并现金流量表经营活动现金流量净额。' --confidence high
  sf --view historical --year "20$y" --field after_tax_interest_in_operating_cash_flow --expression "h${y}_zero_interest" --basis-type reported --reason '利息与租赁付款在筹资活动列示，经营现金流为融资前口径，无需反加。' --confidence high
done

# 用正常经营税率重构现金税，并用现金转换差额得到营运资金增加，使利润路径与现金流路径交叉验证。
sf --view historical --year 2023 --field cash_tax --value 33967539.71 --basis-type estimate --reason '重构EBIT 135,870,158.85元按25%正常税率估计，避免理财及补贴税负混入经营税。' --confidence medium --falsifier '未来三年剔除非经营收益后的现金税率持续低于20%或高于30%。'
sf --view historical --year 2024 --field cash_tax --value 38477892.58 --basis-type estimate --reason '重构EBIT 153,911,570.31元按25%正常税率估计。' --confidence medium --falsifier '未来三年剔除非经营收益后的现金税率持续低于20%或高于30%。'
sf --view historical --year 2025 --field cash_tax --value 40962964.91 --basis-type estimate --reason '重构EBIT 163,851,859.64元按25%正常税率估计。' --confidence medium --falsifier '未来三年剔除非经营收益后的现金税率持续低于20%或高于30%。'
sf --view historical --year 2023 --field operating_working_capital_increase --value -81327265.42 --basis-type estimate --reason 'NOPAT加折旧摊销减经营现金流的现金转换差额；与年报所述销售回款增加一致。' --confidence medium --falsifier '现金流补充资料表明该差额主要来自非经常或非营运项目。'
sf --view historical --year 2024 --field operating_working_capital_increase --value 32446370.09 --basis-type estimate --reason 'NOPAT加折旧摊销减经营现金流的现金转换差额；应收账款增加支持现金占用判断。' --confidence medium --falsifier '现金流补充资料表明该差额主要来自非经常或非营运项目。'
sf --view historical --year 2025 --field operating_working_capital_increase --value -5323874.05 --basis-type estimate --reason 'NOPAT加折旧摊销减经营现金流的现金转换差额；与销售回款改善一致。' --confidence medium --falsifier '现金流补充资料表明该差额主要来自非经常或非营运项目。'

# 资产负债表经营资本。其他流动资产仅保留待抵扣进项税和预缴税费；其他应付款剔除应付股利。
add_cap_facts() {
  local y=$1 src=$2 loc=$3 ar=$4 notes=$5 rf=$6 pre=$7 otherrec=$8 inv=$9 taxasset=${10} ap=${11} contract=${12} emp=${13} taxpay=${14} otherpay=${15} othercur=${16} invprop=${17} fixed=${18} rou=${19} intangible=${20} ltd=${21} goodwill=${22} leasecur=${23} leaselong=${24}
  af c${y}_ar 应收账款 "$ar" ${y}-12-31 "$src" "$loc"
  af c${y}_notes 应收票据 "$notes" ${y}-12-31 "$src" "$loc"
  af c${y}_rf 应收款项融资 "$rf" ${y}-12-31 "$src" "$loc"
  af c${y}_pre 预付款项 "$pre" ${y}-12-31 "$src" "$loc"
  af c${y}_otherrec 其他应收款 "$otherrec" ${y}-12-31 "$src" "$loc"
  af c${y}_inv 存货 "$inv" ${y}-12-31 "$src" "$loc"
  af c${y}_taxasset 其他流动资产中的待抵扣及预缴税费 "$taxasset" ${y}-12-31 "$src" "$loc；其他流动资产附注"
  af c${y}_ap 应付账款 "$ap" ${y}-12-31 "$src" "$loc"
  af c${y}_contract 合同负债 "$contract" ${y}-12-31 "$src" "$loc"
  af c${y}_emp 应付职工薪酬 "$emp" ${y}-12-31 "$src" "$loc"
  af c${y}_taxpay 应交税费 "$taxpay" ${y}-12-31 "$src" "$loc"
  af c${y}_otherpay 其他应付款（不含应付股利） "$otherpay" ${y}-12-31 "$src" "$loc；其他应付款附注"
  af c${y}_othercur 其他流动负债 "$othercur" ${y}-12-31 "$src" "$loc"
  af c${y}_invprop 投资性房地产 "$invprop" ${y}-12-31 "$src" "$loc"
  af c${y}_fixed 固定资产 "$fixed" ${y}-12-31 "$src" "$loc"
  af c${y}_rou 使用权资产 "$rou" ${y}-12-31 "$src" "$loc"
  af c${y}_intangible 无形资产 "$intangible" ${y}-12-31 "$src" "$loc"
  af c${y}_ltd 长期待摊费用 "$ltd" ${y}-12-31 "$src" "$loc"
  af c${y}_goodwill 商誉 "$goodwill" ${y}-12-31 "$src" "$loc"
  af c${y}_leasecur 一年内到期的租赁负债 "$leasecur" ${y}-12-31 "$src" "$loc"
  af c${y}_leaselong 租赁负债 "$leaselong" ${y}-12-31 "$src" "$loc"
}
add_cap_facts 2022 "$s23" '第93-94页，合并资产负债表比较期' 455210357.20 0 0 12005968.33 22563827.11 4749983.80 941731.97 179424268.70 48395071.84 187026624.59 28755102.96 90813473.15 2699463.13 50631942.25 16773560.49 20266215.92 4165732.73 4107102.87 0 10051890.16 14559021.56
add_cap_facts 2023 "$s23" '第93-94页，合并资产负债表' 416937709.25 0 0 9452472.39 55368271.92 4801555.69 2951208.55 232791769.00 48916063.76 200523502.40 28599764.30 107087941.98 1417237.95 48829612.73 49851463.60 30302855.90 6775289.56 7381883.28 19284514.69 13595671.46 21479948.54
add_cap_facts 2024 "$s24" '第82-84页，合并资产负债表' 526577766.06 0 1394413.12 12636275.57 44166979.88 5337872.68 212748.00 317887338.43 30850736.34 192453828.35 34987704.07 126249667.23 650894.79 46317366.29 39390297.01 24895883.20 7202874.45 6258493.50 21549626.05 15218931.03 14275729.07
add_cap_facts 2025 "$s25" '第90-92页，合并资产负债表' 599156642.76 390000 573212.49 23715017.81 46245659.94 4321429.03 4821976.93 386831717.23 38512096.65 199414408.91 31933079.70 132185725.12 1005883.12 43805119.85 27360471.06 16716521.91 7303089.84 5438579.85 21549626.05 13810490.16 7277227.46

for y in 2022 2023 2024 2025; do
  sf --view capital --year "$y" --field operating_working_capital --expression "c${y}_ar + c${y}_notes + c${y}_rf + c${y}_pre + c${y}_otherrec + c${y}_inv + c${y}_taxasset - c${y}_ap - c${y}_contract - c${y}_emp - c${y}_taxpay - c${y}_otherpay - c${y}_othercur" --basis-type formula --reason '经营应收、存货、预付及税项资产减无息经营负债；银行理财和应付股利剔除。' --confidence medium
  sf --view capital --year "$y" --field operating_long_term_assets_net --expression "c${y}_invprop + c${y}_fixed + c${y}_rou + c${y}_intangible + c${y}_ltd + c${y}_goodwill - c${y}_leasecur - c${y}_leaselong" --basis-type formula --reason '经营长期资产含投资物业和商誉，扣除经营口径租赁义务；商誉另行全额剔除。' --confidence medium
  sf --view capital --year "$y" --field required_cash --value 150000000 --basis-type estimate --reason '约覆盖18天年度经营现金支出，并包含履约保函保证金缓冲；物业工资和外包支出按月发生。' --confidence low --falsifier '连续季度在低于1亿元可动用资金下仍可无损经营，或合同预收足以显著降低工资周转需求。'
  sf --view capital --year "$y" --field unsupported_intangible_assets --expression "c${y}_goodwill" --basis-type formula --reason '并购商誉无法独立解释收益，按项目纪律从经营投入资本全额剔除。' --confidence high
done

# 2025年业务树：收入和直接成本披露，费用、税和现金按统一经营利润权重分配。
af b25_property_rev 综合物业管理服务收入 2425328087.74 2025年度 "$s25" '第16页，营业收入分产品'
af b25_property_cost 综合物业管理服务成本 2231222621.29 2025年度 "$s25" '第17-18页，营业成本构成'
af b25_gov_rev 政务服务收入 263513039.54 2025年度 "$s25" '第16页，营业收入分产品'
af b25_gov_cost 政务服务成本 229874512.24 2025年度 "$s25" '第18页，营业成本构成'
af b25_value_rev 增值服务收入 279910287.72 2025年度 "$s25" '第16页，营业收入分产品'
af b25_value_cost 增值服务成本 155615130.99 2025年度 "$s25" '第18页，营业成本构成'
af b25_lease_rev 投资物业租赁收入 3591839.39 2025年度 "$s25" '第16页，其他收入；第17页其他业务成本'
af b25_lease_cost 投资物业租赁成本 3170682.38 2025年度 "$s25" '第18页，其他业务人工及投资性房地产折旧；用1分钱尾差闭合合并成本'

for row in 'property 综合物业与设施管理 b25_property_rev b25_property_cost' 'government 政务服务 b25_gov_rev b25_gov_cost' 'value_added 增值服务 b25_value_rev b25_value_cost' 'leasing 投资物业租赁 b25_lease_rev b25_lease_cost'; do
  set -- $row; id=$1; name=$2; rev=$3; cost=$4
  python3 "$tool" add-business --model "$model" --business-id "$id" --name "$name" --importance '互斥业务分类，收入和成本由年报分产品披露。' --confidence medium --falsifier '后续分部披露显示本分类混合了定价、客户或成本逻辑显著不同的重大业务。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field revenue --expression "$rev" --basis-type reported --reason '2025年报分产品收入。' --confidence high
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field cost_of_revenue --expression "$cost" --basis-type reported --reason '2025年报成本构成汇总。' --confidence high
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field period_operating_expenses --expression "(h25_tax_surcharge + h25_sales + h25_admin + h25_rd + h25_credit_loss) * $rev / h25_rev" --basis-type estimate --reason '财报未分拆期间费用，按收入占比统一分配以闭合公司总量。' --confidence low --falsifier '分业务销售、管理、研发或信用损失明细显示费用率显著不同。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field cash_tax --expression "40962964.91 * ($rev - $cost - (h25_tax_surcharge + h25_sales + h25_admin + h25_rd + h25_credit_loss) * $rev / h25_rev) / (h25_rev - h25_cost - h25_tax_surcharge - h25_sales - h25_admin - h25_rd - h25_credit_loss)" --basis-type estimate --reason '按各业务重构EBIT占比分配正常经营现金税。' --confidence low --falsifier '子公司税率、税收优惠或不可抵扣费用导致业务税率显著分化。'
  python3 "$tool" set-business-field --model "$model" --business-id "$id" --field operating_cash_flow_contribution --expression "h25_ocf * ($rev - $cost - (h25_tax_surcharge + h25_sales + h25_admin + h25_rd + h25_credit_loss) * $rev / h25_rev) / (h25_rev - h25_cost - h25_tax_surcharge - h25_sales - h25_admin - h25_rd - h25_credit_loss)" --basis-type estimate --reason '财报未披露业务现金流，以税前经营利润权重分配并闭合公司经营现金流。' --confidence low --falsifier '分业务应收、预收和支付账期显示现金转换与经营利润权重显著背离。'
done

# 稳定期：2026上半年收入继续增长但没有足够逐年FCFF证据，因此只形成统一基准标尺。
sf --view stable --field revenue --value 3100000000 --basis-type estimate --reason '介于2025年29.72亿元与2026上半年同比增长7.9%的年化水平之间，避免机械外推。' --confidence medium --falsifier '核心大客户流失或全年收入低于29亿元；反之若新项目使收入持续超过33亿元则上修。'
sf --view stable --field cost_of_revenue --value 2734200000 --basis-type estimate --reason '采用11.8%常态毛利率，接近2024-2025年11.78%-11.86%。' --confidence medium --falsifier '人工和外包成本使毛利率连续两年低于10%，或业务结构使其高于13%。'
sf --view stable --field period_operating_expenses --value 195000000 --basis-type estimate --reason '按2025年1.886亿元随业务规模温和增加，保留信用损失成本。' --confidence medium --falsifier '期间费用率连续两年高于7%或低于5.5%。'
sf --view stable --field cash_tax --value 42700000 --basis-type estimate --reason '稳定EBIT 1.708亿元按25%正常经营税率。' --confidence medium --falsifier '经营现金税率持续落在20%-30%区间之外。'
sf --view stable --field depreciation_amortization --value 40000000 --basis-type estimate --reason '取2024-2025年约0.40亿元折旧摊销代表值。' --confidence medium --falsifier '租赁门店或长期资产结构使年度折旧摊销低于0.30亿元或高于0.50亿元。'
sf --view stable --field core_business_capex --value 25000000 --basis-type estimate --reason '接近三年经营长期资产净购建及租赁现金支出的0.23-0.25亿元。' --confidence medium --falsifier '连续两年为维持现有业务支付超过0.40亿元或低于0.15亿元。'
sf --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason '未发现可可靠量化、持续发生且尚未盈利的新业务长期资产投入。' --confidence medium --falsifier '公司披露新业务独立资本预算、商业化里程碑及现金投入。'
sf --view stable --field operating_working_capital_increase --value 15000000 --basis-type estimate --reason '收入仍温和增长且应收占收入约20%，取0.15亿元正常新增占用，剔除年度回款波动。' --confidence low --falsifier '稳定收入后营运资金连续释放，或应收账期继续显著拉长。'

# 股权价值控制数
af e25_cash 货币资金 233921732.50 2025-12-31 "$s25" '第90页，合并资产负债表'
af e25_trading 交易性金融资产 1086856903.70 2025-12-31 "$s25" '第90页，合并资产负债表；第22页说明主要为结构性存款'
af e25_bank_products 其他流动资产中的银行理财产品 32365462.16 2025-12-31 "$s25" '第152页，其他流动资产附注'
af e25_lti 长期股权投资 14886393.22 2025-12-31 "$s25" '第91页，合并资产负债表'
af e25_debt 短期借款 58087175.10 2025-12-31 "$s25" '第91页，合并资产负债表'
af e25_minority 少数股东权益 116768102.26 2025-12-31 "$s25" '第92页，合并资产负债表'
af e25_dividend 2025年度已批准现金股利 50700000 2025年度利润分配 "$s25" '第43页利润分配预案；2026年5月20日股东会后实施'
af e25_shares 期末普通股股本 169000000 2025-12-31 "$s25" '第92页，合并资产负债表及每股收益附注'
af market_price 当前股价 29.82 2026-09-08T14:08:21+08:00 人民币 '中财网特发服务行情页 https://data.cfi.cn/quote93560_300917.html' '2026-09-08 14:08:21盘中报价'

sf --view equity --field expansion_project_value --value 0 --basis-type estimate --reason '没有项目级订单、增量回报和完整资金需求证据，不单独计值。' --confidence medium --falsifier '披露可核验的项目订单、资本预算与增量FCFF。'
sf --view equity --field new_business_option_value --value 0 --basis-type estimate --reason '杭州创新服务等新设业务缺少独立商业验证与现金流证据，作为未计上行。' --confidence medium --falsifier '新业务形成独立规模收入、正现金流及可复现客户获取。'
sf --view equity --field excess_cash --expression 'e25_cash + e25_trading + e25_bank_products - 150000000' --basis-type formula --reason '现金及理财扣除1.50亿元经营必需现金；履约保证金包含在经营缓冲内。' --confidence medium
sf --view equity --field non_operating_assets --expression e25_lti --basis-type reported --reason '联营企业投资收益已从EBIT剔除，对应长期股权投资单独加回；投资物业收入留在经营价值内。' --confidence high
sf --view equity --field financing_debt --expression e25_debt --basis-type reported --reason '短期借款为融资负债；租赁已按经营口径进入资本开支和经营长期资产净额，不重复扣除。' --confidence high
sf --view equity --field minority_interest_value --expression e25_minority --basis-type estimate --reason '缺少全部非全资子公司的独立FCFF和净现金数据，以期末少数股东账面权益作有依据替代值。' --confidence low --falsifier '子公司独立估值显示少数股东份额较账面价值偏离超过20%。'
sf --view equity --field other_priority_claims --expression e25_dividend --basis-type reported --reason '2025年末现金包含随后经股东会批准并支付的每股0.30元现金股利；与2026年9月除息后股价比较时扣除。' --confidence high
sf --view equity --field diluted_shares --expression e25_shares --basis-type reported --reason '基本与稀释每股收益相同，未见实质潜在摊薄工具。' --confidence high
sf --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason '财报与A股交易币种均为人民币。' --confidence high --falsifier '交易币种或列报币种发生变化。'
sf --view equity --field current_price --expression market_price --basis-type reported --reason '2026年9月8日盘中可核验行情，仅用于与年度价值标尺比较。' --confidence high --observed-at '2026年9月8日14:08'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '收入仍增长，但没有稳定状态到达时间和逐年FCFF的充分证据，按纪律采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '理财资产与经营资产分离' --before '货币资金、交易性金融资产及银行理财合计13.53亿元' --after '扣除1.50亿元经营必需现金后，多余现金12.03亿元' --reason '理财收益不进入EBIT，对应资产才可单独加回，避免重复计值。'
python3 "$tool" add-adjustment --model "$model" --name '并购商誉' --before '2025年末0.215亿元' --after '从投入资本全额剔除，估值不单独加回' --reason '现有披露不足以把并购溢价与可持续经营收益独立对应。'
python3 "$tool" add-adjustment --model "$model" --name '除息后市场比较' --before '2025年末尚未扣减的拟派现金股利0.507亿元' --after '作为其他优先索偿扣除' --reason '当前股价观察日在2026年除息后，需把已离开公司的现金从年末资产价值中扣除。'

for item in capital_return_interpretability source_traceability economic_classification stable_state report_consistency; do
  case "$item" in
    capital_return_interpretability) reason='投入资本主要受负营运资金和经营必需现金估计影响，正文将ROIC限定为轻资产资本结构证据而非精确护城河度量。';;
    source_traceability) reason='公司总量与业务收入成本均追溯至三份年报具体页码，市场价格另附公开行情来源。';;
    economic_classification) reason='理财、联营和融资与经营分离，投资物业因实际产生租赁收入保留在经营范围。';;
    stable_state) reason='稳定期结合三年毛利、费用、现金投入及2026半年期变化形成，未机械采用单年FCFF。';;
    report_consistency) reason='报告中心数字将由最终结构化模型和程序生成转写表引用。';;
  esac
  python3 "$tool" set-review --model "$model" --item "$item" --passed --reason "$reason"
done

python3 "$tool" compile --model "$model"

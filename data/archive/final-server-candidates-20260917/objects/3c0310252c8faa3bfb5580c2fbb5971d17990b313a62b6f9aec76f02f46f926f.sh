#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs
python3 "$tool" init --name 长虹华意 --code 000404.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name 普通股 --security-unit 股 --output "$model"

src23='长虹华意压缩机股份有限公司2023年年度报告（2024-03-29） https://static.cninfo.com.cn/finalpage/2024-03-29/1219446362.PDF'
src24='长虹华意压缩机股份有限公司2024年年度报告（2025-04-19） https://static.cninfo.com.cn/finalpage/2025-04-19/1223154247.PDF'
src25='长虹华意压缩机股份有限公司2025年年度报告（2026-04-18） https://static.cninfo.com.cn/finalpage/2026-04-18/1225121004.PDF'

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope consolidated --source "$5" --locator "$6"; }
sf() { python3 "$tool" set-field --model "$model" "$@"; }
bf() { python3 "$tool" set-business-field --model "$model" "$@"; }

# 历史利润、税、折旧摊销、现金流与资本支出的法定披露事实
fact rev23 营业收入 12889012389.22 2023 "$src24" '第100页（2023年比较数）'
fact cost23 营业成本 11285527206.53 2023 "$src24" '第100页（2023年重述比较数）'
fact surtax23 税金及附加 47298498.22 2023 "$src24" '第100页（2023年比较数）'
fact sales23 销售费用 109609252.51 2023 "$src24" '第100页（2023年重述比较数）'
fact admin23 管理费用 403014865.08 2023 "$src24" '第100页（2023年比较数）'
fact rd23 研发费用 476958124.73 2023 "$src24" '第100页（2023年比较数）'
fact otherinc23 其他收益 40256015.42 2023 "$src24" '第100页（2023年比较数）'
fact credit23 信用减值损失 -16604823.04 2023 "$src24" '第100页（2023年比较数）'
fact impair23 资产减值损失 -105533118.05 2023 "$src24" '第100页（2023年比较数）'
fact pbt23 利润总额 579825931.59 2023 "$src23" '第96页'
fact incometax23 所得税费用 48511830.20 2023 "$src23" '第96页'
fact dafix23 固定资产折旧 178048841.34 2023 "$src23" '第211页，现金流量表补充资料'
fact darou23 使用权资产折旧 20770168.91 2023 "$src23" '第211页，现金流量表补充资料'
fact daint23 无形资产摊销 23332806.84 2023 "$src23" '第211页，现金流量表补充资料'
fact dalt23 长期待摊费用摊销 1353961.07 2023 "$src23" '第211页，现金流量表补充资料'
fact ocf23 经营活动产生的现金流量净额 864359604.07 2023 "$src23" '第99页'
fact buycapex23 购建固定资产无形资产和其他长期资产支付的现金 337569441.81 2023 "$src23" '第100页'
fact salecapex23 处置固定资产无形资产和其他长期资产收回的现金净额 1191344.22 2023 "$src23" '第100页'
fact leasepay23 偿还租赁负债本金和利息 16393616.93 2023 "$src23" '第209页，筹资活动现金流补充披露'

fact rev24 营业收入 11966527971.76 2024 "$src24" '第99-100页'
fact cost24 营业成本 10438267461.34 2024 "$src24" '第100页'
fact surtax24 税金及附加 45400532.37 2024 "$src24" '第100页'
fact sales24 销售费用 103038491.15 2024 "$src24" '第100页'
fact admin24 管理费用 348531167.49 2024 "$src24" '第100页'
fact rd24 研发费用 357646196.32 2024 "$src24" '第100页'
fact otherinc24 其他收益 43399985.60 2024 "$src24" '第100页'
fact credit24 信用减值损失 19011426.31 2024 "$src24" '第100页'
fact impair24 资产减值损失 -100897740.46 2024 "$src24" '第100页'
fact pbt24 利润总额 724518990.44 2024 "$src24" '第100页'
fact incometax24 所得税费用 89505628.02 2024 "$src24" '第101页'
fact dafix24 固定资产折旧 163646160.24 2024 "$src24" '第199页，现金流量表补充资料'
fact darou24 使用权资产折旧 12932844.31 2024 "$src24" '第199页，现金流量表补充资料'
fact daint24 无形资产摊销 11442690.51 2024 "$src24" '第199页，现金流量表补充资料'
fact dalt24 长期待摊费用摊销 176669.43 2024 "$src24" '第199页，现金流量表补充资料'
fact ocf24 经营活动产生的现金流量净额 769849682.34 2024 "$src24" '第104页'
fact buycapex24 购建固定资产无形资产和其他长期资产支付的现金 320753138.97 2024 "$src24" '第104-105页'
fact salecapex24 处置固定资产无形资产和其他长期资产收回的现金净额 2824922.52 2024 "$src24" '第104页'
fact leasepay24 偿还租赁负债本金和利息 17659786.37 2024 "$src24" '第198页，筹资活动现金流补充披露'

fact rev25 营业收入 11780825190.49 2025 "$src25" '第92页'
fact cost25 营业成本 10156253082.00 2025 "$src25" '第92页'
fact surtax25 税金及附加 49908904.64 2025 "$src25" '第92页'
fact sales25 销售费用 115124428.32 2025 "$src25" '第92页'
fact admin25 管理费用 323288557.29 2025 "$src25" '第92页'
fact rd25 研发费用 443363166.92 2025 "$src25" '第92页'
fact otherinc25 其他收益 48298438.28 2025 "$src25" '第92页'
fact credit25 信用减值损失 16958713.47 2025 "$src25" '第92页'
fact impair25 资产减值损失 -91846867.80 2025 "$src25" '第92页'
fact pbt25 利润总额 787958818.68 2025 "$src25" '第92页'
fact incometax25 所得税费用 103750983.68 2025 "$src25" '第92页'
fact dafix25 固定资产折旧 169340349.95 2025 "$src25" '第194页，现金流量表补充资料'
fact darou25 使用权资产折旧 15729824.08 2025 "$src25" '第194页，现金流量表补充资料'
fact daint25 无形资产摊销 11669648.08 2025 "$src25" '第194页，现金流量表补充资料'
fact dalt25 长期待摊费用摊销 737782.50 2025 "$src25" '第194页，现金流量表补充资料'
fact ocf25 经营活动产生的现金流量净额 974025090.03 2025 "$src25" '第96页'
fact buycapex25 购建固定资产无形资产和其他长期资产支付的现金 317514184.67 2025 "$src25" '第97页'
fact salecapex25 处置固定资产无形资产和其他长期资产收回的现金净额 3128551.00 2025 "$src25" '第97页'
fact leasepay25 偿还租赁负债本金和利息 20190060.09 2025 "$src25" '第193页，筹资活动现金流补充披露'

# 最新年度分产品、非全资子公司、资金与索偿事实
fact pistonrev25 全封闭活塞压缩机收入 10224644540.54 2025 "$src25" '第15页'
fact pistoncost25 全封闭活塞压缩机成本 8717751335.80 2025 "$src25" '第15页'
fact materialrev25 原材料及配件收入 785486369.24 2025 "$src25" '第15页'
fact materialcost25 原材料及配件成本 729376218.90 2025 "$src25" '第15页'
fact evrev25 新能源汽车空调压缩机收入 668010275.76 2025 "$src25" '第15页'
fact evcost25 新能源汽车空调压缩机成本 610059008.39 2025 "$src25" '第15页'
fact ancillaryrev25 附属业务收入 102684004.95 2025 "$src25" '第15页（财报列名“其他业务收入”）'
fact ancillarycost25 附属业务成本 99066518.91 2025 "$src25" '第15页（财报列名“其他业务收入”）'
fact evnet25 浙江威乐净利润 13119797.67 2025 "$src25" '第200页'
fact evocf25 浙江威乐经营活动现金流量 26004951.37 2025 "$src25" '第200页'
fact cash25 货币资金 5622383400.29 2025-12-31 "$src25" '第85页'
fact restrictedcash25 受限货币资金 286554429.90 2025-12-31 "$src25" '第171页'
fact shortdebt25 短期借款 1506425414.86 2025-12-31 "$src25" '第86页'
fact longdebt25 长期借款 100000000.00 2025-12-31 "$src25" '第87页'
fact currentlongdebt25 一年内到期长期借款及利息 9955000.00 2025-12-31 "$src25" '第175页'
fact minorityprofit25 少数股东损益 189437426.12 2025 "$src25" '第93页'
fact shares25 期末总股本 695995979 2025-12-31 "$src25" '第87页'
fact treasuryshares25 回购专户股份数 11292250 2025-12-31 "$src25" '第1页、第50页'

# 历史经营字段
for y in 23 24 25; do
  year=$((2000+y))
  sf --view historical --year "$year" --field revenue --expression "rev$y" --basis-type reported --reason '合并利润表营业收入' --confidence high
  sf --view historical --year "$year" --field cost_of_revenue --expression "cost$y" --basis-type reported --reason '合并利润表营业成本；2023采用下一年度报告重述比较数以保持费用分类可比' --confidence high
  sf --view historical --year "$year" --field period_operating_expenses --expression "surtax$y + sales$y + admin$y + rd$y - otherinc$y - credit$y - impair$y" --basis-type formula --reason '税金及附加、销售、管理和研发费用，扣除经营性其他收益并计入信用及资产减值；排除财务费用、投资和公允价值损益' --confidence medium
  sf --view historical --year "$year" --field depreciation_amortization --expression "dafix$y + darou$y + daint$y + dalt$y" --basis-type formula --reason '现金流量表补充资料中的经营资产折旧摊销合计' --confidence high
  sf --view historical --year "$year" --field operating_cash_flow --expression "ocf$y" --basis-type reported --reason '合并现金流量表经营活动现金净额' --confidence high
  sf --view historical --year "$year" --field after_tax_interest_in_operating_cash_flow --value 0 --basis-type estimate --reason '中国会计准则现金流量表将已付利息列入筹资活动，本口径经营现金流无需加回税后利息' --confidence high --falsifier '若现金流附注明确将利息支付列入经营活动，则应按税后金额加回'
done

sf --view historical --year 2023 --field cash_tax --value 40554889.2046 --basis-type estimate --reason '以重构EBIT乘当年合并所得税费用/利润总额8.37%估计经营现金税' --confidence medium --falsifier '若披露经营与投资收益对应税费拆分，则以专项拆分替代综合有效税率'
sf --view historical --year 2024 --field cash_tax --value 78466124.4802 --basis-type estimate --reason '以重构EBIT乘当年合并所得税费用/利润总额12.35%估计经营现金税' --confidence medium --falsifier '若披露经营与投资收益对应税费拆分，则以专项拆分替代综合有效税率'
sf --view historical --year 2025 --field cash_tax --value 87731747.2929 --basis-type estimate --reason '以重构EBIT乘当年合并所得税费用/利润总额13.17%估计经营现金税' --confidence medium --falsifier '若披露经营与投资收益对应税费拆分，则以专项拆分替代综合有效税率'

sf --view historical --year 2023 --field core_business_capex --value 322771714.52 --basis-type estimate --reason '购建支出加租赁付款减处置回款后，扣除估计3000万元新能源汽车压缩机开拓投入' --confidence medium --falsifier '若公司披露按项目或业务划分的现金资本开支则据此重分'
sf --view historical --year 2023 --field exploratory_business_capex --value 30000000 --basis-type estimate --reason '新能源汽车空调压缩机尚处客户与产能开拓阶段，按项目进展估计相关现金投入' --confidence low --falsifier '若项目明细显示新能源汽车业务现金投入显著不同则重分'
sf --view historical --year 2024 --field core_business_capex --value 300588002.82 --basis-type estimate --reason '购建支出加租赁付款减处置回款后，扣除估计3500万元新能源汽车压缩机开拓投入' --confidence medium --falsifier '若公司披露按项目或业务划分的现金资本开支则据此重分'
sf --view historical --year 2024 --field exploratory_business_capex --value 35000000 --basis-type estimate --reason '新能源汽车空调压缩机继续处于规模开拓阶段，按产能与产品项目估计' --confidence low --falsifier '若项目明细显示新能源汽车业务现金投入显著不同则重分'
sf --view historical --year 2025 --field core_business_capex --value 294575693.76 --basis-type estimate --reason '购建支出加租赁付款减处置回款后，扣除估计4000万元新能源汽车压缩机开拓投入' --confidence medium --falsifier '若公司披露按项目或业务划分的现金资本开支则据此重分'
sf --view historical --year 2025 --field exploratory_business_capex --value 40000000 --basis-type estimate --reason '浙江威乐实验中心、产线智能化和核心零部件自配仍在拓展，估计相关现金投入' --confidence low --falsifier '若浙江威乐资本开支或项目支付明细披露则以其替代'

sf --view historical --year 2023 --field operating_working_capital_increase --value -163435315.32 --basis-type estimate --reason '按经营应收、预付、存货及合同资产减经营应付、合同负债、职工薪酬、税费和其他经营负债的期末减期初计算；负值为释放' --confidence medium --falsifier '若票据中融资性部分或其他经营往来有更细拆分则重新分类'
sf --view historical --year 2024 --field operating_working_capital_increase --value 20596873.97 --basis-type estimate --reason '同口径经营性营运资金期末减期初；剔除理财、大额存单和融资债务' --confidence medium --falsifier '若票据中融资性部分或其他经营往来有更细拆分则重新分类'
sf --view historical --year 2025 --field operating_working_capital_increase --value -272046789.97 --basis-type estimate --reason '同口径经营性营运资金期末减期初；主要由库存下降与票据融资支持形成现金释放' --confidence medium --falsifier '若票据中融资性部分或其他经营往来有更细拆分则重新分类'

# 资本结构（经营分类涉及研究判断，值与来源页逐年写入理由）
for row in \
  '2022|-1634493730.49|1780191432.89|1000000000|28940970.72|2023年报第89-92页期初数' \
  '2023|-1797929045.81|1535492349.76|1000000000|19321856.64|2023年报第89-92页期末数' \
  '2024|-1777332171.84|1469118016.27|1000000000|19321856.64|2024年报第94-96页期末数' \
  '2025|-2049378961.81|1568183577.18|1000000000|19321856.64|2025年报第85-88页期末数'; do
  IFS='|' read -r year nwc lta req unsupported locator <<<"$row"
  sf --view capital --year "$year" --field operating_working_capital --value "$nwc" --basis-type estimate --reason "$locator；经营流动资产扣除无息经营负债，剔除现金、大额存单、理财和融资债务" --confidence medium --falsifier '若应收票据贴现、应付票据或其他往来披露出融资性质，则相应重分类'
  sf --view capital --year "$year" --field operating_long_term_assets_net --value "$lta" --basis-type estimate --reason "$locator；固定资产、在建工程、使用权资产、经营无形资产及其他经营长期资产，扣除租赁负债、递延收益、长期职工薪酬和质保负债" --confidence medium --falsifier '若长期资产或负债按经营与非经营用途进一步披露，则按实际用途重分'
  sf --view capital --year "$year" --field required_cash --value "$req" --basis-type estimate --reason '约覆盖一个月经营现金流出并留出跨境生产和票据结算缓冲' --confidence low --falsifier '若月度现金支出、最低现金政策或季节性峰值显示所需流动性显著不同则调整'
  sf --view capital --year "$year" --field unsupported_intangible_assets --value "$unsupported" --basis-type estimate --reason "$locator；商誉不以持续经营收益单独证明，作为无法解释并购溢价剔除" --confidence high --falsifier '若可验证的被收购业务超额收益能够单独归因于该商誉，则重新评估'
done

# 稳定状态：收入近三年平稳，结构改善但2026行业存在下行压力，使用基准标尺而非成长折现
sf --view stable --field revenue --value 11800000000 --basis-type estimate --reason '以2024-2025约120亿元收入与2026年118亿元经营目标为锚，避免外推新能源业务高增速' --confidence medium --falsifier '若全封闭活塞压缩机销量或价格连续两年偏离当前水平10%以上则重估'
sf --view stable --field cost_of_revenue --value 10180000000 --basis-type estimate --reason '对应13.73%常态毛利率，低于2025年14.74%的活塞压缩机高点并保留材料与汽车业务低毛利结构' --confidence medium --falsifier '若产品结构升级未能抵消价格与原材料压力、综合毛利率持续低于13%则下调'
sf --view stable --field period_operating_expenses --value 950000000 --basis-type estimate --reason '以2024-2025重构期间经营费用约9-10亿元为常态，保留持续研发和存货减值成本' --confidence medium --falsifier '若研发强度或经营性减值持续显著高于当前水平则上调'
sf --view stable --field cash_tax --value 90000000 --basis-type estimate --reason '约为稳定EBIT的13.4%，接近2025综合有效税率' --confidence medium --falsifier '若税收优惠到期或境外利润占比改变使有效税率持续偏离则调整'
sf --view stable --field depreciation_amortization --value 200000000 --basis-type estimate --reason '接近2024-2025经营资产折旧摊销水平' --confidence medium --falsifier '若产业园、墨西哥和零部件线转固使年度折旧显著上升则调整'
sf --view stable --field core_business_capex --value 250000000 --basis-type estimate --reason '高于当前折旧，覆盖成熟主业技改、智能制造及全球基地的常态更新扩产' --confidence medium --falsifier '若三年平均主业资本开支降至2亿元以下且产能质量不受损则下调'
sf --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason '稳定经营收益不持续扣除尚未形成稳定回报的新能源汽车开拓投入，该选项亦不单独赋值' --confidence low --falsifier '若新能源压缩机形成稳定规模与回报，则把其利润和常态资本需求并入稳定状态'
sf --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason '稳定收入状态下不假定继续依靠降库存或扩大供应商融资释放现金' --confidence medium --falsifier '若正常销量增长或账期变化导致持续营运资金占用则调整为正值'
python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '新能源汽车业务虽增长快，但尚无到达稳定状态时间、逐年FCFF和全部成长投入的充分证据，使用稳定经营收益八倍固定标尺' --stable-multiple 8 --safety-margin-ratio 0.6

# 最新年度互斥业务树及闭合估计
python3 "$tool" add-business --model "$model" --business-id piston --name 全封闭活塞压缩机 --importance '收入与利润主体；全球销量第一，变频和商用结构改善支撑毛利，但行业供过于求和外销回落限制增长。' --confidence medium --falsifier '若公司披露该产品独立期间费用、税和现金流则替代分配估计'
python3 "$tool" add-business --model "$model" --business-id materials --name 原材料及配件销售 --importance '随主机生产与供应链周转形成的低毛利业务，2025年收入明显收缩。' --confidence medium --falsifier '若材料销售主要为内部协同或一次性贸易，应重新界定业务边界'
python3 "$tool" add-business --model "$model" --business-id ev --name 新能源汽车空调压缩机 --importance '销量117万台、收入增长58%的新业务；毛利率仅8.68%，仍处客户、实验能力和产线开拓期。' --confidence medium --falsifier '若浙江威乐外销、内部交易抵消或独立EBIT披露则替代当前估计'
python3 "$tool" add-business --model "$model" --business-id ancillary --name 租赁与生产配套业务 --importance '覆盖年报财报列名“其他业务收入”的租赁、仓储及生产配套活动，规模小且毛利薄。' --confidence low --falsifier '若其他业务收入附注披露具体构成，则按具名活动重分'

for spec in 'piston|pistonrev25|pistoncost25' 'materials|materialrev25|materialcost25' 'ev|evrev25|evcost25' 'ancillary|ancillaryrev25|ancillarycost25'; do
  IFS='|' read -r id rev cost <<<"$spec"
  bf --business-id "$id" --field revenue --expression "$rev" --basis-type reported --reason '2025年报分产品收入控制数' --confidence high
  bf --business-id "$id" --field cost_of_revenue --expression "$cost" --basis-type reported --reason '2025年报分产品成本控制数' --confidence high
done
bf --business-id piston --field period_operating_expenses --value 876823303.52 --basis-type estimate --reason '以全公司期间经营费用为控制数，扣除材料、汽车和配套业务后归属；包含该业务主要研发、管理及经营性减值' --confidence low --falsifier '分产品费用或分部利润披露将替代本分配'
bf --business-id piston --field cash_tax --value 82913604.22 --basis-type estimate --reason '全公司经营现金税扣除材料和汽车业务估计税额后的余额' --confidence low --falsifier '分部税费披露将替代本分配'
bf --business-id piston --field operating_cash_flow_contribution --value 900000000 --basis-type estimate --reason '以公司经营现金流为控制，结合其收入、利润主体地位及成熟业务回款估计' --confidence low --falsifier '分产品经营现金流或应收存货变化披露将替代本分配'
bf --business-id materials --field period_operating_expenses --value 30000000 --basis-type estimate --reason '按低研发、以采购销售和周转管理为主的费用结构估计' --confidence low --falsifier '独立业务费用披露将替代本分配'
bf --business-id materials --field cash_tax --value 3438143.07 --basis-type estimate --reason '按2025综合有效税率估计正经营利润税负' --confidence low --falsifier '独立业务税费披露将替代本分配'
bf --business-id materials --field operating_cash_flow_contribution --value 40000000 --basis-type estimate --reason '结合收入收缩、低毛利和供应链周转估计' --confidence low --falsifier '分产品经营现金流披露将替代本分配'
bf --business-id ev --field period_operating_expenses --value 43451469.70 --basis-type estimate --reason '使外销口径NOPAT近似浙江威乐2025年净利润1312万元，并保留利息与内部交易差异' --confidence low --falsifier '浙江威乐独立营业利润、所得税和抵消明细披露将替代本估计'
bf --business-id ev --field cash_tax --value 1380000 --basis-type estimate --reason '由估计经营利润与浙江威乐净利润差额形成的税费代理' --confidence low --falsifier '浙江威乐所得税费用披露将替代本估计'
bf --business-id ev --field operating_cash_flow_contribution --expression evocf25 --basis-type reported --reason '浙江威乐经营活动现金流作为外销业务贡献代理；内部抵消影响不重大' --confidence medium
bf --business-id ancillary --field period_operating_expenses --value 8000000 --basis-type estimate --reason '按租赁与生产配套活动的小规模管理成本估计，使公司费用总量闭合' --confidence low --falsifier '其他业务具体费用披露将替代本分配'
bf --business-id ancillary --field cash_tax --value 0 --basis-type estimate --reason '估计经营利润为负，不计经营现金税' --confidence low --falsifier '若附属业务独立利润为正且产生税负则调整'
bf --business-id ancillary --field operating_cash_flow_contribution --value 8020138.66 --basis-type estimate --reason '以公司经营现金流为控制数，扣除其余三项业务后闭合' --confidence low --falsifier '附属业务现金流披露将替代本分配'

# 普通股价值桥
sf --view equity --field excess_cash --value 4335828970.39 --basis-type estimate --reason '货币资金56.224亿元，扣除受限资金2.866亿元与经营必需现金10亿元' --confidence medium --falsifier '若集团财务公司存款可达性、资本承诺或季节性最低现金要求显示不可分配金额更高则下调'
sf --view equity --field non_operating_assets --value 2191750877.54 --basis-type estimate --reason '交易性及衍生金融资产、大额存单、债权投资、长期股权投资、其他非流动金融资产与投资性房地产，扣除交易性及衍生金融负债，按账面/公允价值计' --confidence medium --falsifier '若投资存在处置税费、受限或收益已计入稳定FCFF则折价或剔除'
sf --view equity --field financing_debt --value 1616380414.86 --basis-type estimate --reason '短期借款、长期借款及一年内到期长期借款和利息；租赁负债采用经营口径已扣入经营长期资产净额' --confidence high --falsifier '若票据或其他应付款披露融资性质则追加融资负债'
sf --view equity --field minority_interest_value --value 1515499408.96 --basis-type estimate --reason '以2025少数股东损益1.894亿元乘八倍作为其合并经营经济价值代理；主要对应加西贝拉46.22%少数权益' --confidence low --falsifier '若加西贝拉与浙江威乐可单独形成经营价值、净现金及非经营资产桥，则以逐项估值替代'
sf --view equity --field other_priority_claims --value 0 --basis-type estimate --reason '未识别出已宣告未付优先股息或未在经营资本及债务中处理的重大优先索偿；普通股现金分红预案是股东内部价值分配，不重复扣除' --confidence medium --falsifier '若股东会已形成报告期末前不可撤销的重大付款义务或表外资本承诺则纳入'
sf --view equity --field diluted_shares --expression 'shares25 - treasuryshares25' --basis-type formula --reason '期末总股本扣除回购专户股份；无可转债或期权等实质潜在摊薄工具' --confidence high

python3 "$tool" add-adjustment --model "$model" --name '2023费用分类重述' --before '营业成本111.85亿元、销售费用2.10亿元' --after '营业成本112.86亿元、销售费用1.10亿元' --reason '2024年报将约1.00亿元费用从销售费用重分类至营业成本；采用重述数保证三年毛利和期间费用可比，EBIT总额不受影响。'
python3 "$tool" add-adjustment --model "$model" --name '现金与金融资产经营分类' --before '货币资金56.22亿元，另有金融投资约22.03亿元' --after '经营必需现金10亿元；多余现金43.36亿元；净非经营资产21.92亿元' --reason '扣除2.87亿元受限资金，理财、大额存单和股权投资不参与稳定FCFF形成，单列进入普通股价值桥。'
python3 "$tool" add-adjustment --model "$model" --name '商誉剔除' --before '商誉0.193亿元计入长期资产' --after '从投入资本中剔除0.193亿元' --reason '未取得可单独验证的并购超额收益证据，不把会计溢价自动视为经营资产。'

for spec in \
  'capital_return_interpretability|投入资本受供应商票据融资和10亿元经营必需现金估计影响较大，保留ROIC公式结果但正文仅用于说明轻资本与负营运资金结构，不据此直接断言护城河。' \
  'source_traceability|重大财务数均追溯至2023-2025法定年报的报表或附注页码，研究估计写明依据、置信度和推翻条件。' \
  'economic_classification|利息、投资、公允价值与理财资产均从经营口径剔除；租赁统一按经营口径处理，避免双重扣减。' \
  'stable_state|稳定状态结合三年收入、利润率、现金投入与2026目标和行业压力形成，没有机械外推汽车业务单年增速。' \
  'report_consistency|报告中心判断、重大数字、业务闭合和价值桥均以结构化模型的编译结果为准。'; do
  IFS='|' read -r item reason <<<"$spec"
  python3 "$tool" set-review --model "$model" --item "$item" --passed --reason "$reason"
done

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

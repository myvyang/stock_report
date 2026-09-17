#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs

python3 "$tool" init --name 国药股份 --code 600511.SH --period-label 2025年年度报告 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope consolidated --source "$5" --locator "$6"
}

src23='国药股份2023年年度报告（2024-03-21，https://static.cninfo.com.cn/finalpage/2024-03-21/1219360999.PDF）'
src24='国药股份2024年年度报告（2025-03-20，https://static.cninfo.com.cn/finalpage/2025-03-20/1222847076.PDF）'
src25='国药股份2025年年度报告（2026-03-20，https://static.cninfo.com.cn/finalpage/2026-03-20/1225018998.PDF）'

# 历史利润和现金流事实
fact rev23 营业收入 49696045528.87 2023年度 "$src23" 'PDF P085'
fact cost23 营业成本 45704776081.97 2023年度 "$src23" 'PDF P085'
fact taxsur23 税金及附加 114735965.78 2023年度 "$src23" 'PDF P086'
fact sales23 销售费用 962378292.42 2023年度 "$src23" 'PDF P086'
fact mgmt23 管理费用 467127883.37 2023年度 "$src23" 'PDF P086'
fact rd23 研发费用 71197375.91 2023年度 "$src23" 'PDF P086'
fact credit23 信用减值损失 9165197.93 2023年度 "$src23" 'PDF P086'
fact assetimp23 资产减值收益 388870.07 2023年度 "$src23" 'PDF P086'
fact otherinc23 其他收益 81324762.70 2023年度 "$src23" 'PDF P086'
fact disposal23 资产处置收益 83443.40 2023年度 "$src23" 'PDF P086'
fact da_fixed23 固定资产折旧 74799009.60 2023年度 "$src23" 'PDF P179'
fact da_rou23 使用权资产摊销 86664354.72 2023年度 "$src23" 'PDF P179'
fact da_int23 无形资产摊销 38286751.80 2023年度 "$src23" 'PDF P179'
fact da_ltd23 长期待摊费用摊销 8572884.72 2023年度 "$src23" 'PDF P179'
fact capgross23 购建固定资产无形资产和其他长期资产支付的现金 145124184.27 2023年度 "$src23" 'PDF P090'
fact capdispose23 处置固定资产无形资产和其他长期资产收回现金净额 161051.16 2023年度 "$src23" 'PDF P090'
fact leasecash23 与租赁相关的现金流出总额 60547779.44 2023年度 "$src23" 'PDF P184'
fact caprd23 资本化研发支出 69954399.20 2023年度 "$src23" 'PDF P188'
fact wc_inv23 存货增加 243603868.56 2023年度 "$src23" 'PDF P179'
fact wc_rec23 经营性应收项目增加 292548102.02 2023年度 "$src23" 'PDF P179'
fact wc_pay23 经营性应付项目增加 1048141217.07 2023年度 "$src23" 'PDF P179'
fact ocf23 经营活动产生的现金流量净额 2726657097.53 2023年度 "$src23" 'PDF P090'

fact rev24 营业收入 50597449788.57 2024年度 "$src24" 'PDF P086'
fact cost24 营业成本 47002226101.21 2024年度 "$src24" 'PDF P086'
fact taxsur24 税金及附加 129311673.71 2024年度 "$src24" 'PDF P086'
fact sales24 销售费用 805142288.61 2024年度 "$src24" 'PDF P086-P087'
fact mgmt24 管理费用 461529436.04 2024年度 "$src24" 'PDF P087'
fact rd24 研发费用 73707682.75 2024年度 "$src24" 'PDF P087'
fact credit24 信用减值损失 22820890.12 2024年度 "$src24" 'PDF P087'
fact assetimp24 资产减值损失 1066320.03 2024年度 "$src24" 'PDF P087'
fact otherinc24 其他收益 11968624.68 2024年度 "$src24" 'PDF P087'
fact disposal24 资产处置损失 -186992.44 2024年度 "$src24" 'PDF P087'
fact da_fixed24 固定资产折旧 71391097.90 2024年度 "$src24" 'PDF P178-P179'
fact da_rou24 使用权资产摊销 121906216.41 2024年度 "$src24" 'PDF P179'
fact da_int24 无形资产摊销 47240380.75 2024年度 "$src24" 'PDF P179'
fact da_ltd24 长期待摊费用摊销 9527114.56 2024年度 "$src24" 'PDF P179'
fact capgross24 购建固定资产无形资产和其他长期资产支付的现金 130772379.16 2024年度 "$src24" 'PDF P091'
fact capdispose24 处置固定资产无形资产和其他长期资产收回现金净额 387130.00 2024年度 "$src24" 'PDF P091'
fact leasecash24 与租赁相关的现金流出总额 126384930.55 2024年度 "$src24" 'PDF P181'
fact leasesmall24 短期和低价值租赁费用 10321785.42 2024年度 "$src24" 'PDF P181'
fact caprd24 资本化研发支出 50784285.96 2024年度 "$src24" 'PDF P186'
fact wc_inv24 存货增加 993860192.72 2024年度 "$src24" 'PDF P179'
fact wc_rec24 经营性应收项目增加 442419289.56 2024年度 "$src24" 'PDF P179'
fact wc_pay24 经营性应付项目增加 1217684408.04 2024年度 "$src24" 'PDF P179'
fact ocf24 经营活动产生的现金流量净额 1659119523.82 2024年度 "$src24" 'PDF P091'

fact rev25 营业收入 52468280576.72 2025年度 "$src25" 'PDF P078-P079'
fact cost25 营业成本 49008442996.72 2025年度 "$src25" 'PDF P079'
fact taxsur25 税金及附加 137278338.03 2025年度 "$src25" 'PDF P079'
fact sales25 销售费用 724522148.23 2025年度 "$src25" 'PDF P079'
fact mgmt25 管理费用 465457096.70 2025年度 "$src25" 'PDF P079'
fact rd25 研发费用 69305717.06 2025年度 "$src25" 'PDF P079'
fact credit25 信用减值损失 34099335.64 2025年度 "$src25" 'PDF P079'
fact assetimp25 资产减值损失 5563843.29 2025年度 "$src25" 'PDF P079'
fact otherinc25 其他收益 9120795.19 2025年度 "$src25" 'PDF P079'
fact disposal25 资产处置收益 212185.96 2025年度 "$src25" 'PDF P079'
fact da_fixed25 固定资产折旧 73297846.20 2025年度 "$src25" 'PDF P165'
fact da_rou25 使用权资产摊销 110556430.43 2025年度 "$src25" 'PDF P165'
fact da_int25 无形资产摊销 54366923.24 2025年度 "$src25" 'PDF P165'
fact da_ltd25 长期待摊费用摊销 10067575.50 2025年度 "$src25" 'PDF P165'
fact capgross25 购建固定资产无形资产和其他长期资产支付的现金 68194378.17 2025年度 "$src25" 'PDF P082-P083'
fact capdispose25 处置固定资产无形资产和其他长期资产收回现金净额 202302.25 2025年度 "$src25" 'PDF P082'
fact leasecash25 与租赁相关的现金流出总额 143437500.49 2025年度 "$src25" 'PDF P167'
fact leasesmall25 短期和低价值租赁费用 8388712.88 2025年度 "$src25" 'PDF P167'
fact caprd25 资本化研发支出 19935713.37 2025年度 "$src25" 'PDF P169'
fact wc_inv25 存货增加 240873051.48 2025年度 "$src25" 'PDF P165'
fact wc_rec25 经营性应收项目增加 692570321.85 2025年度 "$src25" 'PDF P165'
fact wc_pay25 经营性应付项目增加 1140496132.06 2025年度 "$src25" 'PDF P165'
fact ocf25 经营活动产生的现金流量净额 2005517512.06 2025年度 "$src25" 'PDF P082'

# 资产分类的底层事实，直接保存已按附注经济分类后的合计控制数
fact owc22 经营性营运资金重分类合计 4542963929.52 2022-12-31 "$src23" 'PDF P081-P083（比较数；经营应收存货预付等减经营应付）'
fact owc23 经营性营运资金重分类合计 3898932577.15 2023-12-31 "$src23" 'PDF P081-P083（经营应收存货预付等减经营应付）'
fact owc24 经营性营运资金重分类合计 5203996045.25 2024-12-31 "$src24" 'PDF P082-P084（经营应收存货预付等减经营应付）'
fact owc25 经营性营运资金重分类合计 5584088243.90 2025-12-31 "$src25" 'PDF P074-P076（经营应收存货预付等减经营应付）'
fact olt22 经营性长期资产净额重分类合计 2051097552.36 2022-12-31 "$src23" 'PDF P081-P083（比较数；经营长期资产减递延收益）'
fact olt23 经营性长期资产净额重分类合计 2078970290.03 2023-12-31 "$src23" 'PDF P081-P083（经营长期资产减递延收益）'
fact olt24 经营性长期资产净额重分类合计 2191198087.14 2024-12-31 "$src24" 'PDF P082-P084（经营长期资产减递延收益）'
fact olt25 经营性长期资产净额重分类合计 2015800677.30 2025-12-31 "$src25" 'PDF P074-P076（经营长期资产减递延收益）'
fact goodwill22 商誉 203770428.49 2022-12-31 "$src23" 'PDF P082（比较数）'
fact goodwill23 商誉 203770428.49 2023-12-31 "$src23" 'PDF P082'
fact goodwill24 商誉 203770428.49 2024-12-31 "$src24" 'PDF P082'
fact goodwill25 商誉 203770428.49 2025-12-31 "$src25" 'PDF P075'

# 2025价值桥事实
fact cash25 货币资金 11481694549.72 2025-12-31 "$src25" 'PDF P074'
fact restricted25 受限货币资金 2589648277.42 2025-12-31 "$src25" 'PDF P021'
fact debt25 短期借款 222305815.78 2025-12-31 "$src25" 'PDF P075'
fact associate_profit25 权益法长期股权投资收益 546993889.12 2025年度 "$src25" 'PDF P159'
fact associate_book25 长期股权投资 2313086323.50 2025-12-31 "$src25" 'PDF P075,P128'
fact financial_assets25 其他权益工具和其他非流动金融资产 152014972.18 2025-12-31 "$src25" 'PDF P023-P024'
fact investment_property25 投资性房地产 15227643.84 2025-12-31 "$src25" 'PDF P075'
fact minority25 少数股东权益 1763504165.05 2025-12-31 "$src25" 'PDF P076'
fact dividend_payable25 应付股利 152044619.00 2025-12-31 "$src25" 'PDF P145'
fact proposed_dividend25 2025年度拟派现金股利 603602398.40 2025年度利润分配方案 "$src25" 'PDF P041'
fact shares25 期末普通股股数 754502998 2025-12-31 "$src25" 'PDF P076'

# 历史标准字段
for y in 2023 2024 2025; do
  yy=${y#20}
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field revenue --expression "rev$yy" --basis-type reported --reason '合并利润表营业收入' --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field cost_of_revenue --expression "cost$yy" --basis-type reported --reason '合并利润表营业成本' --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field period_operating_expenses --expression "taxsur$yy + sales$yy + mgmt$yy + rd$yy + credit$yy + assetimp$yy - otherinc$yy - disposal$yy" --basis-type formula --reason '包含税金附加、销售管理研发费用及经营性减值，抵减经营相关其他收益和处置收益；排除财务与投资收益' --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field cash_tax --value "$(case $y in 2023) echo 489692361.532;; 2024) echo 422685405.668;; 2025) echo 406588816.44;; esac)" --basis-type estimate --reason '按重构EBIT的20%估计正常经营现金税，避免把联营投资收益及融资税效混入' --confidence medium --falsifier '税务附注明确披露可持续经营实际现金税率显著偏离20%'
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field depreciation_amortization --expression "da_fixed$yy + da_rou$yy + da_int$yy + da_ltd$yy" --basis-type formula --reason '现金流量补充资料中的常规折旧摊销合计' --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field operating_working_capital_increase --expression "wc_inv$yy + wc_rec$yy - wc_pay$yy" --basis-type formula --reason '现金流量补充资料所列存货、经营应收与经营应付净变动，正数代表占用现金' --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field operating_cash_flow --expression "ocf$yy" --basis-type reported --reason '合并现金流量表经营活动现金流量净额' --confidence high
  python3 "$tool" set-field --model "$model" --view historical --year "$y" --field after_tax_interest_in_operating_cash_flow --value 0 --basis-type estimate --reason '利息与租赁本金在筹资现金流列示，经营现金流无需再加回税后利息' --confidence medium --falsifier '现金流附注明确显示利息付款计入经营活动现金流'
done

python3 "$tool" set-field --model "$model" --view historical --year 2023 --field core_business_capex --value 135556513.35 --basis-type estimate --reason '购建长期资产净现金支出加租赁现金流出，扣除资本化研发后视为现有业务投入' --confidence medium --falsifier '公司披露租赁现金流中的短租费用或资本化研发并未进入购建长期资产现金支出'
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field exploratory_business_capex --expression caprd23 --basis-type formula --reason '资本化研发用于尚未稳定盈利的工业新品研发，作为开拓性投入' --confidence medium
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field core_business_capex --value 195664238.33 --basis-type estimate --reason '购建长期资产净现金支出加长期租赁现金流出，扣除资本化研发后为现有业务投入' --confidence medium --falsifier '租赁或研发现金流分类获得更精确披露'
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field exploratory_business_capex --expression caprd24 --basis-type formula --reason '资本化研发用于尚未稳定盈利的工业新品研发，作为开拓性投入' --confidence medium
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field core_business_capex --value 183105092.56 --basis-type estimate --reason '购建长期资产净现金支出加长期租赁现金流出，扣除资本化研发后为现有业务投入' --confidence medium --falsifier '租赁或研发现金流分类获得更精确披露'
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field exploratory_business_capex --expression caprd25 --basis-type formula --reason '资本化研发用于尚未稳定盈利的工业新品研发，作为开拓性投入' --confidence medium

# 资本视图
for y in 2022 2023 2024 2025; do
  yy=${y#20}
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field operating_working_capital --expression "owc$yy" --basis-type formula --reason '经营性流动资产扣除无息经营负债；剔除现金、借款、应付股利和应付利息' --confidence medium
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field operating_long_term_assets_net --expression "olt$yy" --basis-type formula --reason '固定资产、在建工程、使用权资产、经营无形资产、开发支出、商誉、长期待摊及战略储备等减递延收益' --confidence medium
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field required_cash --value 2000000000 --basis-type estimate --reason '约半个月商品采购和经营支出的流动性缓冲；公司另有票据结算和银行授信' --confidence low --falsifier '月度现金转换周期、集中付款安排或最低现金政策显示需求显著不同'
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field unsupported_intangible_assets --expression "goodwill$yy" --basis-type formula --reason '商誉不直接作为经营投入价值，经营能力由收益反推' --confidence high
done

# 稳定期：证据不足以形成逐年成长路径，因此使用固定八倍标尺
python3 "$tool" set-field --model "$model" --view stable --field revenue --value 52500000000 --basis-type estimate --reason '取2025年规模附近，行业增速放缓且公司从规模扩张转向质量效益' --confidence medium --falsifier '连续两年收入偏离525亿元超过10%且并非短期价格因素'
python3 "$tool" set-field --model "$model" --view stable --field cost_of_revenue --value 48982500000 --basis-type estimate --reason '按6.7%正常毛利率估计，略高于2025年6.59%但低于2024年7.10%' --confidence medium --falsifier '集采和服务费转型使毛利率连续两年低于6.2%或高于7.2%'
python3 "$tool" set-field --model "$model" --view stable --field period_operating_expenses --value 1430000000 --basis-type estimate --reason '接近2025年重构期间经营费用，保留合规、营销、研发和信用成本' --confidence medium --falsifier '费用率连续两年偏离收入的2.5%-3.0%区间'
python3 "$tool" set-field --model "$model" --view stable --field cash_tax --value 417500000 --basis-type estimate --reason '按稳定EBIT的20%经营现金税率' --confidence medium --falsifier '持续税收优惠或税率变化使正常税率显著偏离20%'
python3 "$tool" set-field --model "$model" --view stable --field depreciation_amortization --value 248000000 --basis-type estimate --reason '采用2024-2025常规折旧摊销水平' --confidence medium --falsifier '租赁面积、固定资产或无形资产结构发生重大变化'
python3 "$tool" set-field --model "$model" --view stable --field core_business_capex --value 180000000 --basis-type estimate --reason '参考近两年现有业务长期资产和长期租赁现金投入，取常态约1.8亿元' --confidence medium --falsifier '连续两年维持现有网络所需资本开支显著高于2.5亿元或低于1.2亿元'
python3 "$tool" set-field --model "$model" --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason '开拓性研发不计入稳定经营收益；其价值不在证据不足时资本化' --confidence medium --falsifier '新药业务形成可验证的稳定商业化现金流'
python3 "$tool" set-field --model "$model" --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason '以不增长稳定状态计，异常回款和付款节奏不永久外推' --confidence medium --falsifier '业务结构要求持续增加安全库存或延长客户账期'

# 最新年度业务树；直销与分销的内部抵销按各自披露规模同比例净额化
python3 "$tool" add-business --model "$model" --business-id direct --name 北京药械终端直销 --importance '覆盖北京等级医院，收入最大；SPD、创新药械和终端配送形成客户黏性' --confidence medium --falsifier '公司披露内部抵销主要来自直销板块或单列直销利润'
python3 "$tool" add-business --model "$model" --business-id distribution --name 全国药品与麻精特药分销 --importance '覆盖全国区批客户，麻精药资质、全品种和专业服务是差异化来源' --confidence medium --falsifier '公司披露麻精及全国分销的独立收入成本利润'
python3 "$tool" add-business --model "$model" --business-id manufacturing --name 医药工业与特医研发 --importance '国瑞药业阶段性亏损且持续研发，是当前开拓性现金投入的主要来源' --confidence medium --falsifier '工业板块恢复持续盈利或完成处置'
python3 "$tool" add-business --model "$model" --business-id logistics --name 专业物流与配套服务 --importance '第三方仓储物流及未单列配套收入，规模小但支撑商业网络交付' --confidence medium --falsifier '公司披露配套收入应归属其他具名主营业务'

setbiz() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
setbiz direct revenue 31237989416.98 '直销模式披露额按商业内部抵销比例净额化' medium '披露直销内部交易抵销明细'
setbiz direct cost_of_revenue 29396662143.20 '直销成本按商业成本内部抵销比例净额化' medium '披露直销内部交易抵销明细'
setbiz direct period_operating_expenses 673680381.87 '商业剩余EBIT按直销与分销净毛利比例分配后反推' low '披露直销独立营业利润或费用'
setbiz direct cash_tax 233529378.46 '按估算EBIT的20%' low '披露直销独立税费'
setbiz direct operating_cash_flow_contribution 1151894098.29 '公司经营现金流按各业务NOPAT比例分配' low '披露分部经营现金流或营运资金'
setbiz distribution revenue 20363904337.55 '分销模式披露额按商业内部抵销比例净额化' medium '披露分销内部交易抵销明细'
setbiz distribution cost_of_revenue 18942268181.41 '分销成本按商业成本内部抵销比例净额化' medium '披露分销内部交易抵销明细'
setbiz distribution period_operating_expenses 520129366.25 '商业剩余EBIT按直销与分销净毛利比例分配后反推' low '披露分销独立营业利润或费用'
setbiz distribution cash_tax 180301357.98 '按估算EBIT的20%' low '披露分销独立税费'
setbiz distribution operating_cash_flow_contribution 889344507.89 '公司经营现金流按各业务NOPAT比例分配' low '披露分部经营现金流或营运资金'
setbiz manufacturing revenue 414342595.00 '年报产品销售收入直接作为工业与特医收入' medium '特医业务被单独披露且金额重大'
setbiz manufacturing cost_of_revenue 302261708.22 '年报产品销售成本直接作为工业与特医成本' medium '特医业务被单独披露且金额重大'
setbiz manufacturing period_operating_expenses 162668786.78 '以国瑞药业披露营业亏损近似工业板块EBIT后反推，含特医小额亏损的误差' low '工业和特医合并口径营业利润获得披露'
setbiz manufacturing cash_tax -10117580.00 '按亏损EBIT的20%税盾闭合公司经营税' low '亏损税盾不可利用或税务口径另有披露'
setbiz manufacturing operating_cash_flow_contribution -49905415.62 '公司经营现金流按各业务NOPAT比例分配' low '工业分部经营现金流获得披露'
setbiz logistics revenue 452044227.19 '仓储物流收入加未列入主营分析的配套收入以闭合公司总量' low '非主营配套收入的经济归属获得披露'
setbiz logistics cost_of_revenue 367250963.89 '仓储物流成本加未列入主营分析的配套成本以闭合公司总量' low '非主营配套成本的经济归属获得披露'
setbiz logistics period_operating_expenses 70414963.30 '以国药物流营业利润为锚并吸收配套业务差额' low '物流与空港服务合并营业利润获得披露'
setbiz logistics cash_tax 2875660.00 '按估算EBIT的20%' low '物流业务独立税费获得披露'
setbiz logistics operating_cash_flow_contribution 14184321.50 '公司经营现金流按各业务NOPAT比例分配' low '物流分部经营现金流获得披露'

# 价值桥
python3 "$tool" set-field --model "$model" --view equity --field excess_cash --value 6892046272.30 --basis-type estimate --reason '货币资金减受限资金和20亿元经营必需现金；应付股利在优先索偿单列' --confidence low --falsifier '受限定期存款不可最终回收、现金池限制或最低现金需求显著变化'
python3 "$tool" set-field --model "$model" --view equity --field non_operating_assets --value 4407242616.02 --basis-type estimate --reason '联营企业正常权益法收益5.3亿元按八倍计值，加独立金融资产和投资性房地产账面值' --confidence medium --falsifier '联营企业可分配收益持续低于4亿元、股权受限或出现可靠市场交易估值'
python3 "$tool" set-field --model "$model" --view equity --field financing_debt --expression debt25 --basis-type reported --reason '短期借款；租赁采用经营口径，租赁现金流已进入资本开支，故不重复扣租赁负债' --confidence high
python3 "$tool" set-field --model "$model" --view equity --field minority_interest_value --expression minority25 --basis-type reported --reason '缺乏各非全资子公司完整估值资料，以少数股东账面权益作为经济价值替代' --confidence medium
python3 "$tool" set-field --model "$model" --view equity --field other_priority_claims --expression 'dividend_payable25 + proposed_dividend25' --basis-type formula --reason '已确认未支付股利及董事会拟派2025年度现金股利均在普通股价值之前扣除' --confidence high
python3 "$tool" set-field --model "$model" --view equity --field diluted_shares --expression shares25 --basis-type reported --reason '期末股本，基本与稀释每股收益相同，未见实质摊薄工具' --confidence high
python3 "$tool" set-field --model "$model" --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason '列报与交易币种均为人民币' --confidence high --falsifier '交易币种发生变化'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '流通业务稳定但毛利持续受集采挤压，工业处于亏损转型，缺乏到达稳定状态的逐年FCFF证据，采用稳定经营收益八倍固定标尺' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name 联营企业收益与资产 --before '2025年投资收益5.67亿元混入会计营业利润；长期股权投资账面23.13亿元' --after '主业EBIT剔除投资收益；联营企业按稳定权益法收益5.3亿元×8=42.4亿元单列' --reason '联营企业现金流未并入合并经营现金流，须与主业分开计值；若可分配收益显著下降则下调。'
python3 "$tool" add-adjustment --model "$model" --name 商誉 --before '账面2.04亿元' --after '投入资本中全额剔除' --reason '不以并购溢价直接证明经营价值，相关渠道能力由稳定经营收益反推。'
python3 "$tool" add-adjustment --model "$model" --name 经营必需与受限现金 --before '货币资金114.82亿元' --after '多余现金68.92亿元' --reason '扣除受限资金25.90亿元及估计经营必需现金20亿元；最低现金需求是低可信关键假设。'

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '投入资本边界逐年一致，但经营必需现金为低可信估计，正文仅将ROIC用于说明轻资产与营运资金占用，不作为精确护城河度量。'
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '所有标准字段均引用带报告名称、日期、公开链接和PDF页码的事实ID或记录估计依据。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '剔除融资与投资收益，联营资产和金融资产单列，租赁统一采用经营口径，商誉剔除。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定状态综合三年毛利趋势、2025业务结构、工业亏损与行业控费，不机械使用单年FCFF。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告中心数字将从结构化模型和程序生成表格引用，并在最终化时复核。'

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

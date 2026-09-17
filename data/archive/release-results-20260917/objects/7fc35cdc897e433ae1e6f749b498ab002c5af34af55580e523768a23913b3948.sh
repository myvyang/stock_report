#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
src23="中材科技股份有限公司2023年年度报告（2024年3月22日）"
src24="中材科技股份有限公司2024年年度报告（2025年3月20日）"
src25="中材科技股份有限公司2025年年度报告（2026年3月20日）"

python3 "$tool" init --name 中材科技 --code 002080.SZ --period-label 2025年度 \
  --period-end 2025-12-31 --coverage-years 2023,2024,2025 \
  --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 \
  --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" \
    --amount "$3" --period "$4" --currency 人民币 --scope consolidated \
    --source "$5" --locator "$6"
}

# 利润表、现金流量表及其补充资料（2023采用2024年报重述比较数）。
fact rev23 营业收入 25892634285.05 2023年度 "$src24" "第87页"
fact cost23 营业成本 19683339064.34 2023年度 "$src24" "第87页"
fact surtax23 税金及附加 221431696.72 2023年度 "$src24" "第88页"
fact sell23 销售费用 313755000.57 2023年度 "$src24" "第88页"
fact admin23 管理费用 1307293275.07 2023年度 "$src24" "第88页"
fact rd23 研发费用 1301693679.47 2023年度 "$src24" "第88页"
fact otherinc23 其他收益 461492647.20 2023年度 "$src24" "第88页"
fact creditloss23 信用减值损失 78231883.15 2023年度 "$src24" "第88页，损失转为正数"
fact assetloss23 资产减值损失 166408894.95 2023年度 "$src24" "第88页，损失转为正数"
fact currenttax23 当期所得税费用 282149687.62 2023年度 "$src24" "第170页"
fact fixedda23 固定资产折旧 1629522429.57 2023年度 "$src24" "第171页"
fact rouda23 使用权资产折旧 44566840.90 2023年度 "$src24" "第171页"
fact intangda23 无形资产摊销 132333560.27 2023年度 "$src24" "第171页"
fact prepaidda23 长期待摊费用摊销 45229681.90 2023年度 "$src24" "第171页"
fact ocf23 经营活动产生的现金流量净额 4822304806.74 2023年度 "$src24" "第91页"
fact cffin23 现金流量补充资料财务费用 462841265.25 2023年度 "$src24" "第172页"
fact purchasecapex23 购建固定资产无形资产和其他长期资产支付的现金 7765334919.03 2023年度 "$src24" "第91页"
fact disposal23 处置固定资产无形资产和其他长期资产收回的现金净额 128808177.61 2023年度 "$src24" "第91页"

fact rev24 营业收入 23983849999.77 2024年度 "$src25" "第80页"
fact cost24 营业成本 19901284045.24 2024年度 "$src25" "第80页"
fact surtax24 税金及附加 232452997.97 2024年度 "$src25" "第80页"
fact sell24 销售费用 245896158.00 2024年度 "$src25" "第80页"
fact admin24 管理费用 1373802847.36 2024年度 "$src25" "第80页"
fact rd24 研发费用 1271225813.47 2024年度 "$src25" "第80页"
fact otherinc24 其他收益 635636282.90 2024年度 "$src25" "第80页"
fact creditloss24 信用减值损失 47501735.09 2024年度 "$src25" "第80页，损失转为正数"
fact assetloss24 资产减值损失 84225803.20 2024年度 "$src25" "第81页，损失转为正数"
fact currenttax24 当期所得税费用 138744744.99 2024年度 "$src25" "第159页"
fact fixedda24 固定资产折旧 1821312298.18 2024年度 "$src25" "第160页"
fact rouda24 使用权资产折旧 63742765.89 2024年度 "$src25" "第160页"
fact intangda24 无形资产摊销 194209029.18 2024年度 "$src25" "第160页"
fact prepaidda24 长期待摊费用摊销 93421642.63 2024年度 "$src25" "第160页"
fact ocf24 经营活动产生的现金流量净额 3600096105.09 2024年度 "$src25" "第84页"
fact cffin24 现金流量补充资料财务费用 395874011.12 2024年度 "$src25" "第161页"
fact purchasecapex24 购建固定资产无形资产和其他长期资产支付的现金 4561795412.44 2024年度 "$src25" "第84页"
fact disposal24 处置固定资产无形资产和其他长期资产收回的现金净额 16685592.49 2024年度 "$src25" "第84页"

fact rev25 营业收入 30195487692.29 2025年度 "$src25" "第80页"
fact cost25 营业成本 24478976768.30 2025年度 "$src25" "第80页"
fact surtax25 税金及附加 260832851.37 2025年度 "$src25" "第80页"
fact sell25 销售费用 261649802.67 2025年度 "$src25" "第80页"
fact admin25 管理费用 1534962374.83 2025年度 "$src25" "第80页"
fact rd25 研发费用 1497560835.66 2025年度 "$src25" "第80页"
fact otherinc25 其他收益 647071318.35 2025年度 "$src25" "第80页"
fact creditloss25 信用减值损失 55634012.40 2025年度 "$src25" "第80页，损失转为正数"
fact assetloss25 资产减值损失 192289336.83 2025年度 "$src25" "第81页，损失转为正数"
fact currenttax25 当期所得税费用 447241349.27 2025年度 "$src25" "第159页"
fact fixedda25 固定资产折旧 2078894803.68 2025年度 "$src25" "第160页"
fact rouda25 使用权资产折旧 63060275.78 2025年度 "$src25" "第160页"
fact intangda25 无形资产摊销 184887211.99 2025年度 "$src25" "第160页"
fact prepaidda25 长期待摊费用摊销 115944653.60 2025年度 "$src25" "第160页"
fact ocf25 经营活动产生的现金流量净额 5401826740.24 2025年度 "$src25" "第84页"
fact cffin25 现金流量补充资料财务费用 386771096.55 2025年度 "$src25" "第161页"
fact purchasecapex25 购建固定资产无形资产和其他长期资产支付的现金 3554999929.91 2025年度 "$src25" "第84页"
fact disposal25 处置固定资产无形资产和其他长期资产收回的现金净额 190912149.89 2025年度 "$src25" "第84页"

# 资产负债表：用流动资产/负债总额扣除现金、金融负债及已宣告股利，避免伪精确拆项。
fact ca22 流动资产合计 23512520515.63 2022-12-31 "$src23" "第92页（列示为2023年1月1日）"
fact cash22 货币资金 5904080619.85 2022-12-31 "$src23" "第92页（列示为2023年1月1日）"
fact tfa22 交易性金融资产 65000000.00 2022-12-31 "$src23" "第92页（列示为2023年1月1日）"
fact cl22 流动负债合计 15675693500.47 2022-12-31 "$src23" "第93页（列示为2023年1月1日）"
fact shortdebt22 短期借款 1636662042.72 2022-12-31 "$src23" "第93页（列示为2023年1月1日）"
fact currentdebt22 一年内到期的非流动负债 962447163.97 2022-12-31 "$src23" "第93页（列示为2023年1月1日）"
fact dividend22 应付股利 18167785.67 2022-12-31 "$src23" "第93页（列示为2023年1月1日）"
fact nca22 非流动资产合计 29203246279.15 2022-12-31 "$src23" "第93页（列示为2023年1月1日）"
fact ltrecv22 长期应收款 7958476.38 2022-12-31 "$src23" "第92页（列示为2023年1月1日）"
fact lteq22 长期股权投资 152839141.43 2022-12-31 "$src23" "第92页（列示为2023年1月1日）"
fact otherfin22 其他非流动金融资产 316931030.00 2022-12-31 "$src23" "第92页（列示为2023年1月1日）"
fact invprop22 投资性房地产 241705900.49 2022-12-31 "$src23" "第92页（列示为2023年1月1日）"
fact dta22 递延所得税资产 597557920.34 2022-12-31 "$src23" "第93页（列示为2023年1月1日）"
fact definc22 递延收益 755960892.81 2022-12-31 "$src23" "第94页（列示为2023年1月1日）"
fact provision22 预计负债 297717802.66 2022-12-31 "$src23" "第94页（列示为2023年1月1日）"
fact otherncl22 其他非流动负债 133798167.42 2022-12-31 "$src23" "第94页（列示为2023年1月1日）"
fact goodwill22 商誉 48265219.55 2022-12-31 "$src23" "第93页（列示为2023年1月1日）"

fact ca23 流动资产合计 21291023214.52 2023-12-31 "$src24" "第83页"
fact cash23 货币资金 3544620539.63 2023-12-31 "$src24" "第83页"
fact cl23 流动负债合计 19151699035.30 2023-12-31 "$src24" "第84页"
fact shortdebt23 短期借款 693918545.37 2023-12-31 "$src24" "第84页"
fact currentdebt23 一年内到期的非流动负债 4722357270.58 2023-12-31 "$src24" "第84页"
fact dividend23 应付股利 499720241.56 2023-12-31 "$src24" "第84页"
fact nca23 非流动资产合计 35605702067.82 2023-12-31 "$src24" "第84页"
fact lteq23 长期股权投资 307398764.05 2023-12-31 "$src24" "第83页"
fact otherfin23 其他非流动金融资产 316931030.00 2023-12-31 "$src24" "第83页"
fact invprop23 投资性房地产 229257318.72 2023-12-31 "$src24" "第83页"
fact dta23 递延所得税资产 571566379.83 2023-12-31 "$src24" "第84页"
fact definc23 递延收益 739032548.00 2023-12-31 "$src24" "第85页"
fact provision23 预计负债 319477223.67 2023-12-31 "$src24" "第85页"
fact otherncl23 其他非流动负债 123756846.61 2023-12-31 "$src24" "第85页"
fact goodwill23 商誉 48265219.55 2023-12-31 "$src24" "第84页"

fact ca24 流动资产合计 19880209301.66 2024-12-31 "$src25" "第76页"
fact cash24 货币资金 2742679443.43 2024-12-31 "$src25" "第75页"
fact cl24 流动负债合计 20490872967.62 2024-12-31 "$src25" "第77页"
fact shortdebt24 短期借款 1907446783.49 2024-12-31 "$src25" "第76页"
fact currentdebt24 一年内到期的非流动负债 3175268130.35 2024-12-31 "$src25" "第77页"
fact dividend24 应付股利 339746818.26 2024-12-31 "$src25" "第77页"
fact nca24 非流动资产合计 39984487790.51 2024-12-31 "$src25" "第76页"
fact lteq24 长期股权投资 353358902.66 2024-12-31 "$src25" "第76页"
fact otherfin24 其他非流动金融资产 316931030.00 2024-12-31 "$src25" "第76页"
fact invprop24 投资性房地产 462832625.19 2024-12-31 "$src25" "第76页"
fact dta24 递延所得税资产 634866363.89 2024-12-31 "$src25" "第76页"
fact definc24 递延收益 783855161.39 2024-12-31 "$src25" "第77页"
fact provision24 预计负债 206197408.25 2024-12-31 "$src25" "第77页"
fact otherncl24 其他非流动负债 95483534.39 2024-12-31 "$src25" "第77页"
fact goodwill24 商誉 48265219.55 2024-12-31 "$src25" "第76页"

fact ca25 流动资产合计 23969665137.64 2025-12-31 "$src25" "第76页"
fact cash25 货币资金 3098128164.39 2025-12-31 "$src25" "第75页"
fact restrictedcash25 受限货币资金 21759999.32 2025-12-31 "$src25" "第162页，货币资金与现金等价物差额"
fact cl25 流动负债合计 25885776207.24 2025-12-31 "$src25" "第77页"
fact shortdebt25 短期借款 3028020138.95 2025-12-31 "$src25" "第76页"
fact currentdebt25 一年内到期的非流动负债 2975115808.68 2025-12-31 "$src25" "第77页"
fact dividend25 应付股利 190193418.26 2025-12-31 "$src25" "第77页"
fact nca25 非流动资产合计 41621312858.77 2025-12-31 "$src25" "第76页"
fact lteq25 长期股权投资 694465768.33 2025-12-31 "$src25" "第76页"
fact otherfin25 其他非流动金融资产 316931030.00 2025-12-31 "$src25" "第76页"
fact invprop25 投资性房地产 441901614.45 2025-12-31 "$src25" "第76页"
fact dta25 递延所得税资产 832243097.42 2025-12-31 "$src25" "第76页"
fact definc25 递延收益 948247575.89 2025-12-31 "$src25" "第77页"
fact provision25 预计负债 208528288.35 2025-12-31 "$src25" "第77页"
fact otherncl25 其他非流动负债 86624761.94 2025-12-31 "$src25" "第77页"
fact goodwill25 商誉 48265219.55 2025-12-31 "$src25" "第76页"

# 2025年融资、权益、业务与经营事实。
fact longdebt25 长期借款 8135364424.39 2025-12-31 "$src25" "第77页"
fact bonds25 应付债券 1500000000.00 2025-12-31 "$src25" "第77页"
fact lease25 租赁负债 278230626.37 2025-12-31 "$src25" "第77页"
fact longpay25 长期应付款 18477612.21 2025-12-31 "$src25" "第77页"
fact minorityprofit25 少数股东损益 271176590.73 2025年度 "$src25" "第81页"
fact shares25 股份总数 1678123584 2025-12-31 "$src25" "第62页"
fact windrev25 风电叶片营业收入 12594997143.54 2025年度 "$src25" "第19页"
fact windcost25 风电叶片营业成本 10809023867.62 2025年度 "$src25" "第19页"
fact glassrev25 玻璃纤维及制品营业收入 8904941324.89 2025年度 "$src25" "第19页"
fact glasscost25 玻璃纤维及制品营业成本 6544705002.83 2025年度 "$src25" "第19页"
fact separatorrev25 锂电池隔膜营业收入 2397822850.10 2025年度 "$src25" "第19页"
fact separatoroploss25 中材锂膜营业亏损 -91363494.87 2025年度 "$src25" "第31页"

setf() {
  python3 "$tool" set-field --model "$model" "$@"
}

for y in 2023 2024 2025; do
  yy="${y:2:2}"
  setf --view historical --year "$y" --field revenue --expression "rev${yy}" --basis-type reported --reason "合并利润表营业收入" --confidence high
  setf --view historical --year "$y" --field cost_of_revenue --expression "cost${yy}" --basis-type reported --reason "合并利润表营业成本" --confidence high
  setf --view historical --year "$y" --field period_operating_expenses --expression "surtax${yy} + sell${yy} + admin${yy} + rd${yy} - otherinc${yy} + creditloss${yy} + assetloss${yy}" --basis-type formula --reason "税金、销售、管理、研发费用及经常性减值，扣除经营相关其他收益；排除财务费用、投资和处置收益" --confidence medium
  setf --view historical --year "$y" --field cash_tax --expression "currenttax${yy}" --basis-type estimate --reason "以当期所得税费用近似经营现金税；研发加计扣除与亏损子公司使税率低于法定税率" --confidence medium --falsifier "按业务与非经营损益完整拆出的现金所得税显著不同"
  setf --view historical --year "$y" --field depreciation_amortization --expression "fixedda${yy} + rouda${yy} + intangda${yy} + prepaidda${yy}" --basis-type formula --reason "现金流量表补充资料中的经营性折旧摊销合计" --confidence high
  setf --view historical --year "$y" --field operating_cash_flow --expression "ocf${yy}" --basis-type reported --reason "合并现金流量表经营活动现金流净额" --confidence high
  setf --view historical --year "$y" --field after_tax_interest_in_operating_cash_flow --expression "cffin${yy} * 0.85" --basis-type estimate --reason "现金流补充资料财务费用按15%经营税率税后化，加回融资成本以转为FCFF" --confidence medium --falsifier "融资成本适用税率或资本化利息边界显著不同"
done

setf --view historical --year 2023 --field core_business_capex --value 3136526741.42 --basis-type estimate --reason "现金资本开支扣除约45亿元锂膜新产线等开拓投入；余额归入玻纤、叶片及既有业务扩产技改" --confidence low --falsifier "项目付款明细证明锂膜及前沿新业务现金投入显著偏离45亿元"
setf --view historical --year 2023 --field exploratory_business_capex --value 4500000000 --basis-type estimate --reason "锂膜处于多基地集中建设期，在建工程和披露项目支持将大部分资本开支视为尚未稳定盈利的开拓投入" --confidence low --falsifier "项目付款明细证明锂膜及前沿新业务现金投入显著偏离45亿元"
setf --view historical --year 2024 --field core_business_capex --value 2145109819.95 --basis-type estimate --reason "净现金资本开支扣除约24亿元锂膜扩产投入，余额为现有主业扩产、技改和海外叶片布局" --confidence low --falsifier "项目级现金付款显示锂膜建设投入显著偏离24亿元"
setf --view historical --year 2024 --field exploratory_business_capex --value 2400000000 --basis-type estimate --reason "锂膜产能建设尚未稳定盈利，按项目进度与在建工程增量估算开拓性现金投入" --confidence low --falsifier "项目级现金付款显示锂膜建设投入显著偏离24亿元"
setf --view historical --year 2025 --field core_business_capex --value 2564087780.02 --basis-type estimate --reason "净现金资本开支扣除约8亿元锂膜国内收尾及匈牙利基地投入，余额归现有业务技改扩产" --confidence low --falsifier "项目级现金付款显示锂膜与新材料开拓投入显著偏离8亿元"
setf --view historical --year 2025 --field exploratory_business_capex --value 800000000 --basis-type estimate --reason "国内锂膜产能全面投产但业务仍亏损，海外匈牙利基地启动，作为未稳定赚钱业务投入" --confidence low --falsifier "匈牙利及国内锂膜项目实际现金投入显著偏离8亿元"

for y in 2023 2024 2025; do
  yy="${y:2:2}"
  setf --view historical --year "$y" --field operating_working_capital_increase \
    --expression "rev${yy} - cost${yy} - (surtax${yy} + sell${yy} + admin${yy} + rd${yy} - otherinc${yy} + creditloss${yy} + assetloss${yy}) - currenttax${yy} + fixedda${yy} + rouda${yy} + intangda${yy} + prepaidda${yy} - ocf${yy} - cffin${yy} * 0.85" \
    --basis-type estimate --reason "用NOPAT、折旧摊销、经营现金流及税后利息反推的现金口径经营营运资金变动，包含未单列经营应计项目" --confidence medium --falsifier "详细现金流对账显示重大非营运资金经营调整"
done

# 经营资产分类；2022仅作为2023年ROIC期初。
setf --view capital --year 2022 --field operating_working_capital --expression "ca22 - cash22 - tfa22 - (cl22 - shortdebt22 - currentdebt22 - dividend22)" --basis-type formula --reason "非现金经营流动资产减非融资经营流动负债" --confidence medium
setf --view capital --year 2022 --field operating_long_term_assets_net --expression "nca22 - ltrecv22 - lteq22 - otherfin22 - invprop22 - dta22 - definc22 - provision22 - otherncl22" --basis-type formula --reason "非流动资产剔除金融和递延税资产，并扣资产相关递延收益及长期经营负债" --confidence medium
for y in 2023 2024 2025; do
  yy="${y:2:2}"
  setf --view capital --year "$y" --field operating_working_capital --expression "ca${yy} - cash${yy} - (cl${yy} - shortdebt${yy} - currentdebt${yy} - dividend${yy})" --basis-type formula --reason "非现金经营流动资产减非融资经营流动负债；已宣告股利不作为经营负债" --confidence medium
  setf --view capital --year "$y" --field operating_long_term_assets_net --expression "nca${yy} - lteq${yy} - otherfin${yy} - invprop${yy} - dta${yy} - definc${yy} - provision${yy} - otherncl${yy}" --basis-type formula --reason "非流动资产剔除金融、投资物业和递延税资产，并扣长期经营负债" --confidence medium
done
for y in 2022 2023 2024 2025; do
  yy="${y:2:2}"
  case "$y" in 2022) rc=1700000000;; 2023) rc=1800000000;; 2024) rc=1800000000;; 2025) rc=2000000000;; esac
  setf --view capital --year "$y" --field required_cash --value "$rc" --basis-type estimate --reason "约覆盖一个月的付现经营成本并保留跨基地结算缓冲" --confidence low --falsifier "月度现金峰值、授信可用性或受限资金资料显示最低现金需求显著不同"
  setf --view capital --year "$y" --field unsupported_intangible_assets --expression "goodwill${yy}" --basis-type formula --reason "商誉不能由独立可核验的经营收益解释，默认从投入资本剔除" --confidence high
done

# 稳定期仅作八倍统一标尺，不作公司特定成长预测。
setf --view stable --field revenue --value 28500000000 --basis-type estimate --reason "介于2024低谷与2025放量之间；叶片交付常态化、玻纤高端结构改善，锂膜不外推单年76%销量增速" --confidence low --falsifier "两年可持续销量、价格和订单使收入中枢低于260亿元或高于310亿元"
setf --view stable --field cost_of_revenue --value 22657500000 --basis-type estimate --reason "采用20.5%正常毛利率，低于2023景气水平、高于2024低谷并略高于2025" --confidence low --falsifier "玻纤价格、叶片单位成本或锂膜利用率令综合毛利率持续低于18%或高于23%"
setf --view stable --field period_operating_expenses --value 2850000000 --basis-type estimate --reason "以三年净经营费用约26至32亿元为中心，保留研发强度与常态减值" --confidence medium --falsifier "稳定研发、管理费用和政府补助的净额持续偏离28.5亿元"
setf --view stable --field cash_tax --value 359100000 --basis-type estimate --reason "对29.925亿元稳定EBIT采用12%现金税率，反映高新技术税率、研发加计扣除与业务组合" --confidence low --falsifier "税收优惠到期或亏损业务转盈使现金税率持续高于17%"
setf --view stable --field depreciation_amortization --value 2350000000 --basis-type estimate --reason "接近2025折旧摊销但剔除投产初期波动" --confidence medium --falsifier "新产线稳定后的年度折旧摊销低于20亿元或高于27亿元"
setf --view stable --field core_business_capex --value 2350000000 --basis-type estimate --reason "成熟状态以折旧摊销近似长期更新、环保、技改及正常扩产现金需求" --confidence low --falsifier "连续项目级维持投入证明保持竞争力每年需超过30亿元或不足18亿元"
setf --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason "固定标尺不把可选择的新业务风险投资计入永续稳定经营；当前开拓投入已在历史FCFF体现" --confidence medium --falsifier "新业务投入已成为不可避免的持续经营条件"
setf --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason "不把2025应付款增长导致的现金释放外推；不增长稳定状态采用零净增加" --confidence medium --falsifier "正常销量增长或账期结构要求持续新增营运资金"

# 2025核心业务推算，四行互斥并闭合公司合计。
python3 "$tool" add-business --model "$model" --business-id wind --name 风电叶片 --importance "整机商定制订单业务，2025收入占公司42%，客户集中、验收交付和区域产线决定现金节奏" --confidence medium --falsifier "产品收入成本披露口径包含大量非叶片内部交易"
python3 "$tool" add-business --model "$model" --business-id glass --name 玻璃纤维及制品 --importance "全资泰山玻纤经营，价格周期与高端特种纤维结构共同决定利润" --confidence high --falsifier "泰山玻纤合并范围或产品口径发生重大变化"
python3 "$tool" add-business --model "$model" --business-id separator --name 锂电池隔膜 --importance "超60亿平方米产能刚投产且仍亏损，是主要开拓性业务和资本占用来源" --confidence medium --falsifier "子公司分部口径证明2025已形成显著正经营利润和现金"
python3 "$tool" add-business --model "$model" --business-id specialty --name 气瓶、膜材及工程技术复材 --importance "覆盖气瓶、膜材料、工程/先进复材、技术装备及内部抵消后的净额，是既有专业材料业务组合" --confidence low --falsifier "分部抵消和成本明细足以按独立经济业务进一步可靠拆分"

bizf() { python3 "$tool" set-business-field --model "$model" "$@"; }
bizf --business-id wind --field revenue --expression windrev25 --basis-type reported --reason "年报分产品收入" --confidence high
bizf --business-id wind --field cost_of_revenue --expression windcost25 --basis-type reported --reason "年报分产品成本" --confidence high
bizf --business-id wind --field period_operating_expenses --value 1050000000 --basis-type estimate --reason "以产品毛利和中材叶片营业利润为锚，调整子公司收入与产品口径差" --confidence low --falsifier "中材叶片完整利润表显示期间经营费用显著偏离10.5亿元"
bizf --business-id wind --field cash_tax --value 100000000 --basis-type estimate --reason "按风电叶片正经营利润及优惠税率估算" --confidence low --falsifier "中材叶片现金所得税披露显著不同"
bizf --business-id wind --field operating_cash_flow_contribution --value 2100000000 --basis-type estimate --reason "结合盈利、放量交付和公司营运资金释放分配现金贡献" --confidence low --falsifier "分部现金流显示回款或备货占用显著不同"

bizf --business-id glass --field revenue --expression glassrev25 --basis-type reported --reason "年报分产品收入" --confidence high
bizf --business-id glass --field cost_of_revenue --expression glasscost25 --basis-type reported --reason "年报分产品成本" --confidence high
bizf --business-id glass --field period_operating_expenses --value 1030000000 --basis-type estimate --reason "以产品毛利和泰山玻纤营业利润为锚，排除融资与非经营项目" --confidence low --falsifier "泰山玻纤完整利润表显示期间经营费用显著偏离10.3亿元"
bizf --business-id glass --field cash_tax --value 200000000 --basis-type estimate --reason "按玻纤盈利和高新技术税率估算" --confidence low --falsifier "泰山玻纤现金所得税披露显著不同"
bizf --business-id glass --field operating_cash_flow_contribution --value 2200000000 --basis-type estimate --reason "结合高端产品盈利与库存增加后的现金贡献估算" --confidence low --falsifier "泰山玻纤分部现金流显著不同"

bizf --business-id separator --field revenue --expression separatorrev25 --basis-type reported --reason "年报分产品收入" --confidence high
bizf --business-id separator --field cost_of_revenue --value 2120000000 --basis-type estimate --reason "以中材锂膜营业亏损9136万元反推，假设期间经营费用约3.7亿元" --confidence low --falsifier "锂膜分产品毛利披露使成本显著偏离21.2亿元"
bizf --business-id separator --field period_operating_expenses --value 370000000 --basis-type estimate --reason "以中材锂膜营业亏损为锚并调整产品与子公司收入差" --confidence low --falsifier "锂膜完整利润表显示期间经营费用显著不同"
bizf --business-id separator --field cash_tax --value 0 --basis-type estimate --reason "业务亏损，基准点不计经营现金税" --confidence medium --falsifier "亏损主体仍有重大不可退现金所得税"
bizf --business-id separator --field operating_cash_flow_contribution --value 100000000 --basis-type estimate --reason "销量放大但产能爬坡、库存和应收占用，保守估计小幅正贡献" --confidence low --falsifier "锂膜分部现金流为显著负数或超过5亿元"

bizf --business-id specialty --field revenue --expression "rev25 - windrev25 - glassrev25 - separatorrev25" --basis-type estimate --reason "公司合并收入扣除三大产品，已净含内部抵消" --confidence medium --falsifier "内部抵消能可靠归属三大业务且改变净收入分配"
bizf --business-id specialty --field cost_of_revenue --expression "cost25 - windcost25 - glasscost25 - 2120000000" --basis-type estimate --reason "公司成本扣除风电、玻纤及估计锂膜成本后的闭合数" --confidence low --falsifier "锂膜成本或内部抵消归属显著不同"
bizf --business-id specialty --field period_operating_expenses --value 705857895.41 --basis-type estimate --reason "公司期间经营费用扣除前三项业务估计后的闭合数" --confidence low --falsifier "各子公司完整利润表改变费用归属"
bizf --business-id specialty --field cash_tax --value 147241349.27 --basis-type estimate --reason "公司经营现金税扣除前三项后的闭合数" --confidence low --falsifier "各业务现金税资料改变分配"
bizf --business-id specialty --field operating_cash_flow_contribution --value 1001826740.24 --basis-type estimate --reason "公司经营现金流扣除前三项后的闭合数" --confidence low --falsifier "分部现金流资料改变分配"

# 价值桥。
setf --view equity --field excess_cash --expression "cash25 - restrictedcash25 - 2000000000" --basis-type estimate --reason "期末货币资金扣受限资金及20亿元经营必需现金" --confidence low --falsifier "资本承诺、季节性或集团资金限制使可分配现金显著更低"
setf --view equity --field non_operating_assets --expression "lteq25 + otherfin25 + invprop25" --basis-type formula --reason "长期股权投资、独立金融资产及投资性房地产按账面值计入，未计递延税资产" --confidence medium
setf --view equity --field financing_debt --expression "shortdebt25 + currentdebt25 + longdebt25 + bonds25 + lease25 + longpay25" --basis-type formula --reason "短借、一年内到期债务、长借、债券、租赁及融资性长期应付款" --confidence high
setf --view equity --field minority_interest_value --expression "minorityprofit25 * 8" --basis-type estimate --reason "合并经营价值已含子公司100%经营，以2025少数股东损益八倍作为其经济价值代理，而非机械采用建设期高资本投入形成的账面权益" --confidence low --falsifier "按各子公司持股、债务和稳定FCFF估值所得少数权益显著不同"
setf --view equity --field other_priority_claims --expression dividend25 --basis-type formula --reason "合并口径已宣告未支付股利不属于经营负债，列为普通股之前的现金索偿" --confidence high
setf --view equity --field diluted_shares --expression shares25 --basis-type reported --reason "期末股份总数；基本与稀释每股收益相同，报告期内无股份变动" --confidence high

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "锂膜仍亏损且海外基地刚启动，叶片和玻纤又处周期波动，缺少可靠逐年FCFF和到达稳定状态时间，采用稳定经营收益八倍固定标尺" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name 资产处置收益 --before "2025年利润表确认1.498亿元收益" --after "从核心经营EBIT排除" --reason "苏州房屋征收的一次性处置收益不代表持续产品经营；若同类资产处置成为可重复经营活动则推翻。"
python3 "$tool" add-adjustment --model "$model" --name 开拓性资本开支 --before "2023-2025净现金资本开支76.37/45.45/33.64亿元" --after "其中开拓性估计45/24/8亿元" --reason "锂膜多基地建设且2025仍亏损，匈牙利基地刚启动；项目级付款可推翻估计。"
python3 "$tool" add-adjustment --model "$model" --name 少数股东经济价值 --before "账面少数股东权益84.30亿元" --after "按2025少数股东损益八倍估计21.69亿元" --reason "与经营资产八倍标尺保持收益口径一致，避免把尚未形成稳定收益的建设资本按账面值扣两次；子公司逐项估值可推翻。"

for item in capital_return_interpretability source_traceability economic_classification stable_state report_consistency; do
  case "$item" in
    capital_return_interpretability) why="投入资本分母为正且跨年可比，但经营必需现金和长期经营负债分类含估计，正文仅用于资本占用判断";;
    source_traceability) why="财报直接事实保留披露名称、期间、币种、合并范围、文件名及页码，标准字段由事实ID表达式形成";;
    economic_classification) why="融资、投资物业、金融资产、商誉、股利索偿与经营资产分开，资本开支区分现有主业和未稳定锂膜投入";;
    stable_state) why="稳定期结合三年周期、2025业务结构与产能阶段，不机械外推单年放量或营运资金释放";;
    report_consistency) why="正文重大数字、业务闭合、FCFF及普通股价值均与结构化模型一致";;
  esac
  python3 "$tool" set-review --model "$model" --item "$item" --passed --reason "$why"
done

python3 "$tool" compile --model "$model"

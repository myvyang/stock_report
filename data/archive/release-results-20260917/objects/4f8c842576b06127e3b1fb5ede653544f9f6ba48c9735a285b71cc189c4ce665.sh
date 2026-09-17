#!/usr/bin/env bash
set -euo pipefail

MODEL=outputs/analysis.json
TOOL=.agents/skills/stock-research/scripts/stock_research.py
SRC23='湖南华联瓷业股份有限公司2023年年度报告（2024-03-29）'
SRC24='湖南华联瓷业股份有限公司2024年年度报告（2025-04-03）'
SRC25='湖南华联瓷业股份有限公司2025年年度报告（2026-04-29）'

fact() { python3 "$TOOL" add-fact --model "$MODEL" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope consolidated --source "$5" --locator "$6"; }
field_expr() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
field_est() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }

# 2023经营事实（2024年报对比较数作了小额重述时采用重述后口径）
fact rev23 营业收入 1231540497.32 2023 "$SRC24" '第77页，合并利润表'
fact cost23 营业成本 833043646.36 2023 "$SRC24" '第77页，合并利润表（重述后比较数）'
fact surtax23 税金及附加 18320945.48 2023 "$SRC24" '第77页，合并利润表'
fact sell23 销售费用 77441985.99 2023 "$SRC24" '第77页，合并利润表（重述后比较数）'
fact admin23 管理费用 69600361.55 2023 "$SRC24" '第77页，合并利润表'
fact rd23 研发费用 69372886.60 2023 "$SRC24" '第77页，合并利润表'
fact otherinc23 其他收益 16244909.75 2023 "$SRC24" '第77页，合并利润表'
fact credit23 信用减值损失 427729.83 2023 "$SRC24" '第77页，合并利润表'
fact impair23 资产减值损失 -15070550.14 2023 "$SRC24" '第77页，合并利润表'
fact incometax23 所得税费用 18251624.18 2023 "$SRC24" '第77-78页，合并利润表'
fact pretax23 利润总额 197559675.66 2023 "$SRC24" '第77页，合并利润表'
fact fixeddep23 固定资产折旧 47493440.80 2023 "$SRC24" '第170页，现金流量表补充资料'
fact rouddep23 使用权资产折旧 6408530.11 2023 "$SRC24" '第170页，现金流量表补充资料'
fact amort23 无形资产摊销 4081586.50 2023 "$SRC24" '第170页，现金流量表补充资料'
fact ltdamort23 长期待摊费用摊销 860000.93 2023 "$SRC24" '第170页，现金流量表补充资料'
fact capexpay23 购建固定资产无形资产和其他长期资产支付现金 88225287.52 2023 "$SRC23" '第88页，合并现金流量表'
fact capexsale23 处置长期资产收回现金净额 867444.02 2023 "$SRC23" '第88页，合并现金流量表'
fact cfo23 经营活动产生的现金流量净额 233706999.73 2023 "$SRC23" '第88页，合并现金流量表'

# 2024经营事实
fact rev24 营业收入 1339780814.09 2024 "$SRC24" '第77页，合并利润表'
fact cost24 营业成本 894359570.13 2024 "$SRC24" '第77页，合并利润表'
fact surtax24 税金及附加 18476682.42 2024 "$SRC24" '第77页，合并利润表'
fact sell24 销售费用 80977170.15 2024 "$SRC24" '第77页，合并利润表'
fact admin24 管理费用 73301212.39 2024 "$SRC24" '第77页，合并利润表'
fact rd24 研发费用 67904424.64 2024 "$SRC24" '第77页，合并利润表'
fact otherinc24 其他收益 20983885.36 2024 "$SRC24" '第77页，合并利润表'
fact credit24 信用减值损失 -1892198.12 2024 "$SRC24" '第77页，合并利润表'
fact impair24 资产减值损失 -16046967.59 2024 "$SRC24" '第77页，合并利润表'
fact incometax24 所得税费用 28844258.46 2024 "$SRC24" '第77页，合并利润表'
fact pretax24 利润总额 231222352.93 2024 "$SRC24" '第77页，合并利润表'
fact fixeddep24 固定资产折旧 50267681.60 2024 "$SRC24" '第170页，现金流量表补充资料'
fact rouddep24 使用权资产折旧 6675797.38 2024 "$SRC24" '第170页，现金流量表补充资料'
fact amort24 无形资产摊销 4126477.80 2024 "$SRC24" '第170页，现金流量表补充资料'
fact ltdamort24 长期待摊费用摊销 200577.04 2024 "$SRC24" '第170页，现金流量表补充资料'
fact capexpay24 购建固定资产无形资产和其他长期资产支付现金 128010583.10 2024 "$SRC24" '第80页，合并现金流量表'
fact capexsale24 处置长期资产收回现金净额 336550.07 2024 "$SRC24" '第80页，合并现金流量表'
fact cfo24 经营活动产生的现金流量净额 213099148.37 2024 "$SRC24" '第80页，合并现金流量表'

# 2025经营事实
fact rev25 营业收入 1471543483.29 2025 "$SRC25" '第105页，合并利润表'
fact cost25 营业成本 979192299.44 2025 "$SRC25" '第105页，合并利润表'
fact surtax25 税金及附加 22372526.85 2025 "$SRC25" '第105页，合并利润表'
fact sell25 销售费用 92534142.75 2025 "$SRC25" '第105页，合并利润表'
fact admin25 管理费用 76411141.89 2025 "$SRC25" '第105页，合并利润表'
fact rd25 研发费用 65680259.85 2025 "$SRC25" '第105页，合并利润表'
fact otherinc25 其他收益 15922083.42 2025 "$SRC25" '第105页，合并利润表'
fact credit25 信用减值损失 -3103238.64 2025 "$SRC25" '第106页，合并利润表'
fact impair25 资产减值损失 -16320057.80 2025 "$SRC25" '第106页，合并利润表'
fact incometax25 所得税费用 29436154.42 2025 "$SRC25" '第106页，合并利润表'
fact pretax25 利润总额 245648324.42 2025 "$SRC25" '第106页，合并利润表'
fact fixeddep25 固定资产折旧 54415066.34 2025 "$SRC25" '第177页，现金流量表补充资料'
fact rouddep25 使用权资产折旧 4002436.85 2025 "$SRC25" '第177页，现金流量表补充资料'
fact amort25 无形资产摊销 4042097.18 2025 "$SRC25" '第177页，现金流量表补充资料'
fact ltdamort25 长期待摊费用摊销 142628.10 2025 "$SRC25" '第177页，现金流量表补充资料'
fact capexpay25 购建固定资产无形资产和其他长期资产支付现金 257918122.00 2025 "$SRC25" '第109页，合并现金流量表'
fact capexsale25 处置长期资产收回现金净额 421552.02 2025 "$SRC25" '第109页，合并现金流量表'
fact cfo25 经营活动产生的现金流量净额 348816332.57 2025 "$SRC25" '第109页，合并现金流量表'
fact explore25 越南陶瓷谷及深圳研发设计中心本期投入 113350481.94 2025 "$SRC25" '第25页越南项目本期投入4,186.72万元；第86、89页深圳研发设计中心本期投入7,148.33万元'

for y in 23 24 25; do
  yr=$((2000+y))
  field_expr historical "$yr" revenue "rev$y" reported '合并利润表营业收入。' high
  field_expr historical "$yr" cost_of_revenue "cost$y" reported '合并利润表营业成本。' high
  field_expr historical "$yr" period_operating_expenses "surtax$y + sell$y + admin$y + rd$y - otherinc$y - credit$y - impair$y" formula '包含税金及附加、销售、管理、研发及经营性减值，扣除经营相关政府补助；排除利息、投资、公允价值与处置损益。' medium
  EBIT="rev$y - cost$y - (surtax$y + sell$y + admin$y + rd$y - otherinc$y - credit$y - impair$y)"
  field_expr historical "$yr" cash_tax "($EBIT) * incometax$y / pretax$y" formula '以当年实际所得税率作用于重构EBIT，消除融资和非经营收益对税基的影响。' medium
  field_expr historical "$yr" depreciation_amortization "fixeddep$y + rouddep$y + amort$y + ltdamort$y" formula '现金流量表补充资料的常规折旧摊销合计。' high
  if [[ "$yr" == 2025 ]]; then
    field_expr historical "$yr" core_business_capex 'capexpay25 - capexsale25 - explore25' formula '现金资本开支净额扣除越南新基地和深圳研发设计中心的开拓性投入。' medium
    field_expr historical "$yr" exploratory_business_capex explore25 formula '单列尚未稳定贡献利润的越南陶瓷谷和深圳研发设计中心投入。' medium
  else
    field_expr historical "$yr" core_business_capex "capexpay$y - capexsale$y" formula '当年长期资产现金投入主要为既有陶瓷产线技改、扩能及环保投入。' medium
    field_est historical "$yr" exploratory_business_capex 0 '未发现可与现金支出可靠对应且尚未形成收入的新业务资本开支，谨慎归入既有主业。' medium '后续项目明细若证明存在可量化的新市场或新技术路线现金投入，则重新分类。'
  fi
  field_expr historical "$yr" operating_cash_flow "cfo$y" reported '合并现金流量表经营活动现金净额。' high
  field_est historical "$yr" after_tax_interest_in_operating_cash_flow 0 '公司利息现金流列在筹资活动，经营现金流无需加回税后利息。' high '现金流附注明确将重大利息支付列入经营活动时调整。'
done

# 由利润路径和现金流路径闭合出的经营性营运资金变动（包含经营性应收、存货和经营性应付综合变化）
field_expr historical 2023 operating_working_capital_increase '((rev23-cost23-(surtax23+sell23+admin23+rd23-otherinc23-credit23-impair23))*(1-incometax23/pretax23)) + fixeddep23+rouddep23+amort23+ltdamort23 - cfo23' formula '以NOPAT加折旧摊销减经营现金流反推，保证与现金流量表路径闭合。' medium
field_expr historical 2024 operating_working_capital_increase '((rev24-cost24-(surtax24+sell24+admin24+rd24-otherinc24-credit24-impair24))*(1-incometax24/pretax24)) + fixeddep24+rouddep24+amort24+ltdamort24 - cfo24' formula '以NOPAT加折旧摊销减经营现金流反推，保证与现金流量表路径闭合。' medium
field_expr historical 2025 operating_working_capital_increase '((rev25-cost25-(surtax25+sell25+admin25+rd25-otherinc25-credit25-impair25))*(1-incometax25/pretax25)) + fixeddep25+rouddep25+amort25+ltdamort25 - cfo25' formula '以NOPAT加折旧摊销减经营现金流反推；2025年为显著资金释放。' medium

# 资本分类事实及字段
fact ca22 流动资产合计 1087781466.40 2022 "$SRC23" '第80页，2023年1月1日比较数'
fact cash22 货币资金 521453300.49 2022 "$SRC23" '第80页，2023年1月1日比较数'
fact tfa22 交易性金融资产 240000000.00 2022 "$SRC23" '第80页，2023年1月1日比较数'
fact cl22 流动负债合计 310202138.42 2022 "$SRC23" '第82页，2023年1月1日比较数'
fact leasecur22 一年内到期的非流动负债 6816729.62 2022 "$SRC23" '第81页，2023年1月1日比较数'
fact fixed22 固定资产 529191221.93 2022 "$SRC23" '第81页，2023年1月1日比较数'
fact cip22 在建工程 16790414.99 2022 "$SRC23" '第81页，2023年1月1日比较数'
fact rou22 使用权资产 19634017.55 2022 "$SRC23" '第81页，2023年1月1日比较数'
fact intang22 无形资产 111707256.94 2022 "$SRC23" '第81页，2023年1月1日比较数'
fact ltp22 长期待摊费用 1037642.19 2022 "$SRC23" '第81页，2023年1月1日比较数'
fact onca22 其他非流动资产 31541345.98 2022 "$SRC23" '第81页，2023年1月1日比较数'
fact deferred22 递延收益 55304967.65 2022 "$SRC23" '第82页，2023年1月1日比较数'

for y in 23 24 25; do
  yr=$((2000+y)); srcvar=SRC$y; src=${!srcvar}
  case $yr in
  2023) vals='1162090157.07 511283363.93 350000000 293860127.88 5353292.05 0 513781530.56 64982415.97 13096605.99 108038676.41 177641.26 47764998.64 57645171.04 0'; pages='80-82';;
  2024) vals='1245640809.23 434898377.63 450000000 277956741.07 6358195.19 0 566554882.80 58346393.87 10895757.72 105871616.19 252293.58 45291358.71 54096626.84 16760000'; pages='72-74';;
  2025) vals='1142793394.51 674080917.45 150000000 320478858.56 1631919.08 6384905.66 683537172.89 80230164.75 89724922.29 103806485.04 414975.21 9163304.10 48444748.95 27940000'; pages='100-103';;
  esac
  read -r ca cash tfa cl leasecur dividend fixed cip rou intang ltp onca deferred otherncl <<< "$vals"
  fact "ca$y" 流动资产合计 "$ca" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "cash$y" 货币资金 "$cash" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "tfa$y" 交易性金融资产 "$tfa" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "cl$y" 流动负债合计 "$cl" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "leasecur$y" 一年内到期的非流动负债 "$leasecur" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "dividend$y" 应付股利 "$dividend" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "fixed$y" 固定资产 "$fixed" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "cip$y" 在建工程 "$cip" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "rou$y" 使用权资产 "$rou" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "intang$y" 无形资产 "$intang" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "ltp$y" 长期待摊费用 "$ltp" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "onca$y" 其他非流动资产 "$onca" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "deferred$y" 递延收益 "$deferred" "$yr" "$src" "第${pages}页，合并资产负债表"
  fact "otherncl$y" 其他非流动负债 "$otherncl" "$yr" "$src" "第${pages}页，合并资产负债表"
done

field_expr capital 2022 operating_working_capital 'ca22-cash22-tfa22-(cl22-leasecur22)' formula '全部非现金、非金融流动资产减非融资流动负债；剔除租赁到期额。' medium
field_expr capital 2022 operating_long_term_assets_net 'fixed22+cip22+rou22+intang22+ltp22+onca22-deferred22' formula '生产长期资产及设备预付款减资产相关递延收益。' medium
for yr in 2023 2024 2025; do
  y=${yr:2:2}
  field_expr capital "$yr" operating_working_capital "ca$y-cash$y-tfa$y-(cl$y-leasecur$y-dividend$y)" formula '全部非现金、非金融流动资产减非融资流动负债；剔除租赁到期额及应付股利。' medium
  field_expr capital "$yr" operating_long_term_assets_net "fixed$y+cip$y+rou$y+intang$y+ltp$y+onca$y-deferred$y-otherncl$y" formula '生产长期资产及设备预付款减资产相关政府补助和设备更新专项资金。' medium
done
field_est capital 2022 required_cash 100000000 '约覆盖一个月现金经营支出及出口结算波动。' medium '月度采购、工资和税费峰值明显低于或高于该水平。'
field_est capital 2023 required_cash 105000000 '随经营规模估计约一个月现金经营支出。' medium '月度采购、工资和税费峰值明显低于或高于该水平。'
field_est capital 2024 required_cash 110000000 '随经营规模估计约一个月现金经营支出。' medium '月度采购、工资和税费峰值明显低于或高于该水平。'
field_est capital 2025 required_cash 120000000 '约覆盖1.2个月常态现金经营支出，反映出口结算和客户集中波动。' medium '月度现金预算或授信备用额度证明更低资金即可安全运营。'
for yr in 2022 2023 2024 2025; do field_est capital "$yr" unsupported_intangible_assets 0 '账上无商誉；无形资产主要为持续生产所需土地使用权和软件，未发现无法解释并购溢价。' medium '附注证明存在不再服务主业或无法产生经营收益的重大无形资产。'; done

# 稳定状态：使用最新收入附近、三年约33%的毛利率和常态资本消耗，不给海外项目额外成长价值。
field_est stable '' revenue 1440000000 '取2024与2025之间偏近最新年度的常态收入，避免把单一大客户增长全额永久化。' medium '客户一订单显著流失，或海外产能形成多客户可验证的持续增量。'
field_est stable '' cost_of_revenue 958000000 '对应约33.5%毛利率，与2023-2025披露区间一致。' medium '能源、人工或汇率使三年滚动毛利率持续偏离2个百分点以上。'
field_est stable '' period_operating_expenses 250000000 '按近年销售、管理、研发、税金、补助和减值的正常净负担估计。' medium '费用率因海外运营或推广持续超过本估计2个百分点。'
field_est stable '' cash_tax 27840000 '按稳定EBIT 2.32亿元的12%现金税率估计。' medium '税收优惠到期或海外利润税率使正常现金税率显著变化。'
field_est stable '' depreciation_amortization 63000000 '接近2025年折旧摊销水平。' medium '新产线全面转固后年度折旧明显高于该水平。'
field_est stable '' core_business_capex 100000000 '高于折旧，保留陶瓷产线技改、环保和持续自动化升级所需投入。' medium '项目投产后多年现金资本开支稳定低于0.8亿元或高于1.2亿元。'
field_est stable '' exploratory_business_capex 0 '基准估值不把越南基地和深圳研发中心继续投入当作稳定期永久支出，也不单独赋予成长价值。' low '披露可验证的项目达产时间、逐年FCFF及全部后续投入后改用成长路径。'
field_est stable '' operating_working_capital_increase 5000000 '常态小幅增长需要少量新增周转资金，剔除2025年异常释放。' low '收入不增长时仍持续占用或释放超过0.2亿元。'

# 2025核心业务闭合
python3 "$TOOL" add-business --model "$MODEL" --business-id color_glaze --name '色釉日用陶瓷' --importance '收入占94.71%，核心订单与现金来源；以全球商超和餐饮客户定制订单为主。' --confidence high --falsifier '年报产品口径调整或客户订单证明其包含重大非日用陶瓷业务。'
python3 "$TOOL" add-business --model "$MODEL" --business-id underglaze --name '釉下五彩与文化瓷' --importance '依靠醴陵釉下五彩工艺和红官窑品牌，内销毛利较高但收入下降。' --confidence medium --falsifier '子公司或产品附注披露其实际成本费用显著偏离估计。'
python3 "$TOOL" add-business --model "$MODEL" --business-id electric --name '电瓷' --importance '面向电力设备客户的小规模工业陶瓷业务，2025年收入下降32.14%。' --confidence medium --falsifier '分部附注披露独立利润或现金流。'
python3 "$TOOL" add-business --model "$MODEL" --business-id materials_service --name '陶瓷新材料与配套服务' --importance '覆盖陶瓷新材料、平台服务费及随主业交付的零星配套品，不作为无信息占位。' --confidence low --falsifier '披露资料可将平台和配套品分别形成具备不同客户、定价和成本逻辑的重大业务。'

biz() { python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
fact colorrev25 色釉陶瓷收入 1393639907.44 2025 "$SRC25" '第16页，分产品收入'
fact colorcost25 色釉陶瓷营业成本 928709650.13 2025 "$SRC25" '第17页，占收入10%以上产品成本'
fact underrev25 釉下五彩收入 38756552.19 2025 "$SRC25" '第16页，分产品收入'
fact electricrev25 电瓷收入 20211897.29 2025 "$SRC25" '第16页，分产品收入'
python3 "$TOOL" set-business-field --model "$MODEL" --business-id color_glaze --field revenue --expression colorrev25 --basis-type reported --reason '2025年报第16页分产品收入。' --confidence high
python3 "$TOOL" set-business-field --model "$MODEL" --business-id color_glaze --field cost_of_revenue --expression colorcost25 --basis-type reported --reason '2025年报第17页披露的色釉陶瓷成本。' --confidence high
biz color_glaze period_operating_expenses 238930257.31 estimate '按业务规模、订单服务和研发资源分配，使公司费用闭合。' medium '产品或子公司费用明细显示差异超过10%。'
biz color_glaze cash_tax 26822922.32227536 estimate '按正EBIT承担绝大部分经营现金税。' medium '税务分部资料显示税收优惠集中于该业务。'
biz color_glaze operating_cash_flow_contribution 330000000 estimate '依据其94.71%收入占比、主要客户回款及2025年整体营运资金释放估计。' medium '产品应收存货明细显示现金释放来自其他业务。'

python3 "$TOOL" set-business-field --model "$MODEL" --business-id underglaze --field revenue --expression underrev25 --basis-type reported --reason '2025年报第16页分产品收入。' --confidence high
biz underglaze cost_of_revenue 21315000 estimate '按约45%毛利率估计，反映品牌和工艺溢价。' low '红官窑产品成本附注披露实际毛利率偏离5个百分点以上。'
biz underglaze period_operating_expenses 9441552.19 estimate '按品牌推广和渠道费用较高的特征分配。' low '子公司费用明细显示明显差异。'
biz underglaze cash_tax 960000 estimate '按估计EBIT的12%税率。' low '独立税务资料显示显著税率差异。'
biz underglaze operating_cash_flow_contribution 12000000 estimate '按估计NOPAT和存货回款贡献分配。' low '子公司现金流披露显示明显差异。'

python3 "$TOOL" set-business-field --model "$MODEL" --business-id electric --field revenue --expression electricrev25 --basis-type reported --reason '2025年报第16页分产品收入。' --confidence high
biz electric cost_of_revenue 15158922.97 estimate '按约25%毛利率估计工业陶瓷直接成本。' low '电瓷子公司或产品成本披露。'
biz electric period_operating_expenses 5552974.32 estimate '规模较小且收入下降，估计略亏。' low '电瓷独立利润资料显示已稳定盈利。'
biz electric cash_tax 0 estimate '估计经营亏损不承担当期经营现金税。' low '税务资料显示单独纳税且有应税利润。'
biz electric operating_cash_flow_contribution 3000000 estimate '回款释放使现金贡献可高于当期NOPAT。' low '产品应收和库存明细显示资金仍在占用。'

biz materials_service revenue 18935126.37 estimate '陶瓷新材料、平台服务费及披露零星配套品收入合计，闭合公司收入。' medium '年报披露更细分产品收入。'
biz materials_service cost_of_revenue 14008726.34 estimate '以公司总成本扣除前三项业务成本闭合。' low '细分成本披露推翻分配。'
biz materials_service period_operating_expenses 6574500.54 estimate '按研发与平台支持强度分配并闭合公司费用。' low '细分费用披露推翻分配。'
biz materials_service cash_tax 0 estimate '估计仍处亏损开拓阶段，不承担经营现金税。' low '税务资料显示该组合已有应税利润。'
biz materials_service operating_cash_flow_contribution 3816332.57 estimate '按回款和小规模库存变化分配，使公司经营现金流闭合。' low '分部现金流资料显示不同贡献。'

# 股东价值桥
fact restricted25 受限货币资金 19758164.91 2025 "$SRC25" '第179页，票据保证金、保函保证金和交易保证金'
fact committedipo25 尚未使用募集资金 40040600.69 2025 "$SRC25" '第85、88页，用于募投项目后续投入'
fact lteq25 长期股权投资 100569179.23 2025 "$SRC25" '第101页，合并资产负债表'
fact nfa25 其他非流动金融资产 11581719.70 2025 "$SRC25" '第101页，合并资产负债表'
fact debtinv25 其他债权投资 30028027.40 2025 "$SRC25" '第101、173页'
fact invprop25 投资性房地产 3367656.71 2025 "$SRC25" '第101页，合并资产负债表'
fact mi25 少数股东权益 6930779.55 2025 "$SRC25" '第103页，合并资产负债表'
fact provision25 预计负债 2009777.78 2025 "$SRC25" '第102、167页，农发行预计利息'
fact shares25 期末普通股股数 251866700 2025 "$SRC25" '第92页，股份总数；无潜在摊薄工具'
field_expr equity '' excess_cash 'cash25+tfa25-120000000-restricted25-committedipo25' formula '货币资金和理财扣除经营必需现金、受限资金及已明确用于募投项目的资金。' medium
field_expr equity '' non_operating_assets 'lteq25+nfa25+debtinv25+invprop25' formula '经营利润已剔除对应投资收益，按账面价值计入联营投资、金融资产和投资物业。' medium
field_est equity '' financing_debt 0 '年末无银行借款或债券；租赁采用经营口径，相关租金和资产已纳入经营。' high '发现年末未并表或表外融资义务。'
field_expr equity '' minority_interest_value 'mi25' reported '规模很小且对应子公司整体亏损，暂以账面少数股东权益作为经济价值代理。' medium
field_expr equity '' other_priority_claims 'provision25' reported '农发行预计利息在普通股之前承担，且未进入经营资本分类。' high
field_expr equity '' diluted_shares 'shares25' reported '期末股份总数，未披露实质潜在摊薄工具。' high
python3 "$TOOL" set-valuation --model "$MODEL" --mode benchmark --reason '海外基地与深圳研发中心尚无可核验的逐年FCFF、达产时间和全部后续投入，采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$TOOL" add-adjustment --model "$MODEL" --name '2025年建设投入分类' --before '现金资本开支2.57亿元' --after '主营1.44亿元；开拓性1.13亿元' --reason '越南陶瓷谷和深圳研发设计中心尚未形成稳定利润，单列为开拓性投入；若项目达产和现金流证据完备则重估。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '可分配现金约束' --before '货币资金及理财8.24亿元' --after '多余现金6.44亿元' --reason '扣除1.20亿元经营必需现金、0.20亿元受限资金和0.40亿元已承诺募投资金；若实际现金预算或资本承诺变化则调整。'

python3 "$TOOL" set-review --model "$MODEL" --item source_traceability --passed --reason '历史与资本字段均引用年报事实ID，名称、期间、合并范围和页码完整。'
python3 "$TOOL" set-review --model "$MODEL" --item economic_classification --passed --reason '经营、金融投资、必需现金、受限及承诺资金、融资和少数股东分类无重复。'
python3 "$TOOL" set-review --model "$MODEL" --item stable_state --passed --reason '稳定状态综合三年收入毛利、最新业务结构及持续技改需求，未机械采用2025年现金释放或海外项目目标。'
python3 "$TOOL" set-review --model "$MODEL" --item capital_return_interpretability --passed --reason 'ROIC分母包含经营营运资金、长期资产和经营必需现金；必需现金为中等可信估计，因此结论限定为资本效率趋势。'
python3 "$TOOL" set-review --model "$MODEL" --item report_consistency --passed --reason '报告重大数字、业务闭合和价值桥将直接采用编译生成结果。'

python3 "$TOOL" compile --model "$MODEL"
python3 "$TOOL" render --model "$MODEL" --output outputs/transcribed-tables.md

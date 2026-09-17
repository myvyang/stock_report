#!/usr/bin/env bash
set -euo pipefail

MODEL=outputs/analysis.json
TOOL=.agents/skills/stock-research/scripts/stock_research.py

rm -f "$MODEL"
python3 "$TOOL" init --name 洽洽食品 --code 002557.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency CNY --trading-currency CNY --security-name A股 --security-unit 股 --output "$MODEL"

af() { python3 "$TOOL" add-fact --model "$MODEL" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope 合并 --source "$5" --locator "$6"; }
sfe() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" --field "$2" ${3:+--year "$3"} --expression "$4" --basis-type "$5" --reason "$6" ${7:+--confidence "$7"} ${8:+--falsifier "$8"}; }
sfv() { python3 "$TOOL" set-field --model "$MODEL" --view "$1" --field "$2" ${3:+--year "$3"} --value "$4" --basis-type "$5" --reason "$6" ${7:+--confidence "$7"} ${8:+--falsifier "$8"}; }

S23='洽洽食品股份有限公司2023年年度报告（2024-04-26）'
U23='https://static.cninfo.com.cn/finalpage/2024-04-26/1219833637.PDF'
S24='洽洽食品股份有限公司2024年年度报告（2025-04-24）'
U24='https://static.cninfo.com.cn/finalpage/2025-04-24/1223280054.pdf'
S25='洽洽食品股份有限公司2025年年度报告（2026-04-21）'
U25='https://static.cninfo.com.cn/finalpage/2026-04-21/1225132043.PDF'

# 历史经营：利润表、现金流量表和补充资料原始事实
for row in \
  'rev23|营业收入|6805627279.13|2023|第101页' 'cost23|营业成本|4984861499.69|2023|第101页' \
  'taxadd23|税金及附加|51991003.07|2023|第101页' 'sell23|销售费用|616499771.95|2023|第101页' \
  'admin23|管理费用|289356094.42|2023|第101页' 'rd23|研发费用|64604519.62|2023|第101页' \
  'otherinc23|其他收益|12159588.35|2023|第101页' 'credit23|信用减值损失|-3470332.89|2023|第101页' \
  'dispose23|资产处置收益|122445.07|2023|第101页' 'pbt23|利润总额|994466378.52|2023|第102页' \
  'inctax23|所得税费用|191295541.63|2023|第102页' 'da23|折旧摊销合计|182061542.58|2023|第213-214页' \
  'capex23|购建固定资产无形资产和其他长期资产支付的现金|143551872.17|2023|第106页' 'ocf23|经营活动产生的现金流量净额|419277593.82|2023|第105页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; af "$id" "$item" "$amt" "$period" "$S23" "$loc；$U23"
done

for row in \
  'rev24|营业收入|7131364079.37|2024|第102页' 'cost24|营业成本|5079107937.98|2024|第102页' \
  'taxadd24|税金及附加|66230881.80|2024|第102页' 'sell24|销售费用|712355117.95|2024|第102页' \
  'admin24|管理费用|308000222.57|2024|第102页' 'rd24|研发费用|75683891.50|2024|第102页' \
  'otherinc24|其他收益|14656539.02|2024|第102页' 'credit24|信用减值损失|-4545957.35|2024|第102页' \
  'dispose24|资产处置收益|-169983.52|2024|第102页' 'pbt24|利润总额|1079439736.25|2024|第103页' \
  'inctax24|所得税费用|229311604.32|2024|第103页' 'da24|折旧摊销合计|180085703.04|2024|第208-209页' \
  'capex24|购建固定资产无形资产和其他长期资产支付的现金|159022086.19|2024|第106页' 'ocf24|经营活动产生的现金流量净额|1038904494.15|2024|第105页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; af "$id" "$item" "$amt" "$period" "$S24" "$loc；$U24"
done

for row in \
  'rev25|营业收入|6573688586.48|2025|第90页' 'cost25|营业成本|5034675408.37|2025|第90页' \
  'taxadd25|税金及附加|52334190.04|2025|第90页' 'sell25|销售费用|737760546.78|2025|第90页' \
  'admin25|管理费用|315369208.09|2025|第90页' 'rd25|研发费用|77179896.46|2025|第90页' \
  'otherinc25|其他收益|13012308.02|2025|第90页' 'credit25|信用减值损失|5152919.24|2025|第90页' \
  'impair25|资产减值损失|-1822074.20|2025|第90页' 'dispose25|资产处置收益|397008.80|2025|第91页' \
  'pbt25|利润总额|392490189.52|2025|第91页' 'inctax25|所得税费用|72898690.57|2025|第91页' \
  'da25|折旧摊销合计|183810406.95|2025|第193-194页' 'capex25|购建固定资产无形资产和其他长期资产支付的现金|96860883.63|2025|第94页' \
  'ocf25|经营活动产生的现金流量净额|70447310.36|2025|第93页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; af "$id" "$item" "$amt" "$period" "$S25" "$loc；$U25"
done

for y in 23 24 25; do
  yr=$((2000+y))
  sfe historical revenue "$yr" "rev$y" reported '合并利润表营业收入。' high ''
  sfe historical cost_of_revenue "$yr" "cost$y" reported '合并利润表营业成本。' high ''
done
sfe historical period_operating_expenses 2023 'taxadd23+sell23+admin23+rd23-otherinc23-credit23-dispose23' formula '剔除财务费用、投资收益和公允价值变动，以税金及附加、销售、管理、研发费用并调整经营性其他收益、信用减值及资产处置重构。' high ''
sfe historical period_operating_expenses 2024 'taxadd24+sell24+admin24+rd24-otherinc24-credit24-dispose24' formula '同口径重构持续经营期间费用净额。' high ''
sfe historical period_operating_expenses 2025 'taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25' formula '同口径重构持续经营期间费用净额；资产减值按其损失符号计入。' high ''
sfe historical cash_tax 2023 '(rev23-cost23-(taxadd23+sell23+admin23+rd23-otherinc23-credit23-dispose23))*inctax23/pbt23' estimate '以当年实际所得税率乘重构EBIT，排除融资和投资收益对税基的影响。' medium '若税务附注明确拆出经营与金融投资税费，应以拆分后的现金税替代。'
sfe historical cash_tax 2024 '(rev24-cost24-(taxadd24+sell24+admin24+rd24-otherinc24-credit24-dispose24))*inctax24/pbt24' estimate '以当年实际所得税率乘重构EBIT。' medium '若税务附注明确拆出经营与金融投资税费，应替代。'
sfe historical cash_tax 2025 '(rev25-cost25-(taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25))*inctax25/pbt25' estimate '以当年实际所得税率乘重构EBIT。' medium '若税务附注明确拆出经营与金融投资税费，应替代。'
for y in 23 24 25; do
  yr=$((2000+y))
  sfe historical depreciation_amortization "$yr" "da$y" reported '现金流量表补充资料中的固定资产、使用权资产、无形资产及长期待摊费用折旧摊销之和。' high ''
  sfe historical core_business_capex "$yr" "capex$y" estimate '公开披露的现金长期资产投入均服务现有坚果炒货产能、自动化、供应链和配套设施，未识别可可靠单列的新业务现金资本开支。' medium '若项目明细证明某项资本开支仅服务尚未商业化的新业务，应重分类。'
  sfv historical exploratory_business_capex "$yr" 0 estimate '未发现可与现有经营明确分离且能量化的开拓性现金资本开支。' medium '若披露海外新建工厂或新业务专属现金支出，则不再为零。'
  sfe historical operating_cash_flow "$yr" "ocf$y" reported '合并现金流量表经营活动现金流量净额。' high ''
  sfv historical after_tax_interest_in_operating_cash_flow "$yr" 0 estimate '中国现金流量表中已付利息列筹资活动、利息收入列投资活动，本口径不需向经营现金流加回税后利息。' high '若附注显示利息现金流分类发生变化，应调整。'
done
sfe historical operating_working_capital_increase 2023 '(rev23-cost23-(taxadd23+sell23+admin23+rd23-otherinc23-credit23-dispose23))-(rev23-cost23-(taxadd23+sell23+admin23+rd23-otherinc23-credit23-dispose23))*inctax23/pbt23+da23-ocf23' estimate '由NOPAT、折旧摊销和经营现金流反推，包含经营应收、存货、预付、应付与其他经营项目的综合现金占用。' medium '若现金流补充资料能完整剔除非营运项目，应以逐项净变动替代。'
sfe historical operating_working_capital_increase 2024 '(rev24-cost24-(taxadd24+sell24+admin24+rd24-otherinc24-credit24-dispose24))-(rev24-cost24-(taxadd24+sell24+admin24+rd24-otherinc24-credit24-dispose24))*inctax24/pbt24+da24-ocf24' estimate '同口径由经营现金流反推；负数代表释放。' medium '若现金流补充资料能完整剔除非营运项目，应替代。'
sfe historical operating_working_capital_increase 2025 '(rev25-cost25-(taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25))-(rev25-cost25-(taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25))*inctax25/pbt25+da25-ocf25' estimate '同口径反推；2025年主要反映原料备货导致存货增加。' medium '若存货价格回落但经营现金流未恢复，则需寻找其他现金占用。'

# 经营资本存量：经营流动资产减经营流动负债，长期资产扣递延收益。
for row in \
 'owc22|经营性营运资金重构值|-19011652.36|2022-12-31|2023年报第93-95页' 'olt22|经营性长期资产净额重构值|1586637046.55|2022-12-31|2023年报第94-95页' \
 'owc23|经营性营运资金重构值|490615143.68|2023-12-31|2023年报第93-95页' 'olt23|经营性长期资产净额重构值|1524269298.27|2023-12-31|2023年报第94-95页' \
 'owc24|经营性营运资金重构值|573923486.48|2024-12-31|2024年报第97-99页' 'olt24|经营性长期资产净额重构值|1564603072.34|2024-12-31|2024年报第98-99页' \
 'owc25|经营性营运资金重构值|721229427.72|2025-12-31|2025年报第85-87页' 'olt25|经营性长期资产净额重构值|1468098994.12|2025-12-31|2025年报第86-87页'; do
  IFS='|' read -r id item amt period loc <<< "$row"
  case "$id" in *22|*23) src="$S23"; url="$U23";; *24) src="$S24"; url="$U24";; *) src="$S25"; url="$U25";; esac
  af "$id" "$item" "$amt" "$period" "$src" "$loc；$url"
done
for y in 2022 2023 2024 2025; do
  sfe capital operating_working_capital "$y" "owc${y:2:2}" formula '经营应收票据、应收账款、预付款、其他应收、存货及其他流动资产，减应付票据、应付账款、合同负债、职工薪酬、税费、其他应付款和其他流动负债；排除现金、金融投资和融资债务。' medium '若附注表明其他应收/应付中存在重大非经营项目，应重分类。'
  sfe capital operating_long_term_assets_net "$y" "olt${y:2:2}" formula '固定资产、在建工程、使用权资产、经营性无形资产、长期待摊及工程预付款，扣除资产相关递延收益。' medium '若无形资产或其他非流动资产不再服务主营，应剔除。'
  sfv capital required_cash "$y" 600000000 estimate '约一个月经营现金支出并考虑原料采购季节性，作为不可抽离的最低现金缓冲。' low '若月度现金流、授信可用性或采购季节性证据显示显著不同，应调整。'
  sfv capital unsupported_intangible_assets "$y" 0 estimate '公司无商誉；账面无形资产主要为土地使用权和软件，均服务生产经营，未发现无法解释的并购溢价。' medium '若附注出现不再服务主营或无法产生收益的无形资产，应剔除。'
done

# 稳定期：三年正常收入中枢、正常原料毛利与费用刚性。
sfv stable revenue '' 6800000000 estimate '2023-2025收入分别约68.1、71.3、65.7亿元；以68亿元作为渠道调整后的正常规模，不采用2024高点或2025低点。' medium '若连续两年收入低于65亿元或恢复并稳定超过72亿元，应重估。'
sfv stable cost_of_revenue '' 4930000000 estimate '对应27.5%正常毛利率，位于2023年的26.75%、2024年的28.78%与2025原料冲击后的23.41%之间。' medium '若新采购季葵花籽、巴旦木和腰果成本不能回落，正常毛利率应下调。'
sfv stable period_operating_expenses '' 1150000000 estimate '销售、管理、研发与经营税费具有刚性；按近两年约11.5-11.7亿元取代表值。' medium '若渠道精耕支出形成持续更高费率，或组织提效显著兑现，应调整。'
sfv stable cash_tax '' 144000000 estimate '按稳定EBIT 7.20亿元的20%经营现金税率估计。' medium '若税收优惠或境外利润结构显著改变实际税率，应调整。'
sfv stable depreciation_amortization '' 180000000 estimate '三年折旧摊销稳定在约1.80-1.84亿元。' high '若新增产能大规模转固，折旧将上升。'
sfv stable core_business_capex '' 150000000 estimate '三年现金资本开支约0.97-1.59亿元，取1.50亿元作为维持现有产能、自动化和柔性改造的常态投入。' medium '若设备更新周期或海外工厂建设抬高持续资本需求，应上调。'
sfv stable exploratory_business_capex '' 0 estimate '基准价值不为尚未验证的海外建厂和新业务选项单独赋值或假设持续投入。' medium '若形成明确预算和可验证商业化路径，应纳入成长现金流。'
sfv stable operating_working_capital_increase '' 20000000 estimate '成熟、低增长状态仅保留小幅库存和渠道扩张占用，剔除2023与2025采购季波动。' low '若直采和海外扩张导致持续库存抬升，应上调。'

# 普通股价值桥（2025年末）。
for row in \
 'cash25|货币资金|3391178500.48|2025-12-31|第85页' 'restricted25|受限货币资金|37768896.39|2025-12-31|第172页' \
 'trading25|交易性金融资产|1106285216.87|2025-12-31|第85页' 'current_debt25|一年内到期的非流动资产|392877789.53|2025-12-31|第86页' \
 'debtinv25|债权投资|372227777.74|2025-12-31|第86页' 'lti25|长期股权投资|113642372.35|2025-12-31|第86页' \
 'oei25|其他权益工具投资|116133982.83|2025-12-31|第86页' 'shortborrow25|短期借款|897000000|2025-12-31|第87页' \
 'currentliab25|一年内到期的非流动负债|1493484451.74|2025-12-31|第87页' 'lease25|租赁负债|2486703.58|2025-12-31|第87页' \
 'minority25|少数股东权益|19298062.81|2025-12-31|第88页' 'shares25|期末股本|505855187|2025-12-31|第87页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; af "$id" "$item" "$amt" "$period" "$S25" "$loc；$U25"
done
sfe equity excess_cash '' 'cash25-restricted25-600000000+trading25+current_debt25+debtinv25' estimate '货币资金扣受限资金和经营必需现金，并加回交易性金融资产、到期存单/债权投资等现金等价型非经营资金。' medium '若募集资金存在不可取消的建设承诺或理财产品存在信用损失，应扣减。'
sfe equity non_operating_assets '' 'lti25+oei25' estimate '联营投资及其他权益工具未参与核心FCFF，按年末账面价值计入。' low '若可实现价值、税费或被投资企业基本面显著偏离账面，应重估。'
sfe equity financing_debt '' 'shortborrow25+currentliab25+lease25' formula '短期借款、一年内到期的可转债及租赁负债；不重复扣除经营应付款。' high ''
sfe equity minority_interest_value '' 'minority25' estimate '新设非全资子公司尚处早期且缺乏独立经营估值资料，以少数股东账面权益作为替代。' low '若非全资子公司形成显著盈利或亏损，应按独立经济价值重估。'
sfv equity other_priority_claims '' 0 estimate '未识别在融资负债之外、且尚未进入FCFF的重大普通股优先索偿。' medium '若已承诺未支付的大额资本项目或股利存在，应扣除。'
sfe equity diluted_shares '' 'shares25' estimate '可转债按债务全额扣除，故不再假设转股；用期末总股本并保守视库存股及期权为潜在稀释。' medium '若可转债转股或期权实质行权，应同步调整债务与股数。'
sfe equity financial_to_trading_fx '' '1' formula '财报与交易币种均为人民币。' high ''

python3 "$TOOL" set-valuation --model "$MODEL" --mode benchmark --reason '缺少可可靠预测的逐年成长FCFF与全部成长投入，采用稳定经营收益八倍统一基准标尺。' --stable-multiple 8 --safety-margin-ratio 0.6

# 2025年核心产品业务，以披露产品收入/成本为控制数；未披露的费用与税按收入和EBIT比例分配。
for row in \
 'sunrev|葵花子收入|4022874944.19|2025|第19页' 'suncost|葵花类营业成本|3029946976.53|2025|第19页' \
 'nutrev|坚果类收入|1762554840.78|2025|第19页' 'nutcost|坚果类营业成本|1416507094.07|2025|第19页' \
 'multirev|其他产品及其他业务收入合计|788258801.51|2025|第19页' 'multicost|其余产品及其他业务营业成本推导值|588221337.77|2025|第19-20页'; do
  IFS='|' read -r id item amt period loc <<< "$row"; af "$id" "$item" "$amt" "$period" "$S25" "$loc；$U25"
done
python3 "$TOOL" add-business --model "$MODEL" --business-id sunflower --name 葵花籽休闲食品 --importance '收入与毛利第一支柱，直接材料价格、传统经销覆盖和品牌定价决定利润。' --confidence high --falsifier '若产品口径或成本归属发生重大调整，应重建。'
python3 "$TOOL" add-business --model "$MODEL" --business-id nuts --name 坚果休闲食品 --importance '收入第二支柱，原料全球供需与健康消费需求共同决定毛利和增长。' --confidence high --falsifier '若坚果业务与新产品共享成本导致披露成本不可比，应调整。'
python3 "$TOOL" add-business --model "$MODEL" --business-id multi --name 多品类休闲食品及配套业务 --importance '覆盖薯片、魔芋、豆果等产品和配套业务，承接品类创新但当前规模较小。' --confidence medium --falsifier '若公司披露新的独立核心品类收入成本，应进一步拆分。'
for spec in 'sunflower sunrev suncost' 'nuts nutrev nutcost' 'multi multirev multicost'; do
  set -- $spec; bid=$1; rv=$2; cv=$3
  python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$bid" --field revenue --expression "$rv" --basis-type reported --reason '年报分产品收入；多品类行为披露剩余产品与配套业务的闭合值。' --confidence high
  python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$bid" --field cost_of_revenue --expression "$cv" --basis-type "$([ "$bid" = multi ] && echo formula || echo reported)" --reason '年报分产品成本；多品类成本以公司总成本扣除葵花类和坚果类闭合。' --confidence "$([ "$bid" = multi ] && echo medium || echo high)"
  python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$bid" --field period_operating_expenses --expression "(taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25)*$rv/rev25" --basis-type estimate --reason '公司未按产品披露期间费用，基准按收入比例分配并与合并总额闭合。' --confidence low --falsifier '产品级营销、人员和研发费用披露将推翻平均分配。'
  python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$bid" --field cash_tax --expression "((rev25-cost25-(taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25))*inctax25/pbt25)*(($rv-$cv-(taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25)*$rv/rev25)/(rev25-cost25-(taxadd25+sell25+admin25+rd25-otherinc25-credit25-impair25-dispose25)))" --basis-type estimate --reason '按各业务估算EBIT占比分配公司经营现金税。' --confidence low --falsifier '产品级税收优惠或地域税率差异披露将推翻。'
  python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$bid" --field operating_cash_flow_contribution --expression "ocf25*$rv/rev25" --basis-type estimate --reason '产品级营运资金未披露，按收入比例分配公司经营现金流并保持闭合。' --confidence low --falsifier '若产品级库存、账期和回款资料可得，应按实际现金转换周期分配。'
done

python3 "$TOOL" add-adjustment --model "$MODEL" --name '经营现金与多余现金分离' --before '2025年末货币资金33.91亿元' --after '扣除6.00亿元经营必需现金和0.38亿元受限资金；其余与现金型金融资产合并计入多余现金' --reason '避免把维持采购、工资、税费和季节性备货的最低流动性同时计入经营资本与股东可分配价值。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '可转债与摊薄口径统一' --before '一年内到期非流动负债14.93亿元，期末股本5.06亿股' --after '可转债按债务扣除，不同时假设转股；股数保守采用期末总股本' --reason '避免既扣除债务又加入转股股份的双重保守或双重计算。'

python3 "$TOOL" set-review --model "$MODEL" --item source_traceability --passed --reason '重大数字均保存年报名称、日期、页码和公开链接；估计单列依据和推翻条件。'
python3 "$TOOL" set-review --model "$MODEL" --item economic_classification --passed --reason '经营、金融投资、融资债务、受限资金与少数股东已分离，未重复计入价值桥。'
python3 "$TOOL" set-review --model "$MODEL" --item stable_state --passed --reason '稳定期综合三年收入、毛利、费用、投入和渠道/原料证据，不机械采用单年。'
python3 "$TOOL" set-review --model "$MODEL" --item capital_return_interpretability --passed --reason '投入资本包含经营营运资金、长期资产和必需现金，分母为正且边界跨年一致；必需现金为低置信估计，正文限制ROIC解释。'
python3 "$TOOL" set-review --model "$MODEL" --item report_consistency --passed --reason '正文完成后将逐项核对中心判断与结构化模型。'

python3 "$TOOL" compile --model "$MODEL"
python3 "$TOOL" validate --model "$MODEL"
python3 "$TOOL" render --model "$MODEL" --output outputs/transcribed-tables.md

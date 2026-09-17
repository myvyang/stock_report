#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
mkdir -p outputs

python3 "$tool" init --name '绿源集团控股' --code '02451.HK' --period-label '截至2025年12月31日止年度' --period-end '2025-12-31' --coverage-years '2023,2024,2025' --financial-currency '人民币' --trading-currency '港元' --security-name '普通股' --security-unit '股' --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "${5:-人民币}" --scope consolidated --source "$6" --locator "$7"; }
field_expr() { python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
field_est() { python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }
single_expr() { python3 "$tool" set-field --model "$model" --view "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
single_est() { python3 "$tool" set-field --model "$model" --view "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }

ar23='绿源集团控股（开曼）有限公司2023年报，2024-03-28'
ar24='绿源集团控股（开曼）有限公司2024年报，2025-03-28'
ar25='绿源集团控股（开曼）有限公司2025年报，2026-03-30'
u23='https://www1.hkexnews.hk/listedco/listconews/sehk/2024/0422/2024042200859.pdf'
u24='https://www1.hkexnews.hk/listedco/listconews/sehk/2025/0423/2025042302219.pdf'
u25='https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0423/2026042303020.pdf'

# Historical reported facts, amounts in RMB.
fact rev23 收益 5082982000 2023 人民币 "$ar24" 'PDF P174，综合收益表'
fact cost23 销售成本 4401743000 2023 人民币 "$ar24" 'PDF P174，综合收益表'
fact op23 经营溢利 140390000 2023 人民币 "$ar24" 'PDF P174，综合收益表'
fact gains23 其他收益净额 8728000 2023 人民币 "$ar24" 'PDF P174及P227，综合收益表及附注7'
fact tdint23 定期存款利息收入 2351000 2023 人民币 "$ar24" 'PDF P227，附注6'
fact leaseint23 融资租赁及长期应收款利息收入 1141000 2023 人民币 "$ar24" 'PDF P227，附注6'
fact taxpaid23 已付所得税 2718000 2023 人民币 "$ar24" 'PDF P180，综合现金流量表'
fact da23 折旧及摊销 91726000 2023 人民币 "$ar24" 'PDF P266，附注35(a)'
fact capexp23 购买物业厂房设备无形资产及土地使用权 203304000 2023 人民币 "$ar24" 'PDF P180，综合现金流量表'
fact capexsale23 出售物业厂房设备所得款 263000 2023 人民币 "$ar24" 'PDF P180，综合现金流量表'
fact cfo23 经营活动所得现金净额 260626000 2023 人民币 "$ar24" 'PDF P180，综合现金流量表'
fact bankint23 已收银行存款利息 32661000 2023 人民币 "$ar24" 'PDF P180，综合现金流量表'

fact rev24 收益 5071956000 2024 人民币 "$ar25" 'PDF P285，综合收益表'
fact cost24 销售成本 4406943000 2024 人民币 "$ar25" 'PDF P285，综合收益表'
fact op24 经营溢利 110171000 2024 人民币 "$ar25" 'PDF P285，综合收益表'
fact gains24 其他收益净额 15882000 2024 人民币 "$ar25" 'PDF P285及P346，综合收益表及附注7'
fact tdint24 定期存款利息收入 5039000 2024 人民币 "$ar25" 'PDF P345，附注6'
fact leaseint24 长期应收款利息收入 616000 2024 人民币 "$ar25" 'PDF P345，附注6'
fact taxpaid24 已付所得税 10138000 2024 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact da24 折旧及摊销 108817000 2024 人民币 "$ar25" 'PDF P410，附注35(a)'
fact capexp24 购买物业厂房设备无形资产及土地使用权 433375000 2024 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact capexsale24 出售物业厂房设备所得款 1947000 2024 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact cfo24 经营活动所用现金净额 -3115000 2024 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact bankint24 已收银行存款利息 38400000 2024 人民币 "$ar25" 'PDF P291，综合现金流量表'

fact rev25 收益 5906847000 2025 人民币 "$ar25" 'PDF P285，综合收益表'
fact cost25 销售成本 5093270000 2025 人民币 "$ar25" 'PDF P285，综合收益表'
fact op25 经营溢利 178924000 2025 人民币 "$ar25" 'PDF P285，综合收益表'
fact gains25 其他收益净额 6182000 2025 人民币 "$ar25" 'PDF P285及P346，综合收益表及附注7'
fact tdint25 定期存款利息收入 3885000 2025 人民币 "$ar25" 'PDF P345，附注6'
fact loanint25 第三方贷款利息收入 1347000 2025 人民币 "$ar25" 'PDF P345，附注6'
fact longint25 长期应收款利息收入 151000 2025 人民币 "$ar25" 'PDF P345，附注6'
fact taxpaid25 已付所得税 17920000 2025 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact da25 折旧及摊销 127361000 2025 人民币 "$ar25" 'PDF P410，附注35(a)'
fact capexp25 购买物业厂房设备无形资产及土地使用权 230537000 2025 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact capexsale25 出售物业厂房设备所得款 1628000 2025 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact cfo25 经营活动所得现金净额 448982000 2025 人民币 "$ar25" 'PDF P291，综合现金流量表'
fact bankint25 已收银行存款利息 30297000 2025 人民币 "$ar25" 'PDF P291，综合现金流量表'

# Balance-sheet facts used to classify operating capital.
for row in \
  'inv22 存货 445672000' 'trade22 贸易及票据应收款 285866000' 'otherca22 其他应收款及预付款 132632000' 'fvoci22 按公允价值计入其他全面收益的应收票据 95229000' 'restricted22 受限制现金 81820000' 'pledged22 质押存款证及理财产品 435000000' 'pay22 贸易票据及其他应付款 1704646000' 'equip22 应付土地及设备款 43460000' 'contract22 合约负债 96384000' 'provcur22 流动拨备 4576000' 'taxliab22 所得税负债 19872000' 'ppe22 物业厂房及设备 844125000' 'rou22 使用权资产 95722000' 'intang22 无形资产 1711000' 'othernca22 非流动其他应收款及预付款 116028000' 'deferred22 递延收入 14558000' 'provnon22 非流动拨备 2432000'; do set -- $row; fact "$1" "$2" "$3" 2022 人民币 "$ar23" 'PDF P148-P149及P218-P229，综合资产负债表及附注'; done
for row in \
  'inv23 存货 254028000' 'trade23 贸易及票据应收款 209516000' 'otherca23 其他应收款及预付款 202992000' 'fvoci23 按公允价值计入其他全面收益的应收票据 31637000' 'restricted23 受限制现金 168980000' 'pledged23 质押存款证及理财产品 447382000' 'pay23 贸易票据及其他应付款 1552893000' 'equip23 应付设备款 32942000' 'contract23 合约负债 82710000' 'provcur23 流动拨备 6560000' 'taxliab23 所得税负债 17585000' 'ppe23 物业厂房及设备 958641000' 'rou23 使用权资产 96492000' 'intang23 无形资产 1068000' 'othernca23 非流动其他应收款及预付款 127698000' 'tradenca23 非流动贸易应收款 4543000' 'deferred23 递延收入 21058000' 'provnon23 非流动拨备 3395000'; do set -- $row; fact "$1" "$2" "$3" 2023 人民币 "$ar24" 'PDF P176-P177及P249-P262，综合资产负债表及附注'; done
for row in \
  'inv24 存货 303068000' 'trade24 贸易及票据应收款 360302000' 'otherca24 其他应收款及预付款 237965000' 'fvoci24 按公允价值计入其他全面收益的应收票据 42000000' 'restricted24 受限制现金 384940000' 'pledged24 质押存款证及理财产品 467136000' 'pay24 贸易票据及其他应付款 1655711000' 'equip24 应付设备款 81462000' 'contract24 合约负债 91395000' 'provcur24 流动拨备 2362000' 'taxliab24 所得税负债 19225000' 'ppe24 物业厂房及设备 1255334000' 'rou24 使用权资产 145140000' 'intang24 无形资产 773000' 'othernca24 非流动其他应收款及预付款 177373000' 'tradenca24 非流动贸易应收款 486000' 'deferred24 递延收入 26135000' 'provnon24 非流动拨备 9147000'; do set -- $row; fact "$1" "$2" "$3" 2024 人民币 "$ar25" 'PDF P287-P288及P376-P399，综合资产负债表及附注'; done
for row in \
  'inv25 存货 334387000' 'trade25 贸易及票据应收款 388103000' 'otherca25 其他应收款及预付款 354906000' 'thirdloan25 国有企业委托贷款净额 50000000' 'fvoci25 按公允价值计入其他全面收益的应收票据 64904000' 'restricted25 受限制现金 362460000' 'pledged25 质押存款证及理财产品 761257000' 'pay25 贸易票据及其他应付款 1940681000' 'equip25 应付设备款 37602000' 'contract25 合约负债 90169000' 'provcur25 流动拨备 3345000' 'taxliab25 所得税负债 21238000' 'ppe25 物业厂房及设备 1312395000' 'rou25 使用权资产 166279000' 'intang25 无形资产 2136000' 'othernca25 非流动其他应收款及预付款 187231000' 'tradenca25 非流动贸易应收款 2745000' 'deferred25 递延收入 37545000' 'provnon25 非流动拨备 11844000'; do set -- $row; fact "$1" "$2" "$3" 2025 人民币 "$ar25" 'PDF P287-P288及P376-P399，综合资产负债表及附注'; done

# Historical standardized fields.
for y in 2023 2024 2025; do
  field_expr historical "$y" revenue "rev${y:2:2}" reported '合并收益表直接数。' high
  field_expr historical "$y" cost_of_revenue "cost${y:2:2}" reported '合并收益表销售成本直接数，转写为正数。' high
  field_expr historical "$y" cash_tax "taxpaid${y:2:2}" reported '采用综合现金流量表已付所得税作为历史经营现金税近似；融资收益税额无法可靠拆分。' medium
  field_expr historical "$y" depreciation_amortization "da${y:2:2}" reported '现金流量表附注折旧及摊销直接数。' high
  field_expr historical "$y" core_business_capex "capexp${y:2:2} - capexsale${y:2:2}" formula '购建经营长期资产付款扣除处置经营资产回款；公开披露显示工厂投入服务现有电动两轮车主业。' high
  field_est historical "$y" exploratory_business_capex 0 '未发现机器人、LYVA或海外新业务对应的单独长期资产现金支出；相关研发已在期间费用中反映。' medium '若后续披露能把长期资产付款明确归属于尚未商业化的新业务，则重分类相应资本开支。'
done
field_expr historical 2023 period_operating_expenses 'rev23 - cost23 - (op23 - gains23 - tdint23 - leaseint23)' formula '以经营溢利为起点，剔除其他收益净额及列在其他收入中的金融性利息，保留政府补助及与主业相关的其他净收支。' medium
field_expr historical 2024 period_operating_expenses 'rev24 - cost24 - (op24 - gains24 - tdint24 - leaseint24)' formula '以经营溢利为起点，剔除其他收益净额及列在其他收入中的金融性利息，保留政府补助及与主业相关的其他净收支。' medium
field_expr historical 2025 period_operating_expenses 'rev25 - cost25 - (op25 - gains25 - tdint25 - loanint25 - longint25)' formula '以经营溢利为起点，剔除其他收益净额及金融性利息，保留政府补助及与主业相关的其他净收支。' medium
field_est historical 2023 operating_working_capital_increase -6472000 '按一致的经营资产负债分类，由2022年末经营性营运资金负3.058亿元变至2023年末负3.123亿元。' medium '若应付票据或其质押存款的追索权、结算用途发生变化，需重做经营营运资金分类。'
field_est historical 2024 operating_working_capital_increase 420451000 '按一致的经营资产负债分类，由2023年末负3.123亿元变至2024年末正1.082亿元。' medium '若应付票据或其质押存款的追索权、结算用途发生变化，需重做经营营运资金分类。'
field_est historical 2025 operating_working_capital_increase 90006000 '按一致的经营资产负债分类，由2024年末1.082亿元增至2025年末1.982亿元；包含为应付票据质押的存款证和理财产品。' medium '若质押金融资产可在不替代担保的情况下释放给股东，则应从经营营运资金移出。'
field_est historical 2023 operating_cash_flow 248145750 '由利润路径FCFF反推的经营口径现金流；法定经营现金流另含银行存款利息且未把经营所需质押金融资产投资现金流重分类。' medium '若取得逐笔票据质押与赎回现金流，可用直接现金流重算。'
field_est historical 2024 operating_cash_flow -204338000 '由利润路径FCFF反推的经营口径现金流，已使经营质押资产、营运资金和非现金项目与资本分类一致。' low '若取得逐笔票据质押与赎回现金流及股份支付现金替代成本，可用直接现金流重算。'
field_est historical 2025 operating_cash_flow 209516750 '由利润路径FCFF反推的经营口径现金流，已把新增质押存款证视作支持供应商票据的经营资金占用。' low '若质押存款证可无条件释放，或取得逐笔票据质押现金流，应重算。'
field_est historical 2023 after_tax_interest_in_operating_cash_flow -24495750 '按已收银行存款利息的75%从经营现金流移除，25%为法定税率近似。' medium '若披露存款利息实际税负，则以实际税后金额替换。'
field_est historical 2024 after_tax_interest_in_operating_cash_flow -28800000 '按已收银行存款利息的75%从经营现金流移除，25%为法定税率近似。' medium '若披露存款利息实际税负，则以实际税后金额替换。'
field_est historical 2025 after_tax_interest_in_operating_cash_flow -22722750 '按已收银行存款利息的75%从经营现金流移除，25%为法定税率近似。' medium '若披露存款利息实际税负，则以实际税后金额替换。'

# Capital classification.
field_expr capital 2022 operating_working_capital 'inv22 + trade22 + otherca22 + fvoci22 + restricted22 + pledged22 - (pay22 - equip22) - contract22 - provcur22 - taxliab22' formula '经营流动资产扣经营流动负债；质押存款与票据保证金因支持应付票据而留在经营资本。' medium
field_expr capital 2023 operating_working_capital 'inv23 + trade23 + otherca23 + fvoci23 + restricted23 + pledged23 - (pay23 - equip23) - contract23 - provcur23 - taxliab23' formula '经营流动资产扣经营流动负债；质押存款与票据保证金因支持应付票据而留在经营资本。' medium
field_expr capital 2024 operating_working_capital 'inv24 + trade24 + otherca24 + fvoci24 + restricted24 + pledged24 - (pay24 - equip24) - contract24 - provcur24 - taxliab24' formula '经营流动资产扣经营流动负债；质押存款与票据保证金因支持应付票据而留在经营资本。' medium
field_expr capital 2025 operating_working_capital 'inv25 + trade25 + otherca25 - thirdloan25 + fvoci25 + restricted25 + pledged25 - (pay25 - equip25) - contract25 - provcur25 - taxliab25' formula '经营流动资产扣经营流动负债；剔除国企委托贷款，质押存款与票据保证金因支持应付票据而留在经营资本。' medium
field_expr capital 2022 operating_long_term_assets_net 'ppe22 + rou22 + intang22 + othernca22 - equip22 - deferred22 - provnon22' formula '经营长期资产及相关预付款，扣除设备款、资产补助递延收入和长期保修拨备。' medium
field_expr capital 2023 operating_long_term_assets_net 'ppe23 + rou23 + intang23 + othernca23 + tradenca23 - equip23 - deferred23 - provnon23' formula '经营长期资产及相关预付款，扣除设备款、资产补助递延收入和长期保修拨备。' medium
field_expr capital 2024 operating_long_term_assets_net 'ppe24 + rou24 + intang24 + othernca24 + tradenca24 - equip24 - deferred24 - provnon24' formula '经营长期资产及相关预付款，扣除设备款、资产补助递延收入和长期保修拨备。' medium
field_expr capital 2025 operating_long_term_assets_net 'ppe25 + rou25 + intang25 + othernca25 + tradenca25 - equip25 - deferred25 - provnon25' formula '经营长期资产及相关预付款，扣除设备款、资产补助递延收入和长期保修拨备。' medium
field_est capital 2022 required_cash 250000000 '约覆盖15天现金经营支出并保留季节性结算缓冲。' low '若月度最低现金、供应商结算峰值或可用授信披露支持不同水平，则调整。'
field_est capital 2023 required_cash 260000000 '随收入和门店网络小幅增加的经营备用金。' low '若月度最低现金、供应商结算峰值或可用授信披露支持不同水平，则调整。'
field_est capital 2024 required_cash 270000000 '约覆盖两周经营支出并保留季节性结算缓冲。' low '若月度最低现金、供应商结算峰值或可用授信披露支持不同水平，则调整。'
field_est capital 2025 required_cash 300000000 '约覆盖19天剔除非现金折旧后的经营成本，考虑四基地和约1.4万门店的结算需要。' low '若月度最低现金、供应商结算峰值或可用授信披露支持不同水平，则调整。'
for y in 2022 2023 2024 2025; do field_est capital "$y" unsupported_intangible_assets 0 '账面无形资产规模极小且主要为软件，未识别商誉或无法解释并购溢价。' high '若附注披露商誉、失效牌照或不能支持经营的无形资产，则扣除。'; done

# Stable benchmark.
single_est stable revenue 5800000000 '以2025年5.907十亿元为基准，下调至5.8十亿元以避免机械外推以旧换新、新国标切换和新基地爬坡带来的单年增长。' medium '若2026年不含政策刺激的销量和单价仍显著高于此水平，稳定收入上修；若渠道去库存则下修。'
single_est stable cost_of_revenue 5017000000 '按13.5%稳定毛利率估计，介于2024年13.1%与2025年13.8%之间。' medium '若原材料、产品组合或经销商返利使持续毛利率偏离13.0%至14.0%，则重估。'
single_est stable period_operating_expenses 620000000 '略低于2025年6.462亿元，反映股份支付高位部分回落，但保留研发、品牌和四基地组织成本。' low '若股份支付、研发或渠道补贴形成更高常态费用，则下调稳定收益。'
single_est stable cash_tax 12000000 '研发费用100%加计扣除及优惠税率持续存在，采用接近2024至2025所得税费用的常态现金税。' medium '若加计扣除政策取消、应税主体利润集中或预扣税上升，则提高税额。'
single_est stable depreciation_amortization 125000000 '接近2025年1.274亿元折旧摊销，代表四基地投入后的折旧水平。' medium '若重庆基地后续新增设备使折旧显著上升，则同步调整折旧和资本开支。'
single_est stable core_business_capex 150000000 '高于折旧以保留四基地更新和小幅提效投入，低于2024建设高峰及2025实际净资本开支。' low '若重庆基地达到200万台规划仍需持续大额建设，或新增基地获批，应上调。'
single_est stable exploratory_business_capex 0 '机器人、LYVA及海外探索缺乏可核验的独立长期资产投入路径，不在稳定价值中单独赋值。' medium '若披露商业订单、专属产能和可分拆资本投入，则纳入成长路径。'
single_est stable operating_working_capital_increase 0 '稳定状态不假定销量继续增长，经营营运资金不再永久增加。' medium '若票据质押比例或库存安全水平结构性上升，则增加常态占用。'

# Equity bridge facts and fields.
fact cash25 现金及现金等价物 474779000 2025 人民币 "$ar25" 'PDF P287，综合资产负债表'
fact timedep25 定期存款 392550000 2025 人民币 "$ar25" 'PDF P287，流动及非流动定期存款'
fact fvtplcur25 流动按公允价值计入损益金融资产 997528000 2025 人民币 "$ar25" 'PDF P287及P376，附注19'
fact assoc25 联营公司投资 22000000 2025 人民币 "$ar25" 'PDF P287，综合资产负债表'
fact unlisted25 非上市实体投资 3300000 2025 人民币 "$ar25" 'PDF P376，附注19'
fact borrow25 借款总额 1286428000 2025 人民币 "$ar25" 'PDF P398，附注32'
fact leasecur25 流动租赁负债 9420000 2025 人民币 "$ar25" 'PDF P288，综合资产负债表'
fact leasenon25 非流动租赁负债 12210000 2025 人民币 "$ar25" 'PDF P288，综合资产负债表'
fact nci25 非控股权益 0 2025 人民币 "$ar25" 'PDF P287，综合资产负债表'
fact shares25 已发行普通股数 426667000 2025 股 "$ar25" 'PDF P400，附注33'
single_expr equity excess_cash '(cash25 + timedep25 + fvtplcur25 - pledged25 - 300000000) * 0.95' formula '未受限现金、定存及未质押存款证扣3亿元经营必需现金，并按中国子公司股息汇出5%预扣税折减。' medium
single_expr equity non_operating_assets 'assoc25 + unlisted25 + thirdloan25' formula '联营公司、非上市投资及国企委托贷款未进入核心FCFF，按账面金额列为非经营资产。' medium
single_expr equity financing_debt 'borrow25 + leasecur25 + leasenon25' formula '借款（含银行票据贴现借款）及租赁负债；经营应付款不重复扣除。' high
single_expr equity minority_interest_value 'nci25' reported '2025年末非控股权益为零。' high
single_est equity other_priority_claims 0 '未识别在借款、租赁及经营负债以外、位于普通股之前的重大索偿。' medium '若期后出现已承诺资本付款、未付股息或优先证券，则加入扣减。'
single_est equity diluted_shares 426667000 '采用年末全部已发行股数，保守覆盖库存股未来用于零成本期权、RSU及2026年股份奖励的潜在摊薄。' medium '若奖励失效或库存股注销，完全摊薄股数应下调；若增发新股则上调。'
single_est equity financial_to_trading_fx 1.08 '采用报告期末附近人民币兑港元约1.08的换算基准；市场快照未提供任务指定汇率。' low '若以明确估值日官方即期汇率计算，则替换本估计。'

# Latest-year product-economics business tree.
fact ebike25 电动自行车收入 3605796000 2025 人民币 "$ar25" 'PDF P34，管理层讨论及分析产品收入表'
fact battery25 随整车销售电池收入 1139583000 2025 人民币 "$ar25" 'PDF P34，管理层讨论及分析产品收入表'
fact scooter25 电动踏板车收入 706182000 2025 人民币 "$ar25" 'PDF P34，管理层讨论及分析产品收入表'
fact parts25 电动两轮车部件收入 338539000 2025 人民币 "$ar25" 'PDF P34，管理层讨论及分析产品收入表'
fact otherprod25 三轮车等其他产品收入 81821000 2025 人民币 "$ar25" 'PDF P34-P35，管理层讨论及分析产品收入表及说明'
fact service25 培训及其他服务收入 34926000 2025 人民币 "$ar25" 'PDF P34，管理层讨论及分析产品收入表'

python3 "$tool" add-business --model "$model" --business-id ebike_system --name '电动自行车及配套电池' --importance '占2025年收入80.3%，是渠道、产品升级和销量增长的主体。' --confidence medium --falsifier '若公司披露配套电池与整车的独立成本、返利或毛利，可替换本分摊。'
python3 "$tool" add-business --model "$model" --business-id scooter --name '电动摩托车及轻便摩托车' --importance '收入约7.06亿元，需求结构变化使2025年收入略降。' --confidence medium --falsifier '若新国标后摩托车品类销量、售价或毛利结构显著改变，则重估。'
python3 "$tool" add-business --model "$model" --business-id parts_services --name '售后部件、三轮车及配套服务' --importance '部件增长45.4%，三轮车等新品增长快，并包含培训等服务，虽规模较小但结构不同。' --confidence low --falsifier '若公司披露各品类成本和经营费用，可替换组合基准估计。'

bfield_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence high; }
bfield_est() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
bfield_expr ebike_system revenue 'ebike25 + battery25' '管理层讨论及分析产品收入直接数合计。'
bfield_expr scooter revenue scooter25 '管理层讨论及分析产品收入直接数。'
bfield_expr parts_services revenue 'parts25 + otherprod25 + service25' '具名部件、其他产品（主要增量为三轮车）及服务收入直接数合计。'
bfield_est ebike_system cost_of_revenue 4104752835 '按13.5%毛利率估计，接近公司整体且整车与配套电池共同定价。' low '若披露产品毛利或电池采购成本，则替换。'
bfield_est scooter cost_of_revenue 621440160 '按12.0%毛利率估计，反映品类收入下降和结构性需求变化。' low '若披露产品毛利或新国标改变售价成本，则替换。'
bfield_est parts_services cost_of_revenue 367077005 '作为合并销售成本闭合项，对应约19.4%毛利率，反映售后件与服务通常较整车毛利高。' low '若披露部件、三轮车和服务毛利，则替换。'
bfield_est ebike_system period_operating_expenses 504050040 '按合并期间经营费用78%分摊，接近收入占比但给增长品类较高渠道与研发负担。' low '若披露品类销售、研发人员或费用归属，则替换。'
bfield_est scooter period_operating_expenses 77546160 '按合并期间经营费用12%分摊。' low '若披露品类销售、研发人员或费用归属，则替换。'
bfield_est parts_services period_operating_expenses 64621800 '按合并期间经营费用10%分摊，余额闭合。' low '若披露品类销售、研发人员或费用归属，则替换。'
bfield_est ebike_system cash_tax 14626000 '按各业务估计EBIT占比分配合并经营现金税。' low '若披露分业务纳税主体利润，则替换。'
bfield_est scooter cash_tax 771000 '按各业务估计EBIT占比分配合并经营现金税。' low '若披露分业务纳税主体利润，则替换。'
bfield_est parts_services cash_tax 2523000 '按各业务估计EBIT占比分配合并经营现金税并闭合。' low '若披露分业务纳税主体利润，则替换。'
bfield_est ebike_system operating_cash_flow_contribution 167613400 '按合并经营口径现金流80%分配，整车主业贡献主体。' low '若披露产品存货、应收、应付和现金收款，则直接重算。'
bfield_est scooter operating_cash_flow_contribution 10475838 '按合并经营口径现金流5%分配，反映收入下降和整车营运占用。' low '若披露产品存货、应收、应付和现金收款，则直接重算。'
bfield_est parts_services operating_cash_flow_contribution 31427512 '余额分配给售后部件、三轮车及服务，反映其较轻营运占用。' low '若披露产品存货、应收、应付和现金收款，则直接重算。'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '机器人、海外与新品牌尚无可核验的逐年FCFF、到达稳定状态时间及完整投入，采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name '金融性及其他净收益剔除' --before '2025年报经营溢利1.789亿元' --after '核心EBIT 1.674亿元' --reason '剔除其他收益净额及定存、第三方贷款和长期应收款利息，避免金融资产收益进入经营价值。'
python3 "$tool" add-adjustment --model "$model" --name '票据质押资金分类' --before '2025年末质押存款证及理财产品7.613亿元列为金融资产' --after '计入经营性营运资金，不作为多余现金' --reason '该等资产为应付票据提供担保，拿走后须替换担保，不能无损释放给股东。'
python3 "$tool" add-adjustment --model "$model" --name '多余现金可达性' --before '未质押可释放现金类资产扣经营现金后8.036亿元' --after '按7.634亿元计入普通股价值' --reason '按中国子公司向境外分红通常适用的5%预扣税折减；若资金已在境外则该折减偏保守。'

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason 'ROIC使用期初期末平均投入资本，质押资产和经营必需现金已纳入；但备用现金与票据分类含估计，正文仅作资本效率趋势解释。'
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '财报直接事实均保存披露名称、期间、币种、合并范围、年报名称及PDF页码。'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '经营资产、质押资金、未质押现金、金融投资、借款及租赁负债未重复计值。'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定状态综合2023至2025历史、2025产品结构、四基地投产及政策刺激，不机械外推16.5%单年增长。'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告重大数字和中心判断将使用结构化模型计算结果，转写表由程序生成。'

python3 "$tool" compile --model "$model"

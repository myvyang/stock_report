#!/usr/bin/env bash
set -euo pipefail
cd /workspace
S=.agents/skills/stock-research/scripts/stock_research.py
M=outputs/analysis.json

fact() { python3 "$S" add-fact --model "$M" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency RMB --scope consolidated --source "$5" --locator "$6"; }
field_expr() { python3 "$S" set-field --model "$M" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"; }
field_est() { python3 "$S" set-field --model "$M" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"; }
stable_est() { python3 "$S" set-field --model "$M" --view stable --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }
equity_expr() { python3 "$S" set-field --model "$M" --view equity --field "$1" --expression "$2" --basis-type "$3" --reason "$4" --confidence "$5"; }
equity_est() { python3 "$S" set-field --model "$M" --view equity --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }

for y in 2023 2024 2025; do
  case "$y" in
    2023) src='敏实集团2023年年度报告，2024-03-26'; page='PDF第58、63-64页';;
    2024) src='敏实集团2024年年度报告，2025-03-24'; page='PDF第60、65-66页';;
    2025) src='敏实集团2025年年度报告，2026-03-23'; page='PDF第65、70-71页';;
  esac
  case "$y" in
    2023) vals='20523674000 14901683000 791910000 1449490000 1396622000 22283000 414571000 351482000 2315475000 1302281000 46665000 44964000 3365907000 3218344000 17031000 43856000 19867000 83025000 0';;
    2024) vals='23147123000 16449053000 1047605000 1638404000 1449444000 16369000 459511000 431179000 2806939000 1452180000 45268000 46820000 3274402000 1906002000 5726000 26098000 29951000 15660000 0';;
    2025) vals='25737192000 18530262000 1031195000 1859051000 1501743000 10129000 302632000 525785000 3295924000 1608327000 44763000 46256000 4912275000 2209754000 0 103273000 21808000 47327000 92570000';;
  esac
  read -r rev cost sell admin research ecl otherinc tax pbt dep roudep amort ocf ppebuy roubuy intbuy leasepay ppepro roupro <<<"$vals"
  fact rev_$y Revenue "$rev" "$y-12-31" "$src" "$page"
  fact cost_$y 'Cost of sales' "$cost" "$y-12-31" "$src" "$page"
  fact sell_$y 'Distribution and selling expenses' "$sell" "$y-12-31" "$src" "$page"
  fact admin_$y 'Administrative expenses' "$admin" "$y-12-31" "$src" "$page"
  fact research_$y 'Research expenditure' "$research" "$y-12-31" "$src" "$page"
  fact ecl_$y 'ECL impairment, net' "$ecl" "$y-12-31" "$src" "$page"
  fact otherinc_$y 'Other income' "$otherinc" "$y-12-31" "$src" "$page"
  fact tax_$y 'Income tax expense' "$tax" "$y-12-31" "$src" "$page"
  fact pbt_$y 'Profit before tax' "$pbt" "$y-12-31" "$src" "$page"
  fact dep_$y 'Depreciation of PPE' "$dep" "$y-12-31" "$src" "$page"
  fact roudep_$y 'Depreciation of ROU assets' "$roudep" "$y-12-31" "$src" "$page"
  fact amort_$y 'Amortisation of intangible assets' "$amort" "$y-12-31" "$src" "$page"
  fact ocf_$y 'Net cash from operating activities' "$ocf" "$y-12-31" "$src" "$page"
  fact ppebuy_$y 'Purchases of PPE' "$ppebuy" "$y-12-31" "$src" "$page"
  fact roubuy_$y 'Payments for ROU assets' "$roubuy" "$y-12-31" "$src" "$page"
  fact intbuy_$y 'Purchases of intangible assets' "$intbuy" "$y-12-31" "$src" "$page"
  fact leasepay_$y 'Repayments of lease liabilities' "$leasepay" "$y-12-31" "$src" "$page"
  fact ppepro_$y 'Proceeds from disposal of PPE' "$ppepro" "$y-12-31" "$src" "$page"
  fact roupro_$y 'Proceeds from disposal of ROU assets' "$roupro" "$y-12-31" "$src" "$page"

  field_expr historical "$y" revenue rev_$y reported '合并损益表直接披露。' high
  field_expr historical "$y" cost_of_revenue cost_$y reported '合并损益表直接披露。' high
  field_expr historical "$y" period_operating_expenses "sell_$y+admin_$y+research_$y+ecl_$y-otherinc_$y" formula '销售、管理、研发及经营信用损失，扣除持续经营相关其他收入；剔除投资收益、利息、联营合营业绩及金融工具损益。' medium
  field_expr historical "$y" depreciation_amortization "dep_$y+roudep_$y+amort_$y" formula '现金流量表非现金调整中的经营资产折旧摊销合计。' high
  field_expr historical "$y" operating_cash_flow ocf_$y reported '合并现金流量表直接披露。' high
  field_est historical "$y" after_tax_interest_in_operating_cash_flow 0 '利息支付列于融资活动，经营现金流在调整财务成本后为融资前口径，因此无需加回税后利息。' high '若后续披露显示利息支付被重分类至经营活动，则改按税后金额加回。'
done

field_est historical 2023 cash_tax 360708521 '以报告所得税费用/税前利润15.18%的实际税率作用于重构EBIT。' medium '若税项附注可将非经营收益税负、递延税和一次性优惠可靠拆分，则重算经营现金税。'
field_est historical 2024 cash_tax 461720101 '以报告所得税费用/税前利润15.36%的实际税率作用于重构EBIT。' medium '若税项附注可将非经营收益税负、递延税和一次性优惠可靠拆分，则重算经营现金税。'
field_est historical 2025 cash_tax 495717572 '以报告所得税费用/税前利润15.95%的实际税率作用于重构EBIT。' medium '若税项附注可将非经营收益税负、递延税和一次性优惠可靠拆分，则重算经营现金税。'

field_est historical 2023 core_business_capex 3055269350 '净现金资本开支32.16亿元中约95%归于既有汽车零部件及全球产能，5%归于早期开拓项目。' low '若公司披露逐项目现金资本开支或新业务专用资产金额，则以直接披露替换。'
field_est historical 2023 exploratory_business_capex 160803650 '同一资本开支池的5%研究估计，反映当年新产品和前瞻研发配套。' low '若公司披露逐项目现金资本开支或新业务专用资产金额，则以直接披露替换。'
field_est historical 2024 core_business_capex 1805708225 '净现金资本开支19.52亿元中约92.5%归于现有业务和量产产能。' low '若公司披露逐项目现金资本开支或新业务专用资产金额，则以直接披露替换。'
field_est historical 2024 exploratory_business_capex 146403775 '约7.5%归于机器人、低空经济、新材料等尚未稳定盈利方向。' low '若公司披露逐项目现金资本开支或新业务专用资产金额，则以直接披露替换。'
field_est historical 2025 core_business_capex 1975444200 '净现金资本开支21.95亿元中约90%归于国际基地、电池盒和车身结构等已量产业务。' low '若公司披露AI液冷、机器人、低空飞行器等专用资产和付款，则重新拆分。'
field_est historical 2025 exploratory_business_capex 219493800 '约10%归于年报明确列示但尚处早期商业化的AI液冷、机器人、低空飞行器等方向。' low '若公司披露AI液冷、机器人、低空飞行器等专用资产和付款，则重新拆分。'

field_est historical 2023 operating_working_capital_increase 43551479 '以NOPAT+折旧摊销-经营现金流反推，吸收营运资金及经营性非现金项目差异，使利润与现金路径一致。' medium '若可取得各营运资金科目的交易、汇兑及收购影响明细，则按资产负债表变动重算。'
field_est historical 2024 operating_working_capital_increase 813904899 '以NOPAT+折旧摊销-经营现金流反推；方向与现金流量表库存、应收净占用一致。' medium '若可取得各营运资金科目的交易、汇兑及收购影响明细，则按资产负债表变动重算。'
field_est historical 2025 operating_working_capital_increase -601202572 '以NOPAT+折旧摊销-经营现金流反推；负值反映回款改善、库存下降和应付款增加带来的释放。' medium '若可取得各营运资金科目的交易、汇兑及收购影响明细，则按资产负债表变动重算。'

# 资本占用：资产负债表经营科目构造，金额为人民币元。
for row in \
  '2022 5527484000 15452034000 1500000000 98030000' \
  '2023 4762090000 17545663000 1600000000 98030000' \
  '2024 5974650000 17365676000 1700000000 98030000' \
  '2025 5050454000 18169325000 1800000000 98030000'; do
  read -r y nwc lta cash gw <<<"$row"
  field_est capital "$y" operating_working_capital "$nwc" '存货、应收和合同资产/成本减应付及合同负债的资产负债表构造值。' medium '若附注披露非经营性其他应收/应付或并购、汇兑重分类，应从构造值剔除。'
  field_est capital "$y" operating_long_term_assets_net "$lta" 'PPE、使用权资产、经营性无形资产及购置预付款，扣除资产相关递延收益。' medium '若披露闲置土地、非经营物业或重大设备工程应付款，则相应重分类。'
  field_est capital "$y" required_cash "$cash" '约覆盖一个月左右的现金经营支出，并随经营规模缓慢增加。' low '若公司披露月度现金支出、最低流动性或资金池可动用额度，则据此替换。'
  field_est capital "$y" unsupported_intangible_assets "$gw" '商誉不能由独立、可验证的新增经营收益解释，按账面全额剔除。' high '若被收购业务的独立持续现金流可验证并已排除在合并经营收益外，才重新计值。'
done

# 稳定状态采用2025附近的正常销量和利润率，剔除当年异常营运资金释放。
stable_est revenue 26000000000 '以2025年收入为锚，考虑已量产车身结构与海外订单、国内市场近乎持平，采用260亿元常态收入。' medium '若海外新产能利用率回落或已获项目量产使收入持续显著偏离260亿元，则重估。'
stable_est cost_of_revenue 18720000000 '采用28.0%稳定毛利率，接近2025年并低于2024年28.9%的阶段高点。' medium '若全球本地化工厂利用率稳定后毛利率连续两年高于29%或低于27%，则重估。'
stable_est period_operating_expenses 4100000000 '采用约15.8%收入的净期间经营费用，接近2025年重构口径。' medium '若新业务研发或全球管理费用率连续两年显著变化，则重估。'
stable_est cash_tax 508800000 '按稳定EBIT 31.8亿元和16%经营现金税率。' medium '若税收优惠到期或地区利润组合令正常现金税率离开14%-18%，则重估。'
stable_est depreciation_amortization 1700000000 '按2025年折旧摊销17.0亿元作为现有资产基准。' medium '若产能投产或处置使折旧摊销持续偏离该水平，则重估。'
stable_est core_business_capex 1800000000 '常态主业资本开支略高于折旧摊销，覆盖全球基地维护、效率提升及现有产品扩产。' low '若公司披露维持性资本开支或资产轻量化后连续两年净资本开支低于15亿元，则下调。'
stable_est exploratory_business_capex 0 '基准经营价值不为证据不足的新业务投入和选择权单独赋值。' low '当新业务形成可验证订单、毛利、量产节奏和完整资金需求后，纳入成长路径。'
stable_est operating_working_capital_increase 100000000 '稳定期不外推2025年6.0亿元释放，按温和增长保留1亿元正常占用。' low '若收入稳定时营运资金连续两年释放或占用超过收入的1%，则重估。'

# 股权价值桥。
fact cashpool_2025 'Cash, pledged bank deposits and time deposits' 6799598000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第19页'
fact fvtpl_nc_2025 'Non-current FVTPL financial assets' 2355566000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66页'
fact fvtpl_c_2025 'Current FVTPL financial assets' 21654000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66页'
fact fvoci_2025 'Debt instruments at FVTOCI' 460622000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66页'
fact loans_2025 'Loan receivables' 69403000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66页'
fact deriv_asset_2025 'Derivative financial assets' 27944000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66及105页'
fact deriv_liab_2025 'Derivative financial liabilities' 6262000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66及105页'
fact jv_2025 'Interests in joint ventures' 274693000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66页'
fact assoc_2025 'Interests in associates' 116546000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66页'
fact plan_2025 'Plan assets' 2659000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第66页'
fact borrow_2025 'Borrowings' 8952783000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第19及20页'
fact otherfin_2025 'Other long-term financing liability' 46600000 2025-12-31 '敏实集团2025年年度报告，2026-03-23' 'PDF第169页'
fact issued_2025 'Issued shares' 1181877000 2025-12-31 HKD consolidated '敏实集团2025年年度报告，2026-03-23' 'PDF第152页'
fact treasury_2025 'Shares held in company own name' 11130000 2025-12-31 HKD consolidated '敏实集团2025年年度报告，2026-03-23' 'PDF第118页'
fact options_2025 'Outstanding share options' 26015000 2025-12-31 HKD consolidated '敏实集团2025年年度报告，2026-03-23' 'PDF第160页'

equity_expr excess_cash 'cashpool_2025-1800000000' formula '现金及存款扣除18亿元经营必需现金；因总额含质押资金，可达性风险在正文说明。' medium
equity_expr non_operating_assets 'fvtpl_nc_2025+fvtpl_c_2025+fvoci_2025+loans_2025+deriv_asset_2025-deriv_liab_2025+jv_2025+assoc_2025+plan_2025' formula '经营收益已剔除投资收益、联营合营业绩及金融工具损益，因此相关资产单独按账面计入。' medium
equity_expr financing_debt 'borrow_2025+otherfin_2025' formula '银行借款及具有赎回义务的地方政府资金/利息属于融资索偿；租赁采用经营口径不重复扣债。' high
equity_est minority_interest_value 623912000 '以2025年非控股股东利润0.77989亿元的8倍近似其合并经营价值份额。' low '若可取得非全资子公司的独立FCFF、债务和现金，应改为逐子公司估值。'
equity_est other_priority_claims 0 '报告日无或有负债；资本承诺属于未来经营资本开支，未与价值桥重复扣除。' medium '若报告日后出现已承诺且未进入稳定FCFF的重大优先支付义务，则纳入扣减。'
equity_expr diluted_shares 'issued_2025-treasury_2025+options_2025' formula '期末已发行股数扣公司持有库存股，并假设全部未行权期权摊薄；受托人已购奖励股不新增发行。' medium
equity_est financial_to_trading_fx 1.10 '缺少任务指定估值日汇率，以1人民币约1.10港元作近似换算，仅用于每股展示。' low '取得报告期末或指定估值日可核验人民币兑港元即期汇率后立即替换。'

# 最新年度分业务：按报告分部收入和毛利，按比例消除内部交易；共同费用、税和经营现金流按分部毛利/EBIT能力分配。
python3 "$S" add-business --model "$M" --business-id body_structure --name '车身结构与电池盒' --importance '最大增量业务；电池盒及车身底盘结构件受新能源与海外量产驱动。' --confidence medium --falsifier '若分部披露显示量产延期、利用率下降或客户订单取消，则下调收入和利润贡献。'
python3 "$S" add-business --model "$M" --business-id plastic --name '塑料与智能内外饰' --importance '保险杠、门系统、密封及智能外饰，依赖车型定点和本地化交付。' --confidence medium --falsifier '若智能外饰订单未按计划量产或运输/本地化成本反弹，则推翻当前利润贡献。'
python3 "$S" add-business --model "$M" --business-id metal_trim --name '金属及饰条' --importance '传统核心外饰业务，客户广、现金流较成熟。' --confidence medium --falsifier '若传统车型份额加速下滑且新订单不能补足，则下调稳定贡献。'
python3 "$S" add-business --model "$M" --business-id aluminium --name '铝材与轻量化部件' --importance '铝挤压和高强材料为电池盒及结构件提供材料与工艺协同。' --confidence medium --falsifier '若铝价传导受阻、内部交易消除显著改变外部利润，则重估。'
python3 "$S" add-business --model "$M" --business-id tooling --name '工装模具与配套汽车部件' --importance '模具连接开发定点与后续量产，并包含未单列的配套汽车部件。' --confidence low --falsifier '若公司披露Others分部的完整产品与外部收入构成，则按直接披露重拆。'

setbiz() { python3 "$S" set-business-field --model "$M" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
names=(body_structure plastic metal_trim aluminium tooling)
revs=(6986434451 5691520384 5132101294 4541655948 3385479923)
costs=(5190147416 4109017229 3554516816 3004738856 2671841683)
opex=(1021773980 900168245 897370376 874237727 405935672)
taxes=(123554835 108850040 108511717 105714473 49086507)
ocfs=(1224357098 1078641070 1075288478 1047569410 486418944)
for i in 0 1 2 3 4; do
  b=${names[$i]}
  setbiz "$b" revenue "${revs[$i]}" '报告分部收入按原始收入比例分配集团内部交易抵销，闭合合并收入。' medium '取得分部外部收入后替换比例消除。'
  setbiz "$b" cost_of_revenue "${costs[$i]}" '分部毛利按比例分配抵销后，由净收入减毛利得到成本。' medium '取得分部外部成本后替换比例消除。'
  setbiz "$b" period_operating_expenses "${opex[$i]}" '未分配经营费用按分部毛利贡献分配，闭合公司总量。' low '取得业务单元销售、管理与研发费用后替换。'
  setbiz "$b" cash_tax "${taxes[$i]}" '经营现金税按各业务重构EBIT比例分配。' low '取得业务或地区实际现金税后替换。'
  setbiz "$b" operating_cash_flow_contribution "${ocfs[$i]}" '合并经营现金流按业务重构EBIT比例分配。' low '取得业务营运资金和经营现金流后替换。'
done

python3 "$S" set-valuation --model "$M" --mode benchmark --reason '新业务与海外扩产缺少逐年订单转收入、完整投入和FCFF证据，采用稳定经营收益八倍统一标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$S" add-adjustment --model "$M" --name '金融工具公允价值收益' --before '2025年其他收益净额2.787亿元' --after '从核心EBIT剔除' --reason '主要来自金融工具公允价值及处置，相关金融资产在价值桥单独计入。'
python3 "$S" add-adjustment --model "$M" --name '2025年营运资金释放' --before '实际FCFF含约6.01亿元经营性资金释放' --after '稳定期改为1.00亿元正常占用' --reason '应收、库存和应付改善不可永久重复，避免将一次性释放资本化。'
python3 "$S" add-adjustment --model "$M" --name '开拓性新业务投入' --before '2025年资本开支包含AI液冷、机器人、低空飞行器等' --after '估计2.19亿元列为开拓性资本开支，稳定估值不给独立期权价值' --reason '虽已有小批量或订单证据，但缺少完整量产利润与资金需求。'
python3 "$S" add-adjustment --model "$M" --name '商誉' --before '账面0.98亿元' --after '从投入资本中全额剔除且不单独加值' --reason '无法用可分离且未计入当前经营收益的现金流解释。'

python3 "$S" set-review --model "$M" --item source_traceability --passed --reason '重大金额均追溯至三年经审计年报页码，研究估计附推翻条件。'
python3 "$S" set-review --model "$M" --item economic_classification --passed --reason '经营、金融投资、融资负债、商誉及少数股东已分开，未重复计值。'
python3 "$S" set-review --model "$M" --item stable_state --passed --reason '稳定状态围绕2025业务结构，剔除金融收益和营运资金释放，并纳入常态主业资本开支。'
python3 "$S" set-review --model "$M" --item capital_return_interpretability --passed --reason '投入资本分母由营运资金、长期经营资产和必需现金构造，边界连续可比；必需现金低置信度在正文限制解释。'
python3 "$S" set-review --model "$M" --item report_consistency --passed --reason '报告中心数字、业务闭合和价值桥将由同一结构化模型生成并复核。'

python3 "$S" compile --model "$M"
python3 "$S" validate --model "$M"
python3 "$S" render --model "$M" --output outputs/transcribed-tables.md

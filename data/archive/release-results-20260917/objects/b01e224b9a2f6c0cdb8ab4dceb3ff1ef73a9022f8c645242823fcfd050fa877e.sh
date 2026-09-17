#!/usr/bin/env bash
set -euo pipefail

SR=".agents/skills/stock-research/scripts/stock_research.py"
MODEL="outputs/analysis.json"
S23="中国稀土2023年年度报告（2024-04-27，https://static.cninfo.com.cn/finalpage/2024-04-27/1219870281.PDF）"
S24="中国稀土2024年年度报告（2025-04-28，https://static.cninfo.com.cn/finalpage/2025-04-28/1223322883.PDF）"
S25="中国稀土2025年年度报告（2026-04-28，https://static.cninfo.com.cn/finalpage/2026-04-28/1225218157.PDF）"

python3 "$SR" init --name "中国稀土集团资源科技股份有限公司" --code "000831.SZ" \
  --period-label "2025年年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" \
  --financial-currency CNY --trading-currency CNY --security-name "A股普通股" --security-unit "股" --output "$MODEL"

fact() {
  python3 "$SR" add-fact --model "$MODEL" --fact-id "$1" --reported-item "$2" --amount "$3" \
    --period "$4" --currency CNY --scope "合并口径" --source "$5" --locator "$6"
}

# 利润及现金流原始事实
fact rev23 "营业收入" 3988310051.42 2023 "$S23" "pp.108-109，合并利润表"
fact cog23 "营业成本" 3096852600.29 2023 "$S23" "pp.108-109，合并利润表"
fact op23 "营业利润" 549010529.19 2023 "$S23" "p.109，合并利润表"
fact fin23 "财务费用" -13863898.36 2023 "$S23" "p.108，合并利润表"
fact invest23 "投资收益" 198334.75 2023 "$S23" "pp.108-109，合并利润表"
fact disposal23 "资产处置收益" -404302.31 2023 "$S23" "p.109，合并利润表"
fact tax23 "所得税费用" 110068204.55 2023 "$S23" "p.109，合并利润表"
fact da23 "固定资产、使用权资产折旧及无形资产、长期待摊费用摊销合计" 60797867.39 2023 "$S23" "pp.181-182，现金流量表补充资料"
fact capex23 "购建固定资产、无形资产和其他长期资产支付的现金" 80541329.31 2023 "$S23" "p.112，合并现金流量表"
fact proceeds23 "处置固定资产、无形资产和其他长期资产收回的现金净额" 29240 2023 "$S23" "p.112，合并现金流量表"
fact lease23 "与租赁相关的现金流出总额" 1264246.65 2023 "$S23" "p.183，租赁附注"
fact cfo23 "经营活动产生的现金流量净额" 346106258.63 2023 "$S23" "p.112，合并现金流量表"
fact interest_income23 "利息收入" 19251297.91 2023 "$S23" "p.108，合并利润表"

fact rev24 "营业收入" 3027348207.35 2024 "$S25" "p.85，合并利润表上年数；与2024年报一致"
fact cog24 "营业成本" 2550534719.14 2024 "$S25" "p.85，合并利润表上年数；与2024年报一致"
fact op24 "营业利润" -254209929.22 2024 "$S25" "p.86，合并利润表上年数；与2024年报一致"
fact fin24 "财务费用" -11416501.64 2024 "$S25" "p.86，合并利润表上年数；与2024年报一致"
fact invest24 "投资收益" 8590150.28 2024 "$S25" "p.86，合并利润表上年数；与2024年报一致"
fact disposal24 "资产处置收益" 56363.99 2024 "$S25" "p.86，合并利润表上年数；与2024年报一致"
fact tax24 "所得税费用" 13047834.11 2024 "$S25" "p.86，合并利润表上年数；与2024年报一致"
fact da24 "固定资产、使用权资产折旧及无形资产、长期待摊费用摊销合计" 75377404.88 2024 "$S24" "pp.173-174，现金流量表补充资料"
fact capex24 "购建固定资产、无形资产和其他长期资产支付的现金" 86377142.69 2024 "$S25" "p.89，合并现金流量表上年数"
fact proceeds24 "处置固定资产、无形资产和其他长期资产收回的现金净额" 53380 2024 "$S25" "p.89，合并现金流量表上年数"
fact lease24 "与租赁相关的现金流出总额" 1298628.01 2024 "$S24" "p.174，租赁附注"
fact cfo24 "经营活动产生的现金流量净额" -594099718.78 2024 "$S25" "p.89，合并现金流量表上年数"
fact interest_income24 "利息收入" 15015434.24 2024 "$S25" "p.86，合并利润表上年数"

fact rev25 "营业收入" 3182090218.84 2025 "$S25" "p.85，合并利润表"
fact cog25 "营业成本" 2652215890.17 2025 "$S25" "p.85，合并利润表"
fact op25 "营业利润" 243269827.81 2025 "$S25" "p.86，合并利润表"
fact fin25 "财务费用" 3949496.60 2025 "$S25" "p.86，合并利润表"
fact invest25 "投资收益" 15970034.47 2025 "$S25" "p.86，合并利润表"
fact disposal25 "资产处置收益" -10799.15 2025 "$S25" "p.86，合并利润表"
fact tax25 "所得税费用" 58717873.83 2025 "$S25" "p.86，合并利润表"
fact da25 "固定资产、使用权资产折旧及无形资产、长期待摊费用摊销合计" 90392455.56 2025 "$S25" "pp.162-163，现金流量表补充资料"
fact capex25 "购建固定资产、无形资产和其他长期资产支付的现金" 59492897.64 2025 "$S25" "p.89，合并现金流量表"
fact proceeds25 "处置固定资产、无形资产和其他长期资产收回的现金净额" 22000 2025 "$S25" "p.89，合并现金流量表"
fact lease25 "与租赁相关的现金流出总额" 1297048.36 2025 "$S25" "p.164，租赁附注"
fact cfo25 "经营活动产生的现金流量净额" 465839138.31 2025 "$S25" "p.89，合并现金流量表"
fact interest_income25 "利息收入" 2923848.77 2025 "$S25" "p.86，合并利润表"

# 经营资本组成项的机械加总；定位中保留了全部披露科目。
fact oca22 "应收票据、应收账款、应收款项融资、预付款、其他应收、存货及税项类其他流动资产合计" 2565108582.33 2022 "$S23" "pp.104-105，合并资产负债表期初数"
fact ocl22 "应付账款、合同负债、职工薪酬、税费、其他应付及其他流动负债合计" 280101144.00 2022 "$S23" "pp.105-106，合并资产负债表期初数"
fact ola22 "固定资产、在建工程、使用权、无形、长期待摊、递延税资产及经营性其他非流动资产合计" 579643180.59 2022 "$S23" "pp.104-105，合并资产负债表期初数"
fact oll22 "预计负债、递延收益、递延税负债、租赁负债及估计资产相关应付款合计" 79408629.84 2022 "$S23" "pp.105-106；资产相关应付款估计1000万元"

fact oca23 "应收票据、应收账款、应收款项融资、预付款、其他应收、存货及税项类其他流动资产合计" 2448580137.91 2023 "$S24" "pp.90-92期初数及附注；采用槽体料重分类后的可比口径"
fact ocl23 "应付账款、合同负债、职工薪酬、税费、其他应付及其他流动负债合计" 239787206.78 2023 "$S24" "pp.91-92，合并资产负债表期初数"
fact ola23 "固定资产、在建工程、使用权、无形、长期待摊、递延税资产及经营性其他非流动资产合计" 729499074.81 2023 "$S24" "pp.90-92期初数及槽体料附注"
fact oll23 "预计负债、递延收益、递延税负债、租赁负债及估计资产相关应付款合计" 93929082.61 2023 "$S24" "pp.91-92及应付账款附注；资产相关应付款估计2000万元"

fact oca24 "应收票据、应收账款、应收款项融资、预付款、其他应收、存货及税项类其他流动资产合计" 2653752091.58 2024 "$S25" "pp.81-82期初数及pp.132-137附注；剔除大额存单"
fact ocl24 "应付账款、合同负债、职工薪酬、税费、其他应付及其他流动负债合计" 376529566.94 2024 "$S25" "pp.82-83期初数及pp.148-151附注"
fact ola24 "固定资产、在建工程、使用权、无形、长期待摊、递延税资产及经营性其他非流动资产合计" 972041819.97 2024 "$S25" "pp.81-82期初数及pp.138-147附注；剔除长期大额存单"
fact oll24 "预计负债、递延收益、递延税负债、租赁负债及资产相关应付款合计" 108941876.67 2024 "$S25" "pp.82-83及pp.148-152期初数；工程设备款按附注直接数"

fact oca25 "应收票据、应收账款、应收款项融资、预付款、其他应收、存货及税项类其他流动资产合计" 2571903486.79 2025 "$S25" "pp.81-82及pp.129-137；剔除6.473亿元大额存单"
fact ocl25 "应付票据、应付账款、合同负债、职工薪酬、税费、其他应付及其他流动负债合计" 259269594.49 2025 "$S25" "pp.82-83及pp.148-151"
fact ola25 "固定资产、在建工程、使用权、无形、长期待摊、递延税资产及经营性其他非流动资产合计" 968585201.00 2025 "$S25" "pp.81-82及pp.138-147；剔除4.748亿元长期大额存单"
fact oll25 "预计负债、递延收益、递延税负债、租赁负债及资产相关应付款合计" 120842601.42 2025 "$S25" "pp.82-83及pp.148-152；工程设备款按附注直接数"

# 价值桥和业务拆分事实
fact cash25 "货币资金" 722976823.74 2025-12-31 "$S25" "pp.81、129"
fact restricted25 "受限货币资金" 635999 2025-12-31 "$S25" "p.147"
fact cd_current25 "其他流动资产中的大额存单" 647328069.32 2025-12-31 "$S25" "pp.136-137"
fact cd_long25 "其他非流动资产中的大额存单" 474821708.36 2025-12-31 "$S25" "p.147"
fact associates25 "长期股权投资" 339212657.26 2025-12-31 "$S25" "pp.81、137-138"
fact equity_invest25 "其他权益工具投资" 11870300 2025-12-31 "$S25" "pp.81、137"
fact debt25 "短期借款" 414540206.05 2025-12-31 "$S25" "pp.82、147"
fact minority25 "少数股东权益" 178581188.24 2025-12-31 "$S25" "p.83"
fact shares25 "股份总数" 1061220807 2025-12-31 "$S25" "pp.70、152"
fact dividend25 "2025年度现金分红预案" 30775403.40 2025 "$S25" "p.2；每10股派0.29元"
fact price260908 "A股收盘价（人民币/股）" 54.96 2026-09-08 "Investing.com历史行情（https://ph.investing.com/equities/guanlu-a-historical-data）" "2026-09-08收盘"

fact oxide_rev25 "稀土氧化物营业收入" 2374064352.81 2025 "$S25" "pp.14-15"
fact oxide_cog25 "稀土氧化物营业成本" 1977523728.46 2025 "$S25" "p.15"
fact metal_rev25 "稀土金属营业收入" 787612398.23 2025 "$S25" "pp.14-15"
fact metal_cog25 "稀土金属营业成本" 667955165.99 2025 "$S25" "p.15"
fact support_rev25 "试剂、技术服务及资源综合利用收入" 20413467.80 2025 "$S25" "pp.14-15；试剂、技术服务及其他收入合计"
fact support_cog25 "试剂、技术服务及资源综合利用成本" 6736995.72 2025 "$S25" "p.15；对应披露成本合计"

seth() {
  local args=(python3 "$SR" set-field --model "$MODEL" --view historical --year "$1" --field "$2" "--expression=$3" --basis-type "$4" --reason "$5" --confidence "$6")
  if [[ -n "${7:-}" ]]; then args+=(--falsifier "$7"); fi
  "${args[@]}"
}

for y in 23 24 25; do
  yr="20$y"
  seth "$yr" revenue "rev$y" reported "合并利润表营业收入" high ""
  seth "$yr" cost_of_revenue "cog$y" reported "合并利润表营业成本" high ""
  seth "$yr" period_operating_expenses "rev$y-cog$y-(op$y+fin$y-invest$y-disposal$y)" formula "以营业利润加回财务费用并剔除投资和资产处置收益重构EBIT；库存减值、税金及附加和经营性补助保留在经营内" medium "若附注明确某项重大减值与持续经营无关，则应重新分类"
  seth "$yr" cash_tax "tax$y" estimate "所得税按纳税主体实际计征；以合并所得税费用近似经营现金税，避免亏损年份机械给出负税" medium "取得按经营与非经营收益拆分的当期所得税和递延税明细"
  seth "$yr" depreciation_amortization "da$y" reported "现金流量表补充资料中的折旧摊销合计" high ""
  seth "$yr" core_business_capex "capex$y-proceeds$y+lease$y" estimate "现金购建支出扣处置回款并加租赁现金支出；公开项目均服务现有采选冶、环保和技改" medium "披露现金支出中有可明确归属于未商业化新业务的项目"
  seth "$yr" exploratory_business_capex "0" estimate "未识别出可与现有稀土业务分离、尚未稳定盈利的新业务长期资产现金投入；研发全部费用化" medium "出现独立新产品/新市场项目且披露其现金资本投入"
  seth "$yr" operating_cash_flow "cfo$y" reported "合并现金流量表经营活动净现金流" high ""
  seth "$yr" after_tax_interest_in_operating_cash_flow "-interest_income$y*0.8" estimate "经营现金流含多余资金利息收入，按20%税率剔除税后利息；借款利息在筹资现金流支付" medium "现金流附注明确不同的利息收付分类或实际税率"
done

# 有效现金营运资金占用，用利润路径与剔除税后利息的经营现金流路径闭合；它不同于期末营运资金存量的简单差额。
seth 2023 operating_working_capital_increase "(op23+fin23-invest23-disposal23-tax23)+da23-cfo23+interest_income23*0.8" estimate "由NOPAT、折旧和经营现金流反推当年有效现金占用，吸收应收应付、存货计价与现金流列报差异" medium "取得能把资产负债表变动逐项桥接到现金流量表的公司底稿"
seth 2024 operating_working_capital_increase "(op24+fin24-invest24-disposal24-tax24)+da24-cfo24+interest_income24*0.8" estimate "由NOPAT、折旧和经营现金流反推；2024年包含大额存货增加与跌价计价差异" medium "取得逐项营运资金现金桥"
seth 2025 operating_working_capital_increase "(op25+fin25-invest25-disposal25-tax25)+da25-cfo25+interest_income25*0.8" estimate "由NOPAT、折旧和经营现金流反推；负数表示2025年回款和采购付款节奏带来的现金释放" medium "取得逐项营运资金现金桥"

setc() {
  local args=(python3 "$SR" set-field --model "$MODEL" --view capital --year "$1" --field "$2" "--expression=$3" --basis-type "$4" --reason "$5" --confidence "$6")
  if [[ -n "${7:-}" ]]; then args+=(--falsifier "$7"); fi
  "${args[@]}"
}
for y in 22 23 24 25; do
  yr="20$y"
  setc "$yr" operating_working_capital "oca$y-ocl$y" formula "经营性应收、存货和税项资产减经营性无息流动负债；大额存单和租赁负债剔除" medium "科目附注显示聚合项中包含重大融资或非经营往来"
  setc "$yr" operating_long_term_assets_net "ola$y-oll$y" estimate "经营长期资产扣资产相关非融资负债；2022-2023资产相关应付款缺少完整拆分，采用基准点估计" medium "取得全部工程设备应付款逐年明细或证明相关资产不再服务经营"
  setc "$yr" required_cash "250000000" estimate "约等于2025年一个月经营现金流出，覆盖采购、工资、税费和结算波动；各年保持可比" medium "月度现金预算或季节性数据表明最低流动性显著不同"
  setc "$yr" unsupported_intangible_assets "0" estimate "无商誉；现存无形资产主要为土地、软件及服务经营的权利，未发现无法解释的并购溢价" medium "出现停用、减值或无法支持经营收益的无形资产"
done

sets() {
  python3 "$SR" set-field --model "$MODEL" --view stable --field "$1" --value "$2" --basis-type estimate \
    --reason "$3" --confidence "$4" --falsifier "$5"
}
sets revenue 3400000000 "三年收入均值约34亿元；不采用单一景气高点或2024低点" medium "未来两年销量、指标或产品价格使收入持续偏离30.6亿至37.4亿元区间"
sets cost_of_revenue 2805000000 "对应17.5%正常毛利率，介于2024年15.75%、2025年16.65%和2023年22.35%之间" medium "连续两年毛利率低于14%或高于21%且非存货计价造成"
sets period_operating_expenses 380000000 "包含税金附加、销售管理研发及常态库存损失净额；低于2024异常减值年、高于2025账面费用" medium "存货跌价三年均值或资源税政策使常态费用偏离1亿元以上"
sets cash_tax 43000000 "按稳定EBIT约20%的经营税率估计，与2023有效税负接近" medium "税收优惠到期或纳税主体利润分布使现金税率长期偏离15%-25%"
sets depreciation_amortization 85000000 "取2024-2025折旧摊销区间并考虑采矿权摊销下降" medium "重大投产或采矿权变更使年折旧摊销持续偏离7000万至1亿元"
sets core_business_capex 80000000 "以2023-2025现金资本开支均值约0.77亿元并覆盖常态环保、技改和矿区投入" medium "已披露项目投产后仍需连续多年超过1.2亿元，或成熟期降至0.5亿元以下"
sets exploratory_business_capex 0 "未对费用化研发和潜在资产注入另行赋予新业务资本开支或价值" medium "出现具名、独立商业化路径且披露完整资金需求的新业务"
sets operating_working_capital_increase 0 "稳定而不增长状态不假设永久增加营运资金；2025释放不可外推" medium "稳定销量仍要求结构性提高库存或延长关联客户账期"

python3 "$SR" set-valuation --model "$MODEL" --mode benchmark --stable-multiple 8 --safety-margin-ratio 0.6 \
  --reason "公司盈利受稀土价格和存货减值显著影响，资产注入和探转采缺少逐年FCFF及投入证据，采用稳定经营收益八倍固定标尺"

sete() {
  local args=(python3 "$SR" set-field --model "$MODEL" --view equity --field "$1" "--expression=$2" --basis-type "$3" --reason "$4" --confidence "$5")
  if [[ -n "${6:-}" ]]; then args+=(--falsifier "$6"); fi
  if [[ -n "${7:-}" ]]; then args+=(--observed-at "$7"); fi
  "${args[@]}"
}
sete excess_cash "cash25-restricted25-250000000" estimate "货币资金扣受限资金和2.5亿元经营必需现金" medium "月度资金安排显示更高最低现金或大额已承诺付款"
sete non_operating_assets "cd_current25+cd_long25+associates25+equity_invest25" formula "剔出FCFF的两类大额存单、联营投资和赣州银行股权按账面值加回" medium "投资减值、处置税费或资金受限使可实现价值低于账面"
sete financing_debt "debt25" reported "短期借款；租赁负债已按经营口径进入资产与资本开支" high ""
sete minority_interest_value "minority25" estimate "缺少两家非全资子公司独立稳定FCFF，以少数股东账面权益作价值替代" low "子公司独立估值显示其经济权益与账面偏离20%以上"
sete other_priority_claims "dividend25" estimate "截至报告形成日已提出的2025年度现金分红将从年末现金中支付，避免把同一现金留给估值股东" medium "分红方案未获股东会通过或已在更新后现金余额中扣除"
sete diluted_shares "shares25" reported "无潜在摊薄工具，使用期末普通股股数" high ""
sete financial_to_trading_fx "1" estimate "财报和交易币种均为人民币" high "币种发生变化"
sete current_price "price260908" reported "最近完整交易日收盘价，仅用于比较，不进入经营价值" high "" "2026-09-08"

python3 "$SR" add-business --model "$MODEL" --business-id oxide --name "稀土氧化物" \
  --importance "占2025年收入74.6%，覆盖矿产、冶炼分离和定制高纯氧化物的主要利润来源" --confidence high \
  --falsifier "公司披露产品口径将矿产品与贸易氧化物拆分且经济性显著不同"
python3 "$SR" add-business --model "$MODEL" --business-id metal --name "稀土金属及合金" \
  --importance "占2025年收入24.8%，下游磁材和合金客户需求及原料价差决定毛利" --confidence high \
  --falsifier "公司披露金属业务仅为代理贸易且不承担库存和价格风险"
python3 "$SR" add-business --model "$MODEL" --business-id services --name "技术服务、试剂与资源综合利用" \
  --importance "覆盖剩余0.6%收入，虽小但把研发平台、试剂和副产/配套经营完整纳入业务树" --confidence medium \
  --falsifier "后续分部披露证明其中存在应独立列示的重大业务"

setb() {
  local args=(python3 "$SR" set-business-field --model "$MODEL" --business-id "$1" --field "$2" "--expression=$3" --basis-type "$4" --reason "$5" --confidence "$6")
  if [[ -n "${7:-}" ]]; then args+=(--falsifier "$7"); fi
  "${args[@]}"
}
setb oxide revenue oxide_rev25 reported "年报按产品披露" high ""
setb oxide cost_of_revenue oxide_cog25 reported "年报按产品披露" high ""
setb metal revenue metal_rev25 reported "年报按产品披露" high ""
setb metal cost_of_revenue metal_cog25 reported "年报按产品披露" high ""
setb services revenue support_rev25 formula "试剂、技术服务和其他披露收入合计" medium "后续披露显示资源综合利用与技术服务应拆开"
setb services cost_of_revenue support_cog25 formula "对应试剂、技术服务和其他成本合计" medium "后续披露显示成本归属不同"
for b in oxide metal services; do
  case "$b" in oxide) r=oxide_rev25; c=oxide_cog25;; metal) r=metal_rev25; c=metal_cog25;; services) r=support_rev25; c=support_cog25;; esac
  setb "$b" period_operating_expenses "(rev25-cog25-(op25+fin25-invest25-disposal25))*$r/rev25" estimate "财报未按产品拆期间费用，按收入比例形成单一基准点并闭合公司" low "披露产品对应税金、研发、销售管理费用或存货减值"
  setb "$b" cash_tax "tax25*(($r-$c)-((rev25-cog25-(op25+fin25-invest25-disposal25))*$r/rev25))/(op25+fin25-invest25-disposal25)" estimate "按各业务估计EBIT占比分配经营税并闭合公司" low "取得分业务纳税主体税负"
  setb "$b" operating_cash_flow_contribution "cfo25*$r/rev25" estimate "财报未拆产品现金流，按收入比例形成基准点并闭合公司" low "取得分业务回款、库存和付款数据"
done

python3 "$SR" add-adjustment --model "$MODEL" --name "2024年存货跌价冲击" \
  --before "资产减值损失-4.153亿元" --after "保留在历史经营费用；稳定期只纳入常态库存损失" \
  --reason "稀土价格波动和存货计价是经营风险，但单年4.15亿元不代表每年重复发生；若长期价格继续下跌则稳定期需下调"
python3 "$SR" add-adjustment --model "$MODEL" --name "大额存单重分类" \
  --before "流动及非流动资产合计11.221亿元" --after "从经营资本剔除并作为非经营资产加回" \
  --reason "大额存单利息已从EBIT剔除，且资金不直接参与生产经营，避免与经营价值重复"
python3 "$SR" add-adjustment --model "$MODEL" --name "少数股东价值替代" \
  --before "账面少数股东权益1.786亿元" --after "暂按1.786亿元扣除" \
  --reason "合并FCFF含广州建丰25%和湖南稀土5.33%的非归母部分；缺少独立稳定FCFF，账面权益仅为低可信替代"

python3 "$SR" set-review --model "$MODEL" --item source_traceability --passed --reason "重大数字均回到2023-2025年法定年报页码，市场价单列观察日和公开来源"
python3 "$SR" set-review --model "$MODEL" --item economic_classification --passed --reason "大额存单和股权投资从经营资产剔除；租赁统一采用经营口径；存货、槽体料和环保负债保留在经营内"
python3 "$SR" set-review --model "$MODEL" --item stable_state --passed --reason "稳定收入取三年均值，毛利率跨越高低景气，资本开支取三年常态，不外推2025营运资金释放"
python3 "$SR" set-review --model "$MODEL" --item capital_return_interpretability --passed --reason "投入资本分母以存货和有形经营资产为主但部分应付款为估计；ROIC仅解释资本占用，不据此宣称护城河"
python3 "$SR" set-review --model "$MODEL" --item report_consistency --passed --reason "报告将在模型编译后引用同一组经营、业务和价值桥数字"

python3 "$SR" compile --model "$MODEL"
python3 "$SR" render --model "$MODEL" --output outputs/transcribed-tables.md

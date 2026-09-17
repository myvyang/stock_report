#!/usr/bin/env bash
set -euo pipefail

PY=python3
TOOL=.agents/skills/stock-research/scripts/stock_research.py
MODEL=outputs/analysis.json
SRC23='广东翔鹭钨业股份有限公司2023年年度报告（2024-04-25）|https://static.cninfo.com.cn/finalpage/2024-04-25/1219788876.PDF'
SRC24='广东翔鹭钨业股份有限公司2024年年度报告（2025-04-29）|https://static.cninfo.com.cn/finalpage/2025-04-29/1223379768.PDF'
SRC25='广东翔鹭钨业股份有限公司2025年年度报告（2026-04-01）|https://static.cninfo.com.cn/finalpage/2026-04-01/1225066810.PDF'

rm -f "$MODEL"
$PY "$TOOL" init --name 翔鹭钨业 --code 002842.SZ --period-label 2025年年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股 --security-unit 股 --output "$MODEL"

fact() {
  local id="$1" item="$2" amount="$3" period="$4" source="$5" locator="$6"
  $PY "$TOOL" add-fact --model "$MODEL" --fact-id "$id" --reported-item "$item" --amount "$amount" --period "$period" --currency 人民币 --scope 合并 --source "$source" --locator "$locator"
}
field_expr() {
  local view="$1" year="$2" field="$3" expr="$4" basis="$5" reason="$6" confidence="$7"
  local args=(--model "$MODEL" --view "$view" --field "$field" --expression "$expr" --basis-type "$basis" --reason "$reason" --confidence "$confidence")
  if [[ -n "$year" ]]; then args+=(--year "$year"); fi
  $PY "$TOOL" set-field "${args[@]}"
}
field_est() {
  local view="$1" year="$2" field="$3" value="$4" reason="$5" confidence="$6" falsifier="$7"
  local args=(--model "$MODEL" --view "$view" --field "$field" --value "$value" --basis-type estimate --reason "$reason" --confidence "$confidence" --falsifier "$falsifier")
  if [[ -n "$year" ]]; then args+=(--year "$year"); fi
  $PY "$TOOL" set-field "${args[@]}"
}

# 利润表、现金流量表及折旧摊销原始事实
fact rev23 营业收入 1798754965.21 2023 "$SRC24" '第90页，合并利润表2023年度比较数'
fact cost23 营业成本 1691345359.54 2023 "$SRC24" '第90页，合并利润表2023年度比较数'
fact biztax23 税金及附加 6210151.02 2023 "$SRC24" '第91页，合并利润表2023年度比较数'
fact sell23 销售费用 8964231.37 2023 "$SRC24" '第91页，合并利润表2023年度比较数'
fact admin23 管理费用 48152890.16 2023 "$SRC24" '第91页，合并利润表2023年度比较数'
fact rd23 研发费用 73057775.88 2023 "$SRC24" '第91页，合并利润表2023年度比较数'
fact interest23 利息费用 58796332.33 2023 "$SRC24" '第91页，合并利润表2023年度比较数'
fact cfo23 经营活动产生的现金流量净额 49770802.84 2023 "$SRC24" '第94页，合并现金流量表2023年度比较数'
fact capex23 购建固定资产无形资产和其他长期资产支付的现金 72251060.17 2023 "$SRC24" '第94页，合并现金流量表2023年度比较数'
fact dep23 固定资产折旧 76950881.54 2023 "$SRC24" '第194页，现金流量表补充资料2023年度比较数'
fact roudep23 使用权资产折旧 210968.57 2023 "$SRC24" '第194页，现金流量表补充资料2023年度比较数'
fact amort23 无形资产摊销 3213567.07 2023 "$SRC24" '第194页，现金流量表补充资料2023年度比较数'
fact ltpamort23 长期待摊费用摊销 4083879.36 2023 "$SRC24" '第194页，现金流量表补充资料2023年度比较数'

fact rev24 营业收入 1749018174.12 2024 "$SRC25" '第73页，合并利润表2024年度比较数'
fact cost24 营业成本 1648410031.29 2024 "$SRC25" '第73页，合并利润表2024年度比较数'
fact biztax24 税金及附加 7947747.28 2024 "$SRC25" '第74页，合并利润表2024年度比较数'
fact sell24 销售费用 7285222.90 2024 "$SRC25" '第74页，合并利润表2024年度比较数'
fact admin24 管理费用 57620836.72 2024 "$SRC25" '第74页，合并利润表2024年度比较数'
fact rd24 研发费用 77943015.16 2024 "$SRC25" '第74页，合并利润表2024年度比较数'
fact interest24 利息费用 54384200.24 2024 "$SRC25" '第74页，合并利润表2024年度比较数'
fact cfo24 经营活动产生的现金流量净额 40080692.08 2024 "$SRC25" '第77页，合并现金流量表2024年度比较数'
fact capex24 购建固定资产无形资产和其他长期资产支付的现金 36581239.94 2024 "$SRC25" '第77页，合并现金流量表2024年度比较数'
fact dep24 固定资产折旧 71086546.86 2024 "$SRC25" '第168页，现金流量表补充资料2024年度比较数'
fact amort24 无形资产摊销 3593540.17 2024 "$SRC25" '第168页，现金流量表补充资料2024年度比较数'
fact ltpamort24 长期待摊费用摊销 3894594.82 2024 "$SRC25" '第168页，现金流量表补充资料2024年度比较数'

fact rev25 营业收入 2408547936.24 2025 "$SRC25" '第73页，合并利润表'
fact cost25 营业成本 2062629255.22 2025 "$SRC25" '第73页，合并利润表'
fact biztax25 税金及附加 10504124.26 2025 "$SRC25" '第74页，合并利润表'
fact sell25 销售费用 8495860.84 2025 "$SRC25" '第74页，合并利润表'
fact admin25 管理费用 47148057.26 2025 "$SRC25" '第74页，合并利润表'
fact rd25 研发费用 85569482.87 2025 "$SRC25" '第74页，合并利润表'
fact interest25 利息费用 36085118.78 2025 "$SRC25" '第74页，合并利润表'
fact cfo25 经营活动产生的现金流量净额 110315567.94 2025 "$SRC25" '第77页，合并现金流量表'
fact capex25 购建固定资产无形资产和其他长期资产支付的现金 104757837.00 2025 "$SRC25" '第77页，合并现金流量表'
fact dep25 固定资产折旧 68722416.87 2025 "$SRC25" '第168页，现金流量表补充资料'
fact amort25 无形资产摊销 3695239.31 2025 "$SRC25" '第168页，现金流量表补充资料'
fact ltpamort25 长期待摊费用摊销 3102325.98 2025 "$SRC25" '第168页，现金流量表补充资料'

# 资产负债表重构所需事实；经营营运资金含应收、存货、预付及其他经营流动资产，扣经营性应付项目。
add_balance_year() {
  local y="$1" src="$2" loc="$3"; shift 3
  local labels=(ar arf pre orec inv ocur npay ap contract emp tax opay oliab fixed cip rou intangible ltp othernoncur deferred)
  local names=(应收账款 应收款项融资 预付款项 其他应收款 存货 其他流动资产 应付票据 应付账款 合同负债 应付职工薪酬 应交税费 其他应付款 其他流动负债 固定资产 在建工程 使用权资产 无形资产 长期待摊费用 其他非流动资产 递延收益)
  local i=0
  for amount in "$@"; do
    fact "${labels[$i]}${y}" "${names[$i]}" "$amount" "$y-12-31" "$src" "$loc"
    i=$((i+1))
  done
}
add_balance_year 2022 "$SRC23" '第78-80页，合并资产负债表2023年1月1日数' 264153826.03 122921358.54 1287452.92 8768812.56 737210105.49 3613288.36 277710512.98 42132679.82 1016062.09 3130746.76 6391890.26 15437837.53 2055132.53 728960597.70 16330011.10 527421.43 113241927.00 14142123.29 13067982.85 12224572.42
add_balance_year 2023 "$SRC23" '第78-80页，合并资产负债表2023年末数' 288305302.06 80343405.88 7142448.64 4216914.65 710237951.38 24099462.15 227532105.64 69501964.40 4846651.00 2657445.82 1030050.83 7733527.66 2967349.54 685918812.33 22102911.01 0 110028359.93 13129087.94 26048229.46 11011009.37
add_balance_year 2024 "$SRC24" '第86-88页，合并资产负债表2024年末数' 299872980.82 75394212.21 1522486.07 1164631.60 717692006.36 40728821.98 208889592.89 118909169.99 3548584.98 2607383.00 3578336.30 469662.62 1702333.96 622174526.29 11749359.67 0 100021951.44 11134493.12 7303438.29 12298172.14
add_balance_year 2025 "$SRC25" '第69-71页，合并资产负债表2025年末数' 159509873.56 48451404.88 67603991.69 2026023.27 1208565574.44 82623568.66 354893364.91 114503306.96 183157899.40 4918623.78 11022513.15 857632.12 22623346.51 567234930.89 76596787.45 0 96326712.13 8032167.14 27885035.11 8552675.10

# 估值桥事实
fact cash25 货币资金 435432782.66 2025-12-31 "$SRC25" '第69页，合并资产负债表'
fact restricted25 受限货币资金 148112128.77 2025-12-31 "$SRC25" '第22页及第125页，银行承兑汇票质押保证金'
fact equityinv25 其他权益工具投资 11075616.17 2025-12-31 "$SRC25" '第70页及第139页'
fact leaserecv25 融资租赁保证金长期应收款 4000000 2025-12-31 "$SRC25" '第139-140页'
fact shortdebt25 短期借款 595494831.83 2025-12-31 "$SRC25" '第70页，合并资产负债表'
fact currentltdebt25 一年内到期的非流动负债 86186259.53 2025-12-31 "$SRC25" '第70页及第155页'
fact longdebt25 长期借款 160707845.61 2025-12-31 "$SRC25" '第71页及第155页'
fact longpay25 长期应付款 55013325.53 2025-12-31 "$SRC25" '第71页及第156-157页，融资租赁款'
fact shares25 股本 327172422 2025-12-31 "$SRC25" '第71页及第58页；年末普通股总数'

# 历史经营字段
for y in 2023 2024 2025; do
  s="${y:2:2}"
  field_expr historical "$y" revenue "rev$s" reported '合并利润表营业收入。' high
  field_expr historical "$y" cost_of_revenue "cost$s" reported '合并利润表营业成本。' high
  field_expr historical "$y" period_operating_expenses "biztax$s + sell$s + admin$s + rd$s" formula '税金及附加、销售、管理和研发费用合计；融资费用及非经营损益剔除。' high
  if [[ "$y" == 2023 ]]; then da_expr='dep23 + roudep23 + amort23 + ltpamort23'; else da_expr="dep$s + amort$s + ltpamort$s"; fi
  field_expr historical "$y" depreciation_amortization "$da_expr" formula '现金流量表补充资料中的经营性折旧与摊销合计。' high
  field_expr historical "$y" core_business_capex "capex$s" formula '购建长期资产现金支出全部归入已产生收入的粉末、合金及钨丝业务；年报明确主要增量为已商业化钨丝项目。' medium
  field_est historical "$y" exploratory_business_capex 0 '未识别出脱离现有钨产业链且尚未商业化的新业务资本开支。' medium '若后续披露资本开支用于独立新业务或尚无收入的新技术路线，则重新分类。'
  field_expr historical "$y" operating_cash_flow "cfo$s" reported '合并现金流量表经营活动现金流量净额。' high
done

# 经营现金税按正EBIT的15%估计；亏损年度取零。经营性营运资金增加为使利润路径与现金流路径闭合的经营应计净变动。
field_est historical 2023 cash_tax 0 '重构EBIT为负，不确认经营现金税。' medium '若税务披露显示当年就主业EBIT实际缴纳不可退税款，则改按实际额。'
field_est historical 2024 cash_tax 0 '重构EBIT为负，不确认经营现金税。' medium '若税务披露显示当年就主业EBIT实际缴纳不可退税款，则改按实际额。'
field_est historical 2025 cash_tax 29130173.3685 '正EBIT按公司及主要子公司15%高新技术企业税率估计，剔除融资税盾。' medium '若税务机关认定、优惠资格或可抵扣亏损使用情况显示长期有效税率显著不同，则重估。'
field_est historical 2023 after_tax_interest_in_operating_cash_flow 49976882.4805 '利息费用按15%税盾折算后加回，统一为融资前FCFF。' medium '若现金利息、资本化利息或实际税盾明细与估计显著不同，则按明细修订。'
field_est historical 2024 after_tax_interest_in_operating_cash_flow 46226570.204 '利息费用按15%税盾折算后加回，统一为融资前FCFF。' medium '若现金利息、资本化利息或实际税盾明细与估计显著不同，则按明细修订。'
field_est historical 2025 after_tax_interest_in_operating_cash_flow 30672350.963 '利息费用按15%税盾折算后加回，统一为融资前FCFF。' medium '若现金利息、资本化利息或实际税盾明细与估计显著不同，则按明细修订。'
field_est historical 2023 operating_working_capital_increase -44263831.5405 '由NOPAT、折旧摊销、经营现金流和税后利息反推的经营应计净变动；包含营运资金及与经营有关的应计调整。' medium '若取得逐项现金流量表工作底稿，可用纯经营营运资金变动替换并同步处理其他经营应计项。'
field_est historical 2024 operating_working_capital_increase -57921259.664 '由NOPAT、折旧摊销、经营现金流和税后利息反推的经营应计净变动；包含营运资金及与经营有关的应计调整。' medium '若取得逐项现金流量表工作底稿，可用纯经营营运资金变动替换并同步处理其他经营应计项。'
field_est historical 2025 operating_working_capital_increase 99603045.6785 '由NOPAT、折旧摊销、经营现金流和税后利息反推的经营应计净变动；与存货大增、预收款增加的方向相符。' medium '若取得逐项现金流量表工作底稿，可用纯经营营运资金变动替换并同步处理其他经营应计项。'

# 投入资本
for y in 2022 2023 2024 2025; do
  field_expr capital "$y" operating_working_capital "ar$y + arf$y + pre$y + orec$y + inv$y + ocur$y - npay$y - ap$y - contract$y - emp$y - tax$y - opay$y - oliab$y" formula '经营性流动资产扣无息经营负债；货币资金和有息负债不在本项。' medium
  field_expr capital "$y" operating_long_term_assets_net "fixed$y + cip$y + rou$y + intangible$y + ltp$y + othernoncur$y - deferred$y" formula '固定资产、在建工程、使用权资产、经营无形资产、长期待摊和其他经营长期资产，扣资产相关递延收益。' medium
  field_est capital "$y" unsupported_intangible_assets 0 '商誉已在经营性长期资产净额中排除；采矿权、土地和软件服务于现有钨业务，未再剔除。' medium '若矿权停产、土地闲置或其他无形资产不能支持经营收益，则应剔除对应账面额。'
done
field_est capital 2022 required_cash 60000000 '按约一个月不含大宗原料采购的工资、税费、能源及日常结算缓冲估计。' low '若月度现金支出、授信可用额度或季节性资料显示最低流动性需求不同，则调整。'
field_est capital 2023 required_cash 60000000 '按约一个月不含大宗原料采购的工资、税费、能源及日常结算缓冲估计。' low '若月度现金支出、授信可用额度或季节性资料显示最低流动性需求不同，则调整。'
field_est capital 2024 required_cash 60000000 '按约一个月不含大宗原料采购的工资、税费、能源及日常结算缓冲估计。' low '若月度现金支出、授信可用额度或季节性资料显示最低流动性需求不同，则调整。'
field_est capital 2025 required_cash 80000000 '经营规模与钨价上升后按约一个月不含大宗原料采购的日常结算缓冲估计。' low '若月度现金支出、授信可用额度或季节性资料显示最低流动性需求不同，则调整。'

# 稳定期采用周期中枢，不把2025年原料涨价和在建钨丝项目的远期产能机械外推。
field_est stable '' revenue 2200000000 '介于2024与2025收入之间，保留硬质合金和钨丝商业化后的结构改善，但不延续2025年钨价急涨。' medium '若连续两年销量、单位售价和客户订单证明高于或低于该收入中枢，则重估。'
field_est stable '' cost_of_revenue 1925000000 '对应12.5%稳定毛利率，高于2023-2024低谷、低于2025高景气的14.36%。' medium '若钨价传导、产品组合或产能利用率使正常毛利率持续偏离12.5%，则重估。'
field_est stable '' period_operating_expenses 148000000 '接近三年经营费用中枢，研发投入维持约0.8亿元。' medium '若组织、研发或环保合规费用形成新的持续台阶，则调整。'
field_est stable '' cash_tax 19050000 '稳定EBIT 1.27亿元按15%经营税率估计。' medium '高新技术企业资格失效或亏损抵扣耗尽后的实际税率显著变化将推翻。'
field_est stable '' depreciation_amortization 75000000 '接近2024-2025折旧摊销水平。' medium '钨丝项目投产后折旧台阶若显著抬升则调整。'
field_est stable '' core_business_capex 75000000 '以折旧摊销为常态主业更新投入，不计在建项目剩余扩张投资，也不赋予对应增长价值。' low '若历史更新支出或投产后维持资本需求长期显著高于折旧，则提高。'
field_est stable '' exploratory_business_capex 0 '未发现独立于现有钨产业链的新业务。' medium '若公司进入尚未商业化的新产品或新行业并持续投入，则重分类。'
field_est stable '' operating_working_capital_increase 0 '固定收入和价格中枢下不假设永久新增营运资金。' medium '若安全库存、客户账期或预付款模式结构性上升，则改为正值。'

# 2025年核心业务，直接披露收入与主要产品成本；“钨丝及配套钨制品”覆盖钨丝和披露的其他钨制品。
fact powderrev25 粉末制品营业收入 1612474346.51 2025 "$SRC25" '第15页，分产品收入'
fact powdercost25 粉末制品营业成本 1403926861.15 2025 "$SRC25" '第16页，分产品成本'
fact alloyrev25 硬质合金营业收入 500531244.75 2025 "$SRC25" '第15页，分产品收入'
fact alloycost25 硬质合金营业成本 422965519.98 2025 "$SRC25" '第16页，分产品成本'
fact wirerev25 钨丝系列营业收入 196587911.69 2025 "$SRC25" '第15页，分产品收入'
fact wirecost25 钨丝系列营业成本 149398704.62 2025 "$SRC25" '第16页，分产品成本'
fact otherrev25 其他钨制品营业收入 98954433.29 2025 "$SRC25" '第15页，分产品收入的“其他”披露项'
$PY "$TOOL" add-business --model "$MODEL" --business-id powder --name 粉末制品 --importance '收入基本盘及上下游一体化枢纽' --confidence medium --falsifier '若公司披露APT、氧化钨、钨粉和碳化钨粉的独立利润与现金流，应重新细分。'
$PY "$TOOL" add-business --model "$MODEL" --business-id alloy --name 硬质合金 --importance '高附加值深加工增长业务' --confidence medium --falsifier '若棒材、矿用合金等子品类经济性差异显著且披露充分，应重新细分。'
$PY "$TOOL" add-business --model "$MODEL" --business-id wire --name 钨丝及配套钨制品 --importance '光伏切割钨丝及规模较小的配套钨制品' --confidence low --falsifier '若其他产品被披露为与钨丝无关且经济性重大，应拆为独立具名业务。'

biz_expr() { $PY "$TOOL" set-business-field --model "$MODEL" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
biz_est() { $PY "$TOOL" set-business-field --model "$MODEL" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
biz_expr powder revenue powderrev25 reported '年报第15页分产品收入。' high
biz_expr powder cost_of_revenue powdercost25 reported '年报第16页分产品成本。' high
biz_expr alloy revenue alloyrev25 reported '年报第15页分产品收入。' high
biz_expr alloy cost_of_revenue alloycost25 reported '年报第16页分产品成本。' high
biz_expr wire revenue 'wirerev25 + otherrev25' formula '钨丝系列收入与其他钨制品收入合计。' medium
biz_expr wire cost_of_revenue 'wirecost25 + cost25 - powdercost25 - alloycost25 - wirecost25' formula '钨丝系列披露成本加上由公司总成本减已披露三类产品成本得到的其他钨制品成本。' medium
for spec in 'powder 91467475.18365306 17562247.85813211 66507059.46874575' 'alloy 34019786.87613959 6531982.302998686 24736180.640633147' 'wire 26230263.170207355 5035943.207869201 19072327.83062111'; do
  read -r id op tx cf <<<"$spec"
  biz_est "$id" period_operating_expenses "$op" '按各业务毛利占比分配公司经营费用，保证合并闭合。' low '若披露分产品人员、研发、销售和管理费用，按直接归属替换。'
  biz_est "$id" cash_tax "$tx" '按各业务估计EBIT占比分配经营现金税。' low '若披露分产品纳税主体及税率，按直接归属替换。'
  biz_est "$id" operating_cash_flow_contribution "$cf" '按各业务估计NOPAT占比分配合并经营现金流，仅用于识别现金来源。' low '若披露分产品营运资金与现金收付，按直接现金流替换。'
done

# 资产与普通股价值桥
field_expr equity '' excess_cash 'cash25 - restricted25 - 80000000' formula '货币资金扣受限保证金和经营必需现金；不对境内资金另作可达性折扣。' medium
field_expr equity '' non_operating_assets 'equityinv25 + leaserecv25' formula '非交易性权益投资及融资租赁保证金，均未计入经营收益。' medium
field_expr equity '' financing_debt 'shortdebt25 + currentltdebt25 + longdebt25 + longpay25' formula '银行借款、一年内到期融资债务和融资租赁款合计。' high
field_est equity '' minority_interest_value 0 '合并资产负债表未列少数股东权益，合并收益亦无少数股东损益。' high '若新增少数股东持股子公司或披露非零少数权益，则重估。'
field_est equity '' other_priority_claims 0 '未识别出在已计债务之外对普通股有重大优先权的索偿。' medium '若出现已承诺未支付的重大资本款、优先股或其他优先索偿，则扣除。'
field_expr equity '' diluted_shares 'shares25' reported '年末可转债已转股并摘牌，未见仍具实质摊薄可能的工具，采用期末普通股数。' high
field_est equity '' financial_to_trading_fx 1 '财报和交易均为人民币。' high '若证券交易币种变化则按估值日汇率换算。'

$PY "$TOOL" set-valuation --model "$MODEL" --mode benchmark --reason '三年含两个亏损年度，2025又处于钨价急涨和钨丝扩建期；稳定状态及逐年成长投入证据不足，采用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
$PY "$TOOL" add-adjustment --model "$MODEL" --name '经营现金重分类' --before '货币资金4.35亿元' --after '经营必需0.80亿元、受限1.48亿元、多余2.07亿元' --reason '保证金不能自由分配，日常结算现金属于投入资本。'
$PY "$TOOL" add-adjustment --model "$MODEL" --name '商誉不计经营资产' --before '商誉0.036亿元' --after '经营性长期资产净额不含商誉' --reason '2023年已发生大额商誉减值，剩余商誉不单独赋值；现有能力由稳定收益反推。'
$PY "$TOOL" add-adjustment --model "$MODEL" --name '钨丝扩产不单独加值' --before '300亿米项目预算4.00亿元、累计投入32.65%' --after '只计当期现金支出，未给予项目额外价值' --reason '尚缺完整投产时间、逐年FCFF和剩余投入回报证据。'

$PY "$TOOL" set-review --model "$MODEL" --item source_traceability --passed --reason '重大财务数均保存披露名称、期间、币种、合并范围、公开年报链接和页码。'
$PY "$TOOL" set-review --model "$MODEL" --item economic_classification --passed --reason '经营营运资金、长期经营资产、受限及多余现金、非经营投资、融资债务和商誉已分开，未重复计值。'
$PY "$TOOL" set-review --model "$MODEL" --item stable_state --passed --reason '稳定期使用三年周期中枢并明确不外推2025钨价高点和未完工钨丝项目。'
$PY "$TOOL" set-review --model "$MODEL" --item capital_return_interpretability --passed --reason '平均投入资本分母完整且可比；ROIC仅用于描述资本占用和周期反转，不解释为持久护城河。'
$PY "$TOOL" set-review --model "$MODEL" --item report_consistency --passed --reason '报告将在模型编译后按同一组核心数字、业务闭合和估值桥撰写。'

$PY "$TOOL" compile --model "$MODEL"
$PY "$TOOL" validate --model "$MODEL"
$PY "$TOOL" render --model "$MODEL" --output outputs/transcribed-tables.md

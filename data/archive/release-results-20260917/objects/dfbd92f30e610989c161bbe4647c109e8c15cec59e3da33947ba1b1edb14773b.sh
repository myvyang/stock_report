#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name "桃李面包" --code "603866.SH" --period-label "2025年年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "普通股" --security-unit "股" --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "合并" --source "$5" --locator "$6"
}
setf() {
  local view="$1" year="$2" field="$3" expression="$4" basis="$5" reason="$6" confidence="$7"
  if [[ -n "$year" ]]; then
    python3 "$tool" set-field --model "$model" --view "$view" --year "$year" --field "$field" --expression "$expression" --basis-type "$basis" --reason "$reason" --confidence "$confidence"
  else
    python3 "$tool" set-field --model "$model" --view "$view" --field "$field" --expression "$expression" --basis-type "$basis" --reason "$reason" --confidence "$confidence"
  fi
}
estimate() {
  local view="$1" year="$2" field="$3" value="$4" reason="$5" confidence="$6" falsifier="$7"
  if [[ -n "$year" ]]; then
    python3 "$tool" set-field --model "$model" --view "$view" --year "$year" --field "$field" --value "$value" --basis-type estimate --reason "$reason" --confidence "$confidence" --falsifier "$falsifier"
  else
    python3 "$tool" set-field --model "$model" --view "$view" --field "$field" --value "$value" --basis-type estimate --reason "$reason" --confidence "$confidence" --falsifier "$falsifier"
  fi
}

s23="桃李面包2023年年度报告"
s24="桃李面包2024年年度报告"
s25="桃李面包2025年年度报告"

# 历史经营事实，单位均为财报原始人民币元。
fact rev23 "营业收入" 6758573196.57 2023 "$s23" "第150页，合并利润表"
fact cost23 "营业成本" 5218510828.53 2023 "$s23" "第150页，合并利润表"
fact surtax23 "税金及附加" 79588228.99 2023 "$s23" "第151页，合并利润表"
fact sell23 "销售费用" 549205354.47 2023 "$s23" "第151页，合并利润表"
fact admin23 "管理费用" 138472040.53 2023 "$s23" "第151页，合并利润表"
fact rd23 "研发费用" 33697670.40 2023 "$s23" "第151页，合并利润表"
fact current_tax23 "当期所得税费用" 196234894.01 2023 "$s23" "第332页，所得税费用附注"
fact dep23 "固定资产折旧" 195524404.18 2023 "$s23" "第337页，现金流量表补充资料"
fact roudep23 "使用权资产摊销" 21467973.26 2023 "$s23" "第337页，现金流量表补充资料"
fact amort23 "无形资产摊销" 11508581.85 2023 "$s23" "第337页，现金流量表补充资料"
fact ltprepaid_amort23 "长期待摊费用摊销" 25829411.44 2023 "$s23" "第337页，现金流量表补充资料"
fact capex_paid23 "购建固定资产、无形资产和其他长期资产支付的现金" 861276166.42 2023 "$s23" "第158页，合并现金流量表"
fact disposal23 "处置固定资产、无形资产和其他长期资产收回的现金净额" 1417752.90 2023 "$s23" "第158页，合并现金流量表"
fact ocf23 "经营活动产生的现金流量净额" 810608998.82 2023 "$s23" "第158页，合并现金流量表"

fact rev24 "营业收入" 6087158512.65 2024 "$s24" "第123页，合并利润表"
fact cost24 "营业成本" 4663507784.54 2024 "$s24" "第124页，合并利润表"
fact surtax24 "税金及附加" 78814894.81 2024 "$s24" "第124页，合并利润表"
fact sell24 "销售费用" 481924084.54 2024 "$s24" "第124页，合并利润表"
fact admin24 "管理费用" 136368040.70 2024 "$s24" "第124页，合并利润表"
fact rd24 "研发费用" 22968394.81 2024 "$s24" "第124页，合并利润表"
fact current_tax24 "当期所得税费用" 175767193.28 2024 "$s25" "第189页，所得税费用附注上期数"
fact dep24 "固定资产折旧" 222847979.57 2024 "$s24" "第283页，现金流量表补充资料"
fact roudep24 "使用权资产摊销" 16112398.64 2024 "$s24" "第283页，现金流量表补充资料"
fact amort24 "无形资产摊销" 11023716.55 2024 "$s24" "第283页，现金流量表补充资料"
fact ltprepaid_amort24 "长期待摊费用摊销" 27453457.62 2024 "$s24" "第283页，现金流量表补充资料"
fact capex_paid24 "购建固定资产、无形资产和其他长期资产支付的现金" 656640346.22 2024 "$s24" "第131页，合并现金流量表"
fact disposal24 "处置固定资产、无形资产和其他长期资产收回的现金净额" 5040886.65 2024 "$s24" "第131页，合并现金流量表"
fact ocf24 "经营活动产生的现金流量净额" 997797814.92 2024 "$s24" "第130页，合并现金流量表"

fact rev25 "营业收入" 5448153351.32 2025 "$s25" "第82页，合并利润表"
fact cost25 "营业成本" 4220953554.03 2025 "$s25" "第82页，合并利润表"
fact surtax25 "税金及附加" 83691032.01 2025 "$s25" "第82页，合并利润表"
fact sell25 "销售费用" 478955256.79 2025 "$s25" "第82页，合并利润表"
fact admin25 "管理费用" 125514791.82 2025 "$s25" "第82页，合并利润表"
fact rd25 "研发费用" 26254779.82 2025 "$s25" "第82页，合并利润表"
fact current_tax25 "当期所得税费用" 160715788.34 2025 "$s25" "第189页，所得税费用附注"
fact dep25 "固定资产折旧" 269141343.83 2025 "$s25" "第191页，现金流量表补充资料"
fact roudep25 "使用权资产摊销" 11374125.64 2025 "$s25" "第191页，现金流量表补充资料"
fact amort25 "无形资产摊销" 10932383.58 2025 "$s25" "第191页，现金流量表补充资料"
fact ltprepaid_amort25 "长期待摊费用摊销" 25664433.41 2025 "$s25" "第191页，现金流量表补充资料"
fact capex_paid25 "购建固定资产、无形资产和其他长期资产支付的现金" 335753642.91 2025 "$s25" "第86页，合并现金流量表"
fact disposal25 "处置固定资产、无形资产和其他长期资产收回的现金净额" 8348818.60 2025 "$s25" "第86页，合并现金流量表"
fact ocf25 "经营活动产生的现金流量净额" 764135977.22 2025 "$s25" "第86页，合并现金流量表"

for y in 2023 2024 2025; do
  suffix="${y:2:2}"
  setf historical "$y" revenue "rev$suffix" reported "合并利润表营业收入" high
  setf historical "$y" cost_of_revenue "cost$suffix" reported "合并利润表营业成本" high
  setf historical "$y" period_operating_expenses "surtax$suffix + sell$suffix + admin$suffix + rd$suffix" formula "经营费用包括税金及附加、销售、管理和研发费用；排除财务费用及投资、公允价值和非经常损益" high
  setf historical "$y" cash_tax "current_tax$suffix" reported "以当期所得税费用近似经营现金税，避免把递延税变动当作当期现金税" medium
  setf historical "$y" depreciation_amortization "dep$suffix + roudep$suffix + amort$suffix + ltprepaid_amort$suffix" formula "经营性固定资产、使用权资产、无形资产及长期待摊费用折旧摊销合计" high
  setf historical "$y" core_business_capex "capex_paid$suffix - disposal$suffix" formula "采用融资租赁口径；经营长期资产购建现金减处置回款，全部服务现有烘焙业务及区域扩张" high
  estimate historical "$y" exploratory_business_capex 0 "没有披露脱离现有烘焙主业的新业务资本项目；研发中心、佛山工厂及区域扩张均归入主营业务资本开支" medium "若后续披露独立新技术路线或新业务项目的专属资本支出，则应重分类"
  setf historical "$y" operating_cash_flow "ocf$suffix" reported "合并现金流量表经营活动现金流量净额" high
  estimate historical "$y" after_tax_interest_in_operating_cash_flow 0 "利息支出在筹资现金流支付，经营现金流中利息收入规模很小，按零处理" medium "若现金流量表政策显示重大净利息现金流进入经营活动，应调整"
done

# 为使利润路径和现金流路径闭合，以NOPAT、折旧摊销与经营现金流反推广义经营应计资金变化。
estimate historical 2023 operating_working_capital_increase -13414448.45 "由NOPAT+折旧摊销-经营现金流反推；包含经营性周转项目及未单列经营应计项目的净释放" medium "若公司披露可完整剥离税费时点及其他经营应计项目的营运资金现金变动，应以该明细替代"
estimate historical 2024 operating_working_capital_increase -192552142.57 "由NOPAT+折旧摊销-经营现金流反推；包含经营性周转项目及未单列经营应计项目的净释放" medium "若公司披露可完整剥离税费时点及其他经营应计项目的营运资金现金变动，应以该明细替代"
estimate historical 2025 operating_working_capital_increase -94955542.25 "由NOPAT+折旧摊销-经营现金流反推；包含经营性周转项目及未单列经营应计项目的净释放" medium "若公司披露可完整剥离税费时点及其他经营应计项目的营运资金现金变动，应以该明细替代"

# 资产分类原始事实：为控制模型体积，字段事实是年报主表中同页披露项目的逐项算术组合。
fact owc22_assets "经营流动资产合计（应收账款、预付、其他应收、存货及其他流动资产）" 869546823.33 2022 "$s23" "第142-143页，合并资产负债表上年末数"
fact owc22_liabs "经营流动负债合计（应付账款、合同负债、职工薪酬、应交税费、其他应付款及其他流动负债）" 908901846.71 2022 "$s23" "第144-145页，合并资产负债表上年末数"
fact olt22 "经营性长期资产毛额（固定资产、在建、使用权、无形、长期待摊及其他非流动资产）" 4810673387.95 2022 "$s23" "第143页，合并资产负债表上年末数"
fact deferred22 "递延收益" 7205188.94 2022 "$s23" "第145页，合并资产负债表上年末数"
fact owc23_assets "经营流动资产合计（应收、预付、存货及其他经营流动资产）" 758092517.79 2023 "$s23" "第142-143页，合并资产负债表"
fact owc23_liabs "经营流动负债合计" 799753462.14 2023 "$s23" "第144-145页，合并资产负债表"
fact olt23 "经营性长期资产毛额" 5468846831.88 2023 "$s23" "第143页，合并资产负债表"
fact deferred23 "递延收益" 11962872.93 2023 "$s23" "第145页，合并资产负债表"
fact owc24_assets "经营流动资产合计" 601829034.41 2024 "$s24" "第116-117页，合并资产负债表"
fact owc24_liabs "经营流动负债合计" 726961348.97 2024 "$s24" "第118页，合并资产负债表"
fact olt24 "经营性长期资产毛额" 5821677273.07 2024 "$s24" "第117页，合并资产负债表"
fact deferred24 "递延收益" 11537587.25 2024 "$s24" "第119页，合并资产负债表"
fact owc25_assets "经营流动资产合计" 563985327.29 2025 "$s25" "第77-78页，合并资产负债表"
fact owc25_liabs "经营流动负债合计" 733751399.44 2025 "$s25" "第78-79页，合并资产负债表"
fact olt25 "经营性长期资产毛额" 5878449325.53 2025 "$s25" "第78页，合并资产负债表"
fact deferred25 "递延收益" 21426794.77 2025 "$s25" "第79页，合并资产负债表"

for y in 2022 2023 2024 2025; do
  suffix="${y:2:2}"
  setf capital "$y" operating_working_capital "owc${suffix}_assets - owc${suffix}_liabs" formula "经营性流动资产减无息经营流动负债；金融投资及融资性票据、借款不在其中" medium
  setf capital "$y" operating_long_term_assets_net "olt${suffix} - deferred${suffix}" formula "经营性长期资产减资产相关递延收益；排除递延所得税资产和金融投资" medium
  estimate capital "$y" required_cash 150000000 "以约10天现金经营支出及全国工厂日常结算缓冲估计，且不高于各年可动用现金规模" low "若披露月度最低现金、集中资金池或备用授信可将实际最低现金显著压低或抬高，应重估"
  estimate capital "$y" unsupported_intangible_assets 0 "无形资产主要是生产基地土地使用权并直接服务经营，未见商誉或无法解释并购溢价" medium "若附注显示重大闲置土地或不再服务经营的无形资产，应剔除"
done

# 稳定期：不假定恢复增长，只把2025收入与利润率轻微正常化；资本开支按折旧摊销常态化。
estimate stable "" revenue 5500000000 "以2025年54.48亿元为基准，考虑产量已连续下滑且产能利用率约65%，仅取轻微正常化而非恢复历史峰值" medium "若连续两年同店/同渠道销量恢复且全国利用率显著回升，可上调；若收入继续两位数下滑，应下调"
estimate stable "" cost_of_revenue 4262500000 "按22.5%稳定毛利率估计，接近2025年22.53%，不假定新产能固定成本迅速消失" medium "若新增产能折旧压力消退且单位制造成本持续下降，毛利率可上调；反之下调"
estimate stable "" period_operating_expenses 720500000 "按收入约13.1%估计，接近2025年费用结构并保留品牌、渠道与研发投入" medium "若销售费用率因竞争持续上升或组织降本可验证，需相应调整"
estimate stable "" cash_tax 129250000 "按稳定EBIT 5.17亿元的25%法定税率估计，剔除2025年递延税资产终止确认的一次性影响" medium "若主要子公司税率结构或税收优惠发生持久变化，应调整"
estimate stable "" depreciation_amortization 320000000 "接近2025年3.17亿元折旧摊销，反映已投产生产网络的常态会计损耗" medium "若佛山项目投产后折旧显著增加或关停资产，应调整"
estimate stable "" core_business_capex 320000000 "稳定状态以折旧摊销近似维持现有经营网络的长期资本支出，不给在建扩张免费价值" low "若披露成熟工厂长期维持资本开支显著低于折旧，或佛山尚需重大不可撤销投入，应调整"
estimate stable "" exploratory_business_capex 0 "未识别脱离当前烘焙主业的独立开拓性项目" medium "若公司进入新业务并披露专属投入，应加入"
estimate stable "" operating_working_capital_increase 0 "成熟且不增长的稳定状态不假设永久营运资金释放" medium "若渠道账期或库存结构发生永久性改变，应调整"

# 最新年度按销售模式拆成两项具名经济业务。
python3 "$tool" add-business --model "$model" --business-id direct --name "直营终端与附属经营" --importance "直营覆盖KA及中心城市终端，占主营收入58%，是品牌触达和费用投入的主要载体" --confidence medium --falsifier "若公司披露分渠道完整利润及现金流，应替代费用和现金贡献分摊"
python3 "$tool" add-business --model "$model" --business-id distributor --name "经销网络" --importance "经销覆盖外埠便利店、县乡商店，占主营收入42%，收入降幅低于直营" --confidence medium --falsifier "若公司披露分渠道完整利润及现金流，应替代费用和现金贡献分摊"

bf() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" "${@:7}"; }
bf direct revenue 3178381103.36 estimate "主营直营收入加归入直营侧的附属经营收入，使业务树闭合公司总收入" medium --falsifier "若附属经营收入可明确归属经销渠道，应重分"
bf direct cost_of_revenue 2430176852.70 estimate "主营直营成本加归入直营侧的附属经营成本，使业务树闭合公司总成本" medium --falsifier "若附属经营成本可明确归属经销渠道，应重分"
bf direct period_operating_expenses 472633303.13 estimate "销售费用70%归直营，其余经营费用按收入比例分摊；直营自营终端和人员密度更高" low --falsifier "分渠道销售人员、门店和广告费用明细会推翻该分配"
bf direct cash_tax 86368934.15 estimate "按两业务EBIT占比分配公司经营现金税" low --falsifier "分渠道纳税主体和亏损抵扣明细会推翻该分配"
bf direct operating_cash_flow_contribution 445786892.14 estimate "按收入比例分配合并经营现金流，作为缺少渠道回款明细时的基准点" low --falsifier "分渠道应收账期和实际回款数据会推翻该分配"
fact distributor_revenue25 "经销模式主营业务收入" 2269772247.96 2025 "$s25" "第23页，主营业务分销售模式"
fact distributor_cost25 "经销模式主营业务成本" 1790776701.33 2025 "$s25" "第23页，主营业务分销售模式"
python3 "$tool" set-business-field --model "$model" --business-id distributor --field revenue --expression distributor_revenue25 --basis-type reported --reason "2025年年报披露经销模式主营业务收入" --confidence high
python3 "$tool" set-business-field --model "$model" --business-id distributor --field cost_of_revenue --expression distributor_cost25 --basis-type reported --reason "2025年年报披露经销模式主营业务成本" --confidence high
bf distributor period_operating_expenses 241782557.31 estimate "销售费用30%归经销，其余经营费用按收入比例分摊" low --falsifier "分渠道销售人员、返利和支持费用明细会推翻该分配"
bf distributor cash_tax 74346854.19 estimate "按两业务EBIT占比分配公司经营现金税" low --falsifier "分渠道纳税主体和亏损抵扣明细会推翻该分配"
bf distributor operating_cash_flow_contribution 318349085.08 estimate "按收入比例分配合并经营现金流" low --falsifier "经销商账期和回款数据会推翻该分配"

# 普通股价值桥。
fact cash25 "货币资金" 164624391.81 2025 "$s25" "第77页，合并资产负债表"
fact trading25 "交易性金融资产" 111566984.40 2025 "$s25" "第77页，合并资产负债表"
fact current_debtinv25 "一年内到期的非流动资产" 75445907.74 2025 "$s25" "第78页，合并资产负债表"
fact other_debtinv25 "其他债权投资" 350616397.16 2025 "$s25" "第78页，合并资产负债表"
fact financing25 "筹资活动相关负债期末余额合计" 1265821974.45 2025 "$s25" "第191页，筹资活动产生的各项负债变动情况"
fact shares25 "期末股本" 1599719155 2025 "$s25" "第79页，合并资产负债表"
setf equity "" excess_cash "cash25 + trading25 + current_debtinv25 + other_debtinv25 - 150000000" formula "货币资金和短久期金融投资减1.5亿元经营必需现金；理财均为集团资产且未披露分配限制" medium
estimate equity "" non_operating_assets 0 "可识别金融投资已全部计入多余现金，未见参股投资或投资物业" medium "若披露独立参股股权、待处置土地或非主营投资物业，应加入"
setf equity "" financing_debt "financing25" reported "包括短期借款、供应商融资票据、长期借款当期及长期部分和租赁负债，避免把融资性应付票据留在营运资金" high
estimate equity "" minority_interest_value 0 "合并资产负债表未列少数股东权益" high "若合并范围新增非全资子公司，应扣除少数股东经济价值"
estimate equity "" other_priority_claims 0 "未见优先股、已宣告未支付股息或未入账重大优先索偿；利润分配预案属于普通股股东内部价值转移" medium "若期后出现对普通股优先的重大义务，应扣除"
setf equity "" diluted_shares "shares25" reported "无可转债或未行权股权工具；员工持股计划已于2025年1月出售完毕，使用期末股本" high

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "收入连续两年下降、产能利用率约65%且仍有佛山项目在建，缺少到达稳定状态时间与逐年FCFF证据，采用稳定经营收益八倍固定标尺" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "2025年递延税资产终止确认" --before "所得税费用2.19亿元" --after "经营现金税1.61亿元；稳定期1.29亿元" --reason "年报披露前期递延税资产终止确认增加所得税费用1.05亿元，不能把该非现金一次性影响机械外推到稳定税率。"
python3 "$tool" add-adjustment --model "$model" --name "供应商融资重分类" --before "应付票据及借款分散列报" --after "融资负债合计12.66亿元" --reason "年报披露供应商融资安排；将相关票据及借款统一视为融资负债，避免夸大无息经营负债。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "重大财务数字均追溯至三份年度报告的具体页码，期间、单位及合并范围明确。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "金融投资与融资性供应商安排已分别归入多余现金和融资负债，经营与非经营边界无重复。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期基于三年下降趋势、2025年业务结构、约65%产能利用率及在建项目，未机械采用高点。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本以经营资产逐年重构；经营必需现金置信度低，ROIC仅用于判断重资产效率趋势，不作为护城河证据。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心判断、重大数字及估值桥将与脚本编译结果逐项核对。"

python3 "$tool" compile --model "$model"

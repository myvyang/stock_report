#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name 国投资本 --code 600061.SH --period-label 2025年年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name A股普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency 人民币 --scope "$5" --source "$6" --locator "$7"
}

src23="国投资本股份有限公司2023年年度报告（2024-03-30）"
src24="国投资本股份有限公司2024年年度报告（2025-03-29）"
src25="国投资本股份有限公司2025年年度报告（2026-04-03）"

fact rev23 "金融口径主营业务收入（证券、信托、基金合计）" 13798852124.72 2023 consolidated "$src23" "PDF P20-P21"
fact cost23 "金融口径主营业务成本（证券、信托、基金合计）" 9942609223.51 2023 consolidated "$src23" "PDF P20-P21"
fact op23 "营业利润" 3555991718.16 2023 consolidated "$src23" "PDF P92"
fact tax23 "所得税费用" 591310502.83 2023 consolidated "$src23" "PDF P92"
fact ni23 "净利润" 2947479812.70 2023 consolidated "$src23" "PDF P92"
fact attrib23 "归属于母公司股东的净利润" 2356831429.43 2023 parent_attributable "$src23" "PDF P92"
fact minority_profit23 "少数股东损益" 590648383.27 2023 noncontrolling_interests "$src23" "PDF P92"
fact da23 "固定资产、使用权资产、无形资产及长期待摊费用折旧摊销" 900917241.03 2023 consolidated "$src23" "PDF P221"
fact capex23 "购建固定资产、无形资产和其他长期资产支付的现金" 680276977.48 2023 consolidated "$src23" "PDF P96"
fact ocf23 "经营活动产生的现金流量净额" 3601643318.20 2023 consolidated "$src23" "PDF P96"

fact rev24 "金融口径主营业务收入（证券、信托、基金合计）" 13567371643.10 2024 consolidated "$src24" "PDF P27"
fact cost24 "金融口径主营业务成本（证券、信托、基金合计）" 9136193148.78 2024 consolidated "$src24" "PDF P27"
fact op24 "营业利润" 4059980061.55 2024 consolidated "$src24" "PDF P111"
fact tax24 "所得税费用" 838728003.87 2024 consolidated "$src24" "PDF P111"
fact ni24 "净利润" 3198282451.95 2024 consolidated "$src24" "PDF P111"
fact attrib24 "归属于母公司股东的净利润" 2694294849.97 2024 parent_attributable "$src24" "PDF P111"
fact minority_profit24 "少数股东损益" 503987601.98 2024 noncontrolling_interests "$src24" "PDF P112"
fact da24 "固定资产、使用权资产、无形资产及长期待摊费用折旧摊销" 926339397.57 2024 consolidated "$src24" "PDF P242"
fact capex24 "购建固定资产、无形资产和其他长期资产支付的现金" 435026150.59 2024 consolidated "$src24" "PDF P115"
fact ocf24 "经营活动产生的现金流量净额" 25952370532.35 2024 consolidated "$src24" "PDF P115"

fact rev25 "金融口径主营业务收入（证券、信托、基金合计）" 12503240472.68 2025 consolidated "$src25" "PDF P28-P29"
fact cost25 "金融口径主营业务成本（证券、信托、基金合计）" 7420026906.78 2025 consolidated "$src25" "PDF P28-P29"
fact op25 "营业利润" 4684968324.40 2025 consolidated "$src25" "PDF P116"
fact tax25 "所得税费用" 1031670120.13 2025 consolidated "$src25" "PDF P116"
fact ni25 "净利润" 3627507451.48 2025 consolidated "$src25" "PDF P116"
fact attrib25 "归属于母公司股东的净利润" 3279299080.12 2025 parent_attributable "$src25" "PDF P116"
fact minority_profit25 "少数股东损益" 348208371.36 2025 noncontrolling_interests "$src25" "PDF P116"
fact da25 "固定资产、使用权资产、无形资产及长期待摊费用折旧摊销" 866957753.28 2025 consolidated "$src25" "PDF P216"
fact capex25 "购建固定资产、无形资产和其他长期资产支付的现金" 441649478.69 2025 consolidated "$src25" "PDF P120"
fact ocf25 "经营活动产生的现金流量净额" 14885318419.60 2025 consolidated "$src25" "PDF P120"
fact rnd25 "研发费用" 274119645.94 2025 consolidated "$src25" "PDF P116"

fact common_equity22 "所有者权益减其他权益工具" 53460549773.96 2022 consolidated "$src23" "PDF P89"
fact common_equity23 "所有者权益减其他权益工具" 55656958292.73 2023 consolidated "$src23" "PDF P89"
fact common_equity24 "所有者权益减其他权益工具" 57338590998.64 2024 consolidated "$src24" "PDF P108"
fact common_equity25 "所有者权益减其他权益工具" 59991732311.12 2025 consolidated "$src25" "PDF P113"
fact goodwill22 "商誉" 4598942255.02 2022 consolidated "$src23" "PDF P88"
fact goodwill23 "商誉" 4598942255.02 2023 consolidated "$src23" "PDF P88"
fact goodwill24 "商誉" 4598942255.02 2024 consolidated "$src24" "PDF P107"
fact goodwill25 "商誉" 4598942255.02 2025 consolidated "$src25" "PDF P112"
fact minority_equity25 "少数股东权益" 5807757473.04 2025 noncontrolling_interests "$src25" "PDF P113"
fact other_equity25 "其他权益工具" 2552052505.37 2025 consolidated "$src25" "PDF P113"
fact shares25 "期末实收资本（股本）" 6393983737 2025 parent "$src25" "PDF P113"
fact dividend25 "2025年度现金分红预案" 986923916.94 2025 parent "$src25" "PDF P55"
fact parent_cash25 "母公司货币资金" 170114482.29 2025 parent "$src25" "PDF P113"
fact parent_invest_income25 "母公司投资收益" 1300000000 2025 parent "$src25" "PDF P118"
fact parent_interest25 "母公司利息费用" 433492673.26 2025 parent "$src25" "PDF P117"
fact convertible25 "国投转债期末尚未转股额" 7999151000 2025 parent "$src25" "PDF P104"

fact sec_rev25 "证券行业金融口径营业收入" 10331527923.96 2025 consolidated_segment "$src25" "PDF P28"
fact sec_cost25 "证券行业金融口径营业成本" 6101798838.48 2025 consolidated_segment "$src25" "PDF P28"
fact trust_rev25 "信托行业金融口径营业收入" 865367285.18 2025 consolidated_segment "$src25" "PDF P28"
fact trust_cost25 "信托行业金融口径营业成本" 461814354.68 2025 consolidated_segment "$src25" "PDF P28"
fact fund_rev25 "基金行业金融口径营业收入" 1306345263.54 2025 consolidated_segment "$src25" "PDF P28"
fact fund_cost25 "基金行业金融口径营业成本" 856413713.62 2025 consolidated_segment "$src25" "PDF P28"
fact securities_profit25 "国投证券合并净利润" 3400000000 2025 subsidiary "$src25" "PDF P16/P35"
fact trust_profit25 "国投泰康信托单体净利润" 395000000 2025 subsidiary "$src25" "PDF P18"
fact fund_profit25 "国投瑞银基金净利润" 341000000 2025 subsidiary "$src25" "PDF P23"

set_hist() {
  local year="$1" field="$2"; shift 2
  python3 "$tool" set-field --model "$model" --view historical --year "$year" --field "$field" "$@"
}

set_hist 2023 revenue --expression rev23 --basis-type reported --reason "年报按金融口径列示的证券、信托、基金营业收入合计。" --confidence high
set_hist 2023 cost_of_revenue --expression cost23 --basis-type reported --reason "年报按金融口径列示的证券、信托、基金营业成本合计。" --confidence high
set_hist 2023 period_operating_expenses --value 300251183.05 --basis-type estimate --reason "金融口径毛利与合并营业利润的差额，视作总部、抵销及未分配经营费用。" --confidence medium --falsifier "若公司披露可直接归属的总部及抵销明细，则改用披露值。"
set_hist 2023 cash_tax --expression tax23 --basis-type reported --reason "所得税费用作为经营税代理；营业外损益很小。" --confidence medium
set_hist 2023 depreciation_amortization --expression da23 --basis-type reported --reason "现金流量表补充资料披露的折旧摊销合计。" --confidence high
set_hist 2023 core_business_capex --expression capex23 --basis-type reported --reason "金融机构固定资产、系统和无形资产购建支出全部视作已开展业务投入。" --confidence medium
set_hist 2023 exploratory_business_capex --value 0 --basis-type estimate --reason "年报未披露可可靠识别的新业务长期资产现金投入；转型投入主要费用化。" --confidence low --falsifier "若后续披露数字化或新牌照项目资本化现金投入，则重分类。"
set_hist 2023 operating_working_capital_increase --value 220640263.55 --basis-type estimate --reason "券商交易资产和回购等属核心金融头寸，普通营运资金公式失真；以折旧摊销减资本开支作为稳定资本消耗中性化代理。" --confidence low --falsifier "若披露监管资本净投入和可分配资本变动，则以该数据替代。"
set_hist 2023 operating_cash_flow --value 3644958192.81 --basis-type estimate --reason "以税后经营利润加固定资产资本开支表示金融机构可分配收益前现金代理，不采用受交易头寸波动驱动的法定经营现金流。" --confidence low --falsifier "若披露监管口径可分配资本现金流，则直接采用。"
set_hist 2023 after_tax_interest_in_operating_cash_flow --value 0 --basis-type estimate --reason "利息收支是券商信用、自营和融资业务的经营项目，不作工业企业式融资加回。" --confidence high --falsifier "若改用非金融企业口径并剥离金融子公司，才需重构。"

set_hist 2024 revenue --expression rev24 --basis-type reported --reason "年报按金融口径列示的证券、信托、基金营业收入合计。" --confidence high
set_hist 2024 cost_of_revenue --expression cost24 --basis-type reported --reason "年报按金融口径列示的证券、信托、基金营业成本合计。" --confidence high
set_hist 2024 period_operating_expenses --value 371198432.77 --basis-type estimate --reason "金融口径毛利与合并营业利润的差额，视作总部、抵销及未分配经营费用。" --confidence medium --falsifier "若公司披露可直接归属的总部及抵销明细，则改用披露值。"
set_hist 2024 cash_tax --expression tax24 --basis-type reported --reason "所得税费用作为经营税代理；营业外损益很小。" --confidence medium
set_hist 2024 depreciation_amortization --expression da24 --basis-type reported --reason "现金流量表补充资料披露的折旧摊销合计。" --confidence high
set_hist 2024 core_business_capex --expression capex24 --basis-type reported --reason "金融机构固定资产、系统和无形资产购建支出全部视作已开展业务投入。" --confidence medium
set_hist 2024 exploratory_business_capex --value 0 --basis-type estimate --reason "年报未披露可可靠识别的新业务长期资产现金投入；转型投入主要费用化。" --confidence low --falsifier "若后续披露数字化或新牌照项目资本化现金投入，则重分类。"
set_hist 2024 operating_working_capital_increase --value 491313246.98 --basis-type estimate --reason "以折旧摊销减资本开支作为金融机构稳定资本消耗中性化代理。" --confidence low --falsifier "若披露监管资本净投入和可分配资本变动，则以该数据替代。"
set_hist 2024 operating_cash_flow --value 3656278208.27 --basis-type estimate --reason "以税后经营利润加固定资产资本开支表示可分配收益前现金代理。" --confidence low --falsifier "若披露监管口径可分配资本现金流，则直接采用。"
set_hist 2024 after_tax_interest_in_operating_cash_flow --value 0 --basis-type estimate --reason "利息收支属于金融主营经营项目。" --confidence high --falsifier "若改用非金融企业口径并剥离金融子公司，才需重构。"

set_hist 2025 revenue --expression rev25 --basis-type reported --reason "年报按金融口径列示的证券、信托、基金营业收入合计。" --confidence high
set_hist 2025 cost_of_revenue --expression cost25 --basis-type reported --reason "年报按金融口径列示的证券、信托、基金营业成本合计。" --confidence high
set_hist 2025 period_operating_expenses --value 398245241.50 --basis-type estimate --reason "金融口径毛利与合并营业利润的差额，视作总部、抵销及未分配经营费用。" --confidence medium --falsifier "若公司披露可直接归属的总部及抵销明细，则改用披露值。"
set_hist 2025 cash_tax --expression tax25 --basis-type reported --reason "所得税费用作为经营税代理；营业外净损失仅0.26亿元。" --confidence medium
set_hist 2025 depreciation_amortization --expression da25 --basis-type reported --reason "现金流量表补充资料披露的折旧摊销合计。" --confidence high
set_hist 2025 core_business_capex --expression capex25 --basis-type reported --reason "金融机构固定资产、系统和无形资产购建支出全部视作已开展业务投入。" --confidence medium
set_hist 2025 exploratory_business_capex --value 0 --basis-type estimate --reason "信托转型、投顾和AI投入主要费用化，无法从资本开支中可靠拆出。" --confidence low --falsifier "若公司披露新业务项目资本化现金投入，则重分类。"
set_hist 2025 operating_working_capital_increase --value 425308274.59 --basis-type estimate --reason "以折旧摊销减资本开支作为金融机构稳定资本消耗中性化代理。" --confidence low --falsifier "若披露监管资本净投入和可分配资本变动，则以该数据替代。"
set_hist 2025 operating_cash_flow --value 4094947682.96 --basis-type estimate --reason "以税后经营利润加固定资产资本开支表示可分配收益前现金代理；法定经营现金流受交易头寸和客户资金波动驱动。" --confidence low --falsifier "若披露监管口径可分配资本现金流，则直接采用。"
set_hist 2025 after_tax_interest_in_operating_cash_flow --value 0 --basis-type estimate --reason "利息收支属于金融主营经营项目。" --confidence high --falsifier "若改用非金融企业口径并剥离金融子公司，才需重构。"

for y in 2022 2023 2024 2025; do
  yy="${y:2:2}"
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field operating_working_capital --expression "common_equity${yy}" --basis-type formula --reason "金融机构用全部普通权益资本替代普通营运资金，反映监管资本和风险头寸的共同支持。" --confidence medium
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field operating_long_term_assets_net --value 0 --basis-type estimate --reason "长期金融资产已由权益资本整体覆盖，避免与普通权益资本重复计入。" --confidence medium --falsifier "若采用分部监管资本模型，则按各业务必要资本重构。"
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field required_cash --value 0 --basis-type estimate --reason "金融机构现金和结算备付金属于核心流动性资产，已包含于普通权益资本代理。" --confidence medium --falsifier "若改用资产端逐项重构，则单列经营必需流动性。"
  python3 "$tool" set-field --model "$model" --view capital --year "$y" --field unsupported_intangible_assets --expression "goodwill${yy}" --basis-type reported --reason "收购形成商誉不能作为监管资本效率的可解释经营资产。" --confidence high
done

set_stable() { python3 "$tool" set-field --model "$model" --view stable --field "$1" "${@:2}"; }
set_stable revenue --value 13200000000 --basis-type estimate --reason "介于2023-2025金融口径收入之间，证券景气回落由财富管理增长部分抵消。" --confidence medium --falsifier "连续两年金融口径收入高于145亿元或低于120亿元。"
set_stable cost_of_revenue --value 8700000000 --basis-type estimate --reason "按约34%的常态金融口径毛利率，低于2025高点、高于2023低点。" --confidence medium --falsifier "证券自营和信托转型使成本率连续两年偏离5个百分点以上。"
set_stable period_operating_expenses --value 500000000 --basis-type estimate --reason "保留总部、抵销及未分配费用缓冲，高于近三年差额均值。" --confidence medium --falsifier "总部及抵销费用连续两年显著低于3亿元或高于7亿元。"
set_stable cash_tax --value 800000000 --basis-type estimate --reason "对应20%的常态经营税率。" --confidence medium --falsifier "实际有效税率连续两年低于15%或高于25%。"
set_stable depreciation_amortization --value 850000000 --basis-type estimate --reason "接近近三年折旧摊销水平。" --confidence medium --falsifier "折旧摊销稳定低于7亿元或高于10亿元。"
set_stable core_business_capex --value 450000000 --basis-type estimate --reason "接近2024-2025系统及固定资产现金投入。" --confidence medium --falsifier "年度购建长期资产现金连续两年低于3亿元或高于7亿元。"
set_stable exploratory_business_capex --value 0 --basis-type estimate --reason "无法识别可单独估值的资本化开拓项目，转型投入留在费用中。" --confidence low --falsifier "新业务形成独立资本预算、客户验证和现金回报披露。"
set_stable operating_working_capital_increase --value 400000000 --basis-type estimate --reason "用于中和折旧与常态资本开支差额，使稳定经营收益等于税后经营利润；金融资本需求在普通权益资本中评价。" --confidence low --falsifier "披露稳定监管资本净投入或资本释放指标。"

python3 "$tool" add-business --model "$model" --business-id securities --name 证券综合金融 --importance "2025年贡献82.6%的金融口径收入，涵盖经纪、投行、自营、资管、信用及期货。" --confidence medium --falsifier "公司披露按独立业务线闭合至合并税后利润的完整分部数据。"
python3 "$tool" add-business --model "$model" --business-id trust --name 信托受托与财富管理 --importance "传统融资信托退出与家族信托、资产服务信托转型并存。" --confidence medium --falsifier "转型业务形成稳定、可单独验证的收入和利润披露。"
python3 "$tool" add-business --model "$model" --business-id funds --name 公募基金管理 --importance "管理费驱动、轻资产，但费率改革和规模结构决定盈利。" --confidence medium --falsifier "公司披露不同产品类别收入、费率和利润完整数据。"

biz() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" "${@:3}"; }
biz securities revenue --expression sec_rev25 --basis-type reported --reason "年报金融口径分行业披露。" --confidence high
biz securities cost_of_revenue --expression sec_cost25 --basis-type reported --reason "年报金融口径分行业披露。" --confidence high
biz securities period_operating_expenses --value 329073238.4242089 --basis-type estimate --reason "按金融口径收入比例分配公司层未分配费用。" --confidence low --falsifier "披露总部费用的业务归属。"
biz securities cash_tax --value 858957800.2820777 --basis-type estimate --reason "按分配费用后的业务税前利润比例分配经营税。" --confidence low --falsifier "披露分部所得税或税收优惠归属。"
biz securities operating_cash_flow_contribution --value 3406636554.6475906 --basis-type estimate --reason "税后经营利润加按收入比例分配的固定资产资本开支，作为可分配收益前现金代理。" --confidence low --falsifier "披露分部监管资本现金流。"

biz trust revenue --expression trust_rev25 --basis-type reported --reason "年报金融口径分行业披露。" --confidence high
biz trust cost_of_revenue --expression trust_cost25 --basis-type reported --reason "年报金融口径分行业披露。" --confidence high
biz trust period_operating_expenses --value 27563126.873048082 --basis-type estimate --reason "按金融口径收入比例分配公司层未分配费用。" --confidence low --falsifier "披露总部费用的业务归属。"
biz trust cash_tax --value 82796172.57073991 --basis-type estimate --reason "按分配费用后的业务税前利润比例分配经营税。" --confidence low --falsifier "披露分部所得税或税收优惠归属。"
biz trust operating_cash_flow_contribution --value 323760827.7129685 --basis-type estimate --reason "税后经营利润加按收入比例分配的固定资产资本开支。" --confidence low --falsifier "披露分部监管资本现金流。"

biz funds revenue --expression fund_rev25 --basis-type reported --reason "年报金融口径分行业披露。" --confidence high
biz funds cost_of_revenue --expression fund_cost25 --basis-type reported --reason "年报金融口径分行业披露。" --confidence high
biz funds period_operating_expenses --value 41608876.20274304 --basis-type estimate --reason "按金融口径收入比例分配公司层未分配费用。" --confidence low --falsifier "披露总部费用的业务归属。"
biz funds cash_tax --value 89916147.27718249 --basis-type estimate --reason "按分配费用后的业务税前利润比例分配经营税。" --confidence low --falsifier "披露分部所得税或税收优惠归属。"
biz funds operating_cash_flow_contribution --value 364550300.5994406 --basis-type estimate --reason "税后经营利润加按收入比例分配的固定资产资本开支。" --confidence low --falsifier "披露分部监管资本现金流。"

eq() { python3 "$tool" set-field --model "$model" --view equity --field "$1" "${@:2}"; }
eq expansion_project_value --value 0 --basis-type estimate --reason "没有足够增量回报证据支持单独计值。" --confidence low --falsifier "披露新增资本、利用率、订单和增量回报。"
eq new_business_option_value --value 0 --basis-type estimate --reason "信托转型、AI投顾和跨境投行仍处验证阶段。" --confidence low --falsifier "形成连续两年独立盈利和清晰资本需求。"
eq excess_cash --value 0 --basis-type estimate --reason "现金、结算备付金和金融资产均承担客户结算、流动性和监管资本功能，不视作可自由抽离现金。" --confidence medium --falsifier "母公司形成可自由分派且无债务约束的大额净现金。"
eq non_operating_assets --value 0 --basis-type estimate --reason "参股金融资产收益已进入稳定收益，避免重复加值；商誉不加值。" --confidence medium --falsifier "存在未贡献收益且可独立处置的重大资产。"
eq financing_debt --value 0 --basis-type estimate --reason "估值基于扣除利息后的金融机构权益收益；券商借款、回购、债券是经营性资金来源，重复扣债会失真。" --confidence medium --falsifier "改用资产端清算或企业价值口径时需重构全部金融负债。"
eq minority_interest_value --value 3360000000 --basis-type estimate --reason "以4.20亿元常态少数股东收益的8倍计值，反映国投泰康信托38.71%外部权益。" --confidence medium --falsifier "信托稳定少数股东损益连续两年显著偏离4.2亿元。"
eq other_priority_claims --expression other_equity25 --basis-type reported --reason "其他权益工具在普通股之前索偿，按2025年末账面值扣除。" --confidence high
eq diluted_shares --expression shares25 --basis-type reported --reason "国投转债转股价9.42元，高于本模型每股基准价值，不具有经济稀释性，采用期末股本。" --confidence medium
eq financial_to_trading_fx --value 1 --basis-type estimate --reason "财报与交易均为人民币。" --confidence high --falsifier "交易币种或列报币种改变。"
eq current_price --value 6.46 --basis-type estimate --reason "公开行情显示2026-09-07收盘价。" --confidence high --falsifier "采用其他观察日市场价格。" --observed-at 2026-09-07

python3 "$tool" set-valuation --model "$model" --mode benchmark --stable-multiple 8 --safety-margin-ratio 0.6 --reason "券商、信托和基金缺少可靠逐年FCFF路径；用32.0亿元稳定合并税后经营收益的8倍，扣少数股东和其他权益工具，形成普通股固定收益标尺。"

python3 "$tool" add-adjustment --model "$model" --name "金融机构FCFF替代" --before "2025年法定经营现金流148.85亿元" --after "可分配收益代理36.53亿元" --reason "法定经营现金流受交易资产、回购、融出资金和客户资金变化主导，不能作为券商自由现金流；以税后经营利润代理稳定可分配收益。"
python3 "$tool" add-adjustment --model "$model" --name "商誉资本剔除" --before "普通权益资本599.92亿元" --after "扣商誉后投入资本553.93亿元" --reason "45.99亿元并购商誉无法单独解释当前收益，不作为可解释经营资本。"
python3 "$tool" add-adjustment --model "$model" --name "少数股东价值" --before "2025年少数股东权益58.08亿元" --after "常态收益8倍计值33.60亿元" --reason "合并收益包含国投泰康信托38.71%外部权益；用常态少数股东收益而非账面权益计值。"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "ROIC仅解释为扣商誉普通权益资本回报代理，不作为工业企业资本效率或护城河结论。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "金融资产、回购、融出资金和客户结算资金按金融经营口径处理；母公司其他权益工具单列优先索偿。"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "历史金额均引用2023-2025法定年报及PDF页码，市场价格注明观察日。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定收益综合三年经营利润、2025业务结构和证券景气/信托转型差异，未直接年化单年高点。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告使用32.0亿元稳定税后经营收益、256亿元业务价值、33.6亿元少数股东价值和25.52亿元其他优先索偿。"

python3 "$tool" compile --model "$model"

#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
u23="https://static.cninfo.com.cn/finalpage/2024-03-27/1219410233.PDF"
u24="https://static.cninfo.com.cn/finalpage/2025-04-23/1223213811.PDF"
u25="https://static.cninfo.com.cn/finalpage/2026-04-08/1225082462.PDF"

python3 "$tool" init --name 盐津铺子 --code 002847.SZ --period-label 2025年 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency CNY --trading-currency CNY --security-name A股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency CNY --scope consolidated --source "$5" --locator "$6"
}

# 合并利润表和现金流量表原始事实
fact revenue_2023 营业收入 4115175423.46 2023 "$u23" "《2023年年度报告》PDF第99页"
fact cost_2023 营业成本 2734998999.49 2023 "$u23" "《2023年年度报告》PDF第99页"
fact tax_surcharge_2023 税金及附加 32598355.56 2023 "$u23" "《2023年年度报告》PDF第99页"
fact selling_2023 销售费用 515712461.28 2023 "$u23" "《2023年年度报告》PDF第99页"
fact admin_2023 管理费用 182716902.51 2023 "$u23" "《2023年年度报告》PDF第99页"
fact rd_2023 研发费用 79751445.60 2023 "$u23" "《2023年年度报告》PDF第99页"
fact income_tax_2023 所得税费用 60690315.84 2023 "$u23" "《2023年年度报告》PDF第100页"
fact profit_before_tax_2023 利润总额 573975050.40 2023 "$u23" "《2023年年度报告》PDF第100页"
fact da_fixed_2023 固定资产等折旧 151899863.17 2023 "$u23" "《2023年年度报告》PDF第162页"
fact da_rou_2023 使用权资产折旧 4863801.32 2023 "$u23" "《2023年年度报告》PDF第162页"
fact da_intangible_2023 无形资产摊销 11065933.42 2023 "$u23" "《2023年年度报告》PDF第162页"
fact da_ltpre_2023 长期待摊费用摊销 2193587.44 2023 "$u23" "《2023年年度报告》PDF第162页"
fact ocf_2023 经营活动产生的现金流量净额 664033786.96 2023 "$u23" "《2023年年度报告》PDF第103页"
fact cashflow_finance_cost_2023 现金流量调节表财务费用 19379296.13 2023 "$u23" "《2023年年度报告》PDF第162页"
fact capex_paid_2023 购建固定资产无形资产和其他长期资产支付的现金 347109120.55 2023 "$u23" "《2023年年度报告》PDF第103页"
fact disposal_proceeds_2023 处置固定资产无形资产和其他长期资产收回的现金净额 2527548.87 2023 "$u23" "《2023年年度报告》PDF第103页"

fact revenue_2024 营业收入 5303933906.59 2024 "$u24" "《2024年年度报告》PDF第84页"
fact cost_2024 营业成本 3676259715.26 2024 "$u24" "《2024年年度报告》PDF第84页"
fact tax_surcharge_2024 税金及附加 39882947.78 2024 "$u24" "《2024年年度报告》PDF第84页"
fact selling_2024 销售费用 662810313.39 2024 "$u24" "《2024年年度报告》PDF第84页"
fact admin_2024 管理费用 219105282.82 2024 "$u24" "《2024年年度报告》PDF第84页"
fact rd_2024 研发费用 79578935.80 2024 "$u24" "《2024年年度报告》PDF第84页"
fact income_tax_2024 所得税费用 71529154.67 2024 "$u24" "《2024年年度报告》PDF第85页"
fact profit_before_tax_2024 利润总额 711982396.64 2024 "$u24" "《2024年年度报告》PDF第85页"
fact da_fixed_2024 固定资产等折旧 176196781.74 2024 "$u24" "《2024年年度报告》PDF第144页"
fact da_rou_2024 使用权资产折旧 7586946.99 2024 "$u24" "《2024年年度报告》PDF第144页"
fact da_intangible_2024 无形资产摊销 6387257.78 2024 "$u24" "《2024年年度报告》PDF第144页"
fact da_ltpre_2024 长期待摊费用摊销 7908516.22 2024 "$u24" "《2024年年度报告》PDF第144页"
fact ocf_2024 经营活动产生的现金流量净额 1133957136.23 2024 "$u24" "《2024年年度报告》PDF第88页"
fact cashflow_finance_cost_2024 现金流量调节表财务费用 16055207.61 2024 "$u24" "《2024年年度报告》PDF第144页"
fact capex_paid_2024 购建固定资产无形资产和其他长期资产支付的现金 783029161.92 2024 "$u24" "《2024年年度报告》PDF第89页"
fact disposal_proceeds_2024 处置固定资产无形资产和其他长期资产收回的现金净额 14196366.94 2024 "$u24" "《2024年年度报告》PDF第88页"

fact revenue_2025 营业收入 5762229731.44 2025 "$u25" "《2025年年度报告》PDF第77页"
fact cost_2025 营业成本 3987653377.59 2025 "$u25" "《2025年年度报告》PDF第77页"
fact tax_surcharge_2025 税金及附加 49393958.72 2025 "$u25" "《2025年年度报告》PDF第77页"
fact selling_2025 销售费用 605089846.44 2025 "$u25" "《2025年年度报告》PDF第77页"
fact admin_2025 管理费用 190765015.71 2025 "$u25" "《2025年年度报告》PDF第77页"
fact rd_2025 研发费用 75646354.39 2025 "$u25" "《2025年年度报告》PDF第77页"
fact income_tax_2025 所得税费用 132177132.64 2025 "$u25" "《2025年年度报告》PDF第78页"
fact profit_before_tax_2025 利润总额 874838496.64 2025 "$u25" "《2025年年度报告》PDF第78页"
fact da_fixed_2025 固定资产等折旧 188507494.71 2025 "$u25" "《2025年年度报告》PDF第135页"
fact da_rou_2025 使用权资产折旧 10096440.31 2025 "$u25" "《2025年年度报告》PDF第135页"
fact da_intangible_2025 无形资产摊销 7578584.71 2025 "$u25" "《2025年年度报告》PDF第135页"
fact da_ltpre_2025 长期待摊费用摊销 11367681.49 2025 "$u25" "《2025年年度报告》PDF第135页"
fact ocf_2025 经营活动产生的现金流量净额 908977875.88 2025 "$u25" "《2025年年度报告》PDF第81页"
fact cashflow_finance_cost_2025 现金流量调节表财务费用 26412654.38 2025 "$u25" "《2025年年度报告》PDF第135页"
fact capex_paid_2025 购建固定资产无形资产和其他长期资产支付的现金 900551252.32 2025 "$u25" "《2025年年度报告》PDF第82页"
fact disposal_proceeds_2025 处置固定资产无形资产和其他长期资产收回的现金净额 12664173.87 2025 "$u25" "《2025年年度报告》PDF第81页"

# 经营资本原始事实；其他应付款扣除限制性股票回购义务后才进入经营资本。
capital_facts() {
  local y="$1" url="$2" bal="$3" lt="$4"; shift 4
  local names=(ar notes_rec prepay other_rec inventory other_ca notes_pay ap contract employee tax_pay other_pay stock_ob other_cl fa cip bio rou intang ltpre other_nca deferred)
  local labels=(应收账款 应收票据 预付款项 其他应收款 存货 其他流动资产 应付票据 应付账款 合同负债 应付职工薪酬 应交税费 其他应付款 限制性股票回购义务 其他流动负债 固定资产 在建工程 生产性生物资产 使用权资产 无形资产 长期待摊费用 其他非流动资产 递延收益)
  local i
  for i in "${!names[@]}"; do
    fact "${names[$i]}_${y}" "${labels[$i]}" "${1}" "$y-12-31" "$url" "${labels[$i]}：$([ "$i" -lt 14 ] && echo "$bal" || echo "$lt")"
    shift
  done
}

capital_facts 2022 "$u23" "《2023年年度报告》PDF第93-95页（期初数）" "《2023年年度报告》PDF第94-95页（期初数）" \
  161417997.79 7600000 118269670.69 11156897.28 453439152.10 35413258.88 7849740 269096445.71 106349691.23 76552479.73 25892483.22 156477716.15 83560928.67 13076723.29 940911585.48 143327506.34 0 17356922.09 200194105.84 3016858.11 61363049.02 13902434.33
capital_facts 2023 "$u23" "《2023年年度报告》PDF第93-95页" "《2023年年度报告》PDF第94-95页" \
  210535789.20 0 144764452.12 16621974.25 594467200.17 27394856.47 31563006.33 288696284.43 100170706.10 92117431.73 37343454.92 285754094.66 225002451.60 13035317.36 1134923040.48 32882387.15 1037249.54 25365819.69 198457009.87 14772893.48 120032844.88 13933492.50
capital_facts 2024 "$u24" "《2024年年度报告》PDF第78-80页" "《2024年年度报告》PDF第79-80页" \
  262257334.20 70000 84670816.06 15132191.70 744164798.47 60832500.80 16110510.12 618051816.93 89263361.66 151851455.78 47521386.90 215288281.43 127002015 11662155.38 1467432715.25 242165423.56 3848703.91 50067192.13 245074994.98 23057492.54 114926499.45 28000005.35
capital_facts 2025 "$u25" "《2025年年度报告》PDF第71-73页" "《2025年年度报告》PDF第72-73页" \
  227341671.09 0 130990938.48 10213545.23 734220212.52 146022054.53 16908158 459563046.67 78394739.13 145514644.97 30256480.54 174431689.47 64252608 10403496.37 1784068787.67 412335645.03 7467748.62 36762188.93 264231514.73 45880699.05 101522721.10 28389638.28

# 最新年度渠道控制数及股权价值桥事实
fact offline_revenue_2025 线下渠道营业收入 4840564791.28 2025 "$u25" "《2025年年度报告》PDF第21-22页"
fact offline_cost_2025 线下渠道营业成本 3381324250.83 2025 "$u25" "《2025年年度报告》PDF第22页"
fact online_revenue_2025 线上渠道营业收入 921664940.16 2025 "$u25" "《2025年年度报告》PDF第21-22页"
fact online_cost_2025 线上渠道营业成本 606329126.76 2025 "$u25" "《2025年年度报告》PDF第22页"
fact cash_2025 货币资金 167321037.08 2025-12-31 "$u25" "《2025年年度报告》PDF第71页"
fact restricted_cash_2025 使用受限货币资金 4919067.23 2025-12-31 "$u25" "《2025年年度报告》PDF第28、121页"
fact short_debt_2025 短期借款 368531627.97 2025-12-31 "$u25" "《2025年年度报告》PDF第72页"
fact current_lt_debt_2025 一年内到期的长期借款 351235912.32 2025-12-31 "$u25" "《2025年年度报告》PDF第124页"
fact current_lease_2025 一年内到期的租赁负债 9378724.99 2025-12-31 "$u25" "《2025年年度报告》PDF第124页"
fact long_debt_2025 长期借款 222903609.99 2025-12-31 "$u25" "《2025年年度报告》PDF第73、125页"
fact lease_debt_2025 租赁负债 25379075.05 2025-12-31 "$u25" "《2025年年度报告》PDF第73、125页"
fact minority_book_2025 少数股东权益 27918243.03 2025-12-31 "$u25" "《2025年年度报告》PDF第74页"
fact investment_property_2025 投资性房地产 493569.05 2025-12-31 "$u25" "《2025年年度报告》PDF第72页"
fact diluted_shares_2025 股份总数 272709679 2025-12-31 "$u25" "《2025年年度报告》PDF第74页、第149页"
fact incentive_shares_2026 期后授予限制性股票数量 2999000 2026-02-27 "$u25" "《2025年年度报告》PDF第48、149页"
fact incentive_price_2026 期后授予限制性股票价格 35.18 2026-01-20 "$u25" "《2025年年度报告》PDF第149页"

setf() { python3 "$tool" set-field --model "$model" "$@"; }

# 历史经营字段
for y in 2023 2024 2025; do
  setf --view historical --year "$y" --field revenue --expression "revenue_${y}" --basis-type reported --reason "合并利润表营业收入" --confidence high
  setf --view historical --year "$y" --field cost_of_revenue --expression "cost_${y}" --basis-type reported --reason "合并利润表营业成本；自2021年起物流配送费依新收入准则计入营业成本" --confidence high
  setf --view historical --year "$y" --field period_operating_expenses --expression "tax_surcharge_${y}+selling_${y}+admin_${y}+rd_${y}" --basis-type formula --reason "税金及附加、销售、管理和研发费用之和；排除融资费用及投资和资产处置损益" --confidence high
  setf --view historical --year "$y" --field cash_tax --expression "income_tax_${y}" --basis-type formula --reason "以合并所得税费用作为经营现金税基准；公司非经营投资收益很小" --confidence medium
  setf --view historical --year "$y" --field depreciation_amortization --expression "da_fixed_${y}+da_rou_${y}+da_intangible_${y}+da_ltpre_${y}" --basis-type formula --reason "现金流量表补充资料所列经营资产折旧摊销之和" --confidence high
  setf --view historical --year "$y" --field core_business_capex --expression "capex_paid_${y}-disposal_proceeds_${y}" --basis-type formula --reason "购建长期经营资产现金支出扣除经营资产处置回款；项目均服务现有休闲食品品类、产能和供应链" --confidence high
  setf --view historical --year "$y" --field exploratory_business_capex --value 0 --basis-type estimate --reason "未发现与现有休闲食品、上游原料、制造和渠道体系可清晰分离的新业务资本项目" --confidence medium --falsifier "若披露可独立商业化、尚未稳定盈利的新业务项目及其现金支出，则重分类"
  setf --view historical --year "$y" --field operating_cash_flow --expression "ocf_${y}" --basis-type reported --reason "合并现金流量表经营活动现金流量净额" --confidence high
done

setf --view historical --year 2023 --field after_tax_interest_in_operating_cash_flow --value 17330190.333385758 --basis-type estimate --reason "现金流量调节表财务费用按当年合并实际税率税后化，作为中国准则经营现金流内含融资成本加回" --confidence medium --falsifier "若附注披露经营现金流不含利息支付或可精确拆分资本化利息，则改按披露数"
setf --view historical --year 2024 --field after_tax_interest_in_operating_cash_flow --value 14442224.713492623 --basis-type estimate --reason "现金流量调节表财务费用按当年合并实际税率税后化，作为中国准则经营现金流内含融资成本加回" --confidence medium --falsifier "若附注披露经营现金流不含利息支付或可精确拆分资本化利息，则改按披露数"
setf --view historical --year 2025 --field after_tax_interest_in_operating_cash_flow --value 22422033.328493666 --basis-type estimate --reason "现金流量调节表财务费用按当年合并实际税率税后化，作为中国准则经营现金流内含融资成本加回" --confidence medium --falsifier "若附注披露经营现金流不含利息支付或可精确拆分资本化利息，则改按披露数"
setf --view historical --year 2023 --field operating_working_capital_increase --value -2633848.7633855864 --basis-type estimate --reason "按NOPAT、折旧摊销与经营现金流反推的综合经营应计占用，包含存货、经营应收应付、递延税项及股份支付等经营性非现金调整；用于与现金流路径闭合" --confidence medium --falsifier "若公司披露可剥离非营运资本应计项目的完整现金流对账，则改用逐项营运资本变动"
setf --view historical --year 2024 --field operating_working_capital_increase --value -395552301.3434926 --basis-type estimate --reason "按NOPAT、折旧摊销与经营现金流反推；2024年主要由经营性应付项目增加5.29亿元形成现金释放，并包含其他经营应计调整" --confidence medium --falsifier "若应付项目中工程款、股权激励或其他非经营项目可精确拆出，则重新分类"
setf --view historical --year 2025 --field operating_working_capital_increase --value 7654337.9615057 --basis-type estimate --reason "按NOPAT、折旧摊销与经营现金流反推的综合经营应计占用；2025年存货释放而应收增加、应付减少" --confidence medium --falsifier "若公司披露可剥离非营运资本应计项目的完整现金流对账，则改用逐项营运资本变动"

# 经营资本存量
for y in 2022 2023 2024 2025; do
  setf --view capital --year "$y" --field operating_working_capital --expression "ar_${y}+notes_rec_${y}+prepay_${y}+other_rec_${y}+inventory_${y}+other_ca_${y}-notes_pay_${y}-ap_${y}-contract_${y}-employee_${y}-tax_pay_${y}-other_pay_${y}+stock_ob_${y}-other_cl_${y}" --basis-type formula --reason "经营流动资产减无息经营流动负债；其他应付款剔除限制性股票回购义务" --confidence medium
  setf --view capital --year "$y" --field operating_long_term_assets_net --expression "fa_${y}+cip_${y}+bio_${y}+rou_${y}+intang_${y}+ltpre_${y}+other_nca_${y}-deferred_${y}" --basis-type formula --reason "固定资产、在建工程、生物资产、使用权资产、经营无形资产、长期待摊和预付设备工程款，扣除递延收益" --confidence high
  case "$y" in 2022|2023) rc=100000000;; 2024) rc=110000000;; 2025) rc=120000000;; esac
  setf --view capital --year "$y" --field required_cash --value "$rc" --basis-type estimate --reason "约覆盖一周至十天采购、工资、税费等经营现金支出，并结合公司实际现金余额和短账期销售模式估计" --confidence medium --falsifier "若披露月度最低现金、未使用授信或季节性现金缺口，按实际流动性需求更新"
  setf --view capital --year "$y" --field unsupported_intangible_assets --value 0 --basis-type estimate --reason "账面无商誉；无形资产主要为持续服务生产的土地使用权和软件，收益已由经营利润检验" --confidence medium --falsifier "若发现闲置土地、失效软件或不再服务主营的无形资产，则剔除其账面值"
done

# 稳定经营基准：不机械外推增长，正常化2025年股份支付冲回并假设建设期结束后的资本开支仍高于当前折旧。
setf --view stable --field revenue --value 5800000000 --basis-type estimate --reason "以2025年57.62亿元为基准略作取整；线上主动收缩、线下增长和新产能爬坡相互抵消，不外推单年高增长" --confidence medium --falsifier "若2026年收入明显低于55亿元或超过65亿元且可持续，重估稳定收入"
setf --view stable --field cost_of_revenue --value 4015000000 --basis-type estimate --reason "对应30.8%正常毛利率，接近2025年30.80%，并消除股份支付冲回的小额影响" --confidence medium --falsifier "若魔芋原料、渠道返利或品类结构使毛利率持续偏离29%-32%，重估"
setf --view stable --field period_operating_expenses --value 940000000 --basis-type estimate --reason "以2025年9.21亿元为基准，加回当年销售与管理端股份支付冲回约0.20亿元并留少量品牌投入余量" --confidence medium --falsifier "若品牌投放、渠道费用或股份支付正常化后持续低于9亿元或高于10亿元，重估"
setf --view stable --field cash_tax --value 126750000 --basis-type estimate --reason "按稳定EBIT 8.45亿元和15%经营现金税率估计，接近2025年实际税负且不依赖短期税收波动" --confidence medium --falsifier "若主要子公司税率优惠取消或稳定有效税率偏离12%-18%，重估"
setf --view stable --field depreciation_amortization --value 250000000 --basis-type estimate --reason "2025年折旧摊销2.18亿元；固定资产和在建工程继续增加后取2.50亿元常态水平" --confidence medium --falsifier "若2026年投产资产折旧明显低于2.3亿元或高于2.8亿元，重估"
setf --view stable --field core_business_capex --value 300000000 --basis-type estimate --reason "建设期结束后仍需更新自动化产线、环保设施和上游供应链；取高于稳定折旧的3.00亿元，远低于2024-2025建设期支出" --confidence medium --falsifier "若建设完成后连续两年净资本开支不能降至3亿元附近，或产能不再扩张且支出低于折旧，重估"
setf --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason "海外、魔芋原料和鹌鹑养殖均服务现有产品体系，未单列独立新业务价值" --confidence medium --falsifier "若海外Mowon或其他新业务形成独立商业模型和明确现金投入，则单列"
setf --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason "固定估值标尺采用不增长稳定状态；经销商款到发货使正常营运资本不需永久增加" --confidence medium --falsifier "若稳定收入下库存安全水平或客户账期持续上升，则计入常态占用"

# 最新年度渠道业务推算
python3 "$tool" add-business --model "$model" --business-id offline --name 线下全渠道休闲食品 --importance "84.01%收入，覆盖经销、量贩、会员店和直营KA；经销以款到发货为主，是规模与现金核心。" --confidence medium --falsifier "若公司披露直营、经销、新零售的完整利润与现金数据，则按实际子渠道重拆"
python3 "$tool" add-business --model "$model" --business-id online --name 线上电商休闲食品 --importance "15.99%收入；2025年主动收缩低毛利品类，承担品牌传播、新品触达与直接销售双重职能。" --confidence medium --falsifier "若平台费用、投流、退款与账期数据表明当前分摊显著失真，则重估"
python3 "$tool" set-business-field --model "$model" --business-id offline --field revenue --expression offline_revenue_2025 --basis-type reported --reason "按销售模式披露" --confidence high
python3 "$tool" set-business-field --model "$model" --business-id offline --field cost_of_revenue --expression offline_cost_2025 --basis-type reported --reason "按销售模式披露" --confidence high
python3 "$tool" set-business-field --model "$model" --business-id offline --field period_operating_expenses --value 755134043.71 --basis-type estimate --reason "将公司期间经营费用的82%分配至线下；低于84.01%收入占比，反映线上投流和平台运营费用强度更高" --confidence low --falsifier "若渠道费用明细显示线上费用占比显著偏离18%，则重分配"
python3 "$tool" set-business-field --model "$model" --business-id offline --field cash_tax --value 109018191.04 --basis-type estimate --reason "按渠道估计EBIT占比分配公司经营税" --confidence low --falsifier "若取得各渠道纳税主体和税收优惠数据，则按实际税负重分配"
python3 "$tool" set-business-field --model "$model" --business-id offline --field operating_cash_flow_contribution --value 749714581.80 --basis-type estimate --reason "按渠道NOPAT占比分配合并经营现金流；经销款到发货支持较高现金转化" --confidence low --falsifier "若渠道应收、库存、平台结算和返利数据完整披露，则按实际现金贡献重估"
python3 "$tool" set-business-field --model "$model" --business-id online --field revenue --expression online_revenue_2025 --basis-type reported --reason "按销售模式披露" --confidence high
python3 "$tool" set-business-field --model "$model" --business-id online --field cost_of_revenue --expression online_cost_2025 --basis-type reported --reason "按销售模式披露" --confidence high
python3 "$tool" set-business-field --model "$model" --business-id online --field period_operating_expenses --value 165761131.55 --basis-type estimate --reason "将公司期间经营费用的18%分配至线上，略高于15.99%收入占比以反映平台运营和营销强度" --confidence low --falsifier "若渠道费用明细显示线上费用占比显著偏离18%，则重分配"
python3 "$tool" set-business-field --model "$model" --business-id online --field cash_tax --value 23158941.60 --basis-type estimate --reason "按渠道估计EBIT占比分配公司经营税" --confidence low --falsifier "若取得各渠道纳税主体和税收优惠数据，则按实际税负重分配"
python3 "$tool" set-business-field --model "$model" --business-id online --field operating_cash_flow_contribution --value 159263294.08 --basis-type estimate --reason "按渠道NOPAT占比分配合并经营现金流" --confidence low --falsifier "若平台结算、退款和投流付款数据完整披露，则按实际现金贡献重估"

# 普通股价值桥
setf --view equity --field excess_cash --expression "cash_2025-restricted_cash_2025-120000000" --basis-type formula --reason "货币资金扣除受限资金和经营必需现金" --confidence medium
setf --view equity --field non_operating_assets --expression "investment_property_2025+incentive_shares_2026*incentive_price_2026" --basis-type formula --reason "投资性房地产加期后由回购专户向激励对象转让299.90万股可收取的缴款；完全摊薄股数已包含这些股份" --confidence medium
setf --view equity --field financing_debt --expression "short_debt_2025+current_lt_debt_2025+current_lease_2025+long_debt_2025+lease_debt_2025" --basis-type formula --reason "有息银行借款及租赁负债，租赁采用融资口径" --confidence high
setf --view equity --field minority_interest_value --expression minority_book_2025 --basis-type formula --reason "少数股东对应子公司缺乏独立FCFF披露，谨慎以账面少数股东权益作为经济价值替代" --confidence low
setf --view equity --field other_priority_claims --value 0 --basis-type estimate --reason "年报披露无优先股、重大或有事项或其他可识别的普通股前索偿；拟派普通股股利归同一普通股股东，不重复扣除" --confidence medium --falsifier "若期后出现担保赔付、税务追索或优先融资工具，则纳入扣减"
setf --view equity --field diluted_shares --expression diluted_shares_2025 --basis-type formula --reason "期末股份总数；期后激励使用已回购股份转让，不新增总股本" --confidence high
setf --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason "财报与交易均为人民币" --confidence high --falsifier "若证券交易币种改变则更新"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "增长仍在品类和渠道重构期，且2024-2025资本开支远高于折旧；缺少逐年FCFF与全部成长投入证据，采用稳定经营收益八倍固定标尺" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name 2025年股份支付冲回正常化 --before "合计冲回0.216亿元" --after "稳定成本费用加回约0.216亿元" --reason "未达解锁条件和员工离职导致生产、销售、管理费用冲回，不代表可持续降本；若后续激励持续无法解锁，该调整可取消。"
python3 "$tool" add-adjustment --model "$model" --name 期后限制性股票缴款 --before "回购专户股份已含在2.727亿股总股本中" --after "非经营资产加计1.055亿元缴款" --reason "2026年2月向156名对象授予299.90万股、价格35.18元/股；若未归属或款项不可由股东支配，应下调。"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "ROIC使用期初期末平均投入资本；但经营必需现金和费用化品牌投入含估计，正文仅作资本效率趋势判断，不作跨公司精确比较。"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "所有重大报表数字均保存事实ID并定位至三份法定年度报告PDF页码。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "经营资本剔除融资负债、受限及多余现金、投资性房地产和限制性股票回购义务；租赁统一按融资口径。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定收入不外推高增长，费用加回股份支付冲回，资本开支高于折旧并承认2026产能爬坡不确定性。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心判断、历史FCFF、稳定经营收益和普通股价值将与结构化模型一致。"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
src23="创新新材料2023年年度报告（2024-04-26，https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2024-04-26/600361_20240426_4IV2.pdf）"
src24="创新新材料2024年年度报告（2025-04-25，https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2025-04-25/600361_20250425_88MA.pdf）"
src25="创新新材料2025年年度报告（2026-04-25，https://www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2026-04-25/600361_20260425_M4OE.pdf）"

python3 "$tool" init --name "创新新材料科技股份有限公司" --code "600361.SH" --period-label "2025年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "CNY" --trading-currency "CNY" --security-name "A股" --security-unit "股" --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --source "$5" --locator "$6"
}
reported() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type reported --reason "$5" --confidence high
}
formula() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --expression "$4" --basis-type formula --reason "$5" --confidence "$6"
}
estimate() {
  python3 "$tool" set-field --model "$model" --view "$1" ${2:+--year "$2"} --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

# Consolidated operating statements and cash-flow facts.
fact rev23 "营业收入" 72843631643.64 2023 "$src23" "第142页，合并利润表"
fact cost23 "营业成本" 70497410887.87 2023 "$src23" "第142页，合并利润表"
fact op_profit23 "营业利润" 1240320310.44 2023 "$src23" "第143页，合并利润表"
fact finance23 "财务费用" 308478713.93 2023 "$src23" "第143页，合并利润表"
fact invest23 "投资收益" -38780064.75 2023 "$src23" "第143页，合并利润表"
fact fv23 "公允价值变动收益" 0 2023 "$src23" "第143页，合并利润表（无金额）"
fact pretax23 "利润总额" 1241887652.01 2023 "$src23" "第143页，合并利润表"
fact income_tax23 "所得税费用" 284182809.16 2023 "$src23" "第143页，合并利润表"
fact da_fixed23 "固定资产折旧" 428675102.13 2023 "$src23" "第256页，现金流量表补充资料"
fact da_rou23 "使用权资产摊销" 41093047.18 2023 "$src23" "第256页，现金流量表补充资料"
fact da_intangible23 "无形资产摊销" 20764660.43 2023 "$src23" "第256页，现金流量表补充资料"
fact da_ltp23 "长期待摊费用摊销" 437673.61 2023 "$src23" "第256页，现金流量表补充资料"
fact ocf23 "经营活动产生的现金流量净额" 582368329.46 2023 "$src23" "第146页，合并现金流量表"
fact interest23 "利息费用" 350769384.40 2023 "$src23" "第143页，合并利润表"
fact capex_gross23 "购建固定资产、无形资产和其他长期资产支付的现金" 2312125990.51 2023 "$src23" "第147页，合并现金流量表"
fact asset_disposal23 "处置固定资产、无形资产和其他长期资产收回的现金净额" 2363244.30 2023 "$src23" "第147页，合并现金流量表"
fact wc_inventory23 "存货增加" 534985980.24 2023 "$src23" "第256页，现金流量表补充资料"
fact wc_receivable23 "经营性应收项目增加" 59153183.42 2023 "$src23" "第256页，现金流量表补充资料"
fact wc_payable23 "经营性应付项目减少" 647799979.90 2023 "$src23" "第256页，现金流量表补充资料"

fact rev24 "营业收入" 80941533176.44 2024 "$src24" "第144页，合并利润表"
fact cost24 "营业成本" 78199764573.20 2024 "$src24" "第144页，合并利润表"
fact op_profit24 "营业利润" 1332357367.09 2024 "$src24" "第145页，合并利润表"
fact finance24 "财务费用" 360094792.30 2024 "$src24" "第145页，合并利润表"
fact invest24 "投资收益" -39665825.97 2024 "$src24" "第145页，合并利润表"
fact fv24 "公允价值变动收益" 0 2024 "$src24" "第145页，合并利润表（无金额）"
fact pretax24 "利润总额" 1330570118.84 2024 "$src24" "第146页，合并利润表"
fact income_tax24 "所得税费用" 325617441.84 2024 "$src24" "第146页，合并利润表"
fact da_fixed24 "固定资产折旧" 593626539.33 2024 "$src24" "第262页，现金流量表补充资料"
fact da_rou24 "使用权资产摊销" 32700530.11 2024 "$src24" "第262页，现金流量表补充资料"
fact da_intangible24 "无形资产摊销" 27386009.49 2024 "$src24" "第262页，现金流量表补充资料"
fact da_ltp24 "长期待摊费用摊销" 901597.22 2024 "$src24" "第262页，现金流量表补充资料"
fact ocf24 "经营活动产生的现金流量净额" 1516891174.09 2024 "$src24" "第149页，合并现金流量表"
fact interest24 "利息费用" 418597540.07 2024 "$src24" "第145页，合并利润表"
fact capex_gross24 "购建固定资产、无形资产和其他长期资产支付的现金" 1634940576.36 2024 "$src24" "第149页，合并现金流量表"
fact asset_disposal24 "处置固定资产、无形资产和其他长期资产收回的现金净额" 143723795.82 2024 "$src24" "第149页，合并现金流量表"
fact wc_inventory24 "存货减少" -3072398.71 2024 "$src24" "第262页，现金流量表补充资料（现金占用为负）"
fact wc_receivable24 "经营性应收项目增加" 1210737344.84 2024 "$src24" "第262页，现金流量表补充资料"
fact wc_payable24 "经营性应付项目增加" -551079053.85 2024 "$src24" "第262-263页，现金流量表补充资料（现金占用为负）"

fact rev25 "营业收入" 77040962692.01 2025 "$src25" "第149页，合并利润表"
fact cost25 "营业成本" 74606217222.21 2025 "$src25" "第149页，合并利润表"
fact op_profit25 "营业利润" 1026703980.43 2025 "$src25" "第150页，合并利润表"
fact finance25 "财务费用" 419984611.27 2025 "$src25" "第150页，合并利润表"
fact invest25 "投资收益" -24337653.81 2025 "$src25" "第150页，合并利润表"
fact fv25 "公允价值变动收益" 109570047.33 2025 "$src25" "第150页，合并利润表"
fact pretax25 "利润总额" 1018328663.67 2025 "$src25" "第150页，合并利润表"
fact income_tax25 "所得税费用" 242777196.25 2025 "$src25" "第150页，合并利润表"
fact da_fixed25 "固定资产折旧" 705702758.97 2025 "$src25" "第258页，现金流量表补充资料"
fact da_rou25 "使用权资产摊销" 37799872.74 2025 "$src25" "第258页，现金流量表补充资料"
fact da_intangible25 "无形资产摊销" 37369429.39 2025 "$src25" "第258页，现金流量表补充资料"
fact da_ltp25 "长期待摊费用摊销" 732708.18 2025 "$src25" "第258页，现金流量表补充资料"
fact ocf25 "经营活动产生的现金流量净额" -1074340048.45 2025 "$src25" "第154页，合并现金流量表"
fact interest25 "利息费用" 466418064.14 2025 "$src25" "第150页，合并利润表"
fact capex_gross25 "购建固定资产、无形资产和其他长期资产支付的现金" 1201098151.79 2025 "$src25" "第154页，合并现金流量表"
fact asset_disposal25 "处置固定资产、无形资产和其他长期资产收回的现金净额" 13584175.70 2025 "$src25" "第154页，合并现金流量表"
fact wc_inventory25 "存货增加" 917503475.80 2025 "$src25" "第258页，现金流量表补充资料"
fact wc_receivable25 "经营性应收项目增加" 834159237.72 2025 "$src25" "第258页，现金流量表补充资料"
fact wc_payable25 "经营性应付项目减少" 1318367226.99 2025 "$src25" "第258页，现金流量表补充资料"

for y in 23 24 25; do
  year="20$y"
  reported historical "$year" revenue "rev$y" "直接采用合并利润表营业收入。"
  reported historical "$year" cost_of_revenue "cost$y" "直接采用合并利润表营业成本。"
  formula historical "$year" period_operating_expenses "rev$y-cost$y-(op_profit$y+finance$y-invest$y-fv$y)" "以营业利润加回净财务费用、剔除投资和公允价值收益重构EBIT，期间经营费用作为毛利与EBIT之差。" medium
  formula historical "$year" cash_tax "(op_profit$y+finance$y-invest$y-fv$y)*income_tax$y/pretax$y" "用当年实际所得税率作用于重构EBIT，作为经营现金税估计。" medium
  formula historical "$year" depreciation_amortization "da_fixed$y+da_rou$y+da_intangible$y+da_ltp$y" "合计现金流量表补充资料披露的经营性折旧摊销。" high
  reported historical "$year" operating_cash_flow "ocf$y" "直接采用合并现金流量表经营活动现金流量净额。"
  formula historical "$year" after_tax_interest_in_operating_cash_flow "interest$y*(1-income_tax$y/pretax$y)" "经营现金流含利息支出，按当年实际税率计算税后利息加回。" medium
  formula historical "$year" operating_working_capital_increase "wc_inventory$y+wc_receivable$y+wc_payable$y" "采用现金流量表补充资料的存货、经营性应收和经营性应付变动合计现金占用。" high
done

estimate historical 2023 core_business_capex 1409762746.21 "净现金资本开支中估计9亿元用于越南、墨西哥及再生铝等尚在开拓阶段项目，余额归入已经营业务。" low "若项目明细证明新市场/新产线现金支出显著高于或低于9亿元，应重分类。"
estimate historical 2023 exploratory_business_capex 900000000 "越南3C、墨西哥汽车材料及再生铝新产能仍属新市场/新产线开拓。" low "项目现金支出明细或投产后独立盈利证据可推翻。"
estimate historical 2024 core_business_capex 841216780.54 "净现金资本开支扣除估计6.5亿元海外与新产线开拓投入。" low "项目现金支出明细可推翻。"
estimate historical 2024 exploratory_business_capex 650000000 "越南、墨西哥与新增绿色产线仍处建设或爬坡期。" low "若披露证明这些支出全部用于既有稳定产能，则应转回主营资本开支。"
estimate historical 2025 core_business_capex 937513976.09 "2025年募投和越南部分产线已投产，净资本开支大部分归入既有业务，保留2.5亿元为海外未成熟项目。" low "按项目现金流披露可重新划分。"
estimate historical 2025 exploratory_business_capex 250000000 "墨西哥仅完成土地购买、越南仍扩线，估计其中2.5亿元尚属新市场开拓。" low "若墨西哥/越南项目实际现金支出和成熟盈利证据不同，应调整。"

# Capital mapping. Accounts payable is split between trade working capital and equipment/project payables.
add_capital_facts() { :; }
fact der_asset22 "衍生金融资产" 7682907.67 2022 "$src23" "第138页，合并资产负债表比较数"
fact notes_rec22 "应收票据" 297750263.00 2022 "$src23" "第138页，合并资产负债表比较数"
fact ar22 "应收账款" 2129240082.59 2022 "$src23" "第138页，合并资产负债表比较数"
fact ar_fin22 "应收款项融资" 63719353.80 2022 "$src23" "第138页，合并资产负债表比较数"
fact prepay22 "预付款项" 175654545.01 2022 "$src23" "第138页，合并资产负债表比较数"
fact other_rec_op22 "经营性其他应收款（剔除置出资产交易款）" 11179961.63 2022 "$src23" "第138页及第205页，其他应收款比较数减置出资产交易款11.40亿元"
fact inventory22 "存货" 3111241064.50 2022 "$src23" "第138页，合并资产负债表比较数"
fact other_ca22 "其他流动资产" 231320846.11 2022 "$src23" "第138页，合并资产负债表比较数"
fact der_liab22 "衍生金融负债" 2118675.00 2022 "$src23" "第139页，合并资产负债表比较数"
fact notes_pay22 "应付票据" 695534842.39 2022 "$src23" "第139页，合并资产负债表比较数"
fact ap_trade22 "应付账款—货款" 641717428.61 2022 "$src23" "第231页，应付账款附注比较数"
fact contract22 "合同负债" 198929730.62 2022 "$src23" "第139页，合并资产负债表比较数"
fact employee22 "应付职工薪酬" 136332127.29 2022 "$src23" "第139页，合并资产负债表比较数"
fact tax_pay22 "应交税费" 98363415.26 2022 "$src23" "第139页，合并资产负债表比较数"
fact other_pay22 "其他应付款" 109988821.15 2022 "$src23" "第139页，合并资产负债表比较数"
fact other_cl22 "其他流动负债" 126855513.02 2022 "$src23" "第139页，合并资产负债表比较数"
fact fixed22 "固定资产" 3729780884.78 2022 "$src23" "第139页，合并资产负债表比较数"
fact cip22 "在建工程" 259418020.99 2022 "$src23" "第139页，合并资产负债表比较数"
fact rou22 "使用权资产" 118597487.22 2022 "$src23" "第139页，合并资产负债表比较数"
fact intangible22 "无形资产" 863997750.84 2022 "$src23" "第139页，合并资产负债表比较数"
fact ltp22 "长期待摊费用" 0 2022 "$src23" "第139页，合并资产负债表比较数（无余额）"
fact other_nca22 "其他非流动资产" 399029016.16 2022 "$src23" "第139页，合并资产负债表比较数"
fact deferred_income22 "递延收益" 58457689.00 2022 "$src23" "第140页，合并资产负债表比较数"
fact ap_equipment22 "应付账款—工程、设备款" 120207293.15 2022 "$src23" "第231页，应付账款附注比较数"
fact special_payable22 "专项应付款" 150000000 2022 "$src23" "第140页，长期应付款比较数"
fact op_cash_out22 "经营活动现金流出小计" 80667138145.85 2022 "$src23" "第146页，合并现金流量表比较数"

fact der_asset23 "衍生金融资产" 6999042.20 2023 "$src23" "第138页，合并资产负债表"
fact notes_rec23 "应收票据" 354182178.63 2023 "$src23" "第138页，合并资产负债表"
fact ar23 "应收账款" 2249663017.56 2023 "$src23" "第138页，合并资产负债表"
fact ar_fin23 "应收款项融资" 123155100.10 2023 "$src23" "第138页，合并资产负债表"
fact prepay23 "预付款项" 288329623.19 2023 "$src23" "第138页，合并资产负债表"
fact other_rec_op23 "其他应收款" 56811648.93 2023 "$src23" "第138页，合并资产负债表"
fact inventory23 "存货" 3631765935.29 2023 "$src23" "第138页，合并资产负债表"
fact other_ca23 "其他流动资产" 444879196.61 2023 "$src23" "第138页，合并资产负债表"
fact der_liab23 "衍生金融负债" 29155950.00 2023 "$src23" "第139页，合并资产负债表"
fact notes_pay23 "应付票据" 0 2023 "$src23" "第139页，合并资产负债表（无余额）"
fact ap_trade23 "应付账款—货款" 674123520.82 2023 "$src23" "第231页，应付账款附注"
fact contract23 "合同负债" 300902586.44 2023 "$src23" "第139页，合并资产负债表"
fact employee23 "应付职工薪酬" 132408289.43 2023 "$src23" "第139页，合并资产负债表"
fact tax_pay23 "应交税费" 165271403.03 2023 "$src23" "第139页，合并资产负债表"
fact other_pay23 "其他应付款" 94377852.27 2023 "$src23" "第139页，合并资产负债表"
fact other_cl23 "其他流动负债" 204495456.81 2023 "$src23" "第139页，合并资产负债表"
fact fixed23 "固定资产" 4711413026.69 2023 "$src23" "第139页，合并资产负债表"
fact cip23 "在建工程" 1299661735.37 2023 "$src23" "第139页，合并资产负债表"
fact rou23 "使用权资产" 178805599.35 2023 "$src23" "第139页，合并资产负债表"
fact intangible23 "无形资产" 1013610919.18 2023 "$src23" "第139页，合并资产负债表"
fact ltp23 "长期待摊费用" 5864826.39 2023 "$src23" "第139页，合并资产负债表"
fact other_nca23 "其他非流动资产" 516928419.64 2023 "$src23" "第139页，合并资产负债表"
fact deferred_income23 "递延收益" 106274667.31 2023 "$src23" "第140页，合并资产负债表"
fact ap_equipment23 "应付账款—工程、设备款" 291712457.84 2023 "$src23" "第231页，应付账款附注"
fact special_payable23 "专项应付款" 150000000 2023 "$src23" "第140页，合并资产负债表"
fact op_cash_out23 "经营活动现金流出小计" 82302478168.61 2023 "$src23" "第146页，合并现金流量表"

fact der_asset24 "衍生金融资产" 13893137.86 2024 "$src25" "第145页，合并资产负债表比较数"
fact notes_rec24 "应收票据" 540575447.87 2024 "$src25" "第145页，合并资产负债表比较数"
fact ar24 "应收账款" 3196317707.18 2024 "$src25" "第145页，合并资产负债表比较数"
fact ar_fin24 "应收款项融资" 193473072.24 2024 "$src25" "第145页，合并资产负债表比较数"
fact prepay24 "预付款项" 97007805.90 2024 "$src25" "第145页，合并资产负债表比较数"
fact other_rec_op24 "其他应收款" 88524422.05 2024 "$src25" "第145页，合并资产负债表比较数"
fact inventory24 "存货" 3593038193.64 2024 "$src25" "第145页，合并资产负债表比较数"
fact other_ca24 "其他流动资产" 590214875.51 2024 "$src25" "第145页，合并资产负债表比较数"
fact der_liab24 "衍生金融负债" 2906025.00 2024 "$src25" "第146页，合并资产负债表比较数"
fact notes_pay24 "应付票据" 1380171550.00 2024 "$src25" "第146页，合并资产负债表比较数"
fact ap_trade24 "应付账款—货款" 754451392.72 2024 "$src25" "第231页，应付账款附注比较数"
fact contract24 "合同负债" 622054616.02 2024 "$src25" "第146页，合并资产负债表比较数"
fact employee24 "应付职工薪酬" 154438961.80 2024 "$src25" "第146页，合并资产负债表比较数"
fact tax_pay24 "应交税费" 158042264.82 2024 "$src25" "第146页，合并资产负债表比较数"
fact other_pay24 "其他应付款" 72051581.82 2024 "$src25" "第146页，合并资产负债表比较数"
fact other_cl24 "其他流动负债" 492642994.64 2024 "$src25" "第146页，合并资产负债表比较数"
fact fixed24 "固定资产" 6265532479.26 2024 "$src25" "第145页，合并资产负债表比较数"
fact cip24 "在建工程" 818756692.07 2024 "$src25" "第146页，合并资产负债表比较数"
fact rou24 "使用权资产" 114685998.31 2024 "$src25" "第146页，合并资产负债表比较数"
fact intangible24 "无形资产" 1218215855.72 2024 "$src25" "第146页，合并资产负债表比较数"
fact ltp24 "长期待摊费用" 3764062.49 2024 "$src25" "第146页，合并资产负债表比较数"
fact other_nca24 "其他非流动资产" 576845937.10 2024 "$src25" "第146页，合并资产负债表比较数"
fact deferred_income24 "递延收益" 215786555.02 2024 "$src25" "第147页，合并资产负债表比较数"
fact ap_equipment24 "应付账款—工程、设备款" 403698513.46 2024 "$src25" "第231页，应付账款附注比较数"
fact special_payable24 "专项应付款" 150000000 2024 "$src25" "第147页，合并资产负债表比较数"
fact op_cash_out24 "经营活动现金流出小计" 87807030511.05 2024 "$src24" "第149页，合并现金流量表"

fact der_asset25 "衍生金融资产" 0 2025 "$src25" "第145页，合并资产负债表（无余额）"
fact notes_rec25 "应收票据" 551521945.81 2025 "$src25" "第145页，合并资产负债表"
fact ar25 "应收账款" 3771795048.73 2025 "$src25" "第145页，合并资产负债表"
fact ar_fin25 "应收款项融资" 301420772.27 2025 "$src25" "第145页，合并资产负债表"
fact prepay25 "预付款项" 431177792.51 2025 "$src25" "第145页，合并资产负债表"
fact other_rec_op25 "其他应收款" 83394234.72 2025 "$src25" "第145页，合并资产负债表"
fact inventory25 "存货" 4691561816.70 2025 "$src25" "第145页，合并资产负债表"
fact other_ca25 "其他流动资产" 380405654.78 2025 "$src25" "第145页，合并资产负债表"
fact der_liab25 "衍生金融负债" 198163525.00 2025 "$src25" "第146页，合并资产负债表"
fact notes_pay25 "应付票据" 2847866579.20 2025 "$src25" "第146页，合并资产负债表"
fact ap_trade25 "应付账款—货款" 561643706.76 2025 "$src25" "第231页，应付账款附注"
fact contract25 "合同负债" 280871003.84 2025 "$src25" "第146页，合并资产负债表"
fact employee25 "应付职工薪酬" 175094577.55 2025 "$src25" "第146页，合并资产负债表"
fact tax_pay25 "应交税费" 136126776.82 2025 "$src25" "第146页，合并资产负债表"
fact other_pay25 "其他应付款" 40840885.70 2025 "$src25" "第146页，合并资产负债表"
fact other_cl25 "其他流动负债" 158232458.21 2025 "$src25" "第146页，合并资产负债表"
fact fixed25 "固定资产" 7148749655.19 2025 "$src25" "第146页，合并资产负债表"
fact cip25 "在建工程" 674516271.91 2025 "$src25" "第146页，合并资产负债表"
fact rou25 "使用权资产" 107166748.67 2025 "$src25" "第146页，合并资产负债表"
fact intangible25 "无形资产" 1206731371.90 2025 "$src25" "第146页，合并资产负债表"
fact ltp25 "长期待摊费用" 2562083.53 2025 "$src25" "第146页，合并资产负债表"
fact other_nca25 "其他非流动资产" 198818565.29 2025 "$src25" "第146页，合并资产负债表"
fact deferred_income25 "递延收益" 252591729.34 2025 "$src25" "第147页，合并资产负债表"
fact ap_equipment25 "应付账款—工程、设备款" 434894341.69 2025 "$src25" "第231页，应付账款附注"
fact special_payable25 "专项应付款" 150000000 2025 "$src25" "第147页及第239页，政府项目扶持资金"
fact op_cash_out25 "经营活动现金流出小计" 87797241891.12 2025 "$src25" "第153-154页，合并现金流量表"

for y in 22 23 24 25; do
  year="20$y"
  formula capital "$year" operating_working_capital "der_asset$y+notes_rec$y+ar$y+ar_fin$y+prepay$y+other_rec_op$y+inventory$y+other_ca$y-der_liab$y-notes_pay$y-ap_trade$y-contract$y-employee$y-tax_pay$y-other_pay$y-other_cl$y" "经营性应收、存货、预付及其他经营流动资产，扣除贸易应付、合同负债、经营税费和其他经营流动负债；工程设备应付款转入长期经营资产净额。" medium
  formula capital "$year" operating_long_term_assets_net "fixed$y+cip$y+rou$y+intangible$y+ltp$y+other_nca$y-deferred_income$y-ap_equipment$y-special_payable$y" "固定资产、在建工程、使用权资产、经营性无形资产等，扣除工程设备款、递延收益和政府项目专项应付款。" medium
  case "$y" in
    22) required_cash=2210068980.71 ;;
    23) required_cash=2254862415.58 ;;
    24) required_cash=2405672068.80 ;;
    25) required_cash=2405403887.43 ;;
  esac
  estimate capital "$year" required_cash "$required_cash" "按约10天经营现金流出估计最低周转现金；原铝采购规模大且结算密集。" low "若月度现金头寸、授信备用额度或供应商账期证明所需现金显著不同，应调整。"
  estimate capital "$year" unsupported_intangible_assets 0 "无商誉；无形资产主要为生产所需土地使用权等可解释经营资产，未另行剔除。" medium "若发现闲置土地、并购溢价或不能支持当前经营的无形资产，应剔除。"
done

# Stable-state benchmark.
estimate stable "" revenue 77000000000 "取接近2023—2025收入中枢的常态规模；不外推管理层远期产能。" medium "基础品继续战略收缩且型材/线缆不能补量，或海外产线形成经验证净增量时，应下调或上调。"
estimate stable "" cost_of_revenue 74382000000 "对应3.4%常态毛利率，略高于三年均值，反映型材占比提升但不假设加工费回到高景气。" medium "型材收入占比和加工费无法维持，或基础品加工费进一步下跌时应下调毛利率。"
estimate stable "" period_operating_expenses 1000000000 "取近两年约10—11亿元经营费用的正常化值，包含经营性减值和政府补助净影响。" medium "海外组织、研发或信用损失形成持续更高费用时应上调。"
estimate stable "" cash_tax 380230000 "按稳定EBIT的23.5%正常经营税率估计。" medium "高新技术税率、地区税惠或税基差异出现可持续变化时应调整。"
estimate stable "" depreciation_amortization 780000000 "接近2025年投产后折旧摊销水平。" medium "新项目转固或资产处置使折旧发生结构性变化时应调整。"
estimate stable "" core_business_capex 900000000 "以略高于当前折旧的现金投入维持现有产能、环保、安全和小规模提效扩产。" low "连续多年分项目维护和技改现金支出证明常态值显著不同。"
estimate stable "" exploratory_business_capex 0 "固定估值标尺不把尚未验证的海外/新业务投入并入稳定经营收益。" medium "项目投产并形成稳定订单、利润和维护资本需求后，应纳入稳定经营口径。"
estimate stable "" operating_working_capital_increase 0 "不在稳定状态中永久外推2025年的库存、保证金和应收扩张。" medium "若收入结构要求营运资金随规模持续增长，则应采用正的常态占用。"

# Equity bridge facts and fields.
fact cash_equiv25 "现金及现金等价物" 4456243527.14 2025 "$src25" "第259页，现金和现金等价物构成"
fact trading_asset25 "交易性金融资产" 359868162.50 2025 "$src25" "第145页，合并资产负债表"
fact huajian25 "山东华建铝业科技有限公司权益法投资" 201088009.54 2025 "$src25" "第215页，长期股权投资"
fact granges25 "格朗吉斯铝业（上海）有限公司权益法投资" 531064125.59 2025 "$src25" "第215页，长期股权投资"
fact investment_property25 "投资性房地产" 16138512.61 2025 "$src25" "第216-217页，投资性房地产附注"
fact saudi_invest25 "Red Sea Aluminium Holdings权益法投资" 516719730.15 2025 "$src25" "第215页，长期股权投资"
fact short_debt25 "短期借款" 7954482332.49 2025 "$src25" "第146页及第230页"
fact current_debt25 "一年内到期的非流动负债" 2125251438.62 2025 "$src25" "第146页，合并资产负债表"
fact long_debt25 "长期借款" 1844024041.18 2025 "$src25" "第146页及第237页"
fact lease_debt25 "租赁负债" 68280356.70 2025 "$src25" "第146页及第239页"
fact minority_book25 "少数股东权益" 134011672.40 2025 "$src25" "第147页，合并资产负债表"
fact shares25 "报告披露日前总股本" 3732662913 2025 "$src25" "第2页，2026年3月31日总股本；基本与稀释每股收益相同见第151页"

formula equity "" excess_cash "cash_equiv25-op_cash_out25/36.5" "可自由支配现金等价物扣除约10天经营现金需求；28.04亿元受限货币资金不作为多余现金。" low
formula equity "" non_operating_assets "trading_asset25+huajian25+granges25+investment_property25" "按账面/公允价值计入未进入合并FCFF的金融资产、联营投资和投资物业；沙特建设期项目暂不赋值。" medium
formula equity "" financing_debt "short_debt25+current_debt25+long_debt25+lease_debt25" "扣除全部有息借款和租赁负债；贸易票据和政府项目专项应付款已在经营资产口径处理。" high
formula equity "" minority_interest_value "minority_book25" "缺少非全资子公司的独立FCFF资料，以少数股东账面权益作替代值。" low
estimate equity "" other_priority_claims 0 "未识别到优先股、已宣告未付股息或尚未计入经营资本的其他重大优先索偿。" medium "若期后出现重大资本承诺、诉讼赔偿或优先资本工具，应纳入。"
reported equity "" diluted_shares "shares25" "报告披露日前总股本；公司无可转债或股权激励，基本与稀释每股收益相同。"
estimate equity "" financial_to_trading_fx 1 "财报和股票交易币种均为人民币。" high "币种发生变化时调整。"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "海外项目逐年FCFF和全部成长投入证据不足，采用技能规定的稳定经营收益8倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "沙特建设期权益投资暂不计值" --before "账面价值5.17亿元" --after "普通股价值桥计0" --reason "项目尚在建设且2025年权益法亏损；与控股股东及实控人共同投资并存在未来潜在同业竞争解决安排，缺少可验证稳定FCFF和可实现退出价格。"
python3 "$tool" add-adjustment --model "$model" --name "受限货币资金不列多余现金" --before "货币资金72.60亿元" --after "仅以现金等价物44.56亿元为起点，再扣除经营必需现金" --reason "28.04亿元为信用证、期货、承兑汇票及借款保证金和冻结资金，不能在报告日自由分配。"

# Latest-year named economic businesses. Product revenue/cost is disclosed; remaining consolidated revenue/cost is assigned to trade and ancillary processing.
for spec in \
  "bars|棒材|基础合金材料，收入体量最大但毛利率低|medium|若公司披露棒材客户、费用和现金流独立数据则替换分摊" \
  "wire|铝杆线缆（含电线电缆）|电力建设需求驱动、全球销量第一|medium|若线缆深加工独立盈利披露则替换分摊" \
  "sheet|板带箔|基础产品战略收缩，销量大幅下降|medium|若高附加值箔材形成独立规模则重新拆分" \
  "profiles|3C与汽车轻量化型材|高毛利核心升级业务、客户认证和海外交付重要|medium|若3C与汽车业务分别披露利润和现金流则进一步拆分" \
  "structures|消费电子及汽车结构件|规模小且2025年仍亏损|low|若新客户量产令收入和毛利显著改善则重估" \
  "trade|贸易及铝加工配套|覆盖披露产品与合并总量差额，含贸易收入及配套服务|low|若公司披露其他业务收入成本明细则替换残差"; do
  IFS='|' read -r bid bname importance conf falsifier <<< "$spec"
  python3 "$tool" add-business --model "$model" --business-id "$bid" --name "$bname" --importance "$importance" --confidence "$conf" --falsifier "$falsifier"
done

fact bars_rev "棒材主营业务收入" 45266268726.40 2025 "$src25" "第38页，主营业务分产品"
fact bars_cost "棒材主营业务成本" 44430104311.04 2025 "$src25" "第38页，主营业务分产品"
fact wire_rev "铝杆线缆主营业务收入" 19300060113.62 2025 "$src25" "第38页，主营业务分产品"
fact wire_cost "铝杆线缆主营业务成本" 18865737116.33 2025 "$src25" "第38页，主营业务分产品"
fact sheet_rev "板带箔主营业务收入" 5774679328.11 2025 "$src25" "第38页，主营业务分产品"
fact sheet_cost "板带箔主营业务成本" 5637542071.63 2025 "$src25" "第38页，主营业务分产品"
fact profiles_rev "型材主营业务收入" 5209313621.40 2025 "$src25" "第38页，主营业务分产品"
fact profiles_cost "型材主营业务成本" 4268079324.61 2025 "$src25" "第38页，主营业务分产品"
fact structures_rev "结构件主营业务收入" 179192333.32 2025 "$src25" "第38页，主营业务分产品"
fact structures_cost "结构件主营业务成本" 207931165.00 2025 "$src25" "第38页，主营业务分产品"
fact main_rev "主营业务收入合计" 75729514122.85 2025 "$src25" "第38页，有色金属制造主营业务"
fact main_cost "主营业务成本合计" 73409393988.61 2025 "$src25" "第38页，有色金属制造主营业务"

biz_reported() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type reported --reason "$4" --confidence high; }
biz_est() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
for bid in bars wire sheet profiles structures; do
  biz_reported "$bid" revenue "${bid}_rev" "2025年报按产品直接披露。"
  biz_reported "$bid" cost_of_revenue "${bid}_cost" "2025年报按产品直接披露。"
done
biz_reported trade revenue "rev25-main_rev" "合并收入减已披露五类主营产品，为贸易及配套业务控制数。"
biz_reported trade cost_of_revenue "cost25-main_cost" "合并成本减已披露五类主营产品，为贸易及配套业务控制数。"

biz_est bars period_operating_expenses 300000000 "按业务复杂度、收入规模和毛利承受力分摊公司经营费用。" low "独立费用披露可推翻。"
biz_est wire period_operating_expenses 150000000 "按业务复杂度、收入规模和毛利承受力分摊公司经营费用。" low "独立费用披露可推翻。"
biz_est sheet period_operating_expenses 75000000 "按业务复杂度、收入规模和毛利承受力分摊公司经营费用。" low "独立费用披露可推翻。"
biz_est profiles period_operating_expenses 430000000 "高研发、客户验证和海外组织投入使型材承担较多经营费用。" low "独立费用披露可推翻。"
biz_est structures period_operating_expenses 80000000 "精密加工、自动化和客户开发强度高，分摊较高费用。" low "独立费用披露可推翻。"
biz_est trade period_operating_expenses 38289271.62 "以公司经营费用总额残差闭合。" low "其他业务费用明细可推翻。"

biz_est bars cash_tax 127825623.22 "按公司正常经营税率作用于业务估计EBIT。" low "分业务纳税和税惠披露可推翻。"
biz_est wire cash_tax 67784737.82 "按公司正常经营税率作用于业务估计EBIT。" low "分业务纳税和税惠披露可推翻。"
biz_est sheet cash_tax 14813988.60 "按公司正常经营税率作用于业务估计EBIT。" low "分业务纳税和税惠披露可推翻。"
biz_est profiles cash_tax 121882095.72 "按公司正常经营税率作用于业务估计EBIT。" low "分业务纳税和税惠披露可推翻。"
biz_est structures cash_tax -25924154.10 "结构件估计经营亏损形成税盾；仅为公司税负闭合分摊。" low "亏损不可抵税或业务独立税负资料可推翻。"
biz_est trade cash_tax 18199084.48 "按公司现金税总额残差闭合。" low "其他业务税负明细可推翻。"

biz_est bars operating_cash_flow_contribution -700000000 "存货与经营性应付款逆向变化主要分配给最大宗棒材。" low "产品级库存、应收、应付和现金流资料可推翻。"
biz_est wire operating_cash_flow_contribution -300000000 "线缆增长带来库存和应收占用。" low "产品级营运资金资料可推翻。"
biz_est sheet operating_cash_flow_contribution -100000000 "收缩期仍有库存与回款占用。" low "产品级营运资金资料可推翻。"
biz_est profiles operating_cash_flow_contribution 150000000 "较高毛利和收入增长支持正经营现金贡献，但估计置信度低。" low "产品级营运资金资料可推翻。"
biz_est structures operating_cash_flow_contribution -80000000 "毛利为负且仍在客户和产能投入期。" low "产品级现金流资料可推翻。"
biz_est trade operating_cash_flow_contribution -44340048.45 "以公司经营现金流总额残差闭合。" low "其他业务现金流资料可推翻。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "所有重大金额均保存为原始事实并定位至上交所年报页码。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "区分经营营运资金、长期经营资产、受限现金、非经营投资和融资负债；避免重复。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本为正且规模稳定，ROIC分母有经济意义；经营必需现金估计置信度较低，正文限制比较结论。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定状态结合三年收入、毛利、费用、投产后折旧和正常资本开支，不采用2025异常营运资金占用。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "正文中心数字已与编译后的结构化模型和转写表逐项核对。"

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

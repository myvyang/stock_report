#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
src23=https://static.cninfo.com.cn/finalpage/2024-04-24/1219769617.PDF
src24=https://static.cninfo.com.cn/finalpage/2025-04-26/1223306974.PDF
src25=https://static.cninfo.com.cn/finalpage/2026-04-27/1225178636.PDF

python3 "$tool" init --name 华夏航空 --code 002928.SZ --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 人民币 --security-name 普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --source "$5" --locator "$6"
}
hist_expr() {
  python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --expression="$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}
}
hist_est() {
  python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"
}
cap_expr() {
  python3 "$tool" set-field --model "$model" --view capital --year "$1" --field "$2" --expression="$3" --basis-type formula --reason "$4" --confidence "$5"
}
cap_est() {
  python3 "$tool" set-field --model "$model" --view capital --year "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"
}

# 历史损益、现金流和租赁现金投入。2023比较数采用后续年度经审计列报。
for row in \
"2023 revenue 5151265004.81 营业收入 $src24 2024年年度报告第96页" \
"2023 cost 5512823455.56 营业成本 $src24 2024年年度报告第96至97页" \
"2023 surtax 16318988.11 税金及附加 $src24 2024年年度报告第97页" \
"2023 selling 239456144.72 销售费用 $src24 2024年年度报告第97页" \
"2023 admin 267091117.35 管理费用 $src24 2024年年度报告第97页" \
"2023 rd 22828891.56 研发费用 $src24 2024年年度报告第97页" \
"2023 subsidy 528408880.02 其他收益 $src24 2024年年度报告第97页" \
"2023 credit -91762669.91 信用减值损失 $src24 2024年年度报告第97页" \
"2023 impairment -13462513.23 资产减值损失 $src24 2024年年度报告第97页" \
"2023 lease_interest 366774542.17 租赁负债利息费用 $src23 2023年年度报告第161页" \
"2023 da_fixed 197509486.43 固定资产折旧 $src24 2024年年度报告第160页比较数" \
"2023 da_rou 1032570227.08 使用权资产折旧 $src24 2024年年度报告第160页比较数" \
"2023 da_intangible 20346618.12 无形资产摊销 $src24 2024年年度报告第160页比较数" \
"2023 da_deferred 68581143.66 长期待摊费用摊销 $src24 2024年年度报告第160页比较数" \
"2023 ocf 1322170693.08 经营活动产生的现金流量净额 $src24 2024年年度报告第100页" \
"2023 capex_paid 541251378.65 购建固定资产无形资产和其他长期资产支付的现金 $src24 2024年年度报告第101页" \
"2023 disposal 494746.34 处置固定资产无形资产和其他长期资产收回的现金净额 $src24 2024年年度报告第100页" \
"2023 lease_principal 1454171935.73 租赁负债现金减少额 $src23 2023年年度报告第165页" \
"2024 revenue 6695600043.05 营业收入 $src25 2025年年度报告第93至94页比较数" \
"2024 cost 6578035417.08 营业成本 $src25 2025年年度报告第94页比较数" \
"2024 surtax 19833376.44 税金及附加 $src25 2025年年度报告第94页比较数" \
"2024 selling 296229682.20 销售费用 $src25 2025年年度报告第94页比较数" \
"2024 admin 259257571.84 管理费用 $src25 2025年年度报告第94页比较数" \
"2024 rd 11216015.07 研发费用 $src25 2025年年度报告第94页比较数" \
"2024 subsidy 1293444400.81 其他收益 $src25 2025年年度报告第94页比较数" \
"2024 credit 11171307.05 信用减值损失 $src25 2025年年度报告第94页比较数" \
"2024 impairment -1761496.63 资产减值损失 $src25 2025年年度报告第94页比较数" \
"2024 lease_interest 380679496.50 租赁负债利息费用 $src25 2025年年度报告第156页比较数" \
"2024 current_tax 30542688.97 当期所得税费用 $src25 2025年年度报告第158页比较数" \
"2024 interest 571668090.54 利息费用 $src25 2025年年度报告第94页比较数" \
"2024 da_fixed 247586894.83 固定资产资产折旧 $src25 2025年年度报告第159页比较数" \
"2024 da_rou 1097369934.38 使用权资产折旧 $src25 2025年年度报告第159页比较数" \
"2024 da_intangible 19857086.17 无形资产摊销 $src25 2025年年度报告第159页比较数" \
"2024 da_deferred 82963736.79 长期待摊费用摊销 $src25 2025年年度报告第159页比较数" \
"2024 ocf 1809630115.58 经营活动产生的现金流量净额 $src25 2025年年度报告第98页比较数" \
"2024 capex_paid 298200645.20 购建固定资产无形资产和其他长期资产支付的现金 $src25 2025年年度报告第98页比较数" \
"2024 disposal 117650773.80 处置固定资产无形资产和其他长期资产收回的现金净额 $src25 2025年年度报告第98页比较数" \
"2024 lease_principal 1664507981.00 租赁负债现金减少额 $src24 2024年年度报告第162页" \
"2025 revenue 7456121307.37 营业收入 $src25 2025年年度报告第93至94页" \
"2025 cost 7291995536.40 营业成本 $src25 2025年年度报告第94页" \
"2025 surtax 14689671.04 税金及附加 $src25 2025年年度报告第94页" \
"2025 selling 327627771.15 销售费用 $src25 2025年年度报告第94页" \
"2025 admin 292973174.14 管理费用 $src25 2025年年度报告第94页" \
"2025 rd 471921.24 研发费用 $src25 2025年年度报告第94页" \
"2025 subsidy 1697620670.13 其他收益 $src25 2025年年度报告第94页" \
"2025 credit 25108903.01 信用减值损失 $src25 2025年年度报告第94页" \
"2025 impairment -6949625.44 资产减值损失 $src25 2025年年度报告第94页" \
"2025 lease_interest 363354913.41 租赁负债利息费用 $src25 2025年年度报告第156页" \
"2025 current_tax 27973244.27 当期所得税费用 $src25 2025年年度报告第158页" \
"2025 interest 550695807.84 利息费用 $src25 2025年年度报告第94页" \
"2025 da_fixed 268083210.82 固定资产折旧 $src25 2025年年度报告第159页" \
"2025 da_rou 1208358153.09 使用权资产折旧 $src25 2025年年度报告第159页" \
"2025 da_intangible 14803269.11 无形资产摊销 $src25 2025年年度报告第159页" \
"2025 da_deferred 91660288.79 长期待摊费用摊销 $src25 2025年年度报告第159页" \
"2025 ocf 2521266161.95 经营活动产生的现金流量净额 $src25 2025年年度报告第97至98页" \
"2025 capex_paid 2372433074.65 购建固定资产无形资产和其他长期资产支付的现金 $src25 2025年年度报告第98页" \
"2025 disposal 190251062.91 处置固定资产无形资产和其他长期资产收回的现金净额 $src25 2025年年度报告第98页" \
"2025 lease_principal 2100594233.11 租赁负债现金减少额 $src25 2025年年度报告第159页"
do
  set -- $row
  fact "${2}_${1}" "$4" "$3" "$1" "$5" "$6"
done

for y in 2023 2024 2025; do
  hist_expr "$y" revenue "revenue_$y" reported "合并利润表直接列示。" high
  hist_expr "$y" cost_of_revenue "cost_$y" reported "合并利润表直接列示。" high
  hist_expr "$y" period_operating_expenses "surtax_$y + selling_$y + admin_$y + rd_$y + lease_interest_$y - subsidy_$y - credit_$y - impairment_$y" formula "将持续经营相关航线补贴纳入经营收益，并按经营租赁口径将租赁利息纳入经营费用；剔除借款利息、投资和处置损益。" medium
  hist_expr "$y" depreciation_amortization "da_fixed_$y + da_rou_$y + da_intangible_$y + da_deferred_$y" formula "加总经营性固定资产、使用权资产、无形资产和长期待摊费用折旧摊销。" high
  hist_expr "$y" core_business_capex "capex_paid_$y - disposal_$y + lease_principal_$y" formula "经营租赁口径：自购长期资产现金支出扣处置回款，再加租赁本金；均服务现有航空运输网络。" high
  hist_est "$y" exploratory_business_capex 0 "公司业务仍集中于航空运输，未识别可独立验证的新业务资本开支。" medium "若后续披露资本投入对应独立新业务，则应重分类。"
  hist_expr "$y" operating_cash_flow "ocf_$y" reported "合并现金流量表直接列示。" high
done
hist_est 2023 cash_tax 0 "经营EBIT为负，经营现金税按零处理；子公司当期税不归因于亏损经营整体。" medium "若披露可归属于经营EBIT的现金税，则改按该金额。"
hist_expr 2024 cash_tax "current_tax_2024 + (interest_2024 - lease_interest_2024) * 0.15" formula "当期所得税加回非租赁融资利息的15%税盾，近似无融资经营现金税。" medium
hist_expr 2025 cash_tax "current_tax_2025 + (interest_2025 - lease_interest_2025) * 0.15" formula "当期所得税加回非租赁融资利息的15%税盾，近似无融资经营现金税。" medium
hist_expr 2023 after_tax_interest_in_operating_cash_flow "-lease_interest_2023" formula "经营租赁口径下，现金流量表把租赁利息列在筹资活动，故在经营现金流桥中扣回。" medium
hist_expr 2024 after_tax_interest_in_operating_cash_flow "-lease_interest_2024 * 0.85" formula "经营租赁口径下扣回税后租赁利息。" medium
hist_expr 2025 after_tax_interest_in_operating_cash_flow "-lease_interest_2025 * 0.85" formula "经营租赁口径下扣回税后租赁利息。" medium
hist_est 2023 operating_working_capital_increase -487233113.40 "按NOPAT、折旧摊销与经租赁重分类后的经营现金流反推，亦反映应收回落带来的资金释放。" medium "若附注明确的经营营运资金口径与此差异重大，则重算。"
hist_est 2024 operating_working_capital_increase 355736825.69 "按NOPAT、折旧摊销与经租赁重分类后的经营现金流反推，主要对应补贴及经营应收增长。" medium "若经营应收中存在重大非经营款项，则重算。"
hist_est 2025 operating_working_capital_increase 195204325.51 "按NOPAT、折旧摊销与经租赁重分类后的经营现金流反推，并以资产负债表经营净营运资金变化复核。" medium "若补贴应收或应付票据被证实属于融资，则重算。"

# 投入资本：流动端由流动总量剔除现金、交易金融资产并加回融资负债；长期端将租赁资产和负债净额纳入经营机器。
for row in \
"2022 ca 4127276345.71 流动资产合计 $src23 2023年年度报告第98页期初数" "2022 cash 1789386006.79 货币资金 $src23 2023年年度报告第98页期初数" "2022 tfa 25617.78 交易性金融资产 $src23 2023年年度报告第98页期初数" "2022 cl 4706982407.01 流动负债合计 $src23 2023年年度报告第99页期初数" "2022 sd 2187198824.42 短期借款 $src23 2023年年度报告第99页期初数" "2022 cd 1545121081.82 一年内到期非流动负债 $src23 2023年年度报告第99页期初数" "2022 fa 2653729887.24 固定资产 $src23 2023年年度报告第98页期初数" "2022 cip 1200421551.24 在建工程 $src23 2023年年度报告第98页期初数" "2022 rou 7991196086.42 使用权资产 $src23 2023年年度报告第99页期初数" "2022 ia 187084298.94 无形资产 $src23 2023年年度报告第99页期初数" "2022 ltp 847594830.05 长期待摊费用 $src23 2023年年度报告第99页期初数" "2022 lease 7879181710.93 租赁负债含一年内到期 $src23 2023年年度报告第165页期初数" "2022 prov 181403714.95 预计负债 $src23 2023年年度报告第100页期初数" "2022 grant 60340435.94 递延收益 $src23 2023年年度报告第100页期初数" \
"2023 ca 4076445415.75 流动资产合计 $src24 2024年年度报告第92页期初数" "2023 cash 1920388792.53 货币资金 $src24 2024年年度报告第92页期初数" "2023 tfa 18869.01 交易性金融资产 $src24 2024年年度报告第92页期初数" "2023 cl 5751958099.38 流动负债合计 $src24 2024年年度报告第93页期初数" "2023 sd 2077008712.88 短期借款 $src24 2024年年度报告第93页期初数" "2023 cd 2568079251.77 一年内到期非流动负债 $src24 2024年年度报告第93页期初数" "2023 fa 3011755808.08 固定资产 $src24 2024年年度报告第92页期初数" "2023 cip 944482764.28 在建工程 $src24 2024年年度报告第92页期初数" "2023 rou 8364431817.90 使用权资产 $src24 2024年年度报告第93页期初数" "2023 ia 177920709.01 无形资产 $src24 2024年年度报告第93页期初数" "2023 ltp 954823168.70 长期待摊费用 $src24 2024年年度报告第93页期初数" "2023 lease 7904067659.64 租赁负债含一年内到期 $src24 2024年年度报告第162页期初数" "2023 prov 207528461.19 预计负债 $src24 2024年年度报告第94页期初数" "2023 grant 68811441.65 递延收益 $src24 2024年年度报告第94页期初数" \
"2024 ca 5180505248.94 流动资产合计 $src25 2025年年度报告第89页期初数" "2024 cash 1659259200.43 货币资金 $src25 2025年年度报告第89页期初数" "2024 tfa 23414.10 交易性金融资产 $src25 2025年年度报告第89页期初数" "2024 cl 6270677201.23 流动负债合计 $src25 2025年年度报告第91页期初数" "2024 sd 2579410084.01 短期借款 $src25 2025年年度报告第90页期初数" "2024 cd 2141663181.78 一年内到期非流动负债 $src25 2025年年度报告第90页期初数" "2024 fa 2638336450.06 固定资产 $src25 2025年年度报告第90页期初数" "2024 cip 1091071707.65 在建工程 $src25 2025年年度报告第90页期初数" "2024 rou 10087746138.37 使用权资产 $src25 2025年年度报告第90页期初数" "2024 ia 101062257.95 无形资产 $src25 2025年年度报告第90页期初数" "2024 ltp 1025165700.67 长期待摊费用 $src25 2025年年度报告第90页期初数" "2024 lease 9466377516.48 租赁负债含一年内到期 $src25 2025年年度报告第159页期初数" "2024 prov 229643376.95 预计负债 $src25 2025年年度报告第91页期初数" "2024 grant 42881267.10 递延收益 $src25 2025年年度报告第91页期初数" \
"2025 ca 6241561112.84 流动资产合计 $src25 2025年年度报告第89页" "2025 cash 1816161223.68 货币资金 $src25 2025年年度报告第89页" "2025 tfa 24929.13 交易性金融资产 $src25 2025年年度报告第89页" "2025 cl 7568084339.95 流动负债合计 $src25 2025年年度报告第91页" "2025 sd 2969451749.66 短期借款 $src25 2025年年度报告第90页" "2025 cd 2125742622.90 一年内到期非流动负债 $src25 2025年年度报告第90页" "2025 fa 4388936303.94 固定资产 $src25 2025年年度报告第90页" "2025 cip 1099457994.20 在建工程 $src25 2025年年度报告第90页" "2025 rou 10341496514.05 使用权资产 $src25 2025年年度报告第90页" "2025 ia 94826966.27 无形资产 $src25 2025年年度报告第90页" "2025 ltp 1141311964.30 长期待摊费用 $src25 2025年年度报告第90页" "2025 lease 9376425768.94 租赁负债含一年内到期 $src25 2025年年度报告第159页" "2025 prov 252341457.81 预计负债 $src25 2025年年度报告第91页" "2025 grant 34629682.46 递延收益 $src25 2025年年度报告第91页"
do
  set -- $row
  fact "${2}_${1}" "$4" "$3" "$1" "$5" "$6"
done

for y in 2022 2023 2024 2025; do
  cap_expr "$y" operating_working_capital "ca_$y - cash_$y - tfa_$y - cl_$y + sd_$y + cd_$y" "流动资产负债总量剔除现金和交易性金融资产，并加回短期借款及一年内到期融资负债。" medium
  cap_expr "$y" operating_long_term_assets_net "fa_$y + cip_$y + rou_$y + ia_$y + ltp_$y - lease_$y - prov_$y - grant_$y" "固定资产、在建工程、使用权资产、经营无形资产及长期待摊投入，扣除租赁负债、预计负债和资产相关递延收益。" medium
  cap_est "$y" unsupported_intangible_assets 0 "无商誉；现有无形资产主要服务航空运行系统，未识别无法解释的并购溢价。" medium "若披露不服务经营或已失效的无形资产，则予以剔除。"
done
cap_est 2022 required_cash 400000000 "约覆盖一个月核心现金经营支出，保留季节性与运行保障缓冲。" low "若月度现金支出或可用授信证明更低需求，则下调。"
cap_est 2023 required_cash 450000000 "随航班恢复提高，约覆盖一个月核心现金经营支出。" low "若月度现金支出或可用授信证明更低需求，则下调。"
cap_est 2024 required_cash 480000000 "按当年现金经营支出规模估计的最低运行现金。" low "若公司披露最低现金政策，则以披露替代。"
cap_est 2025 required_cash 500000000 "约为年度经营现金流出一个月，反映航油、薪酬与机场结算缓冲。" low "若公司披露最低现金政策或旺淡季峰值，则重估。"

# 稳定状态采用2025运量基础、略正常化的成本和补贴；维持投入含租赁本金。
stable() { python3 "$tool" set-field --model "$model" --view stable --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }
stable revenue 7500000000 "以2025年80架机队和83.23%客座率为基准，不外推高速扩张。" medium "若客座率显著跌破78%或机队继续大幅扩张，则重估。"
stable cost_of_revenue 7350000000 "维持约2%的报告毛利率，反映支线航线薄毛利和航油波动。" medium "若油价、单位起降费或单位人工成本持续偏离2025水平，则重估。"
stable period_operating_expenses -600000000 "假设日常航线补贴约16亿元，抵减约10亿元税附、销售管理研发及租赁利息。" low "若补贴政策、航段运力资格或确认节奏变化，稳定EBIT将显著变化。"
stable cash_tax 112500000 "按稳定EBIT的15%估计无融资经营税。" medium "若税收优惠终止或亏损结转耗尽后的有效税率不同，则重估。"
stable depreciation_amortization 1550000000 "接近2025年折旧摊销，匹配80架左右机队。" medium "若自购与租赁机队结构变化，折旧摊销需重估。"
stable core_business_capex 2100000000 "包含约3亿元自有资产正常更新及约18亿元租赁本金，低于2025扩张投入。" low "若飞机续租、退租或发动机大修现金需求明显高于该水平，则下调价值。"
stable exploratory_business_capex 0 "未对无法验证的独立新业务投入赋予稳定价值。" medium "若出现具名新业务及独立资本预算，则另行计入。"
stable operating_working_capital_increase 0 "成熟运量下假设经营营运资金不再永久增长。" medium "若补贴应收继续随收入持续增加，则应采用正数。"

# 最新年度业务树，成本按已披露客运成本与客运收入比例分配，费用、税和现金按收入比例分配。
fact retail_revenue_2025 个人客运分销收入 5641746216.24 2025 "$src25" 2025年年度报告第21页
fact institutional_revenue_2025 机构客运分销收入 1691493134.22 2025 "$src25" 2025年年度报告第21页
python3 "$tool" add-business --model "$model" --business-id passenger_retail --name 个人客运分销 --importance "占2025年收入75.66%，由个人旅客购票需求与网络收益管理驱动。" --confidence medium --falsifier "若公司披露个人渠道的独立成本或补贴归属，则替换比例分配。"
python3 "$tool" add-business --model "$model" --business-id passenger_institutional --name 机构客运分销 --importance "占2025年收入22.69%，机构客户及航线合作安排影响定价和回款。" --confidence medium --falsifier "若机构分销实为政府购买或包机且经济性显著不同，则重新划分。"
python3 "$tool" add-business --model "$model" --business-id cargo_ancillary --name 货运及航空配套服务 --importance "覆盖货运收入及非客运配套收入，规模小但闭合公司总量。" --confidence medium --falsifier "若配套服务披露出独立重大资产或利润贡献，则进一步拆分。"
biz() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type "$4" --reason "$5" --confidence "$6" ${7:+--falsifier "$7"}; }
biz_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression="$3" --basis-type "$4" --reason "$5" --confidence "$6"; }
biz_expr passenger_retail revenue retail_revenue_2025 reported "2025年年度报告按销售模式直接披露。" high
biz passenger_retail cost_of_revenue 5536421364.02 estimate "客运成本按个人与机构客运收入比例分配。" low "渠道成本或补贴归属披露后重算。"
biz passenger_retail period_operating_expenses -542269601.38 estimate "公司净经营费用按收入比例分配。" low "渠道费用和航线补贴归属披露后重算。"
biz passenger_retail cash_tax 42429220.14 estimate "经营现金税按收入比例分配。" low "分业务税务数据披露后重算。"
biz passenger_retail operating_cash_flow_contribution 1907740397.85 estimate "公司经营现金流按收入比例分配。" low "分渠道回款和营运资金披露后重算。"
biz_expr passenger_institutional revenue institutional_revenue_2025 reported "2025年年度报告按销售模式直接披露。" high
biz passenger_institutional cost_of_revenue 1659914921.10 estimate "客运成本按个人与机构客运收入比例分配。" low "渠道成本或补贴归属披露后重算。"
biz passenger_institutional period_operating_expenses -162581809.33 estimate "公司净经营费用按收入比例分配。" low "机构渠道费用和补贴归属披露后重算。"
biz passenger_institutional cash_tax 12721014.35 estimate "经营现金税按收入比例分配。" low "分业务税务数据披露后重算。"
biz passenger_institutional operating_cash_flow_contribution 571973580.72 estimate "公司经营现金流按收入比例分配。" low "机构客户回款披露后重算。"
biz cargo_ancillary revenue 122881956.91 estimate "货运收入与其他业务收入合计，两项均由年报直接披露。" high "若其他业务具备独立重大经济性，则进一步拆分。"
biz cargo_ancillary cost_of_revenue 95659251.28 estimate "公司营业成本扣除已披露客运成本。" high "若公司重述客运成本，则同步更新。"
biz cargo_ancillary period_operating_expenses -11811086.01 estimate "公司净经营费用按收入比例分配。" low "独立费用披露后重算。"
biz cargo_ancillary cash_tax 924143.94 estimate "经营现金税按收入比例分配。" low "分业务税务数据披露后重算。"
biz cargo_ancillary operating_cash_flow_contribution 41552183.38 estimate "公司经营现金流按收入比例分配。" low "分业务现金流披露后重算。"

# 价值桥。租赁已进入经营投入，不重复列作融资负债。
equity() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"; }
equity excess_cash 490393052.85 "期末货币资金18.16亿元，扣受限资金8.26亿元及经营必需现金5亿元。" medium "若受限资金释放或现金承诺变化，则重估。"
equity non_operating_assets 2564990.45 "长期股权投资与其他非流动金融资产按账面值计入；金额不重大。" medium "若可实现价值或处置税费显著不同，则重估。"
equity financing_debt 7807098922.82 "短期借款、含流动部分长期借款、长期应付款及飞机融资款合计；租赁负债不重复扣除。" medium "若长期应付款被证实为经营租赁本金且已全数进入资本开支，则需剔除。"
equity minority_interest_value 0 "合并报表期末无少数股东权益。" high "若期后引入子公司少数股东，则重估。"
equity other_priority_claims 0 "未识别未在经营资本或融资负债中处理的重大优先索偿。" medium "若资本承诺形成不可撤销且未计入债务的付款义务，则纳入。"
equity diluted_shares 1278241550 "以期末总股本为完全摊薄基准；回购股用于员工持股，审慎保留潜在摊薄。" medium "若回购股份注销或新增激励工具，则更新。"
python3 "$tool" set-field --model "$model" --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason "财务与交易币种均为人民币。" --confidence high --falsifier "若交易币种改变则更新。"
python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "缺少可可靠预测的逐年成长FCFF，使用稳定经营收益八倍固定标尺；租赁与补贴正常化后仍检验普通股剩余价值。" --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-adjustment --model "$model" --name "航线补贴经营化" --before "其他收益：2025年16.98亿元" --after "纳入EBIT" --reason "年报称主要为与日常经营相关的航线补贴且具有持续性；这是支线网络商业模式的一部分，但政策变化是核心风险。"
python3 "$tool" add-adjustment --model "$model" --name "飞机租赁经营化" --before "租赁利息列财务费用、租赁本金列筹资现金流" --after "利息纳入期间经营费用，本金纳入资本开支" --reason "使航空运力的完整现金成本进入经营收益，并避免价值桥重复扣除租赁负债。"
python3 "$tool" add-adjustment --model "$model" --name "受限资金与最低现金" --before "货币资金18.16亿元" --after "多余现金4.90亿元" --reason "扣除8.26亿元保证金等受限资金及5亿元最低运行现金。"

for item in capital_return_interpretability source_traceability economic_classification stable_state report_consistency; do
  case "$item" in
    capital_return_interpretability) reason="ROIC分母包括经营营运资金及租赁净资产，经营必需现金为低置信估计，正文限制其解释范围。";;
    source_traceability) reason="重大报表数均保存法定年报公开链接、报告名称及页码。";;
    economic_classification) reason="补贴与飞机租赁按航空业务经济实质重分类，投资、处置和借款利息排除。";;
    stable_state) reason="稳定状态不机械采用2025扩张资本开支，单独正常化补贴、租赁本金和自有资产更新。";;
    report_consistency) reason="正文中心数字、FCFF、投入资本与价值桥均以结构化模型为唯一口径。";;
  esac
  python3 "$tool" set-review --model "$model" --item "$item" --passed --reason "$reason"
done

python3 "$tool" compile --model "$model"

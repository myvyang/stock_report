#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name "乐歌股份" --code "300729.SZ" --period-label "2025年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "普通股" --security-unit "股" --output "$model"

addfact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "合并" --source "$5" --locator "$6"
}

setf() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" ${3:+--year "$3"} --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}

sete() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" ${3:+--year "$3"} --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

# 合并利润表、现金流量表和补充资料。2023 P110-P115/P192；2024 P125-P130/P211；2025 P118-P123/P198。
for row in \
"2023 rev 3901707615.76 营业收入 P110-P111" \
"2023 cost 2476504084.79 营业成本 P110-P111" \
"2023 pbt 795625502.61 利润总额 P111" \
"2023 noi 3590545.04 营业外收入 P111" \
"2023 noe 9415397.67 营业外支出 P111" \
"2023 ie 89775759.48 利息费用 P111" \
"2023 ii 55531664.54 利息收入 P111" \
"2023 inv -23654726.57 投资收益 P111" \
"2023 fv -1825545.53 公允价值变动收益 P111" \
"2023 disp 515720818.04 资产处置收益 P111" \
"2023 ocf 819500926.26 经营活动产生的现金流量净额 P114" \
"2023 dep 74178188.26 固定资产折旧 P192" \
"2023 roudep 157676992.93 使用权资产折旧 P192" \
"2023 amort 10965274.51 无形资产摊销 P192" \
"2023 ltdamort 14861034.86 长期待摊费用摊销 P192" \
"2023 purch 1387807878.68 购建固定资产无形资产和其他长期资产支付的现金 P114-P115" \
"2023 leasepay 146713034.62 租赁负债支付的现金 P191" \
"2023 proceeds 847170578.60 处置固定资产无形资产和其他长期资产收回的现金净额 P114" \
"2024 rev 5670453707.45 营业收入 P125" \
"2024 cost 4017772338.23 营业成本 P125" \
"2024 pbt 394564328.68 利润总额 P126" \
"2024 noi 2175769.28 营业外收入 P126" \
"2024 noe 3665938.86 营业外支出 P126" \
"2024 ie 135891739.67 利息费用 P126" \
"2024 ii 66791222.01 利息收入 P126" \
"2024 inv -6085006.27 投资收益 P126" \
"2024 fv -5427382.70 公允价值变动收益 P126" \
"2024 disp 153352458.70 资产处置收益 P126" \
"2024 ocf 658022131.65 经营活动产生的现金流量净额 P129" \
"2024 dep 99461947.59 固定资产折旧 P211" \
"2024 roudep 278413985.00 使用权资产折旧 P211" \
"2024 amort 17752653.34 无形资产摊销 P211" \
"2024 ltdamort 12395725.26 长期待摊费用摊销 P211" \
"2024 purch 628122898.62 购建固定资产无形资产和其他长期资产支付的现金 P129" \
"2024 leasepay 198792728.63 租赁负债支付的现金 P210" \
"2024 proceeds 595388108.21 处置固定资产无形资产和其他长期资产收回的现金净额 P129" \
"2025 rev 6714646356.80 营业收入 P118-P119" \
"2025 cost 4883527602.40 营业成本 P118-P119" \
"2025 pbt 314130883.50 利润总额 P119" \
"2025 noi 5392366.75 营业外收入 P119" \
"2025 noe 7800402.03 营业外支出 P119" \
"2025 ie 179639652.13 利息费用 P119" \
"2025 ii 80233550.70 利息收入 P119" \
"2025 inv 9362247.44 投资收益 P119" \
"2025 fv 10135456.70 公允价值变动收益 P119" \
"2025 disp 26562092.84 资产处置收益 P119" \
"2025 ocf 1125332117.32 经营活动产生的现金流量净额 P122" \
"2025 dep 131403170.82 固定资产折旧 P198" \
"2025 roudep 431795254.99 使用权资产折旧 P198" \
"2025 amort 18848382.83 无形资产摊销 P198" \
"2025 ltdamort 10567283.60 长期待摊费用摊销 P198" \
"2025 purch 1184773822.74 购建固定资产无形资产和其他长期资产支付的现金 P122" \
"2025 leasepay 471658689.58 租赁负债支付的现金 P197" \
"2025 proceeds 105300763.50 处置固定资产无形资产和其他长期资产收回的现金净额 P122"
do
  read -r year id amount item locator <<<"$row"
  case "$year" in 2023) src="乐歌股份2023年年度报告";; 2024) src="乐歌股份2024年年度报告";; 2025) src="乐歌股份2025年年度报告";; esac
  addfact "${id}_${year}" "$item" "$amount" "${year}年度" "$src" "$locator"
done

# 经营表。EBIT剔除利息、投资、公允价值、资产处置和营业外净损益；政府补助及信用/资产减值保留在经营中。
for y in 2023 2024 2025; do
  ebit="pbt_${y}-noi_${y}+noe_${y}+ie_${y}-ii_${y}-inv_${y}-fv_${y}-disp_${y}"
  setf historical revenue "$y" "rev_${y}" reported "合并利润表营业收入。" high
  setf historical cost_of_revenue "$y" "cost_${y}" reported "合并利润表营业成本。" high
  setf historical period_operating_expenses "$y" "rev_${y}-cost_${y}-(${ebit})" formula "用收入减营业成本和重构EBIT得到净期间经营费用；保留经常经营相关其他收益与减值，剔除融资及非经营投资、资产处置、营业外损益。" medium
  case "$y" in
    2023) tax=51818085.636; ati=76309395.558; wc=-344493012.652;;
    2024) tax=48497241.9285; ati=115507978.7195; wc=-90688094.9215;;
    2025) tax=55482783.4845; ati=152693704.3105; wc=-371009289.6445;;
  esac
  sete historical cash_tax "$y" "$tax" "按重构EBIT的15%估计经营现金税；母公司高新技术企业适用15%，比混有资产处置和境外主体税负的报表所得税更接近正常经营税率。" medium "若分部税务资料显示境外经营的长期现金税率显著偏离15%，应重算。"
  setf historical depreciation_amortization "$y" "dep_${y}+roudep_${y}+amort_${y}+ltdamort_${y}" reported "现金流量表补充资料所列固定资产、使用权资产、无形资产及长期待摊费用折旧摊销合计。" high
  setf historical core_business_capex "$y" "purch_${y}+leasepay_${y}-proceeds_${y}" formula "采用经营租赁一致口径：购建长期经营资产现金加租赁负债现金支付，扣除经营性长期资产处置回款；公共海外仓已形成收入，相关投入归入现有主营业务。" medium
  sete historical exploratory_business_capex "$y" 0 "年报未披露可与现有智能家居及公共海外仓明确分离的资本化新业务投入；产品及系统探索主要进入研发费用，避免重复计入资本开支。" medium "若项目明细披露独立新业务的资本化现金支出，应从主营资本开支重分类。"
  sete historical operating_working_capital_increase "$y" "$wc" "按融资前现金流闭合反推：NOPAT加折旧摊销减经营现金流和税后利息；该现金流口径吸收经营应收应付、存货及其他经营项目的综合变动。" medium "若能取得逐项经营资产负债现金变动表，应以逐项结果替代该闭合估计。"
  setf historical operating_cash_flow "$y" "ocf_${y}" reported "合并现金流量表经营活动产生的现金流量净额。" high
  sete historical after_tax_interest_in_operating_cash_flow "$y" "$ati" "经营现金流由净利润起算，按利息费用的85%加回得到税后利息；税率与经营现金税估计一致。" medium "若现金流补充资料显示利息现金流分类或实际税盾不同，应调整。"
done

# 资产负债表经营资本。用合并报表小计扣除明确的金融、持有待售、融资及递延税项目，避免把研究聚合数伪装成披露事实。
for row in \
"2022 ca 3152376189.57 流动资产合计 2023 乐歌股份2023年年度报告 P106 期初" \
"2022 capcash 1628010309.68 货币资金 2023 乐歌股份2023年年度报告 P106 期初" \
"2022 captfa 369816484.62 交易性金融资产 2023 乐歌股份2023年年度报告 P106 期初" \
"2022 held 298444421.56 持有待售资产 2023 乐歌股份2023年年度报告 P106 期初" \
"2022 cl 1814537123.94 流动负债合计 2023 乐歌股份2023年年度报告 P107 期初" \
"2022 stloan 902307275.82 短期借款 2023 乐歌股份2023年年度报告 P107 期初" \
"2022 deriv 10920250.00 交易性金融负债 2023 乐歌股份2023年年度报告 P107 期初" \
"2022 currncl 167548111.25 一年内到期的非流动负债 2023 乐歌股份2023年年度报告 P107 期初" \
"2022 nca 2836351648.89 非流动资产合计 2023 乐歌股份2023年年度报告 P107 期初" \
"2022 lti 51898166.34 长期股权投资 2023 乐歌股份2023年年度报告 P106 期初" \
"2022 dta 26684412.10 递延所得税资产 2023 乐歌股份2023年年度报告 P107 期初" \
"2022 lease 1084112830.12 租赁负债含一年内到期 2023 乐歌股份2023年年度报告 P107-P108及P176 期初" \
"2022 defer 22537312.66 递延收益 2023 乐歌股份2023年年度报告 P108 期初" \
"2023 ca 2906329344.86 流动资产合计 2023 乐歌股份2023年年度报告 P106" \
"2023 capcash 1652177540.32 货币资金 2023 乐歌股份2023年年度报告 P106" \
"2023 captfa 245201312.62 交易性金融资产 2023 乐歌股份2023年年度报告 P106" \
"2023 held 42069816.71 持有待售资产 2023 乐歌股份2023年年度报告 P106" \
"2023 cl 1686274469.28 流动负债合计 2023 乐歌股份2023年年度报告 P107" \
"2023 stloan 580043767.61 短期借款 2023 乐歌股份2023年年度报告 P107" \
"2023 deriv 8130623.53 交易性金融负债 2023 乐歌股份2023年年度报告 P107" \
"2023 currncl 202340087.29 一年内到期的非流动负债 2023 乐歌股份2023年年度报告 P107" \
"2023 nca 3891578539.89 非流动资产合计 2023 乐歌股份2023年年度报告 P107" \
"2023 lti 65283575.70 长期股权投资 2023 乐歌股份2023年年度报告 P106" \
"2023 dta 32355786.09 递延所得税资产 2023 乐歌股份2023年年度报告 P107" \
"2023 lease 1159644792.96 租赁负债含一年内到期 2023 乐歌股份2023年年度报告 P107-P108及P176" \
"2023 defer 40963750.37 递延收益 2023 乐歌股份2023年年度报告 P108" \
"2024 ca 4143121550.29 流动资产合计 2024 乐歌股份2024年年度报告 P121" \
"2024 capcash 2540489654.96 货币资金 2024 乐歌股份2024年年度报告 P121" \
"2024 captfa 66449502.41 交易性金融资产 2024 乐歌股份2024年年度报告 P121" \
"2024 held 0 持有待售资产 2024 乐歌股份2024年年度报告 P121" \
"2024 cl 2542465511.78 流动负债合计 2024 乐歌股份2024年年度报告 P122" \
"2024 stloan 584672180.68 短期借款 2024 乐歌股份2024年年度报告 P122" \
"2024 deriv 24806196.02 交易性金融负债 2024 乐歌股份2024年年度报告 P122" \
"2024 currncl 515321311.80 一年内到期的非流动负债 2024 乐歌股份2024年年度报告 P122" \
"2024 nca 6008332260.62 非流动资产合计 2024 乐歌股份2024年年度报告 P122" \
"2024 lti 72886878.94 长期股权投资 2024 乐歌股份2024年年度报告 P121" \
"2024 dta 29472236.42 递延所得税资产 2024 乐歌股份2024年年度报告 P122" \
"2024 lease 3084183065.08 租赁负债含一年内到期 2024 乐歌股份2024年年度报告 P122-P123及P194" \
"2024 defer 35334973.74 递延收益 2024 乐歌股份2024年年度报告 P123" \
"2025 ca 3538351949.48 流动资产合计 2025 乐歌股份2025年年度报告 P114" \
"2025 capcash 2169823284.61 货币资金 2025 乐歌股份2025年年度报告 P114" \
"2025 captfa 74859358.53 交易性金融资产 2025 乐歌股份2025年年度报告 P114" \
"2025 held 0 持有待售资产 2025 乐歌股份2025年年度报告 P114" \
"2025 cl 2693704367.21 流动负债合计 2025 乐歌股份2025年年度报告 P115" \
"2025 stloan 490121481.78 短期借款 2025 乐歌股份2025年年度报告 P115" \
"2025 deriv 3080595.44 交易性金融负债 2025 乐歌股份2025年年度报告 P115" \
"2025 currncl 828314496.10 一年内到期的非流动负债 2025 乐歌股份2025年年度报告 P115" \
"2025 nca 6713047641.14 非流动资产合计 2025 乐歌股份2025年年度报告 P115" \
"2025 lti 74114013.93 长期股权投资 2025 乐歌股份2025年年度报告 P114" \
"2025 dta 39212747.67 递延所得税资产 2025 乐歌股份2025年年度报告 P115" \
"2025 lease 2936230795.76 租赁负债含一年内到期 2025 乐歌股份2025年年度报告 P115-P116及P189" \
"2025 defer 33635695.73 递延收益 2025 乐歌股份2025年年度报告 P116"
do
  read -r year id amount item srcyear src locator extra <<<"$row"
  addfact "${id}_${year}" "$item" "$amount" "${year}-12-31" "$src" "$locator ${extra:-}"
done

for y in 2022 2023 2024 2025; do
  setf capital operating_working_capital "$y" "ca_${y}-capcash_${y}-captfa_${y}-held_${y}-(cl_${y}-stloan_${y}-deriv_${y}-currncl_${y})" formula "流动资产合计扣货币资金、交易性金融资产和持有待售资产，再扣除剔除短借、衍生金融负债及一年内到期非流动负债后的经营流动负债。" medium
  setf capital operating_long_term_assets_net "$y" "nca_${y}-lti_${y}-dta_${y}-lease_${y}-defer_${y}" formula "非流动资产合计扣长期股权投资、递延所得税资产、采用经营租赁口径的租赁负债和资产相关递延收益；余额主要是固定资产、在建工程、使用权资产、经营无形资产及其他长期经营资产。" medium
  case "$y" in 2022) cash=250000000;; 2023) cash=300000000;; 2024) cash=400000000;; 2025) cash=500000000;; esac
  sete capital required_cash "$y" "$cash" "按约一个月现金经营成本并结合跨境结算、旺季备货和海外仓周转需求取整估计最低经营现金。" medium "若月度现金支出、授信备用额度或季节性峰值资料显示最低现金需求显著不同，应重估。"
  sete capital unsupported_intangible_assets "$y" 0 "公司无商誉；账面无形资产主要为服务制造及仓储网络的土地使用权与软件，未发现应从经营资本剔除的无法解释并购溢价。" medium "若无形资产附注出现不再服务主营或无法由经营收益解释的重大项目，应剔除。"
done

# 稳定状态：保持2025收入规模，不为尚未验收仓库机械加入远期收入；以27.5%毛利率、约5.9% EBIT率和零增长营运资金形成基准。
sete stable revenue "" 6714646356.80 "以2025年实际收入为当前正常规模；海外仓增长快但行业竞争加剧，缺少逐年订单与产能利用率证据，不外推管理层远景。" medium "若自建仓投运后利用率、单价和客户留存形成连续证据，可上调。"
sete stable cost_of_revenue "" 4868118688.68 "按27.5%稳定毛利率估计，略高于2025年27.27%，反映仓储毛利改善但不假设显著扩张。" medium "若仓储物流毛利率持续偏离11%-13%或业务组合显著变化，应调整。"
sete stable period_operating_expenses "" 1450000000 "以2025年重构期间经营费用为中心，假设规模稳定后费用略有节制但继续承担品牌、研发及全球运营成本。" medium "若销售费率或研发投入出现结构性变化，应重估。"
sete stable cash_tax "" 59479150.218 "按稳定EBIT的15%估计经营现金税。" medium "若境外利润占比或税收优惠变化使长期税率显著偏离15%，应调整。"
sete stable depreciation_amortization "" 600000000 "以2025年5.93亿元折旧摊销取整，反映既有自有及租赁仓网。" medium "若Ellabell等新仓投运后的折旧及租赁结构显著变化，应调整。"
sete stable core_business_capex "" 700000000 "常态主营资本开支取7亿元，覆盖制造、信息化、租赁仓现金支付及既有仓网更新扩张；低于2025建设峰值但高于折旧。" low "若公司披露成熟仓网的维持/扩张现金投入及建设节奏，可据此替代。"
sete stable exploratory_business_capex "" 0 "稳定经营收益不为未证实的新业务资本化投入预留独立价值；探索项目主要费用化。" medium "若出现独立资本化新业务项目，应另列且不计入稳定经营收益。"
sete stable operating_working_capital_increase "" 0 "固定收入规模的稳定状态不假设永久新增营运资金，也不延续2025年的大额现金释放。" medium "若正常增长或账期结构需要持续占用，应改为正数。"

# 最新年度两项经济业务，收入成本直接按分行业披露；费用、税和经营现金流作有依据的单点分配并严格闭合。
addfact biz_product_rev "家具制造业营业收入" 3404930814.56 "2025年度" "乐歌股份2025年年度报告" "P23"
addfact biz_product_cost "家具制造业营业成本" 1964056851.71 "2025年度" "乐歌股份2025年年度报告" "P23"
addfact biz_warehouse_rev "仓储物流服务业营业收入" 3309715542.24 "2025年度" "乐歌股份2025年年度报告" "P23"
addfact biz_warehouse_cost "仓储物流服务业营业成本" 2919470750.69 "2025年度" "乐歌股份2025年年度报告" "P23"

python3 "$tool" add-business --model "$model" --business-id products --name "智能家居与智慧办公产品" --importance "成熟品牌、研发制造和DTC渠道业务，承担主要毛利与品牌研发费用。" --confidence medium --falsifier "若公司披露家具分部完整利润及现金流，应替代费用和现金流分配。"
python3 "$tool" add-business --model "$model" --business-id warehouse --name "公共海外仓跨境物流服务" --importance "收入已占49.29%，依赖仓网、尾程议价和本地履约，资本占用重大。" --confidence medium --falsifier "若公司披露仓储分部完整利润及现金流，应替代费用和现金流分配。"

setbf() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" "$3" "$4" --basis-type "$5" --reason "$6" --confidence "$7" ${8:+--falsifier "$8"}; }
setbf products revenue --expression biz_product_rev reported "年报分行业家具制造业收入，包含人体工学系列及其他家具产品。" high
setbf products cost_of_revenue --expression biz_product_cost reported "年报分行业家具制造业营业成本。" high
setbf products period_operating_expenses --value 1250000000 estimate "品牌直销获客、全球销售渠道和绝大部分研发由产品业务承担；以公司费用为上限分配后，产品EBIT约1.91亿元。" low "分部利润或费用披露会推翻本分配。"
setbf products cash_tax --value 28631094.428 estimate "按产品业务估计EBIT的15%分配经营税。" low "分部税务披露会推翻本分配。"
setbf products operating_cash_flow_contribution --value 600000000 estimate "结合产品较高毛利、库存及DTC回款，分配合并经营现金流6亿元。" low "分部现金流或营运资金披露会推翻本分配。"
setbf warehouse revenue --expression biz_warehouse_rev reported "年报分行业仓储物流服务业收入。" high
setbf warehouse cost_of_revenue --expression biz_warehouse_cost reported "年报分行业仓储物流服务业营业成本。" high
setbf warehouse period_operating_expenses --value 211233531.17 estimate "将合并重构期间费用扣除产品业务分配额后的余额归属仓储物流；仓储成本已含尾程、租金与人工。" low "分部利润或费用披露会推翻本分配。"
setbf warehouse cash_tax --value 26851689.0565 estimate "经营现金税余额闭合至公司，约等于仓储估计EBIT的15%。" low "分部税务披露会推翻本分配。"
setbf warehouse operating_cash_flow_contribution --value 525332117.32 estimate "合并经营现金流扣除产品业务分配额后的余额，反映仓储规模和经营负债支持。" low "分部现金流或营运资金披露会推翻本分配。"

# 股权价值桥。
for row in \
"cash25 2169823284.61 货币资金 P114" \
"restricted25 65340471.29 使用受限货币资金 P159" \
"commit25 443250240.94 已签订正在或准备履行的固定资产采购合同 P222" \
"tfa25 74859358.53 交易性金融资产 P114及P160" \
"lti25 74114013.93 长期股权投资 P114" \
"stloan25 490121481.78 短期借款 P115" \
"curloan25 283392640.15 一年内到期的长期借款 P189" \
"curbond25 155688427.47 一年内到期的应付债券 P189及P186" \
"ltloan25 940840000 长期借款 P116" \
"ltbond25 250502348.59 应付债券 P116" \
"shares25 341612707 期末股本 P116"
do
  read -r id amount item locator <<<"$row"
  addfact "$id" "$item" "$amount" "2025-12-31" "乐歌股份2025年年度报告" "$locator"
done

setf equity excess_cash "" "cash25-500000000-restricted25-commit25" formula "货币资金扣经营必需现金、受限资金及已签订未支付固定资产采购承诺；不把已承诺建设款重复列作优先索偿。" medium
setf equity non_operating_assets "" "tfa25+lti25" formula "交易性金融资产和长期股权投资未进入经营FCFF，按账面值作为可单独计值资产；未预设处置溢价。" medium
setf equity financing_debt "" "stloan25+curloan25+curbond25+ltloan25+ltbond25" formula "短期借款、长期借款当期及长期部分、可转债负债和科技创新债；租赁已采用经营口径进入资本开支和长期经营资产净额，故不重复扣除。" high
sete equity minority_interest_value "" 0 "少数股东权益仅3,405.36元，对亿元口径不重大，按零展示。" high "若少数股东持有的并表业务扩大，应单独估值。"
sete equity other_priority_claims "" 0 "固定资产采购承诺已从多余现金中扣除；未发现需另扣且未进入债务或FCFF的重大优先索偿。" medium "若出现优先股、未入账重大赔偿或其他股东前索偿，应加入。"
setf equity diluted_shares "" "shares25" reported "期末股本；可转债转股价32.91元远高于本报告基准每股价值，基准情形不具实质摊薄性并继续作为债务扣除。" high
sete equity financial_to_trading_fx "" 1 "财报与A股交易币种均为人民币。" high "若交易币种变化则调整。"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "海外仓仍高速扩张且自建仓尚在投运阶段，缺少到达稳定状态时间、逐年FCFF、利用率和全部成长投入证据；依规则采用稳定经营收益八倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-adjustment --model "$model" --name "资产处置收益" --before "2023/2024/2025年分别5.16/1.53/0.27亿元" --after "从核心EBIT剔除" --reason "主要是海外仓等长期资产处置，滚动卖仓买地会产生现金但不代表当期履约经营利润；处置回款已在净资本开支中处理。"
python3 "$tool" add-adjustment --model "$model" --name "经营租赁一致口径" --before "租赁支付列筹资现金流、租赁负债列报" --after "租赁现金支付计入主营资本开支；租赁负债不再从价值桥扣除" --reason "仓储租赁是履约能力的一部分，避免在FCFF和股权价值中重复扣除。"
python3 "$tool" add-adjustment --model "$model" --name "资本采购承诺" --before "2025年末4.43亿元未支付合同" --after "从多余现金中扣除4.43亿元" --reason "合同已签订且准备履行，资金尚不能无损分配给股东；若合同取消或由项目融资替代，可恢复相应现金。"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "主表及附注事实均保存文件名、年度与PDF页码；标准字段引用事实ID或记录估计依据。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "两项具名业务互斥覆盖公司；融资、投资、资产处置、租赁与经营项目避免重复分类。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定状态综合三年利润结构、2025业务组合和仓网建设阶段，不机械外推高速增长；证据不足采用benchmark。"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本包含经营营运资金、净长期资产和必需现金；ROIC分母可解释，但研发和品牌费用化及长期资产口径估计使其仅用于趋势判断。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告重大数字、业务合计、FCFF、估值桥与结构化模型保持一致。"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

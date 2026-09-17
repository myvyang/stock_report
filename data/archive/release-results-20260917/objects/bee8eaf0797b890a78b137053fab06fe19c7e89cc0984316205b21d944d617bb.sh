#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json
ar23=https://www1.hkexnews.hk/listedco/listconews/sehk/2024/0424/2024042401139.pdf
ar24=https://www1.hkexnews.hk/listedco/listconews/sehk/2025/0417/2025041700745.pdf
ar25=https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0423/2026042300830.pdf
hkma=https://api.hkma.gov.hk/public/market-data-and-statistics/monthly-statistical-bulletin/er-ir/er-eeri-daily

python3 "$tool" init --name 华润啤酒 --code 00291.HK --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2023,2024,2025 --financial-currency 人民币 --trading-currency 港元 --security-name 普通股 --security-unit 股 --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "$5" --scope "$6" --source "$7" --locator "$8"
}

# Consolidated operating facts (currency unit: RMB, not RMB million).
fact revenue_2023 营业额 38932000000 2023 人民币 consolidated "$ar24" "2024年报PDF第317页（报告内第315页）"
fact cost_2023 销售成本 22829000000 2023 人民币 consolidated "$ar24" "2024年报PDF第317页（报告内第315页）"
fact ocf_2023 经营活动现金流入净额 4149000000 2023 人民币 consolidated "$ar24" "2024年报PDF第321页（报告内第319页）"
fact tax_paid_2023 已付中国内地所得税 2015000000 2023 人民币 consolidated "$ar24" "2024年报PDF第321页（报告内第319页）"
fact tax_refund_2023 退还中国内地所得税 706000000 2023 人民币 consolidated "$ar24" "2024年报PDF第321页（报告内第319页）"
fact da_2023 折旧及摊销 2277000000 2023 人民币 consolidated "$ar24" "2024年报PDF第357页（报告内第355页）"
fact ppe_buy_2023 购入固定资产及使用权资产 2520000000 2023 人民币 consolidated "$ar24" "2024年报PDF第321页（报告内第319页）"
fact lease_principal_2023 租赁付款本金 81000000 2023 人民币 consolidated "$ar24" "2024年报PDF第322页（报告内第320页）"
fact asset_disposal_2023 出售固定资产及使用权资产所得款 157000000 2023 人民币 consolidated "$ar24" "2024年报PDF第321页（报告内第319页）"
fact adjusted_ebitda_2023 管理层特殊项目调整后EBITDA 8505000000 2023 人民币 consolidated "$ar23" "2023年报PDF第27-29页；以披露的分部EBIT、折旧摊销及特殊项目重构"

fact revenue_2024 营业额 38635000000 2024 人民币 consolidated "$ar25" "2025年报PDF第157页（报告内第155页）"
fact cost_2024 销售成本 22160000000 2024 人民币 consolidated "$ar25" "2025年报PDF第157页（报告内第155页）"
fact ocf_2024 经营活动现金流入净额 6928000000 2024 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact tax_paid_2024 已付中国内地所得税 2553000000 2024 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact tax_refund_2024 退还中国内地所得税 539000000 2024 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact da_2024 折旧及摊销 2350000000 2024 人民币 consolidated "$ar25" "2025年报PDF第197页（报告内第195页）"
fact ppe_buy_2024 购入固定资产及使用权资产 2813000000 2024 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact lease_principal_2024 租赁付款本金 94000000 2024 人民币 consolidated "$ar25" "2025年报PDF第162页（报告内第160页）"
fact asset_disposal_2024 出售固定资产及使用权资产所得款 120000000 2024 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact adjusted_ebitda_2024 管理层特殊项目调整后EBITDA 8694000000 2024 人民币 consolidated "$ar24" "2024年报PDF第32页（报告内第30页）"

fact revenue_2025 营业额 37985000000 2025 人民币 consolidated "$ar25" "2025年报PDF第157页（报告内第155页）"
fact cost_2025 销售成本 21625000000 2025 人民币 consolidated "$ar25" "2025年报PDF第157页（报告内第155页）"
fact ocf_2025 经营活动现金流入净额 7127000000 2025 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact tax_paid_2025 已付中国内地所得税 2237000000 2025 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact tax_refund_2025 退还中国内地所得税 435000000 2025 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact da_2025 折旧及摊销 2426000000 2025 人民币 consolidated "$ar25" "2025年报PDF第196页（报告内第194页）"
fact ppe_buy_2025 购入固定资产及使用权资产 1799000000 2025 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact lease_principal_2025 租赁付款本金 83000000 2025 人民币 consolidated "$ar25" "2025年报PDF第162页（报告内第160页）"
fact asset_disposal_2025 出售固定资产及使用权资产所得款 305000000 2025 人民币 consolidated "$ar25" "2025年报PDF第161页（报告内第159页）"
fact adjusted_ebitda_2025 管理层特殊项目调整后EBITDA 9879000000 2025 人民币 consolidated "$ar25" "2025年报PDF第32页（报告内第30页）"

# Balance-sheet facts for the operating-capital reconstruction.
fact stock_2022 存货 7402000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第267页（报告内第265页）"
fact op_receivables_2022 经营性贸易及其他应收款 701000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第327页（总额扣短期存款、合营及同系贷款）"
fact op_payables_2022 经营性贸易及其他应付款 22785000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第329页（总额扣出资及关联方资金款）"
fact fixed_2022 固定资产 14050000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第267页（报告内第265页）"
fact rou_2022 使用权资产 3156000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第267页（报告内第265页）"
fact intangible_2022 其他无形资产 203000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第267页（报告内第265页）"
fact goodwill_2022 商誉 9385000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第267页（报告内第265页）"
fact grants_other_2022 资产相关政府补助及其他长期经营负债 2753000000 2022-12-31 人民币 consolidated "$ar23" "2023年报PDF第333页（政府补助2,447及其他306百万元）"

fact stock_2023 存货 9502000000 2023-12-31 人民币 consolidated "$ar24" "2024年报PDF第319页（报告内第317页）"
fact op_receivables_2023 经营性贸易及其他应收款 1283000000 2023-12-31 人民币 consolidated "$ar24" "2024年报PDF第381页（总额扣收购退款及同系贷款）"
fact op_payables_2023 经营性贸易及其他应付款 22705000000 2023-12-31 人民币 consolidated "$ar24" "2024年报PDF第383页（总额扣出资及关联方资金款）"
fact fixed_2023 固定资产 16294000000 2023-12-31 人民币 consolidated "$ar24" "2024年报PDF第319页（报告内第317页）"
fact rou_2023 使用权资产 3229000000 2023-12-31 人民币 consolidated "$ar24" "2024年报PDF第319页（报告内第317页）"
fact intangible_2023 其他无形资产 8991000000 2023-12-31 人民币 consolidated "$ar24" "2024年报PDF第319页（报告内第317页）"
fact goodwill_2023 商誉 16806000000 2023-12-31 人民币 consolidated "$ar24" "2024年报PDF第319页（报告内第317页）"
fact grants_other_2023 资产相关政府补助及其他长期经营负债 3008000000 2023-12-31 人民币 consolidated "$ar23" "2023年报PDF第333页（政府补助2,706及其他302百万元）"

fact stock_2024 存货 9640000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact op_receivables_2024 经营性贸易及其他应收款 1646000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact op_payables_2024 经营性贸易及其他应付款 24245000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第225页（总额扣出资及关联方资金款）"
fact fixed_2024 固定资产 18124000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact rou_2024 使用权资产 3050000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact intangible_2024 其他无形资产 8258000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact goodwill_2024 商誉 16806000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact grants_other_2024 资产相关政府补助及其他长期经营负债 2629000000 2024-12-31 人民币 consolidated "$ar25" "2025年报PDF第229页（政府补助2,320及其他309百万元）"

fact stock_2025 存货 9240000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact op_receivables_2025 经营性贸易及其他应收款 1351000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第223页（总额扣同系公司贷款251百万元）"
fact op_payables_2025 经营性贸易及其他应付款 23385000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第225页（总额扣出资及关联方资金款）"
fact fixed_2025 固定资产 17963000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact rou_2025 使用权资产 2935000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact intangible_2025 其他无形资产 7530000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact goodwill_2025 商誉 13929000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact grants_other_2025 资产相关政府补助及其他长期经营负债 2459000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第229页（政府补助2,181及其他278百万元）"

# Latest-year equity bridge and business facts.
fact cash_2025 现金及现金等价物 6918000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159页（报告内第157页）"
fact nonop_2025 非经营资产合计 6133000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159、217-223页：合联营1,700、FVPL4,155、受限及质押27、同系贷款251百万元"
fact debt_2025 融资负债合计 3404000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第159-160、225页：银行贷款2,711、租赁93、合营借款600百万元"
fact nci_2025 非控制股东权益账面值 3702000000 2025-12-31 人民币 consolidated "$ar25" "2025年报PDF第160及242页（报告内第158及240页）"
fact shares_2025 已发行普通股 3244000000 2025-12-31 股 parent "$ar25" "2025年报PDF第230页（报告内第228页）"
fact cny_hkd_2025 人民币兑港元收市中间价 1.1144 2025-12-31 港元 market "$hkma" "end_of_day=2025-12-31；cny字段，单位为每人民币港元"
fact beer_revenue_2025 啤酒业务营业额 36489000000 2025 人民币 segment "$ar25" "2025年报PDF第33页（报告内第31页）"
fact beer_gpm_2025 啤酒业务毛利率 0.425 2025 ratio segment "$ar25" "2025年报PDF第33页（报告内第31页）"
fact beer_adj_ebitda_2025 啤酒特殊项目调整后EBITDA 9611000000 2025 人民币 segment "$ar25" "2025年报PDF第33页（报告内第31页）"
fact baijiu_revenue_2025 白酒业务营业额 1496000000 2025 人民币 segment "$ar25" "2025年报PDF第35页（报告内第33页）"
fact baijiu_adj_ebitda_2025 白酒剔除商誉减值后EBITDA 264000000 2025 人民币 segment "$ar25" "2025年报PDF第35页（报告内第33页）"
fact jinsha_ocf_2025 贵州金沙经营活动现金流出净额 -476000000 2025 人民币 subsidiary "$ar25" "2025年报PDF第243页（报告内第241页）"

setf() {
  python3 "$tool" set-field --model "$model" "$@"
}

for y in 2023 2024 2025; do
  setf --view historical --year "$y" --field revenue --expression "revenue_$y" --basis-type reported --reason "合并损益表营业额。" --confidence high
  setf --view historical --year "$y" --field cost_of_revenue --expression "cost_$y" --basis-type reported --reason "合并损益表销售成本。" --confidence high
  setf --view historical --year "$y" --field cash_tax --expression "tax_paid_$y - tax_refund_$y" --basis-type formula --reason "以现金流量表内地所得税实付减退税作为经营现金税代表值。" --confidence medium
  setf --view historical --year "$y" --field depreciation_amortization --expression "da_$y" --basis-type reported --reason "分部资料披露的合并折旧及摊销。" --confidence high
  setf --view historical --year "$y" --field core_business_capex --expression "ppe_buy_$y + lease_principal_$y - asset_disposal_$y" --basis-type formula --reason "经营资产购置加租赁本金、减经营资产处置回款；均服务既有酒类业务。" --confidence high
  setf --view historical --year "$y" --field exploratory_business_capex --value 0 --basis-type estimate --reason "公开披露未识别能与既有啤酒、白酒经营资产可靠分开的新业务现金资本开支。" --confidence medium --falsifier "后续披露独立新业务项目现金支出、商业化里程碑及资产归属。"
  setf --view historical --year "$y" --field operating_cash_flow --expression "ocf_$y" --basis-type reported --reason "合并现金流量表经营活动现金流入净额。" --confidence high
  setf --view historical --year "$y" --field after_tax_interest_in_operating_cash_flow --value 0 --basis-type estimate --reason "利息支付列于融资活动，经营现金流无需加回税后利息。" --confidence high --falsifier "现金流分类政策改变或有重大利息计入经营活动。"
done

setf --view historical --year 2023 --field period_operating_expenses --value 9875000000 --basis-type estimate --reason "以管理层特殊项目调整后EBITDA8,505百万元减折旧摊销重构EBIT，再由毛利倒算期间经营费用。" --confidence medium --falsifier "公司发布不同口径的2023调整后EBITDA对账。"
setf --view historical --year 2023 --field operating_working_capital_increase --value 3047000000 --basis-type estimate --reason "以调整后利润路径与现金流路径闭合，剔除特殊项目的非现金及应计影响。" --confidence medium --falsifier "公司披露剔除特殊项目后的营运资金完整对账。"
setf --view historical --year 2024 --field period_operating_expenses --value 10131000000 --basis-type estimate --reason "以管理层披露调整后EBITDA8,694百万元减折旧摊销重构EBIT，再由毛利倒算。" --confidence high --falsifier "公司发布不同口径的调整后EBITDA对账。"
setf --view historical --year 2024 --field operating_working_capital_increase --value -248000000 --basis-type estimate --reason "以调整后利润路径与现金流路径闭合，表示小幅营运资金释放。" --confidence medium --falsifier "公司披露剔除特殊项目后的营运资金完整对账。"
setf --view historical --year 2025 --field period_operating_expenses --value 8907000000 --basis-type estimate --reason "以管理层披露调整后EBITDA9,879百万元减折旧摊销重构EBIT，再由毛利倒算。" --confidence high --falsifier "公司发布不同口径的调整后EBITDA对账。"
setf --view historical --year 2025 --field operating_working_capital_increase --value 950000000 --basis-type estimate --reason "以调整后利润路径与现金流路径闭合，反映存货、应收应付及特殊项目应计调整后的经济占用。" --confidence medium --falsifier "公司披露剔除特殊项目后的营运资金完整对账。"

for y in 2022 2023 2024 2025; do
  setf --view capital --year "$y" --field operating_working_capital --expression "stock_$y + op_receivables_$y - op_payables_$y" --basis-type formula --reason "存货加经营性应收、减经营性应付；剔除贷款、收购退款及出资款。" --confidence medium
  setf --view capital --year "$y" --field operating_long_term_assets_net --expression "fixed_$y + rou_$y + intangible_$y + goodwill_$y - grants_other_$y" --basis-type formula --reason "固定资产、使用权资产、经营性无形资产及商誉，扣资产相关政府补助和其他长期经营负债。" --confidence medium
  setf --view capital --year "$y" --field required_cash --value 3000000000 --basis-type estimate --reason "约覆盖一个月现金经营成本，并考虑负营运资金模式及未使用授信后的最低结算缓冲。" --confidence low --falsifier "月度现金成本、季节性峰值或受限资金资料显示所需缓冲显著偏离30亿元。"
  setf --view capital --year "$y" --field unsupported_intangible_assets --expression "goodwill_$y" --basis-type formula --reason "依研究纪律将商誉全额剔除；品牌及客户关系等可识别无形资产仍留在经营投入。" --confidence high
done

# Stable-state benchmark.
setf --view stable --field revenue --value 38000000000 --basis-type estimate --reason "接近2024-2025收入水平；假定啤酒量缩与高端化大致抵销，白酒不恢复至收购时高预期。" --confidence medium --falsifier "啤酒销量或吨价连续两年使收入偏离380亿元10%以上。"
setf --view stable --field cost_of_revenue --value 21660000000 --basis-type estimate --reason "采用约43%常态毛利率，介于2025集团和啤酒披露水平。" --confidence medium --falsifier "原料、包装或产品结构令毛利率连续两年低于40%或高于45%。"
setf --view stable --field period_operating_expenses --value 9340000000 --basis-type estimate --reason "对应70亿元常态EBIT，低于2025调整后水平以保留竞争和白酒修复不确定性。" --confidence medium --falsifier "销售投入或组织成本使调整后费用率持续高于27%。"
setf --view stable --field cash_tax --value 1750000000 --basis-type estimate --reason "按常态EBIT的25%中国企业所得税率估计。" --confidence medium --falsifier "持续税收优惠、亏损抵扣或预提税使现金税率显著偏离25%。"
setf --view stable --field depreciation_amortization --value 2400000000 --basis-type estimate --reason "取近两年折旧摊销约24亿元的常态水平。" --confidence high --falsifier "产能关停或无形资产摊销到期使折旧摊销偏离20%。"
setf --view stable --field core_business_capex --value 2400000000 --basis-type estimate --reason "约等于常态折旧摊销，覆盖厂房更新、搬迁、环保和既有产能优化。" --confidence medium --falsifier "连续三年现金资本开支显著高于或低于折旧且产能质量同步改变。"
setf --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason "没有可独立验证商业化路径与资金需求的新业务项目，故不另列价值。" --confidence medium --falsifier "披露独立新业务项目及其可验证资本预算。"
setf --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason "稳定期收入不增长，成熟负营运资金模式不假设永久额外释放。" --confidence medium --falsifier "渠道条款或库存制度造成持续结构性资金占用。"

# Equity bridge.
setf --view equity --field excess_cash --value 3918000000 --basis-type estimate --reason "现金69.18亿元减经营必需现金30亿元；受限和质押存款另列非经营资产。" --confidence low --falsifier "季节性资金需求、已承诺资本开支或分配限制要求更高现金缓冲。"
setf --view equity --field non_operating_assets --expression nonop_2025 --basis-type reported --reason "合联营、搬迁应收对价、银行理财、受限及质押资金和同系公司贷款均未进入核心FCFF。" --confidence medium
setf --view equity --field financing_debt --expression debt_2025 --basis-type reported --reason "银行借款、租赁负债及合营企业资金借款。" --confidence high
setf --view equity --field minority_interest_value --expression nci_2025 --basis-type reported --reason "贵州金沙缺乏可靠独立稳定收益估值，采用非控制权益账面值作为谨慎替代。" --confidence low
setf --view equity --field other_priority_claims --value 0 --basis-type estimate --reason "未识别已在经营资本或融资负债之外的重大优先索偿。" --confidence medium --falsifier "出现已宣告未付而未计负债的重大分派、担保赔付或建设付款义务。"
setf --view equity --field diluted_shares --expression shares_2025 --basis-type reported --reason "年末已发行股份3,244百万股；年内无权益挂钩协议。" --confidence high
setf --view equity --field financial_to_trading_fx --expression cny_hkd_2025 --basis-type reported --reason "香港金管局2025年12月31日人民币兑港元每日收市中间价。" --confidence high

# Latest-year economic businesses.
python3 "$tool" add-business --model "$model" --business-id beer --name 啤酒 --importance "收入占96%，经高端化、全国生产网络和渠道覆盖形成主要利润与现金。" --confidence high --falsifier "啤酒收入或调整后EBITDA与分部披露无法对账。"
python3 "$tool" add-business --model "$model" --business-id baijiu --name 白酒 --importance "收入占4%，但并购投入、无形资产、商誉减值及非控股权益对资本价值影响重大。" --confidence medium --falsifier "白酒分部恢复稳定盈利并持续产生正经营现金流。"

busf() { python3 "$tool" set-business-field --model "$model" "$@"; }
busf --business-id beer --field revenue --expression beer_revenue_2025 --basis-type reported --reason "分部外部销售。" --confidence high
busf --business-id beer --field cost_of_revenue --value 20981175000 --basis-type estimate --reason "啤酒收入乘以披露的57.5%销售成本率。" --confidence high --falsifier "分部成本附注显示不同金额。"
busf --business-id beer --field period_operating_expenses --value 7577825000 --basis-type estimate --reason "由合并调整后EBIT硬约束分配；以披露的啤酒调整后EBITDA与分部折旧为主要锚。" --confidence medium --falsifier "公司披露完整的啤酒调整后EBIT及总部费用归属。"
busf --business-id beer --field cash_tax --value 1802000000 --basis-type estimate --reason "白酒调整后EBIT为负，合并经营现金税全部归于盈利的啤酒业务。" --confidence medium --falsifier "分部现金税或白酒当期税款资料显示白酒承担重大税款。"
busf --business-id beer --field operating_cash_flow_contribution --value 7603000000 --basis-type estimate --reason "合并经营现金流扣除贵州金沙披露的经营现金流出，作为啤酒及总部贡献。" --confidence medium --falsifier "完整白酒分部现金流与贵州金沙子公司现金流差异重大。"

busf --business-id baijiu --field revenue --expression baijiu_revenue_2025 --basis-type reported --reason "分部外部销售。" --confidence high
busf --business-id baijiu --field cost_of_revenue --value 643825000 --basis-type estimate --reason "合并销售成本减按披露毛利率估算的啤酒成本。" --confidence medium --falsifier "公司披露白酒分部完整销售成本。"
busf --business-id baijiu --field period_operating_expenses --value 1329175000 --basis-type estimate --reason "由白酒剔除商誉减值后的EBITDA2.64亿元、分部折旧摊销7.41亿元倒算。" --confidence medium --falsifier "白酒调整后EBIT或费用明细显示不同水平。"
busf --business-id baijiu --field cash_tax --value 0 --basis-type estimate --reason "白酒调整后EBIT为负，不计当期经营现金税。" --confidence medium --falsifier "白酒分部披露正应税利润及现金税。"
busf --business-id baijiu --field operating_cash_flow_contribution --expression jinsha_ocf_2025 --basis-type reported --reason "贵州金沙构成白酒主要经营主体，以其披露经营现金流出作为分部代表值。" --confidence medium

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "缺少白酒恢复路径及逐年成长投入的可靠证据，采用稳定经营收益八倍固定标尺。" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name 2025年三项特殊项目 --before "账面EBITDA 77.01亿元" --after "调整后EBITDA 98.79亿元" --reason "剔除搬迁协议收益10.05亿元、白酒商誉减值28.77亿元及产能优化费用3.06亿元。"
python3 "$tool" add-adjustment --model "$model" --name 商誉 --before "账面139.29亿元" --after "投入资本中全额剔除" --reason "商誉不是可独立取回的经营资产，价值仅由稳定经营收益反推。"
python3 "$tool" add-adjustment --model "$model" --name 非控制股东权益 --before "账面37.02亿元" --after "经济价值暂按37.02亿元" --reason "主要为贵州金沙44.81%非控股权益，独立稳定收益证据不足，账面值作为替代。"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "ROIC分母纳入负营运资金、经营现金和可识别无形资产；2023收购导致期初期末边界跳变，正文限制解读。"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "重大金额均链接港交所年报并保存PDF页码；汇率链接香港金管局数据接口。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "经营、非经营、融资及少数股东项目互斥；关联贷款及搬迁应收未进入经营资本。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期收入、毛利、费用、税、折旧、资本开支和营运资金相互一致，且未给白酒修复额外项目价值。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "正文中心判断及重大数字与结构化模型一致，转写表由程序生成。"

python3 "$tool" compile --model "$model"

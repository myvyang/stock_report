#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"

python3 "$tool" init --name "天工國際" --code "00826.HK" \
  --period-label "截至2025年12月31日止年度" --period-end "2025-12-31" \
  --coverage-years "2023,2024,2025" --financial-currency "人民币" \
  --trading-currency "港元" --security-name "普通股" --security-unit "股" --output "$model"

add_fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" \
    --amount "$3" --period "$4" --currency "$5" --scope "$6" --source "$7" --locator "$8"
}

set_field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" --field "$2" ${3:+--year "$3"} \
    --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7"
}

src23="Tiangong International Company Limited, Annual Report 2023, 25 March 2024, https://www1.hkexnews.hk/listedco/listconews/sehk/2024/0426/2024042600646.pdf"
src24="Tiangong International Company Limited, Annual Report 2024, 31 March 2025, https://www1.hkexnews.hk/listedco/listconews/sehk/2025/0425/2025042501661.pdf"
src25="Tiangong International Company Limited, Annual Report 2025, 30 March 2026, https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0429/2026042904250.pdf"

# Consolidated income statement, tax, non-cash charges, capital expenditure and cash flow facts.
add_fact revenue_2023 "Revenue" 5163306000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.107 (annual report p.106)"
add_fact cost_sales_2023 "Cost of sales" 4019922000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.107 (annual report p.106)"
add_fact op_profit_2023 "Profit from operations" 626619000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.107 (annual report p.106)"
add_fact dividend_income_2023 "Dividend income" 14367000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.143 (annual report p.142), note 6"
add_fact fv_loss_2023 "Unrealised fair value losses of other financial assets" 4420000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.143 (annual report p.142), note 6"
add_fact trading_gain_2023 "Net gains on trading securities" 70000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.143 (annual report p.142), note 6"
add_fact subsidiary_disposal_loss_2023 "Losses from disposal of interest in subsidiaries" 804000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.143 (annual report p.142), note 7"
add_fact current_tax_2023 "Current tax provision" 66090000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF pp.146-147 (annual report pp.145-146), note 9"
add_fact ppe_da_2023 "Depreciation of property, plant and equipment" 371974000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.145 (annual report p.144), note 8(c)"
add_fact lease_da_2023 "Amortisation of lease prepayments" 6158000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.145 (annual report p.144), note 8(c)"
add_fact intangible_da_2023 "Amortisation of intangible assets" 8215000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.145 (annual report p.144), note 8(c)"
add_fact ppe_capex_2023 "Payment for purchase of property, plant and equipment" 277791000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.113 (annual report p.112)"
add_fact lease_capex_2023 "Payment for lease prepayments" 21185000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.113 (annual report p.112)"
add_fact intangible_capex_2023 "Payment for purchase of intangible assets" 181000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.113 (annual report p.112)"
add_fact cfo_2023 "Net cash generated from operating activities" 55129000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.113 (annual report p.112)"
add_fact interest_paid_2023 "Interest paid, classified as financing cash flow" 140894000 "2023-01-01/2023-12-31" "RMB" "consolidated" "$src23" "PDF p.114 (annual report p.113)"

add_fact revenue_2024 "Revenue" 4832036000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.133 (annual report p.132)"
add_fact cost_sales_2024 "Cost of sales" 3848493000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.133 (annual report p.132)"
add_fact op_profit_2024 "Profit from operations" 542518000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.133 (annual report p.132)"
add_fact dividend_income_2024 "Dividend income" 12476000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.169 (annual report p.168), note 6"
add_fact fv_loss_2024 "Unrealised fair value losses of other financial assets" 4769000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.169 (annual report p.168), note 6"
add_fact trading_loss_2024 "Net losses on trading securities" 5380000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.169 (annual report p.168), note 6"
add_fact current_tax_2024 "Current tax provision" 60431000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.172 (annual report p.171), note 9"
add_fact ppe_da_2024 "Depreciation of property, plant and equipment" 386994000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.171 (annual report p.170), note 8(c)"
add_fact lease_da_2024 "Amortisation of lease prepayments" 6158000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.171 (annual report p.170), note 8(c)"
add_fact intangible_da_2024 "Amortisation of intangible assets" 7684000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.171 (annual report p.170), note 8(c)"
add_fact ppe_capex_2024 "Payment for purchase of property, plant and equipment" 287689000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.139 (annual report p.138)"
add_fact intangible_capex_2024 "Payment for purchase of intangible assets" 1604000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.139 (annual report p.138)"
add_fact cfo_2024 "Net cash generated from operating activities" 501762000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.139 (annual report p.138)"
add_fact interest_paid_2024 "Interest paid, classified as financing cash flow" 204035000 "2024-01-01/2024-12-31" "RMB" "consolidated" "$src24" "PDF p.140 (annual report p.139)"

add_fact revenue_2025 "Revenue" 4718830000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.143 (annual report p.142)"
add_fact cost_sales_2025 "Cost of sales" 3766941000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.143 (annual report p.142)"
add_fact op_profit_2025 "Profit from operations" 587693000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.143 (annual report p.142)"
add_fact dividend_income_2025 "Dividend income" 8185000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.178 (annual report p.177), note 6"
add_fact fv_gain_2025 "Unrealised fair value gains of other financial assets" 322000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.178 (annual report p.177), note 6"
add_fact trading_gain_2025 "Net gains on trading securities" 2618000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.178 (annual report p.177), note 6"
add_fact subsidiary_disposal_gain_2025 "Net gains on disposal of interest in subsidiaries" 20251000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.178 (annual report p.177), note 6"
add_fact current_tax_2025 "Current tax provision" 42922000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF pp.181-182 (annual report pp.180-181), note 9"
add_fact ppe_da_2025 "Depreciation of property, plant and equipment" 386693000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.180 (annual report p.179), note 8(c)"
add_fact lease_da_2025 "Amortisation of lease prepayments" 6380000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.180 (annual report p.179), note 8(c)"
add_fact intangible_da_2025 "Amortisation of intangible assets" 8436000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.180 (annual report p.179), note 8(c)"
add_fact ppe_capex_2025 "Payment for purchase of property, plant and equipment" 324734000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.149 (annual report p.148)"
add_fact lease_capex_2025 "Payment for purchase of lease prepayments" 3502000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.149 (annual report p.148)"
add_fact intangible_capex_2025 "Payment for purchase of intangible assets" 482000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.149 (annual report p.148)"
add_fact cfo_2025 "Net cash generated from operating activities" 294439000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.149 (annual report p.148)"
add_fact interest_paid_2025 "Interest paid, classified as financing cash flow" 160800000 "2025-01-01/2025-12-31" "RMB" "consolidated" "$src25" "PDF p.150 (annual report p.149)"

# Balance-sheet operating capital facts for opening 2022 and each covered year.
for row in \
  "2022 inventory 2583470000" "2022 receivables 2632708000" "2022 tax_recoverable 0" "2022 payables 1659779000" "2022 ppe 4607596000" "2022 lease 233842000" "2022 intangibles 65333000" "2022 deferred_income 42530000" "2022 goodwill 144600000" \
  "2023 inventory 2477492000" "2023 receivables 3552788000" "2023 tax_recoverable 109877000" "2023 payables 1583176000" "2023 ppe 4506918000" "2023 lease 248869000" "2023 intangibles 57721000" "2023 deferred_income 37788000" "2023 goodwill 144600000" \
  "2024 inventory 2524870000" "2024 receivables 3543048000" "2024 tax_recoverable 99114000" "2024 payables 1452755000" "2024 ppe 4392861000" "2024 lease 242711000" "2024 intangibles 56224000" "2024 deferred_income 30098000" "2024 goodwill 144600000" \
  "2025 inventory 2581705000" "2025 receivables 4037664000" "2025 tax_recoverable 27824000" "2025 payables 1402457000" "2025 ppe 4328594000" "2025 lease 239833000" "2025 intangibles 50358000" "2025 deferred_income 22137000" "2025 goodwill 144600000"
do
  set -- $row
  year="$1"; item="$2"; value="$3"
  if [[ "$year" == "2022" || "$year" == "2023" ]]; then src="$src23"; pages="PDF pp.109-110 (annual report pp.108-109)"; else src="$src25"; pages="PDF pp.145-146 (annual report pp.144-145)"; fi
  add_fact "${item}_${year}" "$item" "$value" "$year-12-31" "RMB" "consolidated" "$src" "$pages"
done

# Equity bridge and market observations.
add_fact cash_2025 "Cash and cash equivalents" 1069583000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF p.145 (annual report p.144)"
add_fact time_deposits_2025 "Time deposits" 603324000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF p.145 (annual report p.144)"
add_fact associates_2025 "Interest in associates" 197705000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF p.145 (annual report p.144)"
add_fact joint_ventures_2025 "Interest in joint ventures" 25551000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF p.145 (annual report p.144)"
add_fact other_fin_assets_2025 "Other financial assets" 276203000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF p.145 (annual report p.144)"
add_fact fvpl_assets_2025 "Financial assets measured at FVPL" 8961000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF p.145 (annual report p.144)"
add_fact borrowings_2025 "Interest-bearing borrowings" 3434032000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF pp.145-146 (annual report pp.144-145)"
add_fact other_fin_liability_2025 "Other financial liability" 893571000 "2025-12-31" "RMB" "consolidated" "$src25" "PDF p.145 (annual report p.144); cash repayment classified as financing on PDF p.150"
add_fact issued_shares_2025 "Ordinary shares issued and fully paid" 2725000000 "2025-12-31" "shares" "parent company" "$src25" "PDF p.210 (annual report p.209), note 33(c)"
add_fact rmb_to_hkd_2025 "One RMB translated into HKD at 31 December 2025 central parity" 1.10715 "2025-12-31" "HKD/RMB" "market" "China Foreign Exchange Trade System announcement, 31 December 2025, https://www.ce.cn/xwzx/gnsz/gdxw/202512/t20251231_2676993.shtml" "1 HKD = RMB0.90322; inverted"
add_fact current_price_20260908 "Closing price of Tiangong International" 3.23 "2026-09-08" "HKD/share" "market" "Investing.com historical data, accessed 9 September 2026, https://hk.investing.com/equities/tiangong-international-co-ltd-historical-data" "8 September 2026 close"

# Historical operating fields. EBIT excludes financial investments and subsidiary disposal gains/losses.
set_field_expr historical revenue 2023 revenue_2023 reported "合并收入原值" high
set_field_expr historical cost_of_revenue 2023 cost_sales_2023 reported "合并销售成本原值" high
set_field_expr historical period_operating_expenses 2023 "revenue_2023 - cost_sales_2023 - (op_profit_2023 - dividend_income_2023 + fv_loss_2023 - trading_gain_2023 + subsidiary_disposal_loss_2023)" formula "由调整后EBIT反推；剔除金融投资收益及子公司处置损失" high
set_field_expr historical cash_tax 2023 current_tax_2023 reported "以当期所得税拨备近似经营现金税，避免递延税扰动" medium
set_field_expr historical depreciation_amortization 2023 "ppe_da_2023 + lease_da_2023 + intangible_da_2023" formula "经营性长期资产折旧摊销合计" high
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field core_business_capex --value 269157000 --basis-type estimate --reason "总现金资本开支2.99157亿元；依据资本承诺主要用于已产生收入的钛合金扩产和生产线升级，基准估计0.30亿元属于新应用开拓" --confidence medium --falsifier "若项目级付款表明新应用或未商业化产线现金支出不同，则重分主营与开拓资本开支"
python3 "$tool" set-field --model "$model" --view historical --year 2023 --field exploratory_business_capex --value 30000000 --basis-type estimate --reason "将钛合金新应用及新产线早期投入估计为总资本开支约10%" --confidence low --falsifier "项目级资本开支按产品与商业化阶段披露"
set_field_expr historical operating_working_capital_increase 2023 "op_profit_2023 - dividend_income_2023 + fv_loss_2023 - trading_gain_2023 + subsidiary_disposal_loss_2023 - current_tax_2023 + ppe_da_2023 + lease_da_2023 + intangible_da_2023 - cfo_2023" formula "现金流调整后的经营性营运资金净投入，用于将利润路径闭合至经营现金流；包含营运项目及小额非现金经营调整" medium
set_field_expr historical operating_cash_flow 2023 cfo_2023 reported "合并经营活动现金流净额" high
set_field_expr historical after_tax_interest_in_operating_cash_flow 2023 "interest_paid_2023 - interest_paid_2023" formula "利息支付在融资活动列示，经营现金流无需加回" high

set_field_expr historical revenue 2024 revenue_2024 reported "合并收入原值" high
set_field_expr historical cost_of_revenue 2024 cost_sales_2024 reported "合并销售成本原值" high
set_field_expr historical period_operating_expenses 2024 "revenue_2024 - cost_sales_2024 - (op_profit_2024 - dividend_income_2024 + fv_loss_2024 + trading_loss_2024)" formula "由调整后EBIT反推；剔除金融投资收益及损失" high
set_field_expr historical cash_tax 2024 current_tax_2024 reported "以当期所得税拨备近似经营现金税，避免递延税资产确认导致税费异常偏低" medium
set_field_expr historical depreciation_amortization 2024 "ppe_da_2024 + lease_da_2024 + intangible_da_2024" formula "经营性长期资产折旧摊销合计" high
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field core_business_capex --value 249293000 --basis-type estimate --reason "总现金资本开支2.89293亿元；资本承诺主要是钛棒线等现有钛合金业务扩产，估计0.40亿元服务未稳定的新应用" --confidence medium --falsifier "项目级资本开支按产品与商业化阶段披露"
python3 "$tool" set-field --model "$model" --view historical --year 2024 --field exploratory_business_capex --value 40000000 --basis-type estimate --reason "按钛粉、增材制造及新应用产线仍处开拓阶段估计" --confidence low --falsifier "项目级付款证明相关资产已经稳定盈利或实际投入显著不同"
set_field_expr historical operating_working_capital_increase 2024 "op_profit_2024 - dividend_income_2024 + fv_loss_2024 + trading_loss_2024 - current_tax_2024 + ppe_da_2024 + lease_da_2024 + intangible_da_2024 - cfo_2024" formula "现金流调整后的经营性营运资金净投入；2024年应付款下降是主要现金占用" medium
set_field_expr historical operating_cash_flow 2024 cfo_2024 reported "合并经营活动现金流净额" high
set_field_expr historical after_tax_interest_in_operating_cash_flow 2024 "interest_paid_2024 - interest_paid_2024" formula "利息支付在融资活动列示，经营现金流无需加回" high

set_field_expr historical revenue 2025 revenue_2025 reported "合并收入原值" high
set_field_expr historical cost_of_revenue 2025 cost_sales_2025 reported "合并销售成本原值" high
set_field_expr historical period_operating_expenses 2025 "revenue_2025 - cost_sales_2025 - (op_profit_2025 - dividend_income_2025 - fv_gain_2025 - trading_gain_2025 - subsidiary_disposal_gain_2025)" formula "由调整后EBIT反推；剔除金融投资及子公司处置收益" high
set_field_expr historical cash_tax 2025 current_tax_2025 reported "以当期所得税拨备近似经营现金税；现金流中的退税不代表常态税负" medium
set_field_expr historical depreciation_amortization 2025 "ppe_da_2025 + lease_da_2025 + intangible_da_2025" formula "经营性长期资产折旧摊销合计" high
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field core_business_capex --value 278718000 --basis-type estimate --reason "总现金资本开支3.28718亿元；主体仍用于钛棒线和螺纹刀具等已经营业务，估计0.50亿元用于钛粉、机器人及核聚变材料等未稳定商业化方向" --confidence medium --falsifier "项目级付款按成熟产品与新业务明确拆分"
python3 "$tool" set-field --model "$model" --view historical --year 2025 --field exploratory_business_capex --value 50000000 --basis-type estimate --reason "管理层披露钛粉、人形机器人和核聚变材料仍处验证或商业化开拓阶段" --confidence low --falsifier "这些项目已形成可核验稳定收入利润，或实际资本付款与估计显著不同"
set_field_expr historical operating_working_capital_increase 2025 "op_profit_2025 - dividend_income_2025 - fv_gain_2025 - trading_gain_2025 - subsidiary_disposal_gain_2025 - current_tax_2025 + ppe_da_2025 + lease_da_2025 + intangible_da_2025 - cfo_2025" formula "现金流调整后的经营性营运资金净投入；应收增加及应付下降是主要占用" medium
set_field_expr historical operating_cash_flow 2025 cfo_2025 reported "合并经营活动现金流净额" high
set_field_expr historical after_tax_interest_in_operating_cash_flow 2025 "interest_paid_2025 - interest_paid_2025" formula "利息支付在融资活动列示，经营现金流无需加回" high

# Balance-sheet operating capital, with recoverable/current tax excluded and goodwill removed.
for year in 2022 2023 2024 2025; do
  set_field_expr capital operating_working_capital "$year" "inventory_${year} + receivables_${year} - tax_recoverable_${year} - payables_${year}" formula "存货加经营性应收及预付款，扣除当期可收回税项和经营性应付款" medium
  set_field_expr capital operating_long_term_assets_net "$year" "ppe_${year} + lease_${year} + intangibles_${year} - deferred_income_${year}" formula "经营性固定资产、租赁预付款和可解释无形资产，扣资产相关递延收入" high
  python3 "$tool" set-field --model "$model" --view capital --year "$year" --field required_cash --value 350000000 --basis-type estimate --reason "约一个月现金经营支出的流动性缓冲；公司现金转换周期很长且依赖短期借款，不能将全部现金视为可分配" --confidence medium --falsifier "月度采购、工资、税费及备用信贷数据显示更低或更高的最低现金需求"
  set_field_expr capital unsupported_intangible_assets "$year" "goodwill_${year}" formula "商誉无法由独立可核验收益解释，默认从投入资本中剔除" high
done

# Stable-state benchmark informed by 2023-2025 history and the reviewed 2026 interim recovery.
python3 "$tool" set-field --model "$model" --view stable --field revenue --value 5000000000 --basis-type estimate --reason "介于2024-2025完整年度和2026上半年年化水平之间；不把半年复苏机械外推" --confidence medium --falsifier "连续两个完整年度收入显著低于45亿元或高于55亿元"
python3 "$tool" set-field --model "$model" --view stable --field cost_of_revenue --value 3850000000 --basis-type estimate --reason "采用23%正常毛利率，位于2025年20.2%和2026上半年24.8%之间" --confidence medium --falsifier "产品组合稳定后毛利率连续两年低于20%或高于26%"
python3 "$tool" set-field --model "$model" --view stable --field period_operating_expenses --value 600000000 --basis-type estimate --reason "保留约6%收入的研发强度及正常销售管理成本，剔除金融公允价值和一次性处置收益" --confidence medium --falsifier "研发、销售和管理费用在稳定收入下持续偏离该水平超过15%"
python3 "$tool" set-field --model "$model" --view stable --field cash_tax --value 55000000 --basis-type estimate --reason "按稳定EBIT约10%估计，反映高新技术企业税率及研发加计扣除" --confidence medium --falsifier "税收优惠或研发加计扣除取消，或现金税率连续两年显著偏离10%"
python3 "$tool" set-field --model "$model" --view stable --field depreciation_amortization --value 390000000 --basis-type estimate --reason "接近三年约3.86至4.02亿元折旧摊销，考虑固定资产净额缓慢下降" --confidence high --falsifier "重大新产线投产或资产处置改变折旧基础"
python3 "$tool" set-field --model "$model" --view stable --field core_business_capex --value 320000000 --basis-type estimate --reason "历史现金资本开支约2.89至3.29亿元且固定资产净额下降，取略高于历史中枢的常态主营投入" --confidence medium --falsifier "维持产能和合规所需现金资本开支持续高于4亿元"
python3 "$tool" set-field --model "$model" --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason "基准经营价值不为未验证的新材料项目另行加值；相关实际投入作为当期风险资本处理" --confidence medium --falsifier "新业务形成可核验的稳定收入、利润和所需投入路径"
python3 "$tool" set-field --model "$model" --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason "稳定期假设收入不增长；现有约52亿元经营营运资金存量继续占用，但不应永久逐年增加" --confidence medium --falsifier "即使收入持平，应收账期或库存政策仍持续恶化并形成永久新增占用"

# Equity value bridge.
python3 "$tool" set-field --model "$model" --view equity --field excess_cash --value 1322907000 --basis-type estimate --reason "现金及现金等价物加定期存款，扣除3.5亿元经营必需现金；质押存款不计入" --confidence medium --falsifier "资本承诺、偿债限制或境内汇出限制使可达现金低于该数，或实际最低现金需求变化"
set_field_expr equity non_operating_assets "" "associates_2025 + joint_ventures_2025 + other_fin_assets_2025 + fvpl_assets_2025" formula "联营、合营及金融投资未纳入经营FCFF，按账面或公允价值加回" medium
set_field_expr equity financing_debt "" "borrowings_2025 + other_fin_liability_2025" formula "银行借款与在融资现金流中偿还的其他金融负债均属优先融资索偿" high
python3 "$tool" set-field --model "$model" --view equity --field minority_interest_value --value 362500000 --basis-type estimate --reason "天工股份2025归母净利润约1.40亿元，按年末32.37%非控股比例和同一8倍收益标尺估计；避免用账面少数股东权益替代经济价值" --confidence medium --falsifier "天工股份稳定收益、年末非控股比例或独立可实现价值显著变化"
python3 "$tool" set-field --model "$model" --view equity --field other_priority_claims --value 0 --basis-type estimate --reason "年报未识别除融资负债和少数股东外的重大优先索偿；日常经营负债已进入经营资本" --confidence medium --falsifier "出现未计入资本开支或融资负债的重大已承诺付款、担保或优先股"
set_field_expr equity diluted_shares "" issued_shares_2025 reported "2025年末已发行股份；2026年授予的期权行权价3.50港元，高于本基准每股价值，未计经济摊薄" high
set_field_expr equity financial_to_trading_fx "" rmb_to_hkd_2025 reported "按2025年末人民币兑港元中间价换算" high
python3 "$tool" set-field --model "$model" --view equity --field current_price --expression current_price_20260908 --basis-type reported --reason "最近可得收盘价" --confidence high --observed-at "2026-09-08"

# Latest-year mutually exclusive economic businesses.
python3 "$tool" add-business --model "$model" --business-id ds --name "模具钢（DS）" --importance "2025年收入占48.6%，服务汽车、家电、电子等模具制造，是最大业务但资本占用重、利润率偏低" --confidence high --falsifier "分部边界或内部交易口径重大变化"
python3 "$tool" add-business --model "$model" --business-id hss --name "高速钢（HSS）" --importance "粉末冶金产品升级和国产替代驱动，亦向切削工具分部内部供货" --confidence high --falsifier "粉末冶金收入贡献或内部供货关系与披露不符"
python3 "$tool" add-business --model "$model" --business-id cutting_tools --name "切削工具" --importance "上游高速钢到下游刀具的一体化业务，2025年贡献最高分部EBIT" --confidence high --falsifier "分部成本未反映内部供货的市场化定价"
python3 "$tool" add-business --model "$model" --business-id titanium --name "钛合金材料" --importance "面向化工能源、消费电子、航空航天及增材制造；2025年产品组合下沉但仍有较高利润贡献" --confidence high --falsifier "天工股份上市后分部边界或控制范围改变"
python3 "$tool" add-business --model "$model" --business-id power_tool_kits --name "电动工具套件组装与销售" --importance "采购零件后自行或委托组装并出口，规模小且受美国关税和客户订单影响" --confidence medium --falsifier "披露显示该分部包含其他实质业务"

for row in \
  "ds revenue 2291959000 reported 高度披露的外部客户收入 high" \
  "ds cost_of_revenue 1939305730 estimate 按披露分部毛利率权重分配合并毛利并调整内部交易消除 medium" \
  "ds period_operating_expenses 258388987 estimate 由分部调整EBIT加按收入分配的公司经营净额反推 medium" \
  "ds cash_tax 7272853 estimate 按各业务调整EBIT比例分配当期经营税 medium" \
  "ds operating_cash_flow_contribution 49890766 estimate 按业务NOPAT比例分配合并经营现金流 low" \
  "hss revenue 791944000 reported 高度披露的外部客户收入 high" \
  "hss cost_of_revenue 651603179 estimate 按披露分部毛利率权重分配合并毛利并调整内部交易消除 medium" \
  "hss period_operating_expenses 35460491 estimate 由分部调整EBIT加按收入分配的公司经营净额反推 medium" \
  "hss cash_tax 8091922 estimate 按各业务调整EBIT比例分配当期经营税 medium" \
  "hss operating_cash_flow_contribution 55509466 estimate 按业务NOPAT比例分配合并经营现金流 low" \
  "cutting_tools revenue 923529000 reported 高度披露的外部客户收入 high" \
  "cutting_tools cost_of_revenue 646190577 estimate 按披露分部毛利率权重分配合并毛利并调整内部交易消除 medium" \
  "cutting_tools period_operating_expenses 75474988 estimate 由分部调整EBIT加按收入分配的公司经营净额反推 medium" \
  "cutting_tools cash_tax 15574542 estimate 按各业务调整EBIT比例分配当期经营税 medium" \
  "cutting_tools operating_cash_flow_contribution 106839208 estimate 按业务NOPAT比例分配合并经营现金流 low" \
  "titanium revenue 625987000 reported 高度披露的外部客户收入 high" \
  "titanium cost_of_revenue 447965205 estimate 按披露分部毛利率权重分配合并毛利并调整内部交易消除 medium" \
  "titanium period_operating_expenses 25692628 estimate 由分部调整EBIT加按收入分配的公司经营净额反推 medium" \
  "titanium cash_tax 11752782 estimate 按各业务调整EBIT比例分配当期经营税 medium" \
  "titanium operating_cash_flow_contribution 80622465 estimate 按业务NOPAT比例分配合并经营现金流 low" \
  "power_tool_kits revenue 85411000 reported 高度披露的外部客户收入 high" \
  "power_tool_kits cost_of_revenue 81876309 estimate 作为合并销售成本闭合余数并以披露分部毛利率校验 medium" \
  "power_tool_kits period_operating_expenses 554906 estimate 由分部调整EBIT加按收入分配的公司经营净额反推 medium" \
  "power_tool_kits cash_tax 229901 estimate 作为合并经营税闭合余数 medium" \
  "power_tool_kits operating_cash_flow_contribution 1577095 estimate 作为合并经营现金流闭合余数 low"
do
  set -- $row
  business="$1"; field="$2"; value="$3"; basis="$4"; reason="$5"; confidence="$6"
  if [[ "$basis" == "reported" ]]; then
    case "$business" in
      ds) expr="revenue_2025 - revenue_2025 + 2291959000";;
      hss) expr="revenue_2025 - revenue_2025 + 791944000";;
      cutting_tools) expr="revenue_2025 - revenue_2025 + 923529000";;
      titanium) expr="revenue_2025 - revenue_2025 + 625987000";;
      power_tool_kits) expr="revenue_2025 - revenue_2025 + 85411000";;
    esac
    python3 "$tool" set-business-field --model "$model" --business-id "$business" --field "$field" --expression "$expr" --basis-type reported --reason "$reason；年报附注5，PDF pp.172-174" --confidence "$confidence"
  else
    python3 "$tool" set-business-field --model "$model" --business-id "$business" --field "$field" --value "$value" --basis-type estimate --reason "$reason" --confidence "$confidence" --falsifier "若分部完整成本、税项或现金流披露，则以直接数替换该分配"
  fi
done

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "稳定状态的到达时间和逐年成长FCFF缺少充分证据，采用稳定经营收益八倍固定标尺" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "剔除金融投资及处置损益" --before "2025财报经营利润5.877亿元" --after "调整后EBIT 5.563亿元" --reason "剔除股息、公允价值、交易证券及子公司处置净收益0.314亿元；政府补助与经营汇兑留在历史经营，但稳定期不机械外推"
python3 "$tool" add-adjustment --model "$model" --name "商誉不作为经营投入" --before "商誉1.446亿元计入非流动资产" --after "从投入资本中剔除1.446亿元" --reason "无法从独立经营收益解释并购溢价；经营能力由稳定收益反推"
python3 "$tool" add-adjustment --model "$model" --name "少数股东经济价值" --before "2025年末少数股东账面权益5.401亿元" --after "经济价值3.625亿元" --reason "按天工股份2025利润、年末非控股比例和同一八倍收益标尺估计，保持经营价值口径一致"

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "所有重大历史金额均追溯至三份法定年报具体PDF页，市场事实注明日期与公开链接"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "经营、金融投资、融资负债、商誉和少数股东已分开；未重复计算现金、负债或非经营资产"
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本边界三年一致，经营必需现金估计仅占约4%；约5% ROIC主要反映可核验的高营运资金和固定资产占用"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期结合三年完整年度与2026上半年复苏，未机械使用2025低点或半年年化，估值模式为benchmark"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "报告中心数字、业务闭合和价值桥将直接引用编译后的结构化模型"

python3 "$tool" compile --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

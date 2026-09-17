#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
src24="粵海投資《2024年度報告》，2025-03-24"
url24="https://www1.hkexnews.hk/listedco/listconews/sehk/2025/0428/2025042804203.pdf"
src25="粵海投資《2025年度報告》，2026-03-30"
url25="https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0424/2026042403928.pdf"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency HKD --scope "$5" --source "$6；$7" --locator "$8"
}

field_expr() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7" ${8:+--falsifier "$8"}
}

field_value() {
  python3 "$tool" set-field --model "$model" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
}

stable_value() {
  python3 "$tool" set-field --model "$model" --view stable --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"
}

equity_expr() {
  python3 "$tool" set-field --model "$model" --view equity --field "$1" --expression "$2" --basis-type "$3" --reason "$4" --confidence "$5" ${6:+--falsifier "$6"}
}

equity_value() {
  python3 "$tool" set-field --model "$model" --view equity --field "$1" --value "$2" --basis-type estimate --reason "$3" --confidence "$4" --falsifier "$5"
}

# Comparable continuing-operation profit and segment facts.
fact rev23 "持續經營業務收入" 20322478000 2023 consolidated "$src24" "$url24" "PDF第67頁（年報頁66）"
fact cost23 "持續經營業務銷售成本" 10667918000 2023 consolidated "$src24" "$url24" "PDF第67頁（年報頁66）"
fact segres23 "持續經營業務分部業績合計" 7053917000 2023 consolidated "$src24" "$url24" "PDF第112頁（年報頁111）"
fact assoc23 "應佔聯營公司溢利減虧損" 193411000 2023 consolidated "$src24" "$url24" "PDF第112頁（年報頁111）"
fact fv_gain23 "投資物業公允價值增加" 100198000 2023 consolidated "$src24" "$url24" "PDF第67頁（年報頁66）"
fact tax23 "持續經營業務所得稅費用" 1658283000 2023 consolidated "$src24" "$url24" "PDF第67頁（年報頁66）"
fact da23 "持續經營業務分部折舊及攤銷" 2471948000 2023 consolidated "$src24" "$url24" "PDF第114頁（年報頁113）"

fact rev24 "持續經營業務收入" 18505293000 2024 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact cost24 "持續經營業務銷售成本" 8682832000 2024 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact segres24 "持續經營業務分部業績合計" 7019318000 2024 consolidated "$src25" "$url25" "PDF第113頁（年報頁112）"
fact assoc24 "應佔聯營公司溢利減虧損" 172021000 2024 consolidated "$src25" "$url25" "PDF第113頁（年報頁112）"
fact fv_loss24 "投資物業公允價值減少" 67821000 2024 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact tax24 "持續經營業務所得稅費用" 1852764000 2024 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact da24 "持續經營業務分部折舊及攤銷" 2479597000 2024 consolidated "$src25" "$url25" "PDF第116頁（年報頁115）"

fact rev25 "持續經營業務收入" 18824908000 2025 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact cost25 "持續經營業務銷售成本" 8790600000 2025 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact segres25 "持續經營業務分部業績合計" 7545779000 2025 consolidated "$src25" "$url25" "PDF第113頁（年報頁112）"
fact assoc25 "應佔聯營公司溢利減虧損" 111256000 2025 consolidated "$src25" "$url25" "PDF第113頁（年報頁112）"
fact fv_loss25 "投資物業公允價值減少" 26318000 2025 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact tax25 "持續經營業務所得稅費用" 1975055000 2025 consolidated "$src25" "$url25" "PDF第69頁（年報頁68）"
fact da25 "持續經營業務分部折舊及攤銷" 2476530000 2025 consolidated "$src25" "$url25" "PDF第116頁（年報頁115）"

# Operating cash flow controls; discontinued property development and investment returns are removed.
fact ocf_total23 "經營活動所得現金流量淨額" 10710554000 2023 consolidated "$src24" "$url24" "PDF第74頁（年報頁73）"
fact ocf_disc23 "終止經營業務經營活動現金流入" 3606861000 2023 "GD Land discontinued operations" "$src24" "$url24" "PDF第168頁（年報頁167）"
fact interest_received23 "已收利息" 211514000 2023 consolidated "$src24" "$url24" "PDF第74頁（年報頁73）"
fact assoc_div23 "已收聯營公司股息" 62582000 2023 consolidated "$src24" "$url24" "PDF第74頁（年報頁73）"
fact ocf_total24 "經營活動所得現金流量淨額" 11085708000 2024 consolidated "$src25" "$url25" "PDF第76頁（年報頁75）"
fact ocf_disc24 "終止經營業務經營活動現金流入" 1935988000 2024 "GD Land discontinued operations" "$src25" "$url25" "PDF第167頁（年報頁166）"
fact interest_received24 "已收利息" 248561000 2024 consolidated "$src25" "$url25" "PDF第76頁（年報頁75）"
fact assoc_div24 "已收聯營公司股息" 48727000 2024 consolidated "$src25" "$url25" "PDF第76頁（年報頁75）"
fact ocf_total25 "經營活動所得現金流量淨額" 8805423000 2025 consolidated "$src25" "$url25" "PDF第76頁（年報頁75）"
fact ocf_disc25 "終止經營業務經營活動現金流入" 267758000 "2025-01-01/2025-01-21" "GD Land discontinued operations" "$src25" "$url25" "PDF第167頁（年報頁166）"
fact interest_received25 "已收利息" 189231000 2025 consolidated "$src25" "$url25" "PDF第76頁（年報頁75）"
fact assoc_div25 "已收聯營公司股息" 169427000 2025 consolidated "$src25" "$url25" "PDF第76頁（年報頁75）"

# Cash capital expenditure, net of operating-asset disposal proceeds and including lease principal.
fact ppe23 "購買物業、廠房及設備" 728442000 2023 consolidated "$src24" "$url24" "PDF第75頁（年報頁74）"
fact rou23 "添置使用權資產" 48690000 2023 consolidated "$src24" "$url24" "PDF第75頁（年報頁74）"
fact concession23 "服務特許權安排添置" 322707000 2023 consolidated "$src24" "$url24" "PDF第75頁（年報頁74）"
fact invprop23 "投資物業添置" 719965000 2023 consolidated "$src24" "$url24" "PDF第75頁（年報頁74）"
fact disposal23 "出售物業、廠房及設備所得款" 39317000 2023 consolidated "$src24" "$url24" "PDF第75頁（年報頁74）"
fact lease_principal23 "租賃本金付款" 88811000 2023 consolidated "$src24" "$url24" "PDF第75頁（年報頁74）"
fact disc_investing23 "終止經營業務投資活動現金流出" 489182000 2023 "GD Land discontinued operations" "$src24" "$url24" "PDF第168頁（年報頁167）"
fact ppe24 "購買物業、廠房及設備" 985109000 2024 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact concession24 "服務特許權安排添置" 429577000 2024 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact invprop24 "投資物業添置" 135867000 2024 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact disposal24 "出售物業、廠房及設備所得款" 49450000 2024 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact lease_principal24 "租賃本金付款" 74144000 2024 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact disc_investing24 "終止經營業務投資活動現金流出" 6041000 2024 "GD Land discontinued operations" "$src25" "$url25" "PDF第167頁（年報頁166）"
fact ppe25 "購買物業、廠房及設備" 873402000 2025 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact concession25 "服務特許權安排添置" 854064000 2025 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact invprop25 "投資物業添置" 30365000 2025 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact disposal25 "出售物業、廠房及設備所得款" 44816000 2025 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"
fact lease_principal25 "租賃本金付款" 98176000 2025 consolidated "$src25" "$url25" "PDF第77頁（年報頁76）"

# Historical fields.
for y in 2023 2024 2025; do
  yy="${y:2:2}"
  field_expr historical "$y" revenue "rev$yy" reported "持續經營業務合併收入。" high ""
  field_expr historical "$y" cost_of_revenue "cost$yy" reported "持續經營業務合併銷售成本。" high ""
  field_expr historical "$y" cash_tax "tax$yy" estimate "以持續經營所得稅費用近似經營現金稅；稅款時點差納入營運資金對賬。" medium "若稅項附註可可靠分拆遞延稅、利息稅盾及非經營收益稅，改用調整後現金稅。"
  field_expr historical "$y" depreciation_amortization "da$yy" reported "持續經營分部折舊及攤銷合計。" high ""
  field_value historical "$y" exploratory_business_capex 0 "未見跨越現有水務、物業、零售、酒店、電力或道路能力邊界的現金開拓投入；全部營運資產現金支出歸入現有主業。" medium "若披露可識別的新技术路线或全新市场项目现金资本开支，则重分类。"
  field_expr historical "$y" after_tax_interest_in_operating_cash_flow "0" formula "利息支付列在融資活動；已從經營現金流剔除利息收入，毋須加回稅後利息。" high ""
done
field_expr historical 2023 period_operating_expenses "rev23-cost23-(segres23-assoc23-fv_gain23)" formula "由毛利減去剔除聯營收益和投資物業公允價值收益後的EBIT反推。" high ""
field_expr historical 2024 period_operating_expenses "rev24-cost24-(segres24-assoc24+fv_loss24)" formula "由毛利減去剔除聯營收益並加回投資物業公允價值損失後的EBIT反推。" high ""
field_expr historical 2025 period_operating_expenses "rev25-cost25-(segres25-assoc25+fv_loss25)" formula "由毛利減去剔除聯營收益並加回投資物業公允價值損失後的EBIT反推。" high ""
field_expr historical 2023 core_business_capex "ppe23+rou23+concession23+invprop23-disposal23+lease_principal23-disc_investing23" formula "現有持續經營業務的淨現金資本支出；扣除GD Land投資現金流。" medium ""
field_expr historical 2024 core_business_capex "ppe24+concession24+invprop24-disposal24+lease_principal24-disc_investing24" formula "現有持續經營業務的淨現金資本支出；扣除GD Land投資現金流。" medium ""
field_expr historical 2025 core_business_capex "ppe25+concession25+invprop25-disposal25+lease_principal25" formula "現有持續經營業務的淨現金資本支出；收購支付不屬日常資本開支。" high ""
field_expr historical 2023 operating_cash_flow "ocf_total23-ocf_disc23-interest_received23-assoc_div23" formula "從合併經營現金流剔除GD Land、利息收入及聯營股息。" medium ""
field_expr historical 2024 operating_cash_flow "ocf_total24-ocf_disc24-interest_received24-assoc_div24" formula "從合併經營現金流剔除GD Land、利息收入及聯營股息。" medium ""
field_expr historical 2025 operating_cash_flow "ocf_total25-ocf_disc25-interest_received25-assoc_div25" formula "從合併經營現金流剔除GD Land、利息收入及聯營股息。" medium ""
field_expr historical 2023 operating_working_capital_increase "(segres23-assoc23-fv_gain23-tax23)+da23-(ocf_total23-ocf_disc23-interest_received23-assoc_div23)" formula "以利潤路徑和剔除投資回報後的現金流路徑閉合，包含稅款時點和非現金營運調整。" medium ""
field_expr historical 2024 operating_working_capital_increase "(segres24-assoc24+fv_loss24-tax24)+da24-(ocf_total24-ocf_disc24-interest_received24-assoc_div24)" formula "以利潤路徑和剔除投資回報後的現金流路徑閉合，包含稅款時點和非現金營運調整。" medium ""
field_expr historical 2025 operating_working_capital_increase "(segres25-assoc25+fv_loss25-tax25)+da25-(ocf_total25-ocf_disc25-interest_received25-assoc_div25)" formula "以利潤路徑和剔除投資回報後的現金流路徑閉合，包含稅款時點和非現金營運調整。" medium ""

# Capital controls for 2024-2025.
fact segassets24 "持續經營分部資產" 79074579000 2024 consolidated "$src25" "$url25" "PDF第115頁（年報頁114）"
fact segliab24 "持續經營分部負債" 14103875000 2024 consolidated "$src25" "$url25" "PDF第115頁（年報頁114）"
fact assoc_asset24 "聯營公司投資" 3607316000 2024 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact op_current_assets24 "營運流動資產（存貨、特許權應收、合作安排應收、其他應收及待售物業）" 6953583000 2024 consolidated "$src25" "$url25" "PDF第72頁（年報頁71），研究匯總"
fact op_current_liab24 "營運流動負債（應付及合同負債）" 12094358000 2024 consolidated "$src25" "$url25" "PDF第73頁（年報頁72），研究匯總"
fact goodwill24 "商譽" 810988000 2024 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact segassets25 "持續經營分部資產" 82544077000 2025 consolidated "$src25" "$url25" "PDF第115頁（年報頁114）"
fact segliab25 "持續經營分部負債" 15822280000 2025 consolidated "$src25" "$url25" "PDF第115頁（年報頁114）"
fact assoc_asset25 "聯營公司投資" 1726503000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact op_current_assets25 "營運流動資產（存貨、特許權應收、合作安排應收、其他應收及待售物業）" 8476307000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71），研究匯總"
fact op_current_liab25 "營運流動負債（應付及合同負債）" 13735944000 2025 consolidated "$src25" "$url25" "PDF第73頁（年報頁72），研究匯總"
fact goodwill25 "商譽" 793189000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"

field_value capital 2022 operating_working_capital -3800000000 "公開比較數未把GD Land自2022資產負債追溯拆出；按後續持續經營營運資金結構回推。" low "若公司提供2022持續經營資產負債重列，改用重列數。"
field_value capital 2022 operating_long_term_assets_net 67000000000 "按2023–2025持續經營分部淨資產反推期初長期經營資產。" low "若公司提供2022持續經營分部資產負債重列，改用重列數。"
field_value capital 2022 required_cash 2000000000 "約相當於一個月現金營運支出及項目結算緩衝。" low "若披露月度現金支出、受限資金和最低流動性政策，重新估算。"
field_value capital 2022 unsupported_intangible_assets 900000000 "以商譽及無法單獨解釋收益的收購溢價近似。" medium "若商譽對應增量收益和可持續回報可驗證，減少剔除。"
field_value capital 2023 operating_working_capital -4500000000 "剔除GD Land後，按2024–2025負營運資金結構回推持續經營業務。" low "若公司提供2023持續經營資產負債重列，改用重列數。"
field_value capital 2023 operating_long_term_assets_net 68000000000 "剔除GD Land後按持續經營分部淨資產、聯營投資及後續變動回推。" low "若公司提供2023持續經營分部資產負債重列，改用重列數。"
field_value capital 2023 required_cash 2000000000 "約相當於一個月現金營運支出及項目結算緩衝。" low "若披露月度現金支出、受限資金和最低流動性政策，重新估算。"
field_value capital 2023 unsupported_intangible_assets 852000000 "以年末商譽約數剔除，品牌、牌照及特許經營權由收益反推而不另行剔除。" medium "若商譽對應增量收益和可持續回報可驗證，減少剔除。"
field_expr capital 2024 operating_working_capital "op_current_assets24-op_current_liab24" formula "列示營運流動資產減應付及合同負債。" medium ""
field_expr capital 2024 operating_long_term_assets_net "segassets24-segliab24-assoc_asset24-(op_current_assets24-op_current_liab24)" formula "持續經營分部淨資產扣除聯營投資，再扣營運資金，形成長期經營資產淨額。" medium ""
field_value capital 2024 required_cash 2000000000 "約相當於一個月現金營運支出及項目結算緩衝。" low "若披露月度現金支出、受限資金和最低流動性政策，重新估算。"
field_expr capital 2024 unsupported_intangible_assets "goodwill24" reported "商譽默認視為無法解釋的收購溢價；其他特許權服務當期收入，保留在經營資產。" medium ""
field_expr capital 2025 operating_working_capital "op_current_assets25-op_current_liab25" formula "列示營運流動資產減應付及合同負債。" medium ""
field_expr capital 2025 operating_long_term_assets_net "segassets25-segliab25-assoc_asset25-(op_current_assets25-op_current_liab25)" formula "持續經營分部淨資產扣除聯營投資，再扣營運資金，形成長期經營資產淨額。" medium ""
field_value capital 2025 required_cash 2000000000 "約相當於一個月現金營運支出及項目結算緩衝。" low "若披露月度現金支出、受限資金和最低流動性政策，重新估算。"
field_expr capital 2025 unsupported_intangible_assets "goodwill25" reported "商譽默認視為無法解釋的收購溢價；其他特許權服務當期收入，保留在經營資產。" medium ""

# Stable state is a normalized benchmark, not a management forecast.
stable_value revenue 19000000000 "供港基本水價可見至2026，水務擴容抵消零售收縮；取略高於2025的正常收入。" medium "若供港新協議、污水利用率或零售關店令收入偏離2025水平超過10%，重估。"
stable_value cost_of_revenue 8900000000 "按2024–2025約46.7%銷售成本率及業務結構小幅正常化估計。" medium "若水務工程收入占比或燃煤成本结构显著改变，重估。"
stable_value period_operating_expenses 2650000000 "以2025剔除非經營項目後費用為基準，恢復部分節流後取常態。" medium "若行政費用連續兩年維持明顯低於或高於此水平，重估。"
stable_value cash_tax 2000000000 "按約26.8%的正常EBIT現金稅負估計。" medium "若中國稅率、遞延稅或股息預提稅的現金化顯著改變，重估。"
stable_value depreciation_amortization 2500000000 "接近2023–2025持續經營折舊攤銷均值。" high "若新增特許權收購或重大資產處置改變折舊基礎，重估。"
stable_value core_business_capex 2300000000 "高於近三年現金資本開支均值，納入水務在建產能和更新投入但不含併購。" medium "若連續三年現金資本開支穩定低於18億或高於28億且產能不變，重估。"
stable_value exploratory_business_capex 0 "未識別跨越現有能力邊界且需持續投入的新業務。" medium "若公司進入新的技術路線或市場並披露獨立資金需求，另列。"
stable_value operating_working_capital_increase 200000000 "成熟供港與租賃業務需求低，為水務擴容和工程應收保留小幅正常占用。" medium "若服務特許權應收及回款週期持續改善或惡化，重估。"

# Equity bridge facts and fields.
fact cash25 "現金及銀行結餘" 14783332000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact finassets25 "按攤餘成本計量的其他金融資產" 3553589000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact debt25 "銀行及其他借款" 21611592000 2025 consolidated "$src25" "$url25" "PDF第73頁（年報頁72）"
fact fvoci25 "按公允價值計入其他全面收益的股權投資" 16748000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact due_nci_asset25 "應收附屬公司非控股股東款" 913322000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact due_nci_liab25 "應付附屬公司非控股股東款" 479708000 2025 consolidated "$src25" "$url25" "PDF第73頁（年報頁72）"
fact held_sale25 "持作出售的已竣工物業" 94850000 2025 consolidated "$src25" "$url25" "PDF第72頁（年報頁71）"
fact shares25 "已發行及繳足普通股" 6537821440 2025 company "$src25" "$url25" "PDF第162頁（年報頁161）"
equity_expr excess_cash "cash25+finassets25-2000000000" formula "現金與本金受保護的定期金融資產，扣除20億經營必需現金；未另扣日常資本承諾，因穩定資本開支已進FCFF。" medium ""
equity_expr non_operating_assets "assoc_asset25+fvoci25+due_nci_asset25-due_nci_liab25+held_sale25" formula "聯營投資收益已自EBIT剔除，連同獨立股權投資、非控股股東淨應收及待售物業按賬面值加入。" medium ""
equity_expr financing_debt "debt25" reported "銀行及其他借款按年末賬面額扣除；租賃採經營口徑，不重複扣租賃負債。" high ""
equity_value minority_interest_value 5600000000 "以2025持續經營非控股利潤、主要Teem權益及其他水務少數權益，按與八倍標尺一致的收益口徑估計。" low "若主要非全資附屬公司分拆FCFF、現金、債務和估值披露，改用逐戶估值。"
equity_value other_priority_claims 0 "未識別已宣派未付股息以外、且未進營運資本或融資負債的重大優先索償。" medium "若出現重大法律賠償、優先股或未入賬建設付款，納入扣減。"
equity_expr diluted_shares "shares25" reported "年末無潛在攤薄工具，使用已發行普通股。" high ""
equity_value expansion_project_value 0 "水務在建及擴容未披露足夠增量價格、利用率和FCFF，謹慎不另加值。" medium "若公司披露可核驗增量订单、利用率、单位经济性和资本回报，单独估值。"
equity_value new_business_option_value 0 "未識別可獨立驗證商業化的新業務選項。" medium "若新业务形成外部收入和可验证单位经济性，另行估值。"
equity_value financial_to_trading_fx 1 "財報與交易均為港元。" high "若交易或報表幣種改變，重估。"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "公司已成熟但資產組合與水務擴張仍在變動，缺少逐年FCFF與全部增量投入證據；採穩定經營收益八倍固定標尺。" --stable-multiple 8 --safety-margin-ratio 0.6

# Latest-year mutually exclusive business tree.
business() {
  python3 "$tool" add-business --model "$model" --business-id "$1" --name "$2" --importance "$3" --confidence "$4" --falsifier "$5"
}
bfield() {
  python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"
}
business water "水資源：供水、污水與水務工程" "收入和利潤核心；供港合約、內地公用事業及水務工程共同驅動。" medium "若公司披露各水務子業務成本、稅和現金流，按直接數重分配。"
business property "商業物業租賃與管理" "高毛利租金現金流，主要由GDH Teem購物中心組合產生。" medium "若物業層面現金成本和稅項披露，替換估計。"
business retail "百貨店營運" "規模收縮但2025轉為盈利，反映關店和租賃重估。" low "若披露百貨獨立現金流和一次性租賃重估，調整正常盈利。"
business power "燃煤發電" "受上網電價、煤價和售電量共同影響的周期業務。" medium "若披露分部成本和現金稅，替換估計。"
business hotel "酒店擁有、營運與管理" "入住率復甦但固定成本和自有資產占用較高。" medium "若披露酒店層面現金成本和稅項，替換估計。"
business road "收費公路與道路PPP" "收費流量和政府績效回款共同形成收入。" medium "若道路PPP的利息、維護與本金回收重新分類，調整收入和現金流。"
business corporate "集團資金與管理服務" "承接分部抵銷和總部管理成本，避免無信息的「其他」占位。" low "若公司披露總部成本與內部分攤，按披露重列。"

# revenue / costs / period expenses / cash tax / OCF contribution
bfield water revenue 14139556000 "分部外部收入直接披露。" high "若年報重列分部收入。"
bfield water cost_of_revenue 6700000000 "以水務收入結構、分部EBIT及公司銷售成本總額約束的基準估計。" low "若披露水務銷售成本，替換估計。"
bfield water period_operating_expenses 1647768000 "由調整後水務EBIT反推，剔除聯營收益和物業公允價值變動。" medium "若披露水務EBIT或分部費用重列，替換估計。"
bfield water cash_tax 1522649780 "按各正EBIT業務同比例分配公司經營稅。" low "若披露分部所得稅或現金稅，替換分配。"
bfield water operating_cash_flow_contribution 6400000000 "按水務NOPAT、折舊攤銷及營運資金回收特徵估計，與公司現金流閉合。" low "若披露分部現金流量，替換估計。"
bfield property revenue 1681806000 "分部外部收入直接披露。" high "若年報重列分部收入。"
bfield property cost_of_revenue 250000000 "以披露租賃直接營運成本及管理服務成本估計。" medium "若披露分部銷售成本，替換估計。"
bfield property period_operating_expenses 484095000 "由調整後物業EBIT反推。" medium "若披露分部EBIT或費用，替換估計。"
bfield property cash_tax 249151375 "按各正EBIT業務同比例分配公司經營稅。" low "若披露分部現金稅，替換分配。"
bfield property operating_cash_flow_contribution 750000000 "按物業NOPAT、低營運資金占用及現金租金估計。" low "若披露分部現金流量，替換估計。"
bfield retail revenue 447972000 "分部外部收入直接披露。" high "若年報重列分部收入。"
bfield retail cost_of_revenue 220000000 "受自營商品銷售與聯營佣金混合影響，按公司成本總額約束估計。" low "若披露百貨銷售成本，替換估計。"
bfield retail period_operating_expenses 118834000 "由剔除投資物業公允價值損失後的分部EBIT反推。" low "若披露正常化租賃重估和分部費用，重估。"
bfield retail cash_tax 28692168 "按各正EBIT業務同比例分配公司經營稅。" low "若披露分部現金稅，替換分配。"
bfield retail operating_cash_flow_contribution 100000000 "按低存貨、即時收款和租賃安排估計。" low "若披露分部現金流量，替換估計。"
bfield power revenue 1237378000 "分部外部收入直接披露。" high "若年報重列分部收入。"
bfield power cost_of_revenue 1050000000 "按燃煤發電低毛利及公司銷售成本總額約束估計。" low "若披露電力燃料與銷售成本，替換估計。"
bfield power period_operating_expenses 73996000 "由剔除聯營電廠收益後的分部EBIT反推。" medium "若披露分部成本費用，替換估計。"
bfield power cash_tax 29807907 "按各正EBIT業務同比例分配公司經營稅。" low "若披露分部現金稅，替換分配。"
bfield power operating_cash_flow_contribution 210000000 "按分部NOPAT和折舊攤銷估計。" low "若披露分部現金流量，替換估計。"
bfield hotel revenue 704641000 "分部外部收入直接披露。" high "若年報重列分部收入。"
bfield hotel cost_of_revenue 420000000 "按自有酒店服務成本與公司總成本約束估計。" low "若披露酒店銷售成本，替換估計。"
bfield hotel period_operating_expenses 184212000 "由剔除投資物業公允價值損失後的分部EBIT反推。" medium "若披露分部成本費用，替換估計。"
bfield hotel cash_tax 26402588 "按各正EBIT業務同比例分配公司經營稅。" low "若披露分部現金稅，替換分配。"
bfield hotel operating_cash_flow_contribution 220000000 "按酒店NOPAT、折舊和預收款特徵估計。" low "若披露分部現金流量，替換估計。"
bfield road revenue 613555000 "分部外部收入直接披露。" high "若年報重列分部收入。"
bfield road cost_of_revenue 130000000 "按收費公路高固定成本、高毛利及公司總成本約束估計。" low "若披露道路分部銷售成本，替換估計。"
bfield road period_operating_expenses 33376000 "由分部EBIT反推。" medium "若披露分部成本費用，替換估計。"
bfield road cash_tax 118351182 "按各正EBIT業務同比例分配公司經營稅。" low "若披露分部現金稅，替換分配。"
bfield road operating_cash_flow_contribution 550000000 "按收費即時回款、PPP回款和折舊攤銷估計。" low "若披露分部現金流量，替換估計。"
bfield corporate revenue 0 "外部收入為零；內部服務在合併抵銷。" high "若分部外部收入重列。"
bfield corporate cost_of_revenue 20600000 "承接公司銷售成本闭合差额。" low "若總部成本及分部抵銷披露，重估。"
bfield corporate period_operating_expenses 31186000 "承接總部分部虧損與分部抵銷。" low "若總部成本及分部抵銷披露，重估。"
bfield corporate cash_tax 0 "虧損業務不分配現金稅利益。" low "若披露總部稅務利益，重估。"
bfield corporate operating_cash_flow_contribution -50993000 "承接公司現金流闭合差额。" low "若披露總部現金流量，替換估計。"

python3 "$tool" add-adjustment --model "$model" --name "GD Land地產開發終止經營" --before "2024合併虧損14.93億港元" --after "從持續經營EBIT、FCFF和期末經營資產剔除" --reason "2025年1月已向股東實物分派，往後不再由粵海投資普通股承擔或受益。"
python3 "$tool" add-adjustment --model "$model" --name "投資物業公允價值變動與聯營收益" --before "列入稅前利潤或分部業績" --after "三年均從EBIT剔除；聯營投資另列非經營資產" --reason "公允價值重估不是現金經營收益；聯營收益不由並表經營資產直接產生。"
python3 "$tool" add-adjustment --model "$model" --name "少數股東索償" --before "賬面非控股權益152.15億港元" --after "估計經濟價值56.0億港元" --reason "與八倍穩定收益標尺保持一致，避免以低回報資產賬面額和收益估值混用；因缺少逐戶FCFF，可信度低。"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "2024–2025投入資本按持續經營分部淨資產重構；2022–2023剔除GD Land依賴低可信估計，報告僅把ROIC解釋為資本占用結構，不作護城河證明。"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "所有報表直接數保存年報名稱、日期、公開URL和PDF頁碼；研究估計保存依據、可信度和可推翻條件。"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "持續經營EBIT剔除投資物業重估與聯營收益；現金、金融資產、聯營投資、借款和少數股東在價值橋中不重複。"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "穩定狀態同時考慮三年收入、利潤、折舊、現金資本開支、供港價格可見性、水務擴容及零售收縮，未由單年外推。"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "報告中心數字將直接引用程序生成轉寫表，正文采用同一持續經營和八倍基準估值口徑。"

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"

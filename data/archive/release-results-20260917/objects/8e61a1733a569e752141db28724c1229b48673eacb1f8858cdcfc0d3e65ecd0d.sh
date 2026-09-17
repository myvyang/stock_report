#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
ar24="古茗控股有限公司2024年度报告（2025-04-29）"
url24="https://www1.hkexnews.hk/listedco/listconews/sehk/2025/0429/2025042901722.pdf"
ar25="古茗控股有限公司2025年度报告（2026-04-24）"
url25="https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0424/2026042401574.pdf"
fxsrc="香港金融管理局：汇率及港汇指数—每日数字"
fxurl="https://api.hkma.gov.hk/public/market-data-and-statistics/monthly-statistical-bulletin/er-ir/er-eeri-daily"

python3 "$tool" init --name 古茗 --code 01364.HK --period-label 2025年度 --period-end 2025-12-31 --coverage-years 2024,2025 --financial-currency 人民币 --trading-currency 港元 --security-name 普通股 --security-unit 股 --output "$model"

fact() { python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "$5" --source "$6" --locator "$7"; }
hist_expr() { python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --expression "$3" --basis-type "$4" --confidence "$5" --reason "$6"; }
hist_est() { python3 "$tool" set-field --model "$model" --view historical --year "$1" --field "$2" --value "$3" --basis-type estimate --confidence "$4" --reason "$5" --falsifier "$6"; }
cap_expr() { python3 "$tool" set-field --model "$model" --view capital --year "$1" --field "$2" --expression "$3" --basis-type "$4" --confidence "$5" --reason "$6"; }
cap_est() { python3 "$tool" set-field --model "$model" --view capital --year "$1" --field "$2" --value "$3" --basis-type estimate --confidence "$4" --reason "$5" --falsifier "$6"; }
stable_est() { python3 "$tool" set-field --model "$model" --view stable --field "$1" --value "$2" --basis-type estimate --confidence "$3" --reason "$4" --falsifier "$5"; }
eq_expr() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --expression "$2" --basis-type "$3" --confidence "$4" --reason "$5"; }
eq_est() { python3 "$tool" set-field --model "$model" --view equity --field "$1" --value "$2" --basis-type estimate --confidence "$3" --reason "$4" --falsifier "$5"; }
biz_expr() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --confidence "$5" --reason "$6"; }
biz_est() { python3 "$tool" set-business-field --model "$model" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --confidence "$4" --reason "$5" --falsifier "$6"; }

# 经营与现金流原始事实（单位：人民币元）
fact revenue_2024 收入 8791355000 2024 人民币 "$ar25" "$url25#page=226"
fact cost_2024 销售成本 6103870000 2024 人民币 "$ar25" "$url25#page=226"
fact adj_ebitda_2024 经调整EBITDA 1944753000 2024 人民币 "$ar25" "$url25#page=24"
fact da_2024 折旧及摊销 140343000 2024 人民币 "$ar25" "$url25#page=24"
fact fv_asset_gain_2024 以公允价值计量且其变动计入损益的金融资产公允价值收益 15506000 2024 人民币 "$ar25" "$url25#page=278"
fact imputed_interest_2024 长期贸易应收款项及合约资产估算利息收入 3185000 2024 人民币 "$ar25" "$url25#page=278"
fact cash_tax_paid_2024 已付所得税 245825000 2024 人民币 "$ar25" "$url25#page=232"
fact ocf_2024 经营活动产生的现金流量净额 1320566000 2024 人民币 "$ar25" "$url25#page=232"
fact ppe_purchase_2024 购买物业厂房及设备 449095000 2024 人民币 "$ar25" "$url25#page=233"
fact intangible_purchase_2024 购买无形资产 1045000 2024 人民币 "$ar25" "$url25#page=233"
fact ppe_disposal_2024 出售物业厂房及设备所得款项 54565000 2024 人民币 "$ar25" "$url25#page=233"
fact lease_principal_2024 租赁付款本金部分 56065000 2024 人民币 "$ar25" "$url25#page=233"

fact revenue_2025 收入 12913774000 2025 人民币 "$ar25" "$url25#page=226"
fact cost_2025 销售成本 8651591000 2025 人民币 "$ar25" "$url25#page=226"
fact adj_ebitda_2025 经调整EBITDA 3365701000 2025 人民币 "$ar25" "$url25#page=24"
fact da_2025 折旧及摊销 164728000 2025 人民币 "$ar25" "$url25#page=24"
fact fv_asset_gain_2025 以公允价值计量且其变动计入损益的金融资产公允价值收益 46959000 2025 人民币 "$ar25" "$url25#page=278"
fact imputed_interest_2025 长期贸易应收款项及合约资产估算利息收入 17405000 2025 人民币 "$ar25" "$url25#page=278"
fact cash_tax_paid_2025 已付所得税 481786000 2025 人民币 "$ar25" "$url25#page=232"
fact ocf_2025 经营活动产生的现金流量净额 2408612000 2025 人民币 "$ar25" "$url25#page=232"
fact ppe_purchase_2025 购买物业厂房及设备 248323000 2025 人民币 "$ar25" "$url25#page=233"
fact ppe_disposal_2025 出售物业厂房及设备所得款项 26152000 2025 人民币 "$ar25" "$url25#page=233"
fact lease_principal_2025 租赁付款本金部分 58137000 2025 人民币 "$ar25" "$url25#page=233"

# 资产负债表原始事实；营运资金仅纳入与客户、存货、供应商及经营应付款有关项目。
fact inventory_2023 存货 881141000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact trade_receivable_2023 贸易应收款项 70416000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact contract_asset_2023 合约资产 9042000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact prepay_other_2023 预付款项其他应收款项及其他资产 298809000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact trade_payable_2023 贸易应付款项 601272000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact other_payable_2023 其他应付款项及应计费用 322219000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact ppe_payable_2023 物业厂房及设备应付款 87068000 2023-12-31 人民币 "$ar24" "$url24#page=188"
fact contract_liability_2023 合约负债 102746000 2023-12-31 人民币 "$ar24" "$url24#page=128"
fact ppe_2023 物业厂房及设备 590058000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact rou_2023 使用权资产 178401000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact intangible_2023 其他无形资产 107000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact other_noncurrent_2023 其他非流动资产 36934000 2023-12-31 人民币 "$ar24" "$url24#page=127"
fact deferred_income_2023 递延收入 10042000 2023-12-31 人民币 "$ar24" "$url24#page=128"
fact lease_liability_2023 租赁负债 70190000 2023-12-31 人民币 "$ar24" "$url24#page=177"

fact inventory_2024 存货 984244000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact trade_receivable_2024 贸易应收款项 290872000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact long_trade_receivable_2024 长期贸易应收款项 104593000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact contract_asset_2024 合约资产 40529000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact prepay_other_2024 预付款项其他应收款项及其他资产 327852000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact trade_payable_2024 贸易应付款项 697891000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact other_payable_2024 其他应付款项及应计费用 391496000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact ppe_payable_2024 物业厂房及设备应付款 106084000 2024-12-31 人民币 "$ar25" "$url25#page=310"
fact contract_liability_2024 合约负债 104089000 2024-12-31 人民币 "$ar25" "$url25#page=229"
fact ppe_2024 物业厂房及设备 954362000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact rou_2024 使用权资产 160572000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact intangible_2024 其他无形资产 852000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact other_noncurrent_2024 其他非流动资产 4732000 2024-12-31 人民币 "$ar25" "$url25#page=228"
fact deferred_income_2024 递延收入 10988000 2024-12-31 人民币 "$ar25" "$url25#page=229"
fact lease_liability_2024 租赁负债 54160000 2024-12-31 人民币 "$ar25" "$url25#page=297"

fact inventory_2025 存货 1300023000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact trade_receivable_2025 贸易应收款项 587990000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact long_trade_receivable_2025 长期贸易应收款项 164141000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact contract_asset_2025 合约资产 145796000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact prepay_other_2025 预付款项其他应收款项及其他资产 390631000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact trade_payable_2025 贸易应付款项 992105000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact other_payable_2025 其他应付款项及应计费用 2827832000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact dividend_payable_2025 应付股息 2290024000 2025-12-31 人民币 "$ar25" "$url25#page=310"
fact ppe_payable_2025 物业厂房及设备应付款 70496000 2025-12-31 人民币 "$ar25" "$url25#page=310"
fact contract_liability_2025 合约负债 58955000 2025-12-31 人民币 "$ar25" "$url25#page=229"
fact ppe_2025 物业厂房及设备 1005231000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact rou_2025 使用权资产 167161000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact intangible_2025 其他无形资产 636000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact other_noncurrent_2025 其他非流动资产 32600000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact deferred_income_2025 递延收入 21349000 2025-12-31 人民币 "$ar25" "$url25#page=229"
fact lease_liability_2025 租赁负债 57685000 2025-12-31 人民币 "$ar25" "$url25#page=297"

# 经营历史：调整后EBITDA剔除融资、上市、汇兑后，再剔除理财公允价值及估算利息，得到经营EBIT。
hist_expr 2024 revenue revenue_2024 reported high 合并损益表直接披露
hist_expr 2024 cost_of_revenue cost_2024 reported high 合并损益表直接披露
hist_expr 2024 period_operating_expenses 'revenue_2024-cost_2024-(adj_ebitda_2024-da_2024-fv_asset_gain_2024-imputed_interest_2024)' formula medium 以毛利减重构经营EBIT；保留经营性政府补助并剔除金融资产收益和估算利息
hist_expr 2024 cash_tax cash_tax_paid_2024 reported medium 以现金流量表已付所得税作为经营现金税近似；税收优惠和缴纳时点使其并非长期税率
hist_expr 2024 depreciation_amortization da_2024 reported high 年报非IFRS对账直接披露
hist_expr 2024 core_business_capex 'ppe_purchase_2024+intangible_purchase_2024-ppe_disposal_2024+lease_principal_2024' formula medium 采用经营租赁口径，计入租赁本金并以处置回款冲减
hist_est 2024 exploratory_business_capex 0 medium 未披露可与现有加盟网络分离的新业务长期资产投入 未来披露独立新品牌或新市场资本项目及其现金支出
hist_expr 2024 operating_working_capital_increase '(adj_ebitda_2024-da_2024-fv_asset_gain_2024-imputed_interest_2024)-cash_tax_paid_2024+da_2024-ocf_2024' formula medium 由NOPAT加折旧减经营现金流反推，使利润路径与现金流路径闭合；包含未单列的经营应计与税款时点差
hist_expr 2024 operating_cash_flow ocf_2024 reported high 合并现金流量表直接披露
hist_est 2024 after_tax_interest_in_operating_cash_flow 0 high 年报将利息收取列投资活动、利息支付列融资活动，经营现金流无需回加利息 年报改变现金流分类或经营现金流包含净利息

hist_expr 2025 revenue revenue_2025 reported high 合并损益表直接披露
hist_expr 2025 cost_of_revenue cost_2025 reported high 合并损益表直接披露
hist_expr 2025 period_operating_expenses 'revenue_2025-cost_2025-(adj_ebitda_2025-da_2025-fv_asset_gain_2025-imputed_interest_2025)' formula medium 以毛利减重构经营EBIT；保留经营性政府补助并剔除金融资产收益和估算利息
hist_expr 2025 cash_tax cash_tax_paid_2025 reported medium 以现金流量表已付所得税作为经营现金税近似；税收优惠和缴纳时点使其并非长期税率
hist_expr 2025 depreciation_amortization da_2025 reported high 年报非IFRS对账直接披露
hist_expr 2025 core_business_capex 'ppe_purchase_2025-ppe_disposal_2025+lease_principal_2025' formula medium 采用经营租赁口径，计入租赁本金并以处置回款冲减
hist_est 2025 exploratory_business_capex 0 medium 咖啡品类仍通过同一古茗门店网络销售，未披露可分离的新业务长期资产现金支出 未来披露独立品牌或业务及可归属资本开支
hist_expr 2025 operating_working_capital_increase '(adj_ebitda_2025-da_2025-fv_asset_gain_2025-imputed_interest_2025)-cash_tax_paid_2025+da_2025-ocf_2025' formula medium 由NOPAT加折旧减经营现金流反推，使利润路径与现金流路径闭合；包含未单列的经营应计与税款时点差
hist_expr 2025 operating_cash_flow ocf_2025 reported high 合并现金流量表直接披露
hist_est 2025 after_tax_interest_in_operating_cash_flow 0 high 年报将利息收取列投资活动、利息支付列融资活动，经营现金流无需回加利息 年报改变现金流分类或经营现金流包含净利息

# 投入资本：租赁作为经营口径，使用权资产与租赁负债净列；金融资产、所得税及股息应付不进入营运资金。
cap_expr 2023 operating_working_capital 'inventory_2023+trade_receivable_2023+contract_asset_2023+prepay_other_2023-trade_payable_2023-(other_payable_2023-ppe_payable_2023)-contract_liability_2023' formula medium 客户与供应链相关经营流动资产减无息经营负债
cap_expr 2023 operating_long_term_assets_net 'ppe_2023+rou_2023+intangible_2023+other_noncurrent_2023-ppe_payable_2023-deferred_income_2023-lease_liability_2023' formula medium 经营长期资产扣工程应付款、资产补助和租赁负债
cap_est 2023 required_cash 480000000 low 约覆盖一个月现金经营成本，因未披露月度季节性只能作基准估计 月度现金支出、旺季资金峰值或可动用授信证明所需现金显著不同
cap_est 2023 unsupported_intangible_assets 0 high 账面无形资产仅为小额经营软件，不属于无法解释并购溢价 发现商誉、失效软件或不服务主营的无形资产

cap_expr 2024 operating_working_capital 'inventory_2024+trade_receivable_2024+long_trade_receivable_2024+contract_asset_2024+prepay_other_2024-trade_payable_2024-(other_payable_2024-ppe_payable_2024)-contract_liability_2024' formula medium 客户与供应链相关经营资产减无息经营负债
cap_expr 2024 operating_long_term_assets_net 'ppe_2024+rou_2024+intangible_2024+other_noncurrent_2024-ppe_payable_2024-deferred_income_2024-lease_liability_2024' formula medium 经营长期资产扣工程应付款、资产补助和租赁负债
cap_est 2024 required_cash 570000000 low 约覆盖一个月现金经营成本，因未披露月度季节性只能作基准估计 月度现金支出、旺季资金峰值或可动用授信证明所需现金显著不同
cap_est 2024 unsupported_intangible_assets 0 high 账面无形资产仅为小额经营软件，不属于无法解释并购溢价 发现商誉、失效软件或不服务主营的无形资产

cap_expr 2025 operating_working_capital 'inventory_2025+trade_receivable_2025+long_trade_receivable_2025+contract_asset_2025+prepay_other_2025-trade_payable_2025-(other_payable_2025-dividend_payable_2025-ppe_payable_2025)-contract_liability_2025' formula medium 客户与供应链相关经营资产减无息经营负债；应付股息另作优先索偿
cap_expr 2025 operating_long_term_assets_net 'ppe_2025+rou_2025+intangible_2025+other_noncurrent_2025-ppe_payable_2025-deferred_income_2025-lease_liability_2025' formula medium 经营长期资产扣工程应付款、资产补助和租赁负债
cap_est 2025 required_cash 820000000 low 约覆盖一个月现金经营成本，因未披露月度季节性只能作基准估计 月度现金支出、旺季资金峰值或可动用授信证明所需现金显著不同
cap_est 2025 unsupported_intangible_assets 0 high 账面无形资产仅为小额经营软件，不属于无法解释并购溢价 发现商誉、失效软件或不服务主营的无形资产

# 稳定经营标尺：固定2025收入，利润率回落至22%，税率20%，资本开支取两年约中点，营运资金不再永久增长。
stable_est revenue 12913774000 low 固定在2025收入而不给未来开店额外价值；两年历史不足以可靠估计成熟收入 更多年度同店、关店率和门店成熟曲线可推翻该收入基准
stable_est cost_of_revenue 8651591000 medium 采用2025实际成本率，反映供应链规模效率与现有品类结构 原料价格、加盟供货折扣或品类结构令正常成本率显著变化
stable_est period_operating_expenses 1421152720 low 令稳定EBIT率为22%，低于2025重构的24.3%，以消化平台补贴和扩张高点的不确定性 平台补贴退潮后同店GMV与利润率仍稳定在2025水平
stable_est cash_tax 568206056 low 按稳定EBIT的20%估计，介于优惠税率与25%法定税率之间 税收优惠到期、子公司利润分布或预扣税使长期现金税率显著偏离20%
stable_est depreciation_amortization 164728000 medium 采用2025折旧摊销，作为现有仓储加工资产正常损耗起点 新设施投产后折旧或资产寿命显著变化
stable_est core_business_capex 366000000 low 取2024至2025经营口径资本开支约中点，覆盖仓配加工和租赁更新 连续年度成熟网络维持及扩张资本开支显著偏离该水平
stable_est exploratory_business_capex 0 medium 固定标尺不为未分离的新业务赋值 独立新业务的市场、现金投入与商业化路径得到披露
stable_est operating_working_capital_increase 0 low 稳定收入假设下不永久增加营运资金；增长期占用已在历史FCFF体现 稳定收入仍因账期、库存安全量或合同条款持续占用现金

# 最新年度业务树。
fact goods_equipment_revenue_2025 销售商品及设备收入 10269166000 2025 人民币 "$ar25" "$url25#page=273"
fact franchise_service_revenue_2025 加盟管理服务收入 2628266000 2025 人民币 "$ar25" "$url25#page=273"
fact company_store_revenue_2025 直营门店销售收入 16342000 2025 人民币 "$ar25" "$url25#page=273"
python3 "$tool" add-business --model "$model" --business-id supply --name 加盟门店商品及设备供应 --importance 收入主体；原料设备采购、加工、库存及冷链配送决定毛利与现金占用 --confidence medium --falsifier 后续分部成本披露显示商品设备业务毛利结构显著不同
python3 "$tool" add-business --model "$model" --business-id services --name 加盟管理与支持服务 --importance 高毛利服务；选址培训、数字化、督导和品牌支持把门店GMV转成持续服务费 --confidence low --falsifier 后续分部成本或人员归属披露显示服务成本及费用显著更高
python3 "$tool" add-business --model "$model" --business-id ownstores --name 直营门店零售 --importance 规模很小但闭合公司收入；直接承担门店人工租金及零售风险 --confidence low --falsifier 直营门店数量、店级利润或成本披露显示经营贡献显著不同

biz_expr supply revenue goods_equipment_revenue_2025 reported high 年报附注5分类收入直接披露
biz_est supply cost_of_revenue 8350000000 low 绝大多数销售成本归属实物商品设备，估计该业务毛利率18.7% 分产品毛利或商品采购加工物流成本披露使毛利率偏离5个百分点以上
biz_est supply period_operating_expenses 420000000 low 归属供应链采购、仓储物流和设备销售相关期间费用 分部费用或人员职能披露显示供应链业务费用显著偏离
biz_est supply cash_tax 230213000 low 按两项正EBIT业务的EBIT比例分配公司经营现金税 分部纳税主体、税率或税收优惠披露使税负分配显著不同
biz_est supply operating_cash_flow_contribution 900000000 low 商品供应承担绝大部分库存和应收增长，现金贡献低于NOPAT 分业务营运资金或现金流披露显示供应业务现金转换显著不同

biz_expr services revenue franchise_service_revenue_2025 reported high 年报附注5分类收入直接披露
biz_est services cost_of_revenue 290000000 low 服务成本以人员、培训和系统履约为主，估计毛利率89.0% 分部毛利或服务履约成本披露使毛利率偏离5个百分点以上
biz_est services period_operating_expenses 700000000 low 将品牌营销、督导、产品研发和大部分总部费用归入加盟服务 分部费用或人员职能披露显示服务费用显著偏离
biz_est services cash_tax 251573000 low 按两项正EBIT业务的EBIT比例分配公司经营现金税 分部纳税主体、税率或税收优惠披露使税负分配显著不同
biz_est services operating_cash_flow_contribution 1510000000 low 服务收费和加盟费预收特征使其承担较少库存，作为主要现金贡献者 分业务合同资产、递延收费及现金流披露显示服务回款更慢

biz_expr ownstores revenue company_store_revenue_2025 reported high 年报附注5分类收入直接披露
biz_est ownstores cost_of_revenue 11591000 low 以公司成本余额闭合，约29.1%直营毛利率 店级商品、人工和租金成本披露显示毛利显著不同
biz_est ownstores period_operating_expenses 5574000 low 以公司期间费用余额闭合，小规模直营网络略亏损 门店数量与店级费用披露显示直营业务盈利
biz_est ownstores cash_tax 0 low 基准估计为税前小幅亏损，不分配经营现金税 直营业务独立应税利润或税务主体披露
biz_est ownstores operating_cash_flow_contribution -1388000 low 以公司经营现金流余额闭合，不把极小业务塑造成利润来源 直营门店现金流或店级经济性披露显示正贡献

# 普通股价值桥。
fact cash_bank_2025 现金及银行结余 4320595000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact long_bank_deposit_2025 长期银行存款 411860000 2025-12-31 人民币 "$ar25" "$url25#page=228"
fact wealth_products_2025 理财产品 1347282000 2025-12-31 人民币 "$ar25" "$url25#page=308"
fact equity_investment_2025 认养一头牛非上市股权投资公允价值 240769000 2025-12-31 人民币 "$ar25" "$url25#page=299"
fact restricted_cash_2025 受限制现金 6481855000 2025-12-31 人民币 "$ar25" "$url25#page=309"
fact bank_borrowing_2025 计息银行借款 6461772000 2025-12-31 人民币 "$ar25" "$url25#page=229"
fact nci_profit_2025 非控股权益应占利润 6371000 2025 人民币 "$ar25" "$url25#page=226"
fact issued_shares_2025 已发行及缴足普通股股数 2378185860 2025-12-31 股 "$ar25" "$url25#page=321"
fact cny_hkd_20251231 人民币兑港元 1.1144 2025-12-31 港元每人民币 "$fxsrc" "$fxurl"

eq_expr excess_cash 'cash_bank_2025+long_bank_deposit_2025-820000000' formula low 账面可用现金及长期存款扣除与投入资本一致的经营必需现金；未付股息另行扣除
eq_expr non_operating_assets 'wealth_products_2025+equity_investment_2025+restricted_cash_2025' formula medium 理财、非上市股权及为收益管理借款质押的现金均不参与经营FCFF；质押现金与债务分别全额列示
eq_expr financing_debt bank_borrowing_2025 reported high 年末计息银行借款；经营租赁已按经营口径处理，不重复扣租赁负债
eq_est minority_interest_value 50968000 low 以2025非控股权益应占利润乘八倍近似经济价值，优于直接采用账面值 子公司独立FCFF、债务现金和所有权比例支持更可靠估值
eq_expr other_priority_claims dividend_payable_2025 reported high 年末已宣派未支付股息在普通股价值之前扣除
eq_expr diluted_shares issued_shares_2025 reported high 年末股本；报告期内上市后股份计划无授出，未识别额外实质摊薄工具
eq_expr financial_to_trading_fx cny_hkd_20251231 reported high 香港金管局2025年12月31日每日收市数据，1人民币兑1.1144港元

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason 仅有两个可用年度且2025单店GMV受外卖平台补贴推动，缺少到达稳定状态时间、逐年FCFF和完整成长投入证据，采用稳定经营收益八倍固定标尺 --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name 经营EBIT重构 --before 2025年报经营利润32.76亿元 --after 重构经营EBIT31.37亿元 --reason 剔除银行及估算利息、理财公允价值、上市开支和汇兑等融资或一次性项目；保留与经营设施及地方经营有关补助
python3 "$tool" add-adjustment --model "$model" --name 质押现金与收益管理借款 --before 受限制现金64.82亿元、银行借款64.62亿元 --after 分别作为非经营资产加回及融资负债扣除 --reason 二者源于利差型现金管理且受限制现金不能直接作为多余现金；分别列示避免把高杠杆误读为经营融资需求
python3 "$tool" add-adjustment --model "$model" --name 已宣派未付股息 --before 年末应付股息22.90亿元 --after 作为其他重大优先索偿扣除 --reason 对应现金仍在年末账上但已归属于既定收款股东，不能再次归入全体普通股价值
python3 "$tool" add-adjustment --model "$model" --name 稳定利润率 --before 2025重构EBIT率24.3% --after 固定标尺采用22.0% --reason 2025单店GMV受外卖平台补贴和新品推动，且仅有两个年度，保守回撤利润率而不把高点永久化

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason ROIC保留计算但正文限定为资本占用结构；品牌研发费用化及经营必需现金低可信使其不用于证明护城河
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason 所有重大财务事实记录年报名称、期间、币种、合并范围及公开PDF页码，汇率记录金管局来源
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason 经营、金融资产、质押现金、债务、股息索偿及租赁口径分别处理且避免重复
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason 两年证据不足已降为benchmark；稳定期固定收入、回撤利润率、正常税率资本开支及零增长营运资金相互一致
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason 报告重大数字、业务闭合和价值桥将以编译后的结构化模型为唯一口径

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

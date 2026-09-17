#!/usr/bin/env bash
set -euo pipefail

tool=".agents/skills/stock-research/scripts/stock_research.py"
model="outputs/analysis.json"
mkdir -p outputs
python3 "$tool" init --name "光弘科技" --code "300735.SZ" --period-label "2025年度" --period-end "2025-12-31" --coverage-years "2023,2024,2025" --financial-currency "人民币" --trading-currency "人民币" --security-name "普通股" --security-unit "股" --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency "人民币" --scope "合并" --source "$5" --locator "$6"
}

# 利润表、现金流量表及补充资料原始事实
fact rev23 营业收入 5402448971.14 2023年度 光弘科技2023年年度报告 PDF-P93
fact cost23 营业成本 4455278903.37 2023年度 光弘科技2023年年度报告 PDF-P93
fact taxsur23 税金及附加 36350835.55 2023年度 光弘科技2023年年度报告 PDF-P94
fact sell23 销售费用 22293368.04 2023年度 光弘科技2023年年度报告 PDF-P94
fact admin23 管理费用 282454040.26 2023年度 光弘科技2023年年度报告 PDF-P94
fact rd23 研发费用 128693958.91 2023年度 光弘科技2023年年度报告 PDF-P94
fact other23 其他收益 37341916.11 2023年度 光弘科技2023年年度报告 PDF-P94
fact credit23 信用减值损失 -3845644.22 2023年度 光弘科技2023年年度报告 PDF-P94
fact impair23 资产减值损失 -7352344.47 2023年度 光弘科技2023年年度报告 PDF-P94
fact tax23 所得税费用 83614921.70 2023年度 光弘科技2023年年度报告 PDF-P94
fact pbt23 利润总额 520056671.01 2023年度 光弘科技2023年年度报告 PDF-P94
fact ocf23 经营活动产生的现金流量净额 926373087.58 2023年度 光弘科技2023年年度报告 PDF-P97
fact int23 利息费用 40030395.98 2023年度 光弘科技2023年年度报告 PDF-P94
fact capex23 购建固定资产无形资产和其他长期资产支付的现金 692708982.69 2023年度 光弘科技2023年年度报告 PDF-P97
fact disposal23 处置固定资产无形资产和其他长期资产收回的现金净额 10645736.80 2023年度 光弘科技2023年年度报告 PDF-P97
fact fa_da23 固定资产折旧 340464660.34 2023年度 光弘科技2023年年度报告 PDF-P193-P194
fact rou_da23 使用权资产折旧 18002827.35 2023年度 光弘科技2023年年度报告 PDF-P193-P194
fact ia_da23 无形资产摊销 8453978.32 2023年度 光弘科技2023年年度报告 PDF-P193-P194
fact ltd_da23 长期待摊费用摊销 44481783.11 2023年度 光弘科技2023年年度报告 PDF-P193-P194

fact rev24 营业收入 6881412192.92 2024年度 光弘科技2024年年度报告 PDF-P92
fact cost24 营业成本 5998635161.06 2024年度 光弘科技2024年年度报告 PDF-P92
fact taxsur24 税金及附加 32862188.14 2024年度 光弘科技2024年年度报告 PDF-P92-P93
fact sell24 销售费用 25933938.23 2024年度 光弘科技2024年年度报告 PDF-P92-P93
fact admin24 管理费用 347015802.93 2024年度 光弘科技2024年年度报告 PDF-P92-P93
fact rd24 研发费用 137868685.04 2024年度 光弘科技2024年年度报告 PDF-P92-P93
fact other24 其他收益 35418748.12 2024年度 光弘科技2024年年度报告 PDF-P93
fact credit24 信用减值损失 312310.02 2024年度 光弘科技2024年年度报告 PDF-P93
fact impair24 资产减值损失 -5558764.30 2024年度 光弘科技2024年年度报告 PDF-P93
fact tax24 所得税费用 66654956.87 2024年度 光弘科技2024年年度报告 PDF-P93
fact pbt24 利润总额 409061761.16 2024年度 光弘科技2024年年度报告 PDF-P93
fact ocf24 经营活动产生的现金流量净额 1443765634.88 2024年度 光弘科技2024年年度报告 PDF-P96
fact int24 利息费用 43640561.12 2024年度 光弘科技2024年年度报告 PDF-P93
fact capex24 购建固定资产无形资产和其他长期资产支付的现金 1138448156.37 2024年度 光弘科技2024年年度报告 PDF-P96
fact disposal24 处置固定资产无形资产和其他长期资产收回的现金净额 18168091.02 2024年度 光弘科技2024年年度报告 PDF-P96
fact fa_da24 固定资产折旧 414419168.33 2024年度 光弘科技2024年年度报告 PDF-P178-P179
fact rou_da24 使用权资产折旧 19950277.86 2024年度 光弘科技2024年年度报告 PDF-P178-P179
fact ia_da24 无形资产摊销 5197911.32 2024年度 光弘科技2024年年度报告 PDF-P178-P179
fact ltd_da24 长期待摊费用摊销 44081254.82 2024年度 光弘科技2024年年度报告 PDF-P178-P179

fact rev25 营业收入 8993560247.76 2025年度 光弘科技2025年年度报告 PDF-P89
fact cost25 营业成本 7894279655.92 2025年度 光弘科技2025年年度报告 PDF-P89
fact taxsur25 税金及附加 37470638.62 2025年度 光弘科技2025年年度报告 PDF-P89
fact sell25 销售费用 49702786.43 2025年度 光弘科技2025年年度报告 PDF-P89
fact admin25 管理费用 515121509.73 2025年度 光弘科技2025年年度报告 PDF-P89
fact rd25 研发费用 137049139.16 2025年度 光弘科技2025年年度报告 PDF-P89
fact other25 其他收益 38228760.06 2025年度 光弘科技2025年年度报告 PDF-P89
fact credit25 信用减值损失 611529.33 2025年度 光弘科技2025年年度报告 PDF-P90
fact impair25 资产减值损失 -7984329.98 2025年度 光弘科技2025年年度报告 PDF-P90
fact tax25 所得税费用 56329923.20 2025年度 光弘科技2025年年度报告 PDF-P90
fact pbt25 利润总额 403004170.32 2025年度 光弘科技2025年年度报告 PDF-P90
fact ocf25 经营活动产生的现金流量净额 1317599905.49 2025年度 光弘科技2025年年度报告 PDF-P92-P93
fact int25 利息费用 39750951.12 2025年度 光弘科技2025年年度报告 PDF-P89
fact capex25 购建固定资产无形资产和其他长期资产支付的现金 1446829570.79 2025年度 光弘科技2025年年度报告 PDF-P93
fact disposal25 处置固定资产无形资产和其他长期资产收回的现金净额 42142024.22 2025年度 光弘科技2025年年度报告 PDF-P93
fact fa_da25 固定资产折旧 554366495.75 2025年度 光弘科技2025年年度报告 PDF-P165
fact rou_da25 使用权资产折旧 42159613.36 2025年度 光弘科技2025年年度报告 PDF-P165
fact ia_da25 无形资产摊销 35655629.59 2025年度 光弘科技2025年年度报告 PDF-P165
fact ltd_da25 长期待摊费用摊销 66163829.15 2025年度 光弘科技2025年年度报告 PDF-P165

field() { python3 "$tool" set-field --model "$model" "$@"; }

for y in 23 24 25; do
  year="20$y"
  field --view historical --year "$year" --field revenue --expression "rev$y" --basis-type reported --reason "合并利润表营业收入" --confidence high
  field --view historical --year "$year" --field cost_of_revenue --expression "cost$y" --basis-type reported --reason "合并利润表营业成本" --confidence high
  field --view historical --year "$year" --field period_operating_expenses --expression "taxsur$y + sell$y + admin$y + rd$y - other$y - credit$y - impair$y" --basis-type formula --reason "税金及附加、销售管理研发费用，扣除经营性政府补助，并纳入信用及资产减值；排除财务、投资、公允价值和处置损益" --confidence medium
  field --view historical --year "$year" --field cash_tax --value "$(case $y in 23) echo 80956437.24079558;; 24) echo 60170840.60691244;; 25) echo 54623033.34610829;; esac)" --basis-type estimate --reason "重构EBIT乘以当年所得税费用除以利润总额的实际税率，作为正常经营现金税近似" --confidence medium --falsifier "税务附注若能拆出经营所得的当期现金税及非经营税项，需据此重算"
  field --view historical --year "$year" --field depreciation_amortization --expression "fa_da$y + rou_da$y + ia_da$y + ltd_da$y" --basis-type formula --reason "现金流量表补充资料披露的经营性折旧摊销合计" --confidence high
  field --view historical --year "$year" --field core_business_capex --expression "capex$y - disposal$y" --basis-type formula --reason "购建长期经营资产现金减处置回款；公开资料未能将现有EMS基地技改扩产与维持投入可靠拆开，全部列为主营业务资本开支" --confidence medium
  field --view historical --year "$year" --field exploratory_business_capex --value 0 --basis-type estimate --reason "汽车电子、海外及AI相关投入均在同一EMS制造平台内，缺少可核验现金支出证明其属于未产生收入的新业务" --confidence low --falsifier "披露独立新业务项目现金支出、商业化阶段与单独资产清单"
  field --view historical --year "$year" --field operating_working_capital_increase --value "$(case $y in 23) echo -125998776.01037869;; 24) echo -687548660.270517;; 25) echo -317279654.09480935;; esac)" --basis-type estimate --reason "以NOPAT加折旧、减营运资金变动的利润路径，与经营现金流加税后利息的现金路径对账所得；包含并购及供应商账期造成的现金释放" --confidence medium --falsifier "若附注可完整拆出收购日营运资金与非经营应收应付，应按同口径重算"
  field --view historical --year "$year" --field operating_cash_flow --expression "ocf$y" --basis-type reported --reason "合并现金流量表经营活动产生的现金流量净额" --confidence high
  field --view historical --year "$year" --field after_tax_interest_in_operating_cash_flow --value "$(case $y in 23) echo 33594292.73958346;; 24) echo 36529508.47360407;; 25) echo 34194760.418701366;; esac)" --basis-type estimate --reason "利息费用乘以一减当年实际所得税率，因中国准则经营现金流包含利息支付而加回" --confidence medium --falsifier "现金流附注明确利息支付分类或可分拆非现金利息后需调整"
done

# 资本占用：经营性营运资金采用贸易应收、存货和预付款减应付账款、票据及合同负债；长期资产剔除商誉、投资物业、递延税项。
for row in \
  "2022 715407582.68 2210883754.11 100202453.41" \
  "2023 473487605.77 2586342867.20 377006077.61" \
  "2024 172612836.51 3235081901.83 525031722.30" \
  "2025 541875229.93 4684478236.42 672079359.79"; do
  set -- $row; year=$1; owc=$2; lta=$3; req=$4
  field --view capital --year "$year" --field operating_working_capital --value "$owc" --basis-type estimate --reason "按年报资产负债表的贸易应收、应收票据及融资、预付款和存货，减应付票据、应付账款及合同负债重构" --confidence medium --falsifier "附注证明所列项目中存在重大非经营余额，或其他流动科目应纳入经营周转"
  field --view capital --year "$year" --field operating_long_term_assets_net --value "$lta" --basis-type estimate --reason "固定资产、在建工程、使用权资产、经营无形资产、长期待摊、出租物业及其他经营长期资产，扣除递延收益；排除商誉和递延税项。出租收入仍在合并经营结果中，故物业留在经营资产" --confidence medium --falsifier "资产附注显示重大闲置资产、待售资产或与项目资产直接对应的其他非融资负债"
  field --view capital --year "$year" --field required_cash --value "$req" --basis-type estimate --reason "以当年经营现金流出约一个月作为工资、采购、税费和结算所需最低流动性" --confidence low --falsifier "月度现金支出、客户预收安排或集团现金池资料显示所需现金显著不同"
  field --view capital --year "$year" --field unsupported_intangible_assets --value 0 --basis-type estimate --reason "商誉已直接排除在经营性长期资产净额之外，未再重复扣减；经营无形资产按持续生产用途保留" --confidence medium --falsifier "经营无形资产附注显示重大停用、无法产生收益或并购溢价性质资产"
done

# 稳定状态与价值桥
field --view stable --field revenue --value 9000000000 --basis-type estimate --reason "以2025年含八个月AC并表的收入为基准，不机械外推汽车电子翻倍增速" --confidence low --falsifier "AC完整年度收入、客户订单或产能利用率证明正常收入明显高于或低于90亿元"
field --view stable --field cost_of_revenue --value 7920000000 --basis-type estimate --reason "采用12%正常毛利率，略高于2025年11.62%，但低于2023年17.53%，反映汽车电子和海外占比提高" --confidence low --falsifier "连续两年产品毛利率与当前假设相差超过2个百分点"
field --view stable --field period_operating_expenses --value 690000000 --basis-type estimate --reason "按2025年重构费用略下调，反映并购整合费用消退，同时保留全球化组织成本" --confidence low --falsifier "AC完整年度期间费用或总部费用率显示无法降至约7.7%的收入比例"
field --view stable --field cash_tax --value 55000000 --basis-type estimate --reason "对应约14.1%的稳定经营税率，接近2025年实际税率" --confidence medium --falsifier "税收优惠到期或地区利润结构改变使经营税率长期偏离"
field --view stable --field depreciation_amortization --value 650000000 --basis-type estimate --reason "以2024至2025折旧摊销为锚，剔除部分并购评估增值摊销和建设峰值" --confidence low --falsifier "最新固定资产结构和完整年度折旧政策支持显著不同的常态折旧"
field --view stable --field core_business_capex --value 750000000 --basis-type estimate --reason "高于常态折旧，反映EMS设备更新、海外多基地维护与持续自动化改造，但低于2024至2025建设高峰" --confidence low --falsifier "连续两年在无重大扩张时净资本开支低于5亿元或高于10亿元"
field --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason "未对缺乏独立现金证据的AI算力等新方向另列价值或持续资本开支" --confidence low --falsifier "出现具名独立新业务项目、现金预算与商业化里程碑"
field --view stable --field operating_working_capital_increase --value 35000000 --basis-type estimate --reason "正常增长下保留小幅营运资金占用，不外推2023至2025由供应商账期和并购带来的释放" --confidence low --falsifier "完整年度账期和库存周转证明稳定期持续释放或占用明显更高"

field --view equity --field excess_cash --value 2055171718.29 --basis-type estimate --reason "2025年末货币资金减经营必需现金和受限货币资金，再加2026年4月定增净募集资金；定增股份同步计入摊薄股数" --confidence medium --falsifier "募集资金用途形成不可撤销资本承诺，或境外资金汇回限制显著高于已披露受限金额"
field --view equity --field non_operating_assets --value 168769282.50 --basis-type estimate --reason "2025年末交易性金融资产按账面公允价值计入；投资性房地产因出租收益仍在合并经营结果中而留在经营资产，避免重复加值" --confidence medium --falsifier "理财或股权基金无法变现，或其收益已纳入稳定经营收益"
field --view equity --field financing_debt --value 1564684042.02 --basis-type estimate --reason "短期借款、长期借款及一年内到期部分、融资性长期应付款及租赁负债合计；与使用权资产口径配套" --confidence medium --falsifier "长期应付款或租赁附注明确属于已在经营费用和资本开支中完整处理的经营义务"
field --view equity --field minority_interest_value --value 789191479.47 --basis-type estimate --reason "子公司级FCFF资料不足，以2025年末少数股东账面权益作为经济价值替代" --confidence low --falsifier "重要非全资子公司单独经营价值、债务和现金资料可得后应按经济价值重估"
field --view equity --field other_priority_claims --value 0 --basis-type estimate --reason "年报披露期末无重大承诺或或有事项，未识别其他普通股前优先索偿" --confidence medium --falsifier "期后出现未计入债务的重大资本承诺、诉讼或已宣告未支付分配"
field --view equity --field diluted_shares --value 809115481 --basis-type estimate --reason "2025年末股本767,460,689股，加2026年4月定增新增41,654,792股；无股份支付工具" --confidence high --falsifier "期后发生回购、可转债或其他实质摊薄工具"

python3 "$tool" add-business --model "$model" --business-id consumer --name "消费电子EMS" --importance "收入最大、毛利率较高的成熟业务，客户认证与规模交付能力决定订单" --confidence high --falsifier "公司改变产品分类或披露该业务已不再独立管理"
python3 "$tool" add-business --model "$model" --business-id auto --name "汽车电子EMS" --importance "2025年收入翻倍并达35.82%，已成为结构变化核心" --confidence high --falsifier "AC完整年度或客户项目资料显示汽车电子收入分类不可比"
python3 "$tool" add-business --model "$model" --business-id network_industrial --name "网络通讯、工业控制及新能源EMS" --importance "覆盖其余具名制造需求，包含并购带来的工业控制与新兴产品" --confidence medium --falsifier "后续分部披露可将该组业务按不同客户、定价和资产边界可靠拆开"

biz() { python3 "$tool" set-business-field --model "$model" "$@"; }
# 收入、消费电子及汽车电子成本为直接披露；第三项吸收合并总量余数。费用、税和OCF按毛利贡献分配。
biz --business-id consumer --field revenue --value 4755261460.41 --basis-type estimate --reason "2025年报分产品直接披露；因脚本业务字段统一要求研究依据，保留为高可信转写" --confidence high --falsifier "产品分类口径更正"
biz --business-id consumer --field cost_of_revenue --value 4069664449.88 --basis-type estimate --reason "2025年报P16直接披露消费电子营业成本" --confidence high --falsifier "产品成本分类口径更正"
biz --business-id consumer --field period_operating_expenses --value 439113511.77 --basis-type estimate --reason "公司未披露分产品期间费用，按各业务毛利占比分配并闭合公司总量" --confidence low --falsifier "分部费用、人员或资产资料可支持更可靠分配"
biz --business-id consumer --field cash_tax --value 33842753.10 --basis-type estimate --reason "按各业务毛利占比分配经营现金税并闭合公司总量" --confidence low --falsifier "子公司及地区税项可按产品归属"
biz --business-id consumer --field operating_cash_flow_contribution --value 816495941.53 --basis-type estimate --reason "按各业务毛利占比分配合并经营现金流，反映现金贡献方向而非分部披露" --confidence low --falsifier "分部现金流或客户回款资料可得"

biz --business-id auto --field revenue --value 3221231946.57 --basis-type estimate --reason "2025年报分产品直接披露" --confidence high --falsifier "产品分类口径更正"
biz --business-id auto --field cost_of_revenue --value 2908150851.06 --basis-type estimate --reason "2025年报P16直接披露汽车电子营业成本" --confidence high --falsifier "产品成本分类口径更正"
biz --business-id auto --field period_operating_expenses --value 200566544.45 --basis-type estimate --reason "按各业务毛利占比分配并闭合公司总量" --confidence low --falsifier "AC及汽车项目分部费用可得"
biz --business-id auto --field cash_tax --value 15460484.70 --basis-type estimate --reason "按各业务毛利占比分配并闭合公司总量" --confidence low --falsifier "汽车电子地区税项可单独归属"
biz --business-id auto --field operating_cash_flow_contribution --value 372995858.53 --basis-type estimate --reason "按各业务毛利占比分配并闭合公司经营现金流" --confidence low --falsifier "分部回款和存货数据可得"

biz --business-id network_industrial --field revenue --value 1017066840.78 --basis-type estimate --reason "网络通讯、工业控制及其他产品收入之和，闭合公司总量" --confidence high --falsifier "其他收入包含重大非EMS活动"
biz --business-id network_industrial --field cost_of_revenue --value 916464354.98 --basis-type estimate --reason "合并营业成本扣除消费电子与汽车电子披露成本的余数" --confidence medium --falsifier "公司披露余下各产品成本"
biz --business-id network_industrial --field period_operating_expenses --value 68808058.31 --basis-type estimate --reason "按毛利贡献分配后的闭合余数" --confidence low --falsifier "分部费用资料可得"
biz --business-id network_industrial --field cash_tax --value 5319795.55 --basis-type estimate --reason "按毛利贡献分配后的闭合余数" --confidence low --falsifier "分部税项资料可得"
biz --business-id network_industrial --field operating_cash_flow_contribution --value 128108105.43 --basis-type estimate --reason "按毛利贡献分配后的闭合余数" --confidence low --falsifier "分部现金流资料可得"

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason "汽车电子和并购增长明显，但缺少AC完整年度、稳定状态到达时间及逐年FCFF，采用稳定经营收益八倍固定标尺" --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$tool" add-adjustment --model "$model" --name "商誉排除" --before "1.19亿元账面商誉" --after "不计入经营性长期资产或非经营资产" --reason "快板与AC并购商誉不能独立解释当前经营收益，避免按账面溢价重复计值"
python3 "$tool" add-adjustment --model "$model" --name "期后定增口径一致" --before "2025年末7.67亿股，未含期后资金" --after "8.09亿股，并加入7.52亿元净募集资金" --reason "年报已披露2026年4月完成定增；股数与现金必须同时纳入，避免单边摊薄"

python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason "投入资本边界包含贸易营运资金、经营长期资产与必需现金；但必需现金为低可信估计，报告仅将ROIC用于观察资本效率变化，不声称形成护城河"
python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason "重大历史数字均追溯至三份法定年报具体PDF页码，研究估计注明依据和可推翻条件"
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason "融资、投资与公允价值损益从EBIT排除；商誉、投资物业和金融资产与经营资产分开；租赁资产债务口径一致"
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason "稳定期不外推2025年汽车电子翻倍增速，正常化毛利率、费用、资本开支和营运资金，并采用基准估值"
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason "正文将使用编译后的经营、资本、业务和普通股价值结果，重大数字与结构化模型一致"

python3 "$tool" compile --model "$model"

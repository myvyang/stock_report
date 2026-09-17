#!/usr/bin/env bash
set -euo pipefail

TOOL=.agents/skills/stock-research/scripts/stock_research.py
MODEL=outputs/analysis.json

python3 "$TOOL" init --name '小鵬集團－Ｗ' --code '09868.HK' --period-label '截至2025年12月31日止年度' --period-end '2025-12-31' --coverage-years '2023,2024,2025' --financial-currency '人民币' --trading-currency '港元' --security-name '普通股' --security-unit '股' --output "$MODEL"

fact() { python3 "$TOOL" add-fact --model "$MODEL" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency '人民币' --scope 'consolidated' --source "$5" --locator "$6"; }
field() {
  if [[ -n "$2" ]]; then
    python3 "$TOOL" set-field --model "$MODEL" --view "$1" --year "$2" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7" "${@:8}"
  else
    python3 "$TOOL" set-field --model "$MODEL" --view "$1" --field "$3" --expression "$4" --basis-type "$5" --reason "$6" --confidence "$7" "${@:8}"
  fi
}
estfield() {
  if [[ -n "$2" ]]; then
    python3 "$TOOL" set-field --model "$MODEL" --view "$1" --year "$2" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  else
    python3 "$TOOL" set-field --model "$MODEL" --view "$1" --field "$3" --value "$4" --basis-type estimate --reason "$5" --confidence "$6" --falsifier "$7"
  fi
}

AR23='小鹏汽车2023年年度报告（2024-04-17）'
AR24='小鹏汽车2024年年度报告（2025-04-16）'
AR25='小鹏汽车2025年年度报告（2026-04-16）'

# Historical operating facts (RMB; annual reports disclose RMB thousands).
fact rev23 'Total revenues' 30676067000 'FY2023' "$AR23" 'PDF p.230 (report p.228)'
fact cost23 'Total cost of sales' 30224912000 'FY2023' "$AR23" 'PDF p.230 (report p.228)'
fact rd23 'Research and development expenses' 5276574000 'FY2023' "$AR23" 'PDF p.230 (report p.228)'
fact sga23 'Selling, general and administrative expenses' 6558942000 'FY2023' "$AR23" 'PDF p.230 (report p.228)'
fact otherinc23 'Other income, net' 465588000 'FY2023' "$AR23" 'PDF p.230 (report p.228)'
fact da23_ppe 'Depreciation of property, plant and equipment' 1645760000 'FY2023' "$AR23" 'PDF p.234 (report p.232)'
fact da23_int 'Amortization of intangible assets' 230501000 'FY2023' "$AR23" 'PDF p.234 (report p.232)'
fact da23_rou 'Amortization of right-of-use assets' 182195000 'FY2023' "$AR23" 'PDF p.234 (report p.232)'
fact da23_land 'Amortization of land use rights' 48828000 'FY2023' "$AR23" 'PDF p.234 (report p.232)'
fact ocf23 'Net cash provided by operating activities' 956164000 'FY2023' "$AR23" 'PDF p.234 (report p.232)'
fact int23 'Cash paid for interest, net of amounts capitalized' 306656000 'FY2023' "$AR23" 'PDF p.236 (report p.234)'
fact ppe23 'Purchase of property, plant and equipment' 2096326000 'FY2023' "$AR23" 'PDF p.235 (report p.233)'
fact ia23 'Purchase of intangible assets' 124838000 'FY2023' "$AR23" 'PDF p.235 (report p.233)'
fact land23 'Purchase of land use rights' 90341000 'FY2023' "$AR23" 'PDF p.235 (report p.233)'
fact disp23 'Disposal of property, plant and equipment' 8380000 'FY2023' "$AR23" 'PDF p.235 (report p.233)'

fact rev24 'Total revenues' 40866309000 'FY2024' "$AR24" 'PDF p.215 (report p.213)'
fact cost24 'Total cost of sales' 35020541000 'FY2024' "$AR24" 'PDF p.215 (report p.213)'
fact rd24 'Research and development expenses' 6456734000 'FY2024' "$AR24" 'PDF p.215 (report p.213)'
fact sga24 'Selling, general and administrative expenses' 6870644000 'FY2024' "$AR24" 'PDF p.215 (report p.213)'
fact otherinc24 'Other income, net' 589227000 'FY2024' "$AR24" 'PDF p.215 (report p.213)'
fact da24_ppe 'Depreciation of property, plant and equipment' 1571754000 'FY2024' "$AR24" 'PDF p.219 (report p.217)'
fact da24_int 'Amortization of intangible assets' 537669000 'FY2024' "$AR24" 'PDF p.219 (report p.217)'
fact da24_rou 'Amortization of right-of-use assets' 413349000 'FY2024' "$AR24" 'PDF p.219 (report p.217)'
fact da24_land 'Amortization of land use rights' 49868000 'FY2024' "$AR24" 'PDF p.219 (report p.217)'
fact ocf24 'Net cash used in operating activities' -2012343000 'FY2024' "$AR24" 'PDF p.219 (report p.217)'
fact int24 'Cash paid for interest, net of amounts capitalized' 465031000 'FY2024' "$AR24" 'PDF p.221 (report p.219)'
fact ppe24 'Purchase of property, plant and equipment' 2226111000 'FY2024' "$AR24" 'PDF p.220 (report p.218)'
fact ia24 'Purchase of intangible assets' 196901000 'FY2024' "$AR24" 'PDF p.220 (report p.218)'
fact land24 'Purchase of land use rights' 4925000 'FY2024' "$AR24" 'PDF p.220 (report p.218)'
fact disp24 'Disposal of property, plant and equipment' 169539000 'FY2024' "$AR24" 'PDF p.220 (report p.218)'

fact rev25 'Total revenues' 76719742000 'FY2025' "$AR25" 'PDF p.232 (report p.230)'
fact cost25 'Total cost of sales' 62246823000 'FY2025' "$AR25" 'PDF p.232 (report p.230)'
fact rd25 'Research and development expenses' 9489979000 'FY2025' "$AR25" 'PDF p.232 (report p.230)'
fact sga25 'Selling, general and administrative expenses' 9398456000 'FY2025' "$AR25" 'PDF p.232 (report p.230)'
fact otherinc25 'Other income, net' 1761419000 'FY2025' "$AR25" 'PDF p.232 (report p.230)'
fact da25_ppe 'Depreciation of property, plant and equipment' 1804658000 'FY2025' "$AR25" 'PDF p.236 (report p.234)'
fact da25_int 'Amortization of intangible assets' 567390000 'FY2025' "$AR25" 'PDF p.236 (report p.234)'
fact da25_rou 'Amortization of right-of-use assets' 540068000 'FY2025' "$AR25" 'PDF p.236 (report p.234)'
fact da25_land 'Amortization of land use rights' 75819000 'FY2025' "$AR25" 'PDF p.236 (report p.234)'
fact ocf25 'Net cash provided by operating activities' 8258529000 'FY2025' "$AR25" 'PDF p.236 (report p.234)'
fact int25 'Cash paid for interest, net of amounts capitalized' 503740000 'FY2025' "$AR25" 'PDF p.237 (report p.235)'
fact ppe25 'Purchase of property, plant and equipment' 3155865000 'FY2025' "$AR25" 'PDF p.237 (report p.235)'
fact ia25 'Purchase of intangible assets' 191192000 'FY2025' "$AR25" 'PDF p.237 (report p.235)'
fact disp25 'Disposal of property, plant and equipment' 52431000 'FY2025' "$AR25" 'PDF p.237 (report p.235)'

# Historical model fields. Cash tax is nil because reconstructed EBIT is negative; working capital is the cash-flow reconciliation residual.
for y in 23 24 25; do
  yr=$((2000+y))
  field historical "$yr" revenue "rev$y" reported '合并利润表收入。' high
  field historical "$yr" cost_of_revenue "cost$y" reported '合并利润表营业成本，转写为正数。' high
  field historical "$yr" period_operating_expenses "rd$y + sga$y - otherinc$y" formula '研发及销售管理费用扣除持续经营相关政府补助；排除或有对价衍生负债公允价值变化。' medium
  estfield historical "$yr" cash_tax 0 '重构EBIT为亏损，正常经营现金税取零；实际小额所得税包含独立主体、递延和非经营因素。' medium '若税务附注明确亏损年度仍有可归属经营EBIT的经常现金税，则需上调。'
  field historical "$yr" depreciation_amortization "da${y}_ppe + da${y}_int + da${y}_rou + da${y}_land" formula '合并现金流量表四类经营折旧摊销之和。' high
  if [[ "$y" == 23 ]]; then cap='ppe23 + ia23 + land23 - disp23'; wc='-10074309000'; fi
  if [[ "$y" == 24 ]]; then cap='ppe24 + ia24 + land24 - disp24'; wc='-2772431000'; fi
  if [[ "$y" == 25 ]]; then cap='ppe25 + ia25 - disp25'; wc='-8428431000'; fi
  field historical "$yr" core_business_capex "$cap" formula '购建长期经营资产现金支出扣除处置回款；公开资料未证明存在可可靠单列的非汽车新业务资本开支。' medium
  estfield historical "$yr" exploratory_business_capex 0 '机器人、飞行汽车及新技术投入主要表现为研发费用或金融投资，年报没有证据把长期资产现金支出可靠归入独立开拓性业务，基准取零。' low '若资产附注披露机器人、飞行汽车等非现有汽车业务的专属资本化投入，则应重分类。'
  estfield historical "$yr" operating_working_capital_increase "$wc" '按NOPAT＋折旧摊销－经营现金流－现金利息倒算，使利润路径与现金流路径闭合；含股份支付、减值及其他经营非现金项目的净影响，故仅代表综合现金占用。' low '若可逐项重构所有经营非现金调整和营运资金，则以逐项结果替代该闭合残差。'
  field historical "$yr" operating_cash_flow "ocf$y" reported '合并现金流量表经营活动现金流。' high
  field historical "$yr" after_tax_interest_in_operating_cash_flow "int$y" reported '亏损年度无可用税盾，使用已付利息净额加回经营现金流。' medium
done

# Capital stock values are classified estimates built from disclosed balance-sheet components.
estfield capital 2022 operating_working_capital -8112602000 '经营应收、分期应收、存货、关联方应收及预付款，扣供应商应付款、关联方应付、递延收入、应计负债和应交所得税。来源：2023年报PDF p.227–228。' medium '若票据应付款被证实主要为融资而非供应商贸易款，应从经营负债移出。'
estfield capital 2022 operating_long_term_assets_net 13196604000 '固定资产、使用权资产、无形资产、土地、长期分期应收及其他经营长期资产，扣经营租赁负债、递延收入和其他长期经营负债。来源：2023年报PDF p.227–228。' medium '若其他非流动资产或负债的经营归属发生明确披露，应重分类。'
estfield capital 2022 required_cash 8000000000 '约覆盖一至两个月现金经营支出及供应链结算波动。' low '若月度现金支出、备用信贷和季节性资料证明更低或更高最低现金需求，则调整。'
estfield capital 2022 unsupported_intangible_assets 0 '账上无形资产主要为软件、技术和土地相关权利，未发现无法联系经营能力的重大商誉单列。' medium '若减值测试证明收购溢价不能支撑经营收益，则应剔除。'

estfield capital 2023 operating_working_capital -17831776000 '按2023年报PDF p.227–228披露的经营流动资产减经营流动负债分类计算；供应商票据列作经营负债。' medium '若票据应付款实质为融资，应移出经营营运资金。'
estfield capital 2023 operating_long_term_assets_net 18486155000 '按2023年报PDF p.227–228披露的长期经营资产扣经营租赁、递延收入、递延税及其他经营长期负债。' medium '若DiDi收购无形资产不能形成经营收益，应部分剔除。'
estfield capital 2023 required_cash 9000000000 '随业务规模上升，估计约一至两个月现金经营支出。' low '若披露月度资金需求或可即时动用信贷，应调整。'
estfield capital 2023 unsupported_intangible_assets 0 'DiDi车辆平台技术已用于MONA车型，基准视为可解释经营技术资产，不机械剔除。' low '若MONA/相关技术无法产生可持续收益或发生减值，应剔除相应账面资产。'

estfield capital 2024 operating_working_capital -19280378000 '按2024年报PDF p.212–213披露的经营流动资产减经营流动负债分类计算。' medium '若供应商票据或分期应收的经济实质被重新分类，应调整。'
estfield capital 2024 operating_long_term_assets_net 19749343000 '按2024年报PDF p.212–213披露的长期经营资产扣经营租赁、递延收入、递延税及其他经营长期负债。' medium '若长期分期应收属于独立金融资产而非售车经营，应移出。'
estfield capital 2024 required_cash 10000000000 '估计覆盖约一至两个月现金经营支出及车型切换波动。' low '若流动性压力测试或已承诺资本开支显示不同最低现金需求，则调整。'
estfield capital 2024 unsupported_intangible_assets 0 '收购技术已进入车型商业化，基准不剔除；未发现独立列示重大商誉。' low '若相关技术收益不达预期或减值，应剔除。'

estfield capital 2025 operating_working_capital -29881377000 '按2025年报PDF p.229–230披露计算；供应商应付及银行保证的供应商票据均归入经营负债。' medium '若银行保证票据实质构成公司融资而非贸易信用，应移出经营营运资金并加入融资负债。'
estfield capital 2025 operating_long_term_assets_net 23856365000 '按2025年报PDF p.229–230披露的固定资产、使用权、无形、土地、长期分期应收等，扣经营租赁、递延收入、递延税和其他经营长期负债。' medium '若长期分期应收或其他项目被证实可独立处置，应移至非经营资产。'
estfield capital 2025 required_cash 12000000000 '约覆盖一至两个月现金经营成本、工资和供应链结算；规模扩大及票据结算提高缓冲需求。' low '若公司披露最低流动性政策、月度支出或可无条件动用信贷，应替代本估计。'
estfield capital 2025 unsupported_intangible_assets 0 'DiDi车辆技术已用于MONA且服务于现有汽车经营，暂不作为无法解释无形资产剔除。' low '若相关车型或技术不能产生持续毛利、发生减值或停止使用，则应剔除。'

# Stable benchmark, not a growth DCF.
estfield stable '' revenue 95000000000 '以2025年767.2亿元收入和42.94万辆交付为基准，取约24%规模提升后的可持续收入，不采用远期管理层目标。' low '若交付和单车收入不能支持950亿元，或需求/价格战导致收入持续低于该水平，则下调。'
estfield stable '' cost_of_revenue 76000000000 '假设综合毛利率20%，略高于2025年18.9%，要求车辆成本改善延续且高毛利技术服务可持续。' low '若车辆毛利率回落或技术服务收入/毛利不可持续，成本率应上调。'
estfield stable '' period_operating_expenses 17000000000 '接近2025年重构期间费用171.3亿元，假设收入扩张后费用绝对额大致稳定，而非比例机械下降。' low '若新车型、AI、海外或渠道投入使费用长期高于170亿元，应上调。'
estfield stable '' cash_tax 300000000 '按约15%的有效经营现金税率估计，考虑中国高新技术企业税率与亏损结转。' low '若税收优惠到期、亏损结转不可用或地域利润结构变化，则调整。'
estfield stable '' depreciation_amortization 3100000000 '参考2025年29.9亿元折旧摊销并对现有资产规模略作正常化。' medium '若武汉基地及新增租赁资产使折旧显著上升，则上调。'
estfield stable '' core_business_capex 3200000000 '接近2025年净现金资本开支32.95亿元，作为维持现有制造、门店、充电与技术基础的常态投入。' medium '若产能建设结束后维持投入明显下降，或海外扩张令资本开支持续上升，则调整。'
estfield stable '' exploratory_business_capex 0 '固定估值标尺不给机器人、飞行汽车等证据不足选项额外价值，其资本开支也不纳入稳定经营收益。' low '若新业务形成独立、可核验的资本化现金投入和经营回报，应另行建模。'
estfield stable '' operating_working_capital_increase 0 '成熟稳定状态不外推2025年供应商票据带来的巨额现金释放，也不假设永久新增占用。' low '若稳定增长必然需要库存或分期应收持续增加，则应采用正值。'

# Latest-year business tree.
python3 "$TOOL" add-business --model "$MODEL" --business-id vehicle --name '智能电动车及新能源车销售' --importance '2025年占收入89.1%，决定制造规模、供应链信用和品牌获客。' --confidence medium --falsifier '若公司披露按业务归属的完整费用与现金流，应替代本研究分配。'
python3 "$TOOL" add-business --model "$MODEL" --business-id services --name '技术研发服务及汽车生态服务' --importance '含平台技术研发、软件许可、配件售后、充电、碳积分和金融相关收入，毛利率显著高于整车。' --confidence medium --falsifier '若技术服务合同收入和碳积分被单独披露，需重估可持续利润。'

bizfield() { python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$1" --field "$2" --expression "$3" --basis-type "$4" --reason "$5" --confidence "$6" "${@:7}"; }
bizest() { python3 "$TOOL" set-business-field --model "$MODEL" --business-id "$1" --field "$2" --value "$3" --basis-type estimate --reason "$4" --confidence "$5" --falsifier "$6"; }
fact vehrev25 'Vehicle sales revenue' 68378920000 'FY2025' "$AR25" 'PDF p.232 (report p.230), Note 22 PDF p.308'
fact srvrev25 'Services and others revenue' 8340822000 'FY2025' "$AR25" 'PDF p.232 (report p.230), Note 22 PDF p.308–309'
fact vehcost25 'Vehicle sales cost' 59598391000 'FY2025' "$AR25" 'PDF p.232 (report p.230)'
fact srvcost25 'Services and others cost' 2648432000 'FY2025' "$AR25" 'PDF p.232 (report p.230)'
bizfield vehicle revenue vehrev25 reported '合并报表直接披露。' high
bizfield vehicle cost_of_revenue vehcost25 reported '合并报表直接披露。' high
bizest vehicle period_operating_expenses 15071776000 '将2025年重构期间费用的88%归入整车：大部分研发、销售门店、加盟佣金与品牌营销服务整车获客和车型开发。' low '若公司披露技术服务项目人员、研发成本和销售费用，则按直接归属重分配。'
bizest vehicle cash_tax 0 '业务EBIT为亏损，经营现金税取零。' medium '若单体税务资料显示整车业务仍缴纳经常现金税，则调整。'
bizest vehicle operating_cash_flow_contribution 6000000000 '基准将主要供应商应付票据释放归入整车，同时扣除库存和分期应收增长。' low '若分业务现金流或供应商票据用途披露，则替换。'
bizfield services revenue srvrev25 reported '合并报表直接披露。' high
bizfield services cost_of_revenue srvcost25 reported '合并报表直接披露。' high
bizest services period_operating_expenses 2055240000 '将2025年重构期间费用的12%归入技术与生态服务，考虑技术研发服务需要研发人员但销售渠道负担较轻。' low '若合同成本或人员归属披露，按直接成本重分配。'
bizest services cash_tax 0 '公司仍有累计亏损且合并经营EBIT为负，基准不对该业务单列现金税。' low '若技术服务利润在独立纳税主体产生不可抵扣现金税，则调整。'
bizest services operating_cash_flow_contribution 2258529000 '作为公司经营现金流扣除整车基准贡献后的闭合数，包含技术服务回款及递延收入变化。' low '若技术服务合同资产、回款与分业务现金流披露，则替换。'

# Equity bridge at 2025-12-31.
fact cash25 'Cash and cash equivalents' 17329612000 '2025-12-31' "$AR25" 'PDF p.229 (report p.227)'
fact std25 'Short-term deposits' 11388834000 '2025-12-31' "$AR25" 'PDF p.229 (report p.227)'
fact ltdcur25 'Long-term deposits, current portion' 3020317000 '2025-12-31' "$AR25" 'PDF p.229 (report p.227)'
fact ltd25 'Long-term deposits' 4263542000 '2025-12-31' "$AR25" 'PDF p.229 (report p.227)'
fact sti25 'Short-term investments' 3217293000 '2025-12-31' "$AR25" 'PDF p.229 (report p.227)'
fact lti25 'Long-term investments' 2523037000 '2025-12-31' "$AR25" 'PDF p.229 (report p.227)'
fact stb25 'Short-term borrowings' 4282000000 '2025-12-31' "$AR25" 'PDF p.230 (report p.228)'
fact ltbcur25 'Long-term borrowings, current portion' 1837950000 '2025-12-31' "$AR25" 'PDF p.230 (report p.228)'
fact ltb25 'Long-term borrowings' 6588865000 '2025-12-31' "$AR25" 'PDF p.230 (report p.228)'
fact flcur25 'Finance lease liabilities, current portion' 55581000 '2025-12-31' "$AR25" 'PDF p.230 (report p.228)'
fact fl25 'Finance lease liabilities' 740576000 '2025-12-31' "$AR25" 'PDF p.230 (report p.228)'
python3 "$TOOL" add-fact --model "$MODEL" --fact-id shares25 --reported-item 'Ordinary shares outstanding' --amount 1908699765 --period '2025-12-31' --currency '股' --scope consolidated --source "$AR25" --locator 'PDF p.231 (report p.229)'
python3 "$TOOL" add-fact --model "$MODEL" --fact-id rsu19_25 --reported-item 'Class A shares subject to outstanding RSUs under 2019 plan' --amount 20451181 --period '2025-12-31' --currency '股' --scope consolidated --source "$AR25" --locator 'PDF p.194 (report p.192)'
python3 "$TOOL" add-fact --model "$MODEL" --fact-id rsu25_25 --reported-item 'Class A shares subject to outstanding RSUs under 2025 scheme' --amount 34072186 --period '2025-12-31' --currency '股' --scope consolidated --source "$AR25" --locator 'PDF p.197 (report p.195)'
python3 "$TOOL" add-fact --model "$MODEL" --fact-id contingent25 --reported-item 'Maximum contingently issuable shares' --amount 14276521 --period '2025-12-31' --currency '股' --scope consolidated --source "$AR25" --locator 'Note 28 PDF p.324 (report p.322)'

python3 "$TOOL" set-field --model "$MODEL" --view equity --field excess_cash --expression 'cash25 + std25 + ltdcur25 + ltd25 - 12000000000' --basis-type formula --reason '仅计未受限现金及存款，扣经营必需现金；受限资金不视作股东可立即取得。' --confidence medium
python3 "$TOOL" set-field --model "$MODEL" --view equity --field non_operating_assets --expression 'sti25 + lti25' --basis-type formula --reason '短期及长期金融投资不参与核心汽车FCFF，按账面金额计入。' --confidence medium
python3 "$TOOL" set-field --model "$MODEL" --view equity --field financing_debt --expression 'stb25 + ltbcur25 + ltb25 + flcur25 + fl25' --basis-type formula --reason '银行及资产证券化借款加融资租赁负债；经营租赁已在长期经营资产净额中扣除。' --confidence high
python3 "$TOOL" set-field --model "$MODEL" --view equity --field minority_interest_value --value 0 --basis-type estimate --reason '合并权益未列少数股东权益，主要经营主体为全资或合约控制并表。' --confidence medium --falsifier '若披露并表子公司存在重大非控股权益，应按经济价值扣除。'
python3 "$TOOL" set-field --model "$MODEL" --view equity --field other_priority_claims --value 281009000 --basis-type estimate --reason '按2025年末DiDi收购或有对价衍生负债账面公允价值列作普通股前索偿；最大股份摊薄另计入完全摊薄股数。' --confidence medium --falsifier '若或有里程碑失效或以不同股份数量结算，应更新。'
python3 "$TOOL" set-field --model "$MODEL" --view equity --field diluted_shares --expression 'shares25 + rsu19_25 + rsu25_25 + contingent25' --basis-type formula --reason '期末已发行在外普通股加全部未归属RSU及最高或有发行股份。' --confidence medium
python3 "$TOOL" set-field --model "$MODEL" --view equity --field financial_to_trading_fx --value 1.1127 --basis-type estimate --reason '2025-12-31人民币兑港元历史收盘汇率约1.1127。' --confidence medium --falsifier '若采用不同权威估值日汇率，则替换。'

python3 "$TOOL" set-valuation --model "$MODEL" --mode benchmark --reason '公司仍处于车型、AI、海外与服务扩张期，缺少可核验的逐年FCFF、到达稳定期时间和全部成长投入，故使用稳定经营收益八倍固定标尺。' --stable-multiple 8 --safety-margin-ratio 0.6
python3 "$TOOL" add-adjustment --model "$MODEL" --name '2025年供应商票据现金释放' --before '经营现金流82.6亿元' --after '不外推至稳定期；稳定营运资金增加取0' --reason '应付账款及票据增加140.8亿元，同时存货、分期应收和预付款增加；现金转正主要来自贸易信用扩张。若票据水平随规模稳定且无回落压力，需重新评估。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name '受限资金可达性' --before '受限现金及存款约84.4亿元' --after '普通股价值桥中不加回' --reason '该等资金用于银行借款、保函、银行票据、诉讼等，不能视为可即时分配现金；若解除质押且无替代担保需求，可加回。'
python3 "$TOOL" add-adjustment --model "$MODEL" --name 'DiDi或有对价' --before '衍生负债2.81亿元；潜在股份0–0.143亿股' --after '扣2.81亿元并采用最大股份摊薄' --reason '保守处理普通股前索偿和股数摊薄；若里程碑失效，负债及相应摊薄均应撤销。'

python3 "$TOOL" set-review --model "$MODEL" --item capital_return_interpretability --passed --reason '各年NOPAT均为负且投入资本受经营必需现金及供应商票据分类影响，报告只把ROIC解释为资本占用结构，不作为竞争优势证据。'
python3 "$TOOL" set-review --model "$MODEL" --item source_traceability --passed --reason '重大财务事实均记录年度报告名称、日期及PDF页码；研究估计保留依据、置信度和推翻条件。'
python3 "$TOOL" set-review --model "$MODEL" --item economic_classification --passed --reason '经营租赁、供应商票据、受限资金、金融投资和融资负债采用一致分类，未在FCFF与价值桥重复计算。'
python3 "$TOOL" set-review --model "$MODEL" --item stable_state --passed --reason '稳定状态结合三年收入、毛利、费用、资本开支及最新业务结构形成，并明确不外推2025年营运资金释放。'
python3 "$TOOL" set-review --model "$MODEL" --item report_consistency --passed --reason '报告中心数字将以结构化模型编译结果为准，最终由脚本注入转写表。'

python3 "$TOOL" compile --model "$MODEL"
python3 "$TOOL" render --model "$MODEL" --output outputs/transcribed-tables.md

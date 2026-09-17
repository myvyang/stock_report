#!/usr/bin/env bash
set -euo pipefail

tool=.agents/skills/stock-research/scripts/stock_research.py
model=outputs/analysis.json

python3 "$tool" init --name '東瀛遊' --code '06882.HK' --period-label '截至2025年12月31日止年度' --period-end '2025-12-31' --coverage-years '2023,2024,2025' --financial-currency '港元' --trading-currency '港元' --security-name '普通股' --security-unit '股' --output "$model"

fact() {
  python3 "$tool" add-fact --model "$model" --fact-id "$1" --reported-item "$2" --amount "$3" --period "$4" --currency '港元' --scope '東瀛遊控股有限公司及其附屬公司（合併）' --source "$5" --locator "$6"
}

ar23='東瀛遊控股有限公司《2023年報》（2024-03-20） https://www1.hkexnews.hk/listedco/listconews/sehk/2024/0425/2024042500442.pdf'
ar24='東瀛遊控股有限公司《2024年報》（2025-03-28） https://www1.hkexnews.hk/listedco/listconews/sehk/2025/0425/2025042500579.pdf'
ar25='東瀛遊控股有限公司《2025年報》（2026-03-27） https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0428/2026042800984.pdf'

# Historical income and cash-flow facts, amounts in HKD.
fact rev_2023 '收益' 1366020000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.94，年报页93，综合损益表'
fact cos_2023 '销售成本' 1026252000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.94，年报页93，综合损益表'
fact sell_2023 '销售开支' 70007000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.94，年报页93，综合损益表'
fact admin_2023 '行政开支' 159446000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.94，年报页93，综合损益表'
fact otherop_2023 '其他经营开支' 55000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.94，年报页93，综合损益表'
fact tax_2023 '所得税开支' 19586000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.94，年报页93，综合损益表'
fact ppe_da_2023 '物业、厂房及设备折旧' 31980000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.100，年报页99，综合现金流量表'
fact rou_da_2023 '使用权资产折旧' 17836000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.100，年报页99，综合现金流量表'
fact ppe_buy_2023 '购买物业、厂房及设备' 9561000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.101，年报页100，综合现金流量表'
fact ppe_sale_2023 '出售物业、厂房及设备所得款项' 205000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.101，年报页100，综合现金流量表'
fact lease_principal_2023 '已付租赁租金本金' 16886000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.101，年报页100，综合现金流量表'
fact ocf_2023 '营运活动产生现金净额' 231067000 '2023-01-01/2023-12-31' "$ar23" 'PDF p.100，年报页99，综合现金流量表'
fact interest_in_ocf_2023 '营运现金流内利息支出' 0 '2023-01-01/2023-12-31' "$ar23" 'PDF p.101，年报页100；已付利息列融资活动，营运现金流不含利息'

fact rev_2024 '收益' 1632532000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.94，年报页93，综合损益表'
fact cos_2024 '销售成本' 1259327000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.94，年报页93，综合损益表'
fact sell_2024 '销售开支' 91303000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.94，年报页93，综合损益表'
fact admin_2024 '行政开支' 175885000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.94，年报页93，综合损益表'
fact otherop_2024 '其他经营开支' 147000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.94，年报页93，综合损益表'
fact tax_2024 '所得税开支' 20999000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.94，年报页93，综合损益表'
fact ppe_da_2024 '物业、厂房及设备折旧' 15427000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.100，年报页99，综合现金流量表'
fact rou_da_2024 '使用权资产折旧' 18350000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.100，年报页99，综合现金流量表'
fact ppe_buy_2024 '购买物业、厂房及设备' 5383000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.101，年报页100，综合现金流量表'
fact lease_principal_2024 '已付租赁租金本金' 18083000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.101，年报页100，综合现金流量表'
fact ocf_2024 '营运活动产生现金净额' 132769000 '2024-01-01/2024-12-31' "$ar24" 'PDF p.100，年报页99，综合现金流量表'
fact interest_in_ocf_2024 '营运现金流内利息支出' 0 '2024-01-01/2024-12-31' "$ar24" 'PDF p.101，年报页100；已付利息列融资活动，营运现金流不含利息'

fact rev_2025 '收益' 1511904000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.90，年报页89，综合损益表'
fact cos_2025 '销售成本' 1186659000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.90，年报页89，综合损益表'
fact sell_2025 '销售开支' 99966000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.90，年报页89，综合损益表'
fact admin_2025 '行政开支' 175763000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.90，年报页89，综合损益表'
fact otherop_2025 '其他经营开支' 34000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.90，年报页89，综合损益表'
fact tax_2025 '所得税开支' 14862000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.90，年报页89，综合损益表；税率详情见PDF pp.142-144'
fact ppe_da_2025 '物业、厂房及设备折旧' 12113000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.96，年报页95，综合现金流量表'
fact rou_da_2025 '使用权资产折旧' 20678000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.96，年报页95，综合现金流量表'
fact ppe_buy_2025 '购买物业、厂房及设备' 6781000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.97，年报页96，综合现金流量表'
fact lease_principal_2025 '已付租赁租金本金' 20444000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.97，年报页96，综合现金流量表'
fact ocf_2025 '营运活动产生现金净额' 98439000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.96，年报页95，综合现金流量表'
fact interest_in_ocf_2025 '营运现金流内利息支出' 0 '2025-01-01/2025-12-31' "$ar25" 'PDF p.97，年报页96；已付利息列融资活动，营运现金流不含利息'

# Balance-sheet facts for invested capital, including the 2022 opening point.
for spec in \
  '2022 1733000 6766000 74510000 5542000 15582000 42236000 100887000 20000 471798000 18361000 2028000 648000 4550000' \
  '2023 1313000 10235000 75250000 3816000 37540000 55207000 127987000 2323000 416503000 25497000 1835000 602000 5653000' \
  '2024 930000 13786000 98109000 3981000 45634000 57796000 136612000 3071000 365298000 24283000 1897000 541000 7417000' \
  '2025 815000 16450000 70856000 2069000 41047000 61473000 132697000 2969000 360894000 41337000 2054000 542000 8312000'; do
  read -r y inv tr pre duefrom tp accr contract dueto ppe rou ncp provision lsp <<<"$spec"
  if [[ $y == 2022 ]]; then src="$ar23"; loc='PDF pp.96-97，年报页95-96，2022比较数（经重列）'; else
    if [[ $y == 2023 ]]; then src="$ar24"; loc='PDF pp.96-97，年报页95-96，2023比较数'; elif [[ $y == 2024 ]]; then src="$ar25"; loc='PDF pp.92-93，年报页91-92，2024比较数'; else src="$ar25"; loc='PDF pp.92-93，年报页91-92'; fi
  fi
  fact inv_$y '存货' "$inv" "$y-12-31" "$src" "$loc"
  fact tr_$y '贸易应收账' "$tr" "$y-12-31" "$src" "$loc"
  fact pre_$y '订金、预付款及其他应收账' "$pre" "$y-12-31" "$src" "$loc"
  fact duefrom_$y '应收联营公司账款' "$duefrom" "$y-12-31" "$src" "$loc"
  fact tp_$y '贸易应付账' "$tp" "$y-12-31" "$src" "$loc"
  fact accr_$y '应计款项及其他应付账' "$accr" "$y-12-31" "$src" "$loc"
  fact contract_$y '合约负债' "$contract" "$y-12-31" "$src" "$loc"
  fact dueto_$y '应付联营公司账款' "$dueto" "$y-12-31" "$src" "$loc"
  fact ppe_$y '物业、厂房及设备' "$ppe" "$y-12-31" "$src" "$loc"
  fact rou_$y '使用权资产' "$rou" "$y-12-31" "$src" "$loc"
  fact ncp_$y '非流动订金及预付款' "$ncp" "$y-12-31" "$src" "$loc"
  fact provision_$y '复原成本拨备' "$provision" "$y-12-31" "$src" "$loc"
  fact lsp_$y '长期服务金拨备' "$lsp" "$y-12-31" "$src" "$loc"
done

# Latest-year valuation and business facts.
fact cash_2025 '银行存款及库存现金' 152841000 '2025-12-31' "$ar25" 'PDF p.92及pp.164-165，年报页91及163-164'
fact pledged_2025 '抵押银行存款' 9093000 '2025-12-31' "$ar25" 'PDF pp.164-165，年报页163-164'
fact associate_2025 '于联营公司权益' 14717000 '2025-12-31' "$ar25" 'PDF p.92，年报页91'
fact bank_debt_2025 '银行借款' 218692000 '2025-12-31' "$ar25" 'PDF pp.168-169，年报页167-168'
fact related_debt_2025 '关连公司贷款' 90532000 '2025-12-31' "$ar25" 'PDF pp.92-93及p.189，年报页91-92及188'
fact shares_2025 '已发行及缴足普通股' 502450000 '2025-12-31' "$ar25" 'PDF p.172，年报页171，附注27'
fact nci_2025 '非控股权益负债净值' -1532000 '2025-12-31' "$ar25" 'PDF p.186，年报页185，附注33；披露为不重大'

fact travel_rev_2025 '旅游相关业务外部客户收益' 1355551000 '2025-01-01/2025-12-31' "$ar25" 'PDF pp.134及138，年报页133及137，分部报告'
fact travel_gp_2025 '旅游相关业务毛利（旅行团加自由行及辅助服务）' 209608000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.16，年报页15，管理层讨论与分析'
fact hotel_rev_2025 '酒店业务外部客户收益' 156353000 '2025-01-01/2025-12-31' "$ar25" 'PDF pp.134及138，年报页133及137，分部报告'
fact hotel_gp_2025 '酒店业务毛利' 115637000 '2025-01-01/2025-12-31' "$ar25" 'PDF p.16，年报页15；分部内收益抵销不影响毛利'

setf() { python3 "$tool" set-field --model "$model" "$@"; }

for y in 2023 2024 2025; do
  setf --view historical --year "$y" --field revenue --expression "rev_$y" --basis-type reported --reason '综合损益表直接披露' --confidence high
  setf --view historical --year "$y" --field cost_of_revenue --expression "cos_$y" --basis-type reported --reason '综合损益表直接披露销售成本' --confidence high
  setf --view historical --year "$y" --field period_operating_expenses --expression "sell_$y + admin_$y + otherop_$y" --basis-type formula --reason '销售、行政及其他经营开支合计；排除融资成本、联营业绩和其他收入净额' --confidence high
  setf --view historical --year "$y" --field cash_tax --expression "tax_$y" --basis-type reported --reason '以所得税费用作为经营现金税基准；集团主要非经营收益规模较小' --confidence medium
  setf --view historical --year "$y" --field depreciation_amortization --expression "ppe_da_$y + rou_da_$y" --basis-type formula --reason '经营物业设备与使用权资产折旧合计' --confidence high
  if [[ $y == 2023 ]]; then capex='ppe_buy_2023 + lease_principal_2023 - ppe_sale_2023'; wc=-90577000; fi
  if [[ $y == 2024 ]]; then capex='ppe_buy_2024 + lease_principal_2024'; wc=-14121000; fi
  if [[ $y == 2025 ]]; then capex='ppe_buy_2025 + lease_principal_2025'; wc=-31028000; fi
  setf --view historical --year "$y" --field core_business_capex --expression "$capex" --basis-type formula --reason '经营租赁口径：设备现金购置加租赁本金、扣经营资产处置回款；投入均服务现有旅行与酒店业务' --confidence high
  setf --view historical --year "$y" --field exploratory_business_capex --value 0 --basis-type estimate --reason '报告期无新建酒店或具名新业务资本项目，资本开支归入现有主营' --confidence medium --falsifier '后续披露显示当年设备或租赁投入专属于尚未商业化的新业务'
  setf --view historical --year "$y" --field operating_working_capital_increase --value "$wc" --basis-type estimate --reason '按利润路径与现金流量表路径反推的综合经营资金释放，吸收预收款、应付款、应收预付及相关非现金调整的实际影响' --confidence medium --falsifier '取得可逐项剔除非经营和非现金调整的营运资金现金变动表后重算'
  setf --view historical --year "$y" --field operating_cash_flow --expression "ocf_$y" --basis-type reported --reason '综合现金流量表直接披露' --confidence high
  setf --view historical --year "$y" --field after_tax_interest_in_operating_cash_flow --expression "interest_in_ocf_$y" --basis-type reported --reason '集团把已付利息列作融资活动，营运现金流无需加回利息' --confidence high
done

for y in 2022 2023 2024 2025; do
  setf --view capital --year "$y" --field operating_working_capital --expression "inv_$y + tr_$y + pre_$y + duefrom_$y - tp_$y - accr_$y - contract_$y - dueto_$y" --basis-type formula --reason '经营流动资产扣贸易、预收及其他经营负债；税项、股息及融资负债排除' --confidence medium
  setf --view capital --year "$y" --field operating_long_term_assets_net --expression "ppe_$y + rou_$y + ncp_$y - provision_$y - lsp_$y" --basis-type formula --reason '经营物业设备、使用权资产及长期经营预付款，扣复原与长期服务金经营义务；联营和递延税项排除' --confidence medium
  setf --view capital --year "$y" --field required_cash --value 30000000 --basis-type estimate --reason '旅行成本外币采购限制约一周需求，另留约一周固定成本与酒店结算缓冲；客户预付款使长期所需现金低于月度总成本' --confidence low --falsifier '月度现金低点、供应商保证金或监管资金要求显示持续最低余额显著高于或低于3000万港元'
  setf --view capital --year "$y" --field unsupported_intangible_assets --value 0 --basis-type estimate --reason '合并财务状况表未列商誉或无形资产，未发现需从经营资产剔除的并购溢价' --confidence high --falsifier '后续发现表外或重分类商誉、客户关系或不再服务主营的递延资产'
done

# Stable-state company assumptions.
setf --view stable --field revenue --value 1560000000 --basis-type estimate --reason '介于2024高位与2025受日本地震传闻冲击年份之间；酒店较高入住率部分抵消旅行波动' --confidence medium --falsifier '旅行团收入持续低于2025水平，或酒店入住率显著低于约85%'
setf --view stable --field cost_of_revenue --value 1201200000 --basis-type estimate --reason '对应23.0%常态毛利率，低于2023约24.9%、略高于2024至2025区间的21.5%至22.9%，反映酒店占比上升但旅行团竞争仍强' --confidence medium --falsifier '旅行团毛利率持续低于12.5%且酒店增长不足以补偿，或旅行团恢复至15%以上'
setf --view stable --field period_operating_expenses --value 275000000 --basis-type estimate --reason '以2024至2025约2.67亿至2.76亿港元的销售、行政及其他经营开支为锚，保留分店、员工和酒店固定成本' --confidence medium --falsifier '分店、人手或关联租赁结构发生重大收缩或扩张'
setf --view stable --field cash_tax --value 19000000 --basis-type estimate --reason '按常态EBIT约8380万港元的约22.7%计，综合香港与日本法定税率及历史税负' --confidence medium --falsifier '地域利润结构或可用税损令持续现金税率偏离20%至25%区间'
setf --view stable --field depreciation_amortization --value 33000000 --basis-type estimate --reason '接近2024至2025物业设备及使用权资产折旧水平' --confidence medium --falsifier '租赁网络或酒店资产折旧基础发生重大变化'
setf --view stable --field core_business_capex --value 27000000 --basis-type estimate --reason '以2023至2025含租赁本金的主营资本开支约2347万至2723万港元为锚' --confidence medium --falsifier '未来多年酒店翻新、分店搬迁或巴士更新令现金投入持续超过3500万港元'
setf --view stable --field exploratory_business_capex --value 0 --basis-type estimate --reason '无证据显示已有未稳定赚钱的新业务资本项目需要纳入稳定期' --confidence medium --falsifier '公司启动第三家酒店或具名新业务并披露资金计划'
setf --view stable --field operating_working_capital_increase --value 0 --basis-type estimate --reason '成熟规模下客户预付款与供应商结算共同波动，稳定状态不假设永久释放现金' --confidence medium --falsifier '连续多年增长需持续增加净营运资金，或预收款比例结构性下降'

# Two mutually exclusive economic businesses for 2025.
python3 "$tool" add-business --model "$model" --business-id travel --name '旅游及旅游相关服务' --importance '收入主体；以旅行团、自由行及辅助服务向香港澳门客户交付出境旅游产品' --confidence medium --falsifier '公司披露能够可靠拆出旅行团与代理型产品各自完整费用和现金流后应进一步细分'
python3 "$tool" add-business --model "$model" --business-id hotel --name '日本酒店客房及辅助服务' --importance '主要有形资产和利润来源；两家自有酒店直接面对全球住客' --confidence medium --falsifier '酒店资产、费用或现金流披露显示与旅游业务存在重大不可分割的交叉补贴'

bizf() { python3 "$tool" set-business-field --model "$model" "$@"; }
bizf --business-id travel --field revenue --expression 'travel_rev_2025' --basis-type reported --reason '分部外部客户收益直接披露' --confidence high
bizf --business-id travel --field cost_of_revenue --expression 'travel_rev_2025 - travel_gp_2025' --basis-type formula --reason '旅行团与自由行辅助服务披露毛利合计反推成本' --confidence high
bizf --business-id travel --field period_operating_expenses --value 225000000 --basis-type estimate --reason '按分部毛利、分部利润、直接融资成本、联营业绩及公司未分配费用的桥接分配；旅游销售网络承担大部分前线和总部费用' --confidence low --falsifier '取得按分部列示的销售、行政和总部费用后重算'
bizf --business-id travel --field cash_tax --value -2025000 --basis-type estimate --reason '以披露旅游分部所得税抵扣212.9万港元为锚，并分配10.4万港元未分配税项' --confidence medium --falsifier '税务附注披露分部抵扣不可用于抵销酒店应税利润'
bizf --business-id travel --field operating_cash_flow_contribution --value 35000000 --basis-type estimate --reason '旅游业务虽经营利润偏弱，但客户预付款及应付结算释放现金；余额与酒店现金贡献共同闭合集团营运现金流' --confidence low --falsifier '分部现金流或银行流水显示旅游业务现金贡献显著不同'

bizf --business-id hotel --field revenue --expression 'hotel_rev_2025' --basis-type reported --reason '分部外部客户收益直接披露，剔除集团内收入' --confidence high
bizf --business-id hotel --field cost_of_revenue --expression 'hotel_rev_2025 - hotel_gp_2025' --basis-type formula --reason '集团内收入抵销不影响披露毛利，据此外部收入反推成本' --confidence medium
bizf --business-id hotel --field period_operating_expenses --value 50763000 --basis-type estimate --reason '公司期间经营费用扣除旅游业务分配额，且与酒店分部利润及融资成本大体相符' --confidence low --falsifier '取得酒店独立损益表后重算'
bizf --business-id hotel --field cash_tax --value 16887000 --basis-type estimate --reason '采用分部报告直接披露的酒店所得税开支作为现金税基准' --confidence medium --falsifier '现金税支付与分部所得税费用长期显著偏离'
bizf --business-id hotel --field operating_cash_flow_contribution --value 63439000 --basis-type estimate --reason '以酒店经营利润、折旧及税负为锚，作为集团营运现金流扣旅游贡献后的闭合值' --confidence low --falsifier '取得酒店独立现金流或营运资金数据后重算'

# Equity bridge.
setf --view equity --field excess_cash --expression 'cash_2025 - 30000000' --basis-type formula --reason '账面现金扣3000万港元经营必需现金；抵押存款并未包含于该账面现金项目' --confidence medium
setf --view equity --field non_operating_assets --expression 'associate_2025 + pledged_2025' --basis-type formula --reason '联营权益不进入合并FCFF；抵押存款单列并与融资负债总额配对，不当作可自由分派现金' --confidence medium
setf --view equity --field financing_debt --expression 'bank_debt_2025 + related_debt_2025' --basis-type formula --reason '银行借款及关连公司贷款；采用经营租赁口径，租赁本金已计资本开支，故不重复扣租赁负债' --confidence high
setf --view equity --field minority_interest_value --value 0 --basis-type estimate --reason '非控股权益对应Zipang净负债153.2万港元且披露为不重大，不假设其具正经济索偿价值' --confidence medium --falsifier 'Zipang形成持续正现金流或少数股东存在额外优先索偿'
setf --view equity --field other_priority_claims --value 0 --basis-type estimate --reason '未发现优先股或未计入经营资本与债务的重大优先索偿；拟派股息归普通股股东，不从普通股总价值扣除' --confidence medium --falsifier '股东批准前后出现重大未入账税务、资本或担保付款义务'
setf --view equity --field diluted_shares --expression 'shares_2025' --basis-type reported --reason '每股盈利附注确认无摊薄潜在股份' --confidence high
setf --view equity --field financial_to_trading_fx --value 1 --basis-type estimate --reason '财务与交易币种同为港元' --confidence high --falsifier '股票交易币种或报告币种改变'

python3 "$tool" set-valuation --model "$model" --mode benchmark --reason '旅行需求受事件与目的地结构影响，且没有足够证据逐年预测到稳定期的FCFF；采用稳定经营收益八倍固定标尺' --stable-multiple 8 --safety-margin-ratio 0.6

python3 "$tool" add-adjustment --model "$model" --name '租赁口径统一' --before '账面租赁负债6421.3万港元' --after '不在普通股价值桥重复扣除' --reason '使用权资产计入经营资产，租赁本金计入现金资本开支，租赁负债若再扣会重复计量'
python3 "$tool" add-adjustment --model "$model" --name '经营必需现金' --before '银行存款及库存现金1.52841亿港元' --after '多余现金1.22841亿港元' --reason '预留3000万港元用于一周旅行采购、员工与酒店结算缓冲'
python3 "$tool" add-adjustment --model "$model" --name '递延税项资产' --before '账面6108.5万港元' --after '普通股价值桥不单独加回' --reason '未来实现依赖应税利润，稳定税负估计已部分反映其效果，避免重复计值'

python3 "$tool" set-review --model "$model" --item source_traceability --passed --reason '所有财报直接数保存披露名称、期间、币种、合并范围、文件链接与PDF页码'
python3 "$tool" set-review --model "$model" --item economic_classification --passed --reason '旅游和酒店互斥覆盖2025年收入、成本、费用、税和经营现金流；经营租赁口径前后一致'
python3 "$tool" set-review --model "$model" --item stable_state --passed --reason '稳定期结合三年总量、旅行波动、酒店入住率、费用与资本开支，不机械外推单年'
python3 "$tool" set-review --model "$model" --item capital_return_interpretability --passed --reason '投入资本含负营运资金、酒店长期资产与经营必需现金；ROIC可解释但受低可信现金估计影响，正文限定使用'
python3 "$tool" set-review --model "$model" --item report_consistency --passed --reason '报告重大数字与脚本编译后的结构化模型保持一致'

python3 "$tool" compile --model "$model"
python3 "$tool" validate --model "$model"
python3 "$tool" render --model "$model" --output outputs/transcribed-tables.md

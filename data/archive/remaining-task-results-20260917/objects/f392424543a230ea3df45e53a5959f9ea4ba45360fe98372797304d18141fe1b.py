from pathlib import Path
exec(Path('outputs/finalize.py').read_text())
review('fixed','2025','partial','2025年报140页原值增加合计3,199,569,201.00元，但购置58,648,327.28、转固3,048,756,105.00、分类调整60,675,447.13、投资性房地产转回22,162,896.28相加少9,326,425.31元；逐项数照录，保留原件内部不一致，不倒算其他增加。')
# Correct 2024 cancellation vs minority purchase from capital-reserve note.
row('equity','repurchase','限制性股票注销：股本及溢价减少',[-34425960,-74584870],157,5,source='filing_2025',calc='2024:-9406000-25019960，依据2024年报178—179页；2025:-22345000-52239870，依据2025年报156—157页')
row('equity','minority_transactions','购入子公司少数股权的归母权益减少',[-1079024.01,-1840715858.71],174,6,calc='2024年报178—179页披露金福源9.5985%股权交易冲减资本公积1079024.01；2025年报174页银根矿业对价2725504200-取得净资产884788341.29=1840715858.71')
cmd('narrative',entity='root',id='equity_evidence',text='归母权益变化逐项取权益表小计列，不取少数股东列。其他直接变化：2024库存股净减少120795240+安全与复垦储备净增加29420474.56-权益法资本公积调整31775421.09；2025库存股净减少226952440-权益法调整93124076.68+专项储备净增加58952720.59-除增持银根矿业以外的处置子公司及股权激励等直接减少59361618.20。归母净利润、其他综合收益、股东投入、股份支付、注销股本及溢价、权益分配、少数股权交易分别记录。')
# No debt financing flows in owner module. Actual cash differs from equity movements.
row('owner_flows','share_input','限制性股票授予取得的股东现金投入',[28437600,0],100,1)
row('owner_flows','cash_repurchase','实际支付限制性股票回购款',[-34457054.25,-74646776.97],165,2)
row('owner_flows','cash_minority_purchase','从少数股东购入子公司股权实际支付现金',[-4614000,-2719564200],165,3)
row('owner_flows','minority_dividend','实际支付给少数股东的现金股利',[-351969165.20,-697666172.84],97,5)
cmd('narrative',entity='root',id='owner_cash_boundary',text='现金流量表“分配股利、利润或偿付利息支付的现金”2024年1,665,818,218.26元、2025年2,038,703,767.88元为混合金额，未当作股东现金流。2025年附注166页应付股利现金减少1,723,169,974.19元，与2024年附注188页应付股利现金减少2,336,423,113.06元的统计口径需结合集团内部分派核查；当前未据此倒算上市公司股东实际收款。已披露少数股东现金股利单独保存。')
# Fully disclosed 2024 asset movements, with opening amounts anchored in evidence.
for obj,items in {
'land':[('purchase',8280329.59),('ip_transfer',1227714),('other_out',-18731375.43),('amort',-27152345.49),('ip_amort',-275017.29),('other_amort_out',5784203.39)],
'patent':[('other_out',-80626),('amort',-9439965.59)],'water_right':[('purchase',211875000),('amort',-11552503.26)],'mine_right':[('amort',-75476539.56)],'software':[('purchase',13330971.80),('disposal',-520310),('amort',-2260266.47),('disposal_amort',520310)]}.items():
 for id,v in items:mov(obj,'2024',id,{'purchase':'购置','ip_transfer':'投资性房地产转入原值','other_out':'附注其他原值减少','amort':'本期摊销','ip_amort':'物业转入累计摊销','other_amort_out':'附注其他减少累计摊销','disposal':'处置原值','disposal_amort':'处置转销摊销'}[id],v,168)
 review(obj,'2024','explained','已查2024年报167—169页各类无形资产期初、增加、减少和摊销；首期变动以该年附注期初为基数')
for obj,value in [('cip_soda',1405985314.56),('cip_mine',194256266.34),('cip_water',49341300.47)]:
 mov(obj,'2024','add','本期工程投入（附注该二期工程期初为零）',value,165)
 review(obj,'2024','explained','2024年重要在建工程附注明确该二期项目为本年投入，期初无余额')
# Business geography: alternate disclosure axes, do not add to product totals.
for j,(id,label,rs,cs) in enumerate([('inner_mongolia','内蒙古地区（地域口径）',[9431907775.71,9303614489.87],[5479201663.69,6432970388.15]),('henan','河南地区（地域口径）',[3829354412.61,2769129727.22],[2351202425.28,1958434630.89]),('hainan','海南地区（地域口径）',[2657152.11,1922477.07],[5862291,5231253.60])],20):
 cmd('business',entity='root',id=id,label=label,order=j)
 for i,p in enumerate(['2024','2025']):
  for metric,v,c in [('revenue',rs[i],None),('direct_cost',-cs[i],None),('gross_profit',rs[i]-cs[i],'地域收入-地域成本')]:cmd('business-metric',entity='root',business=id,metric=metric,amount=v,**proof(p,182 if p=='2024' else 159,label,c))
cmd('narrative',entity='root',id='business_basis',text='产品、地域、销售渠道为不同交叉统计轴，各自均含于公司合计，不能互相相加。费用保留含折旧原口径，不再重复扣折旧。2024“其他产品”成本168766477.80来自2024年报181页；2025对应101032664.50见159页。')
# Components: preserve disclosed 100% financial information, do not divide minority balances to manufacture parent bases.
components={
'yingen':('内蒙古博源银根矿业有限责任公司','阿拉善塔木素天然碱矿、纯碱装置及水务共同构成独立资产包，外部股东占2024年40%、2025年末29.3536%。',[[2259748989.35,14528805437.36,16788554426.71,5360557151.67,3704957729.58,9065514881.25],[1329711252.19,19600659577.95,20930370830.14,6429210496.20,6026020852.05,12455231348.25]],[6184433231.07,6158785712.15],[2240549270.85,1380380688.77],[1853102282.31,1177632253.82],[.6,.706464]),
'zhongyuan':('河南中源化学股份有限公司','河南及苏尼特天然碱业务具有独立资源与生产系统，外部股东占18.29%；新型化工等子单元仍有自身少数股东，不能将整体利润作为归母基数。',[[2681667337,6265110336.87,8946777673.87,1659999096.36,339676939.26,1999676035.62],[1385586707.26,5515206730.40,6900793437.66,1769003259.74,293348715.81,2062351975.55]],[5275939679.88,4057795866.25],[594759644.43,-183555901.98],[1466542035.77,651008437.58],[.8171,.8171]),
'boda':('内蒙古博大实地化学有限公司','煤化工尿素业务与天然碱独立，外部股东占29%；与配套全资水处理单元作为共同经营包。',[[860659095.78,2678436031.78,3539095127.56,364349722.98,64321765.08,428671488.06],[783104620.80,2312760331.24,3095864952.04,545028471.22,10861427.88,555889899.10]],[1758309820.84,1773562367.38],[150075187.65,223244086.86],[532769800.43,243878790.30],[.71,.71]),
'mengda_unit':('乌审旗蒙大矿业有限责任公司','纳林河二号煤矿及选煤厂为独立煤炭业务，上市公司持有34%，无控制权；穿透份额不得再与根的权益法投资相加。',[[1282017921.37,16799635401.45,18081653322.82,3814616026.66,2980382121.86,6794998148.52],[1785063574.51,16378093341.06,18163156915.57,1854461992.68,4000666528.67,5855128521.35]],[4932723852.99,4515074625.16],[1230554661.01,1390358774.68],None,[.34,.34]),
'zhongmei_unit':('内蒙古中煤远兴能源化工有限公司','独立煤化工经营及25%外部投资权益；与根权益法账面投资不可相加。',[[259427988.94,1666761545.74,1926189534.68,536141434.48,784218357.64,1320359792.12],[318602787.38,1552797432.61,1871400219.99,842657212.82,0,842657212.82]],[1862585077.89,1920410583.49],[165639926.71,422211528.15],None,[.25,.25])}
for id,(name,basis,summary,revenue,profit,cf,ratios) in components.items():
 page=175 if id.endswith('_unit') else 173
 cmd('entity',id=id,name=name,parent_id='root',scope='100%主体合并汇总；根下穿透明细不可相加',accounting_scope='consolidated')
 cmd('presentation',entity=id,mode='component',basis=basis)
 cmd('coverage',entity=id,level='partial',basis='已读2024年报195—197页、2025年报171—175页及2025-10-28银根矿业审计和交易公告。两年资产负债分类汇总、收入与净利润如下；年报未披露本单元完整经营链与资产滚存。中源化学、博大实地独立审计检索未取得覆盖2024—2025全年的原件。银根矿业补充审计只覆盖2024及2025年1—5月，不能延长到2025年末；其2024详细附注仍需结构化录入，已保留法定原件。'+basis,source_ids='filing_2024,filing_2025,yingen_audit,yingen_transaction')
 for i,p in enumerate(['2024','2025']):
  for key,label,v in zip(['current_assets','long_assets','total_assets','current_liabilities','long_liabilities','total_liabilities'],['流动资产','非流动资产','资产合计','流动负债','非流动负债','负债合计'],summary[i]):cmd('summary-row',entity=id,id=key,label=label,amount=v,**proof(p,page,'年报非全资子公司/重要联营企业100%主体汇总',source='filing_2025'))
  cmd('control',entity=id,id='consolidated_equity',amount=summary[i][2]-summary[i][5],**proof(p,page,'主体全部净资产，尚未扣主体自己的少数股东权益','资产合计-负债合计','filing_2025'))
 cmd('business',entity=id,id='company_total',label='主体全部业务披露收入',kind='total')
 for i,p in enumerate(['2024','2025']):cmd('business-metric',entity=id,business='company_total',metric='revenue',amount=revenue[i],**proof(p,175 if id.endswith('_unit') else 174,'全部主体收入',source='filing_2025'))
 row('other_profit','consolidated_profit','主体全部净利润',profit,175 if id.endswith('_unit') else 174,1,'total',entity=id)
 if cf:row('cash_flow','operating_cash_flow','法定经营活动现金净额',cf,174,1,'total',entity=id)
 known_parent=id in ['boda','mengda_unit','zhongmei_unit']
 if known_parent:
  # Boda has only wholly owned operating water subsidiary per group composition.
  for i,p in enumerate(['2024','2025']):cmd('control',entity=id,id='parent_equity',amount=summary[i][2]-summary[i][5],**proof(p,page,'联营企业归母权益明确列示；博大实地配套子公司全资（172页）','资产合计-负债合计；无本单元自身少数股东权益','filing_2025'))
  row('other_profit','parent_profit','本单元归母净利润',profit,175 if id.endswith('_unit') else 174,2,'total',entity=id,calc='已核查本单元无自身少数股东损益，全部净利润=本单元归母净利润')
 for i,p in enumerate(['2024','2025']):
  meth='proportional' if known_parent else 'unavailable'
  cmd('ownership',entity=id,period=p,ratio=ratios[i],profit_ratio=ratios[i] if id!='yingen' or p=='2024' else 'null',method=meth,source_id='filing_2025',page=174 if id=='yingen' else (175 if id.endswith('_unit') else 172),basis=basis+('全年比例稳定；归母基数按本单元披露，不取集团数。' if known_parent else '归母基数未在两期汇总中单独披露，不除少数股东金额倒算；2025银根矿业11月底增持，分段利润未披露，不能用年末比例代替全年。'))
 cmd('narrative',entity=id,id='equity',text='本单元为非上市经营单元，年报未披露两年可比的独立股份变动，不套用上市公司股数。')
cmd('narrative',entity='yingen',id='audited_2024',text='补充审计原件物理第7、10页确认2024本单元归母净资产7,723,039,545.46元、归母净利润2,240,549,270.85元；2024全年60%比例对应权益4,633,823,727.28元、利润1,344,329,562.51元。2025存在新设非全资新能源单元，年报汇总未单列银根自身少数股东基数；未将2024无少数股东的情况直接沿用于2025。上述2024已知基数将在protocol控制项逐期录入；2025按missing记录。')
cmd('control',entity='yingen',id='parent_equity',amount=7723039545.46,**proof('2024',7,'银根矿业审计合并资产负债表归母权益',source='yingen_audit'))
cmd('control',entity='yingen',id='parent_equity',period='2025',amount='null',status='missing',basis='2025年末本单元自身少数股东权益未单列，不能用总权益代替归母权益')
cmd('operating-row',entity='yingen',module='other_profit',id='parent_profit',label='银根矿业本单元归母净利润',kind='total',amount=2240549270.85,**proof('2024',10,'银根矿业审计合并利润表归母利润',source='yingen_audit'))
cmd('operating-row',entity='yingen',module='other_profit',id='parent_profit',label='银根矿业本单元归母净利润',kind='total',period='2025',amount='null',status='missing',basis='新设非全资新能源子公司，全年单元归母损益未单列，不能用整体利润替代')
cmd('ownership',entity='yingen',period='2024',ratio=.6,profit_ratio=.6,method='proportional',source_id='yingen_audit',page=109,basis='2024全年上市公司直接持股60%；本单元2024合并归母权益及净利润分别取审计物理第7和10页，不倒算基数')
# Record remaining work honestly rather than turn format-validation into completion.
cmd('block',reason='本次finalize未达到完整采集目标：已修正合并资产分类、经营利润桥、归母权益和主要经营单元，但银根矿业2024年独立审计（materials/supplemental/yingen-audit.pdf，129页，覆盖2024全年及2025年1—5月）仍有完整资产对象、经营费用及滚存附注未逐项结构化，不能以目前汇总替代成功；2025年末该单元自身少数股东与全年归母基数未单列，已记录缺失。上市公司两年实际支付普通股东现金股利尚未从含利息及集团内部分派口径中完成核实。固定资产2025年原值增加合计与明细有9,326,425.31元原件差异，保留未解释额。上述缺口均保留于同一JSON，不声称已完成。')
print('Supplemental protocol entries complete')

cmd('narrative',entity='root',id='source_discrepancies',text='2024年报181页其他产品成本168766477.80元、分解表其他业务成本64007681.50元，而同页营业收入成本总表其他业务成本64007681.29元，相差0.21元。保留其他产品披露数，其他业务采用总表口径；该差异低于1元呈报容差。2025年固定资产原值增加明细与合计差9326425.31元已检查PDF原页140页，保留为未解释差额。')
cmd('narrative',entity='root',id='dilution_scope',text='2024、2025年报股本及其他权益工具附注未列发行在外的可转债、优先股或独立认股工具，dilution为空；已发行限制性股票纳入现有总股数，回购义务分别在资产负债与归母权益变化记录，不重复列作新增股份。')

import json, subprocess, shutil, hashlib
from pathlib import Path
P='.agents/skills/company-two-table/scripts/protocol.py'; D='outputs/draft.json'
shutil.copyfile(D,'outputs/draft.before-finalize.json')
x=json.load(open(D)); g=x['entities']['group']
def run(cmd,**kw):
 args=['python3',P,cmd]
 if cmd!='init': args+=['--draft',D]
 for k,v in kw.items():
  if v is not None: args+=['--'+k.replace('_','-'),str(v)]
 r=subprocess.run(args,capture_output=True,text=True)
 if r.returncode: raise RuntimeError(r.stdout+r.stderr)
def val(cmd,period,amount,page,basis,status='disclosed',calculation=None,source_id='filing_2025',**kw):
 run(cmd,period=period,amount='null' if amount is None else amount*1000,status=status,source_id=source_id,page=page,basis=basis,calculation=calculation,**kw)
def asset(i,label,section,values,page,group='operating',basis=None):
 for p,v in zip(x['periods'],values):
  val('asset-object',p,v,page,basis or f'2025年报附注明细；{label}；2024比较列及2025本年列，RMB千元转基本单位。',entity='group',id=i,label=label,section=section,group=group)
  run('movement-review',entity='group',object=i,period=p,status='difference_only',basis='余额比较；不倒算变动原因。',source_ids='filing_2025')
def move(i,p,mid,label,v,page=119,basis=None):
 run('asset-movement',entity='group',object=i,id=mid,period=p,label=label,amount=v*1000,source_id='filing_2025',page=page,basis=basis or '附注14(A)同一列成本及累计折旧滚存，RMB千元；成本增加为正，折旧费用为负，累计折旧冲销为正。')
run('init',company_code='00837.HK',company_name='谭木匠',periods='2024,2025',currency='CNY',display_scale=1e8,out=D)
for s in x['sources'].values(): run('source',**s)
p=Path('materials/supplement/interim-2025.pdf')
count=int(subprocess.check_output(['pdfinfo',str(p)],text=True).split('Pages:')[1].split()[0])
run('source',id='interim_2025',kind='filing',path=str(p),basis='补充检查2025中期报告附注17（2024少数股权收购）；未提供标的独立两表；中期交易数字与年度审计披露不同，年度金额以年报为准。',sha256=hashlib.sha256(p.read_bytes()).hexdigest(),page_count=count)
run('source',id='hkex_search',kind='external',path='https://www1.hkexnews.hk/search/titlesearch.xhtml?category=0&lang=EN&market=SEHK&stockId=38490',basis='2026-09-13检索00837在2024—2025期间的交易、标的审计及补充披露；检索命中年报、中报，未取得子公司独立审计全文。检索不证明不存在其他披露。')
run('entity',id='group',name='谭木匠集团',code='00837.HK',scope='上市股票对应合并会计主体；母公司单体另列，不与合并数字加总。',accounting_scope='consolidated')
run('coverage',entity='group',level='complete',basis='已复核2024、2025年报合并报表、附注5—8、14—30及母公司单体附注，并补查2025中报收购附注及披露易检索。子公司仅登记基本资料，没有取得独立两表；不得声称已排除全部补充披露。合并使用权滚存、渠道成本现金流分配及税项归属存在下述缺口。',source_ids='filing_2024,filing_2025,interim_2025,hkex_search')
# Re-enter verified balances, correcting labels, classes and physical pages.
exclude={'receivables_other_current','receivables_other_noncurrent','payables_other','rou_land','rou_buildings'}
for i,r in g['assets'].items():
 if i in exclude: continue
 page=119 if i.startswith('ppe_') else 128 if i.startswith('inventory') else 129 if i=='receivables_trade' else 124 if i.startswith('investprop') else 134 if i in ['cash','deposit_short','deposit_long'] else 131 if i=='fvtpl' else 126 if i=='intangible' else 136 if i in ['payables_trade','dividend_payable'] else 137 if i.startswith('lease_') else 80 if i in ['deferred_tax','deferred_income'] else 79
 label={'inventory_raw':'梳具及木制配饰原材料库存','inventory_wip':'梳具及木制配饰在产品','inventory_finished':'梳具及木制配饰产成品','fvtpl':'中国银行发行的保本理财产品','ppe_plant':'木梳及木制配饰生产设备','ppe_furniture':'生产办公及销售设施家具装置','ppe_motor':'生产经营机动车辆'}.get(i,r['label'])
 group=r['group']; section=r['section']; vv=[r['amounts'][p]/1000 for p in x['periods']]
 if i=='payables_trade': group='operating';section='working';vv=[-v for v in vv]
 if i=='deferred_income': group='operating';section='other_operating';vv=[-v for v in vv]
 asset(i,label,section,vv,page,group)
asset('other_receivable','经营结算其他应收款（扣除信用损失准备）','working',[6370,7189],130,basis='附注20：其他应收款6515/7342减损失准备145/153，等于6370/7189千元；准备属于其他应收款。')
# mark arithmetic appropriately
for p,v,calc in [('2024',6370,'(6515-145)*1000'),('2025',7189,'(7342-153)*1000')]: val('asset-object',p,v,130,'附注20其他应收款净额。','derived',calc,entity='group',id='other_receivable',label='经营结算其他应收款（扣除信用损失准备）',section='working',group='operating')
asset('deposits_current','经营贸易及租赁押金（一年内）','working',[1773,3300],130)
for p,v,calc in [('2024',1773,'(2397-624)*1000'),('2025',3300,'(7759-4459)*1000')]: val('asset-object',p,v,130,'附注20押金总额减非流动租赁押金。','derived',calc,entity='group',id='deposits_current',label='经营贸易及租赁押金（一年内）',section='working',group='operating')
asset('deposits_long','仓库与门店租赁押金（一年以上）','working',[624,4459],130)
asset('prepayments','经营采购及服务预付款','working',[2372,25319],130)
asset('tax_recoverable','待收回增值税及其他非所得税','other_operating',[141,894],130)
for i,l,v in [('salary','员工应付薪酬',[-16746,-21092]),('accrual','经营结算应付款及应计费用',[-11758,-17624]),('returns','加盟销售退货退款义务',[-2179,-1419]),('vat','增值税及其他非所得税义务',[-550,-3335]),('franchise_deposit','加盟商可退还保证金',[-12291,-12207]),('contracts','加盟商订货预收款',[-3941,-3962])]: asset(i,l,'other_operating' if i in ['salary','vat'] else 'working',v,136)
asset('rou_land','自有厂区对应租赁土地权利','rights',[23165,22751],120)
asset('rou_buildings','仓库门店及生产基地租入土地楼宇使用权','facilities',[13068,30800],120)
# Detailed PPE rollforwards, never a net-difference plug.
ids=['ppe_buildings','ppe_leasehold','ppe_plant','ppe_furniture','ppe_motor','ppe_cip']
rows={'2024': [('additions','购置及建造新增',[0,118,609,536,282,31536]),('dispose_cost','处置原值',[0,0,-922,-316,-142,0]),('transfer','在建项目完工转入或转出',[39025,6161,2647,3680,0,-51513]),('fx_cost','原值汇兑',[0,14,0,0,0,0]),('depreciation','本年折旧',[-1488,-869,-1846,-1950,-120,0]),('dispose_depr','处置冲回累计折旧',[0,0,562,309,128,0]),('fx_depr','累计折旧汇兑',[0,-11,0,0,0,0])], '2025':[('additions','购置及建造新增',[0,1840,495,785,53,15602]),('derec_cost','句容物业诉讼终审后终止确认原值',[-33556,-3677,-354,-624,0,0]),('dispose_cost','处置原值',[0,0,-620,-113,-55,0]),('transfer','在建项目完工转入或转出',[39559,1170,1158,1264,0,-43151]),('fx_cost','原值汇兑',[0,-34,0,4,0,0]),('depreciation','本年折旧',[-1817,-982,-1916,-1265,-110,0]),('derec_depr','终止确认冲回累计折旧',[11471,1725,203,480,0,0]),('dispose_depr','处置冲回累计折旧',[0,0,587,102,52,0]),('fx_depr','累计折旧汇兑',[0,19,0,0,0,0])]}
for p,rr in rows.items():
 for mid,label,values in rr:
  for i,v in zip(ids,values):
   if v: move(i,p,mid,label,v)
 for i in ids: run('movement-review',entity='group',object=i,period=p,status='explained',basis='附注14(A)物理119页逐类成本和累计折旧完整滚存，2025终止确认原因续见物理120页。2024期初净额为30081/8157/11605/2963/495/52624千元。',source_ids='filing_2025')
for p in ['2024','2025']:
 for i,v in [('rou_land',-828 if p=='2024' else -970),('rou_buildings',-3030 if p=='2024' else -3581)]:
  move(i,p,'depreciation','本年使用权折旧',v,120,'附注14(B)按土地权利和其他租入土地楼宇分列折旧。')
  run('movement-review',entity='group',object=i,period=p,status='partial',basis='附注14(B)物理120—122页只披露两类余额、分类折旧及新增合计1616/21974千元；无法可靠将新增与汇兑分配到两类。2025合计53551-36233=17318，而21974-4551=17423，差额-105千元未明确拆因；不倒算为汇兑。2024合计差额另有113千元未明确归属。',source_ids='filing_2024,filing_2025')
for p,vals in [('2024',[80000,816,-10025,0]),('2025',[160000,669,-160789,-2])]:
 for mid,l,v in zip(['purchase','fairvalue','sale','sale_loss'],['购入保本理财','公允价值收益','到期或出售收回','处置损失'],vals):
  if v: move('fvtpl',p,mid,l,v,131,'附注21完整滚存，RMB千元。')
 run('movement-review',entity='group',object='fvtpl',period=p,status='explained',basis='附注21滚存；2024期初10000千元。',source_ids='filing_2025')
for p,vals in [('2024',[-570,-6900]),('2025',[0,-2700])]:
 for i,v in zip(['investprop_residential','investprop_commercial'],vals):
  move(i,p,'fairvalue','投资物业公允价值重估',v,123,'附注15总滚存仅有公允价值变化；类别余额见2025物理124页及2024物理113页。')
  run('movement-review',entity='group',object=i,period=p,status='explained',basis='附注15唯一变化为重估，按类别比较确定；2023住宅4870、商业86700千元。',source_ids='filing_2024,filing_2025')
for cid,r in g['controls'].items():
 for p,v in r['amounts'].items(): val('control',p,v/1000,80,'合并财务状况及权益变动表物理80—81页。',entity='group',id=cid)
# Remove duplicated equity details; canonical rows retain each effect once.
for i,r in g['equity_changes'].items():
 if i in ['oci_translation_functional','oci_translation_foreign','nci_transaction_parent']: continue
 for p,v in r['amounts'].items():
  val('equity-change',p,v/1000,81,'合并权益变动表。OCI为两类汇兑合计；权益确认分红与现金支付分开录入。','derived' if i=='parent_equity_change' else 'disclosed','2024:(883959-804385)*1000;2025:(970204-883959)*1000' if i=='parent_equity_change' else None,entity='group',id=i,label=r['label'],kind=r['kind'],order=r['order'])
for i,r in g['owner_flows'].items():
 for p,v in r['amounts'].items(): val('operating-row',p,v/1000,83,'合并现金流量表融资活动；实际支付现金。',entity='group',module='owner_flows',id=i,label=r['label'],kind=r['kind'])
run('business',entity='group',id='total',label='木梳及木制配饰生产销售、加盟服务合计',kind='total')
nonops={'interest':('银行利息收入',[11757,7725]),'rental':('投资物业租金净收益',[4064,2461]),'property_fv':('投资物业公允价值损失',[-7470,-2700]),'wealth_fv':('保本理财公允价值收益',[816,669]),'fx':('汇兑净收益或损失',[4,-124]),'wealth_sale':('理财处置损失',[0,-2])}
for idx,p in enumerate(['2024','2025']):
 op=[213545,217150][idx]-sum(v[1][idx] for v in nonops.values())
 vals={'revenue':[505436,558223][idx],'direct_cost':[-200234,-212921][idx],'gross_profit':[305202,345302][idx],'period_cost':op-[305202,345302][idx], 'asset_net_consumption':None,'operating_profit':op,'operating_tax':None,'tax_after_operating_profit':None,'asset_addback':[14024,36942][idx],'working_capital_effect':[-45938,-34226][idx],'operating_cash_contribution':None,'asset_spending':[-33031,-18743][idx],'free_cash_contribution':None}
 for m,v in vals.items():
  reason='按合并损益表及附注6、7和现金流量表整理。'
  calc=None; status='disclosed';pg=77
  if m in ['operating_tax','tax_after_operating_profit','operating_cash_contribution','free_cash_contribution']: status='missing'; reason='全公司所得税及实际经营现金净额已知，但未披露经营与银行理财、投资物业等非经营项目的税和现金归属，不把全部所得税分配给经营，也不倒算现金贡献。'
  elif m=='asset_net_consumption': status='missing'; reason='折旧10131/10641、存货净减值2851/1939、固定资产处置损失331/15及终止确认0/24332、应收损失711/15千元已披露且嵌入直接成本或期间费用；附注7仅合并披露存货成本中员工成本和折旧65686/73037千元，无法拆出各费用中的折旧，不额外重复扣减。'
  elif m=='period_cost': status='derived'; calc=f'({op}-{[305202,345302][idx]})*1000';reason='经营费用净额含经营补助及增值税退税、其他经营收入；保留已含资产耗损的费用口径。资产耗损单列缺失仅表示不能重复拆分，非耗损总额未知。'
  elif m=='operating_profit': status='derived';calc=f'({[213545,217150][idx]}-({"+".join(str(v[1][idx]) for v in nonops.values())}))*1000';reason='报表经营利润扣除银行利息、投资物业净租金、公允价值变化、汇兑和理财处置损益，附注6、7。'
  elif m=='asset_addback': status='derived';pg=82;calc=['(6273+3858+2851+331+24+21+666)*1000','(6090+4551+2259-320+24332+15+7+8)*1000'][idx];reason='经营资产折旧、净减值、处置及终止确认损失加回；不含投资物业重估。'
  elif m=='working_capital_effect':status='derived';pg=82;calc=['(-47213-369+872+2651-1879)*1000','(-17997-587-30693+2592+12459)*1000'][idx];reason='现金流量表五项营运资金变化实际合计，未包含税款时差、收息或其他非现金调整；不使用残差。'
  elif m=='asset_spending':status='derived';pg=83;calc=['(-33081+50)*1000','(-18775+32)*1000'][idx];reason='购建固定资产付款加出售收款；不混入定存、理财或普通融资现金。'
  val('business-metric',p,v,pg,reason,status,calc,entity='group',business='total',metric=m)
 # bridge rows replay audited controls, corrected business OP
 for i,r in g['other_profit'].items():
  v=op if i=='business_operating_profit' else r['amounts'][p]/1000
  val('operating-row',p,v,77,'合并损益表；业务经营利润由报表经营利润剔除独立列示的非经营项目。','derived' if i=='business_operating_profit' else 'disclosed',f'{op}*1000，计算见业务合计operating_profit' if i=='business_operating_profit' else None,entity='group',module='other_profit',id=i,label=r['label'],kind=r['kind'],order=r['order'])
 for n,(i,(label,v)) in enumerate(nonops.items()):
  val('operating-row',p,v[idx],111 if i=='rental' else 82 if i=='wealth_sale' else 110,'附注6、7；投资物业净租金为租金减已披露直接支出。','derived' if i=='rental' else 'disclosed', ['(4743-679)*1000','(2899-438)*1000'][idx] if i=='rental' else None,entity='group',module='other_profit',id=i,label=label,kind='line',order=11+n)
 for i,l,v,pg in [('reported_ocf','报表经营活动现金净额（含收息及全公司税款）',[146387,177450],82),('operating_cash_generated','营运资金变动后经营产生现金（未付税未收息）',[175724,213393],82),('cash_interest','报表经营活动收到利息',[8536,8529],82),('cash_tax','实际所得税及预提税付款',[-37873,-44472],82),('noncash_grant','递延补助转损益（经营现金桥扣除）',[-21,-21],82),('return_provision','销售退货准备转回（经营现金桥扣除）',[-783,-760],82)]:
  val('operating-row',p,v[idx],pg,'补充保留合并现金流量表披露；置于净利润桥之后，不参与利润相加。','derived' if i=='cash_tax' else 'disclosed', ['(-33373-4500)*1000','(-39887-4585)*1000'][idx] if i=='cash_tax' else None,entity='group',module='other_profit',id=i,label=l,kind='subtotal',order=100)
for i,l,v in [('online','线上木梳及配饰销售',[209636,228738]),('offline','线下渠道木梳及配饰销售',[290161,323983]),('joining','加盟入网服务费',[1179,712]),('retail','直营门店木梳及配饰销售',[4460,4790])]:
 run('business',entity='group',id=i,label=l,kind='business')
 for p,a in zip(['2024','2025'],v):
  for m in g['businesses']['total']['metrics']:
   val('business-metric',p,a if m=='revenue' else None,109,'附注5渠道收入明细。' if m=='revenue' else '附注5披露收入，附注11仅一个经营分部；未独立披露渠道成本、税款、营运资金及资产投入，没有可靠分配依据。','disclosed' if m=='revenue' else 'missing',entity='group',business=i,metric=m)
run('narrative',entity='group',id='scope',text='根主体是集团合并。下列母公司单体是同一结果内的独立会计口径，不是集团新增经济资产，禁止与合并相加。附注17子公司仅披露名称、股权及注册资本；注册资本不是其净资产或对子公司投资账面余额。')
run('narrative',entity='group',id='dilution',text='2025年报物理118页附注13确认2024及2025无发行在外潜在稀释股份；潜在稀释工具为空。')
run('narrative',entity='group',id='filing_conflicts',text='原件内部差异保留：2025物理135页股利负债2024期末1882千元与物理136页333千元不符；租赁滚存期末20774千元与主表和附注26的20773千元差1千元，余额采用主表。2025物理139页母公司2024权益分红89569千元与合并权益89996千元不同，分别按各会计主体权益表录入。补查2025中报少数股权收购金额4444、净资产4099与年度审计4445、4212不一致，年度用已审计数据。')
# Company standalone: disclosed assets and equity, operating gaps retained.
run('entity',id='parent_standalone',name='谭木匠控股有限公司（母公司单体）',parent_id='group',accounting_scope='standalone',scope='上市母公司独立口径，与根合并主体不加总；只列对子公司投资、往来及自身资产义务。')
run('coverage',entity='parent_standalone',level='partial',basis='2024年报物理139页、130页及2025年报物理148页、139页提供单体资产负债及权益；未提供单体完整损益或现金流量表。补查中报及披露易未取得2024/2025单体独立经营链。',source_ids='filing_2024,filing_2025,interim_2025,hkex_search')
for i,l,section,grp,v in [('investment','对Carpenter Tan (BVI)投资','investments','nonoperating',[47,47]),('duefrom','应收控股子公司往来','other_assets','nonoperating',[154414,147999]),('deposits','母公司服务押金及预付款','working','operating',[23,133]),('cash','母公司银行及手头现金','cash','nonoperating',[377,506]),('dueto','应付控股子公司往来','financing','liabilities',[24855,24195]),('payables','母公司服务应付款及应计费用','working','operating',[-3143,-3103])]:
 for p,a in zip(['2024','2025'],v):
  val('asset-object',p,a,148,'附注33母公司独立资产负债表，千元转基本单位。',entity='parent_standalone',id=i,label=l,section=section,group=grp)
  run('movement-review',entity='parent_standalone',object=i,period=p,status='difference_only',basis='单体只披露资产负债余额，无细分滚存。',source_ids='filing_2025')
run('business',entity='parent_standalone',id='total',label='母公司投资管理及自身经营',kind='total')
for idx,p in enumerate(['2024','2025']):
 val('control',p,[126863,121387][idx],148,'母公司单体净资产，不套用归母或少数股东标签。',entity='parent_standalone',id='parent_equity')
 for m in g['businesses']['total']['metrics']: val('business-metric',p,None,148,'母公司只提供财务状况表及储备变动，未披露独立收入费用或现金流；不能用集团数或子公司分红倒算。','missing',entity='parent_standalone',business='total',metric=m)
 val('operating-row',p,[82102,82595][idx],139,'母公司储备变动表的主体净利润。',entity='parent_standalone',module='other_profit',id='parent_profit',label='母公司单体净利润',kind='total')
 for i,l,v in [('parent_profit','母公司单体净利润',[82102,82595]),('other_comprehensive_income','母公司列报货币换算差额',[4891,1498]),('equity_distribution','母公司权益确认分红',[-89569,-89569]),('owner_input','股东投入',[0,0]),('share_compensation','权益结算激励',[0,0]),('repurchase','股份回购',[0,0]),('minority_transactions','单体不适用少数股权交易',[0,0]),('other_direct_equity_change','其他直接权益变动',[0,0]),('parent_equity_change','母公司主体净资产变化',[-2576,-5476])]:
  val('equity-change',p,v[idx],139,'母公司储备变动表；股本两期均2189千元。',entity='parent_standalone',id=i,label=l,kind='total' if i=='parent_equity_change' else 'line')
 val('operating-row',p,None,148,'未披露母公司单体现金流表；合并实际股利支付不直接替代母公司现金流。','missing',entity='parent_standalone',module='owner_flows',id='cash_dividend_paid',label='母公司实际现金股利支付',kind='line')
run('narrative',entity='parent_standalone',id='dilution',text='同一上市公司，附注13确认2024及2025无潜在稀释股份；工具为空。')
run('block',reason='本次完整目标未达成。已核对2024及2025年报，并补查2025中报少数股权收购附注及披露易搜索。已修正资产分类、页码，拆解固定资产完整滚存，补录母公司单体及渠道收入。剩余：使用权资产分类新增及汇兑缺少可闭合路径；经营/非经营税费和现金流不能可靠分配，禁止用残差闭合；渠道成本、税与现金投入仅披露集团总额；母公司缺完整单体损益与现金流；子公司未取得独立两表。原件股利负债及租赁负债滚存存在差异，已在对应说明保留。')
print('Protocol reconstruction complete')

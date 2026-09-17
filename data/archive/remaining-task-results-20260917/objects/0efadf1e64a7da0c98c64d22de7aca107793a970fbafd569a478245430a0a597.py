"""Replay verified facts through the task-local protocol; never serialize result JSON."""
import json, subprocess, sys, hashlib
from pathlib import Path
P='.agents/skills/company-two-table/scripts/protocol.py'
D='outputs/draft.json'
old=json.loads(Path('outputs/draft.before-finalize.json').read_text())
g=old['entities']['group']
log=open('outputs/protocol-commands.jsonl','w')
def call(cmd, **kw):
    args=[sys.executable,P,cmd]
    if cmd not in ('init','validate'):kw={'draft':D,**kw}
    for k,v in kw.items():
        if v is not None:args += ['--'+k.replace('_','-'),str(v)]
    log.write(json.dumps(args,ensure_ascii=False)+'\n');log.flush()
    r=subprocess.run(args,capture_output=True,text=True)
    if r.returncode:raise RuntimeError(r.stdout+r.stderr+str(args))
def val(amount,page,basis, status='disclosed',calc=None,source='filing_2025'):
    return dict(amount=amount,status=status,source_id=source,page=page,basis=basis,calculation=calc)
def facts(cmd,kw,amounts,page,basis, status='disclosed',calcs=None,source='filing_2025'):
    for i,p in enumerate(('2024','2025')):
        call(cmd,**kw,period=p,**val(amounts[i]*1000,page,basis,status,None if calcs is None else calcs[i],source))
def review(id,status='difference_only',basis='已核对2025年报两期余额；日常周转余额保留自动差额，不推定差额原因。',entity='group'):
    for p in ('2024','2025'):call('movement-review',entity=entity,object=id,period=p,status=status,basis=basis,source_ids='filing_2024,filing_2025')
def asset(id,label,amounts,page,group='operating',section='working',status='disclosed',calcs=None,basis=None,entity='group',rev=True):
    facts('asset-object',dict(entity=entity,id=id,label=label,group=group,section=section),amounts,page,basis or label+'；金额单位为人民币千元，录入乘1000。',status,calcs)
    if rev:review(id,entity=entity)
def movement(id,mid,label,amount,p,page=119,basis=None):
    if amount:call('asset-movement',entity='group',object=id,id=mid,label=label,period=p,amount=amount*1000,source_id='filing_2025',page=page,basis=basis or '附注14(A)，'+label+'，按该资产列成本及累计折旧滚存净额计算。')
call('init',company_code='00837.HK',company_name='谭木匠',periods='2024,2025',currency='CNY',display_scale=1e8,out=D)
for s in old['sources'].values():
    s=dict(s);s['basis'] += '；金额页码均为PDF物理页码。'
    assert hashlib.sha256(Path(s['path']).read_bytes()).hexdigest()==s['sha256']
    call('source',**s)
f=Path('materials/supplemental/litigation-20260109.pdf')
call('source',id='litigation_20260109',kind='filing',path=str(f),basis='2026-01-09诉讼进展公告，追溯2013购置及2025-12-29裁定；https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0109/2026010900139.pdf；全文4页已查阅，最终入账金额采用2025审计年报。',sha256=hashlib.sha256(f.read_bytes()).hexdigest(),page_count=4)
call('entity',id='group',name=g['name'],scope=g['scope'],accounting_scope='consolidated')
call('coverage',entity='group',level='complete',basis='查阅2024、2025年报财务报表及附注（两年完整年度），2025年报附注5渠道收入、14设施及租赁、15出租物业、17子公司与少数股权交易、18—30周转及金融资产义务、33母公司单体；另查2026-01-09诉讼公告全文解释2025句容物业终止确认。2024少数股权退出交易年报附注17(B)已给出对价与权益影响；未取得子公司独立两表，注册资本不是资产余额，不套用集团数。母公司单体另附partial。',source_ids='filing_2024,filing_2025,litigation_20260109')
# Retain verified balance-sheet facts, replacing broad objects below with note-level objects.
replace={'ppe','inventory','other_payables','current_other_receivables','nc_other_receivables','investment_property'}
labels={'fvtpl':'中国境内银行发行的一年内到期保本理财产品','rou':'木梳生产用土地及租赁生产用地、仓库和直营店铺使用权（附注未分摊新增）','cash':'集团银行活期及三个月内到期现金等价物','tax_payable':'境内外主体利润及分红预扣应付所得税','deferred_tax':'出租物业公允价值、自用物业重估与租赁暂时差异递延税负债','lease_current':'生产用地、仓库及直营店租约一年内到期义务','lease_noncurrent':'生产用地、仓库及直营店租约一年后到期义务','deferred_income':'生产经营政府补助未摊销递延收入'}
for id,r in g['assets'].items():
    if id in replace:continue
    page=80 if id in ('deferred_tax','lease_noncurrent','deferred_income') else 79
    if id=='fvtpl':page=131
    if id=='rou':page=120
    asset(id,labels.get(id,r['label']),[r['amounts'][p]/1000 for p in ('2024','2025')],page,r['group'],r['section'],rev=id!='rou')
    if id=='rou':
        for p,a,d in [('2024',1616,-3858),('2025',21974,-4551)]:
            movement(id,'additions','新增生产用地、仓库及店铺使用权',a,p,121,'附注14(B)新增合计，未分摊至土地与房屋；不重复加入现金资本开支。')
            movement(id,'depreciation','自用土地及租赁土地房屋折旧',d,p,120,'附注14(B)折旧合计；2024为828+3030，2025为970+3581千元。')
        review(id,'partial','已核查2024年报物理109—111页、2025年报120—122页及租赁现金流附注。2023期末38362千元；2024新增1616、折旧3858、期末36233，剩余113千元；2025新增21974、折旧4551、期末53551，剩余-105千元。原件无完整其他变动表，不倒算为汇兑或修改。新增未按土地和房屋分摊，保留合计对象及分类余额说明。')
# Fixed assets: six independently disclosed columns and their additive roll-forwards.
ppe=[('buildings','木梳生产及集团办公自有房屋',[67618,83275]),('improvements','生产、仓储及销售租赁物业装修',[13570,13631]),('equipment','木梳及工艺品生产机器设备',[12655,12208]),('fixtures','生产办公及直营店家具装置',[5222,5855]),('vehicles','生产经营运输车辆',[643,583]),('construction','木梳生产园区及生产配套在建工程',[32647,5098])]
adds=[[0,118,609,536,282,31536],[0,1840,495,785,53,15602]]
deps=[[1488,869,1846,1950,120,0],[1817,982,1916,1265,110,0]]
disps=[[0,0,-360,-7,-14,0],[0,0,-33,-11,-3,0]]
trans=[[39025,6161,2647,3680,0,-51513],[39559,1170,1158,1264,0,-43151]]
fx=[[0,3,0,0,0,0],[0,-15,0,4,0,0]]
derec=[-22085,-1952,-151,-144,0,0]
opens=[30081,8157,11605,2963,495,52624]
for j,(id,label,amts) in enumerate(ppe):
    asset(id,label,amts,119,section='projects' if id=='construction' else 'facilities',rev=False)
    for i,p in enumerate(('2024','2025')):
        for mid,l,a in [('additions','本年购建新增',adds[i][j]),('depreciation','本年折旧',-deps[i][j]),('disposals','处置转销账面净值',disps[i][j]),('transfer','在建工程竣工转入或转出',trans[i][j]),('exchange','外币折算净差额',fx[i][j]),('derecognition','句容管理中心诉讼相关资产终止确认',derec[j] if i else 0)]:movement(id,mid,l,a,p)
    review(id,'explained',f'2025年报物理119页附注14(A)该列成本减累计折旧；2024期初账面{opens[j]}千元。处置和终止确认用成本转销减累计折旧转销，转入转出单列，两年均数值闭合。2025句容终止确认详见120页及已登记诉讼公告，不作为期末仍持有资产重复计入。')
# Inventories and receivable/deposit reality objects.
for id,label,amts in [('raw_materials','木梳及工艺品木材等原料库存',[230711,234417]),('work_in_progress','正在加工的木梳及工艺品',[24307,29313]),('finished_goods','待售木梳及配件产成品',[37480,44826])]:asset(id,label,amts,128)
for id,label,amts,sec,status,calc in [
 ('other_receivables_net','日常经营其他应收款（扣除损失准备）',[6370,7189],'working','derived',['(6515-145)*1000','(7342-153)*1000']),
 ('long_rental_deposits','一年以上生产及店铺租约可退租赁按金',[624,4459],'working','disclosed',None),
 ('short_deposits_operating','一年内贸易和租赁按金',[1773,3300],'working','derived',['(2397-624)*1000','(7759-4459)*1000']),
 ('prepayments','生产销售经营预付款',[2372,25319],'working','disclosed',None),
 ('vat_recoverable','可收回增值税及其他非所得税',[141,894],'other_operating','disclosed',None)]:asset(id,label,amts,130,section=sec,status=status,calcs=calc,basis='附注20两期分项；非流动部分明确全部为租赁按金，损失准备从其他应收款扣除，不重复列总额。')
for id,label,amts in [('salary_payable','木梳生产、销售及管理员工应付工资',[-16746,-21092]),('operating_accruals','日常经营未付费用及应计结算款',[-11758,-17624]),('sales_returns','加盟产品销售可退货退款义务',[-2179,-1419]),('vat_payable','销售增值税及其他非所得税应付款',[-550,-3335]),('franchise_deposits','加盟商可退还履约保证金',[-12291,-12207]),('contract_liabilities','加盟商货款预收及待履约交货义务',[-3941,-3962])]:asset(id,label,amts,136)
asset('dividend_payable','已确认尚未支付股东股利',[333,0],136,'liabilities','shareholder')
for id,label,amts,losses,opening in [('rental_residential','中国境内对外出租住宅物业',[4300,4300],[-570,0],4870),('rental_commercial','中国境内对外出租商业物业',[79800,77100],[-6900,-2700],86700)]:
    asset(id,label,amts,126,'nonoperating','other_assets',rev=False)
    for p,a in zip(('2024','2025'),losses):movement(id,'fair_value','出租物业公允价值损失',a,p,126,'附注15分住宅/商业公允价值滚存。')
    review(id,'explained',f'附注15物理126页；2024期初{opening}千元，两年均仅有明确披露的公允价值变化，闭合。')
for i,p in enumerate(('2024','2025')):
    for mid,l,a in [('subscription','认购境内银行保本理财',[80000,160000][i]),('fair_value','理财公允价值收益',[816,669][i]),('redemption','赎回理财收款',[-10025,-160789][i]),('disposal_loss','赎回理财损失',[0,-2][i])]:movement('fvtpl',mid,l,a,p,131,'附注21明示的同一滚存路径。')
review('fvtpl','explained','2025年报物理131页理财滚存；2024期初10000千元，认购+公允价值-赎回-处置损失分别闭合至两期末。')
# Equity controls.
for id,r in g['controls'].items():facts('control',dict(entity='group',id=id),[r['amounts'][p]/1000 for p in ('2024','2025')],80,'合并财务状况表及权益变动表；归母权益等于总权益，无期末非控股权益。')
# Company operating metrics: no unsupported allocation of income tax.
call('business',entity='group',id='total',label='公司合计：谭木匠木梳及工艺品生产销售',kind='total',order=0)
for id,r in g['businesses']['total']['metrics'].items():
    if id in ('operating_tax','asset_spending'):continue
    calc=None
    if id=='period_cost':calc=['(-41851-85624-6638)*1000','(-45432-96945-30820)*1000']
    if id=='operating_profit':calc=['(305202-134113)*1000','(345302-173197)*1000']
    facts('business-metric',dict(entity='group',business='total',metric=id),[r['amounts'][p]/1000 for p in ('2024','2025')],77,'合并损益表：期间费用含行政、销售分销及其他经营费用，已包含折旧、减值和2025句容终止确认损失，不再独立扣耗损。', 'derived' if calc else 'disclosed',calc)
for i,(id,label,amts) in enumerate([('online','线上木梳及配件销售',[209636,228738]),('offline_goods','线下加盟及分销商品销售',[290161,323983]),('franchise_fee','线下加盟加入费',[1179,712]),('direct_outlets','直营门店商品销售',[4460,4790])],1):
    call('business',entity='group',id=id,label=label,order=i)
    facts('business-metric',dict(entity='group',business=id,metric='revenue'),amts,109,'附注5客户合同收入按销售渠道拆分；未披露渠道独立成本、税和现金流，仅录收入。')
for id,r in g['other_profit'].items():
    if id=='other_income':continue
    calc=['(305202-134113)*1000','(345302-173197)*1000'] if id=='business_operating_profit' else None
    facts('operating-row',dict(entity='group',module='other_profit',id=id,label=r['label'],kind=r['kind'],order=r['order']*20),[r['amounts'][p]/1000 for p in ('2024','2025')],77,'合并损益表；非控股利润取负数以闭合归母净利润。','derived' if calc else 'disclosed',calc)
other=[('grants','就业、制造及境外推广政府补助',[833,3313]),('grant_release','政府补助递延收入摊销',[21,21]),('bank_interest','银行存款利息',[11757,7725]),('vat_refund','残疾人就业增值税退税',[28904,30898]),('rental_income','商业及住宅投资物业租金',[4743,2899]),('fx_profit','汇兑净收益或损失',[4,-124]),('property_fv','投资物业公允价值损失',[-7470,-2700]),('disposal_loss','生产经营设施处置损失',[-331,-15]),('trade_impairment','加盟及其他客户应收款减值',[-24,-7]),('wealth_fv','银行保本理财公允价值收益',[816,669]),('other_income_remaining','附注6未进一步细分的其他收入',[3203,2366])]
for i,(id,l,amts) in enumerate(other,1):facts('operating-row',dict(entity='group',module='other_profit',id=id,label=l,order=i),amts,110,'附注6其他收入及其他净收益明示分项，不把合计再次相加。')
for id,r in g['owner_flows'].items():facts('operating-row',dict(entity='group',module='owner_flows',id=id,label=r['label'],order=r['order']),[r['amounts'][p]/1000 for p in ('2024','2025')],83,'合并现金流量表融资活动；现金股东往来独立于权益确认金额。')
# Latest comparative cash-flow classifications.
for id,r in g['cash_flow'].items():
    amts=[r['amounts'][p]/1000 for p in ('2024','2025')]
    if id=='other_receivable_allowance':amts=[21,8]
    if id=='other_receivable_wc':amts=[872,-30693]
    page=77 if id in ('net_profit','income_tax_adjust') else 83 if id=='asset_spending' else 82
    calc=['(146387-33081)*1000','(177450-18775)*1000'] if id=='free_cash_flow' else None
    facts('operating-row',dict(entity='group',module='cash_flow',id=id,label=r['label'].replace('其他应收款、按金及预付款减少','其他应收款、按金及预付款周转影响'),kind=r['kind'],order=r['order']*10),amts,page,'2025年报合并现金流量表及2024比较列；先以净利润加回所得税到税前，再按原件调整至法定经营现金净额。','derived' if calc else 'disclosed',calc)
facts('operating-row',dict(entity='group',module='cash_flow',id='other_receivable_writeoff',label='其他应收款核销',order=155),[666,0],82,'2025年报比较列将2024原列666千元其他应收款损失准备改列核销，另外列准备21千元及周转释放872千元；法定经营现金不变。')
for id,r in g['equity_changes'].items():
    calc=['(883959-804385)*1000','(970204-883959)*1000'] if id=='parent_equity_change' else None
    facts('equity-change',dict(entity='group',id=id,label=r['label'],kind=r['kind'],order=r['order']),[r['amounts'][p]/1000 for p in ('2024','2025')],81,'合并权益变动表；2024期初归母权益为808484-4099=804385千元。无发生额项目为表中无该变动。','derived' if calc else 'disclosed',calc)
call('narrative',entity='group',id='dilution_note',text='潜在稀释工具为空：2024年报物理128页记载此前授出购股权已于2023-08-30全部到期；2025年报物理118页明确2024、2025年均无潜在摊薄股份。2018年回购的50000股仍未注销（2025年报140页），不构成本期回购或新稀释工具。')
call('narrative',entity='group',id='equity_note',text=g['narratives']['equity_note']+' 2024集团权益确认分配89996千元，母公司单体确认89569千元，各自主体保留原披露。')
call('narrative',entity='group',id='cash_flow_note',text='2024/2025合并净利润171479/171027千元，经非现金项目、经营周转、收息及实付所得税和预扣税调整，经营现金净额146387/177450千元；扣现金购建支出33081/18775千元后为113306/158675千元。费用已含折旧及资产损失；租赁本金在融资活动，不当作额外资本开支。2024比较现金流采用2025年报82页重分类：准备21、核销666、其他应收款周转872千元；2024年报69页原为准备666及周转893千元，合计现金不变。')
call('narrative',entity='group',id='asset_detail_note',text='使用权附注分类余额（千元）：自有土地使用权2024/2025为23165/22751，其他租赁土地及房屋13068/30800；分类折旧828/970及3030/3581。未披露新增分摊，资产对象保留整体滚存。2025年报122页另述30880，与120页分类表30800不一致，采用与资产负债表53551闭合的分类表；不造差额原因。万州生产用地账面5418/5257包含在自有土地中，未另加。原料存货一年后收回2025为166816千元、2024最新比较201224千元（2025年报128页），2024年报117页原为127971千元；总原料余额无变化，保留比较披露差异。')
call('narrative',entity='group',id='litigation_note',text='句容管理中心：已查2026-01-09公告全文（来源litigation_20260109），覆盖2013购入至2025-12-29裁定；公告初估账面22796120元。最终采用2025年报119—120页审计滚存，房屋及配套设施合计终止确认24332000元；购价33556320元不是期末资产。年报119页仍述房屋22085千元，与同页转销相对应，不重复视为年末仍持有。申诉/破产索偿未确认可收回资产，不能将购价补回资产余额。')
# Standalone listed parent, explicitly attached as a separate accounting scope.
call('entity',id='parent_standalone',name='谭木匠控股有限公司（上市母公司单体附列）',scope='上市母公司单体，附列于合并主体；不是合并主体的法律子公司，不与集团相加。',accounting_scope='standalone',parent_id='group')
call('coverage',entity='parent_standalone',level='partial',basis='2024年报物理130、139页及2025年报139、148页披露母公司单体资产负债与储备变动，涵盖2024、2025完整年度。独立利润表收入成本及现金流量表未披露；仅保存主体投资往来、实际净利润及权益变化，不使用集团业务现金流。2025储备分类列含内部数值不一致，采用净资产总额与可闭合变动行，差异在叙述中保留。',source_ids='filing_2024,filing_2025')
for id,label,amts,group,section in [('sub_investment','对Carpenter Tan (BVI) Holdings Group的单体投资',[47,47],'nonoperating','investments'),('due_from_subs','母公司对子公司应收往来',[154414,147999],'nonoperating','other_assets'),('parent_prepayment','母公司日常按金和预付款',[23,133],'operating','working'),('parent_cash','母公司银行结存',[377,506],'nonoperating','cash'),('due_to_subs','母公司应付子公司往来',[24855,24195],'liabilities','financing'),('parent_accruals','上市母公司费用应计及其他应付款',[-3143,-3103],'operating','working')]:asset(id,label,amts,148,group,section,entity='parent_standalone')
facts('control',dict(entity='parent_standalone',id='parent_equity'),[126863,121387],148,'附注33母公司单体净资产。')
facts('operating-row',dict(entity='parent_standalone',module='other_profit',id='parent_profit',label='上市母公司单体净利润',kind='total'),[82102,82595],139,'附注29母公司储备变动披露本年净利润，不能理解为集团净利润。')
for id,label,amts in [('parent_profit','母公司单体净利润',[82102,82595]),('other_comprehensive_income','母公司功能币折算呈报币汇兑收益',[4891,1498]),('equity_distribution','母公司权益确认利润分配',[-89569,-89569])]:facts('equity-change',dict(entity='parent_standalone',id=id,label=label),amts,139,'附注29母公司储备变动表。')
for id,label in [('owner_input','股东投入'),('share_compensation','权益结算激励'),('repurchase','当年股份回购'),('minority_transactions','少数股权交易'),('other_direct_equity_change','其他直接权益变化')]:facts('equity-change',dict(entity='parent_standalone',id=id,label=label),[0,0],139,'母公司储备变动表无该类直接净权益变动；储备内结转不改变净资产。')
facts('equity-change',dict(entity='parent_standalone',id='parent_equity_change',label='母公司单体权益净变化',kind='total'),[-2576,-5476],139,'母公司权益变动与期末净资产相符。','derived',['(126863-129439)*1000 = (82102+4891-89569)*1000','(121387-126863)*1000 = (82595+1498-89569)*1000'])
call('narrative',entity='parent_standalone',id='disclosure_limit',text='单体没有独立披露营业收入成本和法定经营现金流，不为其生成空经营链。2025年报139页母公司储备明細：外币折算储备列1551与-3049+1498=-1551不符，其列内合计122300与总储备119198亦不同；采用148页净资产121387及139页利润、OCI、分配的可闭合路径，不猜测其他直接权益变化。购股权已到期，潜在稀释工具为空。')
call('narrative',entity='group',id='report_periods',text='2024：2024-01-01至2024-12-31，annual，materials/0；2025：2025-01-01至2025-12-31，annual，materials/1。全部金额按人民币基本单位录入；显示缩放100000000。')
call('block',reason='')
call('compile',out='outputs/result.json')
call('validate',result='outputs/result.json')
print('Protocol replay, compile and final validate passed.')

import json,subprocess,sys
from pathlib import Path
D=Path('outputs/draft.json');d=json.loads(Path('outputs/draft.before-finalize.json').read_text());e=d['entities']['pdd']
def units(o):
 if isinstance(o,dict):
  if 'amounts' in o: o['amounts']={k:None if v is None else int(v*1000) for k,v in o['amounts'].items()}
  if 'evidence' in o:
   for p,v in o['evidence'].items():
    if v.get('source_id')=='f2024' and v.get('page')==276: v['page']=275
    v['basis']=v.get('basis','').replace('test','合并资产负债表归属普通股股东的权益')+'；原表人民币千元乘1,000，录入人民币元'
  for k,v in o.items():
   if k not in ['amounts','evidence']: units(v)
 elif isinstance(o,list):
  for x in o: units(x)
units(e)
e['assets']={};e['section_totals']={};e['dilution']={}
e['other_profit'].pop('equity_investee');e['other_profit']['a_share_results']['order']=8;e['other_profit']['consolidated_profit']['order']=9;e['other_profit']['minority_profit']['order']=10;e['other_profit']['parent_profit']['order']=11
for p in d['periods']:
 g=e['businesses']['total']['metrics']['gross_profit']['evidence'][p];g.update(status='derived',calculation='集团收入 + 负号收入成本',basis='合并综合收益表收入减成本，计算毛利；元')
 e['other_profit']['minority_profit']['evidence'][p].update(status='derived',calculation='合并净利润 - 普通股股东应占净利润 = 0',basis='合并综合收益表两项独立披露总额相同')
 e['equity_changes']['parent_equity_change']['evidence'][p].update(status='derived',calculation='本期披露期末权益 - 本期期初披露权益',basis='合并股东权益变动表；元')
e['equity_changes'].pop('owner_input')
e['cash_flow'].pop('operating_adjustments')
e['cash_flow']['net_profit']['order']=1;e['cash_flow']['operating_cash_flow']['order']=50;e['cash_flow']['asset_spending']['order']=51;e['cash_flow']['free_cash_flow']['order']=52
e['cash_flow']['asset_spending']['label']='购建设备、软件及无形资产现金支出'
e['cash_flow']['free_cash_flow']['label']='经营现金流减现金资本开支'
e['coverage']['basis']='复核两期合并资产负债表、综合收益表、现金流量表、股东权益表及投资、租赁、关联方、股份奖励、VIE和分部附注；2024年细分余额以2025年报比较栏交叉核对。历史参考0.json经营总数复核一致，1.md估值调整不纳入账面两表。'
D.write_text(json.dumps(d,ensure_ascii=False,indent=2))
P='.agents/skills/company-two-table/scripts/protocol.py'
def run(cmd,**kw):
 args=[sys.executable,P,cmd,'--draft',str(D),'--entity','pdd']
 for k,v in kw.items():
  if v is not None: args.append('--'+k.replace('_','-')+'='+str(v))
 z=subprocess.run(args,text=True,capture_output=True)
 if z.returncode: raise RuntimeError(z.stdout+z.stderr+' '+str(args))
def val(cmd,vals,source='f2025',page=282,status='disclosed',basis='合并报表原件；人民币千元乘1,000换算为元',calculation=None,**kw):
 for p,v in zip(['2024','2025'],vals):
  run(cmd,period=p,amount='null' if v is None else round(v*1000),status=status,source_id=source,page=page,basis=basis,calculation=calculation,**kw)
assets=[
('restricted','operating','working','商户结算监管账户受限现金',[68426368,73830824],282,None),
('payment','operating','working','第三方支付平台待结算款',[3679309,5109129],282,None),
('tencent','operating','working','腾讯支付平台等关联应收款',[3427778,3826908],334,None),
('fufeitong','operating','working','付费通支付平台等关联应收款',[3430770,5467588],334,None),
('prepayments','operating','working','平台预付款',[1357173,1672528],315,None),
('tax_receivable','operating','working','待收回税款',[699033,3024945],315,None),
('deposits','operating','working','租赁及其他押金',[552878,1150725],315,None),
('other_current','operating','working','其余流动资产',[1599341,1486776],315,None),
('related_payable','operating','working','关联方服务应付款',[-801859,-1086540],282,None),
('advances','operating','working','客户预收款及递延收入',[-2947041,-3378789],282,None),
('merchants','operating','working','应付商户结算款',[-91655947,-107407160],282,None),
('merchant_deposits','operating','working','商户保证金',[-16460600,-17708197],282,None),
('ads_payable','operating','working','应付营销推广费用',[-11070464,-10733946],319,None),
('tax_payable','operating','working','应交税费',[-22805311,-27637234],319,None),
('payroll','operating','working','应付薪酬',[-4026851,-4890448],319,None),
('accounts_payable','operating','working','应付供应商账款',[-28280328,-32662965],319,None),
('other_accruals','operating','working','其余应计及流动义务',[-2958877,-5733246],319,None),
('equipment','operating','facilities','平台设备、软件及租赁装修净额',[879327,1306044],315,None),
('intangible','operating','rights','平台无形资产',[19170,15387],282,None),
('rou','operating','rights','办公室及仓库使用权',[5064351,4863332],282,None),
('leases','operating','rights','办公室及仓库经营租赁义务',[-5297543,-5378795],282,'-(流动租赁负债 + 非流动租赁负债)，经营租赁按经营口径保留'),
('deferred_tax_assets','operating','other_operating','递延所得税资产',[15998,171959],282,None),
('deferred_tax_liabilities','operating','other_operating','递延所得税负债',[-106774,-41851],282,None),
('cash','nonoperating','cash','现金及现金等价物',[57768053,108900587],282,None),
('short_deposits','nonoperating','investments','短期定存及持有至到期债券',[210368027,220422862],314,None),
('equities','nonoperating','investments','交易性权益证券',[44479404,66033596],314,None),
('short_afs','nonoperating','investments','一年内可供出售政府债券',[6319014,19599692],314,None),
('other_debt','nonoperating','investments','短期贷款等其他债务投资',[12625411,7351532],314,None),
('long_deposits','nonoperating','investments','长期定存及持有至到期债券',[57309555,70296260],317,None),
('long_afs','nonoperating','investments','长期可供出售政府债券',[23855196,32150125],319,None),
('equity_method','nonoperating','investments','有限合伙基金权益法投资',[1809260,1870268],319,None),
('related_loan','nonoperating','investments','宁波禾信关联贷款',[710632,910632],334,None),
('interest_receivable','nonoperating','other_assets','应收利息',[205041,191568],315,None),
('other_noncurrent','nonoperating','other_assets','其余未细分非流动资产',[433227,391060],317,'其他非流动资产总额 - 长期定存及持有至到期债券 - 长期可供出售债券 - 权益法投资；2024: 83,407,238-57,309,555-23,855,196-1,809,260=433,227千元；2025:104,707,713-70,296,260-32,150,125-1,870,268=391,060千元'),
('bonds','liabilities','financing','到期可转债',[5309597,0],321,None),
]
for order,(id,group,section,label,vals,page,calc) in enumerate(assets,1):
 note={'restricted':'主要为消费者支付、待付商户的监管资金，与商户结算义务配对阅读。','merchants':'含部分服务合同负债，不能将全部余额理解为可自由使用的融资。','other_noncurrent':'附注只披露主要组成；扣除已识别投资后的原口径余额保留，不推定为另一项投资。','equity_method':'账面余额已按权益法计量，不再乘基金持有比例。','related_loan':'借款方受公司高管控制；属对外关联贷款，未并入经营结算应收款。'}.get(id)
 val('asset-object',vals,id=id,group=group,section=section,label=label,order=order,page=page,status='derived' if calc else 'disclosed',calculation=calc,reader_note=note)
 # Working balances and unsegmented investment changes retained as differences, with explicit review limits.
 review='difference_only' if section in ['working','cash','other_operating','other_assets'] else 'partial'
 reason='普通周转或现金余额以两期差额列示；现金流量表另列现金实际流转。' if review=='difference_only' else '核对相关附注及现金流量表，未披露与该对象完全匹配的资本投入、处置和汇率变动完整滚动表；保留真实余额差额，分量可核实的另列。'
 run('movement-review',object=id,period='2025',status=review,basis=reason,source_ids='f2025')
# Relevant business axis, with group total independent.
for id,label,values in [('marketing','在线营销服务及其他',[197934192,217783028]),('transaction','交易服务',[195901905,214062685])]:
 run('business',id=id,label=label,kind='business',order=1 if id=='marketing' else 2)
 val('business-metric',values,business=id,metric='revenue',page=325)
 for metric in ['direct_cost','gross_profit','operating_profit']:
  val('business-metric',[None,None],business=id,metric=metric,page=310,status='missing',basis='年报单一报告分部；仅按服务披露收入，未披露该类服务成本和利润，集团总量独立保留')
# Separate equity contributions from noncash conversion.
val('equity-change',[1263,1384],id='owner_input',label='股份奖励行权形成权益',order=5,page=289)
val('equity-change',[651393,0],id='bond_conversion',label='可转债转股（非现金）',order=6,page=288,basis='2025年报股东权益表第288—289页；2024年转股651,393千元，2025年无转股')
# All operating cash adjustments, grouped by economic meaning, no balance plug.
cf=[
 ('depreciation','设备、软件及无形资产折旧摊销',[708763,601483],None),
 ('rou_amort','使用权资产摊销',[1932124,2398881],None),
 ('share_comp','股份支付非现金费用',[9883564,7936971],None),
 ('investment_adjustments','扣除投资收益、公允价值及权益法收益',[-9661132,-11309120],'2024: -2,827,453-6,816,454-17,225；2025: -774,225-10,405,890-129,005；千元乘1,000'),
 ('other_noncash','信用损失、递延税、汇兑及资产处置调整',[-31930,2100840],'2024:329,902+222,176-587,866+3,858；2025:313,084-181,928+1,966,622+3,062；千元乘1,000'),
 ('working_changes','结算、预付款及经营义务现金变化',[28020045,19967124],'2024:48,814-141,110-782,012+802,431-436,917+16,885,188+13,781,239-418,146-1,879,851+160,409；2025:-1,523,543-2,435,948-3,654,188+431,748+284,681+15,327,685+12,359,644+1,247,597-2,116,609+46,057；千元乘1,000'),
 ('investment_cash','计入经营现金流的短期投资变动',[-21356654,-12600028],None)]
for order,(id,label,values,calc) in enumerate(cf,2):
 val('operating-row',values,module='cash_flow',id=id,label=label,order=order,page=290,status='derived' if calc else 'disclosed',calculation=calc)
for id,label,values,order in [('cash_dividend','向普通股股东支付现金分红',[0,0],1),('cash_repurchase','普通股现金回购',[0,0],2),('other_finance_cash','行权等其他融资现金净流入',[1255,1363],3)]:
 val('operating-row',values,module='owner_flows',id=id,label=label,order=order,page=290,status='derived' if id!='other_finance_cash' else 'disclosed',calculation='现金流量表融资活动无普通股现金分红或普通股回购项目；可转债偿还另列融资债务变动' if id!='other_finance_cash' else None)
# Verified components of physical and lease asset changes; residual remains explicitly unidentified.
for obj,id,label,v,page,calc in [
 ('equipment','depreciation','设备及软件折旧',-597684,315,None),
 ('rou','new_leases','新租赁确认使用权',2279851,317,None),
 ('rou','amortization','使用权摊销',-2398881,290,None),
 ('leases','new_leases','新租赁义务',-2279851,317,None),
 ('leases','cash_settlement','租赁义务现金净减少',2116609,290,None),
 ('bonds','repayment','到期现金偿还',-5228716,290,None),
 ('bonds','translation_residual','期初账面与偿还现金的其余差额',-80881,321,'0-5,309,597+5,228,716=-80,881千元；美元债现金偿还与人民币账面差额，未单独披露汇兑滚动金额，不推定全部为汇兑'),
]:
 run('asset-movement',object=obj,id=id,period='2025',label=label,amount=v*1000,source_id='f2025',page=page,status='derived' if calc else 'disclosed',basis='年报附注或现金流量表匹配分量；人民币千元乘1,000',calculation=calc,order=1 if id in ['depreciation','new_leases','repayment'] else 2)
# Cash balances explained by total cash statement and separate restricted cash difference.
for id,label,v in [('cfo','经营活动',106938690),('cfi','投资活动',-43423236),('cff','融资活动',-5227353),('fx','现金汇率影响',-1751111),('restricted_change','扣除监管受限现金净增加',-5404456)]:
 run('asset-movement',object='cash',id=id,period='2025',label=label,amount=v*1000,source_id='f2025',page=290,status='derived' if id=='restricted_change' else 'disclosed',basis='现金及现金等价物变动：现金流量表总现金变化扣除受限现金变化',calculation='-(73,830,824-68,426,368)千元×1,000' if id=='restricted_change' else None)
run('movement-review',object='cash',period='2025',status='explained',basis='现金流量表经营、投资、融资、汇兑四项，扣受限现金变化，连接非受限现金余额',source_ids='f2025')
for p,opts,rsu in [('2024',390422524,67741348),('2025',355189100,55599296)]:
 run('dilution',id='awards_'+p,label=p+'年末股份奖励潜在交付',outstanding=f'期权{opts:,}股，RSU {rsu:,}股（普通股）；来源f2025第327—328页',terms='一份ADS代表4股普通股。期权加RSU为已授予奖励的毛交付上限；含可用存托行持股结算部分，不等于增发上限或EPS稀释增量，未含尚未授予额度。',maximum_new_shares=opts+rsu)
run('dilution',id='bonds_2024',label='2024年末可转债潜在转换',outstanding='本金738,634,000美元；f2025第320—321页',terms='初始转换率每1,000美元为5.2459 ADS，每ADS 4股；按初始率全部以股票结算计算，特殊事件可调整，现金或混合结算亦可。2025年末债券已全部到期，无余额。',maximum_new_shares=738634*5.2459*4)
notes={
'scope':'以PDD Holdings集团合并报表为完整基底，包含子公司及按合同安排合并的VIE。披露只有一个报告分部；在线营销与交易服务仅拆收入，成本、利润、资产及现金流保留集团口径，不能据此拆出拼多多与Temu各自业绩。未披露少数股东权益或损益，合并总数与归母总数一致。',
'equity':'利润留存是归母权益增长的主要来源；2025年归母利润978亿元，其他综合损失57.1亿元，股份支付增加79.4亿元。两期无普通股现金分红或回购。2024年可转债转股增加权益6.51亿元，属非现金；2025年偿还可转债52.3亿元，减少融资债务。存托行预存股份及奖励结算不重复计作股东现金投入。',
'cash':'2025年归母利润978亿元，经非现金和周转调整得到经营现金流1.07千亿元，扣设备、软件及无形资产现金开支11.5亿元后余额1.06千亿元。该口径已包含短期投资现金流出126亿元及经营租赁付款，不再重复扣租金，也不是历史估值报告的经营企业自由现金流。受限商户结算现金列入经营周转，不能视同可分配现金。',
'ownership':'VIE依据合同经济安排并表，名义持股不用于折算集团资产；关联支付公司与宁波禾信仅按已披露往来或投资保留。未取得可匹配合并组成的非全资项目应占明细，亦无少数股东余额需要扣除。',
}
for id,t in notes.items():run('narrative',id=id,text=t)
print('Rebuilt draft with',len(assets),'asset objects and complete cash/equity bridges.')

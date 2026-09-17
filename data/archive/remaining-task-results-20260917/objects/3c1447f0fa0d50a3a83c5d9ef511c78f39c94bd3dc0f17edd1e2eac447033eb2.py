import json,sys,subprocess,hashlib,shutil
from pathlib import Path
S='.agents/skills/company-two-table/scripts/protocol.py'; D='outputs/draft.json'
shutil.copyfile(D,'outputs/draft-input.json')
x=json.load(open(D));r=x['entities']['root']
x['sources']['yingen_audit']['path']='materials/additional/0-yingen-audit-20251028.pdf'
x['sources']['dividend_2025']['path']='materials/additional/2-dividend-2025.pdf'
fixes=[]
def walk(o,path=''):
 if isinstance(o,dict):
  if o.get('source_id')=='filing_2025' and '2024年报' in o.get('basis',''):
   o['source_id']='filing_2024';fixes.append(path)
  for k,v in o.items():walk(v,path+'/'+k)
 elif isinstance(o,list):
  for i,v in enumerate(o):walk(v,path+'/'+str(i))
walk(x)
for a in r['assets'].values():
 v=a.get('movement_review',{}).get('2024')
 if v and ('2024年报' in v.get('basis','') or a.get('movements',{}).get('2024')):v['source_ids']=['filing_2024']
# Replace aggregate objects with sourced components; original remains in the independent input archive.
for k in ['fixed','otherrec','currentloan','construction_material']:del r['assets'][k]
r['assets']['dividend_due']['label']='合并范围已确认未支付股利'
for p in x['periods']:r['assets']['dividend_due']['evidence'][p]['reader_note']='合并应付股利包含子公司对外部股东应付款；2024年末518万元全部为银根应付中国长城资产管理款，不能视为上市公司尚欠普通股东分红。'
r['narratives'].pop('finalize_outstanding',None)
json.dump(x,open(D,'w'),ensure_ascii=False,indent=2)
# Execute the task protocol for all new data.
def cmd(command,**kw):
 args=[sys.executable,S,command,'--draft',D]
 for k,v in kw.items():
  if v is not None:args+=['--'+k.replace('_','-')+'='+str(v)]
 z=subprocess.run(args,capture_output=True,text=True)
 if z.returncode:raise RuntimeError(str(args)+'\n'+z.stdout+z.stderr)
def asset(e,i,label,section,vals,page,source='filing_2025',status='disclosed',note=None,calc=None):
 group='liabilities' if section in ['financing','shareholder','other_liabilities'] else 'nonoperating' if section in ['cash','investments','other_assets'] else 'operating'
 for p,v in vals.items():cmd('asset-object',entity=e,id=i,label=label,group=group,section=section,period=p,amount=v,status=status,source_id=source,page=page,basis=f'{label}；附注对应期间期末账面金额',reader_note=note,calculation=calc)
def mov(e,obj,i,label,p,v,page,src='filing_2025',status='disclosed',calc=None,note=None):
 if not v:return
 cmd('asset-movement',entity=e,object=obj,id=i,label=label,period=p,amount=v,source_id=src,page=page,basis=f'{p}年度附注滚存；正负号表示账面净值影响',status=status,calculation=calc,reader_note=note)
def row(e,module,i,label,p,v,page,src='yingen_audit',status='disclosed',calc=None,note=None):
 cmd('operating-row',entity=e,module=module,id=i,label=label,period=p,amount=v,status=status,source_id=src,page=page,basis=f'{label}；对应年度法定披露',calculation=calc,reader_note=note)
ids=['fixed_buildings','fixed_machines','fixed_transport','fixed_electronic','fixed_pipe']
labels=['化工厂房及建筑物','天然碱及尿素机器设备','生产运输工具','电子设备及其他','天然碱输送管网']
a=[7266903564.88,10907807274.14,32015337.65,55808971.43,1060725717.60];b=[8616874160.64,10988287376.53,24463561.89,54773459.28,1027932216.02]
for i,l,v,w in zip(ids,labels,a,b):asset('root',i,l,'facilities',{'2024':v,'2025':w},141,note='已扣累计折旧及减值。固定资产合计单独保存于生产性固定资产分类总量的计算依据；租赁使用权另列。')
for p,total,rou in [('2024',19323260865.70,12880504.88),('2025',20712330774.36,10086789.64)]:cmd('section-total',entity='root',section='facilities',period=p,amount=total+rou,status='derived',source_id='filing_2025',page=90,basis='固定资产加使用权资产，独立保存合计核对明细',calculation=f'{total}+{rou}')
m25=[('purchase','购置原值',[29910991.21,19420451.48,4490175.87,4826708.72,0],140),('transfer','在建工程转入',[1836634594.19,1208010071.05,0,5881236.34,7556628.73],140),('class_in','分类调整转入',[0,53945822.01,99115.04,4098723.67,2531786.41],140),('ip_in','出租物业转回原值',[22162896.28,0,0,0,0],140),('disposal','处置报废原值',[0,-6647036.29,-7315071.39,-1125303.82,0],140),('class_out','分类调整转出',[-60326611.73,0,0,-348835.40,0],140),('land_refund','土地补偿退回',[-48238,0,0,0,0],140),('other_out','其他减少原值',[-8602487.70,-190138.74,0,0,0],140),('ip_out','转入出租物业原值',[-1193096.79,0,0,0,0],140),('subs_out','处置子公司转出原值',[-12458234.38,-3227699.73,-1203162.64,-109093.84,0],140),('depr','计提折旧',[-339157748.81,-1057791435.84,-7183180.67,-15366909.51,-42881916.72],140),('class_depr_in','分类转入折旧',[0,0,-21971.32,-272874.73,0],140),('ip_depr','出租物业转回折旧',[-2615436.12,0,0,0,0],140),('disposal_depr','处置转销折旧',[0,5001626.58,4025982.36,1363575.86,0],141),('class_depr_out','分类转出折旧',[0,248388.73,24486,21971.32,0],141),('other_depr_out','其他转销折旧',[745845.78,0,0,0,0],141),('subs_depr','处置子公司转销折旧',[4233538.08,3066314.75,1143004.50,103869.88,0],141),('impair','计提减值',[-127540112.55,-142351846.32,-1611153.51,-109933.46,0],141),('disposal_impair','处置转销减值',[0,834199.73,0,0,0],141),('subs_impair','处置子公司转销减值',[8224696.30,161384.98,0,1352.82,0],141)]
m24=[('purchase','购置原值',[2866250.30,29929256.74,8097635.93,13146131.47,0],162),('transfer','在建工程转入',[430262847.47,2990129977.22,0,3760078.33,0],162),('ip_in','出租物业转回原值',[26646558.32,0,0,0,0],162),('class_in','分类转入',[0,6531597.98,2760988.35,128814.98,0],162),('disposal','处置报废原值',[-30282793.89,-59773467.05,-6638015.80,-1294058.01,0],162),('other_out','其他减少原值',[-356839665.48,-451.20,0,0,-64606.63],162),('ip_out','转入出租物业原值',[-180866450.36,0,0,0,0],162),('class_out','分类转出',[-8588510.38,-3954.80,0,-828936.13,0],162),('depr','计提折旧',[-349296991.20,-944779845.82,-6795536.33,-17570734.73,-42787335.56],162),('ip_depr','出租物业转回折旧',[-7698354.70,0,0,0,0],162),('other_depr','其他增加折旧',[-2659710.38,0,-1961284.29,0,0],162),('disposal_depr','处置转销折旧',[13649223.49,53626547.29,4117357.74,1227415.12,0],162),('ip_depr_out','出租物业转出折旧',[24719829.74,0,0,0,0],162),('other_depr_out','其他减少折旧',[36976875.29,4566708.92,0,54285.75,0],162),('impair','计提减值',[-38219628.76,-1689428.65,0,-1352.82,0],163)]
for p,rows in [('2024',m24),('2025',m25)]:
 for mid,l,vals,pg in rows:
  for obj,v in zip(ids,vals):mov('root',obj,mid,l,p,v,pg,'filing_'+p)
for i in ids:cmd('movement-review',entity='root',object=i,period='2025',status='explained',basis='分类型核对原值、折旧、减值及转入转出；原件整体购置合计少于五类之和9326425.31元，五类明细已完整录入并各自闭合。',source_ids='filing_2025')
# Other receivables preserve gross components and a separate impairment contra-account.
for i,l,v,w in [('rec_current','往来款债权原额',145655948.19,139753935.95),('rec_deposit','保证金及押金原额',2445908.72,3673417.53),('rec_explore','勘探费债权原额',33000000,33000000),('rec_interest','融资利息补差款原额',0,24844372.22),('rec_other','其他债权原额',2883009.56,1700127.67),('rec_impair','其他应收款坏账抵减',-106252956.42,-138829666.11)]:asset('root',i,l,'working',{'2024':v,'2025':w},133 if i=='rec_impair' else 131,note='原额与独立坏账抵减共同组成账面净值；2025绿源水务债权原额1.06亿元，已计提坏账7,610万元。')
asset('root','dividend_receivable','庆源绿色金融应收股利','investments',{'2024':4343065.69,'2025':0},131)
mov('root','rec_impair','provision','计提坏账','2025',-33020728.69,133)
mov('root','rec_impair','writeoff','核销转销坏账准备','2025',444019,133)
for i,l,v,w in [('due_bank','一年内到期银行长期借款',1955312134.32,1028687600.90),('due_pay','一年内到期长期应付款',499807537.54,521917300.27),('due_lease','一年内到期租赁负债',3619355.93,4274572.20)]:asset('root',i,l,'financing',{'2024':v,'2025':w},154)
for i,l,v,w in [('construction_equipment','工程专用设备原额',72754874.80,79148640.27),('construction_raw','工程专用材料',21897575.69,9757054.18),('construction_impair','工程设备减值抵减',-37944927,-66793319.19)]:asset('root',i,l,'projects',{'2024':v,'2025':w},144)
mov('root','construction_impair','impair','减值准备净增加','2025',-28848392.19,144,status='derived',calc='-(66793319.19-37944927.00)',note='附注仅列准备余额，表示净变动，不将其等同于本期计提。设备及材料原额余额变动合计减少575万元，未披露购入和领用滚存。')
# Yingen 2024 standalone operating package, audited full-year only.
ye=[('cash','银行可用存款','cash',819487247.40,56),('restricted','票据和复垦保证金','cash',88309804.54,56),('deposit','质押定期、结构性存款及贷款保证金','cash',545436711.85,66),('ar','天然碱销售应收账款','working',4207198.14,57),('bills','销售银行承兑票据','working',203321731.99,59),('pre','生产采购预付','working',27228583.25,60),('rec','往来及保证金净额','working',2900044.29,65),('raw','天然碱原材料','working',118573828.94,66),('goods','纯碱及小苏打库存','working',110531675.26,66),('shipped','已发运产品','working',21187837.48,66),('turnover','周转材料','working',2292.40,66),('tax_credit','预缴及待抵税款','other_operating',318005655.62,66),('current_rec','一年内收回设备融资租赁款','other_assets',556378.19,66),('long_rec','长期设备融资租赁债权','other_assets',9429384.38,67),('ip','对外出租物业','other_assets',20557432.58,69),('rou','租入房屋使用权','facilities',12597551.35,78),('cip_soda','天然碱纯碱生产线二期','projects',1405985314.56,74),('cip_mine','塔木素矿建工程','projects',194256266.34,74),('cip_water','黄河供水二期','projects',49341300.47,74),('construction','工程物资','projects',26301823.49,73),('pre_equipment','预付工程设备款','projects',653078079.11,85),('pre_land','预付土地款','projects',8815125,85),('land','生产及配套土地使用权','rights',124750594.73,81),('water','天然碱水资源使用权','rights',333170200.82,81),('mine','天然碱采矿权','rights',2398912.63,81),('software','生产管理软件','rights',2511212.82,81),('road','厂区外道路摊余支出','other_operating',250593719.59,82),('fee','银团贷款待摊费用','other_assets',87304380.94,82),('green','厂区绿化摊余支出','other_operating',23165991.37,82),('decoration','装修摊余支出','other_operating',5178645.83,82),('dta','抵销后递延所得税资产','other_operating',15113940.35,84),('ap_equip','工程设备供应商应付款','working',-2338509121.71,86),('ap_raw','原料应付款','working',-201790063.32,86),('ap_other','劳务费用应付款','working',-105667666.07,86),('contract','天然碱客户预付货款','working',-615514672.35,87),('employee','职工薪酬义务','other_operating',-47765107.58,87),('tax','应交所得税及资源等税费','other_operating',-103578144.35,89),('otherpay_deposit','押金及保证金应付款','working',-7576490,90),('otherpay_expense','费用及其他应付款','working',-3030976.78,90),('parent_pay','往来款及其他应付款','working',-350000000,90),('vat','预收货款待转销项税','other_operating',-80016907.41,90),('stloan','生产周转短期借款','financing',840162916.67,86),('notes','银行承兑汇票义务','financing',279007842.77,86),('otherloan','其他借款','financing',1961032.34,90),('due_bank','一年内到期银行贷款及利息','financing',180806562.30,90),('due_lease','一年内到期租赁负债','financing',3585737.84,90),('due_pay','一年内到期长期应付款','financing',196399099.70,90),('ltloan','天然碱项目银行长期借款','financing',3324362157.32,90),('lease','租入房屋长期租金','financing',7474118.56,91),('ltpay','售后回租及采矿权长期付款义务','financing',372890799.46,91),('dividend','应付中国长城资产管理股利','shareholder',5184810.48,89),('dtl','抵销后递延所得税负债','other_liabilities',230654.24,84)]
for i,l,s,v,p in ye:asset('yingen',i,l,s,{'2024':v},p,'yingen_audit',note='2024年末独立资产包合并口径，含与上市公司其他单元往来；2025年5月数据不代替2025年末。')
ya=[3974638629.96,6237435035.20,4432110.57,27024067.67,1060725717.60]
for i,l,v in zip(ids,labels,ya):asset('yingen',i,l,'facilities',{'2024':v},72,'yingen_audit')
yrows=[('purchase','购置原值',[0,863593.81,2480078.41,3233331.93,0],71),('transfer','在建工程转入',[425077719.10,2893232002.29,0,766700.93,0],71),('ip_out','转入出租物业原值',[-22046599.28,0,0,0,0],72),('other_out','其他减少原值',[-259968973.56,-451.20,0,0,-64606.63],72),('depr','计提折旧',[-156010730.64,-328685883.78,-730589.09,-6788272.60,-42787335.56],72),('ip_depr_out','转出出租物业折旧',[1489166.70,0,0,0,0],72),('other_depr_out','其他转出折旧',[10389231.96,0,0,0,0],72)]
for mid,l,vs,pg in yrows:
 for i,v in zip(ids,vs):mov('yingen',i,mid,l,'2024',v,pg,'yingen_audit')
for i,pu,am in [('land',2634214.49,2574696.81),('water',211875000,11552503.26),('mine',0,107010.12),('software',2386749.88,234646.61)]:
 mov('yingen',i,'purchase','购置','2024',pu,80,'yingen_audit');mov('yingen',i,'amort','本期摊销','2024',-am,81,'yingen_audit')
mov('yingen','land','other','其他减少原值','2024',-632900.64,80,'yingen_audit')
for i,pu,am in [('road',259640724.79,9047005.20),('fee',0,12183388.88),('green',32710507.39,9544516.02),('decoration',5891340.94,712695.11)]:
 mov('yingen',i,'addition','本期增加','2024',pu,82,'yingen_audit');mov('yingen',i,'amort','本期摊销','2024',-am,82,'yingen_audit')
mov('yingen','rou','depr','租入房屋折旧','2024',-3435695.79,78,'yingen_audit')
mov('yingen','cip_soda','addition','二期工程投入','2024',1405985314.56,75,'yingen_audit',note='74页余额表将此余额写作一期，75页滚存及集团年报列作二期，采用二期身份。')
asset('yingen','cip_soda_phase1','天然碱纯碱生产线一期（已转固）','projects',{'2024':0},75,'yingen_audit')
mov('yingen','cip_soda_phase1','addition','一期工程新增投入','2024',1240994196.12,75,'yingen_audit')
mov('yingen','cip_soda_phase1','transfer','一期工程转固','2024',-3066643623.72,75,'yingen_audit')
for i,l,vs in [('soda','纯碱',5729844007.75),('bicarbonate','小苏打',449432707.50),('water','供水',2990012.99),('other','其他业务',2166502.83)]:
 cmd('business',entity='yingen',id=i,label=l)
 cmd('business-metric',entity='yingen',business=i,metric='revenue',period='2024',amount=vs,status='disclosed',source_id='yingen_audit',page=93,basis='2024年度产品收入明细；各行合计主体收入')
for i,l,v,pg,status,calc in [('parent_profit','本单元归母净利润',2240549270.85,93,'disclosed',None),('equity_distribution','本单元权益确认利润分配',-602884939.19,93,'disclosed',None),('share_compensation','股份支付净增资本公积',28521514.35,92,'derived','28556033.61-34519.26'),('other_direct_equity_change','安全生产和复垦专项储备净增加',34830871.49,92,'derived','43074730.43-8243858.94'),('parent_equity_change','本单元归母权益年度变动',1701016717.50,92,'derived','2240549270.85-602884939.19+28521514.35+34830871.49')]:cmd('equity-change',entity='yingen',id=i,label=l,period='2024',amount=v,status=status,source_id='yingen_audit',page=pg,basis='本单元合并归母权益滚存，不等于上市公司归母份额',calculation=calc)
json.dump({'source_corrections':fixes},open('outputs/finalize-audit.json','w'),ensure_ascii=False,indent=2)
print('completed protocol input',len(fixes),'source corrections')

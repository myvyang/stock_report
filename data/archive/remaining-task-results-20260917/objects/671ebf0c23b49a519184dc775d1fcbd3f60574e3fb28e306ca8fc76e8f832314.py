import json,sys,subprocess
S='.agents/skills/company-two-table/scripts/protocol.py';D='outputs/draft.json';fixes=[]
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
mov('root','construction_impair','impair','减值准备净增加','2025',-28848392.19,144,status='derived',calc='-(66793319.19-37944927.00)',note='附注仅列准备余额，表示净变动，不将其等同于本期计提。设备及材料原额余额变动合计减少575万元，未披露购入和领用滚存。')
# Yingen 2024 standalone operating package, audited full-year only.
ye=[('cash','银行可用存款','cash',819487247.40,56),('restricted','票据和复垦保证金','cash',88309804.54,56),('deposit','质押定期、结构性存款及贷款保证金','cash',545436711.85,66),('ar','天然碱销售应收账款','working',4207198.14,57),('bills','销售银行承兑票据','working',203321731.99,59),('pre','生产采购预付','working',27228583.25,60),('rec','往来及保证金净额','working',2900044.29,65),('raw','天然碱原材料','working',118573828.94,66),('goods','纯碱及小苏打库存','working',110531675.26,66),('shipped','已发运产品','working',21187837.48,66),('turnover','周转材料','working',2292.40,66),('tax_credit','预缴及待抵税款','other_operating',318005655.62,66),('current_rec','一年内收回设备融资租赁款','other_assets',556378.19,66),('long_rec','长期设备融资租赁债权','other_assets',9429384.38,67),('ip','对外出租物业','other_assets',20557432.58,69),('rou','租入房屋使用权','facilities',12597551.35,78),('cip_soda','天然碱纯碱生产线二期','projects',1405985314.56,74),('cip_mine','塔木素矿建工程','projects',194256266.34,74),('cip_water','黄河供水二期','projects',49341300.47,74),('construction','工程物资','projects',26301823.49,73),('pre_equipment','预付工程设备款','projects',653078079.11,85),('pre_land','预付土地款','projects',8815125,85),('land','生产及配套土地使用权','rights',124750594.73,81),('water','天然碱水资源使用权','rights',333170200.82,81),('mine','天然碱采矿权','rights',2398912.63,81),('software','生产管理软件','rights',2511212.82,81),('road','厂区外道路摊余支出','other_operating',250593719.59,82),('fee','银团贷款待摊费用','other_assets',87304380.94,82),('green','厂区绿化摊余支出','other_operating',23165991.37,82),('decoration','装修摊余支出','other_operating',5178645.83,82),('dta','抵销后递延所得税资产','other_operating',15113940.35,84),('ap_equip','工程设备供应商应付款','working',-2338509121.71,86),('ap_raw','原料应付款','working',-201790063.32,86),('ap_other','劳务费用应付款','working',-105667666.07,86),('contract','天然碱客户预付货款','working',-615514672.35,87),('employee','职工薪酬义务','other_operating',-47765107.58,87),('tax','应交所得税及资源等税费','other_operating',-103578144.35,89),('otherpay_deposit','押金及保证金应付款','working',-7576490,90),('otherpay_expense','费用及其他应付款','working',-3030976.78,90),('parent_pay','往来款及其他应付款','working',-350000000,90),('vat','预收货款待转销项税','other_operating',-80016907.41,90),('stloan','生产周转短期借款','financing',840162916.67,86),('notes','银行承兑汇票义务','financing',279007842.77,86),('otherloan','其他借款','financing',1961032.34,90),('due_bank','一年内到期银行贷款及利息','financing',180806562.30,90),('due_lease','一年内到期租赁负债','financing',3585737.84,90),('due_pay','一年内到期长期应付款','financing',196399099.70,90),('ltloan','天然碱项目银行长期借款','financing',3324362157.32,90),('lease','租入房屋长期租金','financing',7474118.56,91),('ltpay','售后回租及采矿权长期付款义务','financing',372890799.46,91),('dividend','应付中国长城资产管理股利','shareholder',5184810.48,89),('dtl','抵销后递延所得税负债','other_liabilities',230654.24,84)]
for i,l,s,v,p in ye:asset('yingen',i,l,s,{'2024':v},p,'yingen_audit',note='2024年末独立资产包合并口径，含与上市公司其他单元往来；2025年5月数据不代替2025年末。')
ids=['fixed_buildings','fixed_machines','fixed_transport','fixed_electronic','fixed_pipe']
labels=['化工厂房及建筑物','天然碱及尿素机器设备','生产运输工具','电子设备及其他','天然碱输送管网']
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

"""Replay verified facts through the task-local protocol; never serialize result JSON."""
import json,sys,hashlib,contextlib,io
from pathlib import Path
sys.path.insert(0,str(Path('.agents/skills/company-two-table/scripts').resolve()))
import protocol
old=json.load(open('outputs/draft-before-finalize.json'))
D='outputs/draft.json'
def cmd(command,**kw):
 args=['protocol.py',command]
 if command!='init':kw={'draft':D,**kw}
 for k,v in kw.items():
  if v is not None:args+=['--'+k.replace('_','-')+'='+str(v)]
 sys.argv=args
 with contextlib.redirect_stdout(io.StringIO()):protocol.main()
def proof(p,page,basis,calc=None,source=None):
 return dict(period=p,source_id=source or 'filing_'+p,page=page,basis=basis,status='derived' if calc else 'disclosed',calculation=calc)
def asset(id,label,section,vals,page,basis=None,group=None):
 group=group or protocol.SECTION_GROUP[section]
 for p,v in zip(['2024','2025'],vals):
  cmd('asset-object',entity='root',id=id,label=label,group=group,section=section,amount=v,**proof(p,page,basis or label,source='filing_2025'))
 cmd('movement-review',entity='root',object=id,period='2025',status='difference_only' if section not in ['facilities','rights','projects'] else 'not_searched',basis='按2025年报附注比较两期余额；滚存原因另行逐项核查',source_ids='filing_2025')
def mov(obj,p,id,label,v,page):
 cmd('asset-movement',entity='root',object=obj,period=p,id=id,label=label,amount=v,source_id='filing_'+p,page=page,basis=f'{p}年报物理第{page}页附注滚存表：{label}；正负号表示账面净值影响')
def review(obj,p,status,basis):cmd('movement-review',entity='root',object=obj,period=p,status=status,basis=basis,source_ids='filing_'+p)
def row(module,id,label,vals,page,order=9999,kind='line',calc=None,entity='root',source='filing_2025'):
 for p,v in zip(['2024','2025'],vals):
  command='equity-change' if module=='equity' else 'operating-row'
  kw={} if module=='equity' else dict(module=module)
  cmd(command,entity=entity,id=id,label=label,order=order,kind=kind,amount=v,**kw,**proof(p,100 if module=='equity' and page==99 and p=='2024' else page,label,calc,source))
cmd('init',company_code='000683.SZ',company_name='博源化工',periods='2024,2025',currency='CNY',display_scale=1e8,out=D)
for s in old['sources'].values():cmd('source',**{k:s[k] for k in ['id','kind','path','basis','sha256','page_count']})
for id,file in [('yingen_audit','yingen-audit'),('yingen_transaction','yingen-transaction')]:
 path=Path('materials/supplemental/'+file+'.pdf')
 cmd('source',id=id,kind='filing',path=str(path),basis='2025-10-28法定补充披露；审计覆盖2024全年及2025年1—5月，交易公告说明收购安排',sha256=hashlib.sha256(path.read_bytes()).hexdigest(),page_count=len(Path(str(path).replace('.pdf','.txt')).read_text().split('\f'))-1)
cmd('entity',id='root',name='博源化工',code='000683.SZ',scope='上市公司合并总量对照；内嵌经营单元为穿透明细，不可相加',accounting_scope='consolidated')
cmd('presentation',entity='root',mode='split',basis='银根矿业经营阿拉善天然碱资产包，中源化学经营河南及苏尼特天然碱资产包，博大实地经营尿素，均存在重要外部股东；以合并根保留上市公司总量及总部资产债务费用，各单元为穿透明细不得再加至合并根。银根化工、水务等共同服务同一资产包，不逐法人重复展示。')
# Reuse balance totals where not replaced, correct financial evidence pages and reality labels.
replace={'cash','inv','ocurrent','lti','equityinv','cip','intang','otherna','otherp','ap','provision','ltdefer'}
labels={'trade':'银行理财及其收益','ar':'纯碱、小苏打、尿素等客户赊销款','arf':'销售结算持有的银行承兑票据','pre':'化工生产采购预付款','otherrec':'绿源水务往来、勘探费及利息补差等债权（含应收股利）','oneyear':'一年内收取的设备融资租赁款','lrec':'一年后收取的设备融资租赁款','fin':'非上市金融投资（公允价值计量）','ip':'对外出租房屋及土地','fixed':'天然碱、尿素生产装置及厂房、运输工具和管网','rou':'化工业务租入房屋、设备和土地','goodwill':'收购桐柏博源新型化工形成的商誉','dta':'经营亏损、减值及暂时性差异形成的税款抵扣权','stloan':'生产经营及周转银行短期借款','notes':'采购及融资结算银行承兑汇票','tax':'增值税、所得税、资源税等应缴税款','currentloan':'一年内偿付的银行借款、融资租赁及长期应付款','ltloan':'天然碱项目等银行长期借款','lease':'租入厂房、设备及土地的长期租金义务','ltpay':'融资租赁等长期融资付款义务','dtl':'投资公允价值、租赁及加速折旧递延税款','contract':'纯碱、尿素等客户预付货款','emp':'生产及管理人员薪酬和社保义务','other_current_liab':'客户预收货款对应待转销项税','defrev':'政府补助递延确认及售后回租收益'}
for id,a in old['entities']['root']['assets'].items():
 if id in replace:continue
 section=a['section'];group=a['group'];sign=1
 if id in ['tax','contract','emp','other_current_liab','defrev']:
  group='operating';section='working' if id=='contract' else 'other_operating';sign=-1
 for p,v in a['amounts'].items():
  page=90 if group!='liabilities' and id not in ['tax','contract','emp','other_current_liab','defrev'] else 91
  cmd('asset-object',entity='root',id=id,label=labels[id],group=group,section=section,amount=sign*v,**proof(p,page,'合并资产负债表原科目：'+a['label'],source='filing_2025'))
 review(id,'2025','difference_only' if section not in ['facilities','rights'] else 'not_searched','已核对两期法定余额；长期资产滚存另核对附注')
asset('cash_available','可随时支付的库存现金、银行存款及结算资金','cash',[3564320804.88,1273865896.48],167)
asset('cash_restricted','冻结及用途受限的货币资金','cash',[235462827.57,4444866.57],168,'货币资金扣除现金及现金等价物；受限资金附注明细')
asset('bill_deposit','票据保证金及利息（其他流动资产列报）','cash',[944900011.40,744025531.49],135)
asset('tax_credit','预缴及待抵税款和出口退税','other_operating',[426197737.72,572458709.74],136)
asset('prepaid_expense','化工业务短期待摊费用','other_operating',[4652167.48,4405904.61],136)
for id,label,vals in [('raw','化工生产原材料',[394703467.94,306132288.22]),('goods','纯碱、小苏打、尿素等库存商品',[347138461.76,245863539.55]),('turnover','生产周转材料',[9274199.65,9112979.60]),('shipped','已发运尚未确认收入的化工产品',[21236286.73,55373432.99])]:asset(id,label,'working',vals,135)
for id,label,vals in [('mengda','乌审旗蒙大矿业34%权益法投资',[3837462759.26,4827039032.23]),('zhongmei','中煤远兴25%权益法投资',[151457435.64,257185751.80]),('zhonghao','中昊碱业权益法投资',[3619192.87,2976912.63]),('taisheng','泰盛恒矿业权益法投资',[245788251.13,245788251.13]),('env','蒙大能源环保权益法投资',[7304037.65,7627416.95])]:asset(id,label,'investments',vals,137)
for id,label,vals in [('qingyuan','庆源绿色金融股权',[255000000,255000000]),('yulin','中盐榆林盐化股权',[139445764.98,146090200.58]),('northwest','新西北能源股权',[56290864.38,56772621.53]),('water_equity','桐柏绿源水务股权',[3918270.28,3946031.10])]:asset(id,label,'investments',vals,136)
for id,label,vals in [('land','天然碱、尿素生产及配套土地使用权',[764501475.89,944755486.16]),('patent','化工生产专利权',[8170400.62,6359570.38]),('water_right','天然碱项目水资源使用权',[333170200.82,337789268.78]),('mine_right','天然碱等矿产采矿权',[451874838.59,383520445.04]),('software','生产管理软件使用权',[15640303.46,13912432.90])]:asset(id,label,'rights',vals,147)
for id,label,vals in [('cip_soda','阿拉善塔木素纯碱生产线二期工程',[1405985314.56,4434551190.59]),('cip_mine','阿拉善塔木素矿建二期工程',[194256266.34,27097906.42]),('cip_water','黄河供水二期工程',[49341300.47,0]),('cip_well','天然碱井建工程',[20900466.76,10579286.05]),('cip_salt','天然碱伴生盐资源综合利用项目',[0,4782356.78]),('cip_other','其他化工技改工程（扣除停建项目减值）',[57072337.37,8467325.72]),('construction_material','化工建设专用设备与材料',[56707523.49,22112375.26])]:asset(id,label,'projects',vals,143)
for id,label,section,vals in [('pre_house','预付房屋购置款','projects',[23926671,106528701.08]),('pre_equipment','预付化工工程设备款','projects',[844744789.75,358206538.86]),('pre_software','预付生产管理软件款','projects',[0,7506183.35]),('pre_explore','预付探矿权款','projects',[0,2161373.59]),('long_tax_credit','长期预缴税款及待抵扣进项税','other_operating',[504331.85,55630020.62])]:asset(id,label,section,vals,150)
for id,label,vals in [('ap_equipment','化工工程设备供应商应付款',[-2409925350.03,-3038477220.53]),('ap_material','化工原料供应商应付款',[-486212660.46,-712296021.57]),('ap_expense','劳务费用及其他供应商应付款',[-283850870.07,-175796387.51])]:asset(id,label,'working',vals,152)
for id,label,section,vals in [('dividend_due','已确认未支付的普通股股利','shareholder',[5184810.48,171760549.64]),('incentive_obligation','限制性股票回购义务','shareholder',[312768360,85815920]),('land_due','远兴物流危化园区土地款','other_operating',[-175790318.71,-175790318.71]),('other_borrowing','其他应付款中的借款','financing',[1961032.34,1961032.34]),('settlement_due','经营往来及其他应付款','working',[-51642054.25,-79912526.98]),('explore_due','蒙大矿业探矿权价差支付义务','other_liabilities',[0,1889145230])]:asset(id,label,section,vals,153)
asset('litigation','蒙大矿业探矿权诉讼预计支付义务','other_liabilities',[1149035612.59,0],156)
asset('restoration','矿山土地复垦和环境治理义务','other_operating',[-122504574.66,-127260523.42],156)
asset('resettlement','苏尼特停产员工安置义务','other_operating',[0,-78271900],156)
for id,label,vals in [('road','厂区外道路建设摊余支出',[250593719.59,353160101.12]),('syndicated_fee','银团贷款待摊费用',[87304380.94,69119899.18]),('landscape','厂区绿化摊余支出',[23165991.37,40362638.14]),('structures','构筑物及管道摊余支出',[24327348.90,0]),('decoration','厂房办公装修摊余支出',[5178645.83,3778036.74]),('other_deferred','其他化工业务长期摊余支出',[1189308.21,0])]:asset(id,label,'other_operating' if id!='syndicated_fee' else 'other_assets',vals,148)
# Asset rolls: same additive gross/depreciation/impairment path, with source labels.
for p,items in {'2024':[('purchase','购置原值',54039274.44),('transfer','在建工程转入原值',3424152903.02),('ip_in','出租物业转回原值',26646558.32),('class_in','设备分类调整转入原值',9421401.31),('disposal','处置报废原值',-97988334.75),('other_out','附注其他减少原值',-356904723.31),('ip_out','转入出租物业原值',-180866450.36),('class_out','分类调整转出原值',-9421401.31),('depr','当年计提折旧',-1361230443.64),('ip_depr','出租物业转回累计折旧',-7698354.70),('other_depr','其他增加累计折旧',-4620994.67),('disposal_depr','处置报废转销折旧',72620543.64),('ip_depr_out','转入出租物业转销折旧',24719829.74),('other_depr_out','其他减少累计折旧',41597869.96),('impair','当年计提减值',-39910410.23)],'2025':[('purchase','购置原值',58648327.28),('transfer','在建工程转入原值',3048756105),('class_in','分类调整转入原值',60675447.13),('ip_in','出租物业转回原值',22162896.28),('disposal','处置报废原值',-15087411.50),('class_out','分类调整转出原值',-60675447.13),('land_refund','土地补偿款退回',-48238),('other_out','附注其他减少原值',-8792626.44),('ip_out','转入出租物业原值',-1193096.79),('subsidiary_out','处置子公司转出原值',-16998190.59),('depr','计提折旧',-1462381191.55),('class_depr','分类调整转入折旧',-294846.05),('ip_depr','出租物业转入折旧',-2615436.12),('disposal_depr','处置报废转销折旧',10391184.8),('class_depr_out','分类调整转销折旧',294846.05),('other_depr_out','其他减少折旧',745845.78),('subs_depr_out','处置子公司转销折旧',8546727.21),('impair','计提减值',-271613045.84),('disposal_impair','处置转销减值',834199.73),('subs_impair','处置子公司转销减值',8387434.10)]}.items():
 for id,label,v in items:mov('fixed',p,id,label,v,162 if p=='2024' else (141 if 'impair' in id else 140))
 review('fixed',p,'explained','固定资产原值、累计折旧、减值准备使用同一路径逐项加减；分类调整转入转出同时保留且净额为零')
for p,items in {'2024':[('depr','租赁资产折旧',-3469312.59)],'2025':[('new','新增土地租赁',2312542.96),('depr','租入房屋、设备及土地折旧',-4856921.47),('impair','租入设备减值',-249336.73)]}.items():
 for id,label,v in items:mov('rou',p,id,label,v,167 if p=='2024' else 145)
 review('rou',p,'explained','使用权资产原值、折旧及减值滚存已逐项录入')
rights={
'land':[('purchase',292882918.07),('disposal',-84702616.50),('ip_out',-2223014.60),('amort',-31656798.62),('disposal_amort',5854152.02),('ip_amort',101046.12),('impair',-1676.22)],
'patent':[('amort',-1810830.24)],'water_right':[('purchase',21187500),('amort',-16568432.04)],'mine_right':[('other_in',7857008.18),('amort',-76211401.73)],'software':[('purchase',1392346.90),('subs_out',-35000),('other_out',-396121.40),('amort',-2373803.23),('subs_amort',35000),('impair',-350292.83)]}
ml={'purchase':'购置','disposal':'处置原值','ip_out':'转入出租物业原值','amort':'当年摊销','disposal_amort':'处置转销摊销','ip_amort':'转入出租物业转销摊销','impair':'当年减值','other_in':'附注其他增加','subs_out':'处置子公司转出原值','other_out':'附注其他减少原值','subs_amort':'处置子公司转销摊销'}
for obj,items in rights.items():
 for id,v in items:mov(obj,'2025',id,ml[id],v,146 if id not in ['impair','subs_amort','disposal_amort','ip_amort'] else 147)
 review(obj,'2025','explained','逐项核对无形资产附注原值、累计摊销与减值准备，闭合两期净值')
for obj,items in {'cip_soda':[('add',4677021100.44),('fixed',-1547879452.37),('other',-100575772.04)],'cip_mine':[('add',1069467871.39),('fixed',-1231459339.12),('other',-5166892.19)],'cip_water':[('add',73888396.83),('fixed',-123229697.30)]}.items():
 for id,v in items:mov(obj,'2025',id,{'add':'本年工程投入','fixed':'达到使用状态转入固定资产','other':'附注披露其他减少'}[id],v,144)
 review(obj,'2025','explained','重要在建工程本年增加、转固及其他减少逐项目闭合；资本化利息包含在增加金额中，不重复加计')
for obj in ['cip_well','cip_salt','cip_other','construction_material','pre_house','pre_equipment','pre_software','pre_explore']:
 review(obj,'2025','not_disclosed','已查2025年报143—144、150页：仅列该对象期初期末净值，重要项目滚存表未覆盖此对象；不把余额差额作为已知增加或转出，未解释差额保留。工程物资另记录已披露减值；预付设备款减值转销未单独给出完整路径。')
mov('construction_material','2025','impair','工程专用设备新增减值准备',-28848392.19,144)
for id,label,v in [('transfer_in','自用房屋土地转入原值',3416111.39),('transfer_out','转回自用原值',-22162896.28),('depr','计提折旧及摊销',-13924824.33),('transfer_depr','自用土地转入摊销',-101046.12),('transfer_depr_out','转回自用转销折旧',2615436.12),('impair','出租房屋减值',-86416621.27)]:mov('ip','2025',id,label,v,139)
review('ip','2025','explained','出租房屋及土地按原值、累计折旧摊销与减值滚存闭合')
for obj,inc,am in [('road',113117696.05,10551314.52),('syndicated_fee',0,18184481.76),('landscape',36135184.74,18938537.97),('structures',0,24327348.90),('decoration',98712.87,1499321.96),('other_deferred',0,1189308.21)]:
 if inc:mov(obj,'2025','add','本期增加',inc,148)
 mov(obj,'2025','amort','本期摊销',-am,148);review(obj,'2025','explained','长期待摊费用各对象增加与摊销闭合')
for id,c in old['entities']['root']['controls'].items():
 for p,v in c['amounts'].items():cmd('control',entity='root',id=id,amount=v,**proof(p,91,'合并资产负债表净资产控制数',source='filing_2025'))
# Company operations and each actual product/channel, with no allocated tax or cash flows.
cmd('business',entity='root',id='company_total',label='公司合计',kind='total',order=1)
rev=[13263919340.43,12074666694.16];cost=[7836266379.97,8396636272.64]
expenses=[[236319977.41,382304870.55,988792447.29,123945457.01],[245122661.90,278709892.69,822638527.13,97745020.64]]
ops=[]
for i,p in enumerate(['2024','2025']):
 gp=rev[i]-cost[i];pc=-sum(expenses[i]);op=gp+pc;ops.append(op)
 for metric,value,calc in [('revenue',rev[i],None),('direct_cost',-cost[i],None),('gross_profit',gp,'营业收入-营业成本'),('period_cost',pc,'-(税金及附加+销售费用+管理费用+研发费用)，均保留原含折旧口径'),('operating_profit',op,'毛利+期间经营费用；投资、融资及减值等项目另进入利润桥')]:cmd('business-metric',entity='root',business='company_total',metric=metric,amount=value,**proof(p,94,calc or '合并利润表',calc,'filing_2025'))
products=[('soda','纯碱',[8227698531.66,7460411783.53],[4263511732.47,4921355034.75]),('bicarbonate','小苏打',[1922754193.05,1531145141.38],[1026447453.10,931850765.61]),('urea','尿素',[2886757834.86,2895440113.63],[2313533035.10,2388754047.64]),('other_product','其他产品',[171749107.82,139843506.83],[168766477.80,101032664.50]),('other_business','其他业务',[54959673.04,47826148.79],[64007681.29,53643760.14]),('direct','直销（渠道口径）',[4411549636.68,3718063064.49],None),('other_channel','其他销售模式（渠道口径）',[8852369703.75,8356603629.67],None)]
for j,(id,label,rs,cs) in enumerate(products,2):
 cmd('business',entity='root',id=id,label=label,order=j)
 for i,p in enumerate(['2024','2025']):
  for metric,value,calc in [('revenue',rs[i],None)]+([('direct_cost',-cs[i],None),('gross_profit',rs[i]-cs[i],'本业务收入-本业务成本')] if cs else []):
   page=159 if p=='2025' and cs else (181 if p=='2024' and id=='other_product' else (19 if p=='2024' else 20))
   cmd('business-metric',entity='root',business=id,metric=metric,amount=value,**proof(p,page,label+'披露口径',calc))
row('other_profit','business_operating_profit','经营利润',ops,94,1,calc='收入-成本-税金及附加-销售费用-管理费用-研发费用')
for j,(id,label,vals) in enumerate([('finance','融资及汇兑费用',[-373716200.96,-282340637.30]),('grant','政府补助等其他收益',[19691911.57,23527378.29]),('investment','联营及其他投资收益',[463090776.17,596409643.73]),('fair','金融投资公允价值变动',[-72931584.57,-120033600]),('credit','客户及其他债权信用减值',[-23090458.82,-32833647.93]),('impair','生产装置、工程物资等资产减值',[-102416115.44,-397931652.25]),('disposal','资产处置损益',[-4197151.17,-14237025.99]),('outside_income','营业外收入',[21113246.82,13738820.56]),('outside_cost','营业外支出',[-221334906.08,-129799915.07])],2):row('other_profit',id,label,vals,94,j)
for id in ['pretax_profit','income_tax','consolidated_profit','minority_profit','parent_profit']:
 r=old['entities']['root']['other_profit'][id];row('other_profit',id,r['label'],[r['amounts'][p] for p in ['2024','2025']],94,20+['pretax_profit','income_tax','consolidated_profit','minority_profit','parent_profit'].index(id),r['kind'])
for j,(id,r) in enumerate(old['entities']['root']['cash_flow'].items()):
 row('cash_flow',id,r['label'],[r['amounts'][p] for p in ['2024','2025']],167 if id in ['other_cash_adjustment','operating_cash_flow'] else (97 if id in ['asset_spending','free_cash_flow'] else 166),j,r['kind'],calc='经营活动现金净额-购建长期资产支付的现金' if id=='free_cash_flow' else None)
# Equity IDs required by protocol: mutually exclusive categories, no duplicated alias rows.
eq=[('parent_profit','归母净利润',[1811195127.71,942169508.9]),('other_comprehensive_income','归母其他综合收益',[9444766.8,-26762709.17]),('owner_input','限制性股票授予所收股东投入',[28437600,0]),('share_compensation','权益结算股份支付增加',[197241377.60,47770910.69]),('equity_distribution','权益确认的股东利润分配',[-1119243768,-1115621718]),('repurchase','限制性股票注销：股本及溢价减少',[-35504984.01,-74584870]),('minority_transactions','增持银根矿业不丧失控制权的权益减少',[0,-1840715858.71]),('other_direct_equity_change','库存股转销、权益法变动、专项储备及其他直接变动',[118440293.47,133419465.71]),('parent_equity_change','归母权益本期变化',[1010010413.57,-1934325270.58])]
for j,(id,label,vals) in enumerate(eq):
 calc=None
 if id=='other_direct_equity_change':calc='2024:120795240+59755906.25-30335431.69-31775421.09=118440293.47；2025:226952440-93124076.68+83448982.69-24496262.10-(1900077476.91-1840715858.71)=133419465.71；库存股转销以正号记录，抵销已记录注销股本与溢价，剩余包含解除限售义务；其他事项按权益表及附注披露范围保留'
 row('equity',id,label,vals,99,j,'total' if id=='parent_equity_change' else 'line',calc)
# Narratives and explicit evidence coverage will be finalized after independent arithmetic checks.
cmd('narrative',entity='root',id='equity',text='2024年末总股数37.4亿股：授予836万股、取得股东投入2,840万元，注销941万股；2025年末总股数37.2亿股，全年注销2,230万股、未增发。2024、2025年实际支付股权激励回购款分别为3,450万元、7,460万元；无送股、资本公积转增或可转债转股。')
cmd('narrative',entity='root',id='cash',text='2024年净利润28.7亿元，经非现金损益及周转调整形成经营现金净额45.1亿元，扣除现金资本开支13.4亿元后余31.7亿元；2025年净利润14.8亿元，经营现金净额25.6亿元，扣除资本开支33.8亿元后缺口8.24亿元。')
cmd('coverage',entity='root',level='complete',basis='已核对2024、2025年报合并三表、权益表、资产附注及重要非全资子公司信息，补查2025年10月28日银根矿业审计及股权交易公告；细节和剩余缺口在各对象及主体coverage中记录。',source_ids='filing_2024,filing_2025,yingen_audit,yingen_transaction')
print('Protocol rebuild complete')

import json,sys,hashlib,subprocess,re,copy
from pathlib import Path
sys.path.insert(0,'.agents/skills/company-two-table/scripts')
import protocol as P
D=json.load(open('outputs/draft.json'));E=D['entities']['miniso'];PS=['2021FY','2022FY','2023FY','2024FY','2025FY','2025H1','2026H1'];D['periods']=PS;D['precision']=1
urls=json.load(open('outputs/evidence/extra-urls.json'))
def source(k,file,url,basis):
 raw=Path(file).read_bytes();s={'id':k,'url':url,'local_file':file,'sha256':hashlib.sha256(raw).hexdigest(),'unit_scale':1000,'basis':basis+'；原表人民币千元，底稿人民币元'}
 if raw.startswith(b'%PDF'):
  info=subprocess.check_output(['pdfinfo',file],text=True);s.update(kind='filing',path=file,page_count=int(re.search(r'Pages:\s+(\d+)',info).group(1)))
 else:s.update(kind='external',path=url,format='text')
 D['sources'][k]=s
for k,u in urls.items():source(k,'outputs/evidence/'+k+'.txt',u,'公司业绩发布，表列期间按表头读取')
source('h126','outputs/evidence/h126.pdf','https://links.sgx.com/1.0.0/corporate-announcements/U72CBQRWDASDUC64/902968_HKEX%20Ann%20MINISO%20Group%20Interium%20Results%20Annoucement%20June%2030%202026.pdf','港交所格式2026中期业绩公告，SGX发行人同步披露原件，2026-08-28发布')
source('ir22','outputs/evidence/ir22.pdf','https://filecache.investorroom.com/mr5ir_miniso/270/Interim%20Report%202023%20HK.pdf','截至2022-12-31六个月中期报告及2021同期')
source('fiscal22','outputs/evidence/fiscal22.pdf','https://filecache.investorroom.com/mr5ir_miniso/243/Annual%20Report%202022%20HK%EF%BC%88EN%EF%BC%89.pdf','截至2022-06-30财年年报及2021财年同期')
source('prospectus','outputs/evidence/prospectus-finance.pdf','https://www1.hkexnews.hk/listedco/listconews/sehk/2022/0630/2022063000039.pdf','2022香港招股书，附录IA会计师报告')
for k,u in [('ar2025','https://filecache.investorroom.com/mr5irasia_miniso_tc/202/Annual%20Report%202025%20HK.pdf'),('ar2024','https://www.hkexnews.hk/listedco/listconews/sehk/2025/0424/2025042400855.pdf'),('ar2023','https://ir.miniso.com/Interim-Annual-Reports')]:source(k,D['sources'][k]['path'],u,'本地香港年报原件；2023文件为2023年下半年过渡报告并列2023年六月财年')
source('index','outputs/evidence/index.txt','https://ir.miniso.com/Interim-Annual-Reports','2026-09-16核对发行人报告目录，最新为2026中期业绩公告')
D['disclosure_resolution'].update(index_url='https://ir.miniso.com/Interim-Annual-Reports',basis='发行人目录列2026-08-28中期业绩公告；SGX发行人目录同日登记截至2026-06-30业绩，附港交所格式公告原件；截至研究日未列2026正式中报。',history_basis='覆盖2021至2025五个完整自然年。2021—2023全年为公司因财年改期而提供的未经审计十二个月比较口径，2024—2025为十二月结算的审计财年；明确不以2023下半年过渡报告冒充全年。')
for p in PS:
 y=p[:4];h='H1' in p
 D['period_metadata'][p]={'start':y+'-01-01','end':y+('-06-30' if h else '-12-31'),'balance_date':y+('-06-30' if h else '-12-31'),'kind':'ytd' if h else 'annual','source_id':'h126' if h else 'ar2025','basis':'六个月累计，未经审计' if h else ('完整自然年，公司补充未经审计十二个月比较数' if int(y)<2024 else '完整审计财年'),'asset_compare':('2024FY' if p=='2025H1' else '2025FY' if p=='2026H1' else str(int(y)-1)+'FY' if int(y)>2021 else None),'operating_compare':('2025H1' if p=='2026H1' else str(int(y)-1)+'FY' if not h and int(y)>2021 else None),'asset_visible':p!='2025H1','operating_visible':True}
def page(k,needle):
 f={'prospectus':'prospectus-finance','fiscal22':'fiscal22','ir22':'ir22'}.get(k,k)
 txt=Path(f'outputs/evidence/{f}-layout.txt').read_text();pos=txt.find(needle)
 assert pos>=0,(k,needle)
 return txt[:pos].count('\f')+1
def ev(src,pg,basis,status=None,calc=None,note=None):
 z={'status':status or ('disclosed' if D['sources'][src]['kind']=='filing' else 'external'),'source_id':src,'page':pg,'basis':basis,'calculation':calc}
 if pg is None:z['locator']=basis
 if note:z['reader_note']=note
 return z
def put(store,key,label,p,val,src,pg,basis,kind='line',order=0,calc=None,note=None):
 row=store.setdefault(key,{'id':key,'label':label,'kind':kind,'order':order,'amounts':{},'evidence':{}})
 proof=ev(src,pg,basis,'missing' if val is None else 'derived' if calc else None,calc,note)
 P.set_period_value(row,p,None if val is None else val*1000,proof);return row
# Independent statement totals, corrected sourcing.
for store in [E['summary'],E['controls']]:
 for key,row in store.items():
  for p in PS:
   if p=='2025H1':continue
   src,pg=('ar2024',8) if p in ['2021FY','2022FY'] else ('ar2024',101) if p=='2023FY' else ('h126',32 if key in ['total_assets','current_assets','long_assets'] else 33) if p=='2026H1' else ('ar2025',107 if key in ['total_assets','current_assets','long_assets','parent_equity','consolidated_equity','minority_equity'] else 108)
   row['evidence'][p]=ev(src,pg,'合并财务状况表/独立五年摘要控制数；负债按正数保存')
for key,v in [('consolidated_equity',10898919),('minority_equity',46812),('parent_equity',10852107)]:put(E['controls'],key,key,'2025H1',v,'h126',34,'权益变动表2025年6月30日余额',kind='total')
# Asset balances. Complete signed decomposition: all numbers RMB thousand.
B={
'2021FY':[376021,2391803,53319,19640,161018,0,203390,208289,1360994,1113506,5151456,7347,0,0,0,53572+276537,6369+5182,3189086,411304+268425,16729+5980,81822,0,0],
'2022FY':[467718,2337100,33382,20860,165642,0,28717+200269,809641,1474792,1108501,5186601,28609,135548,0,0,49895+337214,6997,2939852,408162+266487,11741+6533,161472,0,0],
'2023FY':[769306,2900860,19554,21643,104130,90603,135796,252866,1922241,1518357,6415441,7970,310759,0,15783,40954+324028,6533+726,3389826+12411,797986+447319,29229+6644,238436,0,0],
'2024FY':[1436939,4172083,8802,21418,181948,123399,341288,100000,2750389,2207013,6328121,1026,409135,0,38567,35145+323292,4310+566955,3943988+59842,1903137+635357,34983+5376,252221,0,0],
'2025FY':[2109385,5121039,94951,223187,288679,201727,247511,0,3691238,3307129,6817129,54229,216567,774103,5486648,22418+388746,5415416+1751018,4516491+72586,2713798+950784,33053+965,291245,1184050,573681],
'2026H1':[2583756,5959936,225543,210946,320700,479160,292140,100351,3544387,3453949,7046857,5931,241074,321925,5555912,24362+427640,6287885+2352982,4428106+79802,3463573+1114196,32570+965,247692,858687,602657]}
items=[('ppe','门店装修、设备、公寓及总部在建工程','operating','facilities',1),('rou','门店仓库租赁使用权及总部土地','operating','rights',1),('intangible','软件及特许经营等无形资产','operating','rights',1),('goodwill','海外收购形成的商誉','operating','other_operating',1),('dta','递延所得税资产','operating','other_operating',1),('invest_long','非上市基金等非流动投资','nonoperating','investments',1),('recv_long','长期经营按金、预付款及应收款','operating','working',1),('invest_short','短期理财产品','nonoperating','investments',1),('inventory','生活日用品及潮玩库存','operating','working',1),('recv','加盟商、经销商应收及经营预付款','operating','working',1),('cash','现金及现金等价物','nonoperating','cash',1),('restricted','受限现金及质押存款','nonoperating','cash',1),('deposit','定期存款（含非流动）','nonoperating','cash',1),('derivative_asset','股价挂钩下限看涨期权等衍生资产','nonoperating','investments',1),('associate','永辉及其他权益法投资（已应占）','nonoperating','investments',1),('contract','加盟费及货款预收合同义务','operating','working',-1),('loans','银行借款及股票挂钩证券本金负债','liabilities','financing',1),('payables','供应商货款、加盟商保证金及其他应付款','operating','working',-1),('lease_liab','门店及仓库租赁负债','liabilities','financing',1),('deferred','递延政府补助等','operating','other_operating',-1),('tax','应交所得税','operating','other_operating',-1),('derivative_liab','股价挂钩证券衍生负债','liabilities','financing',1),('redemption','TOP TOY优先股赎回负债','liabilities','shareholder',1)]
E['assets']={};E['section_totals']={}
for p,vals in B.items():
 src,pg=('dec21',None) if p=='2021FY' else ('dec22',None) if p=='2022FY' else ('ar2024',101) if p=='2023FY' else ('h126',32) if p=='2026H1' else ('ar2025',107)
 for i,(key,label,group,section,sign) in enumerate(items):
  row=put(E['assets'],key,label,p,vals[i]*sign,src,pg,'合并财务状况表资产/负债完整组成；流动及非流动同名项目合计',order=i,calc='流动+非流动，同属经营义务乘-1' if key in ['loans','lease_liab','contract','payables','deferred','deposit','tax'] else None)
  row.update(group=group,section=section,movements={})
# Reclassify share repurchase prepayments out of operating receivables.
repay={'2021FY':13042,'2022FY':3085,'2023FY':91017,'2024FY':42532,'2025FY':56530,'2026H1':71139}
# 2023 and 2024 notes need independently verified amounts; leave undivided historical receivables until verified.
for p in B:
 amount=repay[p] if p in ['2021FY','2022FY','2025FY','2026H1'] else 0
 src='ir22' if p in ['2021FY','2022FY'] else 'h126' if p=='2026H1' else 'ar2025'
 pg=40 if src=='ir22' else 46 if src=='h126' else 189
 if amount:
  E['assets']['recv']['amounts'][p]-=amount*1000
  E['assets']['recv']['evidence'][p].update(status='derived',calculation=f'应收原表金额-{amount}千元回购预付款')
 r=put(E['assets'],'repurchase_prepaid','回购预付款（尚未转为权益扣减）',p,amount,src,pg,'回购预付款单列非经营资产；2023—2024暂并入应收，见共同边界',calc='应收款项附注明细重分类' if amount else '本行历史未分拆金额为0；不代表原报表无预付回购款')
 r.update(group='nonoperating',section='other_assets',movements={})
# Source-boundary notes, no invented 100% attribution for unmatched non-wholly owned pools.
for p in B:
 E['assets']['associate'].setdefault('attribution',{})[p]={'ratio':1,'basis':'权益法账面金额已经反映本集团所持权益，不再乘永辉29.4%；全集团未匹配非控股权益在剩余归属调整统一扣除。'}
 for key in ['ppe','rou']:
  E['assets'][key]['evidence'][p]['reader_note']='总部在建工程包含于设备总额：2023年3.55亿元、2024年6.30亿元、2025年10.1亿元；半年公告未分拆。使用权包含总部土地和门店租赁；不将加盟商自有门店资产并入。'
# Annual and interim income totals.
R=[10128707,9925619,13838797,16994025,21443827,9393112,11498901];G=[2856884,3464079,5698431,7637060,9648119,4156918,5093676];O=[817831,1370150,2819648,3315789,3303123,1545949,1639910]
N=[564738,1065036,2273995,2635428,1209814,905990,956591];T=[817716,1442266,2980947,3347532,1913338,1194191,1296990];NP=[573626,1065481,2253241,2617560,1205045,906030,961551]
E['businesses']={};E['other_profit']={};E['cash_flow']={};E['owner_flows']={};E['equity_changes']={}
E['businesses']['company_total']={'id':'company_total','label':'合并业务总量','kind':'total','order':99,'metrics':{}}
for i,p in enumerate(PS):
 src,pg=('ar2025',11) if i<2 else ('ar2024',6) if i==2 else ('h126',30) if 'H1' in p else ('ar2025',105)
 for key,label,v in [('revenue','收入',R[i]),('direct_cost','产品及服务成本',G[i]-R[i]),('gross_profit','毛利',G[i]),('period_cost','期间费用及其他经营损益净额',O[i]-G[i]),('operating_profit','经营利润',O[i])]:
  put(E['businesses']['company_total']['metrics'],key,label,p,v,src,pg,'公司完整自然年补充摘要或合并损益表',kind='subtotal' if key in ['gross_profit','operating_profit'] else 'line',calc='毛利-收入' if key=='direct_cost' else '经营利润-毛利（含其他经营收益，不等同纯费用）' if key=='period_cost' else None)
 for key,label,v,kind,order in [('business_operating_profit','经营利润',O[i],'subtotal',0),('operating_to_pretax','经营利润以外损益（早期汇总）',T[i]-O[i],'line',1),('pretax_profit','税前利润',T[i],'subtotal',10),('income_tax','所得税费用',N[i]-T[i],'line',11),('consolidated_profit','合并净利润',N[i],'subtotal',12),('minority_profit','非控股损益归属调整',NP[i]-N[i],'line',13),('parent_profit','归母净利润',NP[i],'total',14)]:
  s,g=src,pg;calc=None
  if i<2 and key not in ['business_operating_profit','parent_profit']:
   s,g='prospectus',page('prospectus','CONSOLIDATED STATEMENTS OF CASH FLOWS');calc='2021自然年：2021六月财年-2020下半年+2021下半年；2022自然年：2022六月财年-2021下半年+2022下半年。合并利润分别 -1429447+1655567+338618=564738；639743-338618+763911=1065036（千元）。所得税分别 -213255+91615-131338；-267070+131338-241498。来源：prospectus/fiscal22/ir22/dec22。'
  if key=='operating_to_pretax':calc='税前利润-经营利润'
  if key=='minority_profit':calc=f'{NP[i]}-{N[i]} 千元，负数表示扣除少数利润'
  put(E['other_profit'],key,label,p,v,s,g,'合并损益表及早期自然年桥接',kind,order,calc)
# Disaggregate material financing and investment effects from 2024 onward; zero the old combined row.
finance={'2024FY':[118672,-92915,5986,0,0],'2025FY':[104421,-430930,-834453,-158491,-70332],'2025H1':[65836,-194236,-138946,0,-84412],'2026H1':[32749,-244722,57757,-47368,-141336]}
for p,vals in finance.items():
 E['other_profit']['operating_to_pretax']['amounts'][p]=0
 E['other_profit']['operating_to_pretax']['evidence'][p]=ev('h126' if 'H1' in p else 'ar2025',30 if 'H1' in p else 105,'本期在下列投资、融资行完整展开','derived','汇总行置0以避免重复加总')
for j,(key,label) in enumerate([('finance_income','存款等财务收入'),('finance_cost','借款、证券及租赁利息'),('associate_result','权益法投资损益（已应占）'),('redemption_fv','TOP TOY优先股赎回负债重估'),('derivative_result','股价挂钩衍生重估及发行费用')]):
 for p in PS:put(E['other_profit'],key,label,p,finance[p][j] if p in finance else 0,'h126' if 'H1' in p else 'ar2025',30 if 'H1' in p else 105,'2021—2023已纳入早期损益汇总，零表示不重复展示；2024起为独立披露',order=2+j,calc=None if p in finance else '本期在早期汇总行列示，明细不重复相加')
# Four mutually exclusive segment axis, external sales excludes all internal sales.
SEG={'2024FY':[[9328231,6674334,983525,7935],[1728123,1492626,97133,-2093]],'2025FY':[[10896147,8628754,1915618,3308],[1919684,1510383,-106156,-20788]],'2025H1':[[5114987,3534017,742058,2050],[927721,583991,51027,-16790]],'2026H1':[[6453955,4059270,984618,1058],[1227675,490984,-72340,-6409]]}
for j,(key,label) in enumerate([('mainland','MINISO中国内地'),('overseas','MINISO海外'),('toptoy','TOP TOY潮玩'),('unallocated','未分配及其他')]):
 E['businesses'][key]={'id':key,'label':label,'kind':'business','order':j,'metrics':{}}
 for p in PS:
  for m,l,idx in [('revenue','外部收入',0),('operating_profit','经营利润',1)]:put(E['businesses'][key]['metrics'],m,l,p,SEG[p][idx][j] if p in SEG else None,'h126' if 'H1' in p else 'ar2025',38+(p=='2026H1') if 'H1' in p else 156+(p=='2025FY'),'分部附注采用外部收入；2021—2023无当前地区分部同口径成本利润重列，保留合并总量',kind='subtotal' if idx else 'line',note='分部未单独披露可与外部收入匹配的销售成本及毛利，不按收入比例分摊合并成本。')
# Cash flows, unified capex includes land use right; proceeds separate.
CF=[916320-806423+731741,1406262-731741+433256,1666030-433256+1097541,2168334,2577891,1014223,1475401]
CAP=[180279-29108+228585+891428,290108-228585+78032+944099-891428,174147-78032+264766,762538,997651,434774,724622]
SALE=[4323-3324,351+1637,5224-1637+427,12446,55684,18301,44263]
LEASE=[215762-140082+163716,317017-163716+170258,346008-170258+236519,725075,897480,395762,551492]
DA=[None,None,464245,808694,1206305,554016,739113]
SBC=[115342,59015,82734,85184,367869,40586,123723]
for i,p in enumerate(PS):
 src,pg=('prospectus',page('prospectus','CONSOLIDATED STATEMENTS OF CASH FLOWS')) if i==0 else ('fiscal22',64) if i==1 else ('ar2023',103) if i==2 else ('h126',36) if 'H1' in p else ('ar2025',111)
 calc='2021:六月财年-2020下半年+2021下半年；2022:六月财年-2021下半年+2022下半年；2023:六月财年-2022下半年+2023下半年；参见prospectus/fiscal22/ir22/ar2023现金流表' if i<3 else None
 # Unbundle independently disclosed D&A and SBC; net residual explicitly aggregates tax and working-capital items.
 da=DA[i] or 0
 rows=[('net_profit','合并净利润',N[i],'subtotal'),('depreciation','折旧摊销加回（早期包含在净调整）',da,'line'),('share_based','股份支付加回',SBC[i],'line'),('cash_adjustments','其他非现金、税款及营运资金净调整',CF[i]-N[i]-da-SBC[i],'line'),('operating_cash_flow','经营活动现金流',CF[i],'subtotal'),('asset_spending','购建设备、无形资产及土地现金支出',-CAP[i],'line'),('asset_disposals','处置设备及无形资产现金回收',SALE[i],'line'),('free_cash_flow','资本开支后自由现金余额（租赁付款前）',CF[i]-CAP[i]+SALE[i],'total'),('lease_cash','备查：租赁本金及利息付款',-LEASE[i],'subtotal'),('after_lease_cash','扣租赁付款后现金余额',CF[i]-CAP[i]+SALE[i]-LEASE[i],'total')]
 for j,(key,label,v,kind) in enumerate(rows):
  c=calc
  if key=='net_profit':c='与合并净利润一致'
  if key=='cash_adjustments':c=f'{CF[i]}-{N[i]}-{da}-{SBC[i]}（千元）；由独立经营现金流总额扣除已列分量，非周转单项估计'
  if key in ['free_cash_flow','after_lease_cash']:c='经营现金流-购建现金支出+处置回收'+('-租赁现金付款' if key=='after_lease_cash' else '')
  if key=='depreciation' and DA[i] is None:c='早期全年折旧未单列，净调整已包含，零表示不另加回'
  put(E['cash_flow'],key,label,p,v,src,pg,'统一自然年现金流；投资收购和金融产品买卖不属于维护/扩张资本开支',kind,j,c)
# Equity bridge with each period's actual opening and independently reconciled changes.
OPEN=[6324690,6736339,7807425,9168195,10314974,10314974,10618763]
OCI=[41253,13339,21662,18273,5483,11371,-67323]
DIV=[-306255,-370787,-923664,-1244251,-1357748,-726875,-792163]
BUY=[-12604,-102267,-73560,-330221,-549237,-344490,-517593]
INPUT=[287,408514,357,649,303,101,136]
MINOR=[0,-2209,0,-415,-18443,0,-15711]
OTHER=[0,0,0,0,650711-194,650711-301,0]
for i,p in enumerate(PS):
 src,pg=('prospectus',page('prospectus','Balance at December 31, 2020 (unaudited)')) if i==0 else ('ir22',38) if i==1 else ('ar2023',101) if i==2 else ('h126',34+(p=='2026H1')) if 'H1' in p else ('ar2025',109+(p=='2025FY'))
 close=E['controls']['parent_equity']['amounts'][p]/1000
 rows=[('opening_parent_equity','期初归母净资产',OPEN[i],'total'),('parent_profit','归母净利润',NP[i],'line'),('other_comprehensive_income','归母其他综合收益',OCI[i],'line'),('owner_input','股东投入及激励行权',INPUT[i],'line'),('share_compensation','权益结算股份支付',SBC[i],'line'),('equity_distribution','确认分配股息',DIV[i],'line'),('repurchase','回购权益净扣减（注销不重复扣）',BUY[i],'line'),('minority_transactions','购买非控股权益的归母变动',MINOR[i],'line'),('other_direct_equity_change','上限认股权证及其他直接权益变化',OTHER[i],'line'),('parent_equity_change','归母权益本期变化',close-OPEN[i],'total')]
 for j,(key,label,v,kind) in enumerate(rows):put(E['equity_changes'],key,label,p,v,src,pg,'权益变动表；早期全年=六月财年-上年下半年+本年下半年，2023同理；期初取各期间真实起点',kind,j,calc='期末归母权益-本期间期初' if key=='parent_equity_change' else '同口径上下半年分量相加，来源prospectus/ir22/ar2023' if i<3 else None)
 # payments differ from share equity charge
 cashbuy=[-12604,-(82160-12604+32711),-73560,-313416,-535249,-303091,-532202][i]
 for j,(key,label,v) in enumerate([('dividend_paid','支付母公司股东股息',DIV[i]),('repurchase_paid','支付回购股份款',cashbuy),('subscription_cash','股东认购及行权现金', [463,493+469683-42616-19046,359,649,303,101,136][i])]):put(E['owner_flows'],key,label,p,v,src,pg,'现金流量表实际付款；回购预付及结算时差不等于本期库存股确认额',order=j,calc='自然年衔接' if i<3 else None)
# Movements for disclosed asset rollforwards and ordinary working balances.
def movement(key,p,parts,src,pg,basis):
 a=E['assets'][key];a.setdefault('movements',{})[p]={}
 for j,(label,v) in enumerate(parts):put(a['movements'][p],f'm{j}',label,p,v,src,pg,basis,order=j,calc='有符号滚存分量' if '其他' in label or '差额' in label else None)
for p,parts in {'2024FY':[('资本添置',846251),('折旧',-157214),('减值',-8846),('处置账面净值',-34538+17896+1662),('汇率及其他',7284-4847-15)],'2025FY':[('资本添置',1009194),('收购带入',20824),('折旧',-270000),('减值',-35499),('处置账面净值',-74651+17490+8752),('汇率及其他',-9686+4699+1323)]}.items():movement('ppe',p,parts,'ar2025',179,'物业设备附注11滚存，含在建工程；现金资本投入与应计新增并不相同')
for p,parts in {'2024FY':[('新增租赁使用权',2093794),('折旧摊销',-684462),('终止确认净额',-378482+237722),('汇率及其他',3820-1169)],'2025FY':[('新增租赁使用权',2111226),('折旧摊销',-971471),('减值',-112),('终止确认净额',-434893+275526),('汇率及其他',-35394+4074)]}.items():movement('rou',p,parts,'ar2025',181,'使用权附注12逐项净额滚存')
for key in E['assets']:
 for p in B:
  prev=D['period_metadata'][p]['asset_compare']
  if prev in B and p not in E['assets'][key].get('movements',{}):
   old=E['assets'][key]['amounts'][prev]/1000;new=E['assets'][key]['amounts'][p]/1000
   movement(key,p,[('本期余额净变动（未拆原因）',new-old)],E['assets'][key]['evidence'][p]['source_id'],E['assets'][key]['evidence'][p].get('page'),'仅期末减期初；不将余额增加误称资本支出，半年未披露细项滚存')
# Hidden interim assets: preserve null rather than synthesize a balance sheet.
for row in list(E['assets'].values())+list(E['summary'].values()):
 row['amounts']['2025H1']=None;row['evidence']['2025H1']={'status':'not_applicable','basis':'仅作经营同比及权益桥的累计期间，不重复展开资产表'}
for section in P.SECTION_GROUP:
 objs=[r for r in E['assets'].values() if r['section']==section]
 if not objs:continue
 for p in PS:
  if p=='2025H1':v=None
  else:v=sum(o['amounts'][p] for o in objs)/1000
  put(E['section_totals'],section,dict(P.GROUPS[P.SECTION_GROUP[section]][1])[section],p,v,'h126' if 'H1' in p else 'ar2025',32 if 'H1' in p else 107,'本分类所列明细的完整有符号加总',kind='subtotal',calc='sum(全部已列明细)')
E['narratives']={
'scope':'金额为人民币，阅读数以亿元、三位有效数字理解。2021—2023为公司补充的未经审计完整自然年，2024—2025为审计财年；2025H1和2026H1均为1—6月累计未经审计。2023过渡报告的六个月数只用于衔接。资产均取各期末。合并资产尚不能按各非全资子公司逐项匹配内部抵销和有效经济权益，故保留合并组成并以剩余少数权益调整连接归母，绝不把缺少比例理解为100%归母；权益法金额已应占。',
'business':'主营通过加盟商供货、海外直营及经销销售生活日用品，TOP TOY经营潮玩。分部主轴为MINISO内地、海外、TOP TOY及未分配，外部收入可加总。2026H1收入115亿元，同比增长22.4%，归母利润9.62亿元，同比增长6.13%；海外直营扩张增加租赁及人员成本。TOP TOY经营亏损0.723亿元，优先股重估另减0.474亿元。2025年利润下滑受永辉权益法亏损及融资、衍生重估影响，不能直接归因于主营销售下滑。',
'assets':'2026年6月底权益法投资55.6亿元，其中永辉按29.4%权益法入账，不以市值替代账面。使用权59.6亿元及租赁负债45.8亿元体现海外直营扩张。总部在建工程已包含于物业设备总额；未再重复列一份在建项目。2023—2024应收款中的回购预付款仍暂含在原应收分类，底层总量不变。受限现金不能视为可自由分配资金。',
'cash':'2026H1经营现金14.8亿元，购建支出7.25亿元、处置回收0.443亿元，资本开支后余额7.95亿元；再扣租赁付款5.51亿元为2.44亿元。自由现金不等同现金增减，未扣金融投资、收购、借贷及股东分配。其他净调整是独立经营现金总额减已列利润和非现金分量；不冒充逐项周转解释。2021购地8.91亿元计入资本开支。',
'equity':'2026H1归母权益从106亿元降至103亿元；归母利润9.62亿元，其他综合损失0.673亿元，股息7.92亿元，回购权益扣减5.18亿元，股份支付1.24亿元。实际回购付款5.32亿元另列，注销仅内部转销不重复扣减。发行在外普通股由12.2亿降至12.0亿，库存股0.385亿；1 ADS代表4股。潜在稀释与已发行股数分开。',
}
E['coverage']={'level':'partial','basis':'五个自然年及最新半年和可比同期总量完整；资产分类完整闭合，权益与现金桥完整。早期当前地区分部利润未追溯披露，非全资子公司逐项归属未取得抵销后映射，故保留总量与少数权益剩余调整。','source_ids':list(D['sources'])}
E['dilution']={'upper_warrant':{'id':'upper_warrant','label':'上限认股权证潜在新股（2026年4月披露）','outstanding':'股票挂钩证券本身为现金结算；上限认股权证可交付新普通股','terms':'2025年报报告页30：末期股息调整后最多70,042,085股、上限行使价HK$96.8；未来股息可再调整。本数为2026年4月披露快照，非当前摊薄EPS分母。1 ADS=4股。','maximum_new_shares':70042085}}
P.save('outputs/draft.json',D)
print('saved',len(E['assets']),'asset rows',len(D['sources']),'sources')

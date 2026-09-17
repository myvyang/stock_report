import sys,json,copy,hashlib,re
from pathlib import Path
sys.path.insert(0,'.agents/skills/company-two-table/scripts')
import protocol as P
D=P.draft('outputs/draft.json'); E=D['entities']['pdd']; periods=D['periods']
Path('outputs/draft-before-finalize.json').write_text(json.dumps(D,ensure_ascii=False,indent=2))
# Use protocol's typed row builder and period setter; retain source amounts in CNY.
def put(bucket,id,p,v,label=None,kind='line',order=0,source=None,page=None,calc=None,basis=None,**extra):
    row=bucket.setdefault(id,{'id':id,'label':label or id,'kind':kind,'order':order,'amounts':{},'evidence':{}})
    P.require_period(D,p)
    source=source or ('q'+p[:4] if 'H1' in p else 'f2023')
    proof={'status':'missing' if v is None else 'derived' if calc else 'disclosed','source_id':source,'page':page or (4 if 'H1' in p else 261),'basis':basis or ('原表人民币百万元乘1,000,000' if p=='2026H1' else '原表人民币千元乘1,000'),'calculation':calc,**extra}
    P.set_period_value(row,p,None if v is None else v*(1000000 if p=='2026H1' else 1000),proof)
    return row

def asset(id,p,v,label=None,section=None,**kw):
    r=put(E['assets'],id,p,v,label,**kw)
    if section:r.update(section=section,group=P.SECTION_GROUP[section])
    return r
# Original balance-sheet units. Full disclosed categories; no interim allocation from annual proportions.
cols=['cash','restricted','payment','short_investments_total','related_receivables_total','prepaid_total','equipment','intangible','rou','deferred_tax_assets','noncurrent_total','related_payable','advances','merchants','accrued_total','merchant_deposits','bonds','leases','deferred_tax_liabilities','other_long_liabilities']
bs={
'2021':[6426715,59617256,673737,86516618,4250155,3424687,2203323,701220,938537,31504,16425966,-1963007,-1166764,-62509714,-14085513,-13577552,11788907,-971427,-31291,-996],
'2022':[34326192,57974225,587696,115112554,6318830,2298379,1044847,134002,1416081,1045030,16862117,-1676391,-1389655,-63316695,-20960723,-15058229,15461506,-1472818,-13025,0],
'2023':[59794469,61985436,3914117,157415365,7428070,4213015,979597,21148,4104889,270738,47951276,-1238776,-2144610,-74997252,-55351399,-16878746,5880093,-4285808,-59829,0],
'2025H1':[63222442,66677640,6007506,323908642,8685737,7540578,843211,17301,5208930,73303,84971006,-1160511,-3601464,-95521629,-76838168,-17137378,5287585,-5675735,-70170,0],
'2026H1':[128918,77274,6079,327496,8432,8581,4752,14,4316,1162,96383,-1266,-3641,-109924,-76883,-18545,0,-4844,None,-517]}
newmeta={'short_investments_total':('短期存款及金融投资（合并披露）','investments'), 'related_receivables_total':('关联方应收款（合并披露）','working'),'prepaid_total':('预付款及其他流动资产（合并披露）','working'),'accrued_total':('应计费用及其他经营义务（合并披露）','working'),'noncurrent_total':('其他非流动资产（含长期金融投资）','other_assets'),'other_long_liabilities':('其他非流动义务（披露汇总）','other_operating')}
for p,vals in bs.items():
 for id,v in zip(cols,vals):
  label,section=newmeta.get(id,(None,None))
  asset(id,p,v,label,section,source='f2021' if p=='2021' else None,page=197 if p=='2021' else 259 if p in ['2022','2023'] else 3,calc=('流动及非流动租赁负债合计取负号' if id=='leases' else '流动及非流动可转债合计' if id=='bonds' else None),basis=('未单独披露递延所得税负债；包含在其他非流动负债汇总，不推算' if v is None else None))
# Long-term investments disclosed in annual note 9 replace corresponding group components.
for p,vals in {'2022':[11040283,3575474,2049616],'2023':[28784997,16816377,1922988]}.items():
 total=bs[p][10]
 for id,v in zip(['long_deposits','long_afs','equity_method'],vals):asset(id,p,v,page=289 if id!='equity_method' else 290)
 put(E['assets'],'noncurrent_total',p,None,basis='已按附注9用长期投资和剩余其他非流动资产替换，避免重复计入')
 asset('noncurrent_remainder',p,total-sum(vals),'其余非流动资产（扣已列长期投资）','other_assets',page=289,calc=f'{total} - '+' - '.join(map(str,vals)),basis='合并其他非流动资产扣除附注9已拆投资，保留实际剩余口径')
# Annual current expenses note breakdown replaces the aggregate.
for p,vals in {'2022':[5850125,6970790,2364723,3978818,1796267],'2023':[13485287,16928603,3200108,16905439,4831962]}.items():
 for id,v in zip(['ads_payable','tax_payable','payroll','accounts_payable','other_accruals'],vals):asset(id,p,-v,page=291)
 put(E['assets'],'accrued_total',p,None,basis='已由应计费用附注五项替换，不重复列汇总')
# Independent classification totals use all available mapped items once.
for p in bs:
 for sec,r in E['section_totals'].items():
  objs=[a for a in E['assets'].values() if a['section']==sec and a.get('amounts',{}).get(p) is not None]
  val=sum(a['amounts'][p] for a in objs)/(1000000 if p=='2026H1' else 1000)
  put(E['section_totals'],sec,p,val,calc=' + '.join(a['id'] for a in objs) or '该分类无披露余额 = 0',basis='完整合并资产负债逐项分类；仅汇总实际已映射对象，汇总与替换明细不重复')
# Income path: keep consolidated results separate from independently disclosed revenue streams.
inc={
'2021':[79809490,14140449,93949939,-31718093,-55335084,6896762,3061662,-1231002,71750,656255,9455427,-1933585,246828,7768670],
'2022':[102931095,27626494,130557589,-31462298,-68693370,30401921,3997100,-51655,-149710,2221358,36419014,-4725667,-155285,31538062],
'2023':[153540553,94098652,247639205,-91723577,-97216866,58698762,10238080,-43987,35721,2952579,71881155,-11849904,-4707,60026544],
'2025H1':[104425393,95231614,199657007,-86806033,-70972512,41878462,10645753,0,-1041490,3380398,54863123,-9299754,-68083,45495286],
'2026H1':[107573,111014,218587,-94910,-76347,47330,12873,0,-703,-9430,50070,-10207,-134,39729]}
for p,v in inc.items():
 for b,n in [('marketing',0),('transaction',1)]:put(E['businesses'][b]['metrics'],'revenue',p,v[n],page=5 if 'H1' in p else 299)
 for id,val in zip(['revenue','direct_cost','period_cost','operating_profit'],[v[2],v[3],v[4],v[5]]):put(E['businesses']['total']['metrics'],id,p,val)
 put(E['businesses']['total']['metrics'],'gross_profit',p,v[2]+v[3],calc=f'{v[2]} + ({v[3]})')
 for id,val in zip(['business_operating_profit','interest_investment_income','interest_expense','foreign_exchange','other_income','pretax_profit','income_tax','a_share_results','consolidated_profit'],v[5:]):
  put(E['other_profit'],id,p,val,label='利息支出' if id=='interest_expense' else None,order=2,calc='原利润表无独立利息支出行；已按净额呈报 = 0' if id=='interest_expense' and 'H1' in p else None)
# Put interest expense before the pretax subtotal for all periods.
for p in ['2024','2025']:put(E['other_profit'],'interest_expense',p,0,calc='该期利润表无独立利息支出行 = 0',source='f'+p,page=284 if p=='2025' else 279)
order=['business_operating_profit','interest_investment_income','interest_expense','foreign_exchange','other_income','pretax_profit','income_tax','a_share_results','consolidated_profit','minority_profit','parent_profit']
for i,id in enumerate(order):E['other_profit'][id]['order']=i
# Cash bridges, annual detailed reconciliation from F-11; interim only the disclosed net reconciliation.
cf={
'2021':[1495380,348863,4774730,-146972-246828+22170,1231002+49300-213-258-71750-2788,55811-10086+1744645-1256426-1422856+8686493+3492038+2651233-354123-23102-1922,0,28783011,-3287232],
'2022':[2224169,510915,7718365,-606447+155285+242236,51655+118384-1028586+10697+149710,86041-2068675+758282+222891-286616+749373+7003998+1480677-487068-34492-996,0,48507860,-635716],
'2023':[786235,1101970,7078794,-1354785+4707-1013475,43987+265159+801100+1755-35721,-3326421-1096240-2121308+754955-437615+11623138+34258159+1820517-977788-184154,-13856982,94162531,-583879]}
cfids=['depreciation','rou_amort','share_comp','investment_adjustments','other_noncash','working_changes','investment_cash','operating_cash_flow','asset_spending']
for p,vs in cf.items():
 for id,v in zip(cfids,vs):put(E['cash_flow'],id,p,v,page=265,calc='现金流量表同类调整项目合计（分量见outputs/finalize.py）' if id in ['investment_adjustments','other_noncash','working_changes'] else None)
 put(E['cash_flow'],'free_cash_flow',p,vs[-2]+vs[-1],page=265,calc=f'{vs[-2]} + ({vs[-1]})')
for p,ocf in [('2025H1',37158599),('2026H1',42115)]:
 put(E['cash_flow'],'operating_cash_flow',p,ocf,page=5)
 put(E['cash_flow'],'interim_reconciliation',p,ocf-inc[p][-1],label='期中非现金及经营周转调整合计',order=7,page=5,calc=f'{ocf} - {inc[p][-1]}',basis='简表仅披露经营现金流总额；差额包括非现金、周转及经营现金流中的投资项目，不能分解')
 for id in ['asset_spending','free_cash_flow']:put(E['cash_flow'],id,p,None,page=5,basis='季报投资现金流仅列净额，不能分离资本支出，不能据此计算自由现金余额')
for i,id in enumerate(['net_profit','depreciation','rou_amort','share_comp','investment_adjustments','other_noncash','working_changes','investment_cash','interim_reconciliation','operating_cash_flow','asset_spending','free_cash_flow']):E['cash_flow'][id]['order']=i
# Own period openings. 2022 starts at previous disclosed equity, with accounting transition separate.
eq={
'2021':[60175888,7768670,-1472172,4774730,375,3867056,0,0],
'2022':[75114547,31538062,5706042,7718365,10219,0,-2316324,0],
'2023':[117770911,60026544,1401522,7078794,8189,955647,0,0],
'2025H1':[313313124,45495286,-1074399,4129027,0,0,0,618],
'2026H1':[413385.156,39729,-8158,2831,0,0,-.156,0]}
for p,vs in eq.items():
 pg={'2021':262,'2022':263,'2023':264,'2025H1':4,'2026H1':3}[p]
 for id,val in zip(['opening_parent_equity','parent_profit','other_comprehensive_income','share_compensation','owner_input','bond_conversion','accounting_transition','other_direct_equity_change'],vs):
  calc=None; basis=None
  if 'H1' in p:
   calc={'opening_parent_equity':'上一年度经审计期末归母权益','parent_profit':None,'other_comprehensive_income':'期末累计其他综合收益 - 年初累计其他综合收益','share_compensation':None,'owner_input':'未独立归属行权；资本变化净额在其他直接权益变化保留 = 0','bond_conversion':'简表未见可转债转股权益净额 = 0','accounting_transition':'年度原值413385.156与季报年初列示413385之单位舍入差 -0.156' if p=='2026H1' else '无已披露会计转换调整 = 0','other_direct_equity_change':'普通股及资本公积期末减期初 - 当期股份支付'}[id]
   basis='期中简表衔接；资本净变化不冒称现金行权或股东投入'
  r=put(E['equity_changes'],id,p,val,label='会计政策转换及呈报精度衔接' if id=='accounting_transition' else None,kind='total' if id=='opening_parent_equity' else 'line',order=8,page=pg,calc=calc,basis=basis)
  if id=='accounting_transition' and p=='2026H1':r['evidence'][p]['reader_note']='季报人民币百万元呈报与年报千元原值的年初舍入差，非真实权益流转。'
 for id in ['equity_distribution','repurchase']:
  put(E['equity_changes'],id,p,0,page=pg,calc='未列独立净权益扣减；期中留存收益变化等于净利润，资本项目按净额列示' if 'H1' in p else '股东权益表无此项净权益流转 = 0')
 close=E['controls']['parent_equity']['amounts'][p]/(1000000 if p=='2026H1' else 1000)
 put(E['equity_changes'],'parent_equity_change',p,close-vs[0],page=pg,calc=f'{close} - {vs[0]}')
for p in ['2024','2025']:put(E['equity_changes'],'accounting_transition',p,0,calc='该年权益变动表无会计转换调整 = 0',source='f'+p,page=288 if p=='2025' else 282)
for i,id in enumerate(['opening_parent_equity','accounting_transition','parent_profit','other_comprehensive_income','share_compensation','owner_input','bond_conversion','equity_distribution','repurchase','other_direct_equity_change','parent_equity_change']):E['equity_changes'][id]['order']=i
# Financial owner cash flows: do not treat borrowing repayment as buyback.
for p,val in [('2021',318),('2022',10079),('2023',8191)]:
 for id in ['cash_dividend','cash_repurchase']:put(E['owner_flows'],id,p,0,page=265,calc='现金流量表融资活动无普通股分红或普通股回购 = 0')
 put(E['owner_flows'],'other_finance_cash',p,val,page=265)
for p in ['2025H1','2026H1']:
 for id in E['owner_flows']:put(E['owner_flows'],id,p,None,page=5,basis='季报仅给融资现金净额，未单独分离分红、回购或股份行权，不把净额当作各项现金流')
# Fill evidence for new rows and correct inherited missing-period citations.
for bucket in [E['assets'],E['section_totals'],E['other_profit'],E['cash_flow'],E['equity_changes'],E['owner_flows']]:
 for row in bucket.values():
  for p in periods:
   if p not in row.get('evidence',{}):put(bucket,row['id'],p,None,basis='本期该项由已列合并项目承接或未独立披露，不重复计入、不外推')
   if row.get('amounts',{}).get(p) is None:
    row['evidence'][p]['source_id']='q'+p[:4] if 'H1' in p else 'f'+p
    if bucket is E['assets']:row['evidence'][p]['basis']='该期按实际可核实分类展示；细分项目由同分类汇总或其他非流动资产承接，不按其他年度比例外推、不重复计入'
# Period descriptions and reader-facing limits.
E['narratives']['scope']='集团合并口径，含子公司及合同控制VIE。五个年度均为1月1日至12月31日；2025H1、2026H1均为1月1日至6月30日累计，资产取各期末。按在线营销及其他、交易服务列收入；未独立披露两项业务或拼多多/Temu的成本、利润与现金，相关指标保留集团总量。2021年营销及其他包含按后续年报比较口径列示的商品销售。期中仅按公告实际分类，不外推年末细项；其他非流动资产含长期存款和证券。2026年季报单位为人民币百万元，2025年季报和年报为千元，已逐份转换。2026Q2单季（4—6月，8月24日公告）收入1.12千亿元、归母净利润272亿元，同比收入增长8.00%、归母净利润下降12.0%；非主表半年累计。'
E['narratives']['cash']='2026H1归母利润397亿元、经营现金流421亿元；2025H1分别为455亿元、372亿元。期中利润到现金仅能保留净调整，投资现金净流量无法分离购建资产支出，自由现金余额留空。2026Q2单季经营现金流257亿元（4—6月），不混入累计。年度经营现金流含部分投资相关现金变化，已单列；自由现金余额按经营现金流减现金购建资产支出，不等于可分配现金。'
E['narratives']['equity']='各期权益桥使用本期年初余额。2022年会计准则转换减少期初权益23.2亿元，单列衔接；当年权益表综合收益净增加57.1亿元，不重复计入转换影响。2021、2023、2024年可转债转股为非现金权益投入。2025年偿债52.3亿元不视为普通股回购。期中仅能推导综合收益及资本净变化，2025H1资本净变动扣股份支付后的61.8万元未独立归因；2026H1年初保留季报舍入衔接。潜在稀释备查沿用经核实的2024—2025年末资料，不当作期中授予余额。'
E['narratives']['ownership']='VIE按合同经济安排合并，名义零持股不代表集团零经济权益。无可靠业务映射的非全资项目保留合并金额，已列权益法投资不再次折算；各期未列少数股东权益或损益。'
# Verify filing identity hashes and retain SEC identity links without changing the local originals.
for id,s in D['sources'].items():
 assert hashlib.sha256(Path(s['path']).read_bytes()).hexdigest()==s['sha256'],id
 if id in ['f2021','f2022']:
  acc={'f2021':'000110465922049283','f2022':'000110465923049927'}[id]; y=id[1:]
  s['basis']+=f'；annualreports镜像，SEC 20-F主体及报告期已核对：https://www.sec.gov/Archives/edgar/data/1737806/{acc}/pdd-{y}1231x20f.htm'
 if id.startswith('q'):s['basis']+='；网页提取保留原PDF URL、页码及行号，不宣称本地文本为原PDF二进制'
# Ensure source pages of 2021 original balance sheet from actual page text.
try:
 from pypdf import PdfReader
 r=PdfReader(D['sources']['f2021']['path'])
 pg=next(i+1 for i,p in enumerate(r.pages) if 'CONSOLIDATED BALANCE SHEETS' in (p.extract_text() or '') and '160,909,168' in (p.extract_text() or ''))
 for a in E['assets'].values():
  e=a.get('evidence',{}).get('2021',{})
  if e.get('source_id')=='f2021' and e.get('status') in ['disclosed','derived']:e['page']=pg
except ImportError:pass
P.save('outputs/draft.json',D)
print('Updated draft via protocol.set_period_value; filled all seven periods.')

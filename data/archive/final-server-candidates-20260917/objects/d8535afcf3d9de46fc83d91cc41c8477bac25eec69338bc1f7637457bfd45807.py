import json,sys,copy
from pathlib import Path
sys.path.insert(0,'.agents/skills/company-two-table/scripts');import protocol as P
D=P.load('outputs/draft.json');E=D['entities']['miniso'];PS=D['periods']
def proof(src,page,basis,calc=None):return {'status':'derived' if calc else 'disclosed','source_id':src,'page':page,'basis':basis,'calculation':calc}
def put(store,key,label,p,v,src,page,basis,order,calc=None,kind='line'):
 r=store.setdefault(key,{'id':key,'label':label,'kind':kind,'order':order,'amounts':{},'evidence':{}});r['amounts'][p]=v*1000;r['evidence'][p]=proof(src,page,basis,calc);return r
# Verify and reclassify all recorded repurchase prepayment balances.
for p,a,src,pg in [('2023FY',87324,'ar2024',183),('2024FY',70518,'ar2025',189)]:
 E['assets']['recv']['amounts'][p]-=a*1000
 E['assets']['recv']['evidence'][p]=proof(src,pg,'应收款明细剔除回购预付款','原表应收款-'+str(a)+'千元')
 E['assets']['repurchase_prepaid']['amounts'][p]=a*1000;E['assets']['repurchase_prepaid']['evidence'][p]=proof(src,pg,'应收款附注中回购预付款，单列非经营资产')
for p in ['2021FY','2022FY']:
 for key in ['pretax_profit','income_tax','consolidated_profit','minority_profit']:
  z=E['other_profit'][key]['evidence'][p]
  if p=='2021FY':z.update(source_id='prospectus',page=458,basis='招股书附录IA损益表：六月财年-上年下半年+本年下半年；归母归属次页')
  else:z.update(source_id='fiscal22',page=58,basis='2022年报合并损益表及ir22中期报告2021/2022下半年数，按自然年衔接')
# More explanatory cash components for years with full reconciliation; retain aggregate residual for earlier/interim.
annual={'2024FY':[-828148,-836820,561422,-6545+6944+4486,-827275], '2025FY':[-916651,-1028794,576214,30931-16043-6341,-769407]}
for j,(k,label) in enumerate([('inventory_cash','库存变动对现金的影响'),('receivable_cash','经营应收及预付变动'),('payable_cash','经营应付变动'),('other_working_cash','合同义务及其他周转变动'),('tax_paid','实际支付所得税')]):
 for p in PS:
  v=annual[p][j] if p in annual else 0
  put(E['cash_flow'],k,label,p,v,'ar2025' if p in annual else 'h126' if 'H1' in p else 'ar2024',193 if p in annual else 36 if 'H1' in p else 30,'2024—2025现金流附注独立分量；其他期间仍在净调整总行中，0表示不重复拆列',3.1+j/10,'未分拆分量已含净调整总行' if p not in annual else None)
for p,vals in annual.items():
 E['cash_flow']['cash_adjustments']['amounts'][p]-=sum(vals)*1000
 E['cash_flow']['cash_adjustments']['evidence'][p]=proof('ar2025',193,'其余非现金及金融、税项调整；已另列周转及实付税款','经营现金流-利润-折旧摊销-股份支付-已列周转影响-实际支付税款')
E['cash_flow']['cash_adjustments']['label']='其余非现金及未展开的税款、周转净调整'
# Correct dates/pages for independently disclosed cash components, not the nearby income or equity page.
for p in PS:
 for k in ['depreciation','share_based']:
  if p in ['2024FY','2025FY']:E['cash_flow'][k]['evidence'][p]=proof('ar2025',193,'现金流附注20(a)非现金加回')
  elif 'H1' in p:E['cash_flow'][k]['evidence'][p]=proof('h126',6 if k=='depreciation' else 5,'中期附注经营损益非现金费用及非IFRS调节；只作现金桥分量')
  elif p=='2023FY':E['cash_flow'][k]['evidence'][p]=proof('ar2024',10,'完整十二个月非IFRS调节列披露的折旧摊销及股份支付；非IFRS净利不替代IFRS净利')
 for key,r in E['owner_flows'].items():
  if 'H1' in p:r['evidence'][p]=proof('h126',36,'现金流量表融资活动，实际支付与权益确认可能不同')
  elif p in ['2024FY','2025FY']:r['evidence'][p]=proof('ar2025',112,'现金流量表融资活动，实际支付与权益确认可能不同')
  elif p=='2023FY':r['evidence'][p]=proof('ar2023',104,'2023六月财年-ir22的2022下半年+2023下半年','同名现金流按十二个月算术衔接')
# Actual additional cash prepaid for repurchase must also remain visible.
for i,p in enumerate(PS):
 v=[-13042, -(3375-13042+3085),-(3693-3085+87324),0,0,0,0][i]
 put(E['owner_flows'],'repurchase_advance','另付回购预付款／前期预付冲回',p,v,'prospectus' if i==0 else 'fiscal22' if i==1 else 'ar2023' if i==2 else 'h126' if 'H1' in p else 'ar2025',470 if i==0 else 64 if i==1 else 104 if i==2 else 36 if 'H1' in p else 112,'2021—2023现金流单列预付款；2024起原表未单列预付款支付，已在回购款内表达',4,'自然年现金流衔接；正数为净冲回' if i<3 else '未另列，避免与支付回购股份款重复')
# Store precise comparisons and scope notes.
E['narratives']['assets']=E['narratives']['assets'].replace('2023—2024应收款中的回购预付款仍暂含在原应收分类，底层总量不变。','回购预付款逐期移至非经营资产，避免将股东分配性资金误当经营周转。')
E['narratives']['cash']+=' 2024—2025已进一步列库存、应收、应付及税款的现金影响；早期和半年仅可验证净调节总额。'
E['narratives']['scope']+=' 借款与租赁负债未按子公司名义股比任意折算；商誉和内部往来缺乏逐项归母映射。'
# Update ordinary balance movements after classification refinements.
for key in ['recv','repurchase_prepaid']:
 r=E['assets'][key]
 for p in PS:
  prev=D['period_metadata'][p]['asset_compare']
  if prev and p!='2025H1' and r['amounts'].get(prev) is not None:
   val=(r['amounts'][p]-r['amounts'][prev])/1000
   z=r['evidence'][p];r.setdefault('movements',{})[p]={}
   put(r['movements'][p],'balance_change','余额净变动',p,val,z['source_id'],z.get('page'),'同一分类的期末-期初；不代表当期收付金额',0,'本期余额-比较基期余额')
for section,row in E['section_totals'].items():
 for p in PS:
  if p!='2025H1':row['amounts'][p]=sum(r['amounts'][p] for r in E['assets'].values() if r['section']==section)
# Missing classification source lines shouldn't fabricate a ratio: accounting-equity residual is independently retained.
E['assets']['associate'].pop('attribution',None)
E['assets']['associate']['evidence']['2025FY']['reader_note']='2025年永辉29.4%收购形成的权益法投资已按持有权益计量；期末全部权益法投资还包括其他被投资公司，不能全部称为永辉。'
E['assets']['associate']['evidence']['2026H1']['reader_note']='全部权益法投资含永辉及其他联营企业；权益法账面值已经应占，不再乘29.4%。'
# Reader explanations of special charges and value changes, linked to statements.
E['other_profit']['associate_result']['evidence']['2025FY']['reader_note']='权益法亏损8.34亿元，其中永辉8.13亿元；不是MINISO零售毛利成本。'
E['other_profit']['associate_result']['evidence']['2026H1']['reader_note']='权益法净收益0.578亿元，其中永辉贡献0.603亿元、其他被投公司亏损0.0253亿元。'
E['businesses']['company_total']['metrics']['period_cost']['evidence']['2026H1']['reader_note']='净额包含销售及分销费用30.5亿元、行政费用5.91亿元以及其他收益和损失；AI基金公允价值收益2.77亿元含在其他净收入中，需区别于零售利润。'
E['narratives']['business']+=' 半年经营利润还含AI基金公允价值收益2.77亿元；经营利润增长不完全等同零售经营改善。'
# Keep verifiable historical reuse audit outside schema.
P.save('outputs/draft.json',D)
Path('outputs/research-notes.md').write_text('''# 研究及核对记录\n\n使用任务指定的既有底稿增量研究，并复用 references/0.json 中2023—2025收入、资产及现金事实；对照本地原件复核，没有照搬旧结论。\n\n更正旧稿：2021/2022税前与合并利润混用了半年数；现金流1097541与1666030千元分别属于2023下半年与2023六月财年，并非2021/2022自然年。现以招股书、2022财年及中期报告算术衔接自然年。2024设备净投入由762538-12446=750092千元；2026H1使用原表1475401千元经营现金流，并将44263千元处置回收与724622千元购建付款分列。\n\n所有七个经营期间均有独立期初权益及归母利润、综合收益、投入、股份支付、分配、回购和其他直接变动。2025H1只为经营比较和权益桥，不重复资产视图。2026H1权益原页35已经视觉复核。\n\n3%阅读原则：较小项目保留在底层完整加总路径。合并总量不因分部缺项消失。早期分部无法按2025年新增的内地/海外利润轴追溯，不假造分摊成本。非全资子公司的净资产无法按内部抵销后的单项映射，明确保留少数权益剩余调整，不声称完成逐项穿透。\n\n原件备注：设备与使用权附注滚存折旧合计和损益附注折旧摊销费用不完全一致，报告分别遵循各自原披露，不将两类口径强行混合。\n''')
print('Refined report')

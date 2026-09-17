import sys,json,subprocess,re
sys.path.insert(0,'.agents/skills/company-two-table/scripts')
import protocol as P
D=P.draft('outputs/draft.json');E=D['entities']['pdd'];ps=D['periods']
for s in D['sources'].values():
 if s['path'].endswith('.pdf'):
  info=subprocess.check_output(['pdfinfo',s['path']],text=True);s['page_count']=int(re.search(r'Pages:\s+(\d+)',info)[1])
for bucket in [E['summary'],E['controls']]:
 for row in bucket.values():
  row['evidence']['2021'].update(source_id='f2021',page=138 if bucket is E['summary'] else 139)
  for p in ['2025H1','2026H1']:row['evidence'][p]['page']=3 if bucket is E['summary'] or p=='2026H1' else 4
for b in ['marketing','transaction']:
 for p in ['2021','2022','2023']:E['businesses'][b]['metrics']['revenue']['evidence'][p]['page']=302
for p in ['2025H1','2026H1']:
 for id in ['consolidated_profit','minority_profit','parent_profit']:E['other_profit'][id]['evidence'][p]['page']=4
 E['cash_flow']['net_profit']['evidence'][p]['page']=4
 E['equity_changes']['share_compensation']['evidence'][p]['page']=5
 E['equity_changes']['parent_profit']['evidence'][p]['page']=4
 E['equity_changes']['opening_parent_equity']['evidence'][p].update(source_id='f'+('2024' if p=='2025H1' else '2025'),page=277 if p=='2025H1' else 283)
# Precise calculations live in evidence instead of depending on an external script.
formulas={
'2021':{'investment_adjustments':'-146972 - 246828 + 22170','other_noncash':'1231002 + 49300 - 213 - 258 - 71750 - 2788','working_changes':'55811 - 10086 + 1744645 - 1256426 - 1422856 + 8686493 + 3492038 + 2651233 - 354123 - 23102 - 1922'},
'2022':{'investment_adjustments':'-606447 + 155285 + 242236','other_noncash':'51655 + 118384 - 1028586 + 10697 + 149710','working_changes':'86041 - 2068675 + 758282 + 222891 - 286616 + 749373 + 7003998 + 1480677 - 487068 - 34492 - 996'},
'2023':{'investment_adjustments':'-1354785 + 4707 - 1013475','other_noncash':'43987 + 265159 + 801100 + 1755 - 35721','working_changes':'-3326421 - 1096240 - 2121308 + 754955 - 437615 + 11623138 + 34258159 + 1820517 - 977788 - 184154'}}
for p,rows in formulas.items():
 for id,f in rows.items():E['cash_flow'][id]['evidence'][p]['calculation']='('+f+') * 1000 CNY'
for p,f in [('2025H1','(6750146 - 7824545) * 1000 CNY'),('2026H1','(-6042 - 2116) * 1000000 CNY')]:E['equity_changes']['other_comprehensive_income']['evidence'][p]['calculation']=f
E['equity_changes']['other_direct_equity_change']['evidence']['2025H1']['calculation']='((181 + 121958952) - (180 + 117829308) - 4129027) * 1000 CNY'
E['equity_changes']['other_direct_equity_change']['evidence']['2026H1']['calculation']='(128599 - 125768 - 2831) * 1000000 CNY；普通股低于百万元呈报精度'
# Give no automatic adjacent-column difference the meaning of a half-year movement.
E['narratives']['scope']+=' 半年权益桥期初取上年12月31日；资产横向差额不等同当期投入，2025H1不以相邻的2025年末列作期初。'
for a in E['assets'].values():
 for p in ['2021','2022','2023','2025H1','2026H1']:
  if a['amounts'].get(p) is not None:a.setdefault('movement_review',{})[p]={'status':'difference_only' if a['section'] in ['working','cash'] else 'not_disclosed','basis':'余额按实际披露保留；未独立核实投入、处置和汇率等完整变动分量。期中以自身年初为变动起点，横向列差不是资本投入。','source_ids':[a['evidence'][p]['source_id']]}
# Grouping identities; null means covered at a coarser disclosed level, not silently zero-valued assets.
audit={'currency':'CNY','display_scale':D['display_scale'],'period_definitions':{},'checks':[],'notes':['分类审计加总本期实际映射明细；空项由已列汇总承接，未以虚构数补平。','现金及权益检查独立于protocol对含空项行的比较逻辑。','原始披露精度保留，读者文字三位有效数字。']}
for p in ps:
 y=p[:4];audit['period_definitions'][p]={'start_date':y+'-01-01','end_date':y+('-06-30' if 'H1' in p else '-12-31'),'type':'half_year' if 'H1' in p else 'annual'}
 parent=E['controls']['parent_equity']['amounts'][p]
 mapped=sum((a['amounts'].get(p) or 0)*(-1 if a['group']=='liabilities' else 1) for a in E['assets'].values())
 bridge=sum(r['amounts'].get(p) or 0 for r in E['equity_changes'].values() if r['kind']=='line')+E['equity_changes']['opening_parent_equity']['amounts'][p]
 cf=sum(r['amounts'].get(p) or 0 for id,r in E['cash_flow'].items() if id not in ['operating_cash_flow','asset_spending','free_cash_flow'])
 rev=sum(E['businesses'][b]['metrics']['revenue']['amounts'][p] for b in ['marketing','transaction'])
 checks={'asset_to_parent':mapped-parent,'equity_bridge':bridge-parent,'cash_bridge':cf-E['cash_flow']['operating_cash_flow']['amounts'][p],'business_revenue':rev-E['businesses']['total']['metrics']['revenue']['amounts'][p]}
 for v in checks.values():assert abs(v)<1,(p,checks)
 audit['checks'].append({'period':p,'differences_CNY':checks,'ok':True})
P.save('outputs/reconciliation-audit.json',audit)
P.save('outputs/draft.json',D)
print('Source page counts verified:',{k:s['page_count'] for k,s in D['sources'].items()})

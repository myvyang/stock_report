import json
p='outputs/draft.json';x=json.load(open(p));e=x['entities']['pdd']
# Keep unexplained movement differences visible: do not manufacture identified flows.
a=e['assets']['leases'];m=a['movements']['2025']['cash_settlement'];m['label']='现金流量表租赁义务调整（反向映射）';m['evidence']['2025'].update(status='derived',calculation='现金流量表租赁负债调整 -2,116,609 千元取反，映射为有符号经营义务的减少',basis='2025年报PDF第290页间接法现金流量表；该调整不等于租赁付款。第317页单列实际经营租赁付款2,302,946千元。',reader_note='实际租赁付款23.0亿元；本分量为间接法现金流调整的反向映射，不能当作现金结算额。')
a['evidence']['2025']['change_explanation']='新增租赁义务22.8亿元；现金流量表租赁义务调整反向映射21.2亿元，其余有符号差额0.820亿元未拆分。实际经营租赁付款23.0亿元，含费用因素，不直接替换本项调整。'
for o in e['assets'].values():
 rev=o.get('movement_review',{}).get('2024')
 if rev and '首个展示年度' in rev.get('basis',''):rev['basis']='该对象已保留2023、2024年末实际余额；年报未列完整同口径滚动表，未拆分的新增、处置等不按现金投入替代。'
# Correct source types for saved official web extracts.
for sid in ['q2025','q2026']:x['sources'][sid]['kind']='external'
def walk(o):
 if isinstance(o,dict):
  if 'amounts' in o and 'evidence' in o:
   for per,ev in o['evidence'].items():
    if ev.get('status') in ['missing','not_applicable']:
     ev['page']=None
     if per in ['2025H1','2026H1'] and ev.get('source_id')=='f2023':ev['source_id']='q2025' if per=='2025H1' else 'q2026'
    if ev.get('source_id') in ['q2025','q2026'] and ev.get('status')=='disclosed':ev['status']='external'
    if ev.get('source_id')=='f2025' and ev.get('page')==283:ev['page']=284
  for v in o.values():walk(v)
 elif isinstance(o,list):
  for v in o:walk(v)
walk(e)
x['disclosure_resolution']['basis']='本轮复查公司季度、年度及SEC披露目录；截至2026-09-15，最新季度目录为2026Q2，公告原件日期2026-08-24、财务截止2026-06-30；最新完整年度为2025年（2026-04-29发布）。本报告列最新上半年累计和可比上半年，单季摘要注明独立起止范围。目录复核记录保存在outputs/evidence/disclosure-index-check.txt。'
json.dump(x,open(p,'w'),ensure_ascii=False,indent=2)

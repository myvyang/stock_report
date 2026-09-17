import json,re
from pypdf import PdfReader
x=json.load(open('outputs/draft.json'));texts={k:[p.extract_text() or '' for p in PdfReader(v['local_file']).pages] for k,v in x['sources'].items() if v['local_file'].endswith('.pdf')}
json.dump(texts,open('outputs/evidence/pdf-pages.json','w'))
def walk(o,path=''):
 if isinstance(o,dict):
  if 'amounts' in o and 'evidence' in o:
   for per,ev in o['evidence'].items():
    val=o['amounts'].get(per);sid=ev.get('source_id');page=ev.get('page')
    if sid not in texts or val is None or not page or ev['status']!='disclosed' or val==0:continue
    n=round(abs(val)/x['sources'][sid]['unit_scale']);s=f'{n:,}'
    if s not in texts[sid][page-1]:
     hits=[i+1 for i,t in enumerate(texts[sid]) if s in t]
     print(path,per,n,'page',page,'hits',hits)
  for k,v in o.items():walk(v,path+'/'+k)
 elif isinstance(o,list):
  for i,v in enumerate(o):walk(v,path+'/'+str(i))
walk(x['entities'])

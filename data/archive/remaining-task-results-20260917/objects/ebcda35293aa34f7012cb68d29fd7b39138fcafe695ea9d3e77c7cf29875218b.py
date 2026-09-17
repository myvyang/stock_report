import json,subprocess,sys,hashlib
from pathlib import Path
p=Path('outputs/draft.json');d=json.loads(p.read_text());e=d['entities']['pdd']
e['businesses']['total']['order']=3
e['businesses']['total']['metrics']['direct_cost']['label']='减：平台服务收入成本'
e['businesses']['total']['metrics']['period_cost']['label']='减：营销、管理及研发费用'
e['businesses']['total']['metrics']['period_cost']['evidence']['2024']['reader_note']='营销费用1.11千亿元、管理费用75.5亿元、研发费用127亿元；已含股份支付及折旧摊销。'
e['businesses']['total']['metrics']['period_cost']['evidence']['2025']['reader_note']='营销费用1.25千亿元、管理费用81.6亿元、研发费用165亿元；已含股份支付及折旧摊销。'
e['assets']['long_afs']['evidence']['2024']['page']=317
e['equity_changes']['owner_input']['evidence']['2024']['page']=288
e['equity_changes']['owner_input']['evidence']['2024']['basis']='2025年报比较股东权益表：2024年股份奖励行权1,263千元×1,000'
e['equity_changes']['bond_conversion']['evidence']['2025']['page']=289
for id in ['equity_distribution','repurchase','other_direct_equity_change']:
 for proof in e['equity_changes'][id]['evidence'].values():
  proof.update(status='derived',basis='逐项读取权益表，未列该项净权益流转；法定储备转拨及存托行股份结算属于权益内部转移',calculation='权益变动表已披露净额项目之外，该项直接净权益变动为0')
e['assets']['short_deposits']['evidence']['2025']['reader_note']='其中账面146亿元的持有至到期债券已出借给金融机构，附注披露收到抵押品1.56亿元；保留证券账面额。'
for id,text in {
'equipment':'净额增加4.27亿元；已单列折旧5.98亿元，新增、处置及其他变动尚有10.2亿元未拆分。现金购建支出还包含无形资产及应计差异，不能直接当作本项资本新增。',
'rou':'新租赁确认22.8亿元、摊销24.0亿元；与期末账面余额仍差-0.820亿元，附注未独立列出完整变动原因。',
'leases':'新租赁义务增加22.8亿元，现金流量表义务净减少21.2亿元；其余有符号差额0.820亿元未拆，不能全归为汇率影响。',
}.items():e['assets'][id]['evidence']['2025']['change_explanation']=text
# First year need not imply research absence; compare balances from disclosed statements when available.
for obj in e['assets'].values():
 obj.setdefault('movement_review',{})['2024']={'status':'difference_only' if obj['section']=='working' else 'not_disclosed','basis':'首个展示年度以年末余额为基准；未给该细分对象建立完整2023年期初至2024年滚动表。2024年全年现金投入、利润及权益变动已另行保存。','source_ids':['f2024','f2025']}
for s in d['sources'].values():
 f=Path(s['path']);assert hashlib.sha256(f.read_bytes()).hexdigest()==s['sha256']
d['sources']['f2025']['basis']+='；报表单位人民币千元，底稿已换算人民币元；官方索引 https://investor.pddholdings.com/sec-filings/sec-filing/20-f/0001104659-26-050727（2026-04-29提交）；在线核对年度收入431,845,713千元一致'
e['coverage']['basis']+='；对原件PDF哈希复核一致。'
p.write_text(json.dumps(d,ensure_ascii=False,indent=2))
# Preserve independent category totals through the protocol, not duplicate objects.
for section in sorted(set(o['section'] for o in e['assets'].values())):
 ids=[k for k,o in e['assets'].items() if o['section']==section]
 for period in d['periods']:
  amount=sum(e['assets'][k]['amounts'][period] for k in ids)
  args=[sys.executable,'.agents/skills/company-two-table/scripts/protocol.py','section-total','--draft',str(p),'--entity','pdd','--section',section,'--period',period,'--amount',str(amount),'--status','derived','--source-id','f2025','--page','282','--basis','原始资产负债表和附注明细分类重组；类别总量与下属对象校验，不另加一层重复计算','--calculation','人民币元有符号加总：'+' + '.join(ids)]
  r=subprocess.run(args,capture_output=True,text=True)
  if r.returncode:raise RuntimeError(r.stdout+r.stderr)
print('Evidence references, classification totals, and unresolved movement explanations updated.')

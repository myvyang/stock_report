import json,sys,subprocess,hashlib
from pathlib import Path
S='.agents/skills/company-two-table/scripts/protocol.py';D='outputs/draft.json'
def cmd(command,**kw):
 a=[sys.executable,S,command,'--draft',D]+['--'+k.replace('_','-')+'='+str(v) for k,v in kw.items() if v is not None]
 r=subprocess.run(a,capture_output=True,text=True)
 if r.returncode:raise RuntimeError(r.stdout+r.stderr)
def row(module,i,label,v,pg,status='disclosed',calc=None,note=None):
 cmd('operating-row',entity='yingen',module=module,id=i,label=label,period='2024',amount=v,status=status,source_id='yingen_audit',page=pg,basis='2024全年合并现金流量表，经原页图像核对',calculation=calc,reader_note=note)
row('cash_flow','asset_spending','购建长期资产支付的现金',-1200835401.90,12)
row('cash_flow','free_cash_flow','经营现金扣现金资本开支余额',652266880.41,12,'derived','1853102282.31-1200835401.90','未扣向股东支付现金及偿还债务；工程新增额含非现金结算，不能代替现金资本开支。')
row('owner_flows','cash_minority_dividend','合并现金流表所列支付少数股东股利',-235969165.20,12,note='按审计合并现金流量表原行保留；期末合并少数权益为零，不能将此现金流行直接当作本单元全部股东分红。')
# Unknown total shareholder cash remains distinct from interest-inclusive cash flow.
cmd('operating-row',entity='yingen',module='owner_flows',id='ordinary_cash_dividend',label='本单元支付全部普通股东现金股利',period='2024',amount='null',status='missing',source_id='yingen_audit',page=12,basis='现金流表仅单列分配股利利润或偿付利息730558031.83元，未能单独核定全部普通股东实际现金支付',reader_note='权益确认分红6.03亿元；合并表股利与利息混合支付7.31亿元，不能直接作为全部实付股利。')
for obj,v in [('cip_mine',194256266.34),('cip_water',49341300.47)]:cmd('asset-movement',entity='yingen',object=obj,id='addition',label='二期工程新增投入',period='2024',amount=v,status='disclosed',source_id='filing_2024',page=165,basis='集团年报对应银根天然碱及供水二期工程附注，项目余额与独立审计74页一致')
# Update narratives, provenance and explicit period boundaries.
x=json.load(open(D));r=x['entities']['root'];y=x['entities']['yingen']
for i in ['fixed_buildings','fixed_machines','fixed_transport','fixed_electronic','fixed_pipe']:
 r['assets'][i]['movement_review']['2025']['basis']='五类原值、累计折旧、减值各自滚存闭合。原件在建工程转入五类合计3058082530.31元，合计栏3048756105.00元，两者差9326425.31元；采用五类直接披露数并保留原合计差异说明。'
 r['assets'][i]['evidence']['2025']['reader_note']='按五类净值与各自滚存列示。原件在建工程转入合计30.5亿元，五类之和30.6亿元，相差933万元；五类分项分别闭合，未倒算其他增加。'
 for p in ['2024','2025']:
  r['assets'][i]['evidence'][p]['basis']='2025年报物理141页固定资产五类期末及期初净值；原值和折旧分别见140—141页'
r['narratives']['source_discrepancies']='2024年报181页其他产品成本168766477.80元、分解表其他业务成本64007681.50元，而同页营业收入成本总表其他业务成本64007681.29元，相差0.21元；保留各自披露数。2025年报140页固定资产在建工程转入原值合计3048756105.00元，五类直接数之和3058082530.31元，相差9326425.31元；已图像复核，资产变化采用五类明细，各类净值均闭合。工程物资原额两年减少5746756.04元、减值准备净增加28848392.19元，共同形成账面净值减少34595148.23元；没有购入和领用的完整分解。'
r['narratives']['scope']='上市公司2024、2025全年合并口径，以人民币元保存并按亿元展示。2024年报使用原公司名称远兴能源。根主体包含各子公司及集团内部抵销，下属经营单元为穿透明细、金额保持各单元整体口径，不可再次相加；产品、地域、渠道也属交叉统计轴。'
r['narratives']['equity']+=' 归母净资产由2024年末127亿元降至2025年末108亿元；2025年归母利润9.42亿元，权益确认分红11.2亿元，增持银根矿业直接减少归母权益18.4亿元。普通股东实付现金因原披露口径未闭合保留未确认，与权益分配分别列示。'
# Correct equity amounts dynamically to avoid using rounded recollections.
pe=r['controls']['parent_equity']['amounts']
r['narratives']['equity']=r['narratives']['equity'].replace('127亿元',f"{pe['2024']/1e8:.3g}亿元").replace('108亿元',f"{pe['2025']/1e8:.3g}亿元")
r['coverage']={'level':'partial','basis':'已复核两年合并主表和附注，增补固定资产五类及两年滚存、其他应收款原额与坏账抵减、一年内到期三类融资义务、工程物资原额与减值，保留各产品及地域渠道、主要子公司与联营企业。普通股东实付现金受原件混合口径及附注不一致限制；在对应行保留missing及依据，权益确认分配独立保存。','source_ids':list(x['sources'])}
y['coverage']={'level':'partial','basis':'2024独立合并资产组成全部录入并与16788554426.71元资产、9065514881.25元负债闭合；已补固定资产五类、权利、摊余支出滚存，产品收入、利润链、资本开支及归母权益变化。独立审计仅覆盖2024全年及2025年1—5月。2025全年继续使用集团年报单元汇总；独立年末组成和分段利润无匹配全年证据，不用5月数填充。','source_ids':['filing_2024','filing_2025','yingen_audit']}
y['narratives']={'scope':'阿拉善天然碱资产包合并口径，含银根化工和配套水务等主体及与集团其他单元往来。2024资产组成来自补充审计；2025汇总来自集团年报。','equity':'2024年本单元净利润22.4亿元，权益确认分红6.03亿元，加股份支付和专项储备后归母权益净增17.0亿元，年末为77.2亿元。上市公司2024年持股60.0%，2025年末持股70.6%；2025取得股权的时点及缺少分段利润使全年归属利润无法简单按期末持股计算。','cash':'2024年本单元净利润22.4亿元，经折旧摊销及应收应付等调整形成经营现金18.5亿元；扣现金资本开支12.0亿元后余6.52亿元。2025全年已披露经营现金11.8亿元，未取得同口径全年资本开支，不推算全年自由现金余额。','source_discrepancies':'补充审计74页将2024年末1405985314.56元纯碱在建余额称为一期，75页滚存将同额列为二期，与集团年报一致，采用二期名称。2024独立审计固定资产转固3319076422.32元，75页重要项目一期转固3066643623.72元仅覆盖其重要项目，其他转固不归入一期；不以局部项目滚存代替全部工程。'}
# Preserve original source identities and ensure every new annual blank is explicitly missing.
for eid,e in x['entities'].items():
 if eid not in ['root','yingen']:
  e['narratives']['scope']=e['scope']+'；下属单元汇总为披露范围，不能与根合并总量相加。'
  if 'cash' not in e['narratives']:
   vs=e['cash_flow'].get('operating_cash_flow',{}).get('amounts',{})
   e['narratives']['cash']='；'.join(f'{p}年经营现金净额{v/1e8:.3g}亿元' for p,v in vs.items() if v is not None)+'。现有资料未提供同口径完整资本开支和利润现金调整，不按集团比例分摊。' if any(v is not None for v in vs.values()) else '现有资料未给出本单元法定现金流及现金资本开支，不按集团数据分摊，未计算自由现金余额。'
for src in x['sources'].values():
 p=Path(src['path']);assert p.exists(),p
 assert hashlib.sha256(p.read_bytes()).hexdigest()==src['sha256'],p
x['sources']['yingen_audit']['basis']='2025-10-28补充审计，2024全年及2025年1—5月；原件物理6—7页合并资产负债表、10页利润表、12页合并现金流量表经图像复核，56—99页附注经全文检索。URL：https://static.cninfo.com.cn/finalpage/2025-10-28/1224746718.PDF；文本materials/additional/1-yingen-audit-20251028.txt。'
json.dump(x,open(D,'w'),ensure_ascii=False,indent=2)
# Protocol writes missing annual observations explicitly.
for i,a in y['assets'].items():
 if '2025' not in a['evidence']:cmd('asset-object',entity='yingen',id=i,label=a['label'],group=a['group'],section=a['section'],period='2025',amount='null',status='missing',source_id='yingen_audit',page=3,basis='补充审计截至2025年5月31日，无2025年末明细；2025全年汇总另取集团年报',reader_note='未取得2025年末同口径明细，5月余额不作为年末金额。')
for i,b in y['businesses'].items():
 for m,a in b['metrics'].items():
  if '2025' not in a['evidence']:cmd('business-metric',entity='yingen',business=i,metric=m,period='2025',amount='null',status='missing',source_id='yingen_audit',page=3,basis='审计截至2025年5月，未取得全年本单元产品分解',reader_note='2025全年主体总收入另列，产品收入不按1—5月年化。')
for mod in ['equity_changes','cash_flow','owner_flows']:
 for i,a in y[mod].items():
  if '2025' not in a['evidence']:
   args=dict(entity='yingen',id=i,label=a['label'],period='2025',amount='null',status='missing',source_id='yingen_audit',page=3,basis='现有独立审计仅截至2025年5月，无本行同口径全年数据',reader_note='2025年1—5月数据不代替全年；已知全年汇总另列。')
   if mod!='equity_changes':args['module']=mod
   cmd('equity-change' if mod=='equity_changes' else 'operating-row',**args)
print('finished annual evidence and narratives')

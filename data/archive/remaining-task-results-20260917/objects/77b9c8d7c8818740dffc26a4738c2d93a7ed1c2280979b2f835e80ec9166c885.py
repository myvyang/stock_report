import subprocess
from decimal import Decimal

P = '.agents/skills/company-two-table/scripts/protocol.py'
D = 'outputs/draft.json'
def run(command, **kwargs):
    args = ['python3', P, command, '--draft', D]
    for key, value in kwargs.items():
        args += ['--' + key.replace('_', '-') + '=' + str(value)]
    subprocess.run(args, check=True, stdout=subprocess.DEVNULL)

run('source', id='yingen_audit', kind='filing', path='materials/yingen-audit-20251028.pdf',
    basis='2025-10-28法定补充审计，覆盖2024全年及2025年1—5月；https://static.cninfo.com.cn/finalpage/2025-10-28/1224746718.PDF；全文提取保存在同目录txt，主表为扫描页，物理7、10页已图像核对。',
    sha256='6ee2cf022b6b625a33c6a8ab44e2934d0e3ac9a95275e16f284bd5353464d63b', page_count=129)
run('source', id='dividend_2025', kind='filing', path='materials/dividend-2025.pdf',
    basis='2024年度权益分派实施公告，2025-06-10公布，实施日在2025年；https://static.cninfo.com.cn/finalpage/2025-06-10/1223824188.PDF',
    sha256='f44fcee52cc427f9bb73d699341212402e2bb5d4297bc79b29798d4e40908826', page_count=3)

# 顺序：流动资产、非流动资产、资产、流动负债、非流动负债、负债；逐数取年报物理页。
data = {
 'yingen': (173, [
  ['2259748989.35','14528805437.36','16788554426.71','5360557151.67','3704957729.58','9065514881.25'],
  ['1329711252.19','19600659577.95','20930370830.14','6429210496.20','6026020852.05','12455231348.25']]),
 'zhongyuan': (173, [
  ['2681667337.00','6265110336.87','8946777673.87','1659999096.36','339676939.26','1999676035.62'],
  ['1385586707.26','5515206730.40','6900793437.66','1769003259.74','293348715.81','2062351975.55']]),
 'boda': (173, [
  ['860659095.78','2678436031.78','3539095127.56','364349722.98','64321765.08','428671488.06'],
  ['783104620.80','2312760331.24','3095864952.04','545028471.22','10861427.88','555889899.10']]),
 'mengda_unit': (175, [
  ['1282017921.37','16799635401.45','18081653322.82','3814616026.66','2980382121.86','6794998148.52'],
  ['1785063574.51','16378093341.06','18163156915.57','1854461992.68','4000666528.67','5855128521.35']]),
 'zhongmei_unit': (175, [
  ['259427988.94','1666761545.74','1926189534.68','536141434.48','784218357.64','1320359792.12'],
  ['318602787.38','1552797432.61','1871400219.99','842657212.82',None,'842657212.82']])
}
keys=['current_assets','long_assets','total_assets','current_liabilities','long_liabilities','total_liabilities']
labels=['流动资产','非流动资产','资产合计','流动负债','非流动负债','负债合计']
for entity,(page,years) in data.items():
    for year,values in zip(['2024','2025'],years):
        for order,(key,label,value) in enumerate(zip(keys,labels,values)):
            ev=dict(status='disclosed',basis='重要非全资子公司主要财务信息；100%主体汇总，不与根相加。' if page==173 else '重要联营企业主要财务信息；100%主体汇总，不与根长期股权投资相加。')
            if value is None:
                value='0'
                ev=dict(status='derived',basis='原表非流动负债栏空白；由已披露总负债减流动负债确定为零。',calculation='842657212.82-842657212.82=0')
            run('summary-row',entity=entity,id=key,label=label,order=order,period=year,amount=value,source_id='filing_2025',page=page,**ev)
        run('control',entity=entity,id='consolidated_equity',period=year,
            amount=Decimal(values[2])-Decimal(values[5]),status='derived',source_id='filing_2025',page=page,
            basis='主体全部净资产，归属基数另行核实。',calculation=f'{values[2]}-{values[5]}')

run('control',entity='yingen',id='parent_equity',period='2024',amount='7723039545.46',status='disclosed',source_id='yingen_audit',page=7,basis='补充审计合并资产负债表2024-12-31归属于母公司所有者权益合计；已核对扫描原页。更正旧底稿误引上市公司年报的来源。')
run('operating-row',entity='yingen',module='other_profit',id='parent_profit',label='银根矿业本单元归母净利润',kind='total',period='2024',amount='2240549270.85',status='disclosed',source_id='yingen_audit',page=10,basis='补充审计合并利润表2024年度归属于母公司所有者的净利润；扫描页已核对。')
run('ownership',entity='yingen',period='2024',ratio='.6',profit_ratio='.6',method='proportional',source_id='filing_2024',page=195,basis='2024年报集团构成披露持股60%；补充审计第7、10页确认本单元归母权益及利润，全年比例60%。')

# 补充审计的全年利润链；不把2025年1—5月写成全年。
common=dict(entity='yingen',period='2024',source_id='yingen_audit',page=10)
revenue=Decimal('6184433231.07'); cost=Decimal('2887707947.59')
expenses=Decimal('62237691.86')+Decimal('219570833.80')+Decimal('140766244.53')
op=revenue-cost-expenses
for metric,amount,formula in [
 ('direct_cost',-cost,None),('gross_profit',revenue-cost,'6184433231.07-2887707947.59'),
 ('period_cost',-expenses,'-(62237691.86+219570833.80+140766244.53)'),
 ('operating_profit',op,'6184433231.07-2887707947.59-62237691.86-219570833.80-140766244.53')]:
    ev=dict(status='derived',calculation=formula) if formula else dict(status='disclosed')
    run('business-metric',business='company_total',metric=metric,amount=amount,basis='2024全年合并利润表；期间费用含税金及附加、销售费用、管理费用，保留含折旧口径；财务费用进入利润桥。',**common,**ev)
    run('business-metric',entity='yingen',business='company_total',metric=metric,period='2025',amount='null',status='missing',basis='2025年报仅披露单元汇总收入与净利润；补充审计仅至5月，不延长至全年。')
profit_rows=[
 ('business_operating_profit','业务经营利润','subtotal',op,'上述收入减成本及经营费用'),
 ('finance','财务费用','line','-240577644.20',None),
 ('grant','其他收益','line','588179.23',None),
 ('investment','投资收益','line','1829135.92',None),
 ('credit','信用减值损失','line','-119410.94',None),
 ('outside_income','营业外收入','line','229170.35',None),
 ('outside_cost','营业外支出','line','-11722330.92',None),
 ('pretax_profit','利润总额','subtotal','2624377612.73',None),
 ('income_tax','所得税费用','line','-383828341.88',None),
 ('minority_profit','本单元少数股东损益','line','0','2240549270.85-2240549270.85=0')]
for order,(key,label,kind,amount,formula) in enumerate(profit_rows,-20):
    run('operating-row',module='other_profit',id=key,label=label,kind=kind,order=order,amount=amount,
        basis='银根矿业2024年度合并利润表；少数股东栏空白且合并净利润与归母净利润同额。' if key=='minority_profit' else '银根矿业2024年度合并利润表。',
        **common,**(dict(status='derived',calculation=formula) if formula else dict(status='disclosed')))
    run('operating-row',entity='yingen',module='other_profit',id=key,label=label,kind=kind,order=order,period='2025',amount='null',status='missing',basis='2025全年未在当前单元汇总中单列；补充审计仅至5月。')
cash=[('net_profit','主体净利润','2240549270.85'),('credit','信用减值损失','119410.94'),
 ('depreciation','固定资产折旧','535002811.67'),('rou_depreciation','使用权资产折旧','3435695.79'),
 ('amortization','无形资产摊销','14468856.80'),('deferred_amortization','长期待摊费用摊销','32598071.55'),
 ('finance','财务费用调整','234977320.08'),('investment','投资收益调整','-1829135.92'),
 ('dta','递延所得税资产变动','-788824.24'),('dtl','递延所得税负债变动','-2174332.83'),
 ('inventory','存货变动','-67441143.38'),('receivables','经营应收项目变动','-836135285.10'),
 ('payables','经营应付项目变动','-299680433.90')]
for order,(key,label,amount) in enumerate(cash,-20):
    run('operating-row',entity='yingen',module='cash_flow',id=key,label=label,kind='line',order=order,period='2024',amount=amount,status='disclosed',source_id='yingen_audit',page=98,basis='银根矿业补充审计2024年度现金流量表补充资料。')
    if key=='net_profit':
        run('operating-row',entity='yingen',module='cash_flow',id=key,label=label,kind='line',period='2025',amount='1380380688.77',status='disclosed',source_id='filing_2025',page=174,basis='重要非全资子公司2025全年主体净利润。')
    else:
        run('operating-row',entity='yingen',module='cash_flow',id=key,label=label,kind='line',period='2025',amount='null',status='missing',basis='2025年报仅披露本单元经营现金净额，未披露全年调整明细；不使用1—5月数据替代。')

run('narrative',entity='yingen',id='audited_2024',text='本次取得并登记2025-10-28补充审计原件，物理第7、10页扫描核实2024归母净资产7,723,039,545.46元、归母净利润2,240,549,270.85元，已更正旧底稿来源误引。已补录2024利润链及第98页净利润至经营现金流调整。该审计仅覆盖至2025年5月，不能用作2025全年证据。第56—99页已披露2024资产组成、固定资产、在建工程、权利等附注，尚未全部结构化，属于待处理披露，非未披露。')
for entity in data:
    basis='本次逐数核对2025年报物理173—174页两年子公司资产负债和经营汇总，并补入此前遗漏的六类资产负债汇总。' if data[entity][0]==173 else '本次逐数核对2025年报物理175页两年联营企业资产负债、归母权益及损益。已补入此前遗漏的六类资产负债汇总。'
    if entity=='yingen':
        basis+='取得并查阅2025-10-28银根矿业补充审计第7、10、70—73、98—99页，覆盖2024全年及2025年1—5月；2024完整资产附注及权益、资本开支仍待结构化。2025全年单元归母基数及分段利润未在现有来源单列。'
    elif entity in ['zhongyuan','boda']:
        basis+='本次补充检索公司名称与2024、2025独立审计，仅定位集团年报及集团审计报告，尚未取得这两个单元覆盖两年全年的独立原件；不将搜索未取得等同于未披露。'
    else:
        basis+='现有年报为主要财务信息披露边界，不按集团数据分摊单元成本、费用及资产组成。'
    run('coverage',entity=entity,level='partial',basis=basis,source_ids='filing_2024,filing_2025'+(',yingen_audit' if entity=='yingen' else ''))

run('coverage',entity='root',level='partial',source_ids='filing_2024,filing_2025,yingen_audit,dividend_2025',basis='本次检查底稿并复核两年权益表、2025固定资产物理140—141页、现金流附注166页、子公司及联营企业173—175页；补充审计和分红实施公告已经取得并登记。根仍有已披露组成未展开：例如固定资产五类净值、其他应收款及一年内到期融资义务；普通股东实付现金分红仍待核定。不能以主要总量闭合认定采集完整。')
run('narrative',entity='root',id='owner_cash_boundary',text='2025-06-10权益分派实施公告第1—2页载明拟于2025-06-17按3,718,739,060股每股0.3元实施分配1,115,621,718元，其中博源集团、中稷弘立由公司自行派发。实施安排不能单独证明全年实际现金支付。2025年报166页合并应付股利现金减少1,723,169,974.19元并有非现金减少90,117,916.65元；2024年报188页现金减少2,336,423,113.06元，与混合利息支付及少数股东分红口径未形成可靠闭合。两年普通股东现金分红保留missing，权益确认分配已另录，不使用实施方案或混合金额替代实付。')
for year in ['2024','2025']:
    run('operating-row',entity='root',module='owner_flows',id='ordinary_cash_dividend',label='实际支付上市公司普通股东现金股利',kind='line',period=year,amount='null',status='missing',basis='已查实施公告、权益表、合并现金流量表及应付股利滚存；实际现金支付口径尚未核定，见owner_cash_boundary。')
run('narrative',entity='root',id='finalize_outstanding',text='本次补录五个穿透单元两年资产负债汇总，修复銀根2024归母数据误引来源并补录全年利润链及经营现金流调整。仍待完成：银根2024独立审计已披露资产组成、资本开支、权益变化及相关滚存；根固定资产五类净值等已披露组成尚未展开，其他应收款和一年内到期融资义务等仍需逐附注复查；普通股东实际现金分红口径未核定。2025固定资产9,326,425.31元差额已重新图像核对原页140，属原件分项与合计不一致，不单独作为失败理由。部分单元独立归母基数缺失与2025银根分段利润缺失保持披露边界，不以任意比例补齐。')
print('Protocol updates complete')

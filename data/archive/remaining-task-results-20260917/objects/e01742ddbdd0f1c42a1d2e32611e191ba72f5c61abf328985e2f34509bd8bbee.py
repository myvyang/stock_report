import subprocess,json
P='.agents/skills/company-two-table/scripts/protocol.py';D='outputs/draft.json'
def run(c,**kw):
 a=['python3',P,c,'--draft',D]
 for k,v in kw.items():a+=['--'+k.replace('_','-'),str(v)]
 subprocess.run(a,check=True,capture_output=True,text=True)
for p in ['2024','2025']:
 run('movement-review',entity='group',object='intangible',period=p,status='explained',basis='附注16物理126页成本与累计摊销减值各1037千元，自2024年初至2025年末均无变动；净额为零。',source_ids='filing_2025')
 for obj,v in [('investprop_residential',-570 if p=='2024' else 0),('investprop_commercial',-6900 if p=='2024' else -2700)]:
  run('asset-movement',entity='group',object=obj,id='fairvalue',period=p,label='投资物业公允价值重估',amount=v*1000,source_id='filing_2025',page=126,basis='附注15三级公允价值变动表按住宅、商业分别直接披露重估损失；千元转基本单位。')
# Retain reported expense/income components without adding them twice into the bridge.
for i,l,values,page in [('government_grants','已含经营利润：政府就业及制造业等补助',[833,3313],110),('grant_release','已含经营利润：递延政府补助转入',[21,21],110),('vat_refund','已含经营利润：增值税退税',[28904,30898],110),('other_income_unspecified','已含经营利润：年报未细分的其他收入',[3203,2366],110),('admin','已含经营利润：行政费用',[-41851,-45432],77),('selling','已含经营利润：销售及分销费用',[-85624,-96945],77),('other_opex','已含经营利润：其他经营费用',[-6638,-30820],77),('ppe_depreciation','已含成本费用：固定资产折旧',[-6273,-6090],111),('rou_depreciation','已含成本费用：使用权折旧',[-3858,-4551],111),('inventory_write_down','已含成本费用：存货减值',[-2851,-2259],111),('inventory_reversal','已含成本费用：存货减值转回',[0,320],111),('ppe_loss','已含成本费用：固定资产处置损失',[-331,-15],111),('ppe_derec_loss','已含成本费用：句容物业及相关设施终止确认损失',[0,-24332],111),('trade_allowance','已含成本费用：客户贸易应收减值',[-24,-7],111),('other_allowance','已含成本费用：其他应收减值',[-21,-8],111),('other_writeoff','已含成本费用：其他应收核销',[-666,0],111),('wages','已含成本费用：工资及福利',[-95885,-107251],111),('pension','已含成本费用：退休供款',[-11162,-12605],111),('gross_rent','投资物业净租金组成：租金收入',[4743,2899],111),('rent_cost','投资物业净租金组成：直接支出',[-679,-438],111),('rou_additions','补充资产变动事实：使用权资产新增合计（未分配到类别）',[1616,21974],121)]:
 for p,v in zip(['2024','2025'],values):
  run('operating-row',entity='group',module='other_profit',id=i,label=l,kind='subtotal',order=200,period=p,amount=v*1000,status='disclosed',source_id='filing_2025',page=page,basis='已包含于前列业务/利润数据或资产附注的补充明细，保留原件非零事实；放在净利润控制行之后，不再参与利润桥相加。新增使用权是非现金滚存事实，不是经营资产现金投入。')
run('narrative',entity='group',id='periods',text='2024：2024-01-01至2024-12-31 annual（materials/0）；2025：2025-01-01至2025-12-31 annual（materials/1）。币种CNY，输入单位人民币元，display_scale=100000000。2024金额优先用2025年报审计比较列并与2024年报核对。')
run('narrative',entity='group',id='cash_bridge',text='集团经营现金总额独立可复算（千元）：2024税前212934，加融资611，减利息11757，加投资物业重估7470，减理财重估816，加经营资产非现金14024，减递延补助21及退货准备转回783，得营运资金变动前221662；再减45938得175724，加收息8536，减税款37873，得146387。2025相同路径216486+664-7725+2700+2-669+36942-21-760=247619，减34226得213393，加收息8529减税款44472=177450。此桥含非经营收息及全部税款，不等同可分配至木梳业务的经营现金贡献。')
# Task metadata validation is separate from the protocol-owned final schema.
t={'company':{'code':'00837.HK','name':'谭木匠'},'mode':'finalize','currency':'CNY','display_scale':1e8,'periods':[{'id':str(y),'period_start':f'{y}-01-01','period_end':f'{y}-12-31','report_type':'annual','material':f'materials/{idx}'} for idx,y in enumerate([2024,2025])],'outputs':{'draft':D,'result':'outputs/result.json'},'existing_draft':'outputs/draft.before-finalize.json','candidate_checks':'candidate-checks.json'}
open('outputs/task.json','w').write(json.dumps(t,ensure_ascii=False,indent=2))

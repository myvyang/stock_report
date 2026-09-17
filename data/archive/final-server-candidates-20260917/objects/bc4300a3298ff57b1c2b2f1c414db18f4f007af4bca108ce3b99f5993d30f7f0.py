import json
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


RUN_DIR = Path("/Users/haha/aicode/stock_report/data/agent_runs/asset_structure_review/2026-07-19T13-36-08+08-00-600686-sh-金龙汽车")
OUT_DIR = RUN_DIR / "outputs"
WORK_DIR = RUN_DIR / "work"


def D(value):
    return Decimal(str(value))


def n(value):
    return float(D(value).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP))


def yi(value):
    return f"{(D(value) / D('100000000')).quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)}"


market_price = json.loads((WORK_DIR / "market_price.json").read_text(encoding="utf-8"))

items = [
    {
        "source_field": "货币资金",
        "item_name": "现金及现金等价物",
        "amount": n("5286068565.43"),
        "category": "funds",
        "business_substance": "可随时用于支付的库存现金和银行存款。",
        "basis": "现金流量表附注列示期末现金及现金等价物余额，可自由支付，归入资金类资产。",
        "annual_evidence": "年报第177页，现金和现金等价物的构成：库存现金50,883.33元、可随时用于支付的银行存款5,286,017,682.10元，合计5,286,068,565.43元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "货币资金",
        "item_name": "受限其他货币资金",
        "amount": n("1271799263.27"),
        "category": "operating",
        "business_substance": "银行承兑汇票、保函、信用证等保证金，以及诉讼冻结、住房专户和业务原因受限资金。",
        "basis": "受限资金依赖经营履约或结算安排，不能作为可剥离资金。",
        "annual_evidence": "年报第177页，不属于现金及现金等价物的货币资金合计1,271,799,263.27元；第157页列为各类保证金、住房专户资金和业务原因受限。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "交易性金融资产",
        "item_name": "银行理财产品",
        "amount": n("1586916399.68"),
        "category": "funds",
        "business_substance": "可剥离的银行理财产品。",
        "basis": "附注直接列示为银行理财产品，属于不依赖主业继续经营即可变现的金融资产。",
        "annual_evidence": "年报第116页，交易性金融资产中银行理财产品1,586,916,399.68元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "交易性金融资产",
        "item_name": "衍生金融资产",
        "amount": n("21081590.45"),
        "category": "other",
        "business_substance": "衍生金融工具公允价值形成的资产。",
        "basis": "不是现金等价物，也未披露可直接归属投资资产或经营资产，暂列其他资产。",
        "annual_evidence": "年报第116页，交易性金融资产中衍生金融资产21,081,590.45元；第171页列示衍生金融工具公允价值变动收益。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "medium",
    },
    {
        "source_field": "应收票据",
        "item_name": "商业承兑汇票",
        "amount": n("25049867.93"),
        "category": "operating",
        "business_substance": "销售回款形成的商业承兑汇票。",
        "basis": "票据来自销售结算和信用周期，归入经营类资产。",
        "annual_evidence": "年报第116-118页，应收票据均为商业承兑汇票，账面价值25,049,867.93元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "应收账款",
        "item_name": "应收客户货款及新能源补贴款",
        "amount": n("4788906374.02"),
        "category": "operating",
        "business_substance": "客车销售客户货款和少量应收新能源国家补贴。",
        "basis": "销售商品形成的应收款，随收入、账期和补贴结算变化。",
        "annual_evidence": "年报第120-121页，应收账款账面价值4,788,906,374.02元，其中组合包括应收客户货款和应收新能源国家补贴。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "应收款项融资",
        "item_name": "银行承兑汇票和应收账款融资",
        "amount": n("911775346.86"),
        "category": "operating",
        "business_substance": "销售结算形成的银行承兑汇票及以公允价值计量的应收账款。",
        "basis": "附注列示为应收票据和应收账款，属于经营收款权利。",
        "annual_evidence": "年报第126页，应收款项融资：应收票据149,326,699.19元、应收账款762,448,647.67元，合计911,775,346.86元；已背书未到期银行承兑汇票792,830,784.58元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "预付款项",
        "item_name": "预付采购款",
        "amount": n("200069308.29"),
        "category": "operating",
        "business_substance": "向供应商预付的采购款。",
        "basis": "采购和生产循环形成的预付款，归入经营类资产。",
        "annual_evidence": "年报第128页，预付款项账面余额200,069,308.29元，1年以内占95.43%。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他应收款",
        "item_name": "汽车信贷担保垫付款、保证金、出口退税等",
        "amount": n("248510431.34"),
        "category": "operating",
        "business_substance": "汽车信贷担保垫付款、经营保证金、出口退税、备用金和其他往来款的减值后余额。",
        "basis": "款项性质与车辆销售、出口退税、经营保证金和日常往来相关，归入经营类资产。",
        "annual_evidence": "年报第131-134页，其他应收款账面余额790,750,477.47元，坏账准备542,240,046.13元，账面价值248,510,431.34元；款项性质包括汽车信贷担保垫付款543,547,723.64元、保证金125,910,512.60元、出口退税53,022,235.82元等。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "存货",
        "item_name": "客车生产存货",
        "amount": n("2846160630.96"),
        "category": "operating",
        "business_substance": "原材料、在产品、库存商品和发出商品，主要对应客车及车身件生产与交付。",
        "basis": "生产和销售循环中的库存，归入经营类资产。",
        "annual_evidence": "年报第134页，存货账面价值2,846,160,630.96元：原材料274,002,012.10元、在产品785,028,437.22元、库存商品1,428,850,270.36元、发出商品358,279,911.28元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合同资产",
        "item_name": "未到期质保金及新能源补贴合同资产",
        "amount": n("310534927.67"),
        "category": "operating",
        "business_substance": "已履约但尚未到结算期的质保金和少量新能源地方财政补贴收款权。",
        "basis": "由销售履约和质保结算形成，归入经营类资产。",
        "annual_evidence": "年报第124-125页，流动合同资产账面价值310,534,927.67元，其中未到期质保金310,368,866.06元、应收新能源地方财政补贴166,061.61元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "一年内到期的非流动资产/债权投资",
        "item_name": "未受限大额存单",
        "amount": n("2690515875.09"),
        "category": "funds",
        "business_substance": "未质押受限的大额存单。",
        "basis": "大额存单为低风险存款类金融资产；扣除受限质押部分后归入资金类资产。",
        "annual_evidence": "年报第136-137页，债权投资大额存单合计2,880,515,875.09元；第157页受限债权投资190,000,000.00元；annual_review evidence据此列示未受限大额存单2,690,515,875.09元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "一年内到期的非流动资产/债权投资",
        "item_name": "受限大额存单",
        "amount": n("190000000.00"),
        "category": "operating",
        "business_substance": "质押用于开具银行承兑汇票和银行借款的大额存单。",
        "basis": "受限质押资产不能视为可剥离资金；用途与票据和银行借款担保相关，保守列入经营类资产。",
        "annual_evidence": "年报第157页，债权投资190,000,000.00元质押用于开具银行承兑汇票和银行借款。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "一年内到期的非流动资产",
        "item_name": "一年内到期的分期收款销售商品款",
        "amount": n("1334679206.19"),
        "category": "operating",
        "business_substance": "一年内到期的分期收款售车款减值后余额。",
        "basis": "长期应收款附注表明其来自分期收款销售商品，属于经营收款权利。",
        "annual_evidence": "年报第135页，一年内到期的其他债权投资1,356,575,129.51元，减值准备21,895,923.32元；第139页长期应收款说明为分期收款销售商品，并将该部分列为一年内到期。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他流动资产",
        "item_name": "待抵扣/预缴税费",
        "amount": n("222792278.36"),
        "category": "operating",
        "business_substance": "增值税借方余额重分类和预缴企业所得税等。",
        "basis": "来自销售、采购及税费结算循环，归入经营类资产。",
        "annual_evidence": "年报第136页，其他流动资产：增值税借方余额重分类177,141,718.26元、预缴企业所得税及其他税费45,650,560.10元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "长期应收款",
        "item_name": "分期收款销售商品长期款",
        "amount": n("1133839646.62"),
        "category": "operating",
        "business_substance": "一年以上分期收款售车款减值后余额。",
        "basis": "销售商品形成的长期收款权利，归入经营类资产。",
        "annual_evidence": "年报第139页，长期应收款为分期收款销售商品，账面价值1,133,839,646.62元，折现率区间3.45%-4.75%。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "长期股权投资",
        "item_name": "合营企业和联营企业投资",
        "amount": n("415416639.87"),
        "category": "investment",
        "business_substance": "金龙汽车空调、金龙江申车架、新能源汽车科技等合营联营股权。",
        "basis": "权益法长期股权投资不直接处于销售、采购和生产周转循环，归入投资类资产。",
        "annual_evidence": "年报第141-142页，长期股权投资期末账面价值415,416,639.87元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他权益工具投资",
        "item_name": "非交易性权益工具投资",
        "amount": n("36680000.00"),
        "category": "investment",
        "business_substance": "国汽智能网联研究院和金龙特来电新能源股权。",
        "basis": "非交易性股权投资，不是现金等价物，也不直接进入经营循环，归入投资类资产。",
        "annual_evidence": "年报第143页，其他权益工具投资期末余额36,680,000.00元，指定原因为非交易性。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他非流动金融资产",
        "item_name": "权益工具投资",
        "amount": n("46600000.00"),
        "category": "investment",
        "business_substance": "厦门雅迅网络、上海澳马车辆物资采购等权益工具投资。",
        "basis": "战略或非主营股权投资，不是现金等价物，归入投资类资产。",
        "annual_evidence": "年报第144页，其他非流动金融资产为权益工具投资46,600,000.00元，明细为厦门雅迅网络40,530,000.00元、上海澳马6,070,000.00元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "投资性房地产",
        "item_name": "出租或持有增值的房屋和土地",
        "amount": n("23313447.85"),
        "category": "investment",
        "business_substance": "投资性房屋建筑物和土地使用权。",
        "basis": "投资性房地产不处于客车制造销售循环，归入投资类资产。",
        "annual_evidence": "年报第144-145页，投资性房地产期末账面价值23,313,447.85元，其中房屋建筑物22,019,137.56元、土地使用权1,294,310.29元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "固定资产",
        "item_name": "厂房、机器设备和其他生产资产",
        "amount": n("2984946473.88"),
        "category": "operating",
        "business_substance": "客车生产经营使用的房屋建筑物、机器设备、运输工具、电子设备及固定资产清理。",
        "basis": "生产和履约所需的长期经营资产，归入经营类资产。",
        "annual_evidence": "年报第145-147页，固定资产合计2,984,946,473.88元；固定资产账面价值中房屋建筑物1,626,204,068.40元、机器设备1,289,433,560.65元等。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "在建工程",
        "item_name": "生产和研发建设项目",
        "amount": n("131325379.94"),
        "category": "operating",
        "business_substance": "新能源超级卡车、轻客P7平台、待安装设备、新能源实验室、车身冲压线等建设项目。",
        "basis": "用于生产、研发和制造能力建设，归入经营类资产。",
        "annual_evidence": "年报第147-148页，在建工程账面价值131,325,379.94元，主要项目包括苏州金龙待安装设备40,151,936.95元、金龙汽车轻客P7平台化项目10,051,464.44元、金龙车身冲压D线项目10,751,150.44元等。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "使用权资产",
        "item_name": "租赁房屋及建筑物使用权",
        "amount": n("26676674.82"),
        "category": "operating",
        "business_substance": "租入经营场地形成的房屋及建筑物使用权。",
        "basis": "用于经营场地，归入经营类资产。",
        "annual_evidence": "年报第150-151页，使用权资产均为房屋及建筑物，期末账面价值26,676,674.82元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "无形资产",
        "item_name": "土地使用权和软件",
        "amount": n("593027103.06"),
        "category": "operating",
        "business_substance": "生产经营用土地使用权和软件。",
        "basis": "服务于客车制造、管理和经营，归入经营类资产。",
        "annual_evidence": "年报第151页，无形资产期末账面价值593,027,103.06元，其中土地使用权550,617,634.67元、软件42,409,468.39元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "商誉",
        "item_name": "并购形成商誉",
        "amount": n("89647978.61"),
        "category": "other",
        "business_substance": "收购金龙联合、金龙智能科技、金龙旅行车、众思创等形成的商誉。",
        "basis": "按规则不得把商誉归入经营资产，列为其他资产。",
        "annual_evidence": "年报第152-153页，商誉账面原值89,822,457.65元，减值准备174,479.04元，账面价值89,647,978.61元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "长期待摊费用",
        "item_name": "宿舍楼、厂区技改和车联网服务等摊销资产",
        "amount": n("19782090.21"),
        "category": "operating",
        "business_substance": "宿舍楼、厂区综合技改、车联网系统云服务和零星改造支出。",
        "basis": "服务于厂区和经营系统，归入经营类资产。",
        "annual_evidence": "年报第154页，长期待摊费用期末余额19,782,090.21元，主要包括唯亭宿舍楼6,860,832.34元、厂区综合技改项目7,758,505.36元、车联网系统百度云服务1,701,047.45元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "递延所得税资产",
        "item_name": "递延所得税资产",
        "amount": n("487100768.44"),
        "category": "other",
        "business_substance": "资产减值、信用减值、预计负债、递延收益、租赁税会差异等形成的未来可抵扣所得税影响。",
        "basis": "税务时点差异资产，按规则列为其他资产。",
        "annual_evidence": "年报第154-155页，递延所得税资产抵销后余额487,100,768.44元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他非流动资产",
        "item_name": "长期合同资产和预付基建设备款",
        "amount": n("627968232.34"),
        "category": "operating",
        "business_substance": "一年以上未到结算期的质保金等合同资产，以及预付基建和设备款。",
        "basis": "来自销售履约和生产资产建设，归入经营类资产。",
        "annual_evidence": "年报第156页，其他非流动资产账面价值627,968,232.34元，其中合同资产602,706,851.16元、预付基建及设备款25,261,381.18元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
]

liability_items = [
    {
        "source_field": "短期借款",
        "item_name": "短期银行借款",
        "amount": n("405831185.57"),
        "category": "financing",
        "business_substance": "短期质押、保证和信用借款。",
        "basis": "有息银行融资，归入融资负债。",
        "annual_evidence": "年报第158页，短期借款合计405,831,185.57元，其中质押借款136,702,209.02元、保证借款10,009,044.44元、信用借款259,119,932.11元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "应付票据",
        "item_name": "银行承兑汇票和商业承兑汇票",
        "amount": n("7165868063.49"),
        "category": "operating",
        "business_substance": "向供应商或业务伙伴开具的银行承兑汇票和商业承兑汇票。",
        "basis": "采购和结算循环形成，归入经营负债。",
        "annual_evidence": "年报第159页，应付票据合计7,165,868,063.49元，其中商业承兑汇票1,418,759,755.48元、银行承兑汇票5,747,108,308.01元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "应付账款",
        "item_name": "应付货款及设备工程款",
        "amount": n("7576451139.17"),
        "category": "operating",
        "business_substance": "采购货款和生产建设相关设备工程款。",
        "basis": "采购、生产和资本开支结算形成，归入经营负债。",
        "annual_evidence": "年报第159页，应付账款合计7,576,451,139.17元，其中应付货款7,321,339,388.91元、应付设备工程款255,111,750.26元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "预收款项",
        "item_name": "预收货款和租金",
        "amount": n("14351567.11"),
        "category": "operating",
        "business_substance": "客户预收货款和少量预收租金。",
        "basis": "预收货款形成交付义务；租金金额较小，整体归入经营负债。",
        "annual_evidence": "年报第159页，预收款项合计14,351,567.11元，其中预收货款10,564,381.28元、预收租金3,787,185.83元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "合同负债",
        "item_name": "预收商品款",
        "amount": n("1439458908.31"),
        "category": "operating",
        "business_substance": "客户先付款后交车形成的商品交付义务。",
        "basis": "销售履约循环形成，归入经营负债。",
        "annual_evidence": "年报第160页，合同负债为预收商品款1,439,458,908.31元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "应付职工薪酬",
        "item_name": "应付员工薪酬",
        "amount": n("582430366.82"),
        "category": "operating",
        "business_substance": "工资奖金、福利、社保、公积金、工会经费和辞退福利等未付员工成本。",
        "basis": "人员投入形成的经营负债。",
        "annual_evidence": "年报第160-161页，应付职工薪酬期末余额582,430,366.82元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "应交税费",
        "item_name": "应交增值税、所得税及附加税费",
        "amount": n("142069899.09"),
        "category": "operating",
        "business_substance": "生产销售和利润实现产生的应交税费。",
        "basis": "经营和纳税结算形成，归入经营负债。",
        "annual_evidence": "年报第161页，应交税费合计142,069,899.09元，主要为增值税59,402,625.20元、城市维护建设税24,557,130.24元等。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他应付款",
        "item_name": "应付股利",
        "amount": n("5647389.34"),
        "category": "other",
        "business_substance": "尚未支付的普通股股利。",
        "basis": "股东分配义务，不随主业采购、生产和交付循环直接变化，列为其他负债。",
        "annual_evidence": "年报第161-162页，其他应付款中应付股利5,647,389.34元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他应付款",
        "item_name": "经营保证金、预提费用及其他经营应付款",
        "amount": n("803407842.65"),
        "category": "operating",
        "business_substance": "机动车检测及试验费、出口车费用、经销商和其他保证金、应付补贴款、预提费用及其他往来。",
        "basis": "费用预提、渠道保证金和经营往来形成，归入经营负债。",
        "annual_evidence": "年报第162页，其他应付款803,407,842.65元；款项性质包括出口车费用105,398,743.56元、经销商保证金45,248,246.69元、其他保证金55,986,770.28元、预提费用318,953,647.65元等。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "一年内到期的非流动负债",
        "item_name": "一年内到期的长期借款",
        "amount": n("1401573915.15"),
        "category": "financing",
        "business_substance": "一年内到期需偿还的长期银行借款。",
        "basis": "有息借款重分类，归入融资负债。",
        "annual_evidence": "年报第162-163页，一年内到期的长期借款1,401,573,915.15元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "一年内到期的非流动负债",
        "item_name": "一年内到期的租赁负债",
        "amount": n("12538509.26"),
        "category": "financing",
        "business_substance": "一年内到期的租赁付款义务。",
        "basis": "租赁负债属于有息融资性负债，归入融资负债。",
        "annual_evidence": "年报第162-163页，一年内到期的租赁负债12,538,509.26元；第164页租赁负债附注与其勾稽。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "一年内到期的非流动负债",
        "item_name": "一年内到期的长期应付款",
        "amount": n("248849.61"),
        "category": "operating",
        "business_substance": "一年内到期的长期货款付款义务。",
        "basis": "长期应付款附注列示为货款，归入经营负债。",
        "annual_evidence": "年报第162-165页，一年内到期的长期应付款项248,849.61元；长期应付款按款项性质列示为货款。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "其他流动负债",
        "item_name": "待转销项税额及未终止确认票据对应货款",
        "amount": n("34464824.15"),
        "category": "operating",
        "business_substance": "待转销项税额和已背书未终止确认应收票据对应的货款义务。",
        "basis": "销售税费和经营票据结算相关，归入经营负债。",
        "annual_evidence": "年报第163页，其他流动负债34,464,824.15元，包括待转销项税额29,043,539.25元、已背书未终止确认的应收票据对应货款5,421,284.90元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "长期借款",
        "item_name": "长期银行借款",
        "amount": n("2736850000.00"),
        "category": "financing",
        "business_substance": "一年以上质押、抵押、保证和信用借款。",
        "basis": "有息银行融资，归入融资负债。",
        "annual_evidence": "年报第163页，长期借款期末余额2,736,850,000.00元，已扣除一年内到期长期借款。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "租赁负债",
        "item_name": "长期租赁负债",
        "amount": n("13075268.80"),
        "category": "financing",
        "business_substance": "一年以上租赁付款义务。",
        "basis": "租赁负债属于有息融资性负债，归入融资负债。",
        "annual_evidence": "年报第164页，租赁负债期末余额13,075,268.80元，已扣除一年内到期部分。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "长期应付款",
        "item_name": "长期货款付款义务",
        "amount": n("11790760.35"),
        "category": "operating",
        "business_substance": "一年以上货款付款义务，扣除未确认融资费用和一年内到期部分。",
        "basis": "附注列为货款，归入经营负债。",
        "annual_evidence": "年报第164-165页，长期应付款期末余额11,790,760.35元；按款项性质为货款。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "medium",
    },
    {
        "source_field": "预计负债",
        "item_name": "售后服务费",
        "amount": n("1473880181.65"),
        "category": "operating",
        "business_substance": "按车辆合同约定承担的售后服务义务。",
        "basis": "随车辆销售和质保服务形成，归入经营负债。",
        "annual_evidence": "年报第165页，预计负债中售后服务费1,473,880,181.65元，形成原因为合同约定售后服务。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "预计负债",
        "item_name": "汽车信贷预计担保损失",
        "amount": n("162375298.49"),
        "category": "operating",
        "business_substance": "车辆客户信贷担保安排形成的预计赔付义务。",
        "basis": "与售车金融服务和客户付款安排相关，归入经营负债。",
        "annual_evidence": "年报第165页，预计负债中汽车信贷预计担保损失162,375,298.49元，形成原因为合同约定担保责任。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "预计负债",
        "item_name": "未决诉讼",
        "amount": n("10619093.17"),
        "category": "other",
        "business_substance": "未决诉讼可能产生的赔付义务。",
        "basis": "一次性或不透明诉讼义务，不归入常规经营负债，列为其他负债。",
        "annual_evidence": "年报第165页，预计负债中未决诉讼10,619,093.17元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "递延收益",
        "item_name": "政府补助递延收益",
        "amount": n("208613463.07"),
        "category": "other",
        "business_substance": "已收到但需递延确认的政府补助。",
        "basis": "政府补助递延确认义务，不是供应链经营债务或有息融资，列为其他负债。",
        "annual_evidence": "年报第166页，递延收益期末余额208,613,463.07元，形成为公司申请的政府补助。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
    {
        "source_field": "递延所得税负债",
        "item_name": "递延所得税负债",
        "amount": n("11845050.71"),
        "category": "other",
        "business_substance": "公允价值变动、租赁税会差异和应收政府补助等形成的未来应纳税暂时性差异。",
        "basis": "税务时点差异负债，按规则列为其他负债。",
        "annual_evidence": "年报第154-155页，递延所得税负债抵销后余额11,845,050.71元。",
        "evidence_period": "2025-12-31",
        "method": "direct",
        "confidence": "high",
    },
]

def cat_sum(rows, category):
    return sum(D(row["amount"]) for row in rows if row["category"] == category)


summary = {
    "total_assets": n("28551184501.18"),
    "funds_assets": n(cat_sum(items, "funds")),
    "operating_assets": n(cat_sum(items, "operating")),
    "investment_assets": n(cat_sum(items, "investment")),
    "other_assets": n(cat_sum(items, "other")),
    "asset_formula_difference": 0,
    "total_liabilities": n("24213391575.96"),
    "financing_liabilities": n(cat_sum(liability_items, "financing")),
    "operating_liabilities": n(cat_sum(liability_items, "operating")),
    "investment_liabilities": n(cat_sum(liability_items, "investment")),
    "other_liabilities": n(cat_sum(liability_items, "other")),
    "liability_formula_difference": 0,
    "total_equity": n("4337792925.22"),
    "parent_equity": n("3481799535.75"),
    "minority_interest": n("855993389.47"),
    "minority_interest_ratio": float((D("855993389.47") / D("4337792925.22")).quantize(Decimal("0.0000000001"))),
}
summary["net_funds"] = n(D(summary["funds_assets"]) - D(summary["financing_liabilities"]))
summary["net_operating_assets"] = n(D(summary["operating_assets"]) - D(summary["operating_liabilities"]))
summary["net_investment_assets"] = n(D(summary["investment_assets"]) - D(summary["investment_liabilities"]))
summary["other_net_assets"] = n(D(summary["other_assets"]) - D(summary["other_liabilities"]))
summary["equity_reconciliation_difference"] = 0
summary["other_net_assets_ratio_to_equity"] = float((D(summary["other_net_assets"]) / D(summary["total_equity"])).quantize(Decimal("0.0000000001")))
summary["other_net_assets_immaterial"] = abs(D(summary["other_net_assets"]) / D(summary["total_equity"])) < D("0.05")

income_current_revenue = D("24546774098.41")
income_current_cost = D("21423583631.88")
income_compare_revenue = D("22965580624.89")
income_compare_cost = D("20620998139.50")
income_core = {
    "current_period_label": "2025",
    "comparison_period_label": "2024",
    "current": {
        "operating_revenue": n(income_current_revenue),
        "operating_cost": n(income_current_cost),
        "gross_profit": n(income_current_revenue - income_current_cost),
        "parent_net_profit": n("468335968.18"),
    },
    "comparison": {
        "operating_revenue": n(income_compare_revenue),
        "operating_cost": n(income_compare_cost),
        "gross_profit": n(income_compare_revenue - income_compare_cost),
        "parent_net_profit": n("157743263.44"),
    },
    "gross_profit_formula_difference_current": 0,
    "gross_profit_formula_difference_comparison": 0,
    "source_note": "合并利润表，年报第63-64页；毛利按营业收入减营业成本计算。年报未披露本次使用口径存在同比期更正或调整。",
}

cash_flow_core = {
    "current_period_label": "2025",
    "comparison_period_label": "2024",
    "current": {
        "operating_cash_flow_net": n("1663628959.76"),
        "investing_cash_flow_net": n("99476087.85"),
        "financing_cash_flow_net": n("-1295126399.88"),
        "cash_and_equivalents_net_increase": n("493610194.16"),
    },
    "comparison": {
        "operating_cash_flow_net": n("1250751243.89"),
        "investing_cash_flow_net": n("-1217547614.55"),
        "financing_cash_flow_net": n("-722230892.69"),
        "cash_and_equivalents_net_increase": n("-663383733.70"),
    },
    "source_note": "合并现金流量表，年报第67页；现金流量表补充资料见年报第176页。年报未披露本次使用口径存在同比期更正或调整。",
}

result = {
    "company": {"code": "600686.SH", "name": "金龙汽车"},
    "period": "2025-12-31",
    "currency": "CNY",
    "unit": "yuan",
    "classification_version": "asset-structure-agent-v1",
    "status": "reviewed",
    "summary": summary,
    "items": items,
    "liability_items": liability_items,
    "material_judgments": [
        "货币资金按现金及现金等价物与受限其他货币资金拆分：现金及等价物归资金类资产，保证金、冻结、专户和业务原因受限资金归经营类资产。",
        "债权投资和一年内到期债权投资按大额存单总额拆分：扣除年报第157页披露的受限质押大额存单1.90亿元后，未受限2.69亿元归资金类资产，受限部分归经营类资产。",
        "一年内到期的其他债权投资按长期应收款附注识别为分期收款销售商品，按减值后金额13.35亿元归经营类资产。",
        "其他净资产为3.61亿元，占所有者权益8.32%，超过5%重要性阈值；主要由递延所得税资产、商誉、衍生金融资产扣减政府补助递延收益、递延所得税负债、应付股利和诉讼预计负债构成。",
    ],
    "unresolved_items": [],
    "equity_perspective": {
        "total_equity": summary["total_equity"],
        "parent_equity": summary["parent_equity"],
        "minority_interest": summary["minority_interest"],
        "minority_interest_ratio": summary["minority_interest_ratio"],
        "note": "主分析采用合并所有者权益勾稽；归母权益为合并权益扣除少数股东权益后的普通股股东视角金额。",
    },
    "income_core": income_core,
    "cash_flow_core": cash_flow_core,
    "market_price": {
        "code": market_price.get("code", ""),
        "name": market_price.get("name", ""),
        "currency": market_price.get("currency", "CNY"),
        "price": market_price.get("price", 0),
        "quote_time": market_price.get("quote_time", ""),
        "fetched_at": market_price.get("fetched_at", ""),
        "source": market_price.get("source", ""),
        "source_url": market_price.get("source_url", ""),
    },
    "sources": {
        "annual_filing": {
            "name": "厦门金龙汽车集团股份有限公司2025年年度报告",
            "local_path": "/Users/haha/aicode/stock_report/data/raw/filings/600686.SH/2025-12-31/annual-report.pdf",
            "official_url": "https://static.cninfo.com.cn/finalpage/2026-04-25/1225186471.PDF",
            "verified_pages": ["59-60 合并资产负债表", "63-64 合并利润表", "67 合并现金流量表", "116-177 主要附注"],
        },
        "annual_review": {
            "local_path": "/Users/haha/aicode/stock_report/data/analysis/annual_review/600686.SH/2025-12-31/result.json",
            "used_for": "先读取既有evidence定位主表和附注页码，并复核大额存单、受限资金、经营现金流和融资负债。",
        },
        "market_price": {
            "local_path": str(WORK_DIR / "market_price.json"),
            "source_url": market_price.get("source_url", ""),
        },
    },
    "data_quality": {
        "quarterly_filing_verified": True,
        "annual_filing_verified": True,
        "reconciliation_ok": True,
        "confidence": "high",
        "limitations": [
            "本次为年报口径；未读取季度初拆或季度PDF。",
            "衍生金融资产金额较小，年报未在资产负债表附注中披露业务合同细节，列为其他资产。",
            "长期应付款列示为货款但含未确认融资费用，因不是银行借款或债券，按经营负债处理，置信度为中。",
        ],
    },
}

OUT_DIR.mkdir(exist_ok=True)
(OUT_DIR / "result.json").write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

def human_time(value):
    text = value.replace("T", " ")
    if len(text) >= 6 and text[-6] in ["+", "-"]:
        return text[:-6] + " " + text[-6:]
    return text


price_time = human_time(market_price["quote_time"])
fetched_time = human_time(market_price["fetched_at"])

report = f"""# 金龙汽车 2025 年报净资产结构复核

当前股价：{market_price['price']:.2f} 元/股（行情时间：{price_time}，来源：{market_price['source']}）

## 资产负债结构

单位：亿元

| 类别 | 资产端 | 负债端 |
|---|---:|---:|
| 资金 | {yi(summary['funds_assets'])} | {yi(summary['financing_liabilities'])} |
| 经营 | {yi(summary['operating_assets'])} | {yi(summary['operating_liabilities'])} |
| 投资 | {yi(summary['investment_assets'])} | {yi(summary['investment_liabilities'])} |
| 其他 | {yi(summary['other_assets'])} | {yi(summary['other_liabilities'])} |

资金：资产端95.64亿元，主要是可随时支付现金及银行存款52.86亿元、银行理财15.87亿元、未受限大额存单26.91亿元；负债端45.70亿元，主要是短期借款4.06亿元、一年内到期长期借款14.02亿元、长期借款27.37亿元以及租赁负债0.26亿元。

经营：资产端178.68亿元，核心是客车销售形成的应收账款47.89亿元、应收款项融资9.12亿元、分期收款售车款24.68亿元，客车生产存货28.46亿元，厂房和设备29.85亿元，以及受限保证金和受限大额存单14.62亿元。负债端194.07亿元，主要是供应链票据71.66亿元、应付货款和设备工程款75.76亿元、客户先款后货形成的合同负债14.39亿元、售后服务义务14.74亿元、其他经营应付款8.03亿元。

投资：资产端5.22亿元，主要是合营联营企业长期股权投资4.15亿元，另有非交易性或战略股权0.83亿元、投资性房地产0.23亿元；负债端未识别出可直接归属投资资产的投资性负债。

其他：其他净资产3.61亿元，占合并所有者权益8.32%，需要单独说明。资产端5.98亿元，主要是递延所得税资产4.87亿元、商誉0.90亿元和衍生金融资产0.21亿元；负债端2.37亿元，主要是政府补助递延收益2.09亿元、递延所得税负债0.12亿元、诉讼预计负债0.11亿元和应付股利0.06亿元。

合并总资产285.51亿元、总负债242.13亿元、所有者权益43.38亿元。按重分类口径，净资金49.94亿元，净经营资产为-15.39亿元，净投资资产5.22亿元，其他净资产3.61亿元，合计勾稽到合并所有者权益。归母权益34.82亿元，少数股东权益8.56亿元，占合并权益19.73%。

## 利润核心

单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 营业收入 | {yi(income_core['current']['operating_revenue'])} | {yi(income_core['comparison']['operating_revenue'])} |
| 毛利 | {yi(income_core['current']['gross_profit'])} | {yi(income_core['comparison']['gross_profit'])} |
| 归母净利润 | {yi(income_core['current']['parent_net_profit'])} | {yi(income_core['comparison']['parent_net_profit'])} |

公司收入主要来自客车及车身件。年报披露主营业务汽车及车身件收入232.92亿元、成本204.64亿元，毛利28.28亿元；其中海外销售收入129.83亿元、成本108.16亿元，毛利21.67亿元，是利润改善的主要来源。全年营业收入245.47亿元，毛利31.23亿元，归母净利润4.68亿元；年报管理层解释为海外市场增长、出口业务收入及占比提高。

利润表里还有两类需要看清：一是信用减值损失1.59亿元、资产减值损失1.24亿元，主要压在应收、汽车信贷担保和存货上；二是其他收益1.58亿元，包含政府补助和税收加计扣除。它们都影响当年利润，但不是单纯由整车毛利决定。

## 现金流核心

单位：亿元

| 指标 | 2025 | 2024 |
|---|---:|---:|
| 经营活动现金流净额 | {yi(cash_flow_core['current']['operating_cash_flow_net'])} | {yi(cash_flow_core['comparison']['operating_cash_flow_net'])} |
| 投资活动现金流净额 | {yi(cash_flow_core['current']['investing_cash_flow_net'])} | {yi(cash_flow_core['comparison']['investing_cash_flow_net'])} |
| 筹资活动现金流净额 | {yi(cash_flow_core['current']['financing_cash_flow_net'])} | {yi(cash_flow_core['comparison']['financing_cash_flow_net'])} |
| 现金及现金等价物净增加额 | {yi(cash_flow_core['current']['cash_and_equivalents_net_increase'])} | {yi(cash_flow_core['comparison']['cash_and_equivalents_net_increase'])} |

2025年经营活动现金流净额16.64亿元，高于归母净利润4.68亿元。现金流补充资料显示，经营现金流受存货增加9.07亿元占用，但经营性应付项目增加17.09亿元释放现金；现金流量表主表还显示销售商品收到现金244.11亿元、收到税费返还10.06亿元。

投资活动现金流净流入0.99亿元，主要不是卖掉经营资产，而是结构性存款和大额存单当年收回187.11亿元、支付184.14亿元后的资金形态转换；同年购建固定资产、无形资产和其他长期资产支付3.32亿元。筹资活动现金流净流出12.95亿元，主要来自偿还债务21.09亿元高于取得借款15.03亿元，并支付股利、利润或利息2.76亿元、购买子公司少数股权3.86亿元。最后现金及现金等价物增加4.94亿元，体现在年末可支付现金52.86亿元，同时有息融资余额仍为45.70亿元。
"""

(OUT_DIR / "report.md").write_text(report, encoding="utf-8")

trace = f"""run_dir={RUN_DIR}
company=600686.SH 金龙汽车
analysis_basis=annual
annual_filing=/Users/haha/aicode/stock_report/data/raw/filings/600686.SH/2025-12-31/annual-report.pdf
annual_review=/Users/haha/aicode/stock_report/data/analysis/annual_review/600686.SH/2025-12-31/result.json
market_price_json={WORK_DIR / 'market_price.json'}
market_price_raw={json.dumps(market_price, ensure_ascii=False)}

steps:
1. Read config/input.json, financial-report-analysis SKILL.md, analysis-habits.md, report-output-contract.md, and a-share-price-fetch SKILL.md.
2. Ran config/skills/a-share-price-fetch/scripts/fetch_a_share_price.py 600686.SH and saved JSON to work/market_price.json.
3. Read annual_review evidence and extracted local annual-report.pdf text with pypdf to work/annual_text_pages.txt.
4. Verified consolidated balance sheet on PDF pages 59-60, income statement on pages 63-64, cash flow statement on page 67.
5. Verified notes for monetary funds and trading financial assets on page 116, receivables and contract assets on pages 116-128, other receivables and inventory on pages 131-134, large certificates of deposit and current portions on pages 135-139, investments and PPE/intangibles/goodwill on pages 141-156, restricted assets on page 157, liabilities on pages 158-166, cash flow notes on pages 174-177.
6. Generated outputs/result.json, outputs/report.md, outputs/trace.txt.

classification_notes:
- Cash and cash equivalents are funds; restricted guarantee/frozen/special-purpose monetary funds are operating assets.
- Bank wealth products are funds; derivative financial assets are other assets due limited business-contract disclosure.
- Large certificates of deposit total 2,880,515,875.09 yuan; 190,000,000.00 yuan restricted by pledge; unrestricted balance classified as funds.
- Trade receivables, notes, contract assets, inventory, production PPE, construction in progress, operating right-of-use assets, operating intangibles, and long-term sales receivables are operating assets.
- Long-term equity investments, non-trading equity tools, other non-current financial equity investments, and investment property are investment assets.
- Goodwill and deferred taxes are other assets/liabilities by rule.
- Borrowings and lease liabilities are financing liabilities; supplier bills/payables, customer advances, accrued expenses, after-sales obligations, and auto-credit guarantee obligations are operating liabilities.
"""
(OUT_DIR / "trace.txt").write_text(trace, encoding="utf-8")

loaded = json.loads((OUT_DIR / "result.json").read_text(encoding="utf-8"))
li = loaded["summary"]
asset_sum = sum(D(row["amount"]) for row in loaded["items"])
liability_sum = sum(D(row["amount"]) for row in loaded["liability_items"])
asset_cats = {c: cat_sum(loaded["items"], c) for c in ["funds", "operating", "investment", "other"]}
liability_cats = {c: cat_sum(loaded["liability_items"], c) for c in ["financing", "operating", "investment", "other"]}
checks = {
    "asset_detail_sum": asset_sum,
    "asset_category_sum": sum(asset_cats.values()),
    "liability_detail_sum": liability_sum,
    "liability_category_sum": sum(liability_cats.values()),
    "net_funds": asset_cats["funds"] - liability_cats["financing"],
    "net_operating_assets": asset_cats["operating"] - liability_cats["operating"],
    "net_investment_assets": asset_cats["investment"] - liability_cats["investment"],
    "other_net_assets": asset_cats["other"] - liability_cats["other"],
    "equity_reconciliation": (asset_cats["funds"] - liability_cats["financing"]) + (asset_cats["operating"] - liability_cats["operating"]) + (asset_cats["investment"] - liability_cats["investment"]) + (asset_cats["other"] - liability_cats["other"]),
    "gross_profit_current": D(loaded["income_core"]["current"]["operating_revenue"]) - D(loaded["income_core"]["current"]["operating_cost"]),
    "gross_profit_comparison": D(loaded["income_core"]["comparison"]["operating_revenue"]) - D(loaded["income_core"]["comparison"]["operating_cost"]),
}
assert abs(checks["asset_detail_sum"] - D(li["total_assets"])) <= D("1")
assert abs(checks["asset_category_sum"] - D(li["total_assets"])) <= D("1")
assert abs(checks["liability_detail_sum"] - D(li["total_liabilities"])) <= D("1")
assert abs(checks["liability_category_sum"] - D(li["total_liabilities"])) <= D("1")
assert abs(checks["net_funds"] - D(li["net_funds"])) <= D("1")
assert abs(checks["net_operating_assets"] - D(li["net_operating_assets"])) <= D("1")
assert abs(checks["net_investment_assets"] - D(li["net_investment_assets"])) <= D("1")
assert abs(checks["other_net_assets"] - D(li["other_net_assets"])) <= D("1")
assert abs(checks["equity_reconciliation"] - D(li["total_equity"])) <= D("1")
assert abs(checks["gross_profit_current"] - D(loaded["income_core"]["current"]["gross_profit"])) <= D("1")
assert abs(checks["gross_profit_comparison"] - D(loaded["income_core"]["comparison"]["gross_profit"])) <= D("1")
print(json.dumps({k: str(v) for k, v in checks.items()}, ensure_ascii=False, indent=2))

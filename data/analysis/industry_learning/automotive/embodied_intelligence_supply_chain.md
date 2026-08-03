# 具身智能供应链学习地图

- Created: 2026-08-03 Asia/Shanghai
- Status: 初步研究笔记

## 总口径

具身智能供应链应拆成四层：

1. 硬件身体：结构、电池、电机、减速器、传感器、线束连接器、热管理、灵巧手。
2. 低层控制：电机驱动、伺服控制、关节力控、步态和平衡控制。
3. 智能系统：视觉感知、语言理解、任务规划、操作策略、仿真训练、数据闭环。
4. 整机和场景：机器人整机、工厂/仓储/家庭等落地场景、运维服务。

投资研究时不能只看“机器人整机”，因为整机厂可能不赚钱；更要看高价值、难替代、可规模化供应的零部件和平台。

## 学习方法更新

后续不机械按零件树继续拆。遇到 McKinsey 这类高质量行业报告时，优先吸收报告的判断框架：它为什么这样拆供应链，哪些地方是成本大头，哪些地方是规模化瓶颈，哪些地方能借用汽车/消费电子/工业自动化供应链，哪些地方缺标准化和量产能力。学习目标是沿着报告逻辑理解行业，而不是只补零件名录。

对不熟悉的组件，先讲它在机器人身体里的作用和与上下游部件的关系，再讲技术瓶颈、成本占比和代表供应商。学习顺序应是“身体功能 -> 部件关系 -> 成本瓶颈 -> 公司线索”，不要先堆名词。

## 成本树

```text
具身机器人整机
-> 关节执行器
   -> 电机
   -> 减速器
   -> 驱动器
   -> 编码器/力矩传感/温度传感
   -> 轴承/壳体/制动/散热
-> 灵巧手
   -> 微型电机/微型减速器
   -> 腱绳/连杆/传动结构
   -> 触觉/力传感
   -> 手指结构件和耐磨材料
-> 传感器
   -> 摄像头/深度相机/LiDAR/IMU/足底力传感
-> 计算和控制
   -> 主控芯片/边缘 AI 模组/运动控制器/驱动板
-> 电源和热管理
   -> 电池包/BMS/电源管理/散热
-> 结构和制造
   -> 轻量化结构件/精密加工/线束连接器/测试设备
-> 软件和数据
   -> 感知/规划/全身控制/仿真/遥操作数据/模型训练
```

## 三个关键分支

### 关节执行器

关节执行器是机器人身体里的“肌肉 + 关节 + 神经反馈”。它通常不是单个零件，而是电机、减速器、驱动器、传感器、轴承、壳体和散热的组合。

难点不是“能不能转”，而是要在很小体积和重量里同时做到高扭矩、高精度、低背隙、抗冲击、低发热、低噪音、长寿命和可量产成本。机器人摔倒、急停、搬重物、长时间站立都会冲击关节。

当前应重点看：

- 减速器：谐波/应变波减速器适合轻小高精度关节；RV/摆线减速器更适合大扭矩和高刚性场景。
- 电机：无框力矩电机、空心杯电机、永磁同步电机。
- 传感：编码器、力矩传感器、温度传感器。
- 组件集成：谁能把减速器、电机、驱动、传感和结构做成稳定的一体化关节。

公开资料中，McKinsey 估算执行器成本里 gearbox 约占 30%-50%，driver 约 15%-20%，motor 约 10%-20%，机械件约 10%-20%，sensor 约 5%-10%。这个比例说明减速器和关节集成是硬件成本核心。

### 灵巧手

灵巧手不是小号机械臂。它要解决小空间里的多自由度、触觉、抓握、耐久、低成本和安全。

硬件上看微型执行器、微型减速器、腱绳/连杆传动、触觉传感、指尖材料；软件上看抓取策略、力控、视觉触觉融合和任务数据。

灵巧手短期更像研究和高端应用部件，量产成熟度低于关节执行器。真正大规模之前，成本、寿命、抗污染、维护和可制造性都需要验证。

### 全身平衡控制

全身平衡控制主要是软件和控制系统能力，不是单一硬件供应链。它依赖硬件反馈：IMU、足底力传感、关节编码器、力矩反馈、视觉/深度感知和低延迟控制器。

这个环节的壁垒在模型、仿真、遥操作数据、真实部署数据、控制算法和软硬件协同。NVIDIA Isaac GR00T、Agility Digit 的 whole-body control、Boston Dynamics Atlas 都说明行业正在从传统控制走向“仿真 + 数据 + 学习控制 + 全身协调”。

## 代表公司线索

以下是供应链学习线索，不等于已确认投资标的；后续需要逐家公司核营收占比、客户、毛利率、现金流和估值。

| 环节 | 代表公司/平台 | 备注 |
|---|---|---|
| 谐波/应变波减速器 | Harmonic Drive Systems、Leaderdrive / 绿的谐波 | 高精度小型关节核心部件 |
| RV/摆线减速器 | Nabtesco | 工业机器人重载关节强项，和人形机器人部分大扭矩关节相关 |
| 一体化关节/执行器 | Unitree、Leaderdrive、部分汽车零部件厂 | 集成能力比单零件更接近整机需求 |
| 力/扭矩传感 | ATI / Novanta、OnRobot、国内力传感厂商 | 用于力控、接触安全、抓取和足底反馈 |
| 灵巧手 | Allegro Hand / Wonik、Shadow Robot、Figure 自研手 | 灵巧手目前仍是高难度、低成熟度环节 |
| 全身控制/仿真平台 | NVIDIA Isaac GR00T、Agility Robotics、Boston Dynamics、Tesla Optimus | 软件平台和数据闭环是核心，不是简单硬件外购 |

## 当前判断

具身智能硬件里最值得优先研究的是关节执行器，因为它价值量高、难量产、和汽车供应链的电机/电控/精密制造能力高度相通。灵巧手更难，但商业化节奏可能慢于关节。全身平衡控制主要是整机厂、AI 平台和数据闭环的能力，硬件供应商更多是提供传感和算力底座。

## 投资优先级草稿

早期具身智能不一定是整机厂先赚钱。整机厂要承担研发、量产、交付、售后和场景试错，可能长期亏损；供应链瓶颈环节和真实场景落地服务可能更早出现现金收入。

| 位置 | 赚钱逻辑 | 风险 | 初步优先级 |
|---|---|---|---|
| 关节执行器 / 减速器 / 电机 / 传感器 | 单机价值量高，难量产，可向多家整机厂供货 | 整机厂自研、标准化后压价，机器人收入占比可能很小 | 高 |
| 工厂/仓储/巡检场景服务 | 如果能替代人或提升效率，ROI 可验证 | 项目制重、运维复杂、客户复制慢 | 中高 |
| 计算/软件/仿真平台 | 模型、控制、仿真、数据闭环可能形成平台 | 收费模式未定，可能被整机厂内化 | 中高 |
| 整机厂 | 系统集成和最终市场空间最大 | 研发重、量产难、价格不确定、早期亏损 | 中 |
| 普通结构件/线束/连接器/加工件 | 能吃到放量订单 | 替代性强，议价弱，毛利可能普通 | 低到中 |

看上市公司时，先核实机器人相关收入占比、真实客户订单、量产阶段、毛利率是否高于主业、资本开支和现金流，而不是只看是否有机器人概念。

## McKinsey 报告框架

McKinsey 的重点不是证明某个零件贵，而是提出一个供应链判断模型：

```text
成本占比高
+ 性能差异大
+ 供应商少
+ 标准化低
+ 难借用相邻产业量产能力
= 最可能成为瓶颈，也最可能产生供应链机会
```

按这个模型：

- 执行器是最大成本项，也是性能差异最大的地方，所以是第一优先级。
- 减速器、滚柱丝杠、机器人级力/触觉传感，是更容易卡住规模化的高风险环节。
- 电池、普通电机、功率电子、摄像头、部分计算平台，因为能借用 EV、消费电子、工业自动化供应链，风险相对低，但仍需要机器人场景适配。
- 计算和控制不是普通零件短缺，而是缺少像汽车 ECU 那样统一、安全认证、低延迟的“机器人控制平台”。
- 今天很多整机厂自研，不一定是因为它们想垂直一体化，而是因为供应链还没成熟、接口还没标准化、供应商无法承诺量产成本和性能。

这个框架会作为后续学习具身供应链的主线。

## 参考资料

- McKinsey: Turning humanoid supply chain constraints into billion-dollar wins: https://www.mckinsey.com/industries/industrials/our-insights/turning-humanoid-supply-chain-constraints-into-billion-dollar-wins
- Tesla AI & Robotics: https://www.tesla.com/AI
- NVIDIA Isaac GR00T: https://developer.nvidia.com/isaac/gr00t
- NVIDIA GR00T workflow concepts: https://docs.nvidia.com/learning/physical-ai/gr00t-e2e-workflow/latest/getting-started/concepts-overview.html
- Agility Robotics whole-body control: https://www.agilityrobotics.com/content/training-a-whole-body-control-foundation-model
- Boston Dynamics Atlas: https://bostondynamics.com/products/atlas/
- Boston Dynamics large behavior models and Atlas: https://bostondynamics.com/blog/large-behavior-models-atlas-find-new-footing/
- Harmonic Drive Systems: https://www.hds.co.jp/english/
- Harmonic Drive high precision products: https://www.harmonicdrive.net/
- Nabtesco precision reduction gears: https://www.nabtesco.com/en/products/robot/
- Leaderdrive humanoid robot gearing: https://www.leaderdrive.com/app/8.html
- Leaderdrive humanoid robotics products: https://www.leaderdrive.com/news/26.html
- Allegro Hand: https://www.allegrohand.com/
- Shadow Robot tactile sensors: https://shadowrobot.com/sensors/
- ATI force/torque sensors: https://ati-ia.com/how-force-torque-sensors-are-enhancing-automation/
- OnRobot HEX force/torque sensor: https://onrobot.com/en/products/hex-6-axis-force-torque-sensor

## 相关清单

- A股供应链候选图谱：`embodied_intelligence_a_share_candidates.md`

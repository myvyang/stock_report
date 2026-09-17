# 旧部署研究产物归档

来源：2026-09-17 服务器退役清点中的五个旧 stock_analysis release，具体提交身份见 manifest 的 release 字段。

本归档保存 34,592 个来源路径、34,497 个不同对象，包含 388 份 report.md，以及 analysis.json、转写表、校验结果、转写片段和生成脚本。每份报告所在工作区的 config/input.json、materials.json、filing-page-chunks.json 一并保留，作为任务身份和材料定位依据。

## 读取与恢复

`manifest.json` 每行包含 release、相对于 `data/outputs/stock_research_runs/` 的 path、原字节数、SHA-256 和 object。实际内容存于 `objects/<SHA-256>.<原扩展名>`；读取时按 object 查找，恢复时按 release/path 还原，文件内容不作转换。相同字节内容允许多个原路径指向同一对象。

这是一份不可变历史底稿集合，不是当前双表发布列表。完整报告、转写子任务及未通过校验的候选保留原状态；不因归档而视为已完成或已通过财务复核。JSON 可解析、原件哈希一致、常见凭证格式检查无命中，详见 validation.json。

本归档不包含模型 trace、完整运行环境、原始 PDF 或工作区全部输入。材料来源与引用应结合配套 config 元数据及既有财报来源清单读取。服务器的其他工作文件与过程记录不会因该归档自动获得删除许可。

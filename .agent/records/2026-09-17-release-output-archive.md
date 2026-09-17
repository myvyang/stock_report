# Session Record: 旧部署研究产物归档

- Time: 2026-09-17 Asia/Shanghai
- Window: 上次服务器旧成果归档后至当前清点批次。
- Previous Record: 2026-09-17T14-33-00+08-00-server-old-results-recovery.md
- Commit: pending
- Branch: archive/server-retirement-20260917
- Task: 利用现有成果仓保全旧部署中的历史研究输出。
- Source Sessions: 当前 Codex 对话、五个 release 的只读文件清单、原件 SHA-256、JSON 与凭证格式检查；未检索其他会话。

## Outcome

保存 34,592 个来源路径、34,497 个对象，约 112MB 原始内容，含 388 份报告及其配套材料索引。内容按哈希存储，manifest 保留原来源关系。全部 JSON 可解析，逐文件 SHA-256 一致，常见凭证格式无命中；没有修订财务结论或覆盖现行报告。

## Engineering Context

旧部署的大部分体积来自重复工作材料和运行记录，不能将整目录视为代码缓存。先抽取 outputs，并为完整报告补存 config 中的任务身份和材料索引；运行 trace 与凭证不进入公开成果仓。

## Open Questions And Risks

归档不表示这些候选通过当前协议，也不构成整个旧运行目录的删除证明。其他独有输入、方法与过程记录仍由退役清点分别处理。

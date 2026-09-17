# Session Record: 服务器旧工作区成果归档

- Time: 2026-09-17T14:33:00+08:00
- Window: 2026-09-17T14:02:00+08:00 to 2026-09-17T14:33:00+08:00
- Previous Record: 2026-09-17T13-50-00+08-00-full-two-table-archive.md
- Commit: pending
- Branch: archive/server-retirement-20260917
- Task: 保全旧服务器独有成果，不覆盖正式报告。
- Source Sessions: 当前 Codex 对话、远端只读工作区清单、Git origin 历史及逐文件哈希；未检索无关会话。

## Outcome

新增历史恢复归档：45 个路径、23 种内容，涉及四家公司，保留版本关系和来源 manifest。所有 JSON 可解析，哈希一致，常见凭证格式扫描无命中。stock_report_run_v3 的两份修改已存在于 origin 历史，未重复归档。

## Engineering Context

未提交状态不等于独有成果，先按 Git blob 对比远端可达历史。归档不触发现行报告替换，也不宣称旧结果符合现行协议。原本地脏工作区与远端工作区均保持不变。

## Open Questions And Risks

SQLite 和运行 trace 不入公开 Git；数据库尚需一致性备份。自动保存新双表完整底稿仍是独立待办。

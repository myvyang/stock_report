# 项目入口

开始工作前按顺序阅读：

1. [README.md](README.md)
2. [docs/data-model.md](docs/data-model.md)
3. [project-memory/index.md](project-memory/index.md)
4. [project-memory/status/current.md](project-memory/status/current.md)

## 项目规则

- 时间统一使用 `Asia/Shanghai`，持久化时间必须带 UTC 偏移或时区。
- 原始 PDF、原始接口 JSON、标准化事实和分析结果分层保存，不相互覆盖。
- 测试数据放在 `tests/fixtures/`，禁止测试删除或改写真实财报数据。
- 不确定的资产先进入 `other_assets` 或具名待复核项，不为了凑公式强行归类。
- PDF 由 Git LFS 管理；不要把 `.venv`、SQLite、缓存或运行日志提交到仓库。

# Recovered Rebase Conflict Variants 2026-08-03

- 来源备份：`/Users/haha/aicode/stock_report_backups/rebase-conflicts-20260803-164224`
- 对比基准：`origin/master`
- 备份文件数：479
- 与主干完全一致：437
- 和主干不同并已纳入本目录：42
- 主干缺失：0

## 结论

这批备份不是整批覆盖型数据。大部分文件已经和主干一致；剩下的差异集中在少数公司/期间，存在三类情况：

- 备份明显包含后续确认过的新口径，例如鲁泰A的资金折扣。
- 备份和主干各有补充事实，需要按字段合并，不能简单二选一。
- 个别报告的历史市值口径差异较大，需要先复核行情日期、复权和汇率，再决定采用哪版。

因此本次先把所有差异文件完整纳入 `files/` 备查，保留原相对路径，后续可以按公司逐个合并到正式 `data/analysis/` 和 `data/normalized/`。

## 涉及公司/期间

- `000726.SZ/2025-12-31`
- `00637.HK/2024-12-31`
- `00743.HK/2024-12-31`
- `00811.HK/2023-12-31`
- `00811.HK/2024-12-31`
- `08436.HK/2024-12-31`

## 合并建议

| 公司/期间 | 判断 | 建议 |
| --- | --- | --- |
| `000726.SZ/2025-12-31` | 备份 owner_earnback 使用现金、定存、保本理财 1.00、投资理财 0.80 的新折扣口径，更符合后续确认规则。 | 优先合并 owner_earnback；annual facts 也可用于补充。 |
| `00637.HK/2024-12-31` | 备份 facts 更细，补了更多资产负债和证据字段。 | 建议按字段合并 facts，再重算 owner_earnback。 |
| `00743.HK/2024-12-31` | 主干 Markdown 更完整，备份 JSON 有额外字段；备份回本年和主干差异大。 | 不建议整文件覆盖，需字段级合并和重新计算。 |
| `00811.HK/2023-12-31` | 备份 facts 更大，但 owner_earnback 市值和主干差异明显。 | 先复核历史市值口径，再决定 owner_earnback。 |
| `00811.HK/2024-12-31` | 备份 facts 更大，但 owner_earnback 市值从 164.19 亿变成 124.41 亿，直接影响回本年。 | 先复核财报发布一个月后的 A+H 市值、复权和汇率，不直接覆盖。 |
| `08436.HK/2024-12-31` | 备份补了更多证据链接、租赁负债和分部信息；回本年和主干差异也较大。 | facts 可合并，owner_earnback 需重算确认。 |

## 文件清单

| 备份文件 | 备份大小 | 主干大小 |
| --- | ---:| ---:|
| `files/data/analysis/annual_review/000726.SZ/2025-12-31/annual_facts.md` | 2487 | 1678 |
| `files/data/analysis/annual_review/000726.SZ/2025-12-31/extraction_trace.txt` | 2032 | 1119 |
| `files/data/analysis/annual_review/000726.SZ/2025-12-31/facts.json` | 16094 | 13510 |
| `files/data/analysis/annual_review/00637.HK/2024-12-31/annual_facts.md` | 3298 | 1852 |
| `files/data/analysis/annual_review/00637.HK/2024-12-31/extraction_trace.txt` | 2013 | 1420 |
| `files/data/analysis/annual_review/00637.HK/2024-12-31/facts.json` | 15941 | 12145 |
| `files/data/analysis/annual_review/00743.HK/2024-12-31/annual_facts.md` | 2510 | 3659 |
| `files/data/analysis/annual_review/00743.HK/2024-12-31/extraction_trace.txt` | 2612 | 2156 |
| `files/data/analysis/annual_review/00743.HK/2024-12-31/facts.json` | 16846 | 13433 |
| `files/data/analysis/annual_review/00811.HK/2023-12-31/annual_facts.md` | 2926 | 2903 |
| `files/data/analysis/annual_review/00811.HK/2023-12-31/extraction_trace.txt` | 4504 | 2035 |
| `files/data/analysis/annual_review/00811.HK/2023-12-31/facts.json` | 18939 | 12374 |
| `files/data/analysis/annual_review/00811.HK/2024-12-31/annual_facts.md` | 2407 | 2151 |
| `files/data/analysis/annual_review/00811.HK/2024-12-31/extraction_trace.txt` | 1464 | 1609 |
| `files/data/analysis/annual_review/00811.HK/2024-12-31/facts.json` | 14782 | 10807 |
| `files/data/analysis/annual_review/08436.HK/2024-12-31/annual_facts.md` | 3198 | 3089 |
| `files/data/analysis/annual_review/08436.HK/2024-12-31/extraction_trace.txt` | 3824 | 2229 |
| `files/data/analysis/annual_review/08436.HK/2024-12-31/facts.json` | 13183 | 12162 |
| `files/data/analysis/owner_earnback/000726.SZ/2025-12-31/report.md` | 5163 | 6088 |
| `files/data/analysis/owner_earnback/000726.SZ/2025-12-31/result.json` | 17380 | 15774 |
| `files/data/analysis/owner_earnback/000726.SZ/2025-12-31/trace.txt` | 2032 | 1327 |
| `files/data/analysis/owner_earnback/00637.HK/2024-12-31/report.md` | 4834 | 4183 |
| `files/data/analysis/owner_earnback/00637.HK/2024-12-31/result.json` | 12183 | 10295 |
| `files/data/analysis/owner_earnback/00637.HK/2024-12-31/trace.txt` | 2763 | 1766 |
| `files/data/analysis/owner_earnback/00743.HK/2024-12-31/report.md` | 3639 | 4459 |
| `files/data/analysis/owner_earnback/00743.HK/2024-12-31/result.json` | 12325 | 10853 |
| `files/data/analysis/owner_earnback/00743.HK/2024-12-31/trace.txt` | 2612 | 3029 |
| `files/data/analysis/owner_earnback/00811.HK/2023-12-31/report.md` | 5706 | 4663 |
| `files/data/analysis/owner_earnback/00811.HK/2023-12-31/result.json` | 15976 | 12201 |
| `files/data/analysis/owner_earnback/00811.HK/2023-12-31/trace.txt` | 4504 | 2890 |
| `files/data/analysis/owner_earnback/00811.HK/2024-12-31/report.md` | 5345 | 4280 |
| `files/data/analysis/owner_earnback/00811.HK/2024-12-31/result.json` | 13646 | 11049 |
| `files/data/analysis/owner_earnback/00811.HK/2024-12-31/trace.txt` | 3378 | 2060 |
| `files/data/analysis/owner_earnback/08436.HK/2024-12-31/report.md` | 4898 | 4548 |
| `files/data/analysis/owner_earnback/08436.HK/2024-12-31/result.json` | 14005 | 12765 |
| `files/data/analysis/owner_earnback/08436.HK/2024-12-31/trace.txt` | 3824 | 2899 |
| `files/data/normalized/facts/000726.SZ/2025-12-31/annual-facts.json` | 16094 | 13510 |
| `files/data/normalized/facts/00637.HK/2024-12-31/annual-facts.json` | 15941 | 12145 |
| `files/data/normalized/facts/00743.HK/2024-12-31/annual-facts.json` | 16846 | 13433 |
| `files/data/normalized/facts/00811.HK/2023-12-31/annual-facts.json` | 18939 | 5710 |
| `files/data/normalized/facts/00811.HK/2024-12-31/annual-facts.json` | 14782 | 2237 |
| `files/data/normalized/facts/08436.HK/2024-12-31/annual-facts.json` | 13183 | 12162 |

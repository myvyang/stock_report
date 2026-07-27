---
name: a-share-price-fetch
description: Fetch current A-share quote data for stock_report agents using fixed public quote endpoints, returning normalized JSON with price, quote time, source URL, and fetch time. Use when a report needs the current stock price for SH/SZ/BJ A-share codes.
---

# A-share Price Fetch

Use this skill whenever a stock report needs a current A-share price. Do not make the report agent rediscover quote APIs.

## Command

Run the bundled script from the project root:

```bash
python3 .agents/skills/a-share-price-fetch/scripts/fetch_a_share_price.py 600132.SH
```

When the skill has been copied into an agent run directory, run that copy instead:

```bash
python3 <run_dir>/config/skills/a-share-price-fetch/scripts/fetch_a_share_price.py 600132.SH
```

It prints normalized JSON:

```json
{
  "code": "600132.SH",
  "name": "重庆啤酒",
  "currency": "CNY",
  "price": 43.19,
  "previous_close": 43.7,
  "change": -0.51,
  "pct_change": -1.17,
  "quote_time": "2026-07-17T16:14:32+08:00",
  "fetched_at": "2026-07-17T20:10:00+08:00",
  "source": "tencent",
  "source_url": "https://qt.gtimg.cn/q=sh600132"
}
```

## Rules

- Accept only A-share style codes ending in `.SH`, `.SZ`, or `.BJ`.
- Use Tencent quote endpoint first: `https://qt.gtimg.cn/q=<prefix><code>`.
- Use Eastmoney quote endpoint as fallback when Tencent fails.
- Prices are current market quotes, not financial statement facts. Store them separately from financial statement amounts.
- If both endpoints fail, report the failure clearly; do not invent or reuse an old price.

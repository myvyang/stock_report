#!/usr/bin/env bash
set -euo pipefail
export TZ=Asia/Shanghai
cd /root/aicode/stock_analysis_current
base=/root/aicode/runs/stock_research_batch/market_count_no_listing_20260801
out=$base/queues
mkdir -p "$out"
echo "[$(date +%F\ %T%z)] HK count start"
PYTHONPATH=src:scripts python3 scripts/build_yfinance_owner_earnback_queue.py --market HK --output-dir "$out" --cache-path "$base/yfinance_hk_cache.json" --period 2025-12-31 --pe-limit 30 --limit 0 --sleep-sec 0.03 --save-every 25
echo "[$(date +%F\ %T%z)] US count start"
PYTHONPATH=src:scripts python3 scripts/build_yfinance_owner_earnback_queue.py --market US --output-dir "$out" --cache-path "$base/yfinance_us_cache.json" --period 2025-12-31 --pe-limit 30 --limit 0 --sleep-sec 0.03 --save-every 25
echo "[$(date +%F\ %T%z)] summarize"
python3 - <<'PY'
import json, pathlib
base=pathlib.Path('/root/aicode/runs/stock_research_batch/market_count_no_listing_20260801')
out=base/'queues'
summary={}
for market in ['hk','us']:
    p=out/f'latest_{market}_ranking.json'
    if p.exists():
        d=json.loads(p.read_text())
        summary[market]={'eligible':len(d.get('ranked_rows') or []),'stats':d.get('stats') or {},'run_generated_at':d.get('generated_at')}
(base/'summary.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2))
print(json.dumps(summary, ensure_ascii=False, indent=2))
PY

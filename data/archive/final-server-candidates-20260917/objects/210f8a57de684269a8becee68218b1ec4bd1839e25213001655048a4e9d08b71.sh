#!/usr/bin/env bash
set -euo pipefail
cd /root/aicode/stock_analysis_current
exec env PYTHONPATH=src python3 scripts/run_stock_research_queue_file.py \
  --queue /root/aicode/runs/stock_research_batch/a_share_owner_earnback_1028_queue_20260731_parallel5_20260731/shard_1.json \
  --stock-report-root /root/aicode/stock_report \
  --period 2025-12-31 \
  --log /root/aicode/runs/stock_research_batch/a_share_owner_earnback_1028_queue_20260731_parallel5_20260731/shard_1.jsonl \
  --timeout-seconds 3600 \
  --include-special

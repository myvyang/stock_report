#!/usr/bin/env bash
set -u
run_root=/root/aicode/runs/stock_research_batch
project=/root/aicode/stock_analysis_run_40a4ac8
stock_report=/root/aicode/stock_report
first_pid_file="$run_root/20260728_ah_priority_all.pid"
if [ -f "$first_pid_file" ]; then
  first_pid=$(cat "$first_pid_file")
  while kill -0 "$first_pid" 2>/dev/null; do
    sleep 60
  done
fi
cd "$project" || exit 1
stamp=$(date +%Y%m%d_%H%M%S)
env PYTHONPATH=src python3 scripts/run_stock_research_batch.py \
  --stock-report-root "$stock_report" \
  --markets A,HK \
  --limit 1000 \
  --timeout-seconds 3600 \
  --log "$run_root/${stamp}_ah_remaining_all.jsonl" \
  > "$run_root/${stamp}_ah_remaining_all.out" 2>&1
stamp=$(date +%Y%m%d_%H%M%S)
env PYTHONPATH=src python3 scripts/run_stock_research_batch.py \
  --stock-report-root "$stock_report" \
  --markets US \
  --limit 300 \
  --timeout-seconds 3600 \
  --log "$run_root/${stamp}_us_after_ah.jsonl" \
  > "$run_root/${stamp}_us_after_ah.out" 2>&1

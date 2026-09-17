from pathlib import Path
import json
import os
import sys

PROJECT = Path('/root/aicode/stock_analysis_run_40a4ac8')
os.environ['PYTHONPATH'] = str(PROJECT / 'src')
sys.path.insert(0, str(PROJECT / 'src'))
sys.path.insert(0, str(PROJECT))

from scripts.run_stock_research_batch import (  # noqa: E402
    append_jsonl,
    candidate_from_code,
    new_result_is_complete,
    now_text,
    run_candidate,
)

STOCK_REPORT = Path('/root/aicode/stock_report')
PERIOD = '2025-12-31'
QUEUE = Path('/root/aicode/runs/stock_research_batch/20260728_a_priority20_queue_v2.json')
LOG = Path('/root/aicode/runs/stock_research_batch/20260728_a_priority20_filtered_v2.jsonl')
TIMEOUT_SECONDS = 3600

items = json.loads(QUEUE.read_text(encoding='utf-8'))
append_jsonl(LOG, {
    'time': now_text(),
    'event': 'filtered_batch_start',
    'period': PERIOD,
    'queue_count': len(items),
    'filter': 'A-share priority20 v2, ST and consistent-loss excluded, turnaround-watch last',
})
selected_count = 0
skipped_count = 0
for item in items:
    code = item['code']
    if new_result_is_complete(STOCK_REPORT, code, PERIOD):
        skipped_count += 1
        append_jsonl(LOG, {'time': now_text(), 'event': 'skip_complete', 'code': code, 'name': item.get('name')})
        continue
    candidate = candidate_from_code(STOCK_REPORT, code, PERIOD)
    selected_count += 1
    append_jsonl(LOG, {
        'time': now_text(),
        'event': 'queue_item',
        'code': code,
        'name': item.get('name'),
        'owner': item.get('owner'),
        'mp': item.get('mp'),
        'watch_reasons': item.get('watch_reasons') or [],
    })
    run_candidate(candidate, STOCK_REPORT, PERIOD, LOG, TIMEOUT_SECONDS)
append_jsonl(LOG, {'time': now_text(), 'event': 'filtered_batch_done', 'selected_count': selected_count, 'skipped_count': skipped_count})

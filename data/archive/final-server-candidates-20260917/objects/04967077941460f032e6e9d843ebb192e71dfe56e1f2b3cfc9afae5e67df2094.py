from pathlib import Path
from dataclasses import replace
import json
import os
import sys

PROJECT = Path('/root/aicode/stock_analysis_run_40a4ac8')
os.environ['PYTHONPATH'] = str(PROJECT / 'src')
sys.path.insert(0, str(PROJECT / 'src'))
sys.path.insert(0, str(PROJECT))

from scripts.run_stock_research_batch import append_jsonl, candidate_from_code, new_result_is_complete, now_text, run_candidate  # noqa: E402

STOCK_REPORT = Path('/root/aicode/stock_report')
PERIOD = '2025-12-31'
QUEUE = Path('/root/aicode/runs/stock_research_batch/20260728_a_current_pe30_owner_need_research.json')
LOG = Path('/root/aicode/runs/stock_research_batch/20260728_a_current_pe30_owner_research.jsonl')
TIMEOUT_SECONDS = 3600

items = json.loads(QUEUE.read_text(encoding='utf-8'))
append_jsonl(LOG, {'time': now_text(), 'event': 'current_pe30_owner_research_start', 'period': PERIOD, 'queue_count': len(items), 'filter': 'A-share, hard-excluded removed, current Tencent 0 < TTM PE < 30, existing owner_earnback, missing stock_research'})
selected_count = 0
skipped_count = 0
for item in items:
    code = item['code']
    if new_result_is_complete(STOCK_REPORT, code, PERIOD):
        skipped_count += 1
        append_jsonl(LOG, {'time': now_text(), 'event': 'skip_complete', 'code': code, 'name': item.get('name')})
        continue
    candidate = candidate_from_code(STOCK_REPORT, code, PERIOD)
    candidate = replace(candidate, name=item.get('name') or candidate.name, pe_ttm=item.get('pe') if item.get('pe') is not None else candidate.pe_ttm, market_cap=(item.get('market_cap_yi') * 100000000 if item.get('market_cap_yi') else candidate.market_cap), market_cap_date=item.get('quote_time') or candidate.market_cap_date, market_cap_source=item.get('quote_source') or candidate.market_cap_source)
    selected_count += 1
    append_jsonl(LOG, {'time': now_text(), 'event': 'queue_item', 'code': code, 'name': item.get('name'), 'pe': item.get('pe'), 'market_cap_yi': item.get('market_cap_yi'), 'owner_earnback_years': item.get('owner_earnback_years'), 'market_profit_payback_years': item.get('market_profit_payback_years'), 'watch_reasons': item.get('watch') or [], 'pending': item.get('pending') or []})
    run_candidate(candidate, STOCK_REPORT, PERIOD, LOG, TIMEOUT_SECONDS)
append_jsonl(LOG, {'time': now_text(), 'event': 'current_pe30_owner_research_done', 'selected_count': selected_count, 'skipped_count': skipped_count})

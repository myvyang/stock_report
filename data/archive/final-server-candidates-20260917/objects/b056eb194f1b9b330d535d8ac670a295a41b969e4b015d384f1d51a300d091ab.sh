#!/usr/bin/env bash
set -u
old=/root/aicode/runs/industry-leaf-groups-20260908
current=/root/aicode/runs/industry-leaf-groups-20260909
target="$current/staples-healthcare-wave2"
while [ ! -f "$old/all-calibrated-leaves/preflight/summary.json" ] || [ ! -f "$current/food-beverage-wave/preflight/summary.json" ] || [ ! -f "$current/utilities/preflight/summary.json" ]; do
  sleep 30
done
prior="$target/prior-ready"
mkdir -p "$prior"
python3 - "$old" "$current" "$prior" <<'PY'
import json, shutil, sys
from pathlib import Path
old, current, target = map(Path, sys.argv[1:])
sources = [Path('/root/aicode/runs/operating-analysis-universe-revised-20260908/preflight-v10')]
sources += [p for p in old.glob('*/preflight')]
sources += [p for p in current.glob('*/preflight') if 'staples-healthcare-wave2' not in str(p)]
copied=set()
for source in sources:
    for path in source.glob('*.json'):
        if path.name == 'summary.json': continue
        try: payload=json.loads(path.read_text(encoding='utf-8'))
        except Exception: continue
        if payload.get('status') != 'ready': continue
        shutil.copy2(path, target/path.name); copied.add(path.name)
print(f'consolidated_ready={len(copied)}', flush=True)
PY
release=/root/aicode/stock_analysis_releases/aa69b426506a65351bb8778652149a436a2397e1
PYTHONPATH="$release/src" python3 -m stock_analysis.interfaces.cli.stock_research_material_preflight \
  --manifest "$target/manifest.tsv" --output-dir "$target/preflight" --prior-output-dir "$prior" \
  --history-years 3 --stock-report-root /root/aicode/stock_report_run_v3 \
  --asset-store-root /root/aicode/stock_research_store --workers 3 --attempts 3
preflight_exit=$?
PYTHONPATH="$release/src" python3 -m stock_analysis.interfaces.cli.stock_research_analysis_queue import-manifest \
  --queue-root /root/aicode/stock_research_analysis_queue_v3 --manifest "$target/manifest.tsv" \
  --preflight-dir "$target/preflight" --completed-root /root/aicode/stock_report_ah_note --history-years 3
exit "$preflight_exit"

from pathlib import Path
import json

from stock_analysis.stock_research import runner

core_run = Path("/root/aicode/stock_analysis_a_bundle_cfbd780/data/outputs/stock_research_runs/689009.SH-2025-12-31-rewrite-core-2025-20260827T1942511893570800")
bundle = core_run / "workspace/outputs/filing-rewrites/2025"
task = json.loads((core_run / "workspace/config/input.json").read_text())
spec = runner.StageExecutionSpec(harness="codex", model="gpt-5.6-terra")
created = runner.create_runner_run(
    "689009.SH-2025-12-31-rewrite-review-gapfix",
    spec,
    definition_dir=runner.REWRITE_REVIEW_DEFINITION_DIR,
)
review_run = Path(created["run_dir"])
review_task = runner.populate_rewrite_review_workspace(
    Path(created["workspace"]), task, 2025, bundle
)
prompt = Path(created["records"]) / "prompt.md"
runner.render_prompt(Path(created["definition"]["prompt_template"]), review_task, prompt)
completed = runner.run_command(
    ["node", str(runner.RUNNER_BIN), "start", "--run", str(review_run), "--prompt-file", str(prompt)],
    timeout_seconds=3600,
)
errors, review = runner.validate_rewrite_review_workspace(review_run)
print(json.dumps({
    "returncode": completed.returncode,
    "run_dir": str(review_run),
    "errors": errors,
    "review": review,
}, ensure_ascii=False, indent=2))

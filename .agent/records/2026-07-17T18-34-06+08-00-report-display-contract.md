# Session Record: Report display contract update

- Time: 2026-07-17T18:34:06+08:00 Asia/Shanghai
- Window: 2026-07-17T18:27:14+08:00 to 2026-07-17T18:34:06+08:00
- Previous Record: `.agent/records/2026-07-17T18-27-14+08-00-two-company-review-samples.md`
- Commit: pending commit
- Branch: main
- Task: standardize Markdown report tables so they focus on asset-side and liability-side amounts rather than net amounts.
- Source Sessions: current Codex conversation; local project files and sample reports checked.

## Outcome

- Updated `agent_scenarios/asset_structure_review/system-prompt.md` so report main tables use only `类别 / 资产端 / 负债端`.
- Kept net funds, net operating assets, net investment assets and other net assets in JSON and formula checks, but removed them from the first-screen report table.
- Documented that `其他` is not a routine main-table row. Other net assets below 5% of equity are omitted from the main table when routine; unusual or opaque items are explained in a疑点/异常段.
- Updated README and `docs/data-model.md` with the same display contract.
- Updated the reviewed Markdown samples for 五粮液, 艾力斯 and 东鹏饮料 to use the new table shape.

## Files And Context Read

- `agent_scenarios/asset_structure_review/system-prompt.md`
- `README.md`
- `docs/data-model.md`
- `data/analysis/asset_structure/000858.SZ/2026-03-31-reviewed.md`
- `data/analysis/asset_structure/688578.SH/2026-03-31-reviewed.md`
- `data/analysis/asset_structure/605499.SH/2026-03-31-reviewed.md`

## Engineering Facts Learned

- The user wants asset-side and liability-side amounts visible, but does not want net funds or net operating assets in the main table.
- Routine `其他` items under 5% of equity should be de-emphasized; unusual opaque items should still be called out.

## Mistakes And Corrections

- Initial sample wording still explained routine low-materiality `其他`; it was tightened so routine low-materiality `其他` only notes omission and JSON retention.

## Project Memory Candidates

- Promote the report-display contract into durable project memory if more report-generation work follows.

## Open Questions And Risks

- Future agent runs should be sampled to confirm the model follows the new table shape without manual repair.

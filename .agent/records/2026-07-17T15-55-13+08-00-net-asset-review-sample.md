# Net Asset Review Sample

- Time: 2026-07-17T15:55:13+08:00 Asia/Shanghai
- Scope: extend the asset structure review agent from asset-only classification to net asset structure review.

## Changes

- Expanded `asset_structure_review` prompt contract to include liabilities, total equity, parent equity, minority interest, net funds, net operating assets, net investment assets and other net assets.
- Updated the report display contract so summaries show assets, liabilities and net amounts side by side for funds, operating, investment and other categories.
- Added a report requirement to explain the major asset-side and liability-side components for each category, with amounts in 亿元.
- Added a `business_substance` requirement so each asset and liability item explains the concrete business object, right, or obligation rather than only an accounting label.
- Required official or traceable evidence when using financial-report-adjacent sources such as earnings calls, investor relations activity records, exchange Q&A, or announcements; unresolved opaque items such as regulatory goods must not be force-explained.
- Strengthened `AssetReviewAgentRunner` validation so reviewed outputs must reconcile assets, liabilities and equity formulas.
- Strengthened `AssetReviewAgentRunner` validation so reviewed outputs must include non-empty `business_substance` for every asset and liability item.
- Updated README, data model and current project status to reflect the net asset structure contract.
- Ran the updated agent for `000858.SZ` using the existing 2026-03-31 quarterly filing and 2025 annual report evidence.

## Result

- Generated `data/analysis/asset_structure/000858.SZ/2026-03-31-reviewed.json`, then supplemented each item with `business_substance`.
- Generated `data/analysis/asset_structure/000858.SZ/2026-03-31-reviewed.md` with an assets/liabilities/net summary table and business-substance component explanations.
- Agent run directory: `data/agent_runs/asset_structure_review/2026-07-17T15-43-31+08-00-000858-sz-五-粮-液/`.
- Verification: `PYTHONPATH=src python3 -m unittest discover -s tests` passed.

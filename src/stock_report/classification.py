from __future__ import annotations

from dataclasses import dataclass
from decimal import Decimal
from typing import Any, Dict, Iterable, List, Optional, Tuple


CLASSIFICATION_VERSION = "asset-structure-v1"

# Fields are leaf lines in the Eastmoney balance-sheet response. Parent totals and
# alternate combined lines are intentionally excluded to prevent double counting.
FIELD_RULES: Dict[str, tuple[str, str, str]] = {
    "MONETARYFUNDS": ("货币资金", "funds", "季报主表；受限资金待年报附注拆分"),
    "TRADE_FINASSET_NOTFVTPL": ("交易性金融资产", "funds", "默认可剥离；待年报附注核对品种"),
    "CREDITOR_INVEST": ("债权投资", "funds", "默认资金配置；待核对是否受限"),
    "OTHER_CREDITOR_INVEST": ("其他债权投资", "funds", "默认资金配置；待核对是否受限"),
    "NOTE_RECE": ("应收票据", "operating", "销售结算形成"),
    "ACCOUNTS_RECE": ("应收账款", "operating", "销售结算形成"),
    "FINANCE_RECE": ("应收款项融资", "operating", "销售结算形成"),
    "PREPAYMENT": ("预付款项", "operating", "采购经营形成"),
    "TOTAL_OTHER_RECE": ("其他应收款", "operating", "默认经营相关；重要时核对附注"),
    "INVENTORY": ("存货", "operating", "生产或销售循环形成"),
    "CONTRACT_ASSET": ("合同资产", "operating", "履约经营形成"),
    "LONG_RECE": ("长期应收款", "operating", "默认经营相关；重要时核对附注"),
    "FIXED_ASSET": ("固定资产", "operating", "为主业提供产能"),
    "CIP": ("在建工程", "operating", "主业产能建设"),
    "PRODUCTIVE_BIOLOGY_ASSET": ("生产性生物资产", "operating", "为主业提供产能"),
    "OIL_GAS_ASSET": ("油气资产", "operating", "为主业提供产能"),
    "USERIGHT_ASSET": ("使用权资产", "operating", "经营场地或设备使用权"),
    "INTANGIBLE_ASSET": ("无形资产", "operating", "默认用于主业；重要时核对附注"),
    "DEVELOP_EXPENSE": ("开发支出", "operating", "主业研发形成"),
    "LONG_PREPAID_EXPENSE": ("长期待摊费用", "operating", "经营投入待摊销"),
    "LONG_EQUITY_INVEST": ("长期股权投资", "investment", "对联营合营等股权投资"),
    "OTHER_EQUITY_INVEST": ("其他权益工具投资", "investment", "默认战略性权益投资"),
    "OTHER_NONCURRENT_FINASSET": ("其他非流动金融资产", "investment", "性质待附注核对"),
    "INVEST_REALESTATE": ("投资性房地产", "investment", "非核心经营资产配置"),
    "DERIVE_FINASSET": ("衍生金融资产", "investment", "套保用途待附注核对"),
    "HOLDSALE_ASSET": ("持有待售资产", "other", "待处置资产"),
    "NONCURRENT_ASSET_1YEAR": ("一年内到期的非流动资产", "other", "混合项目，待附注拆分"),
    "OTHER_CURRENT_ASSET": ("其他流动资产", "other", "混合项目，待附注拆分"),
    "GOODWILL": ("商誉", "other", "会计资产，不视为可再投入经营资产"),
    "DEFER_TAX_ASSET": ("递延所得税资产", "other", "税务时间性差异"),
    "OTHER_NONCURRENT_ASSET": ("其他非流动资产", "other", "混合项目，待附注拆分"),
}


def _number(value: Any) -> float:
    if value in (None, ""):
        return 0.0
    return float(value)


def classify_balance_row(code: str, name: str, period: str, row: Dict[str, Any]) -> Dict[str, Any]:
    total_assets = _number(row.get("TOTAL_ASSETS"))
    items: List[Dict[str, Any]] = []
    totals = {"funds": 0.0, "operating": 0.0, "investment": 0.0, "other": 0.0}
    for field, (label, category, rationale) in FIELD_RULES.items():
        amount = _number(row.get(field))
        if not amount:
            continue
        totals[category] += amount
        items.append(
            {
                "source_field": field,
                "item_name": label,
                "amount": amount,
                "category": category,
                "rationale": rationale,
                "evidence_period": period,
                "evidence_level": "quarterly_statement_default",
                "confidence": "medium" if "待" in rationale or "默认" in rationale else "high",
            }
        )
    classified = sum(totals.values())
    residual = total_assets - classified
    tolerance = max(total_assets * 0.005, 1_000_000.0)
    if abs(residual) > 0.01:
        totals["other"] += residual
        items.append(
            {
                "source_field": "RECONCILIATION_RESIDUAL",
                "item_name": "未映射及报表列报差额",
                "amount": residual,
                "category": "other",
                "rationale": "总资产扣除已映射资产；需用年报附注逐项拆分",
                "evidence_period": period,
                "evidence_level": "reconciliation_residual",
                "confidence": "low" if abs(residual) > tolerance else "medium",
            }
        )
    unresolved_ratio = abs(residual) / total_assets if total_assets else None
    status = "review_required" if unresolved_ratio is None or unresolved_ratio > 0.05 else "provisional"
    return {
        "company": {"code": code, "name": name},
        "period": period,
        "currency": "CNY",
        "unit": "yuan",
        "classification_version": CLASSIFICATION_VERSION,
        "status": status,
        "summary": {
            "total_assets": total_assets,
            "funds_assets": totals["funds"],
            "operating_assets": totals["operating"],
            "investment_assets": totals["investment"],
            "other_assets": totals["other"],
            "mapped_assets_before_residual": classified,
            "reconciliation_residual": residual,
            "unresolved_ratio": unresolved_ratio,
            "formula_difference": total_assets - sum(totals.values()),
        },
        "items": items,
        "review_flags": _review_flags(total_assets, totals, residual),
    }


def _review_flags(total: float, totals: Dict[str, float], residual: float) -> List[str]:
    flags: List[str] = []
    if total <= 0:
        return ["总资产缺失或非正"]
    if abs(residual) / total > 0.05:
        flags.append("未映射资产超过总资产5%，必须查年报附注")
    if totals["investment"] / total > 0.10:
        flags.append("投资类资产超过总资产10%，报告必须解释构成")
    if totals["other"] / total > 0.10:
        flags.append("其他类资产超过总资产10%，报告必须解释构成")
    return flags

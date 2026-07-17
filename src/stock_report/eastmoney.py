from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Dict, Iterable, List

import requests


BASE_URL = "https://emweb.securities.eastmoney.com/PC_HSF10/NewFinanceAnalysis"


def eastmoney_code(code: str) -> str:
    number, exchange = code.split(".")
    return f"{exchange}{number}"


@dataclass
class EastmoneyClient:
    timeout: int = 30

    def fetch_balance_sheet(self, code: str, dates: Iterable[str]) -> Dict[str, Any]:
        date_text = ",".join(dates)
        response = requests.get(
            f"{BASE_URL}/zcfzbAjaxNew",
            params={
                "companyType": "4",
                "reportDateType": "0",
                "reportType": "1",
                "dates": date_text,
                "code": eastmoney_code(code),
            },
            timeout=self.timeout,
        )
        response.raise_for_status()
        payload = response.json()
        if not isinstance(payload.get("data"), list):
            raise ValueError(f"Eastmoney returned no balance-sheet data for {code}")
        return {
            "source": "eastmoney_pc_hsf10",
            "endpoint": response.url,
            "requested_dates": list(dates),
            "response": payload,
        }


def find_period_row(payload: Dict[str, Any], period: str) -> Dict[str, Any]:
    for row in payload["response"]["data"]:
        if str(row.get("REPORT_DATE", ""))[:10] == period:
            return row
    raise KeyError(f"No balance-sheet row for {period}")

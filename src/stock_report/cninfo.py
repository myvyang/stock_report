from __future__ import annotations

from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional

import requests


BASE_URL = "https://www.cninfo.com.cn"
STATIC_URL = "https://static.cninfo.com.cn"


def _exchange_parts(code: str) -> tuple[str, str, str]:
    number, exchange = code.split(".")
    if exchange == "SH":
        return number, "sse", "sh"
    if exchange == "BJ":
        return number, "szse", "bj"
    return number, "szse", "sz"


@dataclass
class CninfoClient:
    timeout: int = 30

    def __post_init__(self) -> None:
        self.session = requests.Session()
        self.session.headers.update(
            {
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
                "Referer": f"{BASE_URL}/new/index",
            }
        )

    def _org_id(self, number: str) -> str:
        response = self.session.post(
            f"{BASE_URL}/new/information/topSearch/query",
            data={"keyWord": number, "maxNum": 10},
            timeout=self.timeout,
        )
        response.raise_for_status()
        matches = response.json()
        for item in matches:
            if str(item.get("code")) == number:
                return str(item["orgId"])
        raise KeyError(f"CNINFO org id not found for {number}")

    def announcements(
        self, code: str, category: str, start_date: str, end_date: str
    ) -> List[Dict[str, Any]]:
        number, column, plate = _exchange_parts(code)
        response = self.session.post(
            f"{BASE_URL}/new/hisAnnouncement/query",
            data={
                "pageNum": 1,
                "pageSize": 30,
                "column": column,
                "tabName": "fulltext",
                "plate": plate,
                "stock": f"{number},{self._org_id(number)}",
                "searchkey": "",
                "secid": "",
                "category": category,
                "trade": "",
                "seDate": f"{start_date}~{end_date}",
                "sortName": "",
                "sortType": "",
                "isHLtitle": "true",
            },
            timeout=self.timeout,
        )
        response.raise_for_status()
        return response.json().get("announcements") or []

    def latest_interim_report(self, code: str, year: int) -> Dict[str, Any]:
        today = date.today().isoformat()
        choices: List[tuple[int, Dict[str, Any]]] = []
        categories = [
            (2, "category_bndbg_szsh", ("半年度报告",)),
            (1, "category_yjdbg_szsh", ("第一季度报告", "一季度报告")),
        ]
        for priority, category, phrases in categories:
            for item in self.announcements(code, category, f"{year}-01-01", today):
                title = str(item.get("announcementTitle", "")).replace("<em>", "").replace("</em>", "")
                if str(year) not in title or not any(phrase in title for phrase in phrases):
                    continue
                if "摘要" in title or "英文" in title or "取消" in title:
                    continue
                choices.append((priority, {**item, "clean_title": title}))
        if not choices:
            raise KeyError(f"No {year} interim report found on CNINFO for {code}")
        _, selected = max(
            choices,
            key=lambda pair: (pair[0], int(pair[1].get("announcementTime") or 0)),
        )
        selected["source_url"] = f"{STATIC_URL}/{str(selected['adjunctUrl']).lstrip('/')}"
        return selected

    def download(self, source_url: str, destination: Path) -> None:
        destination.parent.mkdir(parents=True, exist_ok=True)
        response = self.session.get(source_url, timeout=90)
        response.raise_for_status()
        temporary = destination.with_suffix(destination.suffix + ".tmp")
        temporary.write_bytes(response.content)
        temporary.replace(destination)

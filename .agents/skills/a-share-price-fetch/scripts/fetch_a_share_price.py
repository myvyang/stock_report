#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from datetime import datetime
from typing import Any, Dict, Optional
from zoneinfo import ZoneInfo


BEIJING = ZoneInfo("Asia/Shanghai")
FIELDS = "f43,f57,f58,f60,f169,f170,f46,f44,f45,f47,f48,f86"


def now_beijing() -> str:
    return datetime.now(BEIJING).isoformat(timespec="seconds")


def normalize_code(raw: str) -> Dict[str, str]:
    value = raw.strip().upper()
    match = re.fullmatch(r"(\d{6})\.(SH|SZ|BJ)", value)
    if not match:
        raise ValueError(f"Unsupported A-share code: {raw}")
    number, market = match.groups()
    if market == "SH":
        tencent_prefix = "sh"
        eastmoney_market = "1"
    elif market == "SZ":
        tencent_prefix = "sz"
        eastmoney_market = "0"
    else:
        tencent_prefix = "bj"
        eastmoney_market = "0"
    return {
        "code": f"{number}.{market}",
        "number": number,
        "market": market,
        "tencent_symbol": f"{tencent_prefix}{number}",
        "eastmoney_secid": f"{eastmoney_market}.{number}",
    }


def request_text(url: str, timeout: int) -> str:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": "Mozilla/5.0 stock_report_price_fetch/1.0",
            "Referer": "https://quote.eastmoney.com/",
        },
    )
    with urllib.request.urlopen(request, timeout=timeout) as response:
        encoding = "gb18030" if "qt.gtimg.cn" in url else "utf-8"
        return response.read().decode(encoding, errors="replace")


def parse_tencent_timestamp(value: str) -> Optional[str]:
    if not re.fullmatch(r"\d{14}", value or ""):
        return None
    parsed = datetime.strptime(value, "%Y%m%d%H%M%S").replace(tzinfo=BEIJING)
    return parsed.isoformat(timespec="seconds")


def to_float(value: str) -> Optional[float]:
    if value in {"", "-", "--"}:
        return None
    try:
        return float(value)
    except ValueError:
        return None


def fetch_tencent(info: Dict[str, str], timeout: int) -> Dict[str, Any]:
    url = f"https://qt.gtimg.cn/q={info['tencent_symbol']}"
    text = request_text(url, timeout)
    match = re.search(r'="(.*)";?$', text.strip(), re.S)
    if not match:
        raise ValueError(f"Unexpected Tencent response: {text[:120]}")
    parts = match.group(1).split("~")
    if len(parts) < 33 or not parts[2]:
        raise ValueError(f"Incomplete Tencent response: {text[:120]}")
    price = to_float(parts[3])
    if price is None:
        raise ValueError(f"Tencent response has no numeric price: {text[:120]}")
    return {
        "code": info["code"],
        "name": parts[1],
        "market": info["market"],
        "currency": "CNY",
        "price": price,
        "previous_close": to_float(parts[4]),
        "open": to_float(parts[5]),
        "high": to_float(parts[33]) if len(parts) > 33 else None,
        "low": to_float(parts[34]) if len(parts) > 34 else None,
        "change": to_float(parts[31]),
        "pct_change": to_float(parts[32]),
        "quote_time": parse_tencent_timestamp(parts[30]),
        "fetched_at": now_beijing(),
        "source": "tencent",
        "source_url": url,
    }


def eastmoney_scaled(value: Any) -> Optional[float]:
    if value in (None, "-", "--"):
        return None
    try:
        return float(value) / 100.0
    except (TypeError, ValueError):
        return None


def fetch_eastmoney(info: Dict[str, str], timeout: int) -> Dict[str, Any]:
    params = urllib.parse.urlencode({"secid": info["eastmoney_secid"], "fields": FIELDS})
    url = f"https://push2.eastmoney.com/api/qt/stock/get?{params}"
    payload = json.loads(request_text(url, timeout))
    data = payload.get("data") or {}
    price = eastmoney_scaled(data.get("f43"))
    if price is None:
        raise ValueError(f"Eastmoney response has no numeric price: {payload}")
    quote_time = None
    if data.get("f86"):
        quote_time = datetime.fromtimestamp(int(data["f86"]), BEIJING).isoformat(timespec="seconds")
    return {
        "code": info["code"],
        "name": data.get("f58") or "",
        "market": info["market"],
        "currency": "CNY",
        "price": price,
        "previous_close": eastmoney_scaled(data.get("f60")),
        "open": eastmoney_scaled(data.get("f46")),
        "high": eastmoney_scaled(data.get("f44")),
        "low": eastmoney_scaled(data.get("f45")),
        "change": eastmoney_scaled(data.get("f169")),
        "pct_change": eastmoney_scaled(data.get("f170")),
        "quote_time": quote_time,
        "fetched_at": now_beijing(),
        "source": "eastmoney",
        "source_url": url,
    }


def fetch_price(code: str, timeout: int = 10, retries: int = 1) -> Dict[str, Any]:
    info = normalize_code(code)
    errors = []
    for fetcher in [fetch_tencent, fetch_eastmoney]:
        for attempt in range(retries + 1):
            try:
                return fetcher(info, timeout)
            except Exception as error:  # noqa: BLE001 - command-line tool reports all failures.
                errors.append(f"{fetcher.__name__} attempt {attempt + 1}: {error}")
                if attempt < retries:
                    time.sleep(0.5)
    raise RuntimeError("; ".join(errors))


def main() -> None:
    parser = argparse.ArgumentParser(description="Fetch current A-share stock price as JSON")
    parser.add_argument("code", help="A-share code, e.g. 600132.SH, 000858.SZ, 920982.BJ")
    parser.add_argument("--timeout", type=int, default=10)
    parser.add_argument("--retries", type=int, default=1)
    args = parser.parse_args()
    try:
        print(json.dumps(fetch_price(args.code, args.timeout, args.retries), ensure_ascii=False, indent=2))
    except Exception as error:  # noqa: BLE001 - command-line tool should print clear error.
        print(json.dumps({"code": args.code, "error": str(error), "fetched_at": now_beijing()}, ensure_ascii=False))
        sys.exit(1)


if __name__ == "__main__":
    main()

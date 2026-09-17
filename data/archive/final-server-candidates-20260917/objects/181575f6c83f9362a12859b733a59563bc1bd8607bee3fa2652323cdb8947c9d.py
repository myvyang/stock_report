#!/usr/bin/env python3
import json, pathlib, math, time, statistics, warnings
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
from zoneinfo import ZoneInfo
warnings.filterwarnings("ignore")
import yfinance as yf
import pandas as pd

ROOT=pathlib.Path("/root/aicode/stock_report")
OUT=pathlib.Path("/root/aicode/runs/dividend_bond_like")
PERIOD="2025-12-31"
BEIJING=ZoneInfo("Asia/Shanghai")

def num(x):
    try:
        if x is None: return None
        v=float(x)
        if math.isnan(v) or math.isinf(v): return None
        return v
    except Exception:
        return None

def yf_symbol(code):
    if code.endswith(".SH"):
        return code[:-3]+".SS"
    if code.endswith(".HK"):
        try:
            return str(int(code[:-3]))+".HK"
        except Exception:
            return code
    return code

def load_rows():
    rows=[]
    for p in (ROOT/"data/analysis/stock_research").glob(f"*/{PERIOD}/result.json"):
        try: d=json.loads(p.read_text())
        except Exception: continue
        comp=d.get("company",{}); m=d.get("metrics",{}); fin=d.get("financials",{}); inc=fin.get("income_statement",{}); cf=fin.get("cash_flow",{}); biz=d.get("business",{}); dq=d.get("data_quality",{}); am=d.get("analysis_model",{})
        code=comp.get("code") or p.parts[-3]
        rows.append({
            "code":code,
            "yf_symbol":yf_symbol(code),
            "name":comp.get("display_name") or comp.get("name") or code,
            "market":comp.get("market"),
            "status":dq.get("status"),
            "applicability":am.get("owner_earnback_applicability"),
            "pe_ttm":num(m.get("pe_ttm")),
            "forecast_dividend_yield":num(m.get("forecast_dividend_yield")),
            "owner_earnback_years":num(m.get("owner_earnback_years")),
            "market_cap_to_cash_profit":num(m.get("market_cap_to_cash_profit")),
            "market_cap":num(m.get("market_cap")),
            "discounted_net_cash":num(m.get("discounted_net_cash")),
            "discounted_cash_profit":num(m.get("discounted_cash_profit")),
            "gross_margin":num(m.get("gross_margin")),
            "net_margin":num(m.get("net_margin")),
            "revenue":num(inc.get("revenue")),
            "parent_net_profit":num(inc.get("parent_net_profit") or inc.get("net_profit")),
            "operating_free_cash_flow":num(cf.get("operating_free_cash_flow")),
            "dividend_and_buyback_cash_out":num(cf.get("dividend_and_buyback_cash_out")),
            "one_line":biz.get("one_line") or "",
        })
    return rows

def analyze_price_dividend(row):
    sym=row["yf_symbol"]
    out={"code":row["code"], "yf_symbol":sym, "history_status":"missing"}
    try:
        hist=yf.Ticker(sym).history(period="7y", interval="1mo", auto_adjust=False, actions=True, repair=False)
        if hist is None or hist.empty or "Close" not in hist:
            return out
        close=hist["Close"].dropna()
        if len(close)<36:
            out["history_status"]="short"
        else:
            out["history_status"]="ok"
        if len(close)>1 and close.iloc[0]>0:
            out["unadjusted_price_return_5y"] = num(close.iloc[-1]/close.iloc[max(0,len(close)-61)]-1) if len(close)>=61 and close.iloc[max(0,len(close)-61)]>0 else num(close.iloc[-1]/close.iloc[0]-1)
            recent=close.iloc[-61:] if len(close)>=61 else close
            out["price_range_5y"] = num(recent.max()/recent.min()-1) if recent.min()>0 else None
            out["monthly_return_vol_5y"] = num(recent.pct_change().dropna().std())
        div=hist["Dividends"] if "Dividends" in hist.columns else pd.Series(dtype=float)
        div=div[div>0]
        current_year=datetime.now(BEIJING).year
        full_years=list(range(current_year-5, current_year))
        annual_divs=[]; annual_yields=[]; div_years=0
        for y in full_years:
            ydiv=float(div[div.index.year==y].sum()) if len(div) else 0.0
            yc=close[close.index.year==y]
            annual_divs.append(ydiv)
            if ydiv>0: div_years += 1
            if len(yc) and float(yc.mean())>0 and ydiv>0:
                annual_yields.append(ydiv/float(yc.mean()))
        nz=[x for x in annual_divs if x>0]
        out["dividend_years_5y"]=div_years
        out["annual_dividend_amounts_5y"]=annual_divs
        out["avg_dividend_yield_5y"] = num(sum(annual_yields)/len(annual_yields)) if annual_yields else None
        out["avg_dividend_yield_3y"] = None
        yields3=[]
        for y in full_years[-3:]:
            ydiv=float(div[div.index.year==y].sum()) if len(div) else 0.0
            yc=close[close.index.year==y]
            if len(yc) and float(yc.mean())>0 and ydiv>0:
                yields3.append(ydiv/float(yc.mean()))
        if yields3: out["avg_dividend_yield_3y"]=num(sum(yields3)/len(yields3))
        out["dividend_amount_cv_5y"] = num(statistics.pstdev(nz)/statistics.mean(nz)) if len(nz)>=2 and statistics.mean(nz)>0 else None
        # Simple score: prefer continuous dividend, high yield, limited unadjusted draw/volatility, and FCF coverage.
        dy = row.get("forecast_dividend_yield") or out.get("avg_dividend_yield_3y") or out.get("avg_dividend_yield_5y") or 0
        ret = out.get("unadjusted_price_return_5y")
        pr = out.get("price_range_5y")
        cv = out.get("dividend_amount_cv_5y")
        score=0
        score += min(div_years,5)*15
        score += min(max(dy,0),0.12)*250
        if ret is not None: score += max(0, 20 - abs(ret)*35)
        if pr is not None: score += max(0, 20 - max(0, pr-0.5)*20)
        if cv is not None: score += max(0, 15 - cv*20)
        fcf=row.get("operating_free_cash_flow"); divout=row.get("dividend_and_buyback_cash_out")
        if fcf and divout and divout>0:
            out["fcf_dividend_cover"] = num(fcf/divout)
            if fcf/divout >= 1: score += 15
        out["dividend_bond_like_score"] = num(score)
        return out
    except Exception as e:
        out["history_status"]="error"
        out["error"]=str(e)[:200]
        return out

def main():
    rows=load_rows()
    # Avoid wasting calls on obvious non-dividend rows, but keep low/unknown forecast yield if stable sectors have missing data.
    candidates=[r for r in rows if r.get("status")=="complete" and r.get("pe_ttm") and 0<r["pe_ttm"]<35 and r.get("parent_net_profit") and r["parent_net_profit"]>0 and (r.get("forecast_dividend_yield") or 0)>=0.02]
    # Include all markets; cap can be adjusted.
    print(json.dumps({"loaded":len(rows),"candidates":len(candidates),"generated_at":datetime.now(BEIJING).isoformat(timespec="seconds")}, ensure_ascii=False), flush=True)
    results=[]; done=0; start=time.time()
    with ThreadPoolExecutor(max_workers=6) as ex:
        futs={ex.submit(analyze_price_dividend,r):r for r in candidates}
        for fut in as_completed(futs):
            r=futs[fut]
            h=fut.result()
            merged={**r, **h}
            results.append(merged)
            done+=1
            if done%100==0:
                print(f"progress {done}/{len(candidates)} elapsed={time.time()-start:.1f}s", flush=True)
    results.sort(key=lambda x: (-(x.get("dividend_bond_like_score") or -1), -(x.get("forecast_dividend_yield") or 0)))
    ts=datetime.now(BEIJING).strftime("%Y%m%d_%H%M%S")
    out=OUT/f"dividend_bond_like_{ts}.json"
    out.write_text(json.dumps({"generated_at":datetime.now(BEIJING).isoformat(timespec="seconds"),"source":"stock_report result.json + yfinance monthly history/actions","period":PERIOD,"count":len(results),"results":results}, ensure_ascii=False, indent=2))
    latest=OUT/"dividend_bond_like_latest.json"
    latest.write_text(out.read_text())
    print("output", out)
    print("top")
    for x in results[:30]:
        def pct(v): return "-" if v is None else f"{v*100:.1f}%"
        def f(v): return "-" if v is None else f"{v:.2f}"
        print("\t".join([x["code"],x["name"],x["market"],pct(x.get("forecast_dividend_yield")),pct(x.get("avg_dividend_yield_3y")),str(x.get("dividend_years_5y")),pct(x.get("unadjusted_price_return_5y")),pct(x.get("price_range_5y")),f(x.get("pe_ttm")),f(x.get("dividend_bond_like_score")),x.get("one_line","")[:70]]))
if __name__=="__main__": main()

import unittest

from stock_report.classification import classify_balance_row


class ClassificationTest(unittest.TestCase):
    def test_categories_reconcile_to_total_assets(self):
        row = {
            "TOTAL_ASSETS": 100.0,
            "MONETARYFUNDS": 20.0,
            "ACCOUNTS_RECE": 10.0,
            "INVENTORY": 15.0,
            "FIXED_ASSET": 25.0,
            "LONG_EQUITY_INVEST": 5.0,
            "GOODWILL": 5.0,
        }
        result = classify_balance_row("000001.SZ", "样本", "2026-03-31", row)
        summary = result["summary"]
        self.assertEqual(summary["funds_assets"], 20.0)
        self.assertEqual(summary["operating_assets"], 50.0)
        self.assertEqual(summary["investment_assets"], 5.0)
        self.assertEqual(summary["other_assets"], 25.0)
        self.assertEqual(summary["formula_difference"], 0.0)


if __name__ == "__main__":
    unittest.main()

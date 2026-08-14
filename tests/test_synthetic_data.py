import csv, sys, unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from generate_synthetic_data import generate_rows

class SyntheticDataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.rows = generate_rows()
    def test_n_and_unique_ids(self):
        self.assertEqual(len(self.rows), 320); ids=[r["participant_id"] for r in self.rows]; self.assertEqual(len(ids),len(set(ids))); self.assertTrue(all(x.startswith("SYN") for x in ids))
    def test_synthetic_flag(self): self.assertTrue(all(r["synthetic_flag"] is True for r in self.rows))
    def test_item_ranges(self):
        prefixes=("mv_belief","mv_goal","meaning","prc","struggle","recovery")
        for r in self.rows:
            for k,v in r.items():
                if k.startswith(prefixes) and "_t" in k and v != "": self.assertGreaterEqual(float(v),1.0); self.assertLessEqual(float(v),7.0)
    def test_monotone_attrition(self):
        for r in self.rows:
            obs=[bool(r[f"wave{i}_observed"]) for i in range(1,5)]
            for i in range(1,4):
                if obs[i]: self.assertTrue(obs[i-1])
if __name__ == "__main__": unittest.main()

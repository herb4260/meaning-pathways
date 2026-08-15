import statistics
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from generate_synthetic_data import generate_rows


class SyntheticDataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows = generate_rows()

    def values(self, stem, wave):
        key = f"{stem}_t{wave}"
        return [float(r[key]) for r in self.rows if r[key] != ""]

    def test_n_and_unique_ids(self):
        self.assertEqual(len(self.rows), 320)
        ids = [r["participant_id"] for r in self.rows]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertTrue(all(x.startswith("SYN") for x in ids))

    def test_synthetic_flag(self):
        self.assertTrue(all(r["synthetic_flag"] is True for r in self.rows))

    def test_item_ranges(self):
        prefixes = ("mv_belief", "mv_goal", "meaning", "prc", "struggle", "recovery")
        for row in self.rows:
            for key, value in row.items():
                if key.startswith(prefixes) and "_t" in key and value != "":
                    self.assertGreaterEqual(float(value), 1.0)
                    self.assertLessEqual(float(value), 7.0)

    def test_monotone_attrition(self):
        for row in self.rows:
            observed = [bool(row[f"wave{i}_observed"]) for i in range(1, 5)]
            for i in range(1, 4):
                if observed[i]:
                    self.assertTrue(observed[i - 1])

    def test_composite_distributions_avoid_floor_and_ceiling_pileup(self):
        for stem in ("mv", "meaning", "prc", "struggle", "recovery"):
            previous_mean = None
            for wave in range(1, 5):
                values = self.values(stem, wave)
                current_mean = statistics.mean(values)
                self.assertGreater(statistics.pstdev(values), 0.35, f"{stem} wave {wave} has too little variance")
                self.assertLess(sum(v <= 1.25 for v in values) / len(values), 0.10, f"{stem} wave {wave} has floor pileup")
                self.assertLess(sum(v >= 6.75 for v in values) / len(values), 0.10, f"{stem} wave {wave} has ceiling pileup")
                if previous_mean is not None:
                    self.assertLess(abs(current_mean - previous_mean), 1.0, f"{stem} changes implausibly between waves")
                previous_mean = current_mean


if __name__ == "__main__":
    unittest.main()

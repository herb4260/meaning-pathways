from pathlib import Path
import sys,numpy as np
ROOT=Path(__file__).resolve().parents[1]; sys.path.insert(0,str(ROOT/'scripts'))
from generate_synthetic_data import generate,interviews
from validate_data import validate
from analyze_quantitative import run as qr
from analyze_qualitative import run as ql
def test_reproducible(): assert generate(123).equals(generate(123))
def test_validation(): assert validate(generate())['wave4_n']>=250
def test_100_seeds():
 for s in range(1000,1100): validate(generate(s))
def test_models(): assert np.isfinite(qr(generate()).estimate).all()
def test_qualitative():
 d=generate(); i=interviews(d); c,f,j=ql(i,d); assert len(c)==240 and j.mean_distress.between(1,7).all()
def test_synthetic_ids():
 d=generate(); assert d.person_id.str.startswith('JWP').all()

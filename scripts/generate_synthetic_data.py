import csv, math, random
from pathlib import Path

SEED = 4260
N = 320
WAVES = 4
ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'data' / 'demo' / 'meaning_pathways_longitudinal.csv'

FIELDS = ['participant_id','synthetic_flag','age','gender','stressor_type','months_since_stressor_t1','baseline_stressor_severity','baseline_religiosity']
for stem in ['mv_belief1','mv_belief2','mv_goal1','mv_goal2','meaning1','meaning2','meaning3','meaning4','prc1','prc2','prc3','prc4','struggle1','struggle2','struggle3','struggle4','recovery1','recovery2','recovery3','recovery4']:
    for t in range(1, WAVES+1): FIELDS.append(f'{stem}_t{t}')
for t in range(1, WAVES+1): FIELDS.append(f'wave{t}_observed')
for stem in ['mv','meaning','prc','struggle','recovery']:
    for t in range(1, WAVES+1): FIELDS.append(f'{stem}_t{t}')

def clip(x, lo=1.0, hi=7.0): return max(lo, min(hi, x))
def item(mu, rng): return round(clip(mu + rng.gauss(0, .72)), 2)
def mean(xs): return round(sum(xs)/len(xs), 3)

def generate_rows(seed=SEED, n=N):
    rng = random.Random(seed)
    rows=[]
    stressors=['bereavement','health','relationship','occupational','disaster_or_accident','other']
    genders=['woman','man','nonbinary_or_other']
    for i in range(1,n+1):
        sev=clip(rng.gauss(5.0,1.0)); rel=clip(rng.gauss(4.4,1.4)); age=max(18,min(70,round(rng.gauss(39,10))))
        mv=clip(2.2 + .55*sev + rng.gauss(0,.65)); meaning=clip(5.2 - .33*mv + .10*rel + rng.gauss(0,.6)); prc=clip(2.0 + .32*rel + .15*mv + rng.gauss(0,.65)); struggle=clip(1.8 + .38*mv - .10*rel + rng.gauss(0,.7)); recovery=clip(3.1 + .35*meaning - .28*mv - .18*struggle + rng.gauss(0,.65))
        latent={1:(mv,meaning,prc,struggle,recovery)}
        for t in range(2,5):
            pmv,pmean,pprc,pstr,prec=latent[t-1]
            mv=clip(.61*pmv - .10*pmean + rng.gauss(0,.55))
            prc=clip(.58*pprc + .15*pmv + .08*rel + rng.gauss(0,.55))
            struggle=clip(.62*pstr + .13*mv - .06*pmean + rng.gauss(0,.55))
            meaning=clip(.52*pmean - .22*pmv + .14*prc - .10*pstr + 1.8 + rng.gauss(0,.5))
            recovery=clip(.48*prec + .31*meaning - .24*mv + .10*prc - .18*struggle + 1.1 + rng.gauss(0,.5))
            latent[t]=(mv,meaning,prc,struggle,recovery)
        obs=[True, i<=300, i<=285, i<=265]
        row={'participant_id':f'SYN{i:03d}','synthetic_flag':True,'age':age,'gender':rng.choices(genders,[.49,.49,.02])[0],'stressor_type':rng.choice(stressors),'months_since_stressor_t1':round(rng.uniform(1,3),1),'baseline_stressor_severity':round(sev,2),'baseline_religiosity':round(rel,2)}
        item_names=['mv_belief1','mv_belief2','mv_goal1','mv_goal2','meaning1','meaning2','meaning3','meaning4','prc1','prc2','prc3','prc4','struggle1','struggle2','struggle3','struggle4','recovery1','recovery2','recovery3','recovery4']
        for t in range(1,5):
            mv,meaning,prc,struggle,recovery=latent[t]
            centers=[mv]*4+[meaning]*4+[prc]*4+[struggle]*4+[recovery]*4
            vals=[]
            for name,center in zip(item_names,centers):
                v=item(center,rng) if obs[t-1] else ''
                row[f'{name}_t{t}']=v
                vals.append(v)
            row[f'wave{t}_observed']=obs[t-1]
            for stem,start in [('mv',0),('meaning',4),('prc',8),('struggle',12),('recovery',16)]:
                block=vals[start:start+4]
                row[f'{stem}_t{t}']=mean(block) if obs[t-1] else ''
        rows.append(row)
    return rows

def write_csv(path=OUT):
    path.parent.mkdir(parents=True, exist_ok=True)
    rows=generate_rows()
    with path.open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=FIELDS); w.writeheader(); w.writerows(rows)
    return path

if __name__=='__main__':
    p=write_csv(); print(f'Wrote {N} synthetic participants to {p}')

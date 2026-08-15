import numpy as np,pandas as pd,statsmodels.api as sm,statsmodels.formula.api as smf
def tidy(x,m):
 ci=x.conf_int(); return pd.DataFrame({'model':m,'term':x.params.index,'estimate':x.params.values,'se':x.bse.values,'ci_low':ci[0].values,'ci_high':ci[1].values,'p_value':x.pvalues.values})
def run(df):
 out=[]; out.append(tidy(smf.gee('distress ~ I(months/12) + acute_exposure + org_stress + supervisor_support + peer_support + stigma',groups='person_id',data=df,cov_struct=sm.cov_struct.Exchangeable()).fit(),'GEE distress'))
 x=df.sort_values(['person_id','wave']).copy()
 for c in ['distress','org_stress','acute_exposure','supervisor_support','stigma']: x['lag_'+c]=x.groupby('person_id')[c].shift()
 lag=x.dropna(subset=['lag_distress']); out.append(tidy(smf.ols('distress ~ lag_distress + lag_org_stress + lag_acute_exposure + lag_supervisor_support + lag_stigma + C(wave)',lag).fit(cov_type='cluster',cov_kwds={'groups':lag.person_id}),'Lagged panel distress'))
 out.append(tidy(smf.gee('help_seeking ~ distress + stigma + supervisor_support + peer_support + C(wave)',groups='person_id',data=df,family=sm.families.Binomial(),cov_struct=sm.cov_struct.Exchangeable()).fit(),'GEE help-seeking'))
 out.append(tidy(smf.glm('turnover_event ~ org_stress + burnout + supervisor_support + overtime_hours + C(wave)',df,family=sm.families.Binomial()).fit(),'Discrete-time turnover'))
 z=pd.concat(out,ignore_index=True); assert np.isfinite(z[['estimate','se','ci_low','ci_high','p_value']]).all().all(); return z

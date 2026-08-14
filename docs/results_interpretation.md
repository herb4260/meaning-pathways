# Synthetic Result Interpretation

This document describes the demo results generated for repository validation. **Nothing here is an empirical claim about real people.**

## 1. Mean trajectories

The generated cohort shows lower mean meaning violation and spiritual struggle from T1 to T4, alongside higher meaning in life and recovery. This gives the longitudinal models a coherent pattern to test.

## 2. Lightweight prospective sanity checks

Before running the full latent-variable models, simple regression checks verify that the generated data contain the intended directional relationships. In the current demo:

- T1 meaning predicts higher T2 meaning.
- T1 meaning violation predicts lower T2 meaning.
- T1 positive R/S coping predicts modestly higher T2 meaning.
- T1 spiritual struggle predicts lower T2 meaning.
- T3 meaning predicts higher T4 recovery.
- T3 meaning violation predicts lower T4 recovery.
- T3 spiritual struggle predicts lower T4 recovery.
- The direct T3 positive R/S coping coefficient for T4 recovery is smaller and more uncertain than the meaning pathway, which is consistent with treating coping as part of an indirect process rather than a guaranteed direct benefit.

## 3. Spiritual-struggle groups

Participants in the synthetic high-struggle third have lower average recovery at every wave than participants in the low-struggle third. All groups improve over time. This figure is descriptive and does not establish that spiritual struggle causes poorer recovery.

## 4. What the advanced models are intended to add

- **Measurement invariance** asks whether score changes can be interpreted as changes in the same latent construct across time.
- **Latent growth modeling** estimates average change and individual differences in change.
- **RI-CLPM** separates stable between-person differences from within-person temporal dynamics.
- **Longitudinal mediation** evaluates whether reconstructed meaning statistically carries part of the early-disruption-to-later-recovery association.
- **Moderated mediation** evaluates whether that indirect pathway differs across levels of spiritual struggle.

The advanced model results should be reported only after the R scripts run successfully and model diagnostics are reviewed.

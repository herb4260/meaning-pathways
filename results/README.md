# Results directory

`python_sanity_checks.csv` is a lightweight verification that the synthetic data generator produced the intended broad longitudinal relations. It is **not** a substitute for the SEM models.

Running `Rscript scripts/run_all.R` generates:

- `measurement_invariance_fit.csv`
- `latent_growth_fit.csv` and standardized paths
- `ri_clpm_fit.csv` and standardized paths
- `mediation_fit.csv` and indirect effects
- `moderated_mediation_fit.csv` and conditional indirect effects
- wave means, qualitative code counts, and a trajectory figure

All outputs refer only to synthetic data.

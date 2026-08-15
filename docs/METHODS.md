# Methods

## Conceptual structure
The design separates **acute occupational exposure** (critical incidents, violence exposure) from **chronic organizational/operational stress** (overtime, staffing pressure, schedule instability, perceived fairness). It then evaluates support, stigma, help-seeking, distress, burnout, suicidal ideation, and retention over time.

## Mixed-methods logic
The synthetic cohort links three evidence streams by `person_id` and `wave`: (1) repeated self-report measures, (2) administrative/personnel indicators, and (3) semi-structured interview excerpts. Quantitative and qualitative results are integrated in a joint-display table.

## Quantitative models
- GEE Gaussian model for repeated distress.
- Lagged panel regression for prior-wave predictors of next-wave distress.
- Binomial GEE for repeated help-seeking.
- Discrete-time logistic model for turnover hazard.

## Qualitative component
Synthetic interview excerpts are generated from a transparent theme dictionary: stigma, organizational distrust, supervisor support, peer support, workload, critical incidents, and help-seeking access. Coding is deterministic and auditable; it demonstrates a reproducible content-analysis workflow rather than inference about real interviews.

## Methodological grounding
The architecture is informed by public descriptions of longitudinal correctional-officer well-being research combining repeated interviews, organizational context, administrative/personnel records, and qualitative inquiry, including Northeastern University's *Turning Points in the Careers of Correction Officers* and correction-officer well-being projects. Sample size, variables, simulation mechanisms, code, and results are original to this repository.

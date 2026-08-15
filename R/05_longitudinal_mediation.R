source("R/model_helpers.R")
dat <- read_longitudinal_data()
dat <- add_scale_scores(dat)

med_vars <- c(
  "mv_t1", "prc_t1", "prc_t2", "struggle_t1",
  "meaning_t1", "meaning_t3", "recovery_t1", "recovery_t4",
  "baseline_stressor_severity"
)
med_dat <- dat[, med_vars, drop = FALSE]
med_dat[] <- lapply(med_dat, as.numeric)
stopifnot(!anyDuplicated(names(med_dat)))

model <- '
  prc_t2 ~ a*mv_t1 + ar1*prc_t1 + s1*struggle_t1 + q1*baseline_stressor_severity
  meaning_t3 ~ b*prc_t2 + ar2*meaning_t1 + m1*mv_t1 + s2*struggle_t1
  recovery_t4 ~ c*meaning_t3 + ar3*recovery_t1 + cp*mv_t1 + q2*baseline_stressor_severity

  indirect_serial := a*b*c
  direct := cp
  total := cp + indirect_serial
'
fit <- sem(
  model,
  data = med_dat,
  missing = "fiml",
  estimator = "ML",
  se = "bootstrap",
  bootstrap = 2000,
  fixed.x = FALSE
)
write.csv(fit_row("serial_longitudinal_mediation", fit), "results/mediation_fit.csv", row.names = FALSE)
write_standardized_paths(fit, "results/mediation_paths.csv")

source("R/model_helpers.R")
dat <- read_longitudinal_data()
dat <- add_scale_scores(dat)
for (v in c("mv_t1", "prc_t2", "struggle_t2", "meaning_t3", "recovery_t4", "recovery_t1", "baseline_stressor_severity")) {
  dat[[paste0("z_", v)]] <- as.numeric(scale(dat[[v]]))
}
dat$prcXstruggle_t2 <- dat$z_prc_t2 * dat$z_struggle_t2
model <- '
  z_prc_t2 ~ a*z_mv_t1
  z_meaning_t3 ~ b*z_prc_t2 + w*z_struggle_t2 + int*prcXstruggle_t2 + m*z_mv_t1
  z_recovery_t4 ~ c*z_meaning_t3 + ar*z_recovery_t1 + cp*z_mv_t1 + q*z_baseline_stressor_severity

  ind_low := a*(b + int*(-1))*c
  ind_mean := a*b*c
  ind_high := a*(b + int*(1))*c
'
fit <- sem(model, data = dat, missing = "fiml", estimator = "ML", se = "bootstrap", bootstrap = 2000, fixed.x = FALSE)
write.csv(fit_row("moderated_serial_mediation", fit), "results/moderated_mediation_fit.csv", row.names = FALSE)
write_standardized_paths(fit, "results/moderated_mediation_paths.csv")

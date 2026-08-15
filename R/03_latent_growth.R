source("R/model_helpers.R")
dat <- read_longitudinal_data()
dat <- add_scale_scores(dat)

growth_vars <- c(
  paste0("recovery_t", 1:4),
  "baseline_stressor_severity", "mv_t1", "prc_t1", "struggle_t1"
)
growth_dat <- dat[, growth_vars, drop = FALSE]
growth_dat[] <- lapply(growth_dat, as.numeric)
stopifnot(!anyDuplicated(names(growth_dat)))

model <- '
  i =~ 1*recovery_t1 + 1*recovery_t2 + 1*recovery_t3 + 1*recovery_t4
  s =~ 0*recovery_t1 + 1*recovery_t2 + 2*recovery_t3 + 3*recovery_t4
  i ~ baseline_stressor_severity + mv_t1 + prc_t1 + struggle_t1
  s ~ baseline_stressor_severity + mv_t1 + prc_t1 + struggle_t1
  i ~~ s
'
fit <- growth(
  model,
  data = growth_dat,
  missing = "fiml",
  estimator = "MLR",
  fixed.x = FALSE
)
write.csv(fit_row("recovery_lgcm", fit), "results/latent_growth_fit.csv", row.names = FALSE)
write_standardized_paths(fit, "results/latent_growth_paths.csv")

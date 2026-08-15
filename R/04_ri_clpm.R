source("R/model_helpers.R")
dat <- read_longitudinal_data()
dat <- add_scale_scores(dat)

ri_vars <- c(paste0("mv_t", 1:4), paste0("meaning_t", 1:4))
ri_dat <- dat[, ri_vars, drop = FALSE]
ri_dat[] <- lapply(ri_dat, as.numeric)
stopifnot(!anyDuplicated(names(ri_dat)))

model <- '
  RI_MV =~ 1*mv_t1 + 1*mv_t2 + 1*mv_t3 + 1*mv_t4
  RI_MEAN =~ 1*meaning_t1 + 1*meaning_t2 + 1*meaning_t3 + 1*meaning_t4

  wMV1 =~ 1*mv_t1
  wMV2 =~ 1*mv_t2
  wMV3 =~ 1*mv_t3
  wMV4 =~ 1*mv_t4
  wMEAN1 =~ 1*meaning_t1
  wMEAN2 =~ 1*meaning_t2
  wMEAN3 =~ 1*meaning_t3
  wMEAN4 =~ 1*meaning_t4

  mv_t1 ~~ 0*mv_t1
  mv_t2 ~~ 0*mv_t2
  mv_t3 ~~ 0*mv_t3
  mv_t4 ~~ 0*mv_t4
  meaning_t1 ~~ 0*meaning_t1
  meaning_t2 ~~ 0*meaning_t2
  meaning_t3 ~~ 0*meaning_t3
  meaning_t4 ~~ 0*meaning_t4

  RI_MV ~~ RI_MEAN
  RI_MV ~~ 0*wMV1 + 0*wMV2 + 0*wMV3 + 0*wMV4 + 0*wMEAN1 + 0*wMEAN2 + 0*wMEAN3 + 0*wMEAN4
  RI_MEAN ~~ 0*wMV1 + 0*wMV2 + 0*wMV3 + 0*wMV4 + 0*wMEAN1 + 0*wMEAN2 + 0*wMEAN3 + 0*wMEAN4

  wMV2 ~ a*wMV1 + c*wMEAN1
  wMV3 ~ a*wMV2 + c*wMEAN2
  wMV4 ~ a*wMV3 + c*wMEAN3
  wMEAN2 ~ b*wMEAN1 + d*wMV1
  wMEAN3 ~ b*wMEAN2 + d*wMV2
  wMEAN4 ~ b*wMEAN3 + d*wMV3

  wMV1 ~~ wMEAN1
  wMV2 ~~ wMEAN2
  wMV3 ~~ wMEAN3
  wMV4 ~~ wMEAN4
'
fit <- sem(
  model,
  data = ri_dat,
  missing = "fiml",
  estimator = "MLR",
  meanstructure = TRUE
)
assert_model_ok("meaning_violation_meaning_ri_clpm", fit)
write.csv(fit_row("meaning_violation_meaning_ri_clpm", fit), "results/ri_clpm_fit.csv", row.names = FALSE)
write_standardized_paths(fit, "results/ri_clpm_paths.csv")
cat("RI-CLPM complete.\n")

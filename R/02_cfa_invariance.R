source("R/model_helpers.R")
dat <- read_longitudinal_data()

resid_cor <- paste(c(
  unlist(lapply(1:4, function(i) paste0("meaning", i, "_t1 ~~ meaning", i, "_t2 + meaning", i, "_t3 + meaning", i, "_t4"))),
  unlist(lapply(1:4, function(i) paste0("meaning", i, "_t2 ~~ meaning", i, "_t3 + meaning", i, "_t4"))),
  unlist(lapply(1:4, function(i) paste0("meaning", i, "_t3 ~~ meaning", i, "_t4"))),
  unlist(lapply(1:4, function(i) paste0("recovery", i, "_t1 ~~ recovery", i, "_t2 + recovery", i, "_t3 + recovery", i, "_t4"))),
  unlist(lapply(1:4, function(i) paste0("recovery", i, "_t2 ~~ recovery", i, "_t3 + recovery", i, "_t4"))),
  unlist(lapply(1:4, function(i) paste0("recovery", i, "_t3 ~~ recovery", i, "_t4")))
), collapse = "\n")

configural <- paste0('
f_meaning_t1 =~ meaning1_t1 + meaning2_t1 + meaning3_t1 + meaning4_t1
f_meaning_t2 =~ meaning1_t2 + meaning2_t2 + meaning3_t2 + meaning4_t2
f_meaning_t3 =~ meaning1_t3 + meaning2_t3 + meaning3_t3 + meaning4_t3
f_meaning_t4 =~ meaning1_t4 + meaning2_t4 + meaning3_t4 + meaning4_t4
f_recovery_t1 =~ recovery1_t1 + recovery2_t1 + recovery3_t1 + recovery4_t1
f_recovery_t2 =~ recovery1_t2 + recovery2_t2 + recovery3_t2 + recovery4_t2
f_recovery_t3 =~ recovery1_t3 + recovery2_t3 + recovery3_t3 + recovery4_t3
f_recovery_t4 =~ recovery1_t4 + recovery2_t4 + recovery3_t4 + recovery4_t4
', resid_cor)

metric <- paste0('
f_meaning_t1 =~ lm1*meaning1_t1 + lm2*meaning2_t1 + lm3*meaning3_t1 + lm4*meaning4_t1
f_meaning_t2 =~ lm1*meaning1_t2 + lm2*meaning2_t2 + lm3*meaning3_t2 + lm4*meaning4_t2
f_meaning_t3 =~ lm1*meaning1_t3 + lm2*meaning2_t3 + lm3*meaning3_t3 + lm4*meaning4_t3
f_meaning_t4 =~ lm1*meaning1_t4 + lm2*meaning2_t4 + lm3*meaning3_t4 + lm4*meaning4_t4
f_recovery_t1 =~ lr1*recovery1_t1 + lr2*recovery2_t1 + lr3*recovery3_t1 + lr4*recovery4_t1
f_recovery_t2 =~ lr1*recovery1_t2 + lr2*recovery2_t2 + lr3*recovery3_t2 + lr4*recovery4_t2
f_recovery_t3 =~ lr1*recovery1_t3 + lr2*recovery2_t3 + lr3*recovery3_t3 + lr4*recovery4_t3
f_recovery_t4 =~ lr1*recovery1_t4 + lr2*recovery2_t4 + lr3*recovery3_t4 + lr4*recovery4_t4
', resid_cor)

scalar_intercepts <- paste(c(
  unlist(lapply(1:4, function(i) paste0("meaning", i, "_t1 ~ im", i, "*1\nmeaning", i, "_t2 ~ im", i, "*1\nmeaning", i, "_t3 ~ im", i, "*1\nmeaning", i, "_t4 ~ im", i, "*1"))),
  unlist(lapply(1:4, function(i) paste0("recovery", i, "_t1 ~ ir", i, "*1\nrecovery", i, "_t2 ~ ir", i, "*1\nrecovery", i, "_t3 ~ ir", i, "*1\nrecovery", i, "_t4 ~ ir", i, "*1")))
), collapse = "\n")
latent_means <- "f_meaning_t1 ~ 0*1\nf_meaning_t2 ~ 1\nf_meaning_t3 ~ 1\nf_meaning_t4 ~ 1\nf_recovery_t1 ~ 0*1\nf_recovery_t2 ~ 1\nf_recovery_t3 ~ 1\nf_recovery_t4 ~ 1"
scalar <- paste(metric, scalar_intercepts, latent_means, sep = "\n")

fits <- list(
  configural = cfa(configural, data = dat, std.lv = TRUE, missing = "fiml", estimator = "MLR", meanstructure = TRUE),
  metric = cfa(metric, data = dat, std.lv = TRUE, missing = "fiml", estimator = "MLR", meanstructure = TRUE),
  scalar = cfa(scalar, data = dat, std.lv = TRUE, missing = "fiml", estimator = "MLR", meanstructure = TRUE)
)
fit_table <- do.call(rbind, Map(fit_row, names(fits), fits))
write.csv(fit_table, "results/measurement_invariance_fit.csv", row.names = FALSE)
cat("Measurement invariance models complete. Compare changes in CFI/RMSEA as well as chi-square.\n")

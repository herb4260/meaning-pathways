scripts <- c(
  "R/01_data_validation.R",
  "R/02_cfa_invariance.R",
  "R/03_latent_growth.R",
  "R/04_ri_clpm.R",
  "R/05_longitudinal_mediation.R",
  "R/06_moderated_mediation.R",
  "R/07_visualization.R",
  "R/08_qualitative_summary.R"
)
for (s in scripts) {
  message("Running ", s)
  source(s, echo = FALSE)
}
message("All Meaning Pathways analyses completed.")

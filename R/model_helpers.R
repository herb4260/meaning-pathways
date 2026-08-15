suppressPackageStartupMessages({
  library(lavaan)
})

parse_logical_column <- function(x, name = "logical column") {
  if (is.logical(x)) return(x)

  raw <- trimws(tolower(as.character(x)))
  out <- rep(NA, length(raw))

  true_values <- c("true", "t", "1", "yes", "y")
  false_values <- c("false", "f", "0", "no", "n")
  missing_values <- c("", "na", "nan", "null")

  out[raw %in% true_values] <- TRUE
  out[raw %in% false_values] <- FALSE
  out[raw %in% missing_values | is.na(raw)] <- NA

  unknown <- unique(raw[!is.na(raw) & !(raw %in% c(true_values, false_values, missing_values))])
  if (length(unknown) > 0) {
    stop(sprintf("Unexpected value(s) in %s: %s", name, paste(unknown, collapse = ", ")))
  }

  out
}

read_longitudinal_data <- function() {
  path <- "data/demo/meaning_pathways_longitudinal.csv"
  if (!file.exists(path)) {
    status <- system2("python3", "scripts/generate_synthetic_data.py")
    if (status != 0 || !file.exists(path)) stop("Synthetic data generation failed")
  }

  dat <- read.csv(path, stringsAsFactors = FALSE)
  logical_cols <- intersect(
    c("synthetic_flag", paste0("wave", 1:4, "_observed")),
    names(dat)
  )
  for (v in logical_cols) {
    dat[[v]] <- parse_logical_column(dat[[v]], v)
  }

  dat
}

safe_row_mean <- function(dat, vars) {
  x <- dat[, vars, drop = FALSE]
  out <- rowMeans(x, na.rm = TRUE)
  out[rowSums(!is.na(x)) == 0] <- NA_real_
  out
}

add_scale_scores <- function(dat) {
  for (t in 1:4) {
    dat[[paste0("mv_t", t)]] <- safe_row_mean(dat, c(
      paste0("mv_belief1_t", t), paste0("mv_belief2_t", t),
      paste0("mv_goal1_t", t), paste0("mv_goal2_t", t)))
    dat[[paste0("meaning_t", t)]] <- safe_row_mean(dat, paste0("meaning", 1:4, "_t", t))
    dat[[paste0("prc_t", t)]] <- safe_row_mean(dat, paste0("prc", 1:4, "_t", t))
    dat[[paste0("struggle_t", t)]] <- safe_row_mean(dat, paste0("struggle", 1:4, "_t", t))
    dat[[paste0("recovery_t", t)]] <- safe_row_mean(dat, paste0("recovery", 1:4, "_t", t))
  }
  dat
}

fit_row <- function(name, fit) {
  fm <- fitMeasures(fit, c("chisq", "df", "cfi", "tli", "rmsea", "srmr", "aic", "bic"))
  data.frame(model = name, t(fm), check.names = FALSE)
}

write_standardized_paths <- function(fit, path) {
  pe <- parameterEstimates(fit, standardized = TRUE, ci = TRUE)
  pe <- pe[pe$op %in% c("~", ":="), ]
  write.csv(pe, path, row.names = FALSE)
}

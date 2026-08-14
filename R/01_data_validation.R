source("R/model_helpers.R")
dat <- read_longitudinal_data()
stopifnot(nrow(dat) == 320)
stopifnot(all(dat$synthetic_flag %in% c(TRUE, "True", "TRUE", 1)))
stopifnot(length(unique(dat$participant_id)) == nrow(dat))
item_cols <- grep("^(mv_|meaning|prc|struggle|recovery)[A-Za-z0-9_]*_t[1-4]$", names(dat), value = TRUE)
item_cols <- item_cols[!grepl("^(mv|meaning|prc|struggle|recovery)_t[1-4]$", item_cols)]
for (v in item_cols) {
  x <- dat[[v]]
  stopifnot(all(is.na(x) | (x >= 1 & x <= 7)))
}
for (t in 2:4) {
  prev <- dat[[paste0("wave", t-1, "_observed")]]
  curr <- dat[[paste0("wave", t, "_observed")]]
  stopifnot(!any(curr & !prev))
}
cat("Validation passed:", nrow(dat), "synthetic participants.\n")

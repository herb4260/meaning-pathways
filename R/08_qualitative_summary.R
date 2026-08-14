x <- read.csv("data/demo/synthetic_interview_excerpts.csv")
stopifnot(all(x$synthetic_flag %in% c(TRUE, "True", "TRUE", 1)))
out <- as.data.frame(table(x$candidate_code), stringsAsFactors = FALSE)
names(out) <- c("candidate_code", "n_excerpts")
out <- out[order(-out$n_excerpts), ]
write.csv(out, "results/qualitative_code_counts.csv", row.names = FALSE)

source("R/model_helpers.R")
suppressPackageStartupMessages(library(ggplot2))
dat <- read_longitudinal_data()
dat <- add_scale_scores(dat)
long <- do.call(rbind, lapply(1:4, function(t) data.frame(
  participant_id = dat$participant_id,
  wave = t,
  meaning = dat[[paste0("meaning_t", t)]],
  recovery = dat[[paste0("recovery_t", t)]],
  meaning_violation = dat[[paste0("mv_t", t)]]
)))
means <- aggregate(cbind(meaning, recovery, meaning_violation) ~ wave, data = long, FUN = function(x) mean(x, na.rm = TRUE))
write.csv(means, "results/wave_means.csv", row.names = FALSE)

png("figures/recovery_trajectories.png", width = 1400, height = 900, res = 160)
p <- ggplot(long, aes(wave, recovery, group = participant_id)) +
  geom_line(alpha = .08) +
  stat_summary(aes(group = 1), fun = mean, geom = "line", linewidth = 1.3) +
  stat_summary(aes(group = 1), fun = mean, geom = "point", size = 2.5) +
  scale_x_continuous(breaks = 1:4) +
  labs(title = "Synthetic recovery trajectories", x = "Wave", y = "Recovery / functioning") +
  theme_minimal(base_size = 13)
print(p)
dev.off()

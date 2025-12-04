#load merged dataset and all preprocessing
source("analysis.R")

plot_age_sex <- ggplot(plot_df, aes(x = Age, y = NPQ, colour = Sex)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "loess", se = FALSE, size = 1.1) +
  scale_colour_manual(values = c("Male" = "blue", "Female" = "red")) +
  facet_wrap(~ Protein, scales = "free_y", ncol = 5) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Age Trends by Sex Across Top Variable Proteins",
    x = "Age (years)",
    y = "Protein Expression (NPQ)"
  )
ggsave(
  filename = "plot_age_sex.png",
  plot = plot_age_sex,
  width = 14,
  height = 9,
  dpi = 300
)

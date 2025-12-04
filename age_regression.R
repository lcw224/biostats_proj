#load merged dataset and all preprocessing
source("analysis.R")

plot_df$Protein <- stringr::str_wrap(plot_df$Protein, width = 8)

plot_age_regression <- ggplot(plot_df, aes(x = Age, y = NPQ)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, colour = "red", size = 1) +
  facet_wrap(~ Protein, scales = "free_y", ncol = 5) +
  theme_minimal(base_size = 14) +
  theme(strip.text = element_text(size = 10)) +
  labs(
    title = "Linear Regression: Age vs Top Variable Proteins",
    x = "Age (years)",
    y = "Protein Expression (NPQ)"
  )

#save regression plot
ggsave(
  filename = "plot_age_regression.png",
  plot = plot_age_regression,
  width = 12,
  height = 8,
  dpi = 300
)
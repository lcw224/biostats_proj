#load merged dataset and all preprocessing
source("analysis.R")

plot_sex_box <- ggplot(plot_df, aes(x = Sex, y = NPQ, fill = Sex)) +
  geom_boxplot(alpha = 0.7, outlier.size = 0.8) +
  scale_fill_manual(values = c("Male" = "blue", "Female" = "red")) +
  facet_wrap(~ Protein, scales = "free_y", ncol = 5) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Distribution of Protein Expression by Sex",
    x = "Sex",
    y = "Protein Expression (NPQ)"
  )
ggsave(
  filename = "plot_sex_box.png",
  plot = plot_sex_box,
  width = 14,
  height = 9,
  dpi = 300
)

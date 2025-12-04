library(ggplot2)
library(reshape2)

#load merged dataset and all preprocessing
source("analysis.R")

corr_data <- protein_data[, top_variable_proteins]
corr_matrix <- cor(corr_data, use = "pairwise.complete.obs", method = "pearson")

#convert square corr_matrix to long format
corr_melt <- melt(corr_matrix)

colnames(corr_melt) <- c("Protein1", "Protein2", "Correlation")

#plot heatmap
plot_corr_heatmap <- ggplot(corr_melt, aes(x = Protein1, y = Protein2, fill = Correlation)) +
  geom_tile() +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    midpoint = 0,
    limits = c(-1, 1)
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  ) +
  labs(
    title = "Correlation Heatmap of Top 10 Variable Proteins",
    fill = "Correlation"
  )

#save plot
ggsave(
  filename = "plot_corr_heatmap.png",
  plot = plot_corr_heatmap,
  width = 8,
  height = 7,
  dpi = 300
)
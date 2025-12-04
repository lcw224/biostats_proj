library(ggplot2)
library(stringr)

#load merged dataset and all preprocessing
source("analysis.R")

#compute variance per protein 
exclude_cols <- c("SampleName", "Plasma.ID", "Sex",
                  "Race1", "Race2", "Ethnicity", "Age")

protein_data <- merged[, !(colnames(merged) %in% exclude_cols)]
var_values <- apply(protein_data, 2, var, na.rm = TRUE)
#top 10 variance proteins
top_variable_proteins <- names(sort(var_values, decreasing = TRUE))[1:10]

#build long format dataset
plot_data <- merged[, c("Plasma.ID", "Age", "Sex", top_variable_proteins)]

#convert protein columns to numeric
for (p in top_variable_proteins) {
  plot_data[[p]] <- suppressWarnings(as.numeric(plot_data[[p]]))
}

Protein <- character()
Age_vec <- numeric()
NPQ_vec <- numeric()

for (p in top_variable_proteins) {
  Protein <- c(Protein, rep(p, nrow(plot_data)))
  Age_vec <- c(Age_vec, plot_data$Age)
  NPQ_vec <- c(NPQ_vec, plot_data[[p]])
}

plot_df <- data.frame(
  Age = Age_vec,
  Sex = rep(plot_data$Sex, times = length(top_variable_proteins)),
  Protein = Protein,
  NPQ = NPQ_vec,
  stringsAsFactors = FALSE
)

plot_df$Protein <- factor(plot_df$Protein, levels = top_variable_proteins)


# -------------------------------------------------------------
# 3. Plot using ggplot2 (NO pipes)
# -------------------------------------------------------------

plot_df$Protein <- stringr::str_wrap(plot_df$Protein, width = 8)

plot_age_proteins <- ggplot(plot_df, aes(x = Age, y = NPQ)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, colour = "blue", size = 1) +
  facet_wrap(~ Protein, scales = "free_y", ncol = 5) +
  theme_minimal(base_size = 14) +
  theme(strip.text = element_text(size = 10)) +
  labs(
    title = "Age-Related Trends in Top Variable Proteins",
    x = "Age (years)",
    y = "Protein Expression (NPQ)"
  )

#save plot
ggsave(
  filename = "plot_age_proteins.png",
  plot = plot_age_proteins,
  width = 12,
  height = 8,
  dpi = 300
)
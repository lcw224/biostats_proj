#load merged dataset and all preprocessing
source("analysis.R")

#tell R “Sex” is a category
merged$Sex <- factor(merged$Sex)

set.seed(41)

#total number of samples
n <- nrow(merged)

#randomly select 70% of samples for training model
train_index <- sample(1:n, size = 0.7 * n)

train_data <- merged[train_index, ]
test_data  <- merged[-train_index, ]

#fit logistic regression model using top 10 variance proteins to classify sex
log_model <- glm(
  Sex ~ ., 
  data = train_data[, c("Sex", top_variable_proteins)],
  family = binomial
)

test_subset <- test_data[, c("Sex", top_variable_proteins)]

#predict probabilities where higher probability represents "Male"
probabilities <- predict(log_model, newdata = test_subset, type = "response")
predicted <- ifelse(probabilities > 0.5, "Male", "Female")

#compute accuracy
actual <- as.character(test_subset$Sex)  
accuracy <- mean(predicted == actual)     

conf_mat <- table(Predicted = predicted, Actual = actual)
conf_df <- as.data.frame(conf_mat)
colnames(conf_df) <- c("Predicted", "Actual", "Count")

library(ggplot2)

conf_plot <- ggplot(conf_df, aes(x = Actual, y = Predicted, fill = Count)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Count), size = 6) +
  scale_fill_gradient(low = "#DCEEFF", high = "#003366") +
  labs(
    title = "Confusion Matrix (Gender Classifier)",
    x = "Actual",
    y = "Predicted"
  ) +
  theme_minimal(base_size = 14)

ggsave(
  filename = "plot_sex_classifier.png",
  plot = conf_plot,
  width = 6,
  height = 5,
  dpi = 300
)
library(tidyverse)
library(caret)

train <- read.csv('data/hw7_train.csv')
test <- read.csv('data/hw7_test.csv')

##### Removing IDs
test.id <- test$id
train$id <- NULL
test$id <- NULL

##### Extracting TARGET
train.y <- train$label
train.y <- ifelse(train.y == 1, "g", "b")
train$label <- NULL

##### Evaluation
evaluate <- function(truth, data_prediction) {
    # Confusion Matrix
    Confusion_matrix <- table(truth, data_prediction)
    
    # Calculate Precision
    precision <- Confusion_matrix[2, 2] / sum(Confusion_matrix[, 2])
    
    # Calculate Recall (Sensitivity)
    recall <- Confusion_matrix[2, 2] / sum(Confusion_matrix[2, ])
    
    # Calculate F1_score
    f1_score <- 2 * precision * recall / (precision + recall)
    
    # Print the results
    print("Precision:")
    print(precision)
    print("Recall:")
    print(recall)
    print("F1_score:")
    print(f1_score)
    print("\n")
}

trctrl <- trainControl(
    method = "cv", 
    number = 5,
    search = "grid",
    classProbs = TRUE,
    allowParallel = TRUE
)

tune_grid <- expand.grid(
    nrounds = c(100, 200),
    max_depth = c(5, 6),
    eta = 0.05,
    gamma = 0.01,
    colsample_bytree = 0.75,
    min_child_weight = 0,
    subsample = 0.5
)

fit <- caret::train(
    train,
    train.y,
    method = "xgbTree",
    trControl = trctrl,
    tuneGrid = tune_grid,
    verbosity = 0  # To get rid of xgboost warnings
)

##### Evaluate on train
train_preds <- predict(fit, train, type = "raw")
train_preds <- ifelse(train_preds == "g", 1, -1)
evaluate(train.y, train_preds)

##### Start prediction
preds <- predict(fit, test, type = "raw")
preds <- ifelse(preds == "g", 1, -1)

predict_df <- data.frame(id = test.id, label = preds)

write.csv(
    predict_df,
    file = './output/111753151.csv',
    quote = FALSE,
    row.names = FALSE
)
library(tidyverse)
library(neuralnet)
library(caret)

train <- read.csv('data/hw7_train.csv')
test <- read.csv('data/hw7_test.csv')

##### 
test.id <- test$id
train$id <- NULL
test$id <- NULL

train$label <- ifelse(train$label == -1, 1, 0)

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

feature_length <- length(colnames(train)) - 1

formula <- "label ~ feature1"
for (counter in 2:feature_length) {
    str <- paste0("+ feature", counter)
    formula <- paste(formula, str)
}

# tune parameters
model <- caret::train(formula = eval(parse(text = formula)),     # formula
               data=train,           # 資料
               method="neuralnet",   # 類神經網路(bpn)
               
               # 最重要的步驟：觀察不同排列組合(第一層1~4個nodes ; 第二層0~4個nodes)
               # 看何種排列組合(多少隱藏層、每層多少個node)，會有最小的RMSE
               tuneGrid = expand.grid(.layer1=c(1:4), .layer2=c(0:4), .layer3=c(0)),               
               
               # 以下的參數設定，和上面的neuralnet內一樣
               learningrate = 0.01,  # learning rate
               threshold = 0.01,     # partial derivatives of the error function, a stopping criteria
               stepmax = 5e5         # 最大的ieration數 = 500000(5*10^5)
)

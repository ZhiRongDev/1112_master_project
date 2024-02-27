start_time <- Sys.time()
options(warn = -1)

library(dplyr) # For pipeline %>%
library(ROSE)   # For oversampling the minority class
library(caret)  # For Classification And Regression Training

print("Parsing Arguments......")
args <- commandArgs(trailingOnly = TRUE)
train_path <- NA
test_path <- NA
predict_path <- NA

if (length(args) < 6) {
    stop("Missing argument, check your command format", call. = FALSE)
} else {
    for (args_counter in seq_along(args)) {
        if (args[args_counter] == "--train") {
            if (!file_test("-f", args[args_counter + 1])) {
                print(args[args_counter + 1])
                stop("train_csv is not defined, or not correctly named.")
            } else {
                train_path <- args[args_counter + 1]
            }
            
        } else if (args[args_counter] == "--test") {
            if (!file_test("-f", args[args_counter + 1])) {
                print(args[args_counter + 1])
                stop("test_csv not defined, or not correctly named.")
            } else {
                test_path <- args[args_counter + 1]
            }
        } else if (args[args_counter] == "--predict") {
            predict_path <- args[args_counter + 1]
        }
    }
}

if (is.na(train_path)) {
    stop("Missing --train argument", call. = FALSE)
} else if (is.na(test_path)) {
    stop("Missing --test argument", call. = FALSE)
} else if (is.na(predict_path)) {
    stop("Missing --predict argument", call. = FALSE)
}

print("loading Data......")
train <- read.csv(train_path)
test <- read.csv(test_path)

# Evaluation
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

# Balancing classes using oversampling
oversampling <- function(origin_data) {
    new_data <- ROSE(SeriousDlqin2yrs ~ ., data = origin_data)$data
    return(new_data)
}

train_preprocess <- function(origin_data, replace_data = train) {
    new_data <-
        origin_data %>%
        mutate(
            X = NULL,
            SeriousDlqin2yrs = as.factor(ifelse(SeriousDlqin2yrs == 1, "y", "n")),
            
            # 眾數
            NumberOfDependents = ifelse(is.na(NumberOfDependents), 0, NumberOfDependents),
            
            # 中位數
            MonthlyIncome = ifelse(
                is.na(MonthlyIncome),
                median(replace_data$MonthlyIncome, na.rm = TRUE),
                MonthlyIncome
            ),
        ) %>%
        filter(
            origin_data$age > 0,
            origin_data$RevolvingUtilizationOfUnsecuredLines < 13,
            origin_data$NumberOfTimes90DaysLate <= 17,
            origin_data$DebtRatio <= quantile(origin_data$DebtRatio, 0.975),
        )
    
    # remove duplicated
    new_data <- new_data[!duplicated(new_data), ]
    return(new_data)
}

test_preprocess <- function(origin_data, replace_data = train) {
    new_data <-
        origin_data %>%
        mutate(
            X = NULL,
            SeriousDlqin2yrs = as.factor(ifelse(SeriousDlqin2yrs == 1, "y", "n")),
            
            # 眾數
            NumberOfDependents = ifelse(is.na(NumberOfDependents), 0, NumberOfDependents),
            
            # 中位數
            MonthlyIncome = ifelse(
                is.na(MonthlyIncome),
                median(replace_data$MonthlyIncome, na.rm = TRUE),
                MonthlyIncome
            ),
        )
    return(new_data)
}

# Train a Naive Bayes classifier
nb <- function(data) {
    control_nb <- trainControl(
        method = "cv",
        number = 5,
        search = "grid",
        classProbs = TRUE,
        summaryFunction = prSummary,
    )
    nb_grid <- expand.grid(
        usekernel = c(TRUE, FALSE),
        fL = c(0.1), # Laplace smoothing
        adjust = c(0.5)
    )
    train_nb <- train(
        SeriousDlqin2yrs ~ .,
        data = data,
        method = "nb",
        metric = "F",
        tuneGrid = nb_grid,
        trControl = control_nb,
        verbose = TRUE, # displays additional information and progress updates as the model is being trained.
    )
    return(train_nb)
}

print("Data preprocessing......")
train_clean <-
    train %>%
    train_preprocess() %>%
    oversampling()

test_clean <-
    test %>%
    test_preprocess()


print("Training Model......")
model <- nb(train_clean)

# Predict on train data
train_prediction <- predict(model, newdata = train_clean[, -1])

print("Evaluation:")
evaluate(train_clean[, 1], train_prediction)

print("Predicting......")
pred_prob <-
    predict(model, newdata = test_clean[, -1], type = "prob")
pred_prob_y <- pred_prob[, 2]

### create folders
folders <- unlist(strsplit(predict_path, "[/]"))
base_path <- folders[1]

if (length(folders) > 1) {
    for (i in 2:length(folders)) { 
        if (!file.exists(base_path)) {
            dir.create(base_path)
        }
        assign("base_path", paste0(base_path, "/", folders[i]))
    }
}

print("Making submission......")
# Make submission
predict_df <-
    data_frame(Id = c(1:length(test_clean[, 1])), Probability = pred_prob_y) %>%
    mutate(Probability = as.double(Probability), Id = as.integer(Id))

write.csv(
    predict_df,
    file = predict_path,
    quote = FALSE,
    row.names = FALSE
)

print("Success!")
end_time <- Sys.time()
print(end_time - start_time)
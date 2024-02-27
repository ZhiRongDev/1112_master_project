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

# Remove rows with NA values
remove_NA <- function(origin_data) {
    new_data <- na.omit(origin_data)
    return(new_data)
}

# Remove Outliers
# remove_Outliers <- function(origin_data) {
#     new_data <- 
# }


# replace NA with medium of each column in training Data
replaceMedian <- function(origin_data, replaceData = train) {
    new_data <- origin_data
    for (feature in colnames(new_data)) {
        if ((feature != "X") & (feature != "SeriousDlqin2yrs")) {
            median_val <- median(replaceData[[feature]], na.rm = TRUE)
            new_data[[feature]][is.na(new_data[[feature]])] <-
                median_val
        }
    }
    return (new_data)
}

# Remove insignificant Independent variables base on training data
feature_select <- function(origin_data) {
    # correlation of train
    data_cor <-
        cor(x = origin_data$SeriousDlqin2yrs, y = origin_data)
    new_data <- origin_data[, data_cor >= 0]
    return(new_data)
}

# Feature Scaling
feature_scale <- function(origin_data) {
    # scale all the columns except the 1st column
    origin_data[-1] <- scale(origin_data[-1])
    return(origin_data)
}

# Balancing classes using oversampling
oversampling <- function(origin_data) {
    new_data <- ROSE(SeriousDlqin2yrs ~ ., data = origin_data)$data
    return(new_data)
}

# Naive Bayes classifier can't be trained with numeric target, hence needed transformation
mutate_target <- function(origin_data) {
    new_data <-
        origin_data %>%
        mutate(SeriousDlqin2yrs = as.factor(ifelse(SeriousDlqin2yrs == 1, "y", "n")))
    return(new_data)
}

print("Evaluation:")
# Evaluation
evaluate <- function(truth, data_prediction) {
    # Confusion Matrix
    Confusion_matrix <- table(truth, data_prediction)
    
    # Calculate Precision
    precision <- Confusion_matrix[2, 2] / sum(Confusion_matrix[, 2])
    
    # Calculate Recall (Sensitivity)
    recall <- Confusion_matrix[2, 2] / sum(Confusion_matrix[2,])
    
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

print("Cleaning train data......")
train_clean <-
    train[, (-1)] %>%
    replaceMedian() %>%
    feature_select() %>%
    feature_scale() %>%
    oversampling() %>%
    mutate_target()

# Get the selected features
selected_features <- colnames(train_clean)

# sampling
set.seed(7)
train_clean <- sample_frac(train_clean, 1)

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
        fL = c(0.1),
        # Laplace smoothing
        adjust = c(0.5)
    )
    train_nb <- train(
        SeriousDlqin2yrs ~ .,
        data = data,
        method = "nb",
        metric = "F",
        tuneGrid = nb_grid,
        trControl = control_nb,
        verbose = TRUE,
        # displays additional information and progress updates as the model is being trained.
    )
    return(train_nb)
}

print("Training Model......")
model <- nb(train_clean)

# Predict on train data
train_prediction <- predict(model, newdata = train_clean[,-1])

evaluate(train_clean[, 1], train_prediction)

print("Cleaning test data......")
# Predict on test
test_clean <-
    test[, selected_features] %>%
    replaceMedian() %>%
    feature_scale()

print("Predicting......")
pred_prob <-
    predict(model, newdata = test_clean[,-1], type = "prob")
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

write.csv(predict_df,
          file = predict_path,
          quote = FALSE,
          row.names = FALSE)

print("Success!")
end_time <- Sys.time()
print(end_time - start_time)
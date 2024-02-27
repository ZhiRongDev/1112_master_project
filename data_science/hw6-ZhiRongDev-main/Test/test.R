# https://www.kaggle.com/code/mostig/starter-give-me-some-credit

start_time <- Sys.time()
options(warn = -1)

library(dplyr) # For pipeline %>%
library(ROSE)   # For oversampling the minority class
library(caret)  # For Classification And Regression Training

print("loading Data......")
train <- read.csv('Data/training.csv')
test <- read.csv('Data/test.csv')

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

# Balancing classes using oversampling
oversampling <- function(origin_data) {
    new_data <- ROSE(SeriousDlqin2yrs ~ ., data = origin_data)$data
    return(new_data)
}

train_clean <-
    train %>%
    train_preprocess() %>%
    oversampling()

test_clean <-
    test %>%
    test_preprocess()

View(train_clean)
View(test_clean)





print("Success!")
end_time <- Sys.time()
print(end_time - start_time)
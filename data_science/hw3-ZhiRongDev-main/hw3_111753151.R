start_time <- Sys.time()
options(warn = -1)

library("rpart")

args <- commandArgs(trailingOnly = TRUE)
fold_num <- NA
input_file <- NA
output_file <- NA

if (length(args) < 6) {
    stop("Missing argument, check your command format", call. = FALSE) # nolint
} else {
    for (args_counter in seq_along(args)) {
        if (args[args_counter] == "--fold") {
            fold_num <- as.numeric(args[args_counter + 1])
        } else if (args[args_counter] == "--input") {
            if (!file_test("-f", args[args_counter + 1])) {
                print(args[args_counter + 1])
                stop("inputFile not defined, or not correctly named.")
            } else {
                input_file <- args[args_counter + 1]
            }
        } else if (args[args_counter] == "--output") {
            output_file <- args[args_counter + 1]
        }
    }
}

if (is.na(fold_num)) {
    stop("Missing --fold argument", call. = FALSE)
} else if (is.na(input_file)) {
    stop("Missing --input argument", call. = FALSE)
} else if (is.na(output_file)) {
    stop("Missing --output argument", call. = FALSE)
}

# read input data, 這個作業的 V5603 是 NA, 有瑕疵所以要去掉
data <- read.csv(input_file, header = F)
data <- data[, 1:5602]

# Get CP, CW, EC, IM data
proteinLabel_df <- split(data, data$V2)

# 創建一個 fold_lists 儲存平均分配過 protein data 的 fold 資料
fold_lists <- list()
fold_lists_counter <- NULL

# 開始切 protein, 根據 --fold 將 CP, CW, EC, IM data 均等切割，再分配到 fold_lists 下的 fold1 ~ foldn
for (protein_name in names(proteinLabel_df)) {
    # reset the rowname
    rownames(proteinLabel_df[[protein_name]]) <- NULL
    df <- proteinLabel_df[[protein_name]]

    # split the dataframe: proteinLabel_df[[protein_name]] into fold_num equal-sized subsets
    protein_dataNum <- nrow(df) # get the number of rows in the dataframe
    
    cuts <- cut(seq(1, protein_dataNum), breaks = fold_num, labels = FALSE)
    subsets <- split(df, cuts)

    for (fold_counter in 1:fold_num) {
        str <- paste0("fold", fold_counter)
      
        if (is.null(fold_lists_counter)) {
            fold_lists[[str]] <- subsets[[fold_counter]]
            fold_lists_counter <- 1
        } else {
            fold_lists[[str]] <- rbind(fold_lists[[str]], subsets[[fold_counter]])
        }
    }
}

rm(data)
rm(proteinLabel_df)


### 開始計算 accuracy
output_df <- NULL
column_length <- length(fold_lists[["fold1"]][1, ])

formula <- "V2 ~ V3"
for (formula_counter in 4:column_length) {
    str <- paste0("+ V", formula_counter)
    formula <- paste(formula, str)
}

calc_accuracy <- function(model, pred_fold) {
    # make confusion matrix tabel
    confusion_matrix <- table(
        truth = pred_fold$V2,
        pred = predict(model, pred_fold, type = "class")
    )
    # print(confusion_matrix)
    return(sum(diag(confusion_matrix)) / sum(confusion_matrix)) # 對角線的數量/總數量
}

for (round_counter in 1:fold_num) {
    round_str <- paste0("fold", round_counter)

    fold_q <- c(seq(1:fold_num))
    test_pointer <- round_counter
    validation_pointer <- round_counter + 1
    if (validation_pointer > fold_num) {
        validation_pointer <- 1
    }

    # 不是 test 或 validation 就都標籤為 Train, 用以下語法篩
    fold_q <- fold_q[!fold_q %in% c(test_pointer, validation_pointer)]

    fold_str <- paste0("fold", test_pointer)
    test_fold <- fold_lists[[fold_str]]

    fold_str <- paste0("fold", validation_pointer)
    validation_fold <- fold_lists[[fold_str]]

    train_fold <- NULL
    for (train_counter in fold_q) {
        fold_str <- paste0("fold", train_counter)
        if (is.null(train_fold)) {
            train_fold <- fold_lists[[fold_str]]
        } else {
            train_fold <- rbind(train_fold, fold_lists[[fold_str]])
        }
    }
    # model using decision tree
    model <- rpart(
        eval(parse(text = formula)),
        data = train_fold, control = rpart.control(maxdepth = 4),
        method = "class"
    )

    train_accuracy <- calc_accuracy(model, train_fold)
    validation_accuracy <- calc_accuracy(model, validation_fold)
    test_accuracy <- calc_accuracy(model, test_fold)

    if (is.null(output_df)) {
        output_df <- data.frame(
            set = round_str,
            training = round(train_accuracy, 2),
            validation = round(validation_accuracy, 2),
            test = round(test_accuracy, 2)
        )
    } else {
        tmp_df <- data.frame(
            set = round_str,
            training = round(train_accuracy, 2),
            validation = round(validation_accuracy, 2),
            test = round(test_accuracy, 2)
        )
        output_df <- rbind(output_df, tmp_df)
    }
}

avg_df <- data.frame(
    set = "ave.",
    training = round(mean(output_df$training), 2),
    validation = round(mean(output_df$validation), 2),
    test = round(mean(output_df$test), 2)
)

output_df <- rbind(output_df, avg_df)

### create folders
folders <- unlist(strsplit(output_file, "[/]"))
base_path <- folders[1]

if (length(folders) > 1) {
    for (i in 2:length(folders)) { 
        if (!file.exists(base_path)) {
            dir.create(base_path)
        }
        assign("base_path", paste0(base_path, "/", folders[i]))
    }
}

write.csv(
    output_df,
    file = output_file,
    quote = FALSE,
    row.names = FALSE
)

end_time <- Sys.time()
print(end_time - start_time)

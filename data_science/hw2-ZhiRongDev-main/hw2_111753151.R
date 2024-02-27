args <- commandArgs(trailingOnly = TRUE)
target <- NA
badthre <- NA
input_files <- NA
output_file <- NA

if (length(args) < 8) {
    stop("Missing argument, check your command format", call. = FALSE)
} else {
    for (i in seq_along(args)) {
        if (args[i] == "--target") {
            target <- args[i + 1]
        } else if (args[i] == "--badthre") {
            badthre <- args[i + 1]
        } else if (args[i] == "--input") {
            # add "-" in the final of c() to avoid "--input" cannot find the next "--xxx" 
            # First build an array contains [c(args[(i + 1):length(args)], "-"],
            # Second use grep() to find the "Index" of element which contains "-", that means "--xxx" and the last "-"
            # Third return the First element of grep() array
            j <- grep("-", c(args[(i + 1):length(args)], "-"))[1]
            input_files <- args[(i + 1):(i + j - 1)]
        } else if (args[i] == "--output") {
            output_file <- args[i + 1]
        }
    }
}

if (is.na(target)) {
    stop("Missing --target argument", call. = FALSE)
} else if (is.na(badthre)) {
    stop("Missing --badthre argument", call. = FALSE)
} else if (is.na(input_files[1])) {
    stop("Missing --input_files argument", call. = FALSE)
} else if (is.na(output_file)) {
    stop("Missing --output_file argument", call. = FALSE)
}

output_df <- NA

for (i in seq_along(input_files)) {
    if (!file_test("-f", input_files[i])) {
        print(input_files[i])
        stop("--input not found")
    }

    data <- read.csv(input_files[i])
    
    # gsub replace ".csv" to ""
    method_name <- gsub(".csv", "", basename(input_files[i]))
     
    # Truth = data$reference will create an array, eg: Truth == ["bad", "bad", "good"]
    # pred = data$pred.score >= as.numeric(badthre) will create an array only contains TRUE or FALSE, depend on pred.score.
    # For example, if badthre == 0.5 and pred.score == [0.8, 0.3, 0.2], then pred == [TRUE, FALSE, FALSE]
    
    # Next, table() will count the frequency of the element "Match" in Truth & pred
    # For example, In this case "bad" match 1 TRUE, 1 FALSE;  "good" match 1 FALSE
    # Hence we could calcualte the TP, FP, TN, FN, depends on the --badthre
    if (target == "bad") {
        confusion_matrix <- table(
            Truth = data$reference,
            pred = data$pred.score >= as.numeric(badthre)
        )
    } else if (target == "good") {
        confusion_matrix <- table(
            Truth = data$reference,
            pred = data$pred.score < as.numeric(badthre)
        )
    } else {
        stop("Error in --target", call. = FALSE)
    }

    if (target == "bad") {
        tp <- confusion_matrix[1, 2]
        fp <- confusion_matrix[2, 2]
        tn <- confusion_matrix[2, 1]
        fn <- confusion_matrix[1, 1]
    } else if (target == "good") {
        tp <- confusion_matrix[2, 2]
        fp <- confusion_matrix[1, 2]
        tn <- confusion_matrix[1, 1]
        fn <- confusion_matrix[2, 1]
    } else {
        stop("invalid argument of --target", call. = FALSE)
    }
    sensitivity <- round(tp / (tp + fn), 2)
    specificity <- round(tn / (tn + fp), 2)
    f1 <- round((2 * tp) / (2 * tp + fp + fn), 2)

    # LOG LIKELIHOOD
    likeli_model <- sum(ifelse(data$reference == "bad", log(data$pred.score), log(1 - data$pred.score)))

    # Computing the null model’s log likelihood
    # Check P194 in the textbook
    # The best observable single estimate of the probability of being spam is the observed rate of spam on the training set
    # Hence pNull is Just the probability of being spam in dataset
    # dim(data)[[1]] == 'How many datas are there in the dataset'

    pNull <- sum(ifelse(data$reference == "bad", 1, 0)) / dim(data)[[1]]
    likeli_nullModel <- sum(ifelse(data$reference == "bad", 1, 0)) * log(pNull) + sum(ifelse(data$reference == "bad", 0, 1)) * log(1 - pNull)

    # calcualte pseudo R-squared
    #  In most cases, the saturated model is a perfect model that returns probability 1 for items in the class and probability 0 for items not in the class (so S=0)
    S <- 0
    pseudoR2 <- round(1 - (-2 * (likeli_model - S)) / (-2 * (likeli_nullModel - S)), 2)

    likeli_model <- round(likeli_model, 2)

    if (i == 1) {
        output_df <- data.frame(
            method = method_name,
            sensitivity = sensitivity,
            specificity = specificity,
            F1 = f1,
            logLikelihood = likeli_model,
            pseudoR2 = pseudoR2
        )
    } else {
        df2 <- data.frame(
            method = method_name,
            sensitivity = sensitivity,
            specificity = specificity,
            F1 = f1,
            logLikelihood = likeli_model,
            pseudoR2 = pseudoR2
        )
        output_df <- rbind(output_df, df2)
    }
}

bestMethod_df <- data.frame(
    method = "best",
    sensitivity = output_df$method[[which.max(output_df$sensitivity)]],
    specificity = output_df$method[[which.max(output_df$specificity)]],
    F1 = output_df$method[[which.max(output_df$F1)]],
    logLikelihood = output_df$method[[which.max(output_df$logLikelihood)]],
    pseudoR2 = output_df$method[[which.max(output_df$pseudoR2)]]
)

output_df <- rbind(output_df, bestMethod_df)

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

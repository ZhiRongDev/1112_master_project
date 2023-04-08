args <- commandArgs(trailingOnly = TRUE)
input_path <- NA
output_path <- NA
input_name <- NA

if (length(args) < 4) {
  stop("Missing argument, check --input and --output", call. = FALSE) # nolint
} else {
    for (i in seq_along(args)) {
        if (args[i] == "--input") {
            if (!file_test("-f", args[i + 1])) {
                print(args[i + 1])
                stop("inputFile not defined, or not correctly named.")
            } else {
                assign("input_path", args[i + 1])
            }
        } else if (args[i] == "--output") {
            assign("output_path", args[i + 1])
        }
    }
}

if (is.na(input_path)) {
  stop("Missing --input argument", call. = FALSE)
} else if (is.na(output_path)) {
  stop("Missing --output argument", call. = FALSE)
}

### remove .csv
input_name <- unlist(strsplit(input_path, "[/]"))
input_name <- tail(input_name, n = 1)
input_name <- unlist(strsplit(input_name, "[.]"))
input_name <- input_name[1]

df <- read.csv(file = input_path, header = TRUE, sep = ",")

max_weight <- max(df[["weight"]])
max_height <- max(df[["height"]])

max_weight <- round(max_weight, 2)
max_height <- round(max_height, 2)

output_df <- data.frame(
    "set" = input_name,
    "weight" = max_weight,
    "height" = max_height
)

### create folders
folders <- unlist(strsplit(output_path, "[/]"))
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
    file = output_path,
    quote = FALSE,
    row.names = FALSE
)
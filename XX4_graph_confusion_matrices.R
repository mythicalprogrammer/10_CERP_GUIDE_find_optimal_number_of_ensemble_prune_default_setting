get_accuracy <- function(text) {
  accuracy_index <- grep("Accuracy : ", text)
  tmp_str <- str_trim(text[accuracy_index[1]])
  cur_accuracy <- str_sub(tmp_str, 12)
  return(cur_accuracy)
}
get_sensitivity <- function(text) {
  accuracy_index <- grep("Sensitivity :", text)
  tmp_str <- str_trim(text[accuracy_index[1]])
  cur_accuracy <- str_sub(tmp_str, 15)
  return(cur_accuracy)
}
get_specificity <- function(text) {
  accuracy_index <- grep("Specificity :", text)
  tmp_str <- str_trim(text[accuracy_index[1]])
  cur_accuracy <- str_sub(tmp_str, 15)
  return(cur_accuracy)
}
get_ppv <- function(text) {
  accuracy_index <- grep("Pos Pred Value :", text)
  tmp_str <- str_trim(text[accuracy_index[1]])
  cur_accuracy <- str_sub(tmp_str, 18)
  return(cur_accuracy)
}
get_npv <- function(text) {
  accuracy_index <- grep("Neg Pred Value :", text)
  tmp_str <- str_trim(text[accuracy_index[1]])
  cur_accuracy <- str_sub(tmp_str, 18)
  return(cur_accuracy)
}



raw_dir_path <- "./confusion_matrices"
rand_seeds_paths <-
  list.files(path = raw_dir_path, full.names = TRUE)
for (cur_rand_seed_dir in rand_seeds_paths) {
  cur_rand_seed <- str_sub(cur_rand_seed_dir, 39)
  cur_rand_seed_confusion_matrices <-
    list.files(path = cur_rand_seed_dir, full.names = TRUE)

  partition_num <- c()
  accuracy <- c()
  sensitivity <- c()
  specificity <- c()
  ppv <- c()
  npv <- c()
  j <- 1
  for (cur_confusion_matrix in cur_rand_seed_confusion_matrices) {
    tmp_str <- str_sub(cur_confusion_matrix, 81)
    cur_max_tree <- substr(tmp_str, 1, nchar(tmp_str) - 4)
    text <- readLines(cur_confusion_matrix, encoding = "UTF-8")
    accuracy[j] <- get_accuracy(text)
    sensitivity[j] <- get_sensitivity(text)
    specificity[j] <- get_specificity(text)
    ppv[j] <- get_ppv(text)
    npv[j] <- get_npv(text)
    partition_num[j] <- cur_max_tree
    j <- j + 1
  }
  results_dataframe <-
    data.frame("partition_number" = as.numeric(partition_num),
               "accuracy" = as.numeric(accuracy),
               "sensitivity" = as.numeric(sensitivity),
               "specificity" = as.numeric(specificity),
               "ppv" = as.numeric(ppv),
               "npv" = as.numeric(npv)
               )
  cleaned_data_name <-
    str_c("./results/aggregated_cerp_guide_confusion_matrices_rand_seed_",
          cur_rand_seed,".csv")
  write.csv(results_dataframe,
            file = cleaned_data_name,
            row.names = FALSE)
}


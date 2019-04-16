"DOES NOT WORK! top 88 important features is smaller than optimal
number of partition of 153!
"
myeloma_data <- read.table("start_data/GDS531_after_anova.csv",
                           sep = ",",
                           header = TRUE)
feature_imp_rank <- read.table(
  "./results/feature_importance_tree_num_198.csv",
  sep = ",",
  stringsAsFactors = FALSE,
  header = TRUE
)
num_top_features <- 1000
myeloma_data <-
  myeloma_data[,c("state", feature_imp_rank$X[1:num_top_features])]
#36
minority_nrow <- nrow(myeloma_data[myeloma_data$state == "WO",])
minority_train_data <- myeloma_data[1:20,]
minority_test_data <- myeloma_data[21:36,]
#137
majority_nrow <- nrow(myeloma_data[myeloma_data$state == "W",])
majority_train_data <- myeloma_data[37:136,]
majority_test_data <- myeloma_data[137:nrow(myeloma_data),]

test_data <- rbind(minority_test_data, majority_test_data)
train_data <- rbind(minority_train_data, majority_train_data)

minority_nrow_train <- nrow(minority_train_data)

rand_seed <- 1030

set.seed(rand_seed)
guide_cerp_predictions <- list()

best_number_of_partitions <- 153
set.seed(rand_seed)


    ####
    # BUILD MODEL here ##
    ####
    partitions <- create_CERP_partitions(
      num_partition = best_number_of_partitions,
      dataset = train_data,
      response = "state",
      rand_seed = rand_seed
    )
    generate_GUIDE_files(
      dataset = train_data,
      cerp_partitions = partitions,
      part_prefix_name = str_c('rand_seed_', rand_seed, '_part'),
      response = "state",
      rand_seed = rand_seed
    )
    create_CERP_GUIDE_forest(
      guide_dir = "./guide_data/",
      number_of_partitions = best_number_of_partitions,
      prune = TRUE,
      rand_seed = rand_seed
    )




for (i in  1:nrow(test_data)) {
  # # predict here
  guide_cerp_predictions[[i]] <- predict_CERP_GUIDE_forest(
    test_data[i, ],
    forest_dir = "./guide_output/forests/",
    number_of_partitions = best_number_of_partitions,
    rand_seed = rand_seed
  )
}

pred_df <- data.frame(unlist(guide_cerp_predictions))
names(pred_df) <- "predictions"
pred_df$predictions <- as.factor(pred_df$predictions)
actual_df <- as.data.frame(test_data$state)
names(actual_df) <- "predictions"
file_path  <-
  str_c('./results/cerp_guide_confusion_matrix_test_data_tree_num_',
        best_number_of_partitions,
        '.txt')
sink(file_path)
print(confusionMatrix(pred_df$predictions, actual_df$predictions))
sinkall()

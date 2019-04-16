myeloma_data <- read.table("start_data/GDS531_after_anova.csv",
                           sep = ",",
                           header = TRUE)
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
best_num_partitions <- 153


    ####
    # BUILD MODEL here ##
    ####
    partitions <- create_CERP_partitions(
      num_partition = best_num_partitions,
      dataset = train_data ,
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
      number_of_partitions = best_num_partitions,
      prune = TRUE,
      rand_seed = rand_seed
    )


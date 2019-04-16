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

rand_seed <- 1030

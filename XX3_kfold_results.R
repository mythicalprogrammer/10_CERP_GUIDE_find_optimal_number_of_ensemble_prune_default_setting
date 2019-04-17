dir_path <- "./intermediate_data/pred"
results_path <- list.files(path = dir_path, full.names = TRUE)

for (i in results_path) {
  pred_df <- read.csv(file = i,
                      header = TRUE,
                      sep = ",")
  start_pos_cur_max_tree <- regexpr("_num_tree_",i)
  end_pos_cur_max_tree <- regexpr(".csv",i)
  cur_max_tree <-
    substr(i,
           start_pos_cur_max_tree + attr(start_pos_cur_max_tree, "match.length"),
           end_pos_cur_max_tree - 1)

  start_pos_cur_rand_seed <- regexpr("_ran_seed_",i)
  end_pos_cur_rand_seed <- regexpr("_num_tree_",i)
  cur_rand_seed <-
    substr(i,
           start_pos_cur_rand_seed + attr(start_pos_cur_rand_seed, "match.length"),
           end_pos_cur_rand_seed - 1)


  actual_path <- str_c(
    "./intermediate_data/actual/",
    "LOOCV_CERP_GUIDE_forest_actual_ran_seed_",
    cur_rand_seed,
    "_num_tree_",
    cur_max_tree,
    ".csv"
  )
  actual_df <- read.csv(file = actual_path,
                        header = TRUE,
                        sep = ",")
  create_confusion_matrix(
                          pred = pred_df$predictions,
                          actual = actual_df$predictions,
                          num_tree = cur_max_tree,
                          rand_seed = cur_rand_seed)
}

create_confusion_matrix <-
  function(pred,
           actual,
           num_tree,
           rand_seed) {

    dir <- str_c("confusion_matrices/forest_rand_seed_", rand_seed)
    if (!dir.exists(dir)) {
      dir.create(dir)
    }
    file_path  <-
      str_c(dir,'/cerp_guide_confusion_matrix_num_tree_',
            num_tree,
            '.txt')
    sink(file_path)
    print(confusionMatrix(pred, actual))
    sinkall()
  }

predict_CERP_GUIDE_forest <-
  function(predict_value,
           forest_dir = "./guide_output/forests/",
           number_of_partitions,
           rand_seed = 1030) {
    forest_dir <-
      str_c(forest_dir,
            "rand_seed_" ,
            rand_seed,
            '/part_',
            number_of_partitions)
    tree_paths <-
      list.files(path = forest_dir,
                 full.names = TRUE,
                 pattern = "\\.R$")

    trees_votes <- mclapply(1:length(tree_paths), function(i) {
      predict_CERP_GUIDE_tree(predict_value, tree_paths[i])
    }, mc.silent = TRUE)

    trees_votes <- table(unlist(trees_votes))
    forest_prediction <- names(which.max(trees_votes))
    return(forest_prediction)
  }

predict_CERP_GUIDE_tree <- function(predict_value, tree_path) {
  text <- readLines(tree_path, encoding = "UTF-8")
  to_be_remove <- grep("^newdata <-*", text)

  # the guide generated r file reads training data
  # so we need to remove this
  text[to_be_remove] <- " "
  # newdata in the guide r file is the predict var
  newdata <- predict_value # df one row of features values
  # run the modified GUIDE auto generate R code
  eval(parse(text = text))
  return(pred)
}

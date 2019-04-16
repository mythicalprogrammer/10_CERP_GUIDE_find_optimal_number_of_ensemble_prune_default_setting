create_CERP_partitions <-
  function(
    num_partition,
    dataset,
    # this have to be a string
    response,
    rand_seed = 1030) {

    set.seed(rand_seed)

    # split data into two: features data and response data
    train_df <- dataset[,!names(dataset) %in% c(response)]
    response_df <- dataset[response]

    # Shuffle the columns / Shuffle the features
    shuffled_data <- train_df[, sample(ncol(train_df))]
    shuf_preds <- names(shuffled_data)

    # Partition feature dataset
    # DO NOT PARALLELIZE THIS it is iterative algorithm
    num_pred <- ncol(train_df)
    pred_to_sample <- shuf_preds
    partitions <- list()
    num_pred_per_partition <- floor(num_pred / num_partition)
    remainders <-
      num_pred - num_pred_per_partition * num_partition
    for (j in 1:num_partition) {
      if (remainders > 0) {
        part_size <- num_pred_per_partition + 1
        remainders <- remainders - 1
      } else {
        part_size <- num_pred_per_partition
      }
      partitions[[j]] <-  c(response, pred_to_sample[1:part_size])
      pred_to_sample <-
        setdiff(pred_to_sample, pred_to_sample[1:part_size])
    }
    return(partitions)
  }



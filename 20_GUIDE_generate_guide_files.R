generate_GUIDE_files <- function(dataset,
                                 cerp_partitions,
                                 dir_path = './guide_data',
                                 part_prefix_name = 'part',
                                 response,
                                 rand_seed = 1030) {
  number_of_partitions <- length(cerp_partitions)
  create_GUIDE_dirs(
    dir_path = dir_path,
    number_of_partitions = number_of_partitions,
    rand_seed = rand_seed
  )
  mclapply(1:number_of_partitions, function(i) {
    part_cols <- cerp_partitions[[i]]
    part <- dataset[, part_cols]
    generate_GUIDE_data_file(
      part,
      i,
      dir_path,
      part_prefix_name,
      number_of_partitions = number_of_partitions,
      rand_seed = rand_seed
    )
    generate_guide_description_file(
      part,
      i,
      dir_path,
      part_prefix_name,
      response,
      number_of_partitions = number_of_partitions,
      rand_seed = rand_seed
    )
  }, mc.silent = TRUE)
}

## Generate GUIDE directories
create_GUIDE_dirs <- function(dir_path,
                              number_of_partitions,
                              rand_seed) {
  rand_seed_path <- str_c(dir_path, '/rand_seed_', rand_seed)
  if (!dir.exists(rand_seed_path)) {
    dir.create(rand_seed_path)
  }

  part_path <-
    str_c(rand_seed_path, '/part_', number_of_partitions)
  if (!dir.exists(part_path)) {
    dir.create(part_path)
  }
}

## Generate GUIDE data file extension .txt
generate_GUIDE_data_file <-
  function(partition,
           partition_number,
           dir_path,
           part_prefix_name,
           number_of_partitions = number_of_partitions,
           rand_seed = rand_seed) {
    # create the path and write out to txt
    #TODO need to create folder rand_seed_#/part_#
    data_file_path <-
      str_c(
        dir_path,
        '/rand_seed_',
        rand_seed,
        '/part_',
        number_of_partitions,
        '/',
        part_prefix_name,
        '_',
        partition_number,
        '.txt'
      )

    options(scipen = 100)

    write.table(
      partition,
      file = data_file_path,
      sep = " ",
      row.names = FALSE,
      quote = FALSE
    )
  }

## Generate GUIDE description file extension .dsc
generate_guide_description_file <-
  function(partition,
           partition_number,
           dir_path,
           part_prefix_name,
           response,
           number_of_partitions = number_of_partitions,
           rand_seed = rand_seed) {
    file_name <-
      str_c(
        dir_path,
        '/rand_seed_',
        rand_seed,
        '/part_',
        number_of_partitions,
        '/',
        part_prefix_name,
        '_',
        partition_number
      )

    desc_file_name <- str_c(file_name, '.dsc')
    data_file_name <- str_c('"', file_name, '.txt"')
    str_to_write <- vapply(1:length(names(partition)),
                           function(k) {
                             preds_and_feature <- names(partition)
                             if (preds_and_feature[[k]] == response) {
                               str_c(k, " ", preds_and_feature[[k]], " ", "d")
                             } else {
                               str_c(k, " ", preds_and_feature[[k]], " ", "n")
                             }
                           }, "")
    str_to_write <- c(c(data_file_name, "NA", 2), str_to_write)
    write.table(
      str_to_write,
      file = desc_file_name,
      row.names = FALSE,
      col.names = FALSE,
      quote = FALSE
    )
  }

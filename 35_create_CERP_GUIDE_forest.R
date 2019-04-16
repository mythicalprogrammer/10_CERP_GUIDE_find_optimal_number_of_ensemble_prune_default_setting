create_CERP_GUIDE_forest <-
  function(guide_dir = "./guide_data",
           number_of_partitions,
           prune = FALSE,
           rand_seed = 1030) {
    create_CERP_GUIDE_forest_output_dir(rand_seed, number_of_partitions)

    # get list of files in guide_data dir
    guide_data_path <- str_c(guide_dir,
                             '/rand_seed_',
                             rand_seed,
                             '/part_',
                             number_of_partitions)
    list_dsc <-
      list.files(path = guide_data_path,
                 full.names = TRUE,
                 pattern = "\\.dsc$")

    if (length(list_dsc) > 0) {
      mclapply(1:length(list_dsc), function(i) {
        create_CERP_GUIDE_tree(
          guide_description_path = list_dsc[i],
          tree_name = i,
          number_of_partitions = number_of_partitions,
          prune = prune,
          rand_seed = rand_seed
        )
      }, mc.silent = TRUE)
    } else {
      print("ERROR: No GUIDE files, data & description, was generated. Cannot build GUIDE trees.")
    }
  }

create_CERP_GUIDE_tree <-
  function(guide_description_path,
           tree_name = NULL,
           number_of_partitions,
           prune,
           rand_seed) {
    if (prune) {
      text <- readLines("guide_prune.input", encoding = "UTF-8")
    } else {
      text <- readLines("guide_no_prune.input", encoding = "UTF-8")
    }
    text[4]  <-
      str_c(
        '"guide_output/out_files/rand_seed_',
        rand_seed,
        '/part_',
        number_of_partitions,
        '/tree_',
        tree_name,
        '.out"'
      )
    text[10] <- str_c('"', guide_description_path, '"')

    if (prune) {
      text[23] <-
        str_c(
          '"guide_output/forests/rand_seed_',
          rand_seed,
          '/part_',
          number_of_partitions,
          '/tree_',
          tree_name,
          '.R"'
        )
    } else {
      text[20] <-
        str_c(
          '"guide_output/forests/rand_seed_',
          rand_seed,
          '/part_',
          number_of_partitions,
          '/tree_',
          tree_name,
          '.R"'
        )
    }
    tmp_input_file <-
      str_c(
        "tmp_input/guide.tmp_input_rand_seed_",
        rand_seed,
        "_part_",
        number_of_partitions,
        "_tree_",
        tree_name
      )
    write(text, file = tmp_input_file)
    sys_command <- str_c("./guide < ", tmp_input_file)
    system(sys_command)
  }

create_CERP_GUIDE_forest_output_dir <-
  function(rand_seed, number_of_partitions) {
    result_dir <- str_c('guide_output/forests')
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
    result_dir <- str_c('guide_output/out_files')
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
    result_dir <-
      str_c('guide_output/forests/rand_seed_', rand_seed)
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
    result_dir <-
      str_c('guide_output/forests/rand_seed_',
            rand_seed,
            '/part_',
            number_of_partitions)
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
    result_dir <-
      str_c('guide_output/out_files/rand_seed_', rand_seed)
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
    result_dir <-
      str_c('guide_output/out_files/rand_seed_',
            rand_seed,
            '/part_',
            number_of_partitions)
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
  }


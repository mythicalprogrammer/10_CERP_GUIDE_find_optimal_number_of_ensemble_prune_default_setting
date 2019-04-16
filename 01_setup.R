# Mostly directories setup

check_dirs <- c(
  "./start_data",
  "./guide_data",
  "./guide_output",
  "./results",
  "./intermediate_data",
  "./intermediate_data/actual",
  "./intermediate_data/pred",
  "./tmp_input",
  "./confusion_matrices"
)

for (dir in check_dirs) {
  if (!dir.exists(dir)) {
    dir.create(dir)
  }
}

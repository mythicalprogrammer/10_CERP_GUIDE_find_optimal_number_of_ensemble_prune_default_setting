sinkall <- function() {
  i <- sink.number()
  if (i > 0) {
    for (i in 1:i) {
      sink()
    }
  }
}

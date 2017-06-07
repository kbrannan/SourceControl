wrapper.quick.get.parallel <- function(chr.prefix, chr.pls.names, lst.output,
                                       chr.dir.source.control.scripts) {
  library(data.table)
  library(parallel)
  source(paste0(chr.dir.source.control.scripts, "/",
                "quick-get-parallel.R"))
  

  try(stopCluster(c1), silent = TRUE)
  ## create cluster
  no_cores <- detectCores() - 1
  if(no_cores < 1) no_cores <- 1
  c1 <- makeCluster(no_cores)
  ## export functions to cluster
  clusterExport(c1, lsf.str())

  ## run quick.get.parallel and return a data frame of loads  
  df.loads <- rbindlist(parLapply(c1, lst.output$sub.wtsd.names, quick.get.parallel,
                                              chr.prefix, chr.pls.names, lst.output,
                                              chr.dir.source.control.scripts))
  
  return(df.loads)
}
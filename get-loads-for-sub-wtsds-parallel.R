get.loads.for.sub.wtsd.parallel <- function(chr.sub.wtsd.names, lst.loads) {
  ## function contructs data form in long format for loads from all sources
  ## to each pls in a sub watershed for accum, lim and stream loads
  ##
  ## chr.sub.wtsd.names - character for sub-watershed names in the loads list
  ## lst.loads - list that contains names of the sources, names of 
  ##             sub-watersheds all the data.frame outputs from source models.
  ##             The list is output from run.sub.models.for.sources.parallel
  
  ## doesn't work yet! Error with using get.pls.names function. Not able
  ## to call within get.loads.for.sub.wtsd
  
  ## load packages
  library(parallel)
  
  ## create cluster
  no_cores <- detectCores() - 1
  if(no_cores < 1) no_cores <- 1
  c1 <- makeCluster(no_cores)

  ## run get.loads.for.sub.wtsd for all of the sub-watersheds in 
  ## chr.sub.wtsd.names
  lst.loads.sub.wtsds <- parLapply(c1, chr.sub.wtsd.names, 
                         get.loads.for.sub.wtsd, lst.loads)
  
  ## set names for the loads data frames to sub-watershed names
  names(lst.loads.sub.wtsds) <- chr.sub.wtsd.names

  ## done
  return(lst.loads.sub.wtsds)
}

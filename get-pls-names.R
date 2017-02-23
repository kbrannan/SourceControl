get.pls.names <- function(lst.loads) {
  ## function gets pls names from the list of load data.frames
  ##
  ## lst.loads - list that contains names of the sources, names of 
  ##             sub-watersheds all the data.frame outputs from source models.
  ##             The list is output from run.sub.models.for.sources.parallel
  
  ## get the names of the sources in the list
  chr.src <- lst.loads$source.names
  
  ## get all of the pls names in all of the load data.frames that are in the 
  ## accum columns. This will give all of the names of pls in the watershed
  x <- do.call(c,sapply(chr.src, 
                        function(x, lst.x) gsub("accum\\.","",
                                                grep("accum", names(lst.x[x][[1]][[1]]), 
                                                     ignore.case = TRUE, value = TRUE), 
                                                ignore.case = TRUE), 
                        lst.loads))
  ## remove column names to clean up vector of pls names
  names(x) <- NULL
  
  ## done
  return(x)
}
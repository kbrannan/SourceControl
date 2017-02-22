get.load.to.stream <- function(chr.sub.wtsd, lst.loads) {
  ## function sums loads to stream from all sources a sub watersheds
  ##
  ## chr.sub.wtsd - character for sub-watershed in the loads list
  ## lst.loads - list that contains names of the sources, names of 
  ##             sub-watersheds all the data.frame outputs from source models.
  ##             The list is output from run.sub.models.for.sources.parallel
  
  ## prefix used to search source data.frames for accum loads
  chr.prefix <- "Bacteria.direct.to.stream"
  
  ## the number od sources in the loads list
  n.src <- length(lst.loads$source.names)
  
  ## create character vector of the names of months for use in load data.frame
  pct.mons <- as.POSIXlt(paste0("1999-",1:12,"-01"))
  
  ## create empty data.frame for the loads to the stream from all the sources
  df.dest <- as.data.frame(
    setNames(replicate(13,character(0)),
             c("source", strftime(as.POSIXlt(paste0("1999-",1:12,"-01")), 
                                  format = "%b"))),
    stringsAsFactors = FALSE)
  
  ## loop through all the sources and populate the data.frame for the stream
  for(ii.src in 1:n.src) {
    df.cur <- lst.loads[[lst.loads$source.names[ii.src]]][chr.sub.wtsd][[1]]
    col.cur <- grep(paste0(chr.prefix),names(df.cur), ignore.case = TRUE)
    if(length(col.cur) != 0) {
  ## if the source has load to stream extract from data.frame
      chr.ld <- as.character(df.cur[,col.cur])
    } else {
  ## if the source does not have load to stream set to 0
      chr.ld <- rep("0", 12)
    }
  ## add current source loads to stream to the data.frame for the loads
    df.dest <- 
      rbind(df.dest,
            eval(
              parse(
                text = paste0("data.frame(",
                              paste0(names(df.dest), " = '", 
                                     c(lst.loads$source.names[ii.src],
                                       chr.ld),"'",
                                     collapse = " ,"), 
                              ", stringsAsFactors = FALSE)")))
      )
  ## clean up
    rm(df.cur, col.cur)
  }
  ## sum across sources by month to get monthly load to stream
  vec.loads <- colSums(sapply(df.dest[, 2:13], as.numeric))
  df.loads <- data.frame(month = names(vec.loads),
                          accum.load = vec.loads[],
                          stringsAsFactors = FALSE,
                         row.names = NULL)
  
  names(df.loads) <- c("month", gsub("\\.\\*", "", chr.prefix))
  
  ##  return monthly loads data.frame as function output
  return(df.loads)
}
get.lim.load.to.pls <- function(chr.sub.wtsd, chr.pls, lst.output) {
  ## function sums lim loads from all sources to a pls in a sub watersheds
  ##
  ## chr.sub.wtsd - character for sub-watershed in the loads list
  ## chr.pls - character for the pls in the loads list for chr.sub.wtsd
  ## lst.output - list that contains names of the sources, names of 
  ##             sub-watersheds all the data.frame outputs from source models.
  ##             The list is output from run.sub.models.for.sources.parallel
  
  ## prefix used to search source data.frames for accum loads
  chr.prefix <- "lim.*"
  
  ## the number od sources in the loads list
  n.src <- length(lst.output$source.names)
  
  ## create character vector of the names of months for use in load data.frame
  pct.mons <- as.POSIXlt(paste0("1999-",1:12,"-01"))
  
  ## create empty data.frame for the loads to the pls from all the sources
  df.dest <- as.data.frame(
    setNames(replicate(13,character(0)),
             c("source", strftime(as.POSIXlt(paste0("1999-",1:12,"-01")), 
                                  format = "%b"))),
    stringsAsFactors = FALSE)
  
  ## loop through all the sources and populate the data.frame for the pls
  for(ii.src in 1:n.src) {
    df.cur <- lst.output[[lst.output$source.names[ii.src]]][chr.sub.wtsd][[1]]
    col.cur <- grep(paste0(chr.prefix,chr.pls),names(df.cur), ignore.case = TRUE)
    if(length(col.cur) != 0) {
  ## if the source has accum for pls extract from load data.frame
      chr.ld <- as.character(df.cur[,col.cur])
    } else {
  ## if the source does not have accum for pls set to 0
      chr.ld <- rep("0", 12)
    }
  ## add current source loads to pls to the data.frame for the loads
    df.dest <- 
      rbind(df.dest,
            eval(
              parse(
                text = paste0("data.frame(",
                              paste0(names(df.dest), " = '", 
                                     c(lst.output$source.names[ii.src],
                                       chr.ld),"'",
                                     collapse = " ,"), 
                              ", stringsAsFactors = FALSE)")))
      )
  ## clean up
    rm(df.cur, col.cur)
  }
  ## sum across sources by month to get monthly load to pls
  vec.loads <- colSums(sapply(df.dest[, 2:13], as.numeric))
  df.loads <- data.frame(month = names(vec.loads),
                          accum.load = vec.loads[],
                          stringsAsFactors = FALSE,
                         row.names = NULL)
  
  names(df.loads) <- c("month", paste0(gsub("\\.\\*", "", chr.prefix), ".to.",chr.pls))
  
  ##  return monthly loads data.frame as function output
  return(df.loads)
}
get.loads.parallel <- function(chr.sub.wtsd, chr.prefix, chr.pls.names, 
                               lst.output, chr.dir.source.control.scripts) {
  library(data.table)
  library(parallel)
  source(paste0(chr.dir.source.control.scripts, "/",
                "get-loads-for-sub-wtsd.R"))

  
  ## check if there are loads for the sub watershed, if not set all loads to 0 
  ## and return data frame
  if(length(
    lapply(
      lst.output[lst.output$source.names][[1]][chr.sub.wtsd][[1]], 
      is.null)) == 0) {
    df.sub.loads <- data.frame(sub.wtsd = chr.sub.wtsd,
                          source = "all",
                          load.to = "all",
                          months =strftime(as.POSIXct(paste0("1999-", 1:12, "-01")),
                                           format = "%b"),
                          monthly.loads = rep(0,12))
  } else {

    ## function to get the output of a single source for one sub watershed
    get.wtsd.output <- function(chr.source.name, chr.sub.wtsd, lst.output) {
      df.out <- data.frame(source = chr.source.name,
                           lst.output[chr.source.name][[1]][chr.sub.wtsd][[1]])
    }
    
    ## function that gets loads for a single soure in a sub watershed
    ## this function sets the basic form of the data frame of the loads
    get.pls.load <- function(chr.pls, chr.prefix, chr.sub.wtsd, df.source) {
      options(stringsAsFactors = FALSE)
      chr.months <- strftime(as.POSIXct(paste0("1999-", 1:12, "-01")),
                             format = "%b")
      chr.reg.exp <- paste0("^?.*\\b", chr.prefix,"\\b?.*\\b", chr.pls, "\\b.*$")
      lng.col <- grep(chr.reg.exp, tolower(names(df.source)))
      if(length(lng.col) > 0) {
        df.load <- data.frame(sub.wtsd = chr.sub.wtsd, 
                              source = df.source$source,
                              load.to = paste0(chr.prefix, ".", chr.pls),
                              month = chr.months,
                              monthly.loads = df.source[, lng.col])
      }
      else {
        df.load <- data.frame(sub.wtsd = chr.sub.wtsd,
                              source = df.source$source,
                              load.to = paste0(chr.prefix, ".", chr.pls),
                              months = chr.months,
                              monthly.loads = rep(0,12))
      }
      return(df.load)
    }
    
    ## wrapper function to apply "get.pls.load" for a source
    get.loads.source <- function(chr.source, chr.pls.names, chr.prefix, 
                                 chr.sub.wtsd, lst.wtsd) {
      library(data.table)
      lst.loads <- lapply(chr.pls.names, get.pls.load, chr.prefix, chr.sub.wtsd,
                          lst.wtsd[chr.source][[1]])
      df.source <- as.data.frame(rbindlist(lst.loads))
    }
    ## close cluster if exists
    try(stopCluster(c1), silent = TRUE)
    
    ## create cluster
    no_cores <- detectCores() - 1
    if(no_cores < 1) no_cores <- 1
    c1 <- makeCluster(no_cores)
    
    ## export functions to cluster
    clusterExport(c1, lsf.str())

    ## get the output of all sources in one sub watershed
    lst.cur.wtsd <- lapply(lst.output$source.names,
                           get.wtsd.output, chr.sub.wtsd,
                           lst.output)
    ## change the structure of list for use in later functions
    chr.cur.sources <- do.call(rbind,
                               parLapply(c1,1:length(lst.cur.wtsd), 
                                         function(x,lst.x) lst.x[x][[1]]$source,
                                         lst.cur.wtsd))[,1]
    
    ## get names of sources
    names(lst.cur.wtsd) <- chr.cur.sources
    
    ## get loads of all sources to all pls in a sub-watershed
    lst.sub.loads <- parLapply(c1,chr.cur.sources, get.loads.source,
                               chr.pls.names, chr.prefix, chr.sub.wtsd,
                               lst.cur.wtsd)
    df.sub.loads <- as.data.frame(rbindlist(lst.sub.loads))
    
    ## close cluster
    stopCluster(c1)
  }

  ## return load data.frame
  return(df.sub.loads)
}
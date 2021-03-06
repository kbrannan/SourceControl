get.loads.for.sub.wtsd <- function(chr.sub.wtsd.name, lst.output,
                                   chr.dir.source.control.scripts) {
  ## function contructs data frma in long format for loads from all sources
  ## to each pls in a sub watershed for accum, lim and stream loads
  ##
  ## chr.sub.wtsd - character for sub-watershed in the loads list
  ## lst.output - list that contains names of the sources, names of 
  ##             sub-watersheds all the data.frame outputs from source models.
  ##             The list is output from run.sub.models.for.sources.parallel
  ## chr.dir.source.control.scripts is Source control scripts folder

  options(stringsAsFactors = FALSE)
  ## load packages
  library(parallel)
  
  source(paste0(chr.dir.source.control.scripts, "/",
                "get-pls-names.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/",
                "get-accum-load-to-pls.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/",
                "get-lim-load-to-pls.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/",
                "get-load-to-stream.R"), local = TRUE)

  ## get vector for month names
  chr.months <- lst.output[lst.output[[1]][1]][[1]][[1]]$Month
  
  ## get the pls names
  chr.pls.names <- get.pls.names(lst.output)

  ## create cluster
  no_cores <- detectCores() - 1
  if(no_cores < 1) no_cores <- 1
  c2 <- makeCluster(no_cores)

  ## run get.loads.for.sub.wtsd for all of the sub-watersheds in 
  ## chr.sub.wtsd.names
  ## clusterExport(c2, lsf.str())
  
  ## get accum loads
  lst.accum <- parLapply(c2, chr.pls.names, get.accum.load.to.pls, 
                                   chr.sub.wtsd.name, lst.output)

  ## get accum loads
  # lst.accum <- lapply(chr.pls.names, get.accum.load.to.pls, chr.sub.wtsd.name, 
  #                     lst.output)
  names(lst.accum) <- paste0("accum.", chr.pls.names)
    
  ## get lim load
  # lst.lim <- lapply(chr.pls.names, get.lim.load.to.pls, chr.sub.wtsd.name, 
  #                   lst.output)
  lst.lim <- parLapply(c2, chr.pls.names, get.lim.load.to.pls, 
                         chr.sub.wtsd.name, lst.output)
  names(lst.lim) <- paste0("lim.", chr.pls.names)

  ## close cluster
  stopCluster(c2)

  ## get load to stream
  df.load.stream <- get.load.to.stream(chr.sub.wtsd.name, lst.output)
  
  ## function to extract the rows from accum or lim lists
  get.rows.lst <- function(chr.pls, lst.loads, chr.prefix) {
    df.out <- lst.loads[paste0(chr.prefix,chr.pls)][[1]][,2]
    return(df.out)
  }
  
  ## contruct long format data.frames from accum and lim lists along with stream
  ## data.frame
  ## accum
  df.cur.accum <- data.frame(chr.months, 
                             do.call(cbind,lapply(chr.pls.names, get.rows.lst, 
                                                  lst.accum, 
                                                  chr.prefix = "accum.")))
  names(df.cur.accum) <- c("month", paste0(chr.pls.names))
  df.cur.accum <- reshape2::melt(df.cur.accum, id.vars = c(1))
  names(df.cur.accum) <- c("month", "load.to", "load")
  df.cur.accum <- cbind(df.cur.accum[, "load.to"], 
                        hspf.input = "accum", 
                        df.cur.accum[, c("month", "load")])
  names(df.cur.accum) <- c("load.to", "hspf.input", "month", "load")
  ## lim
  df.cur.lim <- data.frame(chr.months, 
                           do.call(cbind,lapply(chr.pls.names, get.rows.lst, 
                                                lst.lim, 
                                                chr.prefix = "lim.")))
  names(df.cur.lim) <- c("month", paste0(chr.pls.names))
  df.cur.lim <- reshape2::melt(df.cur.lim, id.vars = c(1))
  names(df.cur.lim) <- c("month", "load.to", "load")
  df.cur.lim <- cbind(df.cur.lim[, "load.to"], 
                      hspf.input = "lim", 
                      df.cur.accum[, c("month", "load")])
  names(df.cur.lim) <- c("load.to", "hspf.input", "month", "load")
  ## stream
  df.cur.stream <- cbind(load.to = "stream", hspf.input = "MUTSIN", 
                         df.load.stream)
  names(df.cur.stream) <- c("load.to", "hspf.input", "month", "load")
  
  ## put together the data.frame for the su watershed laods and add field 
  ## for sub watershed name
  df.sub.wtsd.load <- rbind(df.cur.accum, df.cur.lim, df.cur.stream)
  df.sub.wtsd.load <- cbind(sub.wtsd = chr.sub.wtsd.name, df.sub.wtsd.load)
  
  ## make all catagorical varbles character, not factor
  df.sub.wtsd.load <- data.frame(
    lapply(df.sub.wtsd.load[, 1:4], as.character),
    df.sub.wtsd.load$load, stringsAsFactors = FALSE)
  ## set the names for the data.frame
  names(df.sub.wtsd.load) <- c("sub.wtsd", "load.to", "hspf.input", "month", "load")
  ## done
  return(df.sub.wtsd.load)
}

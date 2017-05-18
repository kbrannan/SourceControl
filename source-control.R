source.control <- function(df.control) {
##
  
  
##  df.contol is a data.frame that contains values for the the following variables
##  chr.dir.source.control.scripts is Source control scripts folder
##  chr.dir.hspf is hspf simulation folder
##  chr.file.uci is hspf input file name
##  chr.file.sup is hspf suplimental file name
##  chr.dir.sub.models is folder containing all the sub-model folders
##  chr.pat.model is pattern as a regular expression to search for model R files
##  chr.pat.sub.model.input is pattern as a regular expression to search for input file names
##  NOTE: all fields are character data type

  options(stringsAsFactors = FALSE)
  
  chr.hold <- ls()
  
## assign varaible values
  chr.dir.source.control.scripts <- df.control$chr.dir.source.control.scripts
  chr.dir.hspf <- df.control$chr.dir.hspf
  chr.file.uci <- df.control$chr.file.uci
  chr.file.sup <- df.control$chr.file.sup
  chr.dir.sub.models <- df.control$chr.dir.sub.models
  chr.pat.model <- df.control$chr.pat.model
  chr.pat.sub.model.input <- df.control$chr.pat.sub.model.input
  
  ## load functions
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-sub-model-info.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-sub-model-input.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "run-source-model-for-sub-wtds.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "run-source-model-for-sub-wtds-parallel.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "run-sub-models-for-sources.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "run-sub-models-for-sources-parallel.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-accum-load-to-pls.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-lim-load-to-pls.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-load-to-stream.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-pls-names.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-loads-for-sub-wtsd.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "write-mutsin-files.R"), local = TRUE)
  source(paste0(chr.dir.source.control.scripts, "/", 
                "update-sup.R"), local = TRUE)
  ## not working yet
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-loads-for-sub-wtsds-parallel.R"))
  source(paste0(chr.dir.source.control.scripts, "/", 
                "get-pls-line-info.R"), local = TRUE)

  # get the sub model information
  df.sub.model.info <- get.sub.model.info(
    chr.dir.sub.models = chr.dir.sub.models,
    chr.pat.model = chr.pat.model)
  
  ## get sub model input file names
  df.sub.model.input.files <-
    get.sub.model.input(
      df.sub.model.sources.folders = df.sub.model.info[,1:2],
      chr.pat.sub.model.input = chr.pat.sub.model.input)
  
  ## run all the source sub models for all the sub watersheds
##  lst.output <- run.sub.models.for.sources(df.sub.model.info, 
##                                           df.sub.model.input.files)
  
  ## run in parallel all the source sub models for all the sub watersheds
  lst.output <- run.sub.models.for.sources.parallel(df.sub.model.info,
                                                    df.sub.model.input.files)
  
  ## run get.loads.for.sub.wtsd for all sub-watersheds and put the 
  ## data.frames into a list. I will use the list to rewrite the sup-file and write the MUTSIN files.
  # lst.loads <- lapply(lst.output$sub.wtsd.names, 
  #                     get.loads.for.sub.wtsd, lst.output)
  
  ## can't access get.pls.names from with in "get.loads.for.sub.wtsd" function
 lst.loads <- get.loads.for.sub.wtsd.parallel(lst.output$sub.wtsd.names,
                                              lst.output)
  ## load packages
  # library(parallel)
  # 
  # ## create cluster
  # no_cores <- detectCores() - 1
  # if(no_cores < 1) no_cores <- 1
  # c1 <- makeCluster(no_cores)
  # ##clusterExport(c1,ls())
  # lst.loads <- parLapply(c1, lst.output$sub.wtsd.names, 
  #                        get.loads.for.sub.wtsd, lst.output)
  
  
  names(lst.loads) <- lst.output$sub.wtsd.names
  
  ## get the lines in the sup file for the pls
  df.sup.lines <- get.pls.line.info(paste0(chr.dir.hspf, "/",
                                           chr.file.uci))
  ## The pls name for developed land in the the sub-models is RAOCUT. Change this 
  ## in df.sup.lines
  df.sup.lines$pls.name <- gsub("[dD]evel.*", "RAOCUT", 
                                as.character(df.sup.lines$pls.name))
  
  ## update the sup-file
  update.sup(chr.file = paste0(chr.dir.hspf, "/", chr.file.sup),
             lst.loads =lst.loads, df.sup.lines = df.sup.lines)
  
  ## write mutsin files
  ## create wrapper function for write.mutsin to use in lapply
  wrapper.write.mutsin <- function(chr.name.sub.wtsd, lst.loads, chr.dir.hspf.mutsin, 
                                   chr.file.uci.mutsin, chr.name.wtsd) {
    ## load data.frame
    df.cur <- lst.loads[chr.name.sub.wtsd][[1]]
    chr.name.MUSTIN <- 
      paste0("direct", gsub("[^0-9]", "", chr.name.sub.wtsd), ".mut")
    write.mutsin(df.cur,chr.dir.hspf.mutsin,
                 chr.file.uci.mutsin,chr.name.MUSTIN,
                 chr.name.wtsd,chr.name.sub.wtsd)
  }
  ## generate mutsin files
  junk <- lapply(names(lst.loads), wrapper.write.mutsin, lst.loads, chr.dir.hspf, 
                 chr.file.uci, "Upper Yaquina River")
  rm(junk)  
  chr.all <- ls()
  rm(list = chr.all[-1 * match(chr.hold, chr.all)])
}
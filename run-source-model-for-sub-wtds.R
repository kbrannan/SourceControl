run.source.model.for.sub.wtds <- function(vec.sub.model.input.files,
                                          chr.cur.sub.model.src, 
                                          chr.cur.sub.model.dir,
                                          chr.cur.sub.model.file) {
  ## functions runs source model for all sub watersheds that have input files
  ##
  ## vec.sub.model.input.files - character vector of source model input files
  ## chr.sub.model.src  - name of model R-script
  ## chr.sub.model.dir  - source model R-script folder
  ## chr.sub.model.file - source model R-script file
  
  
  ## get name of sub-model function in the R-script file
  env.sub <- new.env()
  source(paste0(chr.cur.sub.model.dir, "/",
                chr.cur.sub.model.file), local=env.sub)
  chr.cur.sub.model <- ls(envir = env.sub)
  rm(env.sub)
  
  ## get sub-model function
  source(paste0(chr.cur.sub.model.dir, "/", chr.cur.sub.model.file))
  
  ## function wrapper to run source model using function name
  fun.wrap.sub.model <- function(x, fun, f.env) {
    ## set default output to NULL in case input file does not exist
    output <- NULL
    ## set a function to the named function in environment
    if (is.character(fun)) func <- match.fun(fun)
    ## if input file exists run function if not do nothing
    if(file.exists(x)) output <- func(x)
    ## output is either a data from from sub model function or NULL
    return(output)
  }
  
  ## input files with paths
  vec.sub.model.input.files.with.paths <-
    paste0(chr.cur.sub.model.dir, "/", vec.sub.model.input.files)
  
  ## run submodel for all sub-watersheds , returns a list of data frames
  lst.cur.source <- lapply(vec.sub.model.input.files.with.paths, 
                           fun.wrap.sub.model, chr.cur.sub.model)
  
  ## set names of the sub watershed data frames in output list
  if(length(dimnames(vec.sub.model.input.files)[[1]]) == 
     length(vec.sub.model.input.files)) { 
    chr.sub.names <- dimnames(vec.sub.model.input.files)[[1]]
  }
  if(length(dimnames(vec.sub.model.input.files)[[2]]) == 
     length(vec.sub.model.input.files)) { 
    chr.sub.names <- dimnames(vec.sub.model.input.files)[[2]]
  }
  names(lst.cur.source) <- chr.sub.names
  
  ## return sub model for sources run for all sub watersheds
  return(lst.cur.source)
}
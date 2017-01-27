
run.sub.models.for.sources <- function(df.sub.model.info, 
                                       df.sub.model.input.files) {
  ## functions runs sub models for all the sources in df.sub.model.info
  ## using all the input files in df.sub.model.input.files
  ##
  ## df.sub.model.info is data frame output from function
  
  
  ## start function running for all sources
  lst.output <- list()
  
  ## number of sub watersheds
  num.sub.wtsd <- length(df.sub.model.input.files[1, c(-1, -2)])
  
  ## number of sources
  num.sources <- length(df.sub.model.info$source)
  
  ## loop for sources
  for(ii.src in 1:num.sources) {
    ## set input variables for function to run source sub model for sub watersheds
    chr.cur.sub.model.src <- df.sub.model.info$source[ii.src]
    chr.cur.sub.model.dir <- df.sub.model.info$folder[ii.src]
    chr.cur.sub.model.file <- df.sub.model.info$model[ii.src]
    vec.sub.model.input.files <- df.sub.model.input.files[ii.src, c(-1,-2)]
    
    ## run source model for sub watersheds
    lst.cur.source <- run.source.model.for.sub.wtds(vec.sub.model.input.files,
                                                    chr.cur.sub.model.src, 
                                                    chr.cur.sub.model.dir,
                                                    chr.cur.sub.model.file)
    ## append output list with current source ouput
    lst.output[[length(lst.output) + 1]] <- lst.cur.source
    
    ## clean up
    rm(chr.cur.sub.model.src, chr.cur.sub.model.dir, chr.cur.sub.model.file,
       vec.sub.model.input.files, lst.cur.source)
  }
  
  ## set name of the of the source output list in overall list  
  names(lst.output) <- df.sub.model.info$source
  
  ## return the list of output for sources
  return(lst.output)
}

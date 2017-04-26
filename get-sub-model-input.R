get.sub.model.input <- function(df.sub.model.sources.folders,
                                chr.pat.sub.model.input) {
## gets gets input file names for the sub-models
## input
## df.sub.model.sources.folders is the the first two columns of the data frame 
## from get.sub.mode.info function
## chr.pat.sub.model.input is the pattern as a regular expression to search 
## for sub model input files
## returns data frame with
## source is the name of the source from the sub-model filename
## folder is the entire path of the sub-model folder
## N columns with iput file names for each source where N is the number of
## sub watersheds

## function to get min max sub-watershed numbers
  get.number.sub.wtsds <- function(chr.dir.sub.model, 
                                   chr.pat.sub.model.input) {
    chr.files.input <- list.files(
      path = chr.dir.sub.model, pattern = chr.pat.sub.model.input)
    num.range.sub.wtsds <- range(as.numeric(gsub("[aA-zZ.]", "", 
                                                 chr.files.input)))
    return(num.range.sub.wtsds)
  }
## get min and max sub-watershed numbers  
  num.number.of.sub.wtsds <- 
    range(do.call(rbind,
                  lapply(df.sub.model.sources.folders$folder, 
                         get.number.sub.wtsds, chr.pat.sub.model.input)))
## create data frame for output  
  df.sub.model.input <- cbind(df.sub.model.sources.folders,
                              array(data = NA, 
                                    dim = c(length(df.sub.model.sources.folders[,1]),
                                            max(num.number.of.sub.wtsds)),
                                    dimnames = NULL))
  chr.col.names <- 
    paste0("sub.wtsd.", 
           sprintf(
             fmt = paste0("%0",
                          max(nchar(
                            names(df.sub.model.input[, c(-1,-2)]))), "i"),
             as.numeric(names(df.sub.model.input[, c(-1,-2)]))))
  names(df.sub.model.input) <- 
    c(names(df.sub.model.sources.folders), chr.col.names)
## populate output data frame with input file names
  for(ii in 1:length(df.sub.model.input[,1])) {
    tmp.files <- list.files(path = df.sub.model.input$folder[ii],
                            pattern = chr.pat.sub.model.input)
    tmp.col.nums <- as.numeric(gsub("[aA-zZ.]", "", tmp.files)) + 2
    for(jj in 1:length(tmp.col.nums)) {
      df.sub.model.input[ii,tmp.col.nums[jj]] <- tmp.files[jj]
    }
    rm(tmp.files, tmp.col.nums)  
  }  
  return(df.sub.model.input)
}



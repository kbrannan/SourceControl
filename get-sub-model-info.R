get.sub.mode.info <- function(chr.dir.sub.models = NULL,
                              chr.pat.model = NULL) {
## gets source name, folder and filename for the sub-models
## input
## chr.dir.sub.models is the folder containing all the sub-model folders
## chr.pat.model is the pattern as a regular expression to search for model R files
## returns data frame with
## source is the name of the source from the sub-model filename
## folder is the entire path of the sub-model folder
## model is the filename of the R-script for sub-model
  
  
  ## get folders where sub-models are
  tmp.dirs.sub.all <- list.dirs(path = chr.dir.sub.models,
                                full.names = TRUE)
  ## get sub-model file names
  tmp.sub.model <- as.character(sapply(tmp.dirs.sub.all, list.files, 
                                       pattern = chr.pat.model))
  tmp.sub.model <- tmp.sub.model[tmp.sub.model != "character(0)"]
  
  ## get source names
  tmp.sub.strings <- do.call(rbind, strsplit(tmp.sub.model, split = "_"))
  log.keep <- apply(tmp.sub.strings, function(x) !(duplicated(x) | duplicated(x, fromLast = TRUE)), MARGIN = 2)
  tmp.names <- ""
  for(ii in 1:length(tmp.sub.strings[,1])) {
    tmp.val <- tmp.sub.strings[ii,log.keep[ii,]]
    if(length(tmp.val) > 1) tmp.val <-paste0(tmp.val, collapse = ".")
    tmp.names <- c(tmp.names, tmp.val)
    rm(tmp.val)
  }
  tmp.source.names <- tmp.names[-1]
  rm(tmp.names, log.keep, tmp.sub.strings, ii)
  
  ## get model sub-folder names excluding sub-folders without sub-models
  tmp.sub.model.with.dirs <- list.files(path = chr.dir.sub.models,
                                        pattern = chr.pat.model,
                                        recursive = TRUE,
                                        full.names = TRUE, 
                                        no.. = TRUE)
  tmp.dirs.sub.models <- diag(sapply(paste0("/", tmp.sub.model), FUN=gsub, "", tmp.sub.model.with.dirs))
  
  
  df.info.sub.models <- data.frame(source = tmp.source.names,
                                   folder = tmp.dirs.sub.models,
                                   model = tmp.sub.model,
                                   stringsAsFactors = FALSE)
  return(df.info.sub.models)
}

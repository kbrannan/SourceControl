## Source control scripts folder 
chr.dir.source.control.scripts <- 
  "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/SourceControl"

## hspf simulation folder
chr.dir.hspf <- "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/All"

## folder containing all the sub-model folders
chr.dir.sub.models <- paste0(chr.dir.hspf, "/sub-models")

## pattern as a regular expression to search for model R files
chr.pat.model <- "*Model\\.R"

## get the sub model information
df.sub.model.info <- get.sub.mode.info(
  chr.dir.sub.models = chr.dir.sub.models,
  chr.pat.model = chr.pat.model)

## load functions
source(paste0(chr.dir.source.control.scripts, "/", 
              "get-sub-model-info.R"))

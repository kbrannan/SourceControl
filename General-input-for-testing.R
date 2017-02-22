## Source control scripts folder 
chr.dir.source.control.scripts <- 
  "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/SourceControl"

## hspf simulation folder
chr.dir.hspf <- "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/All"

## hspf input file name
chr.file.uci <- "bigelkwq.uci"

## hspf suplimental file name
chr.file.sup <- "bigelkwq.sup"

## folder containing all the sub-model folders
chr.dir.sub.models <- paste0(chr.dir.hspf, "/sub-models")

## pattern as a regular expression to search for model R files
chr.pat.model <- "*Model\\.R"

## load functions
source(paste0(chr.dir.source.control.scripts, "/", 
              "get-sub-model-info.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "get-sub-model-input.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "run-source-model-for-sub-wtds.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "run-source-model-for-sub-wtds-parallel.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "run-sub-models-for-sources.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "run-sub-models-for-sources-parallel.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "get-accum-load-to-pls.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "get-lim-load-to-pls.R"))
source(paste0(chr.dir.source.control.scripts, "/", 
              "get-load-to-stream.R"))

## pattern as a regular expression to search for input file names
chr.pat.sub.model.input <- "*\\.txt"

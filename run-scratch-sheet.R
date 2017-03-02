## load the general input script
source(file = "M:\\Models\\Bacteria\\HSPF\\bacteria-sub-model-testing\\SourceControl\\General-input-for-testing.R")


## get the sub model information
df.sub.model.info <- get.sub.model.info(
  chr.dir.sub.models = chr.dir.sub.models,
  chr.pat.model = chr.pat.model)

## get sub model input file names
df.sub.model.input.files <-
  get.sub.model.input(
    df.sub.model.sources.folders = df.sub.model.info[,1:2],
    chr.pat.sub.model.input = chr.pat.sub.model.input)

## run all the source sub models for all the sub watersheds
##lst.output <- run.sub.models.for.sources(df.sub.model.info, 
##                                         df.sub.model.input.files)

## run in parallel all the source sub models for all the sub watersheds
lst.output <- run.sub.models.for.sources.parallel(df.sub.model.info, 
                                         df.sub.model.input.files)

## run get.loads.for.sub.wtsd for all sub-watersheds and put the 
## data.frames into a list. I will use the list to rewrite the sup-file and write the MUTSIN files.
lst.loads <- lapply(lst.output$sub.wtsd.names, 
                    get.loads.for.sub.wtsd, lst.output)
names(lst.loads) <- lst.output$sub.wtsd.names

## can't access get.pls.names from with in "get.loads.for.sub.wtsd" function
## lst.loads.p <- get.loads.for.sub.wtsd.parallel(lst.output$sub.wtsd.names,
##                                                lst.output)

## get the lines in the sup file for the pls
df.sup.lines <- get.pls.line.info(paste0(chr.dir.hspf, "/",
                                         chr.file.uci))

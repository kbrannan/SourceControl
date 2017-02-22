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

ii.sub <- 12
chr.pls <- "forest"
## get accum load
df.load.accum <- get.accum.load.to.pls(lst.output$sub.wtsd.names[ii.sub],
                                 chr.pls, lst.output)

## get lim load
df.load.lim <- get.lim.load.to.pls(lst.output$sub.wtsd.names[ii.sub],
                                 chr.pls, lst.output)
## check lim/accum ratio
df.load.lim[,2] / df.load.accum[, 2]

## get load to stream
df.load.stream <- get.load.to.stream(lst.output$sub.wtsd.names[ii.sub], 
                                     lst.output)

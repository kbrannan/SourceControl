install.packages("rbenchmark")
library(rbenchmark)

system.time(source.control(df.control = df.control))

system.time(df.sub.model.info <- get.sub.model.info(
  chr.dir.sub.models = df.control$chr.dir.sub.models,
  chr.pat.model = df.control$chr.pat.model))

system.time(df.sub.model.input.files <-
  get.sub.model.input(
    df.sub.model.sources.folders = df.sub.model.info[,1:2],
    chr.pat.sub.model.input = df.control$chr.pat.sub.model.input))

system.time(lst.output <- 
              run.sub.models.for.sources.parallel(df.sub.model.info, 
                                                  df.sub.model.input.files))

system.time(lst.loads <- 
              get.loads.for.sub.wtsd.parallel(lst.output$sub.wtsd.names,
                                              lst.output,
                                              df.control$chr.dir.source.control.scripts)
)

system.time(lst.loads.sub.wtsds <- parLapply(c1, chr.sub.wtsd.names, 
                                               get.loads.for.sub.wtsd, lst.output,
                                               chr.dir.source.control.scripts))

system.time(lst.accum <- lapply(chr.pls.names, get.accum.load.to.pls, chr.sub.wtsd.names[2], 
                                lst.output))

junk <- do.call(rbind,lapply(lst.output$source.names, get.source.load, 
               chr.prefix, chr.pls.names[2],
               chr.sub.wtsd.names[1], lst.output))



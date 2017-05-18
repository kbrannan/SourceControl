install.packages("rbenchmark")
library(rbenchmark)

system.time(source.control(df.control = df.control))

system.time(df.sub.model.info <- get.sub.model.info(
  chr.dir.sub.models = chr.dir.sub.models,
  chr.pat.model = chr.pat.model))

system.time(df.sub.model.input.files <-
  get.sub.model.input(
    df.sub.model.sources.folders = df.sub.model.info[,1:2],
    chr.pat.sub.model.input = chr.pat.sub.model.input))

system.time(lst.output <- 
              run.sub.models.for.sources.parallel(df.sub.model.info, 
                                                  df.sub.model.input.files))

system.time(lst.loads <- lapply(lst.output$sub.wtsd.names,
                                get.loads.for.sub.wtsd, lst.output))
paste0("lst.output$",lst.output$source.names,"$", 
       lst.output$sub.wtsd.names[1])


system.time(lst.loads.sub.wtsds <- parLapply(c1, chr.sub.wtsd.names, 
                                             get.loads.for.sub.wtsd, lst.output))


ii <- 1
jj <- 2
grep(lst.output$sub.wtsd.names[ii], names(lst.output))
grep(lst.output$source.names[jj], names(lst.output))
str(lst.output[[]]$sub.wtsd.01)

chr.sub.wtsd.name <- lst.loads[[1]]$sub.wtsd
system.time(junk <- get.loads.for.sub.wtsd(chr.sub.wtsd.name,
                                           lst.output))

system.time(df.out <- get.accum.load.to.pls(lst.loads[[1]]$sub.wtsd[1],
                                               chr.pls.names[5], lst.output))
system.time(df.out <- get.lim.load.to.pls(lst.loads[[1]]$sub.wtsd[1],
                                            chr.pls.names[5], lst.output))
system.time(lst.accum <- lapply(chr.pls.names, f.wrapper.accum, chr.sub.wtsd.name, 
                                lst.output))


system.time(for(ii.src in 1:n.src) {
  df.cur <- lst.output[[lst.output$source.names[ii.src]]][chr.sub.wtsd][[1]]
  col.cur <- grep(paste0(chr.prefix,chr.pls),names(df.cur), ignore.case = TRUE)
  if(length(col.cur) != 0) {
    ## if the source has accum for pls extract from load data.frame
    chr.ld <- as.character(df.cur[,col.cur])
  } else {
    ## if the source does not have accum for pls set to 0
    chr.ld <- rep("0", 12)
  }
  ## add current source loads to pls to the data.frame for the loads
  df.dest <- 
    rbind(df.dest,
          eval(
            parse(
              text = paste0("data.frame(",
                            paste0(names(df.dest), " = '", 
                                   c(lst.output$source.names[ii.src],
                                     chr.ld),"'",
                                   collapse = " ,"), 
                            ", stringsAsFactors = FALSE)")))
    )
  ## clean up
  rm(df.cur, col.cur)
})


df.out <- get.accum.load.to.pls(wr.sub,
                                wr.pls, wr.lst)

system.time(lst.accum <- lapply(chr.pls.names, f.wrapper.accum, chr.sub.wtsd.name, 
                                lst.output))


system.time(  df.sup.lines <- get.pls.line.info(paste0(chr.dir.hspf, "/",
                                                       chr.file.uci)))
system.time(update.sup(chr.file = paste0(chr.dir.hspf, "/", chr.file.sup),
                         lst.loads =lst.loads, df.sup.lines = df.sup.lines))

system.time(junk <- lapply(names(lst.loads), wrapper.write.mutsin, lst.loads, chr.dir.hspf, 
                           chr.file.uci, "Upper Yaquina River"))

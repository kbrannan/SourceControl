lst.loads <- lst.output

chr.sub.wtsd.names <- lst.loads$sub.wtsd.names

chr.pls.names <- get.pls.names(lst.loads)

ii.sub <- 1
ii.pls <- 3

chr.sub.wtsd.name <- chr.sub.wtsd.names[ii.sub]
chr.pls.name <- chr.pls.names[ii.pls]

## create empty data frame for output , will be in long form
df.loads <- data.frame(load.to = character(), 
                       hspf.input = character(),
                       month = character(),
                       load = double())
                       
## get vector for month names
chr.months <- lst.loads[lst.loads[[1]][1]][[1]][[1]]$Month

## create wrapper functions for using get.accum.load.to.pls and 
## get.lim.load.to.pls in lapply
f.wrapper.accum <- function(wr.pls, wr.sub, wr.lst) {
  df.out <- get.accum.load.to.pls(wr.sub,
                                  wr.pls, wr.lst)
  return(df.out)
}
f.wrapper.lim <- function(wr.pls, wr.sub, wr.lst) {
  df.out <- get.lim.load.to.pls(wr.sub,
                                wr.pls, wr.lst)
  return(df.out)
}

## get accum load
lst.accum <- lapply(chr.pls.names, f.wrapper.accum, chr.sub.wtsd.name, lst.loads)
names(lst.accum) <- paste0("accum.", chr.pls.names)

## get lim load
lst.lim <- lapply(chr.pls.names, f.wrapper.lim, chr.sub.wtsd.name, lst.loads)
names(lst.lim) <- paste0("lim.", chr.pls.names)

## get load to stream
df.load.stream <- get.load.to.stream(chr.sub.wtsd.name, lst.loads)

## function to extract the rows from accum or lim lists
get.rows.lst <- function(chr.pls, lst.loads, chr.prefix) {
  df.out <- lst.loads[paste0(chr.prefix,chr.pls)][[1]][,2]
  return(df.out)
}

## contruct long format data.frames from accum and lim lists along with stream
## data.frame
## accum
df.cur.accum <- data.frame(chr.months, 
                           do.call(cbind,lapply(chr.pls.names, get.rows.lst, 
                                                lst.accum, 
                                                chr.prefix = "accum.")))
names(df.cur.accum) <- c("month", paste0(chr.pls.names))
df.cur.accum <- reshape2::melt(df.cur.accum, id.vars = c(1))
names(df.cur.accum) <- c("month", "load.to", "load")
df.cur.accum <- cbind(df.cur.accum[, "load.to"], 
                      hspf.input = "accum", 
                      df.cur.accum[, c("month", "load")])
names(df.cur.accum) <- c("load.to", "hspf.input", "month", "load")
## lim
df.cur.lim <- data.frame(chr.months, 
                           do.call(cbind,lapply(chr.pls.names, get.rows.lst, 
                                                lst.lim, 
                                                chr.prefix = "lim.")))
names(df.cur.lim) <- c("month", paste0(chr.pls.names))
df.cur.lim <- reshape2::melt(df.cur.lim, id.vars = c(1))
names(df.cur.lim) <- c("month", "load.to", "load")
df.cur.lim <- cbind(df.cur.lim[, "load.to"], 
                      hspf.input = "lim", 
                      df.cur.accum[, c("month", "load")])
names(df.cur.lim) <- c("load.to", "hspf.input", "month", "load")
## stream
df.cur.stream <- cbind(load.to = "stream", hspf.input = "MUTSIN", 
                       df.load.stream)
names(df.cur.stream) <- c("load.to", "hspf.input", "month", "load")

names(df.cur.accum)
names(df.cur.lim)
names(df.cur.stream)

df.sub.wtsd.load <- rbind(df.cur.accum, df.cur.lim, df.cur.stream)
df.sub.wtsd.load <- cbind(sub.wtsd = chr.sub.wtsd.name, df.sub.wtsd.load)

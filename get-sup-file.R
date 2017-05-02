## Source control scripts folder 
chr.dir.source.control.scripts <- 
  "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/SourceControl"

## hspf simulation folder
chr.dir.hspf <- paste0(chr.dir.source.control.scripts, "/hspf")

## hspf suplimental file name
chr.file.sup <- "bigelkwq.sup"



options(stringsAsFactors = FALSE)

chr.sup <- scan(file = paste0(chr.dir.hspf, "/", chr.file.sup),
             what = "character",
             sep = "\n", quiet = TRUE)



lng.accum.st <- grep("MON-ACCUM", chr.sup)
lng.sqolim.st <- grep("MON-SQOLIM", chr.sup)

lng.accum.blk <- c(lng.accum.st, lng.sqolim.st - 1)
lng.sqolim.blk <- c(lng.sqolim.st, length(chr.sup))

chr.sup.accum <- chr.sup[lng.accum.blk[1]:lng.accum.blk[2]]

chr.sup.sqolim <- chr.sup[lng.sqolim.blk[1]:lng.sqolim.blk[2]]


make.mon.df <- function(chr.table, chr.pre = "") {

  chr.sup.line <- gsub("(( ){1,}12)|[^0-9]","",
                       chr.table[seq(from = 1, 
                                               to = length(chr.table), 
                                               by = 2)])
  df.table <- as.data.frame(
    cbind(
      strftime(as.POSIXct(paste0("1967-",1:12,"-1")), format = "%b"),
      do.call(cbind,
              strsplit(chr.table[
                seq(from = 2, to = length(chr.table), by = 2)],
                split = "( ){1,}"))[-1,]))
  
  names(df.table) <- c("month", paste0(chr.pre, "supln",chr.sup.line))  
  return(df.table)
}

df.accum <- make.mon.df(chr.sup.accum, "accum")
df.sqolim <- make.mon.df(chr.sup.sqolim, "sqolim")


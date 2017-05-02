## Source control scripts folder 
chr.dir.source.control.scripts <- 
  "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/SourceControl"

## hspf simulation folder
chr.dir.hspf <- paste0(chr.dir.source.control.scripts, "/hspf")

## hspf suplimental file name
chr.file.sup <- "bigelkwq.sup"


chr.sup <- scan(file = paste0(chr.dir.hspf, "/", chr.file.sup),
             what = "character",
             sep = "\n", quiet = TRUE)



lng.accum.st <- grep("MON-ACCUM", chr.sup)
lng.sqolim.st <- grep("MON-SQOLIM", chr.sup)

lng.accum.blk <- c(lng.accum.st, lng.sqolim.st - 1)
lng.sqolim.blk <- c(lng.sqolim.st, length(chr.sup))

chr.sup.accum <- chr.sup[lng.accum.blk[1]:lng.accum.blk[2]]

chr.sup.sqolim <- chr.sup[lng.sqolim.blk[1]:lng.sqolim.blk[2]]

gsub("(( ){1,}12)|[^0-9]","",chr.sup.accum[seq(from = 1, to = length(chr.sup.accum), by = 2)])


do.call(rbind,strsplit(chr.sup.accum[seq(from = 1, to = length(chr.sup.accum), by = 2)],
         split = "( ){1,}"))
chr.sup.accum[seq(from = 2, to = length(chr.sup.accum), by = 2)]

chr.file <- paste0(chr.dir.hspf, "/", chr.file.uci)

chr.input.hspf.sup <- scan(file = chr.file,
                           what = "character", sep = "\n",
                           quiet = TRUE)
df.cur <- lst.loads[["sub.wtsd.01"]]

df.cur$load[df.cur$load.to == "Pasture"][1]

##  3.0614881E+06
paste0(sprintf(fmt = "  %.5E", df.cur$load[df.cur$load.to == "Pasture"]),
       collapse = "")

grep(paste0("^", df.sup.lines$sup.num.accum[2], "( ){1,}12"), chr.input.hspf.sup)

grep("^24", chr.file)

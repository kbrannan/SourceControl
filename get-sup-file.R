junk <- scan(file = paste0(chr.dir.hspf, "/", chr.file.sup),
             what = "character",
             sep = "\n", quiet = TRUE)



grep("MON-ACCUM", junk)

grep("MON-SQOLIM", junk)

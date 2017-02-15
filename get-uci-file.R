junk <- scan(file = paste0(chr.dir.hspf, "/", chr.file.uci),
             what = "character",
             sep = "\n", quiet = TRUE)

grep("^( ){1,}MON-ACCUM", junk)


grep("^( ){1,}END MON-ACCUM", junk)

grep("MON-SQOLIM", junk)

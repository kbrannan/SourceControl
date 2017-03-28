chr.file <- paste0(chr.dir.hspf, "/", chr.file.uci)

chr.input.hspf.sup <- scan(file = chr.file,
                           what = "character", sep = "\n",
                           quiet = TRUE)
df.cur.loads <- lst.loads[["sub.wtsd.01"]]

chr.sub.wtsd <- unique(gsub("[^0-9]", "", df.cur.loads$sub.wtsd))
df.cur.sup.lines <- df.sup.lines[grep(paste0("^", chr.sub.wtsd, "$"), 
                                      df.sup.lines$sub), ]

df.cur.sup.lines$pls.name <- gsub("[dD]evel.*", "RAOCUT", as.character(df.cur.sup.lines$pls.name))

df.cur.sup.lines$pls.name <- tolower(df.cur.sup.lines$pls.name)
df.cur.sup.lines <- unique(df.cur.sup.lines[, ])

df.cur.accum <- df.cur.loads[grep("accum", df.cur.loads$hspf.input), ]
df.cur.accum$load.to <- tolower(df.cur.accum$load.to)

chr.load.to <- unique(tolower(df.cur.accum$load.to))

unique(df.cur.accum[grep("forest", tolower(df.cur.accum$load.to)), c("load.to", "month", "load")])

merge(unique(df.cur.accum[, c("load.to", "month", "load")]),
      unique(df.cur.sup.lines[, c("pls.name", "sup.num.accum")]),
      by.x = c("load.to"), by.y = c("pls.name"))

grep("^24", chr.file)

##  3.0614881E+06
paste0(sprintf(fmt = "  %.5E", df.cur$load[df.cur$load.to == "Pasture"]),
       collapse = "")

grep(paste0("^", df.sup.lines$sup.num.accum[2], "( ){1,}12"), chr.input.hspf.sup)

grep("^24", chr.file)

## MUTSIN output file name
chr.name.MUSTIN <- "direct01.mut"

## watershed and sub-watershed names
chr.name.wtsd <- "Upper Yaquina River"
chr.name.sub.wtsd <- "sub.wtsd.01"

## read uci file
chr.input.hspf.uci <- scan(file = paste0(chr.dir.hspf, "/", chr.file.uci),
                           what = "character", sep = "\n",
                           quiet = TRUE)

int.global <- grep("GLOBAL", chr.input.hspf.uci)

dte.sim <- as.POSIXct(
  gsub("/","-",
     do.call(rbind,
             strsplit(
               grep("START",
                    chr.input.hspf.uci[int.global[1]:int.global[2]], 
                    value = TRUE), 
               split = "( ){1,}"))[c(3,6)]))

df.load <- data.frame(date = seq(from = dte.sim[1], to = dte.sim[2], by = "months"),
                      load = 0)
df.cur <- lst.loads["sub.wtsd.01"][[1]]
str(df.cur)
unique(df.cur$load.to)

df.stream <- df.cur[df.cur$load.to == "stream", ]



strftime(df.load$date[1:5], "%b")
df.load <- data.frame(df.load(,), 
                month = strftime(df.load$date, "%b"),
              stringsAsFactors = FALSE)

df.mutsin <- merge(df.load, df.stream, by = "month")[, c("date", "load.y")]

df.mutsin <- df.mutsin[order(df.mutsin$date), ]

## create character vector for output
chr.mutsin <- c("**** Direct Deposit Fecal Coliform Load",
                paste0("**** Watershed: ", chr.name.wtsd),
                paste0("**** Sub-watershed: ", chr.name.sub.wtsd),
                "      Year Mo Da Hr Mi   FC",
                paste0(
                  strftime(df.mutsin$date, format = "      %Y %m %d 24 00"),
                  sprintf(fmt = "   %.5E", df.mutsin$load.y)))

cat(chr.mutsin, sep = "\n")

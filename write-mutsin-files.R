## input
## MUTSIN output file name
chr.name.MUSTIN <- "direct01.mut"

## HSPF related input
chr.dir.hspf.mutsin <- chr.dir.hspf
chr.file.uci.mutsin <- chr.file.uci

## watershed and sub-watershed names
chr.name.wtsd <- "Upper Yaquina River"
chr.name.sub.wtsd <- "sub.wtsd.01"

## load data.frame
df.cur <- lst.loads["sub.wtsd.01"][[1]]



## function
## read uci file and get simulation period
chr.input.hspf.uci <- scan(file = paste0(chr.dir.hspf.mutsin, "/", 
                                         chr.file.uci.mutsin),
                           what = "character", sep = "\n",
                           quiet = TRUE)
int.global <- grep("GLOBAL", chr.input.hspf.uci)
## simulation period
dte.sim <- as.POSIXlt(
  gsub("/","-",
     do.call(rbind,
             strsplit(
               grep("START",
                    chr.input.hspf.uci[int.global[1]:int.global[2]], 
                    value = TRUE), 
               split = "( ){1,}"))[c(3,6)]))
paste0(1900 + dte.sim[1]$year -1, "-12-31")

## create empty data.frame for direct deposit loads
df.load <- data.frame(date = c(as.POSIXct(paste0(1900 + dte.sim[1]$year -1, "-12-31")),
                               seq(
                                 from = as.POSIXct(paste0(1900 + dte.sim[1]$year, "-01-31")),
                                 to = as.POSIXct(paste0(1900 + dte.sim[2]$year, "-12-31")),
                                                        by = "months")))
## create date sequence using gegin and end date of simulation by month
## start date is Dec 31 of the year prior to the year of the simulation start date
## end date is Dec 31 of the year of the simulation end date
tmp.seq.date <- seq(
  from = as.POSIXct(paste0(1900 + dte.sim[1]$year, "-01-01 0:0:0")),
  to = as.POSIXct(paste0(1900 + dte.sim[2]$year + 1, "-01-010:0:0")),
  by = "months")
tmp.seq.date <- as.Date(tmp.seq.date) - 1


## create data.frame of date sequence and the corresponding month of each data
tmp.date <- data.frame(date = tmp.seq.date,
                       month = strftime(tmp.seq.date, format = "%b"),
                       stringsAsFactors = FALSE)

## get monthly loads to stream
tmp.stream <- df.cur[df.cur$load.to == "stream", c("month", "load")]
str(tmp.stream)


## combine date and stream load data.frame by month to get monthly laods for the dates
df.mutsin <- merge(tmp.date, tmp.stream, by = "month")

## reorder by date and drop month
df.mutsin <- df.mutsin[order(df.mutsin$date), c("date", "load")]

## create character vector for output
chr.mutsin <- c("**** Direct Deposit Fecal Coliform Load",
                paste0("**** Watershed: ", chr.name.wtsd),
                paste0("**** Sub-watershed: ", chr.name.sub.wtsd),
                "      Year Mo Da Hr Mi   FC",
                paste0(
                  strftime(df.mutsin$date, format = "      %Y %m %d 24 00"),
                  sprintf(fmt = "   %.5E", df.mutsin$load)))

## write MUTSIN file
write.table(chr.mutsin, file = paste0(chr.dir.hspf.mutsin, "/",
                                      chr.name.MUSTIN),
            col.names = FALSE, row.names = FALSE, quote = FALSE)

get.pls.line.info <- function(chr.file) {
  
  ## read uci file
  chr.input.hspf.uci <- scan(file = chr.file,
                           what = "character", sep = "\n",
                           quiet = TRUE)

  ## get beginning and end of PERLND block
  int.str <- min(grep("^PERLND", chr.input.hspf.uci))
  int.end <- grep("^END PERLND", chr.input.hspf.uci)

  ## get pls info from GEN-INFO block
  chr.gen.info <- 
    chr.input.hspf.uci[
      (int.str + 
         min(grep("GEN-INFO", 
                  chr.input.hspf.uci[int.str:int.end])) -1):
        (int.str + 
           grep("END GEN-INFO", chr.input.hspf.uci[int.str:int.end]) - 1)]
  int.drop <- -1 * c(grep("GEN-INFO", chr.gen.info),
                     grep("\\*\\*", chr.gen.info))
  chr.gen.info <- chr.gen.info[int.drop]
  df.gen.info <- data.frame(do.call(rbind,
                                    strsplit(chr.gen.info[int.drop], 
                                             "( ){1,}"))[, c(2,4,5)])
  names(df.gen.info) <- c("pls.num", "sub", "pls.name.lng")
  df.gen.info <- cbind(df.gen.info, 
                       pls.name = 
                         do.call(rbind, 
                                 strsplit(as.character(df.gen.info[, 3]),
                                          "/"))[,1])
  rm(int.drop, chr.gen.info)
  
## function gets sup number given pls numer and mon-accum/sqolim data frame
  get.sup.from.pls <- function(num.pls, df.mon) {
    
  }
  
  
  
## get line numbers for MON-ACCUM
  chr.mon.accum <- 
    chr.input.hspf.uci[
      (int.str + 
         min(grep("MON-ACCUM", 
                  chr.input.hspf.uci[int.str:int.end])) -1):
        (int.str + 
           grep("END MON-ACCUM", chr.input.hspf.uci[int.str:int.end]) - 1)]

  int.drop <- -1 * c(grep("MON-ACCUM", chr.mon.accum), 
                     grep("\\*\\*", chr.mon.accum))
  chr.mon.accum <- chr.mon.accum[int.drop]
  df.mon.accum <- data.frame(
    str = as.numeric(gsub(" ", "", substr(chr.mon.accum, 3, 5))),
    end = as.numeric(gsub(" ", "", substr(chr.mon.accum, 8, 10))),
    sup.line = gsub(" ", "", (gsub("~","",
                                   substr(chr.mon.accum, 71, 80)))))
  
  df.pls.sup.nums.mon.accum <- data.frame()
  for(ii in 1:length(df.mon.accum[,1])) {
    df.pls.sup.nums.mon.accum <- 
      rbind(df.pls.sup.nums.mon.accum, 
            gen.pls.nums(df.mon.accum[ii,]))
  }
  rm(chr.mon.accum, int.drop)
  names(df.pls.sup.nums.mon.accum) <- c("pls.num", "sup.num.accum")

## get line numbers for MON-SQOLIM
  chr.mon.sqolim <- 
    chr.input.hspf.uci[
      (int.str + 
         min(grep("MON-SQOLIM", 
                  chr.input.hspf.uci[int.str:int.end])) -1):
        (int.str + 
           grep("END MON-SQOLIM", chr.input.hspf.uci[int.str:int.end]) - 1)]
  
  int.drop <- -1 * c(grep("MON-SQOLIM", chr.mon.sqolim), 
                     grep("\\*\\*", chr.mon.sqolim))
  chr.mon.sqolim <- chr.mon.sqolim[int.drop]
  df.mon.sqolim <- data.frame(
    str = as.numeric(gsub(" ", "", substr(chr.mon.sqolim, 3, 5))),
    end = as.numeric(gsub(" ", "", substr(chr.mon.sqolim, 8, 10))),
    sup.line = gsub(" ", "", (gsub("~","",
                                   substr(chr.mon.sqolim, 71, 80)))))
  df.pls.sup.nums.mon.sqolim <- data.frame()
  for(ii in 1:length(df.mon.sqolim[,1])) {
    df.pls.sup.nums.mon.sqolim <- 
      rbind(df.pls.sup.nums.mon.sqolim, 
            gen.pls.nums(df.mon.sqolim[ii,]))
  }
  rm(chr.mon.sqolim, int.drop)
  names(df.pls.sup.nums.mon.sqolim) <- c("pls.num", "sup.num.sqolim")
  
  ## merge accum and sqlim data frames and return the result
  df.pls.sup.num <- merge.data.frame(df.pls.sup.nums.mon.accum, 
                   df.pls.sup.nums.mon.sqolim, 
                   by = c("pls.num"))
  return(df.pls.sup.num)
}
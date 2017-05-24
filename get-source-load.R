get.source.load <- function(chr.source.name, chr.prefix, chr.pls,
                           chr.sub.wtsd, lst.output) {
  ## create empty data.frame for the loads to the pls from all the sources
  df.dest <- as.data.frame(
    setNames(replicate(13,character(0)),
             c("source", strftime(as.POSIXlt(paste0("1999-",1:12,"-01")), 
                                  format = "%b"))),
    stringsAsFactors = FALSE)
  
  ## populate the data.frame for for source and the pls
  df.cur <- lst.output[[chr.source.name]][chr.sub.wtsd][[1]]
  col.cur <- grep(paste0(chr.prefix,chr.pls),names(df.cur), ignore.case = TRUE)
  if(length(col.cur) != 0) {
  ## if the source has accum for pls extract from load data.frame
    chr.ld <- as.character(df.cur[,col.cur])
    } else {
  ## if the source does not have accum for pls set to 0
    chr.ld <- rep("0", 12)
    }
  ## add current source loads to pls to the data.frame for the loads
  df.dest <- 
    rbind(df.dest,
          eval(
            parse(
              text = paste0("data.frame(",
                            paste0(names(df.dest), " = '", 
                                     c(chr.source.name,
                                       chr.ld),"'",
                                     collapse = " ,"), 
                              ", stringsAsFactors = FALSE)")))
      )
  return(df.dest)
}
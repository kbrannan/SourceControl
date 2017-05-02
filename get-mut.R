get.mut <- function(chr.mut.list) {
  options(stringsAsFactors = FALSE)
  df.mut <- data.frame(character(0), character(0))
  for(ii in 1:length(chr.mut.list)) {
    df.mut <- rbind(df.mut,
                    cbind(paste0(gsub("\\.mut", "", chr.mut.list[ii]),
                                 strftime(as.POSIXct(paste0("1967-",1:12,"-1")), format = "%b")),
                          gsub("^.*00( ){1,}","", 
                               chr.mut[(grep("^( ){1,}Year", chr.mut) + 1):(grep("^( ){1,}Year", chr.mut) + 12)])
                    ))  
  }
  names(df.mut) <- c("varname", "value")
  return(df.mut)
}
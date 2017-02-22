## get-accum-load-to-pls

get.accum.load.to.pls <- function(chr.sub.wtsd, chr.pls, lst.loads) {
  
  chr.prefix <- "accum.*"
  
  n.src <- length(lst.loads$source.names)
  
  
  pct.mons <- as.POSIXlt(paste0("1999-",1:12,"-01"))
  
  df.dest <- as.data.frame(
    setNames(replicate(13,character(0)),
             c("source", strftime(as.POSIXlt(paste0("1999-",1:12,"-01")), 
                                  format = "%b"))),
    stringsAsFactors = FALSE)
  
  
  for(ii.src in 1:n.src) {
    df.cur <- lst.loads[[lst.loads$source.names[ii.src]]][lst.loads$sub.wtsd.names[ii.sub]][[1]]
    col.cur <- grep(paste0(chr.prefix,chr.pls),names(df.cur), ignore.case = TRUE)
    if(length(col.cur) != 0) {
      chr.ld <- as.character(df.cur[,col.cur])
    } else {
      chr.ld <- rep("0", 12)
    }
    df.dest <- 
      rbind(df.dest,
            eval(
              parse(
                text = paste0("data.frame(",
                              paste0(names(df.dest), " = '", 
                                     c(lst.loads$source.names[ii.src],
                                       chr.ld),"'",
                                     collapse = " ,"), 
                              ", stringsAsFactors = FALSE)")))
      )
    rm(df.cur, col.cur)
  }
  
  
  df.loads <- colSums(sapply(df.dest[, 2:13], as.numeric))
  
}

chr.dest <- c("Pasture", "Forest", "RAOCUT", "stream")
n.dest <- length(chr.dest)


ii.sub <- 8
ii.dest <- 1

lst.loads <- lst.output
chr.sub.wtsd <- lst.loads$sub.wtsd.names[ii.sub]
chr.pls <- chr.dest[ii.dest]








lst.output[source.names == "Cow.Calf", sub.wtsd.names == "sub.wtsd.01", ]

names(lst.output)

lst.output$source.names
lst.output$sub.wtsd.names


## get the load to pasture in sub wtsd 01

ii <- 5
n.src <- length(lst.output$source.names)

ii.dest <- 1

pct.mons <- as.POSIXlt(paste0("1999-",1:12,"-01"))
strftime(as.POSIXlt(paste0("1999-",1:12,"-01")), format = "%b")

df.dest <- as.data.frame(
  setNames(replicate(13,character(0)),
           c("source", strftime(as.POSIXlt(paste0("1999-",1:12,"-01")), format = "%b"))))

for(ii.src in 1:n.src) {
  Sys.sleep(0.1)
  df.cur <- lst.output[[lst.output$source.names[ii.src]]][lst.output$sub.wtsd.names[ii.sub]][[1]]
  col.cur <- grep(paste0("accum.*",chr.dest[ii.dest]),names(df.cur), ignore.case = TRUE)
  if(length(col.cur) != 0) {
    chr.ld <- as.character(df.cur[,col.cur])
  } else {
    chr.ld <- rep("0", 12)
  }
  
  print(paste0("Values for ", lst.output$source.names[ii.src], " in ", 
         lst.output$sub.wtsd.names[ii.sub], " on ", chr.dest[ii.dest], " is ",
         paste0(chr.ld, collapse = " ")))
  print("")
  flush.console()
  df.dest <- 
    rbind(df.dest,
          eval(
            parse(
              text = paste0("data.frame(",
                            paste0(names(df.dest), " = '", 
                                   c(lst.output$source.names[ii.src],
                                     chr.ld),"'",
                                   collapse = " ,"), ")")))
    )
}

colSums(as.numericdf.dest[, 2:13])

rbind(df.dest,df.now)
df.now <- eval(parse(text = paste0("data.frame(",
       paste0(names(df.dest), " = '", c(lst.output$source.names[ii.src],df.cur[,col.cur]),"'",
       collapse = " ,"), ")")))

c("data.frame(",paste0(names(df.dest), " = '", c(lst.output$source.names[ii.src],df.cur[,col.cur]), "'"), ")")



chr.dest <- c("Pasture", "Forest", "RAOCUT", "stream")

length(lst.output[lst.output$sub.wtsd.names[ii.sub.wtsd]])

df.cur <- lst.output[[lst.output$source.names[vec.sources[ii]]]][[lst.output$sub.wtsd.names[ii.sub.wtsd]]]

paste0(lst.output$source.names[ii.src], ": ", 
       paste0(names(lst.output[[lst.output$source.names[ii.src]]]
                    [[lst.output$sub.wtsd.names[ii.sub.wtsd]]]), sep = " "))

grep("Accum.", names(df.cur), ignore.case = TRUE, value = TRUE)


int.cols <- grep("Accum.Pasture", names(df.cur), ignore.case = TRUE)

df.cur[, int.cols]

lst.output[["Cow.Calf"]]

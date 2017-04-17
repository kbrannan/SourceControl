update.sup <- function(chr.file = NULL, lst.loads = NULL) {
  
  ## get the names of the sub watersheds from lst.loads
  chr.sub.wtsds <- names(lst.loads)
  
  ## read sup file
  chr.input.hspf.sup <- scan(file = chr.file,
                             what = "character", sep = "\n",
                             quiet = TRUE)
  
  for(jj in 1:length(chr.sub.wtsds)) {
    ## get loads data.frame for current sub watershed
    df.cur.loads <- lst.loads[[chr.sub.wtsds[jj]]]
    
    ## get the sub watershed number
    chr.sub.wtsd <- unique(gsub("[^0-9]", "", df.cur.loads$sub.wtsd))
    
    ## get the sup lines for current sub watershed
    df.cur.sup.lines <- df.sup.lines[grep(paste0("^", chr.sub.wtsd, "$"), 
                                          df.sup.lines$sub), ]
    ## make all pls names lower case for matching later
    df.cur.sup.lines$pls.name <- tolower(df.cur.sup.lines$pls.name)
    ## get rid of duplicate rows for different types of forest, pasture and developed
    ## forest, pasture and developed each receive the same loads across types
    df.cur.sup.lines <- unique(df.cur.sup.lines[, ])
    
    ## get the loads for the mon-accum and mon-sqolim tables
    df.cur.sup.loads <- df.cur.loads[grep("(accum)|(lim)", df.cur.loads$hspf.input), ]
    ## make all pls names lower case for matching later
    df.cur.sup.loads$load.to <- tolower(df.cur.sup.loads$load.to)
    
    chr.load.to <- unique(tolower(df.cur.sup.loads$load.to))
    chr.hspf.input <- unique(df.cur.sup.loads$hspf.input)
    
    ## combine load and sup line data.frames by pls num
    df.cur.sup <- merge(unique(df.cur.sup.loads[, c("load.to", "hspf.input", "month", "load")]),
                        unique(df.cur.sup.lines[, c("pls.name", "sup.num.accum", "sup.num.sqolim")]),
                        by.x = c("load.to"), by.y = c("pls.name"))
    
    ## reshape df.cur.sup bt brute forse to get long format
    tmp.accum <- df.cur.sup[df.cur.sup$hspf.input == "accum", c(1,2,3,4,5)]
    tmp.lim <- df.cur.sup[df.cur.sup$hspf.input == "lim",   c(1,2,3,4,6)]
    names(tmp.accum) <- c("load.to", "hspf.input", "month", "load", "sup.num")
    names(tmp.lim) <- c("load.to", "hspf.input", "month", "load", "sup.num")
    df.cur.sup <- rbind(tmp.accum, tmp.lim)
    ## make sure order of months is correct
    df.cur.sup <- cbind(df.cur.sup, 
                        month.num = strftime(strptime(paste0("2015-", 
                                                             df.cur.sup$month, -01),
                                                      format = "%Y-%B-%d"), "%m"))
    df.cur.sup <- 
      df.cur.sup[order(df.cur.sup$hspf.input, 
                       df.cur.sup$load.to, df.cur.sup$month.num), ]
    
    ## get the lines in the sup file to be updated
    chr.sup.lines <- unique(df.cur.sup$sup.num)
    
    ## loop throu and update lines in sup file with new loads
    for(ii in 1:length(chr.sup.lines)) {
      num.cur <- grep(paste0("^", chr.sup.lines[ii], "( ){1,}12"), 
                      chr.input.hspf.sup) + 1
      num.rows <- grep(chr.sup.lines[ii], df.cur.sup$sup.num)
      chr.input.hspf.sup[num.cur] <- 
        paste0(sprintf(fmt = "  %.7E", df.cur.sup[num.rows, "load"]),
               collapse = "")
      rm(num.cur, num.rows)
    }  
  }
  
  # write the updated sup file, overwrite previous file
  write.table(chr.input.hspf.sup, file = chr.file, row.names = FALSE,
              quote = FALSE,  col.names = FALSE)
}



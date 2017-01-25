
chr.dir.sub.model <- df.sub.model.info[1,2]
chr.pat.sub.model.input <- "*\\.txt"

chr.files.input <- list.files(
  path = chr.dir.sub.model, pattern = chr.pat.sub.model.input)

range(as.numeric(gsub("[aA-zZ.]", "", chr.files.input)))

get.number.sub.wtsds <- function(chr.dir.sub.model, 
                                 chr.pat.sub.model.input) {
  chr.files.input <- list.files(
    path = chr.dir.sub.model, pattern = chr.pat.sub.model.input)
  num.range.sub.wtsds <- range(as.numeric(gsub("[aA-zZ.]", "", 
                                               chr.files.input)))
  return(num.range.sub.wtsds)
}

get.number.sub.wtsds(chr.dir.sub.model, chr.pat.sub.model.input)

range(do.call(rbind,
        lapply(df.sub.model.info[,2], get.number.sub.wtsds, 
               chr.pat.sub.model.input)))

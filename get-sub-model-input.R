
chr.dirs.sub.model <- df.sub.model.info[,2]
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

num.number.of.sub.wtsds <- range(do.call(rbind,
        lapply(df.sub.model.info[,2], get.number.sub.wtsds, 
               chr.pat.sub.model.input)))

df.sub.model.info

df.sub.model.input <- cbind(df.sub.model.info[,1:2],
                            array(data = NA, 
                                  dim = c(length(df.sub.model.input[,1]),
                                          max(num.number.of.sub.wtsds)),
                                  dimnames = NULL))

array(data = NA, dim = c(length(df.sub.model.input[,1]),
                         max(num.number.of.sub.wtsds)),
      dimnames = NULL)

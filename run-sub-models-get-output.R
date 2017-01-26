## run-sub-models-get-output

lst.output <- list()

ii <- 1

chr.cur.sub.model.file <- paste0(df.sub.model.info[ii,2:3], collapse = "/")

env.sub <- new.env()
source(chr.cur.sub.model.file, local=env.sub)
chr.cur.sub.model <- ls(envir = env.sub)
rm(list=ls(envir = env.sub), envir = env.sub)

vec.cur.sub.model.input <- paste0(df.sub.model.info$folder[ii], "/",
                                  df.sub.model.input.files[ii, c(-1,-2)])

chk.file <- function(f,p) {
  output <- NA
  if(is.na(f) != TRUE) paste0(p, "/", f)
}

vec.cur.sub.model.input <- 
  do.call(rbind, sapply(df.sub.model.input.files[ii, c(-1,-2)], 
                        chk.file, df.sub.model.info$folder[ii]))
do.call(cbind,dimnames(vec.cur.sub.model.input)[1])

jj <- 1

source(chr.cur.sub.model.file)

myfun <- function(x, fun, f.env) {
  output <- NA
  if (is.character(fun)) func <- match.fun(fun)
  if(file.exists(x)) output <- func(x)
  return(output)
}

lst.cur.source <- lapply(vec.cur.sub.model.input, myfun, chr.cur.sub.model)
names(lst.cur.source) <- df.sub.model.info$source[ii]

names(lst.cur.source) <- do.call(cbind,dimnames(vec.cur.sub.model.input)[1])

rm(list = c(eval(chr.cur.sub.model)))

lst.output[[length(lst.output) + 1]] <- 
  list(eval(
    parse(text = paste0(df.sub.model.info$source[ii], " = lst.cur.source"))))
names(lst.output[[length(lst.output)]]) <- df.sub.model.info$source[ii]
str(lst.output[[1]][1], max.level = 1)
lst.output[[1]]$Cow.Calf[1]

chr.cur.name.src <- names(lst.output[[1]])

chr.cur.sub.wtsds <- names(lst.output[[1]][chr.cur.name.src][[1]])

ii.src <- 1
ii.sub <- 3

lst.output[[1]][chr.cur.name.src][[1]][chr.cur.sub.wtsds[ii.sub]]

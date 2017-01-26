## run-sub-models-get-output

tmp.sub.wtsd <- as.list(x = names(df.sub.model.input.files[1,c(-1,-2)]))

tmp.sources <- as.list( x = df.sub.model.info[,1])

tmp.sources[[1]] <- tmp.sub.wtsd

ii <- 1

source(paste0(df.sub.model.info[ii,2:3], collapse = "/"),
             functions = "cur.sub.model")

env.sub <- new.env()
source(paste0(df.sub.model.info[ii,2:3], collapse = "/"),
       local=env.sub)
chr.cur.sub.model <- ls(envir = env.sub)
rm(list=ls(envir = env.sub), envir = env.sub)

vec.cur.sub.model.input <- paste0(df.sub.model.info$folder[ii], "/",
                                  df.sub.model.input.files[ii, c(-1,-2)])

chk.file <- function(f,p) {
  output <- NA
  if(is.na(f) != TRUE) paste0(p, "/", f)
}

vec.cur.sub.model.input <- sapply(df.sub.model.input.files[ii, c(-1,-2)], chk.file, df.sub.model.info$folder[ii])

jj <- 1

chr.cur.run <- paste0(chr.cur.sub.model, "(",
                      vec.cur.sub.model.input[jj], ")")

expr.cur.model <- expression(paste0("junk <- ",chr.cur.run))

eval(parse(text = chr.cur.run))

chr.cur.run <- gsub("/", "\\\\", chr.cur.run)

myfun <- function(x, fun) {
  output <- NA
  if (is.character(fun)) fun <- match.fun(fun)
  if(file.exists(x)) output <- fun(x)
  return(output)
}
file.exists(vec.cur.sub.model.input[3])
junk <- lapply(vec.cur.sub.model.input, myfun, chr.cur.sub.model)

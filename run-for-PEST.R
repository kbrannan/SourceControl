options(stringsAsFactors = FALSE)

## Source control scripts folder 
chr.dir.source.control.scripts <- 
  "Z:/"

setwd(chr.dir.source.control.scripts)

## load source control function
source(paste0(chr.dir.source.control.scripts, "/", "source-control.R"))

## df.control for source.control function
df.control <- data.frame(
  chr.dir.source.control.scripts = chr.dir.source.control.scripts,
  chr.dir.hspf = paste0(chr.dir.source.control.scripts, "/", "hspf"),
  chr.file.uci = "bigelkwq.uci",
  chr.file.sup = "bigelkwq.sup",
  chr.dir.sub.models = paste0(chr.dir.source.control.scripts, "/", "sub-models"),
  chr.pat.model = "\\.R",
  chr.pat.sub.model.input = "\\.txt")

## run source.control
source.control(df.control)

## post-process source control run
source(paste0(chr.dir.source.control.scripts, "/", "post-proc-sup-mut.R"))

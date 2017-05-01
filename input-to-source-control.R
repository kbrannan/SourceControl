options(stringsAsFactors = FALSE)
chr.dir.source.control.scripts.chk <- "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/SourceControl"
df.control.chk <- data.frame(
  chr.dir.source.control.scripts = chr.dir.source.control.scripts.chk,
  chr.dir.hspf = paste0(chr.dir.source.control.scripts.chk, "/hspf"),
  chr.file.uci = "bigelkwq.uci",
  chr.file.sup = "bigelkwq.sup",
  chr.dir.sub.models = paste0(chr.dir.source.control.scripts.chk, "/sub-models"),
  chr.pat.model = "*Model\\.R",
  chr.pat.sub.model.input = "*\\.txt")


source.control(df.control = df.control.chk)

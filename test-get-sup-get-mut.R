## Source control scripts folder 
chr.dir.source.control.scripts <- 
  "M:/Models/Bacteria/HSPF/bacteria-sub-model-testing/SourceControl"

## hspf simulation folder
chr.dir.hspf <- paste0(chr.dir.source.control.scripts, "/hspf")

## hspf suplimental file name
chr.file.sup <- "bigelkwq.sup"

## sup and mut file data for PEST file name
chr.file.out <- "sup-mut.dat"

df.sup <- get.sup(paste0(chr.dir.hspf, "/", chr.file.sup))
chr.mut.list <- list.files(path = chr.dir.hspf, pattern = "\\.mut$")
df.mut <- get.mut(chr.mut.list)

df.sup.mut <- rbind(df.sup, df.mut)

paste0(sprintf("%-25s", df.sup.mut[, 1]),
       sprintf("%s", df.sup.mut[, 2]))

paste0("%-",max(nchar(df.sup.mut[, 1])),"s")

write.table(paste0(sprintf(paste0("%-",max(nchar(df.sup.mut[, 1])),"s"), 
                           df.sup.mut[, 1]), "  ",
                   sprintf("%s", df.sup.mut[, 2])), file = paste0(chr.dir.hspf, "/", chr.file.out),
            sep = " ", quote = FALSE, row.names = FALSE, col.names = FALSE)

#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2023 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################
pkgs <- c("xfun")
pacman::p_load(pkgs, character.only = TRUE)

gtf <- sapply(conf$data$gtf$link, function(x) {
      parse_file_link(x)
    })

gff3tobed_exon <- function (x, outfn, info_col = 10) {
  tmp_exon <- tempfile()
  tmp_exon2 <- tempfile()
  cmd <- sprintf("%s %s| awk '$3 == \"exon\"' | convert2bed -i gff - | cut -f 1,2,3,%s | sed 's/ID=.*gene_name=//g' | sed 's/Parent=.*gene_name=//g' | awk -F ';' '{print $1}' > %s && bedtools merge -i %s > %s; bedmap --echo --echo-map-id-uniq --delim '\t' %s %s > %s", 
    ifelse(file_ext(gtf[1]) == "gz", "zcat", "cat"),
    x, info_col, tmp_exon, tmp_exon, tmp_exon2,
    tmp_exon2, tmp_exon, outfn)
    print(cmd)
  system_safe(cmd)
}
gtftogff3 <- function (x, outfn) {
  tmp_gtf <- paste0(tempfile(), ".gtf")
  cmd <- sprintf("%s %s > %s; gffread -F --keep-exon-attrs -E %s -o %s",
    ifelse(file_ext(gtf[1]) == "gz", "zcat", "cat"), x, tmp_gtf,
    tmp_gtf, outfn)
  system_safe(cmd)
}

outdir <- sprintf("%s/output", dirname(opt$outputFilePrefix))
dir.create(outdir)

if ("gff3tobed_exon" %in% conf$extra$fun) {
  outfn_gff3tobed_exon <- sprintf("%s/gff3tobed_exon.bed.txt", outdir)
  gff3tobed_exon(gtf[1], outfn_gff3tobed_exon)
}
if (any(c("gtftogff3", "gtftobed_exon") %in% conf$extra$fun)) {
  outfn_gtftogff3 <- sprintf("%s/gtftogff3.gff3.txt", outdir)
  gtftogff3(gtf[1], outfn_gtftogff3)
}
if ("gtftobed_exon" %in% conf$extra$fun) {
  outfn_gtftobed_exon <- sprintf("%s/gtftobed_exon.bed.txt", outdir)
  gff3tobed_exon(outfn_gtftogff3, outfn_gtftobed_exon)
}

export_directory()

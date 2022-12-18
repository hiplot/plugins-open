#for (i in c("mmu", "hsa")) {
for (i in c("hsa")) {
  kegg_db <- clusterProfiler::download_KEGG(species = i)
  outfn <- sprintf("/cluster/apps/hiplot/userdata/public/db/kegg/%s_kegg_%s.rds",
    i, stringr::str_replace_all(Sys.Date(), "-", ""))
  saveRDS(kegg_db, outfn)
}

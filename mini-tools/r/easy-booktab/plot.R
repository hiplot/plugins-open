#######################################################
# easy-booktabs.                                      #
#-----------------------------------------------------#
# Author: Jianfeng Li                                 #
# Email: lee_jianfeng@openbiox.org                    #
#                                                     #
# Date: 2022-04-24                                    #
# Version: 0.1                                        #
#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  vars <- unlist(conf$dataArg[[1]][[1]]$value)
  by <- unlist(conf$dataArg[[1]][[2]]$value)
  set_flextable_defaults(font.family = conf$general$font,
    table.layout = "autofit")

  pr_section <- prop_section(
    page_size = page_size(
      width = conf$general$size$width/2.54,
                          height = conf$general$size$height/2.54),
      type = "continuous",
      page_margins = page_mar()
  )

  if (length(conf$extra$table_theme) > 0) {
    sapply(conf$extra$table_theme, function(x) {
      if (x == "") return("")
      if (str_detect(x, "gtsummary_journal")) {
        j <- str_remove(x, ".*journal_")
        x <- str_replace(x, "journal_.*", "journal")
        do.call(x, list(journal = j))
        return ("")
      }
    })
  }
}

############# Section 2 #############
#           plot section
#####################################
{
  params <- list(data = data,
      include = vars,
      by = by,
      missing_text = "NA")
  if (by == "") {
    params$by <- NULL
    conf$extra$add_p = FALSE
    conf$extra$add_overall = FALSE
  }
  p <- do.call(tbl_summary, params) %>%
      tbl_summary_style(add_p = conf$extra$add_p,
        add_overall = conf$extra$add_overall)

  p_flex <- p %>% as_flex_table()
  p_gt <- p %>% as_gt() %>% tab_options(table.font.size = px(6)) %>%
  opt_table_font(font = conf$general$font)
  p_gt_extra <- p %>% as_kable_extra(booktabs = TRUE, escape = TRUE, addtl_fmt = FALSE, keep_tex = TRUE) %>% kableExtra::kable_styling(font_size = 6)
}

############# Section 3 #############
#          output section
#####################################
{
  outprefix <- opt$outputFilePrefix
  #p_gt_extra %>% kableExtra::save_kable(file =paste0(outprefix, ".html"))
  #p_flex %>% save_as_html(path = paste0(outprefix, ".html"))
  p_gt %>% gt::gtsave(filename = paste0(outprefix, ".html"))
  if ("docx" %in% conf$general$imageExportType) {
    p_flex %>% save_as_docx(path = paste0(outprefix, ".docx"))
  }
  if ("pptx" %in% conf$general$imageExportType) {
    p_flex %>% save_as_pptx(path = paste0(outprefix, ".pptx"))
  }
  if (any(sapply(c("pdf", "png", "jpg", "tiff", "svg"),
    function(x) x %in% conf$general$imageExportType))) {
    html2pdf(paste0(outprefix, ".html"), paste0(outprefix, ".pdf"))
    pdfs2image(paste0(outprefix, ".pdf"))
  }
  keep_vars <- c(keep_vars, "p_gt", "p_flex", "p_gt_extra")
}


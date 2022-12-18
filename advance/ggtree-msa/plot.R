#######################################################
#                    CAUTION                          #
#-----------------------------------------------------#
# Copyright (C) 2022 by "National Center for          #
# Translational Medicine·Shanghai                     #
# All rights reserved.                                #
#######################################################

pkgs <- c("ggtree", "ggplotify", "ggplot2", "treeio")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 1 ##########################
# input options, data and configuration section
##################################################
{
  file_paths <- list()
  for (i in seq_len(length(conf$data))) {
    if (conf$data[[i]]$link != "") {
      file_paths[names(conf$data)[i]] <- parse_file_link(conf$data[[i]]$link)
    }
  }
  tree <- do.call(sprintf("read.%s", conf$extra$tree_read_func), list(file_paths[[1]]))
}

############# Section 2 #############
#           plot section
#####################################
{
  print(conf$extra$tree_offset)
  if (!conf$extra$circular) {
    f <- ggtree(tree) + geom_tiplab(size = conf$extra$tree_label_size,
      offset = conf$extra$tree_offset, align = conf$extra$align)
    p <- msaplot(f, file_paths[[2]], offset=conf$extra$msa_offset, width=conf$extra$msa_width)
  } else {
    f <- ggtree(tree, layout='circular') + 
      geom_tiplab(size = conf$extra$tree_label_size,
        offset = conf$extra$tree_offset, align=conf$extra$align) + xlim(NA, 12)
    p <- msaplot(f, file_paths[[2]], window=c(120, 200), offset=conf$extra$msa_offset, width=conf$extra$msa_width)
  }
  if (conf$general$palette != "default")
    p <- p + return_hiplot_palette_color(conf$general$palette,
        conf$general$paletteCustom) +
      return_hiplot_palette(conf$general$palette,
        conf$general$paletteCustom)

  p <- p + theme(text = element_text(
        family = conf$general$font
      ),
      legend.position = conf$general$legendPos,
      legend.direction = conf$general$legendDir,
      legend.title = element_text(
        size = conf$general$legendTitleSize
      ),
      legend.text = element_text(
        size = conf$general$legendTextSize
      )
    )
}


############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

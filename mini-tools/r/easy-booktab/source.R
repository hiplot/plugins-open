pkgs <- c("gtsummary", "kableExtra", "gt", "flextable", "officer")
pacman::p_load(pkgs, character.only = TRUE)

tbl_summary_style <- function (x, add_p = TRUE, add_overall = TRUE) {
  if (add_p) {
    x <- x %>% add_p()
  }
  if (add_overall) {
    x <- x %>% add_overall()
  }
  x %>% 
    modify_header(label = "**Variable**") %>%
    bold_labels()
}

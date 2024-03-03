pkgs <- c("survival", "rms", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 2 #############
#           plot section
#####################################
{
  keep_vars <- c(keep_vars, "cox_nomo")
  # Package data according to nomogram needs
  dd <<- datadist(data)
  options(datadist = "dd")

  # Build COX model and run nomogram
  cox_res <- psm(
    data = data,
    as.formula(paste(
      sprintf("Surv(%s, %s) ~ ", colnames(data)[1], colnames(data)[2]),
      paste(colnames(data)[3:length(colnames(data))],
        collapse = "+"
      )
    )),
    # Surv(time, status) ~ age + sex + ph.ecog + ph.karno + pat.karno,
    dist = "lognormal"
  )

  # Build survival probability function
  surv <- Survival(cox_res)
  # Calculate the probability of 1 year (365 days)
  # function(x) surv(365, x)

  # Build quantile survival time function
  med <- Quantile(cox_res)

  {
cox_nomo_demo<- nomogram(cox_res,
                          fun = list(
                            function(x) med(lp = x),
                            function(x) surv(365, x),
                            function(x) surv(1095, x),
                            function(x) surv(1825, x)
                          ),
                          funlabel = c(
                            "Median Survival Time",
                            "a",
                            "b",
                            "c"
                          ),
                          maxscale = 100
                          )
    ## 判断最优截断值，太小只保留头尾
  a=cox_nomo_demo$a$fat
  b=cox_nomo_demo$b$fat
  c=cox_nomo_demo$c$fat
  a=as.numeric(a)
  b=as.numeric(b)
  c=as.numeric(c)
  a=if((max(a)-min(a))>1){a}else{seq(min(a),max(a),by=0.2)}
  b=if((max(b)-min(b))>0.2){b}else{c(max(b),min(b))}
  c=if((max(c)-min(c))>0.2){c}else{c(max(c),min(c))}
}

cox_nomo <- nomogram(cox_res,
                     fun = list(
                       function(x) surv(365, x),
                       function(x) surv(1095, x),
                       function(x) surv(1825, x),
                       function(x) med(lp = x)
                     ),
                     funlabel = c(
                       "1-year Survival Probability",
                       "3-year Survival Probability",
                       "5-year Survival Probability",
                       "Median Survival Time"
                     ),
                     maxscale = 100
                     # maxscale setting the largest score, 10 or 100.
                     #fun.at = list(a,b,c)
                     # fun.at setting the ticks.
)
  # plot(cox_nomo)
  p <- function() {
    plot(cox_nomo,
      scale = 1
    )
    title(main = conf$general$title)
  }
}

############# Section 3 #############
#          output section
#####################################
{
  outfn <- paste0(opt$outputFilePrefix, ".pdf")
  cairo_pdf(outfn, 
    width = conf$general$size$width, height = conf$general$size$height,
    family = conf$general$font)
  p()
  dev.off()
  pdfs2image(outfn)
}

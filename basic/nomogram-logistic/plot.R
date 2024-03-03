pkgs <- c("rms", "ggplotify")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 2 #############
#           plot section
#####################################
{
  keep_vars <- c(keep_vars, "cox_nomo")
  # Package data according to nomogram needs
  dd <<- datadist(data)
  options(datadist = "dd")

  # Build Logistic model and run nomogram
  logistic_res <- lrm(data=data, as.formula(paste(
      colnames(data)[1], " ~ ",
      paste(colnames(data)[2:length(colnames(data))],
        collapse = "+"
      )
    ))
  )

  logistic_nomo <- nomogram(logistic_res, maxscale = 100,
    fun= function(x)1/(1+exp(-x)), lp=F, funlabel=conf$extra$funlabel,
    fun.at=c(.001,.01,.05,seq(.1,.9,by=.1),.95,.99,.999)
  )
  # plot(cox_nomo)
  p <- as.ggplot(function() {
    plot(logistic_nomo,
      scale = 1
    )
    title(main = conf$general$title)
  })
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

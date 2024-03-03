pkgs <- c("survival", "rms", "ggplotify", "patchwork")
pacman::p_load(pkgs, character.only = TRUE)

############# Section 2 #############
#           plot section
#####################################
{
  colnames(data)[1:2] <- c("time", "status")
  dd <- datadist(data)
  options(datadist = "dd")
  keep_vars <- c(keep_vars, "res.cal", "lrm.cal")
  if (conf$extra$model == "cox") {
    res.cox <- cph(as.formula(paste(
      "Surv(time, status) ~ ",
      paste(colnames(data)[3:length(colnames(data))], collapse = "+")
    )),
    data = data,
    surv = T,
    x = TRUE,
    y = TRUE,
    time.inc = conf$extra$time_day
    )

    ## 构建校正曲线
    ## calibrate函数适用于ols, lrm, cph or psm返回对象
    res.cal <- calibrate(res.cox,
      cmethod = conf$extra$cmethod,
      method = conf$extra$method,
      u = conf$extra$time_day,
      m = length(rownames(data)) / 6,
      B = length(rownames(data))
    )
    p <- as.ggplot(function() {
      plot(res.cal,
        lwd = 1,
        lty = 1,
        errbar.col = "blue",
        xlab = "Nomogram Predicted Survival",
        ylab = "Actual Survival",
        main = conf$general$title,
        col = "red"
      )
    })
  } else if (conf$extra$model == "lrm") {
    res.lrm <- lrm(as.formula(paste(
      "status ~ ",
      paste(colnames(data)[3:length(colnames(data))], collapse = "+")
    )),
    data = data,
    x = TRUE,
    y = TRUE
    )

    lrm.cal <- calibrate(res.lrm,
      method = conf$extra$method,
      B = length(rownames(data))
    )
    p <- as.ggplot(function() {
      plot(lrm.cal,
        xlab = "Nomogram Predicted Survival",
        ylab = "Actual Survival",
        main = conf$general$title
      )
    })
  }
}

############# Section 3 #############
#          output section
#####################################
{
  export_single(p)
}

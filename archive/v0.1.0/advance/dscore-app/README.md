# DscoreApp (v0.1)

A Shiny Web Application for computing the IAT D-score. 

This app is meant as an easy and open source alternative for computing the IAT 
D-score.


# Statement of need 

Despite the [Implicit Association Test (IAT)](https://en.wikipedia.org/wiki/Implicit-association_test) is commonly used for the implicit assessment of different constructs, ranging from racial prejudice to brand preferences, there is not an open source and easy-to-use application for the computation of its effect, the so-called *D-score*. DscoreApp is meant to fill this gap and to provide users with a free and easy to use Shiny Web application for the computation of the IAT *D-score*.

# Installation instructions

DscoreApp can be used both locally and online. 

To use DscoreApp locally, R and RStudio IDE have to be installed. The following R packages have to be installed as well: `shiny`, `shinjs`, `shinythemes`, and `ggplot2`. You can use the following code to install them: 

`install.packages(c("shiny", "shinyjs", "shinythemes", "ggplot2"))`

Once you have installed these packages, download the `DscoreApp.Rproj`, `ui.R` and `server.R` files. If you open either the `ui.R` or the `server.R` file, you will find the `Run App` command on the top right side of the R script. By clicking on the `Run App`, the app will start working on your computer, and it will automatically call for the abovementioned packages. If you want to use the example dataset locally on your computer, you have to download it (`raceAPP.csv` file), save it into a working directory, and change the working dircetory on LINE 23 in `server.R` file accordingly.


DscoreApp can be used online as well, without the need of installing anything locally. The suggested browser for using the app online is Google Chrome. The app is retriavable at the URL: http://fisppa.psy.unipd.it/DscoreApp/


# Example of usage

Either you decide to use DscoreApp locally or online, the dataset containing the IAT data can be easily uploaded by means of the `Browse` button. Data needs to be saved in a CSV format, with comma set as column separator. 

Once data have been updated, the drop-down menus for the IAT blocks labels are populated with the labels identifying the four blocks in the user's dataset. Once the labels have been specificied, the `Prepare data` button becomes active, and, after it has been clicked and the data are ready for the actual *D-score* computation, the `Data are ready` message is appearing right next the button. 

Once the data are ready, any *D-score* can be chosen from the drop-down menu, according to users' preferences. Different options for both the respondents' deletion and the graphical display of the results are available as well. The appearance of the app once the results are displyed and examples of the available graphical options are illustrated on the pdf of the paper in the app [GitHub repository](https://github.com/OttaviaE/DscoreApp).

For further information on the app functioning, please refer to the related paper retrivable at [![DOI](https://joss.theoj.org/papers/10.21105/joss.01764/status.svg)](https://doi.org/10.21105/joss.01764).


# Contributing to DscoreApp

If you want to contribute to this app, you can open a new branch on https://github.com/OttaviaE/DscoreApp, modify the code, and submit your pull request for added features. 

To report any bug or any issue related to the app functioning, you can open a new
issue on https://github.com/OttaviaE/DscoreApp/issues or send me an email at
otta.epifania@gmail.com.

If you need support or you seek help, just contact me at otta.epifania@gmail.com.

## Acknowledgments

O.M.E. wanted to thank Ben Keller for his suggestions and advice.   

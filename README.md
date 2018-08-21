Scenario-based Decision Support Tools with Shiny
================

This repository contains the code for the decision support tools presented in ["Promoting actionable science through the use of scenario-based interactive web tools"](). These tools are built in R using the Shiny package, which can create interactive web applications .

### Contents

Each tool is found in a subdirectory, which contain the following files:

-   `app.R` : R code containing the Shiny application.
-   `functions.R` : R code containing functions used by the Shiny app.
-   `sysdata.rda` and/or `data/` : An Rdata file and/or subdirectory containing data used by the Shiny app.

### Running the applications

#### Via URL

The decision tools for [planning the location of a new health facility](https://kokbent.shinyapps.io/intToolHF/) and for [designing a new road through a protected area](https://kokbent.shinyapps.io/intToolLULC/) can be accessed online through these individual links. These applications are freely hosted by [shinyapps.io](http://www.shinyapps.io/).

#### Via local R

Alternatively, these applications can be run locally (e.g., on your computer) using R and the `shiny` package by directly calling the code from this GitHub repository. This may be useful for applications that are computationally intensive and/or highly accessed, as the free servers from RStudio have limits on memory and active hours.

``` r
# Be sure you have the libraries used by the apps installed locally
install.packages(c("ggplot2", "shiny", "shinydashboard"))

# Run health facility app
shiny::runGitHub("decision-support-tools", "justinmillar", subdir = "health-facility")

# Run road route app
shiny::runGitHub("decision-support-tools", "justinmillar", subdir = "road-route")
```

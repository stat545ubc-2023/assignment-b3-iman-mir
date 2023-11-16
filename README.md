README
================

### Link to Shiny App

The following is a link to a running instance of the app:
<https://iman-mir.shinyapps.io/iman_mir_flow_rate_extremes_app/>

### Description of Shiny App

The app contains multiple features which displays the flow rates per
year at station 05BB001 in Alberta, Canada. The app has a slider which
allows for the user to determine the year range they want to analyze
data from, and this creates a histogram of the count of flow rates
during that time. There are two tabs, one for the histogram and the
other for the dataset in table format. Users can search up different
data values in this tab and pick the number of entries displayed.

### Source of Dataset

The flow_sample dataset from the datateachr package was used to create
the app, the package can be downloaded as shown:

install.packages(“devtools”)

devtools::install_github(“UBC-MDS/datateachr”)

### Repository Main Files

The repository contains: - README.md and README.rmd files describing the
repository - Iman Mir Flow Rate Extremes App which contains the app.R
and rsconnect files

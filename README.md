README
================

## Assignment B4 - Iman Mir Coffee Reccomendation App

For assignment b4 I have created a new app.

### Link to Shiny App

The following is a link to a running instance of the app:
<https://iman-mir.shinyapps.io/iman_mir_flow_rate_extremes_app/>

### Description of Shiny App

The app contains multiple features to allow a user to determine the best
coffee for them based on the coffee dataset.The app will suggest the
highly recommended coffee and roaster location for the user, however the
user can still look at the graphs and tables to see other options if
they would like to. The user first chooses their country, their desired
roast type and their price range. After clicking submit, on the coffee
name recommendation tab the user will see the name(s) of their
recommended coffee name based on the highest rating. There is also a
graph which shows a visual of different coffees within the price range
they chose, as well as a table with the corresponding information. The
next tab shows the most highly recommended roaster of where they can buy
different coffees from. There is also a corresponding table as well. The
last tab is the customer reviews tab with a table with reviews for
different coffees based on the preferences they chose.

### Source of Dataset

The coffee_data dataset can be downloaded from the follwoing link:
<https://www.kaggle.com/datasets/schmoyote/coffee-reviews-dataset/data?select=simplified_coffee.csv/>

### Repository Main Files

The repository contains:

- README.md and README.rmd files describing the repository

- Iman Mir Coffee Recommendations App which contains the app.R and
  rsconnect files

## Assignment B3 - Iman Mir Flow Rates Extremes App

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

The repository contains:

- README.md and README.rmd files describing the repository

- Iman Mir Flow Rate Extremes App which contains the app.R and rsconnect
  files

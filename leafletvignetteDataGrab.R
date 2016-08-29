##the packages we need to grab the map data
library(rgdal)
library(sp)

##the packages we need to grab the macroeconomic data
devtools::install_github("regisely/macrodata")
library(devtools)
library(macrodata)
library(Quandl)

##where to find the world map
## "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"

## Create spatial data frame
## Have a look at this in the global environment after it is loaded
## it contains the shape file, and population and gdp data, amongst other things
world <-readOGR(".", "ne_50m_admin_0_countries", verbose = FALSE)

### Quandl key from quandl.com
## Quandl is a source of world macroeconomic data and is free
##in this case we will pull in world bank data
##but we're not going to do it directly, we're going to use the package called "macrodata" to do so. why? 
##Quandl does not allow a user to pull in download multiple data sets on multiple countries with one command
Quandl.api_key("iz-ThHX9dpWweuxYW43a")

##get econ data for all countries
##serachQ is part of the macrodata package
##see here for more info: http://regisely.com/blog/macrodata/
  
econIndicators <- searchQ("gdp per capita exchange rate population growth consumer price index real interest rate labor force", country = "Brazil", frequency = "annual", 
                         database = "WWDI")

##select out the time series we want
##note: this takes quite a while - 5 to 10 minutes
##Why? we are downloading 7 data sets, from 1960 to 2015, on every country in the world
econData <- requestQ(econIndicators, c(17, 3, 1, 10, 19, 6, 5))

##Usually the names we give to list objects are a convenience
##here it is crucial because we are going to refer to these names in our flexdashboard
##the names will be the inputs to be selected by the user; they have to match exactly
names(econData) <- c("GDP Per Capita", "GDP Per Capita Growth", "Real Interest Rate", 
                     "Exchange Rate", "CPI", "Labor Force Part. Rate", "Female Labor Part.")



### Save
save(world, econData, file = 'sourceData.RDat')

devtools::install_github("regisely/macrodata")
library(devtools)
library(macrodata)
library(Quandl)
library(rgdal)
library(sp)
##library(readr)
library(DT)
library(data.table)

##where to find the world map
## "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"

### Create spatial vector object
world <-readOGR(".", "ne_50m_admin_0_countries", verbose = FALSE)

### Quandl key from quandl.com
## Quandl is a source of world macroeconomic data and is free
##in this case we will pull in world bank data
Quandl.api_key("iz-ThHX9dpWweuxYW43a")

##get econ data for all countries
##serachQ is part of the macrodata package
##see here for more info: http://regisely.com/blog/macrodata/
  
econIndicators <- searchQ("gdp per capita exchange rate population growth consumer price index real interest rate labor force", country = "Brazil", frequency = "annual", 
                         database = "WWDI")

##select out the time series we want
##note: this takes quite a while - 5 to 10 minutes
econData <- requestQ(econIndicators, c(17, 3, 1, 10, 19, 6, 5))
names(econData) <- c("GDP Per Capita", "GDP Per Capita Growth", "Real Interest Rate", 
                     "Exchange Rate", "CPI", "Labor Force Part. Rate", "Labor Female")


### Save
save(world, econData, file = 'sourceData.RDat')

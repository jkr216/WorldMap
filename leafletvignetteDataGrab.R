devtools::install_github("regisely/macrodata")
library(devtools)
library(macrodata)
library(Quandl)
library(rgdal)
library(countrycode)
library(sp)
library(readr)


load('sourceData.RDat')

##where to find the world map
## "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"


### Create spatial vector object
world <-readOGR(".", "ne_50m_admin_0_countries", verbose = FALSE)

### Quandl key from quandl.com
## Quandl is a source of world macroeconomic data and is free
##in this case we will pull in world bank data
Quandl.api_key("iz-ThHX9dpWweuxYW43a")

##get GDP per capita data for all countries
##serachQ is part of the macrodata package
##see here for more info: http://regisely.com/blog/macrodata/

searchWWDIall <- searchQ("gdp per capita", country = "Brazil", frequency = "annual", 
                         database = "WWDI", view = FALSE)

searchWWDIall2 <- searchQ("exchange rate population growth consumer price index real interest rate", country = "Brazil", frequency = "annual", 
                         database = "WWDI")

dataWWDIall<- requestQ(searchWWDIall, c(5,6))

dataWWDIall2<- requestQ(searchWWDIall2, c(1,4,8,13,15))

names(dataWWDIall) <- c("GDP/CapitaGrowth", "GDP/Capita")

names(dataWWDIall2) <- c("RealInterestRate", "ExchangeRate", "CPI", "FemaleLaborPartRate", "TotalLaborPartRate")


##split up the data into new objects, might not be necessary?
WorldGDPPerCapita <- dataWWDIall2$`GDP/Capita`
WorldGDPPerCapitaGrowth <- dataWWDIall$`GDP/CapitaGrowth`


WorldRealInterestRate <- dataWWDIall2$`RealInterestRate`
WorldExchangeRate <- dataWWDIall2$`ExchangeRate`
WorldCPI <- dataWWDIall2$`CPI`
WorldFemaleLaborPartRate <- dataWWDIall2$`FemaleLaborPartRate`
WorldTotalLaborPartRate <- dataWWDIall2$`TotalLaborPartRate`

### Save
save(world, WorldGDPPerCapita, WorldGDPPerCapitaGrowth, dataWWDIall, dataWWDIall2, WorldRealInterestRate, 
     WorldExchangeRate, WorldCPI, WorldFemaleLaborPartRate,
     WorldTotalLaborPartRate, counties, ga_counties_DF, file = 'sourceData.RDat')

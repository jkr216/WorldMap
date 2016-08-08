devtools::install_github("regisely/macrodata")
library(devtools)
library(macrodata)
library(Quandl)
library(rgdal)
library(countrycode)
library(sp)
library(readr)

##set wd
setwd("~/sol-eng-sales/JKR_Data")

load('~/sourceData.RDat')

### Inputs
Quandl.api_key("iz-ThHX9dpWweuxYW43a")
url <- "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"
tmpdir <- tempdir() # destination for download data
filenam <- basename(url)

### Download and unzip OGR data source
file <- file.path(tmpdir, filenam)
download.file(url, file)
unzip(file, exdir = tmpdir)

### Create spatial vector object
countries <- readOGR(
  dsn = tmpdir, 
  layer = sub("^([^.]*).*", "\\1", filenam),
  encoding = "UTF-8",
  verbose = FALSE
)

##get GA state map data in spatial data frame form. source: us census
counties <- readOGR(".", "cb_2015_us_county_20m", verbose = FALSE)

world <-readOGR(".", "ne_50m_admin_0_countries", verbose = FALSE)

world$admin

##get GA popultation by county
ga_counties_data <- read_csv("GA-Counties-Data.csv")
ga_counties_DF <- as.data.frame(ga_counties_data)
colnames(ga_counties_DF) = ga_counties_DF[1, ]
ga_counties_DF = ga_counties_DF[-1, ]

##get GDP per capita data for all countries
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
save(countries, WorldGDPPerCapita, WorldGDPPerCapitaGrowth, dataWWDIall, dataWWDIall2, WorldRealInterestRate, 
     WorldExchangeRate, WorldCPI, WorldFemaleLaborPartRate,
     WorldTotalLaborPartRate, counties, ga_counties_DF, file = 'sourceData.RDat')

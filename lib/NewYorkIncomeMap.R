library(rgdal)    # for readOGR and others
library(sp)       # for spatial objects
library(leaflet)  # for interactive maps (NOT leafletR here)
library(dplyr)    # for working with data frames
library(ggplot2)  # for plotting
library(acs)
library(tigris)
library(stringr)

#create a sp objective of NY....
tracts=tracts(state="NY",county = c(5, 47, 61, 81, 85), cb=TRUE)

#plot(tract1)
api.key.install(key="8bd87e9d054de037fbf2a58c335393c3de1232a6")

geo<-geo.make(state=c("NY"),
              county=c(5, 47, 61, 81, 85), tract="*")


income<-acs.fetch(endyear = 2012, span = 5, geography = geo,
                  table.number = "B19001", col.names = "pretty")

names(attributes(income))
attr(income, "acs.colnames")
income_df1 <- data.frame(paste0(str_pad(income@geography$state, 2, "left", pad="0"), 
                               str_pad(income@geography$county, 3, "left", pad="0"), 
                               str_pad(income@geography$tract, 6, "left", pad="0")), 
                        income@estimate[,c("Household Income: Total:",
                                           "Household Income: $200,000 or more")], 
                        stringsAsFactors = FALSE)


income_df1=cbind()


income_df1 <- select(income_df1, 1:4)
rownames(income_df1)<-1:nrow(income_df1)
names(income_df1)<-c("Census Name","GEOID", "total", "over_200")
income_df1$percent <- 100*(income_df1$over_200/income_df1$total)

income_merged1<- geo_join(tracts, income_df1, "GEOID", "GEOID")
# there are some tracts with no land that we should exclude
income_merged1 <- income_merged1[income_merged1$ALAND>0,]



popup <- paste0("Census: ", income_merged1$Census.Name, "<br>", "Percent of Households above $200k: ", round(income_merged$percent,2))
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = income_merged1$percent
)

map3<-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = income_merged1, 
              fillColor = ~pal(percent), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = income_merged1$percent, 
            position = "bottomright", 
            title = "Percent of Households<br>above $200k",
            labFormat = labelFormat(suffix = "%")) 

map3




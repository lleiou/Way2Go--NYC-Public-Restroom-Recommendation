library(maps)
library(data.table)
library(leaflet)
library(htmltools)
data<-fread("NYCT.csv")
content<-colbind(data$Name,data$Location)
leaflet(data) %>%
  #sets the center of the map view and the zoom level;
  setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
  addTiles() %>%
  addMarkers(popup = ~htmlEscape(Location))#show location when click



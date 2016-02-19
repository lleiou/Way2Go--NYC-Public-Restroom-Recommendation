library(maps)
library(data.table)
library(leaflet)
library(htmltools)
library(sp)
library(rgeos)
tdata<-fread("NYCT.csv")
tmap<-leaflet(tdata) %>%
  #sets the center of the map view and the zoom level;
  setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
  addTiles() %>%
  addMarkers(popup = ~htmlEscape(Location))#show location when click
tmap

wifidata<-fread("nycwifi.csv")
wifimap<-leaflet(wifidata) %>%
  #sets the center of the map view and the zoom level;
  setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
  addTiles() %>% 
  addMarkers(lng = ~ Long_, lat = ~ Lat,popup = ~htmlEscape(Location), clusterOptions = markerClusterOptions())
wifimap

map<-leaflet()%>%
  setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
  addTiles() %>% 
  addMarkers(data =tdata, group = "Restrooms",popup = ~htmlEscape(Location)) %>%
  addMarkers(data = wifidata, group = "Wi-Fi",lng = ~ Long_, lat = ~ Lat,
             popup = ~htmlEscape(Location), clusterOptions = markerClusterOptions())%>%
  # Layers control
    addLayersControl(
    overlayGroups = c("Restrooms", "Wi-Fi"),
  
    options = layersControlOptions(collapsed = FALSE)
    )%>%
  
  
  addCircleMarkers(lng=-73.96884112664793,lat =40.78983730268673, color="purple",weight = 2,radius = 35)
map

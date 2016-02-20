library(maps)
library(data.table)
library(leaflet)
library(htmltools)

tdata<-fread("NYCT.csv")
wifidata<-fread("nycwifi.csv")



name <-tdata$Name
location <- tdata$Location

#separate the location name(bold) and the address(italic) into two lines
name <- paste("<b>",name,"</b>")
location <- paste("<i>",location,"</i>")
content <- paste( name, location, sep =  "<br/>")

#set parameters for the icon
#the iconAnchor is used for setting the position of the tag when you click on the toilet botton.
ToiletIcon <- makeIcon(
  iconUrl = "http://icons.iconarchive.com/icons/icons8/ios7/512/Household-Toilet-Pan-icon.png",
  iconWidth = 20, iconHeight = 25,
  iconAnchorX = 10, iconAnchorY = 0
)

map<-leaflet()%>%
  setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
  addTiles() %>% 
  addMarkers(data =tdata, group = "Restrooms",popup = content, icon=ToiletIcon) %>%
  addMarkers(data = wifidata, group = "Wi-Fi",lng = ~ Long_, lat = ~ Lat,
             popup = ~htmlEscape(Location), clusterOptions = markerClusterOptions())%>%
  # Layers control
    addLayersControl(
    overlayGroups = c("Restrooms", "Wi-Fi"),
  
    options = layersControlOptions(collapsed = FALSE)
    )
  
map

#This file shows all the data
library(leaflet)

data <-read.csv("NYCT.csv")
name <-data$Name
location <- data$Location

#separate the location name(bold) and the address(italic) into two lines
name <- paste("<b>",name,"</b>")
location <- paste("<i>",location,"</i>")
content <- paste( name, location, sep =  "<br/>")

#set parameters for the icon
#the iconAnchor is used for setting the position of the tag when you click on the toilet botton.
ToiletIcon <- makeIcon(
  iconUrl = "http://icons.iconarchive.com/icons/icons8/ios7/512/Household-Toilet-Pan-icon.png",
  iconWidth = 20, iconHeight = 25,
  iconAnchorX = 10, iconAnchorY = 0,
)

#Draw the map, show the location of all the toilets in NYC, w/ popup tag
leaflet(data) %>% 
              addTiles() %>%
              setView(lng = -74.0, lat = 40.71, zoom = 10) %>% 
              addMarkers(~Lon, ~Lat, popup = content, icon=ToiletIcon)

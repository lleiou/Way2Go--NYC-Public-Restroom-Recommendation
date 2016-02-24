library(maps)
library(data.table)
library(dplyr)
library(leaflet)
library(htmltools)

tdata<-read.csv("NYCT_NEW.csv")
wifidata<-read.csv("nycwifi.csv")
#fdata<-read.csv("NYC_fac.csv")

##restrooms popup
name <-tdata$Name
location <- tdata$Location
handicap<-tdata$Handicap
#separate the location name(bold) and the address(italic) into two lines
name <- paste("<b>",name,"</b>")
location <- paste("<i>",location,"</i>")
handicap <- paste("<i>","handicap:",handicap,"</i>")
content <- paste( name,location,handicap, sep =  "<br/>")

##facilities popup
facname <-fdata$FacName
facaddress<- fdata$FacAddress
ft_decode<-fdata$FT_Decode
#separate the location name(bold) and the address(italic) into two lines
facname <- paste("<b>",facname,"</b>")
facaddress <- paste("<i>",facaddress,"</i>")
ft_decode <- paste("<i>",ft_decode,"</i>")
fcontent <- paste( facname,facaddress,ft_decode, sep =  "<br/>")









#set parameters for the iconn
#the iconAnchor is used for setting the position of the tag when you click on the toilet botton.
ToiletIcon <- makeIcon(
  iconUrl = "http://icons.iconarchive.com/icons/icons8/ios7/512/Household-Toilet-Pan-icon.png",
  iconWidth = 20, iconHeight = 25,
  iconAnchorX = 10, iconAnchorY = 0
)

map<-leaflet()%>%
  setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=13) %>% 
  addTiles() %>% 
  addMarkers(data =tdata, group = "Restrooms",popup = content, icon=ToiletIcon) %>%
  addMarkers(data = wifidata, group = "Wi-Fi",lng = ~ Long_, lat = ~ Lat,
             popup = ~htmlEscape(Location), clusterOptions = markerClusterOptions())%>%
  #addMarkers(data =data, group = "Facilities",popup = fcontent) %>%
  # Layers control
    addLayersControl(
    overlayGroups = c("Restrooms", "Wi-Fi"),
  
    options = layersControlOptions(collapsed = FALSE)
    )
  
map

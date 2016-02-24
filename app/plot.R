SalesPop <- read.csv("SalesPop.csv")
library(plotly)
plot_1 <- plot_ly(x = as.character(SalesPop$zipcode), y=SalesPop$NumberofRestrooms, type = "bar", color = SalesPop$borough)


SalesAve <- data.frame(borough=c("Manhattan","Bronx","Queens","Brooklyn","Staten Island"),mean=c(mean(subset(SalesPop,borough == "Manhattan")[,5]),mean(subset(SalesPop,borough == "Bronx")[,5]),mean(subset(SalesPop,borough == "Queens")[,5]), mean(subset(SalesPop,borough == "Brooklyn")[,5]),mean(subset(SalesPop,borough == "Staten Island")[,5])))

plot_2 <- plot_ly(x = SalesAve$borough, y=SalesAve$mean, type = "bar", color = SalesAve$borough)


plot_3 <- plot_ly(x = subset(SalesPop,borough == "Manhattan")$zipcode, y=subset(SalesPop,borough == "Manhattan")$NumberofRestrooms, opacity = 0.6,mode = "markers",xlim=c(0,5)) %>%
  add_trace(x = subset(SalesPop,borough == "Bronx")[,2],y=subset(SalesPop,borough == "Bronx")[,5]) %>%
  add_trace(x = subset(SalesPop,borough == "Queens")[,2],y=subset(SalesPop,borough == "Queens")[,5]) %>%
  add_trace(x = subset(SalesPop,borough == "Brooklyn")[,2],y=subset(SalesPop,borough == "Brooklyn")[,5]) %>%
  add_trace(x = subset(SalesPop,borough == "Staten Island")[,2],y=subset(SalesPop,borough == "Staten Island")[,5]) %>%
  layout(barmode="overlay")

plot_4 <- plot_ly(x = subset(SalesPop,borough == "Manhattan")[,2], y=subset(SalesPop,borough == "Manhattan")[,5]/subset(SalesPop,borough == "Manhattan")[,4], opacity = 0.6, mode = "markers",xlim=c(0,5)) %>%
  add_trace(x = subset(SalesPop,borough == "Bronx")[,2],y=subset(SalesPop,borough == "Bronx")[,5]/subset(SalesPop,borough == "Bronx")[,4]) %>%
  add_trace(x = subset(SalesPop,borough == "Queens")[,2],y=subset(SalesPop,borough == "Queens")[,5]/subset(SalesPop,borough == "Queens")[,4]) %>%
  add_trace(x = subset(SalesPop,borough == "Brooklyn")[,2],y=subset(SalesPop,borough == "Brooklyn")[,5]/subset(SalesPop,borough == "Brooklyn")[,4]) %>%
  add_trace(x = subset(SalesPop,borough == "Staten Island")[,2],y=subset(SalesPop,borough == "Staten Island")[,5]/subset(SalesPop,borough == "Staten Island")[,4]) %>%
  layout(barmode="overlay")

plot_5 <- plot_ly(x = SalesPop$sales , y = SalesPop$population,  plot_bgcolor="blue", size =SalesPop$NumberofRestrooms/SalesPop$population  , color=SalesPop$borough, mode = "markers")
  plot5 <- plot_ly(x = SalesPop$sales , y = SalesPop$population,  plot_bgcolor="blue", size =SalesPop$NumberofRestrooms, color=SalesPop$borough, mode = "markers")

plot_6 <- plot_ly(x = SalesPop$sales , y = SalesPop$population,  plot_bgcolor="blue", size =SalesPop$NumberofRestrooms, color=SalesPop$borough, mode = "markers")

library(rgdal)    # for readOGR and others
library(sp)       # for spatial objects
library(leaflet)  # for interactive maps (NOT leafletR here)
library(dplyr)    # for working with data frames
library(ggplot2)  # for plotting
library(acs)
library(tigris)
library(stringr)
library(rjson)
#library(data.table)

#create a sp objective of NY....
tracts=tracts(state="NY",county = c(5, 47, 61, 81, 85), cb=TRUE)

#plot(tract1)
api.key.install(key="25bc689c95eb102e46a2a0cedbe4ab2450e033f5")

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


income_df1=cbind(Census.Name=rownames(income_df1),income_df1)


income_df1 <- select(income_df1, 1:4)
rownames(income_df1)<-1:nrow(income_df1)
names(income_df1)<-c("Census Name","GEOID", "total", "over_200")
income_df1$percent <- 100*(income_df1$over_200/income_df1$total)

income_merged1<- geo_join(tracts, income_df1, "GEOID", "GEOID")
# there are some tracts with no land that we should exclude
income_merged1 <- income_merged1[income_merged1$ALAND>0,]



popup <- paste0("Census: ", income_merged1$Census.Name, "<br>", "Percent of Households above $200k: ", round(income_merged1$percent,2))
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



# example:  
# current=getCurrentPosision()
#current$city   ==>will return "New York"
#after type in $, it will pop up list element like long lat, zipcode
#notice this method only gives rough position with IP address 
#

library(rjson)
url="http://freegeoip.net/json/"

getCurrentPosition=function(){
  address <- fromJSON(file=url, method='C')
  #address
  return(address)
  
}

#this part requires R-pacakge choroplethrzip, to install the package,type in 
#following lines:
#install.packages("devtools")
#library(devtools)
#install_github('arilamstein/choroplethrZip@v1.4.0')



# New York City is comprised of 5 counties: Bronx, Kings (Brooklyn), New York (Manhattan), 
# Queens, Richmond (Staten Island). Their numeric FIPS codes are:
library(choroplethr)
library(choroplethrZip)
library(data.table)
library(devtools)
library(dplyr)
library(ggplot2)

#the input data frame must only have two columns:region(zip code) and value
nyc_fc=data.frame(fread("fac_num1.csv"))
nyc_pop=data.frame(fread("NYC_pop.csv"))
nyc_hos=data.frame(fread("house.csv"))


nyc_pop=nyc_pop[2:3]
colnames(nyc_pop)=c("region","value")
nyc_pop$region=as.character(nyc_pop$region)

#every region must only appear once
grouped=nyc_fc %>%
  group_by(region) %>%
  summarise(value=sum(value))
data.frame(grouped)

head(nyc_hos)
nyc_hos=nyc_hos[4:5]
colnames(nyc_hos)=c("region","value")
nyc_hos$region=as.character(nyc_hos$region)

grouped1=nyc_hos %>%
  group_by(region) %>%
  summarise(value=mean(value))
data.frame(grouped1)


#grouped_rm<-grouped[!(grouped$region==10129|grouped$region==10281|grouped$region==10430|grouped$region==11249|grouped$region==11352
#                      |grouped$region==11695
#                      |grouped$region==13564)]


#remove the zip code area that not defined in the function
grouped_rm=subset(grouped,region!=10129
                  &region!=10281
                  &region!=10430
                  &region!=11249
                  &region!=11352
                  &region!=11695
                  &region!=13564)

group1_rm=subset(grouped1,region!=10129
                 &region!=10281
                 &region!=10430
                 &region!=11249
                 &region!=11352
                 &region!=11695
                 &region!=13564)

#data.frame(grouped_rm)
#toString(grouped_rm$region)

#the column region must be character
grouped_rm$region=as.character(grouped_rm$region)

#select the nyc county
nyc_fips = c(36005, 36047, 36061, 36081, 36085)


# #this is the map fucntion 
# map1=zip_choropleth(grouped_rm,
#                county_zoom=nyc_fips,
#                title="New York City Facilities with Restroom",
#                legend="Num of Facility",
#                num_colors=3,
#                reference_map=FALSE
#                )
#belowed is another method to mapp
map2=ZipChoropleth$new(grouped_rm)
map2$title="New York City Facilities with Restroom"
map2$ggplot_scale = scale_fill_brewer(name="Num of facility", palette=8, drop=FALSE)
map2$set_zoom_zip(state_zoom=NULL, county_zoom=nyc_fips, msa_zoom=NULL, zip_zoom=NULL)
map1<-map2$render()
map1

map_pop=ZipChoropleth$new(nyc_pop)
map_pop$title="New York Population"
map_pop$ggplot_scale = scale_fill_brewer(name="population", palette=8, drop=FALSE)
map_pop$set_zoom_zip(state_zoom=NULL, county_zoom=nyc_fips, msa_zoom=NULL, zip_zoom=NULL)

map_pop=map_pop$render()
map_pop

map_hos=ZipChoropleth$new(group1_rm)
map_hos$title="Manhattan House Price"
map_hos$ggplot_scale = scale_fill_brewer(name="house price", palette=8, drop=FALSE)
map_hos$set_zoom_zip(state_zoom=NULL, county_zoom=nyc_fips, msa_zoom=NULL, zip_zoom=NULL)

map_hos=map_hos$render()


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
# facname <-fdata$FacName
# facaddress<- fdata$FacAddress
# ft_decode<-fdata$FT_Decode
#separate the location name(bold) and the address(italic) into two lines
# facname <- paste("<b>",facname,"</b>")
# facaddress <- paste("<i>",facaddress,"</i>")
# ft_decode <- paste("<i>",ft_decode,"</i>")
# fcontent <- paste( facname,facaddress,ft_decode, sep =  "<br/>")









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






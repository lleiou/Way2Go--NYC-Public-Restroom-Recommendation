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
library(dplyr)
library(ggplot2)

#the input data frame must only have two columns:region(zip code) and value
nyc_fc=data.frame(fread("..//data//fac_num1.csv"))


#every region must only appear once
grouped=nyc_fc %>%
  group_by(region) %>%
  summarise(value=sum(value))
data.frame(grouped)

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

#data.frame(grouped_rm)
#toString(grouped_rm$region)

#the column region must be character
grouped_rm$region=as.character(grouped_rm$region)

#select the nyc county
nyc_fips = c(36005, 36047, 36061, 36081, 36085)


#this is the map fucntion 
map1=zip_choropleth(grouped_rm,
               county_zoom=nyc_fips,
               title="New York City Facilities with Restroom",
               legend="Num of Facility",
               num_colors=3,
               reference_map=FALSE
               )
# #belowed is another method to map
# map1=ZipChoropleth$new(grouped_rm)
# map1$title="New York City Facilities with Restroom"
# map1$ggplot_scale = scale_fill_brewer(name="Num of facility", palette=8, drop=FALSE)
# map1$set_zoom_zip(state_zoom=NULL, county_zoom=nyc_fips, msa_zoom=NULL, zip_zoom=NULL)
# map1$render()




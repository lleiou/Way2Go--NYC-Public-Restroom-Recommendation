# solving problems with street2coordinates
library(bitops)
library(RCurl)
library(plyr)
library(rjson)
library(RDSTK)
data_test<-c("3260 Henry Hudson Parkway, Bronx, NY 10463")
geocode<- do.call(rbind, lapply(data_test, street2coordinates))
geocode


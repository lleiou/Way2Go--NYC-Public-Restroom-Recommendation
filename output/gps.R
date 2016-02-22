# example:  
# current=getCurrentPosision()
#current$city   ==>will return "New York"
#after type in $, it will pop up list element like long lat, zipcode
#notice this method only gives rough position with IP address 
#

library(rjson)
  url="http://freegeoip.net/json/"
  
  getCurrentPoistion=function(){
  address <- fromJSON(file=url, method='C')
  #address
  return(address)

}

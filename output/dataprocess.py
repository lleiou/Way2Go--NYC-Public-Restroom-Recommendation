import csv
import string 

from geopy.geocoders import Nominatim
geolocator = Nominatim()

with open("../data/NYCT.csv") as csvfile:
	spamreader = csv.reader(csvfile,skipinitialspace=True)
	for row in spamreader:
		#print type(row[2])
		#addr= row[1][1:len(row[1])-1]+","+row[5][1:len(row[5])-1] 
		addr=row[1]+","+row[5]	
		loc=geolocator.geocode(addr)
		if loc is None:
			print "fail"
		else:
			print(loc.latitude,loc.longitude)
		#if(loc)
		#	print loc.latitude
		#else
		#	print "fail"
		#print (addr,loc.latitude)
		#print(type(loc))
		#print(loc.address)
		#print(loc.latitude,type(loc.latitude))	
		




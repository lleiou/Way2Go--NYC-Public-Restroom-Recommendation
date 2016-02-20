import csv
import string 
import unicodedata
import geocoder
import urllib3


from geopy.geocoders import Nominatim

#urllib3.disable_warnings()
#logging.captureWarnings(True)
geolocator = Nominatim()

with open("../data/NYCT.csv") as csvfile:
	spamreader = csv.reader(csvfile,skipinitialspace=True)
	header=next(spamreader)
	for row in spamreader:
		#print type(row[2])
		#addr= row[1][1:len(row[1])-1]+","+row[5][1:len(row[5])-1] 
		#addr=row[1]+","+row[5]	
		#loc=geolocator.geocode(addr)
		#if loc is None:
		#	print "fail"
		#else:
			#print(loc.latitude,loc.longitude,row[6],type(row[6]))
		point=row[6][0:len(row[6])-1]+","+row[7][0:len(row[7])-1]
		#print point
		loc1=geolocator.reverse(point)
		addr_str=unicodedata.normalize('NFKD',loc1.address).encode('ascii','ignore')
		if "New York" not in addr_str:			
			addr= row[1][0:len(row[1])]+","+row[5][0:len(row[5])] 				
			#print addr
			loc=geolocator.geocode(addr)
			if loc is not None:
				print ("SUCCED")
				#print loc.address +"," +"SUCCESSED"
			else:
				if "(" in addr:
					new_addr=row[1][0:row[1].index("(")-1]+","+row[5][0:len(row[5])]
					loc2=geolocator.geocode(new_addr)
					if loc2 is not None:
						print(loc2.latitude,loc2.longitude)
					else:
						newer_addr=geocoder.google(new_addr)
						if newer_addr is not None:
							print (newer_addr.latlng)
						else:
							print (new_addr+"----"+addr+"---------"+ row[2]+","+"NEW ADDRESS FAILED")
				else:		
					newer1_addr=geocoder.google(addr)
					if newer1_addr is not None:
						print (newer1_addr.latlng)
					else:	
						print (addr+"---------"+ row[2]+","+"NEW ADDRESS FAILED")
		else:
			print ("CORRECT")
			#print addr_str+","+"NEW YORK"
		
	#	print point+","+loc1.address
		
		#print(type(loc1.address))

		#print loc1.address
		#if(loc)
		#	print loc.latitude
		#else
		#	print "fail"
		#print (addr,loc.latitude)
		#print(type(loc))
		#print(loc.address)
		#print(loc.latitude,type(loc.latitude))	
		




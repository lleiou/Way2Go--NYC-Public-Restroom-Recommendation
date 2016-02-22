import csv

import string

import unicodedata

import geocoder

import urllib3

import requests

requests.packages.urllib3.disable_warnings()
from geopy.geocoders import Nominatim





def getzip(lat,lon):

        geolocator=Nominatim()

        loc=str(lat)+","+str(lon)

        #print(loc)

        current=geolocator.reverse(loc)

        zip=(current.raw.get("address")).get("postcode")

        #print(zip)

        return zip

#def main():
#	print getzip(40.748871,-73.985428)

#main()


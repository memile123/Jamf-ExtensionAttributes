#!/bin/sh

myLocationInfo=`curl -L -s --max-time 10 http://ip-api.com/csv/?fields=country,city,region,lat,lon,/`

echo "<result>$myLocationInfo</result>"


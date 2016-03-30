#!/bin/bash

## JH: v1.0 - Weather Underground to pwsweather.com script test

WORKINGDIR=/home/ABC123

# Wunderground API key
# Register for a free Stratus plan here: https://www.wunderground.com/weather/api
WUAPI={your weather underground API key - no braces}

# Wunderground PWS to pull weather from
# Navigate to your preferred weather station on Weather Underground and pull the pws:XXXXXXXXXX from the URL
# ex. https://www.wunderground.com/cgi-bin/findweather/getForecast?query=pws:KFLLAKEW61&MR=1
# ex. WUPWS would be the query value - "pws:KFLLAKEW61"
#WUPWS="pws:KFLLAKEW53"
WUPWS={"your weather underground station identifier - no braces - yes quotes"}

#PWS station ID - sign up and create a station at pwsweather.com
PWSID={your pwsweather.com station ID}

#PWS password - password for pwsweather.com
PWSPASS={your pwsweather.com password}

#============================================================
#=
#=      NOT NECESSARY TO CHANGE ANY LINES BELOW
#=
#============================================================

# Construct & Execute Weather Underground API call
WUJSON=http://api.wunderground.com/api/$WUAPI/conditions/q/$WUPWS\.json
echo "Grabbing JSON using the following URL: $WUJSON"
echo ""
wget -O $WORKINGDIR/wu.json $WUJSON

# ALL json extractions below REQUIRE the jq cmd line tool - on Ubuntu 'apt-get install jq'
#
# extract observation time and convert to UTC
# jq .current_observation.observation_epoch wu.json |tr -d '"'
# TZ=UTC date -d @1459187921 +'%Y-%m-%d+%H:%M:%S'|sed 's/:/%3A/g'
PWSDATEUTC=$(TZ=UTC date -d @$(jq .current_observation.observation_epoch $WORKINGDIR/wu.json |tr -d '"') +'%Y-%m-%d+%H:%M:%S'|sed 's/:/%3A/g')
echo "PWSDATEUTC=$PWSDATEUTC"

# extract winddir
PWSWINDDIR=$(jq .current_observation.wind_degrees $WORKINGDIR/wu.json |tr -d '"')
echo "PWSWINDDIR=$PWSWINDDIR"

# extract windspeed
PWSWINDSPEEDMPH=$(jq .current_observation.wind_mph $WORKINGDIR/wu.json |tr -d '"')
echo "PWSWINDSPEEDMPH=$PWSWINDSPEEDMPH"

# extract windgustmph
PWSWINDGUSTMPH=$(jq .current_observation.wind_gust_mph $WORKINGDIR/wu.json |tr -d '"')
echo "PWSWINDGUSTMPH=$PWSWINDGUSTMPH"

# extract tempf
PWSTEMPF=$(jq .current_observation.temp_f $WORKINGDIR/wu.json |tr -d '"')
echo "PWSTEMPF=$PWSTEMPF"

# extract rainin - Hourly rain in inches
PWSRAININ=$(jq .current_observation.precip_1hr_in $WORKINGDIR/wu.json |tr -d '"')
echo "PWSRAININ=$PWSRAININ"


# extract rainin - Hourly rain in inches
PWSDAILYRAININ=$(jq .current_observation.precip_today_in $WORKINGDIR/wu.json |tr -d '"')
echo "PWSDAILYRAININ=$PWSDAILYRAININ"

# extract baromin - Barometric pressure in inches
PWSBAROMIN=$(jq .current_observation.pressure_in $WORKINGDIR/wu.json |tr -d '"')
echo "PWSBAROMIN=$PWSBAROMIN"

# extract dewptf - Dew point in degrees f
PWSDEWPTF=$(jq .current_observation.dewpoint_f $WORKINGDIR/wu.json |tr -d '"')
echo "PWSDEWPTF=$PWSDEWPTF"

# extract humidity - in percent
PWSHUMIDITY=$(jq .current_observation.relative_humidity $WORKINGDIR/wu.json |tr -d '"' |tr -d '%')
echo "PWSHUMIDITY=$PWSHUMIDITY"

# extract solarradiation
PWSSOLARRADIATION=$(jq .current_observation.solarradiation $WORKINGDIR/wu.json |tr -d '"'|tr -d '-')
echo "PWSSOLARRADIATION=$PWSSOLARRADIATION"

# extract UV
PWSUV=$(jq .current_observation.UV $WORKINGDIR/wu.json |tr -d '"')
echo "PWSUV=$PWSUV"

# construct PWS weather POST data string

PWSPOST="ID=$PWSID&PASSWORD=$PWSPASS&dateutc=$PWSDATEUTC&winddir=$PWSWINDDIR&windspeedmph=$PWSWINDSPEEDMPH&windgustmph=$PWSWINDGUSTMPH&tempf=$PWSTEMPF&rainin=$PWSRAININ&dailyrainin=$PWSDAILYRAININ&baromin=$PWSBAROMIN&dewptf=$PWSDEWPTF&humidity=$PWSHUMIDITY&solarradiation=$PWSSOLARRADIATION&UV=$PWSUV&softwaretype=wu_pws_ver1.0&action=updateraw"
#echo $PWSPOST

RESULT=$(wget -qo $WORKINGDIR/tmp.file --post-data=$PWSPOST http://www.pwsweather.com/pwsupdate/pwsupdate.php)
echo wget -qo $WORKINGDIR/tmp.file --post-data=$PWSPOST http://www.pwsweather.com/pwsupdate/pwsupdate.php

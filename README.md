# wupws
simple shell script that parses current observations from a weather underground station and posts to pwsweather.com.  Needed so Rachio smart irrigation controller can use nearby weather underground data to adjust watering schedule.

Mandatory Linux Tools Required:
- jq
- wget

Mandatory variables to set in the script (more info in the .sh):
- WORKINGDIR=/home/ABC123
- WUAPI={your weather underground API key - no braces}
- WUPWS={"your weather underground station identifier - no braces - yes quotes"}
- PWSID={your pwsweather.com station ID}
- PWSPASS={your pwsweather.com password}

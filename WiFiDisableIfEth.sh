#!/bin/bash
# WiFi Disable Script, Will Turn Off WiFi if the Device is Connected to Thunderbolt Ethernet.
# Gavin Pardoe Oct-16

# Checks Network Services for Thunderbolt Ethernet Adapter
services=$(networksetup -listallhardwareports | grep -o 'Thunderbolt Ethernet')

if [[ "$services" == 'Thunderbolt Ethernet' ]]; then
  echo "Ethernet Adapter Connected"
else
  echo "Ethernet Adapter Not Connected, Stopping Script"
  exit 0
fi

# Get Thunderbolt Adapter Device Number
TBeth=$(networksetup -listallhardwareports | grep -C1 'Thunderbolt Ethernet' | grep Device | awk '{ print $2 }')

if [[ $TBeth =~ 'en' ]]; then
  echo "Thunderbolt Eth Device is $TBeth"
else
  echo "No Thunderbolt Eth Device Found, Stopping Script"
  exit 0
fi

# Check That Thunderbolt Ethernet has a Vaild Network Connection, and if so Turn Wi-Fi Off
# Looks at the First 2/3 digits of Your IP to Double Check You have a Valid Connection
ifEth=$(ifconfig | grep -C1 $TBeth | grep 'inet 10' | awk '{ print $2 }' | cut -c 1-2) # Change cut value to 1-3 where needed.
wifiEn=$(networksetup -listallhardwareports | grep -C1 'Wi-Fi' | grep Device | awk '{ print $2 }')

if [[ $ifEth -eq 'YOUR_IP_HERE' ]]; then # Change value to the first 2/3 digits of you IP subnet
  echo "Vaild Thunderbolt Connection. Wi-Fi Turned Off"
  networksetup -setairportpower $wifiEn off
else
  echo "Vaild Thunderbolt Connection Not Found"
fi

exit 0

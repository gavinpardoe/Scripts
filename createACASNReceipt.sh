#!/bin/sh
# Create a Receipt File Contianing the ACA Serial Number.

# ACA Serial Number
connected=$(system_profiler SPPowerDataType | grep 'Connected' | awk '{ print $2 }')

if [[ $connected == Yes ]]; then
  serialNum=$(system_profiler SPPowerDataType | grep 'Serial Number' | awk 'NR==2{ print $3 }')
  echo "$serialNum" >> /Library/Application\ Support/JAMF/ACA.txt
else
  echo "AC Adapter not Connected"
fi

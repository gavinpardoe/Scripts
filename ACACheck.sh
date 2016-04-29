#!/bin/sh

	machineType=$(system_profiler SPHardwareDataType | grep -o 'MacBook' | awk 'NR==1')
	
if [[ $machineType != MacBook ]]; then
	echo "<result>Not Applicable Hardware</result>"
else 
	connected=$(system_profiler SPPowerDataType | grep 'Connected' | awk '{ print $2 }')
	
	if [[ $connected == Yes ]]; then
		serialNum=$(system_profiler SPPowerDataType | grep 'Serial Number' | awk 'NR==2{ print $3 }')
		echo "<result>$serialNum</result>"
	else
		echo "<result>AC Adapter not Connected</result>"
	fi
fi

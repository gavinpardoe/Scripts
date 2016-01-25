#!/bin/bash
# Download & Install Latest Version of Google Chrome - 7/7/2015
# Will Only Install if Google Chrome is not Already in the Applications Folder

# Set Variables 
chromeURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
googleChrome="/tmp/chrome.dmg"
currentUser=$(stat -f "%Su" /dev/console)

# Check Connection to www.google.com
/usr/bin/curl -D- -o /dev/null -s http://www.google.com
if [[ $? != 0 ]]; then
	echo "Google.com not Reachable, Check Internet Connection"
	exit $?
# Check if Chrome is Already Installed, If not Installation will Continue
	elif [ -e /Applications/Google\ Chrome.app ]; then
			echo "Google Chrome Already Present, Skiping Installation"
			exit 1
		else
			echo "Google Chrome not found, Downloading & Installing"
			/usr/bin/curl -o "$googleChrome" "$chromeURL"
			mount=`/usr/bin/mktemp -d /tmp/Chrome`
			/usr/bin/hdiutil attach "$googleChrome" -mountpoint "$mount" -nobrowse -noverify -noautoopen
			cp -R /private/tmp/Chrome/Google\ Chrome.app /Applications/
			/bin/sleep 1
# Cleanup Temp Files & Mounts, Add Permissions for Current User
			/usr/bin/hdiutil detach "$mount"
			/bin/rm -R /private/tmp/Chrome
			/bin/rm -rf "$googleChrome"
			/bin/sleep 1
			/bin/chmod -R +a "$currentUser allow read,write,delete" /Applications/Google\ Chrome.app
			echo "Google Chrome Installed Successfully"
			exit 0
fi
#!/bin/bash
# Download & Install Latest Version of Firefox - 10/4/2016
# Will Only Install if Firefox is not Already in the Applications Folder
# Version 2.0

# Set Variables
fireFoxURL="http://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
fireFox="/tmp/firefox.dmg"
currentUser=$(stat -f "%Su" /dev/console)

# Check Connection to https://www.mozilla.org
/usr/bin/curl -D- -o /dev/null -s https://www.mozilla.org
if [[ $? != 0 ]]; then
	echo "mozilla.org not Reachable, Check Internet Connection"
	exit $?
# Check if Firefox is Already Installed, If not Installation will Continue
	elif [ -e /Applications/Firefox.app ]; then
			echo "FireFox Already Present, Skiping Installation"
			exit 1
		else
			echo "Firefox not found, Downloading & Installing"
			/usr/bin/curl -L -o "$fireFox" "$fireFoxURL"
			mount=`/usr/bin/mktemp -d /tmp/Firefox`
			/usr/bin/hdiutil attach "$fireFox" -mountpoint "$mount" -nobrowse -noverify -noautoopen
			cp -R /private/tmp/Firefox/Firefox.app /Applications/
			/bin/sleep 1
# Cleanup Temp Files & Mounts, Add Permissions for Current User
			/usr/bin/hdiutil detach "$mount"
			/bin/rm -R /private/tmp/Firefox
			/bin/rm -rf "$fireFox"
			/bin/sleep 1
			/bin/chmod -R +a "$currentUser allow read,write,delete" /Applications/Firefox.app
			echo "Firefox Installed Successfully"
			exit 0
fi

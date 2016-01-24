#!/bin/bash
# First Run/Boot Script - Designed For Use With Casper Suite, Filewave, Absolute Manage, Deploy Studio & First Boot PKG. Will Likely Work With Other Methods As Well.
# Created By Gavin Pardoe - http://www.trams.co.uk - June 2015
# Disable iCloud & Setup Assistant Prompts Created by Rich Trouton - https://derflounder.wordpress.com
# Version 1.3 - 26/04/15

# Configure the 2 sections below as required/ needed by replacing the values after the '=' symbol. default 
# settings have already been configured. The second section is for use with Casper Suite only and by default are not 
# enable or configured. DO NOT edit below the top 2 sections.

########################################################
# Define User/Site Parameters (Edit These as Required) #
########################################################
	
# Sets the Name of the Log File (must have .log file extension)
	logFileName=firstRunScript.log
# Sets Time Zone
	timeZone=Europe/London
# Sets Time Server
	timeServer=time.euro.apple.com
# Enables Apple Remote Desktop (yes to enable, anything else will prevent this)
	Enable_ARD=yes
# Sets User to Be Allowed Apple Remote Desktop Access
	ARDuser=administrator
# Configures Second Mouse Button to Right Click (yes to enable, anything else will prevent this)
	Set_Right_Mouse_Click=yes
# Set Gate Keeper to Allow Apps Downloaded From Anywhere (anywhere to allow, anything else will maintain default setting)
	gateKeeperAllow=anywhere
	
######################################################################################################	
# Casper Suite Specific Options (these only function if being used in conjunction with Casper Suite) #
######################################################################################################

# Enable Casper Suite Options (on to enable Casper Suite options)
	casperOptions=off
# Enforce Management Framework from JSS (yes to enforce framework)
	forceMgmtJSS=no
# Check for Policies (yes to check for policies)
	policyCheck=no
# Check for Polices with Custom Tiggers (replace 'none' with customer trigger to run)
	policyTrigger=none
	
################################# *DO NOT EDIT BELOW THIS LINE* #################################
	
# Create Log File and Set Variables 
	dateTime=`/bin/date "+%Y-%m-%d %H:%M"`
	currentUser=$(/usr/bin/whoami)
	computerName=$(scutil --get ComputerName)
	/usr/bin/touch /var/log/$logFileName
	logFilePath=/var/log/$logFileName
	echo "Log File Created at $logFilePath $dateTime" >> $logFilePath
	echo "First Run Setup Script - Created by Gavin Pardoe - http://www.trams.co.uk" >> $logFilePath
	
	echo "*Starting Configuration*: $computerName: $currentUser: $dateTime" >> $logFilePath

# Check for New Hardware
	/usr/sbin/networksetup -detectnewhardware
	if [[ $? == 0 ]]; then
		echo "Checked for New Hardware: $dateTime" >> $logFilePath
		errorList[0]='passed'
	else
		echo "Error Checking for New Hardware: exit 1 - $dateTime" >> $logFilePath
		errorList[0]='failed'
	fi
	
# Set Time, Date & Region Settings
	/usr/sbin/systemsetup -settimezone "$timeZone"
	if [[ $? == 0 ]]; then
		echo "Time Zone Set to $timeZone: $dateTime" >> $logFilePath
		errorList[1]='passed'
	else
		echo "Time Zone Setting Failed Set to Apply: exit 1 - $dateTime" >> $logFilePath
		errorList[1]='failed'
	fi	
	/usr/sbin/systemsetup -setnetworktimeserver "$timeServer"
	if [[ $? == 0 ]]; then
		echo "Time Server Set to $timeServer: $dateTime" >> $logFilePath
		errorList[2]='passed'
	else
		echo "Time Server Setting Failed to Apply: exit 1 - $dateTime" >> $logFilePath
		errorList[2]='failed'
	fi	
	/usr/sbin/systemsetup -setusingnetworktime on
	if [[ $? == 0 ]]; then
		echo "Use Network Time Server Enabled: $dateTime" >> $logFilePath
		errorList[3]='passed'
	else
		echo "Failed to Enable Time Server: exit 1 - $dateTime" >> $logFilePath
		errorList[3]='failed'
	fi	
	defaults write /Library/Preferences/.GlobalPreferences AppleLanguages -array "en-GB"
	if [[ $? == 0 ]]; then
		echo "Default Language Set to British: $dateTime" >> $logFilePath
		errorList[4]='passed'
	else
		echo "Failed to Apply Language Setting: exit 1 - $dateTime" >> $logFilePath
		errorList[4]='failed'
	fi
	defaults write /Library/Preferences/.GlobalPreferences AppleLocale -string "en_GB@currency=GBP"
	if [[ $? == 0 ]]; then
		echo "Default Locale Set to British: $dateTime" >> $logFilePath
		errorList[5]='passed'
	else
		echo "Failed to Apply Locale Setting: exit 1 - $dateTime" >> $logFilePath
		errorList[5]='failed'
	fi
	defaults write /Library/Preferences/.GlobalPreferences Country -string "en_GB"
	if [[ $? == 0 ]]; then
		echo "Country Set to Britain: $dateTime" >> $logFilePath
		errorList[6]='passed'
	else
		echo "failed to Apply Country Setting: exit 1 - $dateTime" >> $logFilePath
		errorList[6]='failed'
	fi
	
# System Settings
	# Enable Mouse Right Click
	if [[ $Set_Right_Mouse_Click == yes ]]; then
	defaults write "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.driver.AppleHIDMouse" Button2 -int 2
	defaults write "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse" MouseButtonMode -string TwoButton
	defaults write "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad" TrackpadRightClick -int 1
		echo "Right Mouse Click Enabled: $dateTime" >> $logFilePath
	else
		echo "Right Mouse Click Not Configured in Script Parameters: $dateTime" >> $logFilePath
	fi
	
	# Enable Apple Remote Desktop
	if [[ $Enable_ARD == yes ]]; then
		/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUser	
		if [[ $? == 0 ]]; then	
			echo "ARD Enabled for Specified User: $dateTime" >> $logFilePath
			errorList[7]='passed'
		else
			echo "ARD has not Been Enabled: exit 1 - $dateTime" >> $logFilePath
			errorList[7]='failed'
		fi
	fi
	if [[ $Enable_ARD == yes ]]; then
		/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -users "$ARDuser" -access -on -privs -all
		if [[ $? == 0 ]]; then
			echo "ARD Access Enabled for $ARDuser with All Privileges: - $dateTime" >> $logFilePath
			errorList[8]='passed'
		else
			echo "ARD Privileges have not Applied: exit 1 - $dateTime" >> $logFilePath
			errorList[8]='failed'
		fi
	fi
	if [[ $Enable_ARD != yes ]]; then
	echo "ARD Not Configured in Script Parameters, Defaults Will Remain: $dateTime" >> $logFilePath
	fi	
		
	# Enable SSH
	/usr/sbin/systemsetup -setremotelogin on
	if [[ $? == 0 ]]; then
		echo "SSH Enabled: $dateTime" >> $logFilePath
		errorList[9]='passed'
	else
		echo "SSH Not Enabled: exit 1 - $dateTime" >> $logFilePath
		errorList[9]='failed'
	fi
	
	# Gatekeeper Allow From Anywhere
	if [[ $gateKeeperAllow == anywhere ]]; then
		/usr/sbin/spctl --master-disable
		if [[ $? == 0 ]]; then
			echo "Gate Keeper Set to Allow From Anywhere: $dateTime" >> $logFilePath
			errorList[10]='passed'
		else
			echo "Gate Keeper Set to Allow From Mac App Store and Identified Developers Only: exit 1 - $dateTime" >> $logFilePath
			errorList[10]='failed'
		fi
	fi
	if [[ $gateKeeperAllow != anywhere ]]; then
			echo "Gate Keeper Not Configured in Script Parameters, Defaults Will Remain: $dateTime" >> $logFilePath
	fi

# Disable iCloud & Setup Assistant Prompts (Created by Rich Trouton - https://derflounder.wordpress.com)
	# Determine OS version
	osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
	sw_vers=$(sw_vers -productVersion)
	
	# Determine OS build number
	sw_build=$(sw_vers -buildVersion)

	# Checks first to see if the Mac is running 10.7.0 or higher.
	# If so, the script checks the system default user template
	# for the presence of the Library/Preferences directory.
	# If the directory is not found, it is created and then the
	# iCloud and diagnostics pop-up settings are set to be disabled.
	
	if [[ ${osvers} -ge 7 ]]; then
	for USER_TEMPLATE in "/System/Library/User Template"/*
	do
	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
	done

	# Checks first to see if the Mac is running 10.7.0 or higher.
	# If so, the script checks the existing user folders in /Users
	# for the presence of the Library/Preferences directory.
	# If the directory is not found, it is created and then the
	# iCloud pop-up settings are set to be disabled.

	for USER_HOME in /Users/*
	do
	USER_UID=`basename "${USER_HOME}"`
	if [ ! "${USER_UID}" = "Shared" ]
	then
	if [ ! -d "${USER_HOME}"/Library/Preferences ]
	then
	mkdir -p "${USER_HOME}"/Library/Preferences
	chown "${USER_UID}" "${USER_HOME}"/Library
	chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
	fi
	if [ -d "${USER_HOME}"/Library/Preferences ]
	then
	defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
	defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
	defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
	defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
	chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant.plist
	fi
	fi
	done
	fi
		echo "Disabled iCloud and Setup Assistant Prompts: $dateTime" >> $logFilePath
	
# Casper Suite Specific Binary Commands; 
	if [[ $casperOptions != on ]]; then
		echo "Casper Suite Options not Enabled: $dateTime" >> $logFilePath
		elif [[ $casperOptions = on ]]; then
			 /usr/sbin/jamf recon
				echo "Inventory Updated into JSS: $dateTime" >>$logFilePath
	fi
	if	[[ $forceMgmtJSS == yes ]]; then
		/usr/sbin/jamf manage
			echo "JSS Management Framework installed: $dateTime" >>$logFilePath
	fi	
	if [[ $policyCheck == yes ]]; then
		/usr/sbin/jamf policy
			echo "Ran Checkin Policies: $dateTime" >>$logFilePath
	fi
	if [[ $policyTrigger != none ]]; then
		/usr/sbin/jamf policy -event "$policyTrigger"
			echo "Ran Any Policies with $policyTrigger Trigger: $dateTime" >>$logFilePat
	fi
	if [[ $casperOptions = on ]]; then
			echo "Casper Suite Options Ran: $dateTime" >> $logFilePath
	fi
	
# Check for Errors, Update Log and Output Exit Code to System	
	if [[ ${errorList[*]} =~ failed ]] ; then
		echo "Script Execution Unsuccessful: exit 1: : $dateTime" >> $logFilePath
		exit 1
	else
		echo "Script Execution Successful - *Configuration Complete*: $dateTime" >> $logFilePath
		exit 0
	fi
#!/bin/bash

# Will enable SSH and ScreenSharing.

# Enable SSH
sudo systemsetup -setremotelogin on

# Enable ScreenSharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false

# Load ScreenSharing Launch Daemon
sudo launchctl load /System/Library/LaunchDaemons/com.apple.screensharing.plist



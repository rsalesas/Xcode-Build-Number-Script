#!/bin/bash

# Get the major and minor version numbers from the Info.plist file
majorVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE" | awk -F "." '{print $1}')
minorVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE" | awk -F "." '{print $2}')

# Get the patch version number from the Info.plist file and increment it
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
buildNumber=$(($buildNumber + 1))

# Get the abbreviated Git commit hash
gitCommitHash=$(git rev-parse --short HEAD)

# Set the version number in the Info.plist file
versionNumber="$majorVersion.$minorVersion.$buildNumber"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $versionNumber" "$INFOPLIST_FILE"

# Set the build number in the Info.plist file
buildString="$versionNumber.$gitCommitHash"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildString" "$INFOPLIST_FILE"

# Set the build date in the Info.plist file
buildDate=$(date +"%Y-%m-%d %H:%M:%S %z")
/usr/libexec/PlistBuddy -c "Set :BuildDate $buildDate" "$INFOPLIST_FILE"

echo "Updated version number to $versionNumber ($buildString) with build date $buildDate"

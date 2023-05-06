#!/bin/bash

# Get the major and minor version numbers from the Info.plist file, or set them to 1 and 0 if they don't exist
majorVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE" 2>/dev/null | awk -F "." '{print $1}')
if [[ -z "$majorVersion" ]]; then
    majorVersion=1
fi

minorVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE" 2>/dev/null | awk -F "." '{print $2}')
if [[ -z "$minorVersion" ]]; then
    minorVersion=0
fi

# Get the patch version number from the Info.plist file, or set it to 0 if it doesn't exist
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE" 2>/dev/null | awk -F "." '{print $3}')
if [[ -z "$buildNumber" ]]; then
    buildNumber=0
else
    # Increment the patch version number if it exists
    buildNumber=$(($buildNumber + 1))
fi

# Get the abbreviated Git commit hash
gitCommitHash=$(git rev-parse --short HEAD)

# Set the version number in the Info.plist file
versionNumber="$majorVersion.$minorVersion.$buildNumber"
if /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$INFOPLIST_FILE" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $versionNumber" "$INFOPLIST_FILE"
else
    /usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string $versionNumber" "$INFOPLIST_FILE"
fi

# Set the build number in the Info.plist file
buildString="$majorVersion.$minorVersion.$buildNumber.$gitCommitHash"
if /usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$INFOPLIST_FILE" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildString" "$INFOPLIST_FILE"
else
    /usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $buildString" "$INFOPLIST_FILE"
fi

# Get the build date from the Info.plist file, or set it to today's date if it doesn't exist
buildDate=$(/usr/libexec/PlistBuddy -c "Print BuildDate" "$INFOPLIST_FILE" 2>/dev/null)
if [[ -z "$buildDate" ]]; then
    buildDate=$(date +"%Y-%m-%d %H:%M:%S %z")
fi

# Set the build date in the Info.plist file
if /usr/libexec/PlistBuddy -c "Print :BuildDate" "$INFOPLIST_FILE" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set :BuildDate $buildDate" "$INFOPLIST_FILE"
else
    /usr/libexec/PlistBuddy -c "Add :BuildDate string $buildDate" "$INFOPLIST_FILE"
fi

echo "Updated version number to $versionNumber ($buildString) with build date $buildDate"

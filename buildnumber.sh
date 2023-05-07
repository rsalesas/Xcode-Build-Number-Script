#!/bin/bash

# Set the path to the source Info.plist file
SRC_INFO_PLIST="${PROJECT_DIR}/${PROJECT_NAME}/Info.plist"

# Set the path to the destination Info.plist file
DST_INFO_PLIST="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

# Get the current build number from the source Info.plist file
CURRENT_BUILD_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${SRC_INFO_PLIST}")

# Increment the build number by 1
NEW_BUILD_NUMBER=$(($CURRENT_BUILD_NUMBER + 1))

# Update the build number in the source Info.plist file
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_BUILD_NUMBER" "${SRC_INFO_PLIST}"

# If the build number doesn't exist in the source Info.plist file, add it
if [ $? -ne 0 ]; then
    /usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $NEW_BUILD_NUMBER" "${SRC_INFO_PLIST}"
fi

# Get the current version number from the source Info.plist file
CURRENT_VERSION_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${SRC_INFO_PLIST}")

# Increment the patch number of the version number by 1
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION_NUMBER"

# Set the major version to 1 if it doesn't exist
MAJOR="${VERSION_PARTS[0]}"
if [ -z "$MAJOR" ]; then
    MAJOR=1
fi

# Set the minor version to 0 if it doesn't exist
MINOR="${VERSION_PARTS[1]}"
if [ -z "$MINOR" ]; then
    MINOR=0
fi

PATCH=$((${VERSION_PARTS[2]} + 1))
NEW_VERSION_NUMBER="$MAJOR.$MINOR.$PATCH"

# Update the version number in the source Info.plist file
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION_NUMBER" "${SRC_INFO_PLIST}"

# If the version number doesn't exist in the source Info.plist file, add it
if [ $? -ne 0 ]; then
    /usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string $NEW_VERSION_NUMBER" "${SRC_INFO_PLIST}"
fi

# Update the build number and version number in the destination Info.plist file
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_BUILD_NUMBER" "${DST_INFO_PLIST}"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION_NUMBER" "${DST_INFO_PLIST}"

# Output what was updated
echo "Updated build number to ${NEW_BUILD_NUMBER} and version number to ${NEW_VERSION_NUMBER}."

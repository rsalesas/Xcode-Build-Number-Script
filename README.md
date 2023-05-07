Sure, here's an example README.md file that you can use on GitHub to describe the script that updates the build number and version number in an Xcode project:

# Xcode Build Number Script

This script updates the build number, version number, and build date in an Xcode project. It's useful for keeping track of different versions of your application and identifying individual builds within a specific version.

## How it works

The script is a bash script that uses the `PlistBuddy` tool to read and modify values in the Info.plist file of your Xcode project.

When you run the script, it performs the following steps:

1. Reads the major and minor version numbers from the Info.plist file
2. Increments the patch version number and updates the version number in the Info.plist file

## How to activate the script

To activate the script, follow these steps:

1. In Xcode, select your project in the project navigator and then select the target you want to add the script to.
2. Click on the "Build Phases" tab and then click on the "+" button in the top left corner to add a new build phase.
3. Select "New Run Script Phase" from the dropdown menu.
4. Copy and paste the script from the example above into the new script phase. Make sure it's the last script to run.
5. Save your changes and rebuild your project. Each time you build your project, the build number, version number, and build date will be updated.

Note: If your project has multiple targets, you will need to add this script to each target individually.

## How it looks

The short build version (`CFBundleShortVersionString`) will look like this:

```
1.2.3
```

The build version (`CFBundleVersion`) will look like this:

```
1234
```

This represents a version number of `1.2.3` and a build number of `1234`.

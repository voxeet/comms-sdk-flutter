 #!/bin/bash
VERSION=`grep -E -o "version: (.*)" ./pubspec.yaml | cut -d ':' -f 2 | xargs`
echo Current version = $VERSION

# Uncomment when ios part will be prepared
sed -i '' "s/sdkVersion = \".*\"/sdkVersion = \"$VERSION\"/g" ./ios/Classes/PluginInfo.swift
sed -i '' "s/COMMS_SDK_VERSION=\".*\"/COMMS_SDK_VERSION=\"$VERSION\"/g" ./android/gradle.properties

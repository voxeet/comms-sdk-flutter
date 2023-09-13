#! /usr/bin/env bash

ANDROID_VERSION="32"
if [ "$2" ]
  then ANDROID_TOOLS=$1
fi

ANDROID_TOOLS="$ANDROID_VERSION"
if [ "$2" ]
  then ANDROID_TOOLS=$2
fi

ANDROID_IMAGE="android-29;default;x86"
if [ "$3" ]
  then ANDROID_IMAGE=$3
fi

echo $ANDROID_VERSION

build_tools_version="build-tools;$ANDROID_TOOLS"
platform_version="platforms;android-$ANDROID_VERSION"
system_image="system-images;$ANDROID_IMAGE"

echo $platform_version
echo $build_tools_version
echo $system_image

export ANDROID_SDK_ROOT=~/android-sdk

CMD_TOOLS="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools"

echo "SDKManager accept licenses"

yes 2>/dev/null | sdkmanager --licenses

$CMD_TOOLS/sdkmanager --list

echo "SDKManager - install required packages"

yes 2>/dev/null | sudo $CMD_TOOLS/sdkmanager "platform-tools" "$build_tools_version"
yes 2>/dev/null | sudo $CMD_TOOLS/sdkmanager "platform-tools" "$platform_version"
yes 2>/dev/null | sudo $CMD_TOOLS/sdkmanager "platform-tools" "emulator"
yes 2>/dev/null | sudo $CMD_TOOLS/sdkmanager "$system_image"

yes 2>/dev/null | sudo $CMD_TOOLS/sdkmanager --update

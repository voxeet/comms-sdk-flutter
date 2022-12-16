#! /usr/bin/env bash

build_tools_version="build-tools;32.0.0"
platform_version="platforms;android-32"
system_image="system-images;android-29;default;x86"

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

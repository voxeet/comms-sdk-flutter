#! /usr/bin/env bash

echo "Setup android"

#TOOLS_VERSION=9123335
TOOLS_VERSION=10406996

wget "https://dl.google.com/android/repository/commandlinetools-mac-${TOOLS_VERSION}_latest.zip"

unzip "commandlinetools-mac-${TOOLS_VERSION}_latest.zip"

mkdir ~/android-sdk/
mkdir ~/android-sdk/cmdline-tools

mv cmdline-tools ~/android-sdk/cmdline-tools/latest

export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools"

echo "PATH = $PATH"

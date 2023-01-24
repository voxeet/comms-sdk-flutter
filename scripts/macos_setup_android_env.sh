#! /usr/bin/env bash

echo "Setup android"

wget https://dl.google.com/android/repository/commandlinetools-mac-9123335_latest.zip

unzip commandlinetools-mac-9123335_latest.zip

mkdir ~/android-sdk/
mkdir ~/android-sdk/cmdline-tools

mv cmdline-tools ~/android-sdk/cmdline-tools/latest

export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools"

echo "PATH = $PATH"

#! /usr/bin/env bash

echo "Setup android"

#lsb_release -a

#sudo apt -y update

# java 8 is required for avdmanager
#sudo apt-get install openjdk-8-jdk

#sudo apt-get install libgl1-mesa-dev

wget https://dl.google.com/android/repository/commandlinetools-mac-9123335_latest.zip

unzip commandlinetools-mac-9123335_latest.zip

mkdir ~/android-sdk/
mkdir ~/android-sdk/cmdline-tools

mv cmdline-tools ~/android-sdk/cmdline-tools/latest

#cat /etc/*ease

export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools"


echo "PATH = $PATH"



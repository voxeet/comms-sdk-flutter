#! /usr/bin/env bash

echo "Setup android"

lsb_release -a

sudo apt -y update

# java 8 is required for avdmanager
sudo apt-get install openjdk-8-jdk

sudo apt-get install libgl1-mesa-dev

wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip

unzip commandlinetools-linux-8512546_latest.zip

sudo mkdir /usr/lib/android-sdk/
sudo mkdir /usr/lib/android-sdk/cmdline-tools

sudo mv cmdline-tools /usr/lib/android-sdk/cmdline-tools/latest

cat /etc/*ease

export ANDROID_SDK_ROOT=/usr/lib/android-sdk

export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools"


echo "PATH = $PATH"



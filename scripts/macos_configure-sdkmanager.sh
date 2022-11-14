#! /usr/bin/env bash

build_tools_version="build-tools;32.0.0"
platform_version="platforms;android-32"
system_image="system-images;android-32;google_apis;x86_64"
system_image="system-images;android-29;default;x86"
#system_image="system-images;android-28;google_apis;arm64-v8a"

#sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
#sudo systemctl enable libvirt-bin

#chmod 777 /dev/kvm

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

#configure haxm

wget https://github.com/intel/haxm/releases/download/v7.8.0/haxm-macosx_v7_8_0.zip

unzip haxm-macosx_v7_8_0.zip

chmod +x silent_install.sh

sudo ./silent_install.sh
#
#kextstat | grep intel
#
#sudo kextunload -b com.intel.kext.intelhaxm
#
#sudo kextload -b com.intel.kext.intelhaxm


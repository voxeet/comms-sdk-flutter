#! /usr/bin/env bash

device_name="testAVD"
system_image="system-images;android-29;default;x86"
device_port="5554"
serial_no="emulator-$device_port"
#gpu_mode="guest"
gpu_mode="swiftshader_indirect"

#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

#export ANDROID_SDK_ROOT=~/android-sdk
#export ANDROID_HOME=~/.android/

export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

echo $PATH

echo "Check available avd"

avdmanager list avd

echo "Create system image: $system_image"

echo "no" | avdmanager --verbose create avd --force --name $device_name --abi "default/x86" --package "$system_image"
echo "disk.dataPartition.size=1024MB" >> ~/.android/avd/$device_name.avd/config.ini
touch ~/.android/emu-update-last-check.ini

ls -la ~/.android/

adb start-server

sleep 5

echo "accel check: "
emulator -accel-check

echo "check emulator list:"
emulator -list-avds

echo "start: $device_name"
$ANDROID_SDK_ROOT/emulator/emulator -avd $device_name -port $device_port -noaudio -no-window  -gpu $gpu_mode -no-snapshot -no-boot-anim &

echo "Device name: $device_name"

sleep 8



i=1
while [ "`adb -s $serial_no shell getprop sys.boot_completed | tr -d '\r' `" != "1" ] ; do
  sleep 2;
  i=$((i+1))
  if [[ "$i" -gt 60 ]]; then
    echo "Waiting for device - tiemout"
    exit 1
  fi

done

echo "Device: $device_name is booted"

adb devices

#run script that set useMockSDK flag
./scripts/change-to-mock.sh

currentFolder=`pwd`

cd test_app

#test for one test file only
#USE_SDK_MOCK=true flutter test integration_tests/mocked/conference_service_test.dart -d $serial_no
USE_SDK_MOCK=true flutter test integration_tests/mocked -d $serial_no
test_exit_code=$?

cd $currentFolder

#remove useMockSDK flag from gradle.properites
./scripts/remove-mocks.sh

echo "Shutting down simulator $device_id ..."
adb -s $serial_no emu kill
echo "Simulator $device_name shut down"
wait
echo "Remove avd: "
avdmanager delete avd -n testAVD

exit $test_exit_code

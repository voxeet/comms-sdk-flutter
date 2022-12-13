#! /usr/bin/env bash

device_name="Pixel_5_API_32"
device_port="5554"
emulator -avd $device_name -port $device_port -netdelay none -netspeed full &

echo "Device name: $device_name"

serial_no="emulator-$device_port"

while [ "`adb -s $serial_no shell getprop sys.boot_completed | tr -d '\r' `" != "1" ] ; do sleep 1; done

echo "Device: $device_name is booted"

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

exit $test_exit_code

#! /usr/bin/env bash


device_name="iPhone 13 Pro"
device_id=$(xcrun simctl list devices | grep "$device_name (" | head -1 | sed -n -e "/$device_name (/ s/[[:space:]]*$device_name (\([^[:space:]]*\)).*/\1/p")

xcode_build_scheme="IntegrationTestRunner"

echo "Device id: $device_id"

simulator_booted_status=$(xcrun simctl list devices | sed -n -e "/($device_id)/ s/[[:space:]]* $device_name ($device_id) (\([^[:space:]]*\))[[:space:]]*/\1/p")
echo "Simulator status: '$simulator_booted_status'"
if [[ "$simulator_booted_status" == "Booted" ]]; then
    echo "No need to boot the simulator as it is alerady booted"
else
    echo "Booting simulator $device_id ..."
    xcrun simctl boot $device_id
    if [ $? == 0 ]; then
        echo "Simulator $device_id booted"
    else 
        echo "Could not boot simulator"
        exit $?
    fi
fi

cd test_app
USE_SDK_MOCK=true flutter test integration_tests --flavor "$xcode_build_scheme" -d "$device_id"
test_exit_code=$?

echo "Shutting down simulator $device_id ..."
xcrun simctl shutdown $device_id
echo "Simulator $device_id shut down"

exit $test_exit_code

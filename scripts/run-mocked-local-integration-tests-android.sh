#! /usr/bin/env bash

export ANDROID_HOME=~/.android/
export HOME=~/

export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

adb start-server

sleep 1

i=1
while [ "`adb shell getprop sys.boot_completed | tr -d '\r' `" != "1" ] ; do
  sleep 2;
  i=$((i+1))
  if [[ "$i" -gt 120 ]]; then
    echo "Waiting for device - tiemout"
    exit 1
  fi

done

./scripts/change-to-mock.sh

currentFolder=`pwd`

cd test_app

USE_SDK_MOCK=true flutter test integration_tests/mocked/master_test.dart
test_exit_code=$?

cd $currentFolder

./scripts/remove-mocks.sh

echo "Shutting down simulator $device_id ..."

exit $test_exit_code

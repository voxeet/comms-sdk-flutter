#! /usr/bin/env bash

cd test_app/android/

pwd

GRADLE_PROPERTIES_FILE=gradle.properties

USE_MOCK=`cat $GRADLE_PROPERTIES_FILE | grep "useMockSDK" | cut -d '=' -f2`

if [ -z $USE_MOCK ]
then
  echo "mock is unnecessary"
else
  echo $USE_MOCK
  sed '$d' ./gradle.properties > tmpfile
  mv tmpfile $GRADLE_PROPERTIES_FILE
fi

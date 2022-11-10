#! /usr/bin/env bash

cd test_app/android/

pwd

GRADLE_PROPERTIES_FILE=gradle.properties

USE_MOCK=`cat $GRADLE_PROPERTIES_FILE | grep "useMockSDK" | cut -d '=' -f2`

if [ -z $USE_MOCK ]
then
  echo "not found"
  echo -e "\nuseMockSDK=true" >> $GRADLE_PROPERTIES_FILE
else
  echo $USE_MOCK
fi

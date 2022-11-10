#! /usr/bin/env bash

echo "activate pana plugin"

dart pub global activate pana

echo "Run pana analyzer"

dart pub global run pana . -j --exit-code-threshold 1
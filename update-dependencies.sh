#!/bin/bash

if [ -n "$IDF_PATH" ] && [ -d "$IDF_PATH" ]; then
    echo Updating "$IDF_PATH"...
    pushd "$IDF_PATH"
    git pull --ff-only
    git submodule update
    popd
fi

OPENOCD_ESP32=../openocd-esp32
if [ -n "$OPENOCD_ESP32" ] && [ -d "$OPENOCD_ESP32" ]; then
    echo Updating "$OPENOCD_ESP32"...
    pushd "$OPENOCD_ESP32"
    git pull --ff-only
    git submodule update
    popd
fi

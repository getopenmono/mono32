#!/bin/bash

if [ -n "$IDF_PATH" ] && [ -d "$IDF_PATH" ]; then
    echo Updating "$IDF_PATH"...
    pushd "$IDF_PATH"
    git pull --ff-only
    git submodule update
    popd
fi

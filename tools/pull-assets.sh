#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DEST_PATH=dist/build/uAssets

echo "*** Pull assets from remote into $DEST_PATH"

if [ ! -e "$DEST_PATH/main" ]; then
    git clone --depth 1 --branch master https://github.com/uBlockOrigin/uAssets "$DEST_PATH/main"
fi

if [ ! -e "$DEST_PATH/prod" ]; then
    git clone --depth 1 --branch gh-pages https://github.com/uBlockOrigin/uAssets "$DEST_PATH/prod"
fi

echo "*** Done"

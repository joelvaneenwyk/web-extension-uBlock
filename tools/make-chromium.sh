#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

echo "*** uBlock0.chromium: Creating web store package"

DEST=dist/build/uBlock0.chromium
rm -rf $DEST
mkdir -p $DEST

echo "*** uBlock0.chromium: Copying common files"
bash ./tools/copy-common-files.sh $DEST

# Chromium-specific
echo "*** uBlock0.chromium: Copying chromium-specific files"
cp platform/chromium/*.js   $DEST/js/
cp platform/chromium/*.html $DEST/
cp platform/chromium/*.json $DEST/

# Chrome store-specific
cp -R $DEST/_locales/nb $DEST/_locales/no

echo "*** uBlock0.chromium: Generating meta..."
python3 tools/make-chromium-meta.py $DEST/

if [ "$1" = all ]; then
    echo "*** uBlock0.chromium: Creating plain package..."
    pushd $(dirname $DEST/) > /dev/null
    zip uBlock0.chromium.zip -qr $(basename $DEST/)/*
    popd > /dev/null
elif [ -n "$1" ]; then
    echo "*** uBlock0.chromium: Creating versioned package..."
    pushd $(dirname $DEST/) > /dev/null
    zip uBlock0_"$1".chromium.zip -qr $(basename $DEST/)/*
    popd > /dev/null
fi

echo "*** uBlock0.chromium: Package done."

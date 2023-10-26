#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DEST=$1/assets

echo "*** Packaging assets in $DEST... "

rm -rf $DEST
cp -R ./assets $DEST/

VERSION=$(cat ./dist/version)
if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "*** Removing $DEST/assets.dev.json"
    rm $DEST/assets.dev.json
else
    echo "*** Removing $DEST/assets.json"
    rm $DEST/assets.json
fi

mkdir $DEST/thirdparties

ASSETS_MAIN=dist/build/uAssets/main
ASSETS_PROD=dist/build/uAssets/prod

cp -R $ASSETS_MAIN/thirdparties/pgl.yoyo.org     $DEST/thirdparties/
cp -R $ASSETS_MAIN/thirdparties/publicsuffix.org $DEST/thirdparties/
cp -R $ASSETS_MAIN/thirdparties/urlhaus-filter   $DEST/thirdparties/

mkdir -p $DEST/thirdparties/easylist
cp $ASSETS_PROD/thirdparties/easylist.txt $DEST/thirdparties/easylist/
cp $ASSETS_PROD/thirdparties/easyprivacy.txt $DEST/thirdparties/easylist/

mkdir $DEST/ublock
cp $ASSETS_PROD/filters/badlists.txt $DEST/ublock/badlists.txt
cp $ASSETS_PROD/filters/badware.txt $DEST/ublock/badware.txt
cp $ASSETS_PROD/filters/filters.min.txt $DEST/ublock/filters.min.txt
cp $ASSETS_PROD/filters/filters-mobile.txt $DEST/ublock/filters-mobile.txt
cp $ASSETS_PROD/filters/privacy.min.txt $DEST/ublock/privacy.min.txt
cp $ASSETS_PROD/filters/quick-fixes.txt $DEST/ublock/quick-fixes.txt
cp $ASSETS_PROD/filters/unbreak.txt $DEST/ublock/unbreak.txt

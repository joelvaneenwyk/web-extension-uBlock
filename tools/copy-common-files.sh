#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DEST=$1

bash ./tools/make-assets.sh        $DEST

cp -R src/css                      $DEST/
cp -R src/img                      $DEST/
mkdir $DEST/js
cp -R src/js/*.js                  $DEST/js/
cp -R src/js/codemirror            $DEST/js/
cp -R src/js/scriptlets            $DEST/js/
cp -R src/js/wasm                  $DEST/js/
cp -R src/lib                      $DEST/
cp -R src/web_accessible_resources $DEST/
cp -R src/_locales                 $DEST/

cp src/*.html                      $DEST/
cp platform/common/*.js            $DEST/js/
cp platform/common/*.json          $DEST/
cp LICENSE.txt                     $DEST/

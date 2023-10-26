#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DEST=dist/build/uBlock0.browser

mkdir -p $DEST/js
cp src/js/base64-custom.js           $DEST/js
cp src/js/biditrie.js                $DEST/js
cp src/js/filtering-context.js       $DEST/js
cp src/js/hntrie.js                  $DEST/js
cp src/js/static-filtering-parser.js $DEST/js
cp src/js/static-net-filtering.js    $DEST/js
cp src/js/static-filtering-io.js     $DEST/js
cp src/js/text-utils.js              $DEST/js
cp src/js/uri-utils.js               $DEST/js

mkdir -p $DEST/js/wasm
cp -R src/js/wasm $DEST/js/

mkdir -p $DEST/lib
cp -R src/lib/punycode.js      $DEST/lib/
cp -R src/lib/publicsuffixlist $DEST/lib/
cp -R src/lib/regexanalyzer    $DEST/lib/

mkdir -p $DEST/data
cp -R submodules/uAssets/thirdparties/publicsuffix.org/list/* \
      $DEST/data
cp -R submodules/uAssets/thirdparties/easylist-downloads.adblockplus.org/* \
      $DEST/data

cp platform/browser/*.html $DEST/
cp platform/browser/*.js   $DEST/
cp LICENSE.txt             $DEST/

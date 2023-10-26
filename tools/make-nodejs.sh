#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DEST=$1

mkdir -p $DEST/js
cp src/js/base64-custom.js           $DEST/js
cp src/js/biditrie.js                $DEST/js
cp src/js/dynamic-net-filtering.js   $DEST/js
cp src/js/filtering-context.js       $DEST/js
cp src/js/hnswitches.js              $DEST/js
cp src/js/hntrie.js                  $DEST/js
cp src/js/redirect-resources.js      $DEST/js
cp src/js/static-dnr-filtering.js    $DEST/js
cp src/js/static-filtering-parser.js $DEST/js
cp src/js/static-net-filtering.js    $DEST/js
cp src/js/static-filtering-io.js     $DEST/js
cp src/js/tasks.js                   $DEST/js
cp src/js/text-utils.js              $DEST/js
cp src/js/uri-utils.js               $DEST/js
cp src/js/url-net-filtering.js       $DEST/js

mkdir -p $DEST/lib
cp -R src/lib/csstree          $DEST/lib/
cp -R src/lib/punycode.js      $DEST/lib/
cp -R src/lib/regexanalyzer    $DEST/lib/
cp -R src/lib/publicsuffixlist $DEST/lib/

# Convert wasm modules into json arrays
mkdir -p $DEST/js/wasm
cp src/js/wasm/* $DEST/js/wasm/
node -pe "JSON.stringify(Array.from(fs.readFileSync('src/js/wasm/hntrie.wasm')))" \
    > $DEST/js/wasm/hntrie.wasm.json
node -pe "JSON.stringify(Array.from(fs.readFileSync('src/js/wasm/biditrie.wasm')))" \
    > $DEST/js/wasm/biditrie.wasm.json
node -pe "JSON.stringify(Array.from(fs.readFileSync('src/lib/publicsuffixlist/wasm/publicsuffixlist.wasm')))" \
    > $DEST/lib/publicsuffixlist/wasm/publicsuffixlist.wasm.json

cp platform/nodejs/*.js      $DEST/
cp platform/nodejs/README.md $DEST/
cp LICENSE.txt               $DEST/

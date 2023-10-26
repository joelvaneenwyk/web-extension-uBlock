#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

echo "*** uBlock0.opera: Creating web store package"

DEST=dist/build/uBlock0.opera
rm -rf $DEST
mkdir -p $DEST

echo "*** uBlock0.opera: Copying common files"
bash ./tools/copy-common-files.sh $DEST

# Chromium-specific
echo "*** uBlock0.opera: Copying chromium-specific files"
cp platform/chromium/*.js   $DEST/js/
cp platform/chromium/*.html $DEST/

# Opera-specific
echo "*** uBlock0.opera: Copying opera-specific files"
cp platform/opera/manifest.json $DEST/

rm -r $DEST/_locales/az
rm -r $DEST/_locales/be
rm -r $DEST/_locales/cv
rm -r $DEST/_locales/gu
rm -r $DEST/_locales/hi
rm -r $DEST/_locales/hy
rm -r $DEST/_locales/ka
rm -r $DEST/_locales/kk
rm -r $DEST/_locales/mr
rm -r $DEST/_locales/si
rm -r $DEST/_locales/so
rm -r $DEST/_locales/th

# Removing WASM modules until I receive an answer from Opera people: Opera's
# uploader issue an error for hntrie.wasm and this prevents me from
# updating uBO in the Opera store. The modules are unused anyway for
# Chromium- based browsers.
rm $DEST/js/wasm/*.wasm
rm $DEST/js/wasm/*.wat
rm $DEST/lib/lz4/*.wasm
rm $DEST/lib/lz4/*.wat
rm $DEST/lib/publicsuffixlist/wasm/*.wasm
rm $DEST/lib/publicsuffixlist/wasm/*.wat

echo "*** uBlock0.opera: Generating meta..."
python3 tools/make-opera-meta.py $DEST/

echo "*** uBlock0.opera: Package done."

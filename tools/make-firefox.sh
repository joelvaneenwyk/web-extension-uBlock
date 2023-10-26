#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

echo "*** uBlock0.firefox: Creating web store package"

BLDIR=dist/build
DEST="$BLDIR"/uBlock0.firefox
rm -rf $DEST
mkdir -p $DEST

echo "*** uBlock0.firefox: Copying common files"
bash ./tools/copy-common-files.sh $DEST

# Firefox-specific
echo "*** uBlock0.firefox: Copying firefox-specific files"
cp platform/firefox/*.json $DEST/
cp platform/firefox/*.js   $DEST/js/

# Firefox store-specific
cp -R $DEST/_locales/nb     $DEST/_locales/no

# Firefox/webext-specific
rm $DEST/img/icon_128.png

echo "*** uBlock0.firefox: Generating meta..."
if command -v py &> /dev/null; then PYTHON3="py -3"; else PYTHON3="python3"; fi
$PYTHON3 tools/make-firefox-meta.py $DEST/

if [ "$1" = all ]; then
    echo "*** uBlock0.firefox: Creating package..."
    pushd $DEST > /dev/null
    zip ../$(basename $DEST).xpi -qr *
    popd > /dev/null
elif [ -n "$1" ]; then
    echo "*** uBlock0.firefox: Creating versioned package..."
    pushd $DEST > /dev/null
    zip ../$(basename $DEST).xpi -qr *
    popd > /dev/null
    mv "$BLDIR"/uBlock0.firefox.xpi "$BLDIR"/uBlock0_"$1".firefox.xpi
fi

echo "*** uBlock0.firefox: Package done."

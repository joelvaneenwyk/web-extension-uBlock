#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

echo "*** uBlock0.thunderbird: Creating web store package"

BLDIR=dist/build
DEST="$BLDIR"/uBlock0.thunderbird
rm -rf $DEST
mkdir -p $DEST

echo "*** uBlock0.thunderbird: copying common files"
bash ./tools/copy-common-files.sh $DEST

echo "*** uBlock0.firefox: Copying firefox-specific files"
cp platform/firefox/*.js $DEST/js/

echo "*** uBlock0.firefox: Copying thunderbird-specific files"
cp platform/thunderbird/manifest.json $DEST/

# Firefox store-specific
cp -R $DEST/_locales/nb             $DEST/_locales/no

# Firefox/webext-specific
rm $DEST/img/icon_128.png

echo "*** uBlock0.thunderbird: Generating meta..."
python3 tools/make-firefox-meta.py $DEST/

if [ "$1" = all ]; then
    echo "*** uBlock0.thunderbird: Creating package..."
    pushd $DEST > /dev/null
    zip ../$(basename $DEST).xpi -qr *
    popd > /dev/null
elif [ -n "$1" ]; then
    echo "*** uBlock0.thunderbird: Creating versioned package..."
    pushd $DEST > /dev/null
    zip ../$(basename $DEST).xpi -qr *
    popd > /dev/null
    mv "$BLDIR"/uBlock0.thunderbird.xpi "$BLDIR"/uBlock0_"$1".thunderbird.xpi
fi

echo "*** uBlock0.thunderbird: Package done."

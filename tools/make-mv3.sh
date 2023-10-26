#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e
shopt -s extglob

echo "*** uBOLite.mv3: Creating extension"

PLATFORM="chromium"

for i in "$@"; do
  case $i in
    quick)
      QUICK="yes"
      shift # past argument=value
      ;;
    full)
      FULL="yes"
      shift # past argument=value
      ;;
    firefox)
      PLATFORM="firefox"
      shift # past argument=value
      ;;
    chromium)
      PLATFORM="chromium"
      shift # past argument=value
      ;;
    (uBOLite_+([0-9]).+([0-9]).+([0-9]).+([0-9]))
      TAGNAME="$i"
      FULL="yes"
      shift # past argument=value
      ;;
  esac
done

DEST="dist/build/uBOLite.$PLATFORM"

if [ "$QUICK" != "yes" ]; then
    rm -rf $DEST
fi

mkdir -p $DEST
cd $DEST
DEST=$(pwd)
cd - > /dev/null

mkdir -p $DEST/css/fonts
mkdir -p $DEST/js
mkdir -p $DEST/img

if [ -n "$UBO_VERSION" ]; then
    UBO_REPO="https://github.com/gorhill/uBlock.git"
    UBO_DIR=$(mktemp -d)
    echo "*** uBOLite.mv3: Fetching uBO $UBO_VERSION from $UBO_REPO into $UBO_DIR"
    cd "$UBO_DIR"
    git init -q
    git remote add origin "https://github.com/gorhill/uBlock.git"
    git fetch --depth 1 origin "$UBO_VERSION"
    git checkout -q FETCH_HEAD
    cd - > /dev/null
else
    UBO_DIR=.
fi

echo "*** uBOLite.mv3: Copying common files"
cp -R $UBO_DIR/src/css/fonts/* $DEST/css/fonts/
cp $UBO_DIR/src/css/themes/default.css $DEST/css/
cp $UBO_DIR/src/css/common.css $DEST/css/
cp $UBO_DIR/src/css/dashboard-common.css $DEST/css/
cp $UBO_DIR/src/css/fa-icons.css $DEST/css/

cp $UBO_DIR/src/js/dom.js $DEST/js/
cp $UBO_DIR/src/js/fa-icons.js $DEST/js/
cp $UBO_DIR/src/js/i18n.js $DEST/js/
cp $UBO_DIR/src/lib/punycode.js $DEST/js/

cp -R $UBO_DIR/src/img/flags-of-the-world $DEST/img

cp LICENSE.txt $DEST/

echo "*** uBOLite.mv3: Copying mv3-specific files"
if [ "$PLATFORM" = "firefox" ]; then
    cp platform/mv3/firefox/background.html $DEST/
fi
cp platform/mv3/extension/*.html $DEST/
cp platform/mv3/extension/*.json $DEST/
cp platform/mv3/extension/css/* $DEST/css/
cp -R platform/mv3/extension/js/* $DEST/js/
cp platform/mv3/extension/img/* $DEST/img/
cp -R platform/mv3/extension/_locales $DEST/
cp platform/mv3/README.md $DEST/

if [ "$QUICK" != "yes" ]; then
    echo "*** uBOLite.mv3: Generating rulesets"
    TMPDIR=$(mktemp -d)
    mkdir -p $TMPDIR
    if [ "$PLATFORM" = "chromium" ]; then
        cp platform/mv3/chromium/manifest.json $DEST/
    elif [ "$PLATFORM" = "firefox" ]; then
        cp platform/mv3/firefox/manifest.json $DEST/
    fi
    ./tools/make-nodejs.sh $TMPDIR
    cp platform/mv3/package.json $TMPDIR/
    cp platform/mv3/*.js $TMPDIR/
    cp platform/mv3/extension/js/utils.js $TMPDIR/js/
    cp $UBO_DIR/assets/assets.json $TMPDIR/
    cp $UBO_DIR/assets/resources/scriptlets.js $TMPDIR/
    cp -R platform/mv3/scriptlets $TMPDIR/
    mkdir -p $TMPDIR/web_accessible_resources
    cp $UBO_DIR/src/web_accessible_resources/* $TMPDIR/web_accessible_resources/
    cd $TMPDIR
    node --no-warnings make-rulesets.js output=$DEST platform="$PLATFORM"
    cd - > /dev/null
    rm -rf $TMPDIR
fi

echo "*** uBOLite.mv3: extension ready"
echo "Extension location: $DEST/"

if [ "$FULL" = "yes" ]; then
    EXTENSION="zip"
    if [ "$PLATFORM" = "firefox" ]; then
        EXTENSION="xpi"
    fi
    echo "*** uBOLite.mv3: Creating publishable package..."
    if [ -z "$TAGNAME" ]; then
        TAGNAME="uBOLite_$(jq -r .version $DEST/manifest.json)"
    else
        tmp=$(mktemp)
        jq --arg version "${TAGNAME:8}" '.version = $version' "$DEST/manifest.json"  > "$tmp" \
            && mv "$tmp" "$DEST/manifest.json"
    fi
    PACKAGENAME="$TAGNAME.$PLATFORM.mv3.$EXTENSION"
    TMPDIR=$(mktemp -d)
    mkdir -p $TMPDIR
    cp -R $DEST/* $TMPDIR/
    cd $TMPDIR > /dev/null
    zip $PACKAGENAME -qr ./*
    cd - > /dev/null
    cp $TMPDIR/$PACKAGENAME dist/build/
    rm -rf $TMPDIR
    echo "Package location: $(pwd)/dist/build/$PACKAGENAME"
fi

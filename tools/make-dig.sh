#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DEST="dist/build/uBlock0.dig"

./tools/make-nodejs.sh $DEST
./tools/make-assets.sh $DEST

cp -R platform/dig/*   $DEST/

cd $DEST
npm run build

echo "*** uBlock0.dig: Package done."

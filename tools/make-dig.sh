#!/usr/bin/env bash
#
# This script assumes a linux environment

set -eEax

DES="dist/build/uBlock0.dig"

./tools/make-nodejs.sh $DES
./tools/make-assets.sh $DES

cp -R platform/dig/* $DES/

cd $DES
yarn build

echo "*** uBlock0.dig: Package done."

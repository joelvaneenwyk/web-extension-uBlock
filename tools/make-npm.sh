#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DES="dist/build/uBlock0.npm"

TMPDIR="$PWD/tmp"
mkdir -p "$TMPDIR/node_modules"

rm -rf $DES

./tools/make-nodejs.sh $DES
./tools/make-assets.sh $DES

# Target-specific
cp platform/npm/.npmignore $DES/
cp platform/npm/*.json $DES/
cp platform/npm/.*.json $DES/
cp platform/npm/*.js $DES/
cp -R platform/npm/tests $DES/

cd $DES
cd tests/data
tar xzf bundle.tgz
cd -
if [ -n "${1:-}" ]; then
    echo "*** uBlock0.npm: Creating versioned package..."
    tarballname="uBlock0_${1:-XXX}.npm.tgz"
else
    echo "*** uBlock0.npm: Creating plain package..."
    tarballname="uBlock0.npm.tgz"
fi
touch yarn.lock
corepack use yarn
yarn build
yarn pack --out "../$tarballname"

ln -sf "$TMPDIR/node_modules" .
if [ -z "$GITHUB_ACTIONS" ]; then
    yarn install
fi
cd -

echo "*** uBlock0.npm: Package done."

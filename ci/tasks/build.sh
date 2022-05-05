#!/bin/sh

set -e

ls -ltr
cat version/number
export version=$( cat version/number )
npm set progress=false

cd source
ls -ltr
npm ci --prefix ./frame/web-tier
npm run build --prefix ./frame/web-tier

set +e
ls -ltr
tar zcf webtier.v${version}.tar.gz ./frame/web-tier/node_modules/ ./frame/web-tier/server.js ./frame/web-tier/Dockerfile ./frame/web-tier/src/ ./frame/web-tier/views/ ./frame/web-tier/app-config.json ./frame/web-tier/package.json
cp -R -v ./*.gz ../artifacts/
ls -ltr ../artifacts

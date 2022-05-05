#!/bin/sh

set -e

ls -ltr
cat version/number
export version=$( cat version/number )
npm set progress=false

cd source
ls -ltr
npm ci --prefix ./app


set +e
ls -ltr
tar zcf webtier.v${version}.tar.gz ./app/node_modules/ ./app/server.js ./app/Dockerfile ./app ./app/package.json
cp -R -v ./*.gz ../artifacts/
ls -ltr ../artifacts

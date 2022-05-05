ls -ltr s3-source
cat version/number
export version=$( cat version/number )
uname -a 
cd builtFiles
tar xzvf ../s3-source/webtier.v${version}.tar.gz
cd ..
ls -ltr builtFiles

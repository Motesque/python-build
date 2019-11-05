#!/bin/bash
if [ $WORKSPACE == "" ]; then
    echo "WARNING: No WORKSPACE set"
    exit 1
fi
set -e
mkdir -p $WORKSPACE/artifacts
ARCH=$1
PYTHON_VERSION=$2
cd $WORKSPACE
sed -e s/#{platform}/$ARCH/g Dockerfile.in > Dockerfile
echo "Building Python '$PYTHON_VERSION' for architecture '$ARCH'"
docker build -t python-build-$ARCH .

if [ $(uname) == "Darwin" ]; then
    docker run --rm -e ARCH=$ARCH -e PYTHON_VERSION=$PYTHON_VERSION -v $WORKSPACE/artifacts:/output python-build-$ARCH bash build.sh
else
    docker run --rm -e ARCH=$ARCH -e PYTHON_VERSION=$PYTHON_VERSION -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static -v $WORKSPACE/artifacts:/output python-build-$ARCH bash build.sh
fi
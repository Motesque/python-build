#!/bin/bash
ARCH=$1
PYTHON_VERSION=$2

if [ $WORKSPACE == "" ]; then
    echo "WARNING: No WORKSPACE set"
    exit 1
fi

set -e
mkdir -p $WORKSPACE/artifacts
cd $WORKSPACE
echo "Building Python '$PYTHON_VERSION' for architecture '$ARCH'"
# remove the crossbuild commands if needed
if [[ $ARCH == "amd64" ]]; then
    cat Dockerfile.in  | sed -e 's/RUN \[ "cross-build-start" \]//g' -e 's/RUN \[ \"cross-build-end\" \]//g' > Dockerfile
else
    cp Dockerfile.in Dockerfile
fi
docker build -t python-build-$ARCH-$PYTHON_VERSION --build-arg ARCH=$ARCH --build-arg PYTHON_VERSION=$PYTHON_VERSION .

echo "Copying artifact..."
if [ $(uname) == "Darwin" ]; then
    docker run --rm -e ARCH=$ARCH -e PYTHON_VERSION=$PYTHON_VERSION -v $WORKSPACE/artifacts:/output python-build-$ARCH-$PYTHON_VERSION /bin/bash  -c "cp /Python*.tar.gz /output/"
else
    docker run --rm -e ARCH=$ARCH -e PYTHON_VERSION=$PYTHON_VERSION -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static -v $WORKSPACE/artifacts:/output python-build-$ARCH-$PYTHON_VERSION /bin/bash  -c "cp /Python*.tar.gz /output/"
fi
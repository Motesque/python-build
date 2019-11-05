#!/bin/bash

# Debian Stretch
TAR_FILE=Python-$PYTHON_VERSION.linux-$ARCH.tar.gz

if [ $ARCH != "amd64" ]; then
    cross-build-start
fi

mkdir -p /usr/tmp && cd /usr/tmp \
    && wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar -zxvf Python-$PYTHON_VERSION.tgz \
    && cd Python-$PYTHON_VERSION \
    && ./configure --enable-shared \
    && make -j4 \
    && make -j4 DESTDIR="/python" install \
    && rm -rf /usr/tmp

cd /
tar -cvzf $TAR_FILE python/*
mv $TAR_FILE /output/

if [ $ARCH != "amd64" ]; then
    cross-build-end
fi
#!/bin/bash
set -euxo pipefail

if [ $(uname) == Linux ]; then
    export CXXFLAGS=$(echo "${CXXFLAGS}" | sed "s/-std=c++17/-std=c++14/g")
fi

autoconf
mkdir build
cd build
if [ ! -z ${LIBRARY_PREFIX+x} ]; then
    ../configure --prefix=$LIBRARY_PREFIX
else
    ../configure --prefix=$PREFIX
fi

make
make install
make check -j$CPU_COUNT

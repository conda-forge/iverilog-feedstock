#!/bin/bash
set -euxo pipefail

if [ $(uname) == Linux ]; then
    export CXXFLAGS=$(echo "${CXXFLAGS}" | sed "s/-std=c++17/-std=c++14/g")
fi

autoconf

if [ ! -z ${LIBRARY_PREFIX+x} ]; then
    ./configure --prefix=$LIBRARY_PREFIX
else
    ./configure --prefix=$PREFIX
fi

make -j$CPU_COUNT

if [ -d "${PREFIX}/lib/ivl" ]; then
    echo "${PREFIX}/lib/ivl path found!"
else
    echo "${PREFIX}/lib/ivl path NOT found!"
    exit 1234
fi

make check -j$CPU_COUNT
make install -j$CPU_COUNT

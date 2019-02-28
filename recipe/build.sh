#!/bin/bash

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
make check -j$CPU_COUNT
make install -j$CPU_COUNT

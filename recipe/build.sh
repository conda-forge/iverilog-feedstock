#!/bin/bash

export CXXFLAGS="$CXXFLAGS -std=c++14"

autoconf
./configure --prefix=$PREFIX
make -j$CPU_COUNT
make check && make install

#!/bin/bash
set -euxo pipefail

if [[ "${target_platform}" != "win-"* ]]; then
    cp ${BUILD_PREFIX}/share/gnuconfig/config.* .
fi

autoconf
mkdir build
cd build

../configure --prefix=$PREFIX --host=$HOST

[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j$CPU_COUNT
make install

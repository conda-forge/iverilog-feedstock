#!/bin/bash
set -euxo pipefail

# build.bat delegates here on Windows and translates the key paths to msys2
# form, restoring the converted PATH via PATH_OVERRIDE.
[ -n "${PATH_OVERRIDE:-}" ] && export PATH="$PATH_OVERRIDE"

# The v13_0 git tag archive ships pre-generated configure + config.h.in, so no
# autoreconf is needed; running the shipped configure directly is reliable.
if [ -n "${LIBRARY_PREFIX_U:-}" ]; then
    prefix="$LIBRARY_PREFIX_U"
    # bison/flex come from WinFlexBison on the modern m2w64 stack; autoconf
    # respects pre-set YACC/LEX. zlib installs its import lib under
    # Library/lib, so point the mingw compiler at the conda Library tree.
    export YACC="${YACC:-win_bison -y}"
    export LEX="${LEX:-win_flex}"
    export CPPFLAGS="${CPPFLAGS:-} -I$prefix/include"
    export LDFLAGS="${LDFLAGS:-} -L$prefix/lib"
    # Icarus builds a couple of build-time tools with a separate native
    # compiler (BUILDCC = @CC_FOR_BUILD@). We build on Windows for Windows,
    # so the mingw compiler serves both; without this the configure probe
    # falls through to 'clang' found on the CI runner, which cannot link in
    # the msys2 shell ("C compiler cannot create executables").
    export CC_FOR_BUILD="${CC_FOR_BUILD:-${CC:-gcc}}"
else
    prefix="$PREFIX"
fi

mkdir -p build
cd build

../configure --prefix="$prefix" --host="${HOST:-${CONDA_TOOLCHAIN_HOST:-$(${CC:-gcc} -dumpmachine)}}"

make -j"$CPU_COUNT"
make install
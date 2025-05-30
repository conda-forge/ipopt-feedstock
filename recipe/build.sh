#!/bin/bash
# Get an updated config.sub and config.guess

if [[ "$target_platform" != "win-64" ]]; then
  cp $BUILD_PREFIX/share/gnuconfig/config.* .
fi

cd $SRC_DIR

export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
export SPRAL_OPTIONS=
if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
  export SPRAL_OPTIONS="--with-spral --with-spral-cflags=-I${PREFIX}/include --with-spral-lflags=-lspral"
fi

if [[ "$target_platform" == "win-64" ]]; then
  # On windows there are no dmumps_seq pkg-config, see https://github.com/conda-forge/mumps-feedstock/issues/129, so we manually specify how to link dmumps
  export MUMPS_LFLAGS="-ldmumps"
else
  export MUMPS_LFLAGS="$(pkg-config --libs dmumps_seq)"
fi

mkdir build
cd build

../configure \
  --without-hsl $SPRAL_OPTIONS \
  --disable-java \
  --with-mumps \
  --with-mumps-cflags="-I${PREFIX}/include/mumps_seq" \
  --with-mumps-lflags="${MUMPS_LFLAGS}" \
  --with-lapack \
  --with-lapack-lflags="-llapack -lblas" \
  --with-asl \
  --with-asl-cflags="-I${PREFIX}/include/asl" \
  --with-asl-lflags="-lasl" \
  --prefix=${PREFIX} || cat config.log

# As documented in https://github.com/conda-forge/autotools_clang_conda-feedstock/blob/cb241060f5d8adcd105f3b2e8454a8ad4d70f08f/recipe/meta.yaml#L58C1-L58C60
[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
  # Environment variables needed by spral
  # See https://github.com/ralna/spral#usage-at-a-glance
  export OMP_CANCELLATION=TRUE
  export OMP_PROC_BIND=TRUE
  make test
fi
make install

# for backward compatibility
install -d ${PREFIX}/include/coin
install -m644 ${PREFIX}/include/coin-or/* ${PREFIX}/include/coin

if [[ "$target_platform" == "win-64" ]]; then
  # In conda-forge import library are called .lib, not .dll.lib,
  # and also pkg-config expects that. The main ipopt.dll.lib library
  # is renamed by the run_autotools_clang_conda_build, but here we also
  # install and, that we manually rename here ipoptamplinterface.dll.lib
  # sipopt.dll.lib
  mv "${PREFIX}/lib/ipoptamplinterface.dll.lib" "${PREFIX}/lib/ipoptamplinterface.lib"
  mv "${PREFIX}/lib/sipopt.dll.lib" "${PREFIX}/lib/sipopt.lib"
  # While the ipopt.dll.lib library is renamed to ipopt.lib by run_autotools_clang_conda_build, for backward
  # compatibility (see https://github.com/conda-forge/ipopt-feedstock/pull/125#issuecomment-2544745043)
  # we also want to install ipopt-3.lib that was the import library name used by the Windows package of ipopt in conda-forge < 3.14.17
  du -h "${PREFIX}/lib/ipopt.dll.lib"
  cp "${PREFIX}/lib/ipopt.dll.lib" "${PREFIX}/lib/ipopt-3.lib"
fi

#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

cd $SRC_DIR

export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
export SPRAL_OPTIONS=
if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
  export SPRAL_OPTIONS="--with-spral --with-spral-cflags=-I${PREFIX}/include --with-spral-lflags=-lspral"
fi

mkdir build
cd build

../configure \
  --without-hsl $SPRAL_OPTIONS \
  --disable-java \
  --with-mumps \
  --with-mumps-cflags="-I${PREFIX}/include/mumps_seq" \
  --with-mumps-lflags="$(pkg-config --libs dmumps_seq)" \
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

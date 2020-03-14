#!/bin/bash

# seems ipopt requires its own mumps version now
git clone https://github.com/coin-or-tools/ThirdParty-Mumps.git && cd ThirdParty-Mumps && git checkout releases/1.6.2 && ./get.Mumps && ./configure --prefix=${PREFIX} && make -j${CPU_COUNT} && make install && cd -

if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi

mkdir build
cd build

../configure \
  CFLAGS="-I$PREFIX/include -I$PREFIX/include/asl" \
  CXXFLAGS=" -m64 -I$PREFIX/include -I$PREFIX/include/asl" \
  --with-blas-lib="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -llapack -lblas" \
  --with-asl-lib="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -lasl" \
  --without-hsl --disable-java \
  --prefix=$PREFIX

make -j${CPU_COUNT}
make test
make install

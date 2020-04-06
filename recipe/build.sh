#!/bin/bash

# ipopt looks only for its own ASL & Mumps now
cd ASL && ./get.ASL && ./configure --prefix=${PREFIX} && make -j${CPU_COUNT} && make install && cd -

cd Metis && ./get.Metis && ./configure --prefix=${PREFIX} && make -j${CPU_COUNT} && make install && cd -

cd Mumps && ./get.Mumps && ./configure --prefix=${PREFIX} && make -j${CPU_COUNT} && make install && cd -

cd Ipopt

if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi

mkdir build
cd build

../configure \
  --without-hsl --disable-java \
  --prefix=$PREFIX

make -j${CPU_COUNT}
make test
make install

# for backward compatibility
cp -r ${PREFIX}/include/coin-or ${PREFIX}/include/coin

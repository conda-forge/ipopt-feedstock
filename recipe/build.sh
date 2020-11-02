#!/bin/bash

# ipopt looks only for its own ASL
cd ASL && ./get.ASL && ./configure --prefix=${PREFIX} && make -j${CPU_COUNT} && make install && cd -

cd Ipopt

if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi

mkdir build
cd build

../configure \
  --without-hsl \
  --disable-java \
  --prefix=$PREFIX \
  --with-mumps \
  --with-mumps-cflags="-I${PREFIX}/include/mumps_seq" \
  --with-mumps-lflags="-L${PREFIX}/lib -lmumps"

make -j${CPU_COUNT}
make test
make install

# for backward compatibility
install -d ${PREFIX}/include/coin
install -m644 ${PREFIX}/include/coin-or/* ${PREFIX}/include/coin


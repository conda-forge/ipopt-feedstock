#!/bin/bash

cd Ipopt

if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi

mkdir build
cd build

../configure \
  --without-hsl \
  --disable-java \
  --with-mumps \
  --with-mumps-cflags="-I${PREFIX}/include/mumps_seq" \
  --with-mumps-lflags="-L${PREFIX}/lib -ldmumps_seq -lmumps_common_seq -lpord_seq -lmpiseq_seq -lesmumps -lscotch -lscotcherr -lmetis -lgfortran" \
  --with-asl \
  --with-asl-cflags="-I${PREFIX}/include/asl" \
  --with-asl-lflags="-L${PREFIX}/lib -lasl" \
  --prefix=${PREFIX}

make -j${CPU_COUNT}
make test
make install

# for backward compatibility
install -d ${PREFIX}/include/coin
install -m644 ${PREFIX}/include/coin-or/* ${PREFIX}/include/coin


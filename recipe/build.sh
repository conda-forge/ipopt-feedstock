#!/bin/bash

if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi

mkdir build
cd build

../configure \
  CFLAGS="-I$PREFIX/include -I$PREFIX/include/asl -I$PREFIX/include/mumps_seq" \
  CXXFLAGS=" -m64 -I$PREFIX/include -I$PREFIX/include/asl -I$PREFIX/include/mumps_seq" \
  --with-blas-lib="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -lopenblas" \
  --with-asl-lib="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -lasl" \
  --with-mumps-lib="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -ldmumps_seq -lmumps_common_seq -lpord_seq -lmpiseq_seq -lesmumps -lscotch -lscotcherr -lmetis -lgfortran" \
  --prefix=$PREFIX

make
make test
make install

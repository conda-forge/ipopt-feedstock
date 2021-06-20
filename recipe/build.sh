#!/bin/bash

cd $SRC_DIR

export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
if [ "$(uname)" == "Linux" ]; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi

# Workaround borrowed from
#   https://github.com/conda-forge/paraview-feedstock/blob/768674f52f492f357c132b110fcb18b2c0587742/recipe/build.sh#L4
# For issue as reported here:
#   https://github.com/AnacondaRecipes/intel_repack-feedstock/issues/8
#   https://github.com/conda-forge/python-feedstock/issues/289
export LDFLAGS=`echo "${LDFLAGS}" | sed "s|-Wl,-dead_strip_dylibs||g"`

mkdir build
cd build

if [[ ${LINEAR_SOLVER} == 'pardisomkl' ]]; then
  ../configure \
    --without-hsl \
    --disable-java \
    --with-asl \
    --with-asl-cflags="-I${PREFIX}/include/asl" \
    --with-asl-lflags="-lasl" \
    --prefix=${PREFIX}
elif [[ ${LINEAR_SOLVER} == 'mumps' ]]; then
  ../configure \
    --without-hsl \
    --disable-java \
    --with-mumps \
    --with-mumps-cflags="-I${PREFIX}/include/mumps_seq" \
    --with-mumps-lflags="-ldmumps_seq -lmumps_common_seq -lpord_seq -lmpiseq_seq -lesmumps -lscotch -lscotcherr -lmetis -lgfortran" \
    --with-asl \
    --with-asl-cflags="-I${PREFIX}/include/asl" \
    --with-asl-lflags="-lasl" \
    --prefix=${PREFIX}
fi

make -j${CPU_COUNT}
make test
make install

# for backward compatibility
install -d ${PREFIX}/include/coin
install -m644 ${PREFIX}/include/coin-or/* ${PREFIX}/include/coin

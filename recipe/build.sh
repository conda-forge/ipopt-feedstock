#!/bin/bash

# ipopt requires its own third parties now
curl -fSsL https://github.com/coin-or-tools/ThirdParty-ASL/archive/releases/1.4.3.tar.gz | tar xz && cd ThirdParty-ASL-releases-1.4.3 && ./get.ASL && ./configure --prefix=${PREFIX} && make -j${CPU_COUNT} && make install && cd -

curl -fSsL https://github.com/coin-or-tools/ThirdParty-Mumps/archive/releases/1.6.2.tar.gz | tar xz && cd ThirdParty-Mumps-releases-1.6.2 && patch -p1 -i ${RECIPE_DIR}/thirdparty-mumps-linux-configure.patch && ./get.Mumps && ./configure --prefix=${PREFIX} && make -j${CPU_COUNT} && make install && cd -

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

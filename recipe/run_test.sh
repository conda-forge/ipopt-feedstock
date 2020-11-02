#!/bin/bash -e

# Test linking against the ipopt library
cd test

${CXX} -I$PREFIX/include/coin-or -c -o cpp_example.o cpp_example.cpp
${CXX} -I$PREFIX/include/coin-or -c -o MyNLP.o MyNLP.cpp

# Deal with different linker flags
if [ $(uname -s) == 'Darwin' ]; then
  ${CXX} -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib -lipopt \
    -I$PREFIX/include/coin-or -o cpp_example cpp_example.o MyNLP.o
else
  ${CXX} -L$PREFIX/lib -lipopt -I$PREFIX/include/coin-or -o cpp_example cpp_example.o MyNLP.o
fi

./cpp_example | grep -q "Optimal Solution"

#!/bin/bash -e

# Test the ipopt binary
ipopt mytoy.nl | grep -q "Optimal Solution"

# Test linking against the ipopt library
cd test

if [ "$(uname)" == "Darwin" ]; then
  export CXX=clang++
else
  export CXX=g++
fi

${CXX} -I$PREFIX/include/coin  -c -o cpp_example.o cpp_example.cpp
${CXX} -I$PREFIX/include/coin  -c -o MyNLP.o MyNLP.cpp

# Deal with different linker flags
if [ $(uname -s) == 'Darwin' ]; then
  ${CXX} -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib -lipopt \
    -I$PREFIX/include/coin -o cpp_example cpp_example.o MyNLP.o
else
  ${CXX} -L$PREFIX/lib -lipopt -I$PREFIX/include/coin -o cpp_example cpp_example.o MyNLP.o
fi

./cpp_example | grep -q "Optimal Solution"

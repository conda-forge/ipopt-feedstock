cd test

${CXX} -I$PREFIX/include/coin  -c -o cpp_example.o cpp_example.cpp
${CXX} -I$PREFIX/include/coin  -c -o MyNLP.o MyNLP.cpp

${CXX} -L$PREFIX/lib -lipopt -I$PREFIX/include/coin -o cpp_example.exe cpp_example.o MyNLP.o

cpp_example.exe | grep -q "Optimal Solution"


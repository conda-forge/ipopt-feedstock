g++ -I%LIBRARY_PREFIX%/mingw-w64/include/coin  -c -o cpp_example.o cpp_example.cpp
g++ -I%LIBRARY_PREFIX%/mingw-w64/include/coin  -c -o MyNLP.o MyNLP.cpp
g++ -L%LIBRARY_PREFIX%/mingw-w64/bin -L%LIBRARY_PREFIX%/mingw-w64/lib -lipopt -lstdc++ -I%LIBRARY_PREFIX%/mingw-w64/include/coin -o cpp_example.exe cpp_example.o MyNLP.o

cpp_example.exe | grep -q "Optimal Solution"

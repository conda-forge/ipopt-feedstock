REM Test the ipopt binary
ipopt mytoy.nl | findstr "Optimal Solution"

REM Test linking against the ipopt library
cd test
cl /c /I $PREFIX/include/coin cpp_example.cpp /out:cpp_example.obj
cl /c /I $PREFIX/include/coin MyNLP.cpp /out:MyNLP.obj
link /LIBPATH $PREFIX/lib /I $PREFIX/include/coin cpp_example.obj MyNLP.obj /out:cpp_example.exe
.\cpp_example.exe | findstr "Optimal Solution"

copy bin\ipopt.exe %LIBRARY_BIN%
xcopy include\* %LIBRARY_INC% /sy
xcopy lib\* %LIBRARY_LIB% /sy
copy share\coin\doc\Ipopt\LICENSE LICENSE
copy share\coin\doc\Ipopt\README README
REM Test linking against the ipopt library
REM Stopgap until conda-build#1059 is fixed
cd test
cl /c /I $PREFIX/include/coin cpp_example.cpp /out:cpp_example.obj
cl /c /I $PREFIX/include/coin MyNLP.cpp /out:MyNLP.obj
link /LIBPATH $PREFIX/lib cpp_example.obj MyNLP.obj /out:cpp_example.exe
.\cpp_example.exe | findstr "Optimal Solution"
del cpp_example.* MyNLP.*
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.

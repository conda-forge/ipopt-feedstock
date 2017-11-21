xcopy include\* %LIBRARY_INC% /sy
xcopy lib\* %LIBRARY_LIB% /sy
copy share\coin\doc\Ipopt\LICENSE LICENSE
copy share\coin\doc\Ipopt\README README

mkdir build
cd build

rm /mingw-w64/bin/make.exe
bash -c "CXXDEFS=-DCOIN_USE_MUMPS_MPI_H ADD_CXXFLAGS='-I${PREFIX}/include -L${PREFIX}/lib' ../configure --build=x86_64-w64-mingw32 --disable-linear-solver-loader --with-blas-lib='-lopenblas' --with-mumps-lib='-ldmumps -lmumps_common -lpord -lgfortran' --enable-shared --enable-dependency-linking --prefix=${PREFIX}"
cp /mingw-w64/bin/mingw32-make.exe /mingw-w64/bin/make.exe
mingw32-make clean
mingw32-make test
mingw32-make libipopt.dll
rm /mingw-w64/bin/make.exe

mingw32-make install
copy src\Interfaces\libipopt.dll %LIBRARY_LIB%


if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.

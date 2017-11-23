mkdir build
cd build

rem rm /mingw-w64/bin/make.exe
bash -c "CXXDEFS=-DCOIN_USE_MUMPS_MPI_H ADD_CXXFLAGS='-I/mingw-w64/include -L/mingw-w64/lib -L/mingw-w64/bin' ../configure --build=x86_64-w64-mingw32 --disable-linear-solver-loader --with-blas-lib='-lopenblas' --with-mumps-lib='-ldmumps -lmumps_common -lpord -lgfortran' --enable-dependency-linking --prefix=/mingw-w64"
rem cp /mingw-w64/bin/mingw32-make.exe /mingw-w64/bin/make.exe
make clean
make test
cd src\Interfaces
make libipopt.dll
cd ..\..
rem rm /mingw-w64/bin/make.exe

make install
bash -c "/usr/bin/install -m 644 src/Interfaces/libipopt.dll /mingw-w64/bin"


if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.

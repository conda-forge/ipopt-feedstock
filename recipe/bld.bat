setlocal EnableDelayedExpansion

copy %RECIPE_DIR%\CMakeLists_root.txt CMakeLists.txt
copy %RECIPE_DIR%\CMakeLists_Ipopt.txt Ipopt\CMakeLists.txt
mkdir Ipopt\include
copy %RECIPE_DIR%\config.h.in Ipopt\include\config.h.in
copy %RECIPE_DIR%\config_ipopt.h.in Ipopt\include\config_ipopt.h.in
xcopy /E %RECIPE_DIR%\cmake\* cmake\

mkdir build
cd build


:: Configure using the CMakeFiles
cmake -G "MinGW Makefiles" ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%\mingw-w64" ^
      -D "CMAKE_PREFIX_PATH=%LIBRARY_PREFIX%;%LIBRARY_PREFIX%\mingw-w64" ^
      -DCMAKE_BUILD_TYPE:STRING=Release ^
      -DCMAKE_SH="CMAKE_SH-NOTFOUND" ^
      -DIPOPT_HAS_MUMPS=1 ^
      -DCOIN_HAS_MUMPS=1 ^
      -DCMAKE_CXX_STANDARD_LIBRARIES="-ldmumps -lmumps_common -llapack -lblas -lgfortran -lkernel32 -luser32 -lgdi32 -lwinspool -lshell32 -lole32 -loleaut32 -luuid -lcomdlg32 -ladvapi32" ^
      -DIPOPT_ENABLE_LINEARSOLVERLOADER=1 ^
      ..
if errorlevel 1 exit 1

:: Build!
mingw32-make
if errorlevel 1 exit 1

:: Install!
mingw32-make install
if errorlevel 1 exit 1
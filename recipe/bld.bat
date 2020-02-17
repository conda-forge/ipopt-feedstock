setlocal EnableDelayedExpansion

copy %RECIPE_DIR%\CMakeLists_root.txt CMakeLists.txt
copy %RECIPE_DIR%\CMakeLists_Ipopt.txt Ipopt\CMakeLists.txt
mkdir Ipopt\include
copy %RECIPE_DIR%\config.h.in Ipopt\include\config.h.in
xcopy /E %RECIPE_DIR%\cmake\* cmake\

mkdir build
cd build


:: Configure using the CMakeFiles
cmake -G "NMake Makefiles" ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_BUILD_TYPE:STRING=Release ^
      -DIPOPT_BUILD_EXAMPLES=1 ^
      -DIPOPT_HAS_MUMPS=1 ^
      -DCMAKE_C_COMPILER=clang-cl ^
      -DCMAKE_CXX_COMPILER=clang-cl ^
      -DCMAKE_Fortran_COMPILER=flang ^
      -DHAVE_RAND=1 ^
      -DIPOPT_ENABLE_LINEARSOLVERLOADER=1 ^
      ..
if errorlevel 1 exit 1
cmake --build . --config Release --target install
if errorlevel 1 exit 1
cmake -E env CTEST_OUTPUT_ON_FAILURE=1 cmake --build . --config Release --target test
if errorlevel 1 exit 1
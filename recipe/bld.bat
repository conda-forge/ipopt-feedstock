copy bin\ipopt.exe %LIBRARY_BIN%
xcopy include\* %LIBRARY_INC% /sy
xcopy lib\* %LIBRARY_LIB% /sy
copy share\coin\doc\Ipopt\LICENSE LICENSE
copy share\coin\doc\Ipopt\README README

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.

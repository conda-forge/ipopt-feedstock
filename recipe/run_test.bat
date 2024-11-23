setlocal EnableDelayedExpansion

:: Check .pc file
pkg-config --exists --print-errors --debug ipopt
if errorlevel 1 exit 1

pkg-config --validate --print-errors --debug ipopt
if errorlevel 1 exit 1

:: Test the ipopt binary
ipopt mytoy.nl | find "Optimal Solution"

:: Test linking against the ipopt library
cd test

:: Compile example that links ipopt
cl.exe /EHsc /I%PREFIX%\Library\include\coin-or ipopt-3.lib cpp_example.cpp MyNLP.cpp
if errorlevel 1 exit 1

:: Make sure that Windows native find is found before the find in C:\Miniconda\Library\usr\bin\
set PATH=C:\Windows\System32;%PATH%

:: Run example
.\cpp_example.exe mumps | find "Optimal Solution"
if errorlevel 1 exit 1

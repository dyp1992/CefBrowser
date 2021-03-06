REM comenv
REM vc2017
@echo off
pushd .
set VERSION=3.3359.1772.gd1df190

REM bash -c "wget -c http://opensource.spotify.com/cefbuilds/cef_binary_%VERSION%_windows32.tar.bz2"
bash -c "bsdtar -xvf cef_binary_%VERSION%_windows32.tar.bz2"
move cef_binary_*_windows32 CEF_WIN

REM Need cmake
cd CEF_WIN
cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release

cd build
msbuild /m /p:configuration=release cef.sln
msbuild /m /p:configuration=debug cef.sln

cd ..\..

copy CEF_WIN\Release\libcef.lib .
copy CEF_WIN\build\libcef_dll_wrapper\Release\libcef_dll_wrapper.lib .
copy CEF_WIN\build\libcef_dll_wrapper\Debug\libcef_dll_wrapper.lib libcef_dll_wrapper_d.lib
xcopy /y /s /i CEF_WIN\include include

msbuild /m /p:configuration=release QCefBrowser.sln
msbuild /m /p:configuration=debug QCefBrowser.sln

copy /y release\QCefBrowser.dll CEF_WIN\build\tests\cefclient\Release\
copy /y release\QCefBrowser_test.exe CEF_WIN\build\tests\cefclient\Release\
CEF_WIN\build\tests\cefclient\Release\QCefBrowser_test.exe

copy /y debug\QCefBrowser_d.dll CEF_WIN\build\tests\cefclient\Release\
copy /y debug\QCefBrowser_test_d.exe CEF_WIN\build\tests\cefclient\Release\
CEF_WIN\build\tests\cefclient\Release\QCefBrowser_test_d.exe
popd
@echo off
setlocal ENABLEDELAYEDEXPANSION

set ADB=adb.exe
set JAVA=java.exe
where %ADB% || (echo Unable to find %ADB% && goto:eof)
where %JAVA% || (echo Unable to find %JAVA% && goto:eof)

:: check java version
if [%EXPERIMENTAL_USE_OPENJDK9%] == [] (
    %JAVA% -version 2>&1 | findstr /R "version\ \"1\.[678].*\"$" || (
        echo Wrong java version. 1.6, 1.7 or 1.8 is required.
        goto:eof
    )
) else (
    %JAVA% -version 2>&1 | findstr /R "java .*\"9.*\"$" || (
        echo Wrong java version. Version 9 is required.
        goto:eof
    )
)

:: check debug flag and set up remote debugging
if not [%TF_DEBUG%] == [] (
    if [%TF_DEBUG_PORT%] == [] (
        set TF_DEBUG_PORT=10088
    )
    set RDBG_FLAG=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=!TF_DEBUG_PORT!
)

:: assume built on Linux; running on Windows.
:: find VTS_ROOT directory by location of this script
echo %~dp0 | findstr /R \\out\\host\\windows-x86\\bin && (
    set CTS_ROOT=%~dp0\..\..\linux-x86\cts
)

if [%CTS_ROOT%] == [] (
    :: assume in an extracted VTS installation package
    set CTS_ROOT=%~dp0\..\..
)
set CTS_ROOT=F:\cts
echo CTS_ROOT=%CTS_ROOT%

:: java classpath
set JAR_DIR=%CTS_ROOT%\android-cts\tools

:: tradefed.jar
set TRADEFED_JAR=%JAR_DIR%\tradefed.jar
if not exist "%TRADEFED_JAR%" (
    echo Unable to locate %TRADEFED_JAR%. Try prebuilt jar.
    set TRADEFED_JAR=%JAR_DIR%\tradefed-prebuilt.jar
)
if not exist "%TRADEFED_JAR%" (
    echo Unable to locate %TRADEFED_JAR%
    goto:eof
)
set JAR_PATH=%TRADEFED_JAR%

:: other required jars
set JARS=^
  hosttestlib^
  cts-tradefed^
  compatibility-host-util
for %%J in (%JARS%) do (
    set JAR=%JAR_DIR%\%%J.jar
    if not exist "!JAR!" ( echo Unable to locate !JAR! && goto:eof )
    set JAR_PATH=!JAR_PATH!;!JAR!
)

:: to run in the lab.
rem set OPTIONAL_JARS=^
rem   android-cts\tools\google-tradefed-cts-prebuilt^
rem   google-tradefed-prebuilt^
rem   google-tradefed-tests^
rem   google-tf-prod-tests

rem for %%J in (%OPTIONAL_JARS%) do (
rem     set JAR=%CTS_ROOT%\%%J.jar
rem     if exist "!JAR!" (
rem         echo Including optional JAR: !JAR!
rem         set JAR_PATH=!JAR_PATH!;!JAR!
rem     ) else (
rem         echo Optional JAR not found: !JAR!
rem     )
rem )

:: skip loading shared libraries for host-side executables

:: include any host-side test jars
set JAR_PATH=%JAR_PATH%;%CTS_ROOT%\android-cts\testcases\*
echo JAR_PATH=%JAR_PATH%

cd %CTS_ROOT%/android-cts/testcases
%JAVA% %RDBG_FLAG% -cp "%JAR_PATH%" "-DCTS_ROOT=%CTS_ROOT%" com.android.compatibility.common.tradefed.command.CompatibilityConsole %*
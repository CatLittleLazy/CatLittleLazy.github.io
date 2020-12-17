@echo off
set CTS_ROOT=F:\cts
set JAR_DIR=%CTS_ROOT%android-cts\tools
set JAR_PATH=%JAR_DIR%\cts-tradefed.jar;%JAR_DIR%\ddmlib-prebuilt.jar;%JAR_DIR%\hosttestlib.jar;%JAR_DIR%\junit.jar;%JAR_DIR%\tradefed-prebuilt.jar
java -cp %JAR_PATH% -DCTS_ROOT=%CTS_ROOT% com.android.cts.tradefed.command.CtsConsole
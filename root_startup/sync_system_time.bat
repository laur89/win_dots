:: first elevate script privileges if executed as non-root.
:: from https://stackoverflow.com/a/24665214/1803648
::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off

:: Check privileges
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    echo !!!
    echo going to run system time update as root
    echo !!!
    pause
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
    exit /b
)

:: Change directory with passed argument. Processes started with
:: "runas" start with forced C:\Windows\System32 workdir
cd /d %1

:: Actual work:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
REM start time-sync service. this is especially useful if we've disabled most
REM daemons via ChrisTitusTech/winutil (or other similar debloater) -- otherwise
REM our system time is possibly off.
:: following logic from https://stackoverflow.com/a/35626035 (or more exactly, from the linked gist @ https://gist.github.com/thedom85/dbeb58627adfb3d5c3af)
@echo on & @setlocal enableextensions
@echo =========================
@echo Turn off the time service
net stop w32time
@echo ======================================================================
@echo Set the SNTP (Simple Network Time Protocol) source for the time server
w32tm /config /syncfromflags:manual /manualpeerlist:"0.it.pool.ntp.org 1.it.pool.ntp.org 2.it.pool.ntp.org 3.it.pool.ntp.org"
@echo =============================================
@echo ... and then turn on the time service back on
net start w32time
@echo =============================================
@echo Tell the time sync service to use the changes
w32tm /config /update
@echo =======================================================
@echo Reset the local computer's time against the time server
w32tm /resync /rediscover
::pause
@endlocal & @goto :EOF

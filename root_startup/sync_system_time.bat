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
if "%~1"=="" (
    echo No parameters have been provided.
) else (
    echo Parameters: %*
    cd /d %1
)

:: enable delayed expansion, so we can get the updated date-time
setlocal enableextensions EnableDelayedExpansion

rem find remote time:
For /F "tokens=6" %%G In ('%__AppDir__%curl.exe --retry 2 --connect-timeout 3 --max-time 6 -s --insecure --head -- "https://www.google.com" ^| %__AppDir__%findstr.exe /r /i /c:"^Date:"') Do Set "response=%%G"
if "%response%" equ "" (
    @echo looks like remote datetime fetch failed, aborting
    rem pause
    @endlocal & @goto :EOF
)

for /f "tokens=1,2,3 delims=:" %%a in ("%response%") do (
  set REMOTE_HOUR=%%a
  set REMOTE_MIN=%%b
  set REMOTE_SEC=%%c
)
set /a REMOTE_TOTAL="REMOTE_HOUR * 3600 + REMOTE_MIN * 60 + REMOTE_SEC"

rem find local UTC time:
rem wmic usage from https://stackoverflow.com/a/9872111/3344729
rem TODO: comment underneath states WMIC is deprecated!
FOR /F  %%x IN ('wmic path win32_utctime get /format:list ^| findstr.exe /i /r /c:"^Hour=" /c:"^Minute=" /c:"^Second="') DO set %%x
set /a LOCAL_TOTAL="Hour * 3600 + Minute * 60 + Second"

set /a DELTA_1="LOCAL_TOTAL - REMOTE_TOTAL"
set /a DELTA_2="REMOTE_TOTAL - LOCAL_TOTAL"

rem afaik batch doesn't have abs(), hence why we have to compare two deltas:
FOR %%a in (%DELTA_1% %DELTA_2%) DO IF %%a GTR 30 (
    set DELTA_SEC=%%a
    goto :sync_time
)

@endlocal & @goto :EOF


:: Actual work:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
REM start time-sync service. this is especially useful if we've disabled most
REM daemons via ChrisTitusTech/winutil (or other similar debloater) -- otherwise
REM our system time is possibly off.
:: following logic from https://stackoverflow.com/a/35626035 (or more exactly, from the linked gist @ https://gist.github.com/thedom85/dbeb58627adfb3d5c3af)

:sync_time
(
    @echo on
    @echo local v remote time delta is %DELTA_SEC%, starting NTP...

    @echo start: user: %username% @ !date! !time!
        
    @echo =======================================================
    @echo Turn off the time service...
    net stop w32time
    @echo =======================================================
    @echo Set the SNTP source for the time server
    w32tm /config /syncfromflags:manual /manualpeerlist:"0.it.pool.ntp.org 1.it.pool.ntp.org 2.it.pool.ntp.org 3.it.pool.ntp.org"
    @echo =======================================================
    @echo ...and then turn on the time service back on
    net start w32time
    @echo =======================================================
    @echo Tell the time sync service to use the changes
    w32tm /config /update
    @echo =======================================================
    @echo Reset the local computer's time against the time server
    w32tm /resync /rediscover

    @echo end: user: %username% @ !date! !time!
    @echo -------------------------------------------------------------------------------------------
rem )
)  >> C:\Users\%username%\Desktop\sync_time_log.txt
@endlocal & @goto :EOF

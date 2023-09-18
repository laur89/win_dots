REM start time-sync service. this is especially useful if we've disabled most
REM daemons via ChrisTitusTech/winutil (or other similar debloater) -- otherwise
REM our system time is possibly off.
REM 
REM add file to C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
REM from https://stackoverflow.com/a/35626035 (or more exactly, from the linked gist)
REM ---------------------------------
Rem run as administrator
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
REM pause  <-- uncomment for debugging
@endlocal & @goto :EOF

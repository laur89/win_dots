@echo off
rem original ver stolen from https://github.com/koppor/koppors-chocolatey-scripts/blob/master/install.bat; thanks @koppor

echo This will first install chocolatey, then other tools
echo .

pushd %SystemRoot%
openfiles.exe 1>nul 2>&1
if %errorlevel% neq 0 (
    echo needs to be run as admin, abort
    pause
    exit 1
)
popd


rem SET mypath=%~dp0
rem SET mypath=%mypath:~0,-1%
SET dest=%userprofile%\dev

where choco.exe 1>nul 2>&1
if %errorlevel% neq 0 (
    rem chocolatey is not installed, do it; from: https://github.com/chocolatey/choco/wiki/Installation
    ::download install.ps1
    %systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command^
     "((new-object net.webclient).DownloadFile('https://chocolatey.org/install.ps1','%TEMP%\install.ps1'))"
    ::run installer
    %systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command^
     "& '%TEMP%\install.ps1' %*"

    rem IF EXIST %ALLUSERSPROFILE%\chocolatey\bin SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
)

where choco.exe 1>nul 2>&1
if %errorlevel% neq 0 (
    echo choco installation failed?
    pause
    exit 1
)

choco feature enable -n=allowGlobalConfirmation

rem first need to install git in order to pull config files:
choco install git.install --params "/GitAndUnixToolsOnPath"
call refreshenv

git config --global diff.indentHeuristic true
git config --global color.diff.new "green bold"
git config --global color.status.updated "green bold"
git config --global color.branch.current "green bold"
git config --global core.longpaths true
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256
git config --global core.commitGraph true

rem pull our dotfiles:
md "%dest%"
git clone https://github.com/laur89/win_dots.git "%dest%/"
echo done
pause
exit1





SET ahk_launcher=%dest%\ahk\ahk-launcher.ahk
if not exist "%ahk_launcher%" (
    echo [%ahk_launcher%] doesn't exist - are you sure installer is in expected location?
    echo or where dotfiles successfully pulled?
    pause
    exit 1
)

rem install ahk script that'll be auto-starting apps during system startup:
mklink "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\ahk-launcher" "%ahk_launcher%"

rem apply regedits:
regedit.exe /s "%dest%\reg\caps-as-esc.reg"
regedit.exe /s "%dest%\reg\disable-winkey-shortcuts.reg"


choco install keepassxc

choco install clink
rem enable normal files also to be treated as executable - see https://github.com/mridgers/clink/issues/311#issuecomment-95330570
rem clink set exec_match_style -1

choco install autohotkey.install
rem Needs to be installed after a reboot:
rem choco install qttabbar 

choco install sublimetext3 
choco install vscode

rem choco install jdk8 jre8
rem choco install jetbrainstoolbox
rem choco pin add -n=jetbrainstoolbox

rem choco install lockhunter
rem choco install windirstat
rem choco install sysinternals
rem choco install procexp
rem choco install procmon
choco install autoruns

rem disabled, because it depends on powershell, which is provided by Windows itself:
rem choco install poshgit


rem choco install 7zip

choco install fiddler
rem choco install p4merge

rem choco install f.lux
rem choco install teamviewer
rem choco install vlc

rem enable editing the Outlook auto completion
rem choco install nk2edit.install

rem choco install docker-for-windows 

rem This allows to burn ISOs - see https://rufus.akeo.ie/:
rem choco install rufus

rem requires restart:
rem choco install adobereader

goto END

rem These packages require manual intervention
choco install veracrypt

rem koppor's special tools

choco install foobar2000 opencodecs

rem koppor's very special tools
choco install pandoc
choco install xmlstarlet
choco install jq

rem Manually: msys2

:END

echo To keep your system updated, run update-all.bat regularly from an administrator CMD.exe.
echo .
echo Follow the steps described at http://tech.brookins.info/2015/11/07/my-git-setup-in-windows.html to get git running with putty and an SSH key
echo Optional: Afterwards, follow the instructions at https://github.com/tj/git-extras/blob/master/Installation.md#windows to install git-extras
echo .
pause

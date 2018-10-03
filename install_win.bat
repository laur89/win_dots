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
    @"powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command^
     "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

    :: sanity:
    where choco.exe 1>nul 2>&1
    if %errorlevel% neq 0 (
        echo choco installation failed?
        pause
        exit 1
    )
)

choco feature enable -n=allowGlobalConfirmation

choco install cygwin
:: choco install cygwin --params "/InstallDir:C:\cygwin"
choco install cyg-get
call cyg-get curl zip unzip

choco install git.install --params "/GitAndUnixToolsOnPath"
if not exist "%userprofile%\.gitconfig" (
    :: most likely our first run, add temporary git settings until config is pulled:
    git config --global core.safecrlf true
    git config --global core.autocrlf input
    git config --global http.sslVerify false
)
call refreshenv

rem pull our dotfiles & private config:
md "%dest%"
call:cloneOrPull https://github.com/laur89/win_dots.git "%dest%\win_dots"
::git clone https://github.com/laur89/win_dots.git "%dest%\win_dots"
SET dots=%dest%\win_dots
SET work_dots=%dest%\work_dotfiles

echo !!!! PULLING PRIVATE DOTS !!!!
::cloneOrPull https://bitbucket.org/layr/private-common.git "%dest%\private-common"
call:cloneOrPull https://git.nonprod.williamhill.plc/laliste/work_dotfiles.git "%work_dots%"

rem link ssh/:
SET ssh_loc=%work_dots%\ssh
if not exist "%ssh_loc%" (
    echo [%ssh_loc%] doesn't exist!
    echo won't abort
    pause
) else (
    call:mkl "%userprofile%\.ssh" "%ssh_loc%"
)

rem link dotfiles to ~/:
rem first from common dots...
SET homedots=%dots%\home
if exist "%homedots%\*" (
    rem pushd "%homedots%"
    rem for %%i in (*) do mklink /d "%userprofile%\" "%%i"
    rem popd
    
    rem TODO: will break with spaces:
    forfiles /P "%homedots%" /C "cmd /c if @isdir==TRUE ( rmdir /s /q \"%userprofile%\@file\" & mklink /d \"%userprofile%\@file\" @path ) else ( del /q \"%userprofile%\@file\" & mklink \"%userprofile%\@file\" @path )"
    rem forfiles /P "%homedots%" /C "cmd /c if @isdir==TRUE ( if exist \"%userprofile%\@file\" ( rmdir /s /q \"%userprofile%\@file\" ) & mklink /d \"%userprofile%\@file\" @path )"
    rem forfiles /P "%homedots%" /C "cmd /c if @isdir==TRUE ( if exists \"%userprofile%\@file\" ( del /s /q \"%userprofile%\@file\" ) & mklink \"%userprofile%\@file\" @path )"
    rem forfiles /P "%homedots%" /C "cmd /c if @isdir==TRUE ( if exists \"@path\*\" ( rmdir /s /q \"@path\" ) & mklink /d \"%userprofile%\@file\" @path ) else ( if exists \"@path\" ( del /s /q \"@path\" ) & mklink \"%userprofile%\@file\" @path )"
)
rem ...followed by work dots:
SET homedots=%work_dots%\home
SET "managed_work_dots=.m2 .bash_aliases_overrides .bash_env_vars_overrides .bash_funs_overrides .npmrc .cx_config"
if exist "%homedots%\*" (
    for %%s in (%managed_work_dots%) do call:mkl "%userprofile%\%%s" "%homedots%\%%s"
) else (
    echo [%homedots%] doesn't exist! won't symlink dotfiles from [%homedots%\]
    pause
)


SET ahk_launcher=%dots%\ahk\ahk-launcher.ahk
if exist "%ahk_launcher%" (
    rem install ahk script that'll be auto-starting apps during system startup:
    call:mkl "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\ahk-launcher" "%ahk_launcher%"
)

rem apply regedits:
if exist "%dots%\reg\*" (
    regedit.exe /s "%dots%\reg\caps-as-esc.reg"
)

rem ############################################
choco install gitkraken
choco install keepassxc

choco install clink
rem enable normal files also to be treated as executable - see https://github.com/mridgers/clink/issues/311#issuecomment-95330570
rem clink set exec_match_style -1

choco install autohotkey.install
rem Needs to be installed after a reboot:
rem choco install qttabbar 

choco install sublimetext3 
choco install vscode
choco install greenshot
choco install ditto

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

rem ############################################
rem additional links & post-install config:
SET cyg_homedir=C:\tools\cygwin\home\%USERNAME%
if exist "%cyg_homedir%\*" (
    for %%s in (".gitconfig" ".bashrc" ".inputrc" ".ssh" ".bash_aliases" ".bash_env_vars" ".bash_functions") do call:mkl "%cyg_homedir%\%%s" "%userprofile%\%%s"
    for %%s in (%managed_work_dots%) do call:mkl "%cyg_homedir%\%%s" "%userprofile%\%%s"
) else (
    echo [%cyg_homedir%] doesn't exist! won't symlink dotfiles from [%userprofile%\]
    pause
)


rem ############################################
echo To keep your system updated, run update-all.bat regularly from an administrator CMD.exe.
echo .
pause

GOTO:EOF
rem ############################################
:: Funcs
rem ############################################


:rm    -- remove file or dir if exists
::                 -- %~1: file or dir to delete
SETLOCAL
set "f=%~1"

if exist "%f%\*" (
    rmdir /s /q "%f%"
) else if exist "%f%" (
    del /q "%f%"
)

ENDLOCAL
GOTO:EOF


:mkl    -- create link; target is deleted beforehand if it already exists.
::                 -- %~1: target link to file
::                 -- %~2: source file/dir to create link for
SETLOCAL
set "t=%~1"
set "s=%~2"

call:rm "%t%"

:: sanity:
if exist "%t%" (
    echo "error: link target [%t%] already exists - did rm() fail?"
    pause
    exit
)

if exist "%s%\*" (
    mklink /d "%t%" "%s%"
) else if exist "%s%" (
    mklink "%t%" "%s%"
) else (
    echo "unable to link - source [%s%] doesn't exist! (wont't abort)"
    pause
)

ENDLOCAL
GOTO:EOF


:cloneOrPull    -- clone or pull repo
::                 -- %~1: https url of repo to clone
::                 -- %~2: repo's target dir (local)
SETLOCAL
set "repo=%~1"
set "target_dir=%~2"

if exist "%target_dir%\*" (
    pushd "%target_dir%"
    git pull
    if %errorlevel% neq 0 (
        :: first pull failed, let's retry...
        git pull
    )
    
    rem TODO check err lvl
    popd
) else if exist "%target_dir%" (
    echo [%target_dir%] already exists, but is not a dir; cannot clone into it. abort.
    pause
    exit 1
) else (
    git clone "%repo%" "%target_dir%"
    rem TODO check err lvl
)

ENDLOCAL
GOTO:EOF

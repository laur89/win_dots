@echo off
rem original ver stolen from https://github.com/koppor/koppors-chocolatey-scripts/blob/master/install.bat  -- thanks @koppor
rem -- to upgrade choco pkgs only, run      $ choco upgrade all
rem TODO: consider boxstarter

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
SET dots=%dest%\win_dots
SET private_dots=%dest%\private_dots

where choco.exe 1>nul 2>&1
if %errorlevel% neq 0 (
    rem chocolatey is not installed, do it; from: https://chocolatey.org/install
    powershell -NoProfile -ExecutionPolicy Bypass -Command^
     "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"^
     && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

    :: sanity:
    where choco.exe 1>nul 2>&1
    if %errorlevel% neq 0 (
        echo choco pkg manager installed - please restart the script
        pause
        exit 0
    )
)
    
choco feature enable -n=allowGlobalConfirmation

choco install cygwin
:: choco install cygwin --params "/InstallDir:C:\cygwin"
choco install cyg-get
:: TODO: cyg-get should be only called form cygwin terminal?:
call cyg-get curl zip unzip bash tar gzip jq

rem All arguments are listed at https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/git.install/ARGUMENTS.md
choco install git.install --params "/GitAndUnixToolsOnPath /WindowsTerminal /WindowsTerminalProfile"
call refreshenv

:: remvove .gitconfig in case it's dead symlink; in that case subsequent git commands would fail;  # TODO find out how to detect dead symlinks! (note the commented out block below does not work)
call:rm "%userprofile%\.gitconfig"
::if exist "%userprofile%\.gitconfig" (
::    fsutil file queryfileid "%userprofile%\.gitconfig" 2> nul
::    if %ERRORLEVEL% neq 0 (
::        :: we have dead link, make sure to remove it! otherwise our git commands will fail!
::        echo yooo gonna delete gitconfig link
::        pause
::        call:rm "%userprofile%\.gitconfig"
::        echo yooosup rm called
::        pause
::    )
::)

if not exist "%userprofile%\.gitconfig" (
    :: most likely our first run, add temporary git settings until config is pulled:
    git config --global core.safecrlf true
    :: rem always have Linux line endings in text files:
    git config --global core.autocrlf input
    ::git config --global http.sslVerify false

    rem support more than 260 characters on Windows
    rem See https://stackoverflow.com/a/22575737/873282 for details
    git config --global core.longpaths true
)

rem pull our dotfiles & private config:
md "%dest%"
call:cloneOrPull https://github.com/laur89/win_dots.git "%dots%"

echo !!!! PULLING PRIVATE DOTS !!!!
cloneOrPull https://bitbucket.org/layr/private-common.git "%private_dots%"

rem link dotfiles to ~/:
rem first from common/win dots...
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

rem ...followed by private dots:
SET homedots=%private_dots%\home
SET "managed_private_dots=.ssh"
if exist "%homedots%\*" (
    for %%s in (%managed_private_dots%) do call:mkl "%userprofile%\%%s" "%homedots%\%%s"
) else (
    echo [%homedots%] doesn't exist! won't symlink dotfiles from [%homedots%\]
    pause
)


SET ahk_launcher=%dots%\ahk\ahk-launcher.ahk
if exist "%ahk_launcher%" (
    rem install ahk script that'll be auto-starting apps during system startup:
    call:mkl "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\ahk-launcher" "%ahk_launcher%"
)

rem apply regedits: (disabled now as we get the function for free via UHK)
::if exist "%dots%\reg\*" (
::    regedit.exe /s "%dots%\reg\caps-as-esc.reg"
::)

rem ############################################
rem choco install p4merge
choco install keepassxc

rem Enable bash shortcuts
rem https://chrisant996.github.io/clink/
choco install clink-maintained
rem enable normal files also to be treated as executable - see https://github.com/mridgers/clink/issues/311#issuecomment-95330570
rem clink set exec_match_style -1

choco install autohotkey.install
rem Needs to be installed after a reboot:
rem choco install qttabbar 

choco install neovim
rem choco install neovide
choco install greenshot
choco install obs-studio
choco install fzf
rem choco install wsltty

rem choco install jetbrainstoolbox
rem choco pin add -n=jetbrainstoolbox

rem choco install lockhunter
rem choco install windirstat
rem choco install sysinternals
rem choco install procexp
rem choco install procmon
rem choco install autoruns

rem disabled, because it depends on powershell, which is provided by Windows itself:
rem choco install poshgit


rem choco install 7zip

choco install firefox
choco install steam
choco install ea-app
choco install discord
choco install signal
choco install copyq
rem choco install fiddler
choco install altdrag
choco install lghub


rem Context menu for Windows Explorer to offer "Copy Unix Path", "Copy Long UNC Path", ...
rem https://pathcopycopy.github.io/
choco install path-copy-copy

rem choco install erlang
rem choco install rebar3

choco install python
rem choco install python --version 3.6.8 
rem choco install pip

rem choco install zulu8
rem choco install jdk8 jre8


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
choco install vscode
choco install sublimetext4

rem Manually: msys2

:END

rem ############################################
rem additional links & post-install config:
rem NOTE!: C:\tools\cygwin\home\%USERNAME% is populated/created only after the first time you open cygwin shell!
SET cyg_homedir=C:\tools\cygwin\home\%USERNAME%
if exist "%cyg_homedir%\*" (
    for %%s in (".gitconfig" ".bashrc" ".inputrc" ".ssh" ".bash_aliases" ".bash_env_vars" ".bash_functions") do call:mkl "%cyg_homedir%\%%s" "%userprofile%\%%s"
    for %%s in (%managed_private_dots%) do call:mkl "%cyg_homedir%\%%s" "%userprofile%\%%s"
) else (
    echo [%cyg_homedir%] doesn't exist - open cygwin shell & restart script; won't symlink dotfiles from [%userprofile%\]
    pause
)


rem ############################################
echo .
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

if exist "%f%" (
    :: make sure to first rmdir, _then_ del; otherwise if %f% is a symlink to a dir,
    :: then del would first remove all the regular files in target!
    rmdir /s /q "%f%" 2> nul
    if exist "%f%" (
        :: assuming it's regular file:
        del /q "%f%" 2> nul
    )
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
    echo "error: link target [%t%] already exists - did rm() fail? aborting."
    pause
    exit
)

:: TODO: improve logic for is-directory checking
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
        if %errorlevel% neq 0 (
            echo pulling [%repo%] in [%target_dir%] failed; won't abort, but check that out :(
            pause
       )
    )
    
    popd
) else if exist "%target_dir%" (
    echo [%target_dir%] already exists, but is not a dir; cannot clone into it. abort.
    pause
    exit 1
) else (
    git clone "%repo%" "%target_dir%"
    if %errorlevel% neq 0 (
        echo cloning [%repo%] failed; won't abort, but check what's up
        pause
    )
)

ENDLOCAL
GOTO:EOF

@echo off
rem original ver stolen from https://github.com/koppor/koppors-chocolatey-scripts/blob/master/install.bat; thanks @koppor
rem -- to upgrade choco pkgs only, run      $ choco upgrade all

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
:: TODO: cyg-get should be only called form cygwin terminal?:
call cyg-get curl zip unzip bash tar gzip jq

choco install git.install --params "/GitAndUnixToolsOnPath"

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
SET "managed_work_dots=.m2 .bash_aliases_overrides .bash_env_vars_overrides .bash_funs_overrides .npmrc .cx_config .ssh"
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
rem choco install p4merge
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
choco install obs-studio
choco install ditto
choco install fzf
choco install wsltty

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
choco install altdrag

choco install erlang
choco install rebar3

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

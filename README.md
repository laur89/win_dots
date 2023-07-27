# win_dots

## to install win11 without linking to MS account (and getting to choose your account name):
- after selecting keeb layout, press `Shift+F10` & type `OOBE\BYPASSNRO` 

windows setup &amp; bootstrapping

- download `install_win.bat` and run as admin (ie right click -> admin); note
  it's important to just download the file instead of git clone - otherwise the
  linefeeds might be hecked up; so just pull the file and remove it afterwards;
  later on you can run it from now-pulled `win_dots/` (ie this repo).
- if git clone is giving you error:

    ```
    remote: HTTP Basic: Access denied fatal: Authentication failed for
    ```

  then you've likely changed your windows/GroupAD password, and that needs to
  [be updated in Windows Credential Manager](https://stackoverflow.com/a/52092795/1803648)

--------------

## After clean win installation checklist:

- activate using [massgravel/Microsoft-Activation-Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)
- declutter/debloat using [ChrisTitusTech/winutil](https://github.com/ChrisTitusTech/winutil)
  - import our settings from `winutil-settings.json` file in this repo
  - alternative debloater tool: [builtbybel/BloatyNosy](https://github.com/builtbybel/BloatyNosy)
  - okayish reddit
    [thread](https://www.reddit.com/r/Windows11/comments/124vxsv/should_i_debloat_my_new_windows_11_laptop_how/)
    on the debloating subject


## WSL2 quickstart (all commands from posh, admin only needed for install):

Instructions taken mainly from [MS WSL2 installation guide](https://learn.microsoft.com/en-us/windows/wsl/install)

- to see list of available distors, run `wsl --list --online`
- to see list of _installed_ distros, run `wsl -l -v`
- to set default linux distro used w/ `wsl` command, run `wsl --setdefault Debian`;
  now running `wsl npm init` will run `npm init` in debian

1. open posh in admin mode and run `wsl --install -d Debian`
  - this command can be re-ran to install other distros
1. follow [this MS best practices for setup](https://learn.microsoft.com/en-us/windows/wsl/setup/environment#set-up-your-linux-username-and-password)
1. `sudo apt-get update`
1. `sudo apt-get install ca-certificates openssh-client`
1. follow instructions from /dotfiles:
   - `wget ...raw//wanted-branch/...install_system.sh`
   - (likely last step, confirm): `./install_system <mode>`

+ other useful tips:
  - [basic WSL commands](https://learn.microsoft.com/en-us/windows/wsl/basic-commands)
  - [windows terminal setup/config](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/startup)
  - maybe check [this SO question for vcxsrv usage under wsl2](https://stackoverflow.com/questions/66768148/how-to-setup-vcxsrv-for-use-with-wsl2)
  - another useful [vcxsrv thread](https://superuser.com/questions/1372854/do-i-launch-the-app-xlaunch-for-every-login-to-use-gui-in-ubuntu-wsl-in-windows)

## misc

- importing jdk cert to jdk in posh:
`.\keytool.exe -import -alias "my cert alias" -keystore  C:\tools\cygwin\home\laur89\.sdkman\candidates\java\8.0.181-zulu\jre\lib\security\cacerts -file C:\tools\cygwin\mycert.crt`
 (didn't work from cygwin like: `$JAVA_HOME/bin/keytool -import -file cert.crt -keystore C:\tools\cygwin\home\laliste\.sdkman\candidates\java\8.0.181-zulu\jre\lib\security\cacerts -alias "my cert alias"`)
- to hide a local drive from windows, see [this SO answer](https://superuser.com/a/944926/179401);
  same info is also included in this [makeuseof](https://www.makeuseof.com/how-to-hide-a-drive-in-windows/) article

### TODO:
1. yarn repo addition causes `apt-get update` to hang;


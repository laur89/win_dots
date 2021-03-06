# win_dots
windows setup &amp; bootstrapping

- download `install_win.bat` and run as admin (ie right click -> admin); note
  it's important to just download the file instead of git clone - otherwise the
  linefeeds might be hecked up; so just pull the file and remove it afterwards;
  later on you can run it from now-pulled `win_dots/` (ie this repo).
- if git clone is giving you error

    remote: HTTP Basic: Access denied fatal: Authentication failed for

  then you've likely changed your windows/GroupAD password, and that needs to
  [be updated in Windows Credential Manager](https://stackoverflow.com/a/52092795/1803648)

--------------
## WSL quickstart (all commands from posh, no admin needed):

**!TODO: [WSL2 is out](https://docs.microsoft.com/en-us/windows/wsl/install-win10), review the process!!**

1. unregister previous installation, if applicable: `wslconfig.exe /unregister Debian`
  - TODO: `wslconfig.exe` has been deprecated for `wsl.exe` as per [this post](https://github.com/microsoft/WSL/issues/3499#issuecomment-786262070)
1. `Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile debian.appx -UseBasicParsing`
1. `Rename-Item .\debian.appx debian.zip`
1. `Expand-Archive .\debian.zip 'C:\distros\debian'`
1. `cd C:\distros\debian\`
1. `.\debian.exe` (or just `..\..\distros\debian\debian.exe`)

1. `sudo apt-get update`
1. `sudo apt-get install ca-certificates openssh-client`
1. follow instructions from /dotfiles:
   - `wget ...raw//wanted-branch/...install_system.sh`
   - (likely last step, confirm): `./install_system <mode>`

## misc
- importing jdk cert to jdk in posh:
`.\keytool.exe -import -alias "my cert alias" -keystore  C:\tools\cygwin\home\laur89\.sdkman\candidates\java\8.0.181-zulu\jre\lib\security\cacerts -file C:\tools\cygwin\mycert.crt`
 (didn't work from cygwin like: `$JAVA_HOME/bin/keytool -import -file cert.crt -keystore C:\tools\cygwin\home\laliste\.sdkman\candidates\java\8.0.181-zulu\jre\lib\security\cacerts -alias "my cert alias"`)

### TODO:
1. yarn repo addition causes `apt-get update` to hang;

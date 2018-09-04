# win_dots
windows config &amp; bootstrapping logic

download `install_win.bat` and run as admin.

--------------
# WSL quickstart (all commands from posh, no admin needed):

1. unregister previous installation, if applicable: `wslconfig.exe /unregister Debian`
1. `Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile debian.appx -UseBasicParsing`
1. `Rename-Item .\debian.appx debian.zip`
1. `Expand-Archive .\debian.zip 'C:\distros\debian'`
1. `cd C:\distros\debian\`
1. `.\debian.exe`

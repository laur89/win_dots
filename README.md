# win_dots

Download windows image from [here](https://www.microsoft.com/en-us/download/windows)

## to install win11 without linking to MS account (and getting to choose your account name):

### first method (as of '25) [from this thread](https://www.reddit.com/r/sysadmin/comments/1jmgkfk/microsoft_is_removing_the_bypassnro_command_from/mkgjurm/)
- after selecting keeb layout, press `Shift+F10` & type `OOBE\BYPASSNRO` 
  - note it's not right after you've first booted from the USB; first the setup
    will have to copy the files to our installation drive, only after the first
    (couple) reboots we can do this step;
  - **actually unsure whether this is needed... looks like this bypass can be
    launched at the very beginning?**
- type `start ms-cxh:localonly`
- this pulls up local user creation form

### second account bypass method from abovementioned reddit thread:
- instead, try: (requires Pro version!)
    - choose `work or school account`
    - select `sign-in options` where is opt to `domain-join this device instead`

### deprecated method not working as of '25:
- after selecting keeb layout, press `Shift+F10` & type `OOBE\BYPASSNRO` 
  - note it's not right after you've first booted from the USB; first the setup
    will have to copy the files to our installation drive, only after the first
    (couple) reboots we can do this step;
  - don't forget to unplug eth cable!
  - **as of 2025**: [this reddit post](https://www.reddit.com/r/sysadmin/comments/1jmgkfk/microsoft_is_removing_the_bypassnro_command_from/)
    claims this feature is removed


## windows setup &amp; bootstrapping

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

---

## After clean win installation checklist:

- activate using [massgravel/Microsoft-Activation-Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)
- declutter/debloat using [ChrisTitusTech/winutil](https://github.com/ChrisTitusTech/winutil)
  - import our settings from `winutil-settings.json` file in this repo
  - alternative debloater tool: [builtbybel/BloatyNosy](https://github.com/builtbybel/BloatyNosy)
  - okayish reddit
    [thread](https://www.reddit.com/r/Windows11/comments/124vxsv/should_i_debloat_my_new_windows_11_laptop_how/)
    on the debloating subject
- run `dotter.exe deploy --force` from win_dots/dotter  (--force to overwrite existing files)

## To execute programs/script as root/admin on startup (from [here](https://superuser.com/a/1005216/716639)):

- see [root_startup/](root_startup/)


## WSL2 quickstart (all commands from posh, admin only needed for install):

Instructions taken mainly from [MS WSL2 installation guide](https://learn.microsoft.com/en-us/windows/wsl/install)

1. open posh in admin mode and run `wsl --install -d Debian`
  - prompt will ask you to reboot the system
  - this command can be re-ran to install other distros
1. follow [this MS best practices for setup](https://learn.microsoft.com/en-us/windows/wsl/setup/environment#set-up-your-linux-username-and-password)
1. `sudo apt-get --allow-releaseinfo-change update`
1. `sudo apt-get upgrade --without-new-pkgs`
1. `sudo apt-get dist-upgrade`
1. `sudo apt-get install ca-certificates openssh-client`
1. follow instructions from /dotfiles:
   - `wget ...raw//wanted-branch/...install_system.sh`
   - (likely last step, confirm): `./install_system <mode>`

+ other useful tips:
  - [basic WSL commands](https://learn.microsoft.com/en-us/windows/wsl/basic-commands)
  - [windows terminal setup/config](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/startup)
  - maybe check [this SO question for vcxsrv usage under wsl2](https://stackoverflow.com/questions/66768148/how-to-setup-vcxsrv-for-use-with-wsl2)
  - another useful [vcxsrv thread](https://superuser.com/questions/1372854/do-i-launch-the-app-xlaunch-for-every-login-to-use-gui-in-ubuntu-wsl-in-windows)
  - to see list of available distors, run `wsl --list --online`
  - to see list of _installed_ distros, run `wsl -l -v`
  - to set default linux distro used w/ `wsl` command, run `wsl --setdefault Debian`;
    now running `wsl npm init` will run `npm init` in debian;
  - note as of WSL2 it's possible to run GUI programs without vcxsrv and the
    likes: https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps#run-linux-gui-apps !!!!
    - gh: https://github.com/microsoft/wslg
    - this feature uses `WSLg`; (looks like it's been merged w/ wsl2)
    - looks like WSLg [ships Weston w/ a built-in window manager that can't be replaced](https://github.com/microsoft/wslg/issues/47#issuecomment-825378818),
      meaning no full desktop experience like i3;
    - however [this gh comment](https://github.com/microsoft/wslg/issues/47#issuecomment-862026696)
      suggests running nested xserver (Xephyr), which _sort of_ works;
    - [troubleshooting issues w/ WSLg](https://github.com/microsoft/wslg/wiki/Diagnosing-%22cannot-open-display%22-type-issues-with-WSLg)
  - WSL doesn't support systemd; if it's really needed, see [here](https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl)
  - [setup for starting win manager/forwarding x11](https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2) 
  - potentially useful xserver-related topics:
    - https://github.com/microsoft/WSL/issues/5339
    - https://www.reddit.com/r/bashonubuntuonwindows/comments/m14puc/x_server_with_vpn_connected_via_wsld_wsl_daemon/
    - [instructions on preserving x11 connection through
      sleep/hibernation/VPN](https://www.reddit.com/r/bashonubuntuonwindows/comments/m14puc/x_server_with_vpn_connected_via_wsld_wsl_daemon/)
  - [share env vars between WSL and windows](https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/)
  - [blog post on how to fwd ssh agent requests from wsl to windows](https://stuartleeks.com/posts/wsl-ssh-key-forward-to-windows/)

## misc

- importing jdk cert to jdk in posh:
`.\keytool.exe -import -alias "my cert alias" -keystore  C:\tools\cygwin\home\laur89\.sdkman\candidates\java\8.0.181-zulu\jre\lib\security\cacerts -file C:\tools\cygwin\mycert.crt`
 (didn't work from cygwin like: `$JAVA_HOME/bin/keytool -import -file cert.crt -keystore C:\tools\cygwin\home\laliste\.sdkman\candidates\java\8.0.181-zulu\jre\lib\security\cacerts -alias "my cert alias"`)
- to hide a local drive from windows, see [this SO answer](https://superuser.com/a/944926/179401);
  same info is also included in this [makeuseof](https://www.makeuseof.com/how-to-hide-a-drive-in-windows/) article
  - actually what I did was simply right click -> 'disable' in Device Manager
- if you see `PCI Memory Controller` and/or `SM Bus Controller` driver issues
  under Control Panel (as described in [this reddit thread](https://www.reddit.com/r/WindowsHelp/comments/q2gguu/pci_memory_controller_sm_bus_controller_errors/)),
  you likely need to install [Intel Chipset INF Utility](https://www.intel.com/content/www/us/en/download/19347/chipset-inf-utility.html);
  ofc this assumes you're on Intel chipset.
- for gaming, avoid windows `N` versions; otherwise you'll see many errors with
  games that will require you to install missing components; eg if launching
  a game you're greeted w/ `Please reinstall the program - DSOUND.dll`
  error/message, you need to install "media feature pack":
    `->  settings -> apps -> optional features -> add an optional feature - view features -> meadia feature pack.`


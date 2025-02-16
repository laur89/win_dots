; to be executed by symlink in %appdata%...\Startup dir;
; this script is likely managed by a system setup script,
; so be careful when changing filename.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; give some time so we could stop faulty scripts at startup:
Sleep, 2500

Run "%A_AHKPath%" "%A_ScriptDir%\key-remap.ahk"
Run "%A_AHKPath%" "%A_ScriptDir%\window-management.ahk"
Run wt  -w _quake powershell -nologo -window minimized

Run powershell -NoProfile -nologo -ExecutionPolicy Bypass -File "%A_ScriptDir%\..\scripts\launch-snapkey.ps1"
Run powershell -NoProfile -nologo -ExecutionPolicy Bypass -File "%A_ScriptDir%\..\scripts\pubg-maintenance.ps1"
;Run powershell -NoProfile -nologo -ExecutionPolicy Bypass -File "%A_ScriptDir%\..\scripts\launch-steam-game-cli.ps1"

; note conhost (and also -WindowStyle hidden opt) are for hiding the terminal window -- only the Form GUI should be visible.
; this idea from https://www.reddit.com/r/PowerShell/comments/1cxeirf/how_do_you_completely_hide_the_powershell/l525neq/
; note as of 2024 it still required additional hiding from script itself: https://stackoverflow.com/a/75919843/3344729
Run conhost  powershell -NonInteractive -NoProfile -nologo -WindowStyle hidden -ExecutionPolicy Bypass -File "%A_ScriptDir%\..\scripts\launch-steam-game-gui.ps1"

; prep env for VcXsrv & launch it:
;Run "%A_AHKPath%" "%A_ScriptDir%\xserver-prep.ahk"
;Run "%A_ScriptDir%\..\config.xlaunch"

ExitApp


; auto-create auto-startup link:
; (note A_Startup likely expands to C:\Users\laur\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
;FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\My AHK Script.lnk, %A_ScriptDir%

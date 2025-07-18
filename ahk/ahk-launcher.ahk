#Requires AutoHotkey v2
#SingleInstance Force
ListLines(0), KeyHistory(0)
ProcessSetPriority("High")

#Include "%A_ScriptDir%\funcs.ahk"

; to be executed by symlink in %appdata%...\Startup dir;
; this script is likely managed by a system setup script,
; so be careful when changing filename.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; give some time so we could stop faulty scripts at startup:
Sleep 2500


Run '"' A_AHKPath '" "' A_ScriptDir '\key-remap.ahk"'
Run '"' A_AHKPath '" "' A_ScriptDir '\window-management.ahk"'
Run '"' A_AHKPath '" "' A_ScriptDir '\disable-super-key.ahk"'

; set exec policy, so our custom posh profiles (e.g. ~/Documents/WindowsPowerShell/Profile.ps1) can be loaded: (from https://stackoverflow.com/a/79403172)
Run 'powershell -NonInteractive -NoProfile -nologo -window minimized -WindowStyle hidden Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser'

Run 'powershell -NoProfile -nologo -window minimized -WindowStyle hidden -ExecutionPolicy Bypass -File "' A_ScriptDir '\..\scripts\launch-snapkey.ps1"'
Run 'powershell -NoProfile -nologo -window minimized -WindowStyle hidden -ExecutionPolicy Bypass -File "' A_ScriptDir '\..\scripts\pubg-maintenance.ps1"'

;Run 'powershell -NoProfile -nologo -ExecutionPolicy Bypass -File "' A_ScriptDir '\..\scripts\launch-steam-game-cli.ps1"'

; !! for hidden terminal, see also https://github.com/stax76/run-hidden project
;    also https://github.com/MScholtes/PS2EXE to compile posh to exe
; note conhost (and also -WindowStyle hidden opt) are for hiding the terminal window -- only the Form GUI should be visible.
; this idea from https://www.reddit.com/r/PowerShell/comments/1cxeirf/how_do_you_completely_hide_the_powershell/l525neq/
; note as of 2024 it still required additional hiding from script itself: https://stackoverflow.com/a/75919843/3344729
Run 'conhost  powershell -NonInteractive -NoProfile -nologo -window minimized -WindowStyle hidden -ExecutionPolicy Bypass -File "' A_ScriptDir '\..\scripts\launch-steam-game-gui.ps1"'

; prep env for VcXsrv & launch it:
;Run '"' A_AHKPath '" "' A_ScriptDir '\super-L-idle-lock.ahk"'
;Run A_ScriptDir "\..\config.xlaunch"

; initialize our quake-term: {  # commented out as it tends to leave bunch of empty terminal windows at boot time, at least w/ komorebi WM
;Run "wt -w _quake powershell -nologo -NoExit -command `"`$Host.UI.RawUI.WindowTitle = '__quake_term'`""  ; old ver not utilizing posh-with-window-title
;Run 'wt -w _quake powershell -nologo -NoExit -File "' A_ScriptDir '\posh-with-window-title.ps1" __quake_term'
;Sleep 2000
;InitQuakeTerm("__quake_term")
;WinMinimize "__quake_term"
; } /quake-term

ExitApp


; auto-create auto-startup link:
; (note A_Startup likely expands to C:\Users\laur\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
;FileCreateShortcut A_ScriptFullPath, A_Startup "\My AHK Script.lnk", A_ScriptDir

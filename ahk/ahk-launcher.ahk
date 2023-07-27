; to be executed by symlink in %appdata%...\Startup dir;
; this script is likely managed by a system setup script,
; so be careful when changing filename.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; give some time so we could stop faulty scripts at startup:
Sleep, 10000

Run "%A_AHKPath%" "%A_ScriptDir%\key-remap.ahk"
Run wt  -w _quake powershell -nologo -window minimized

; prep env for VcXsrv & launch it:
;Run "%A_AHKPath%" "%A_ScriptDir%\xserver-prep.ahk"
;Run "%A_ScriptDir%\..\config.xlaunch"

ExitApp


; auto-create auto-startup link:
;FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\My AHK Script.lnk, %A_ScriptDir%

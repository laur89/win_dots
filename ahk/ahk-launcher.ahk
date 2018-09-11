; to be executed by symlink in %appdata%...\Startup dir
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Run "%A_AHKPath%" "%A_ScriptDir%\xserver-prep.ahk"
Run "%A_AHKPath%" "%A_ScriptDir%\key-remap.ahk"

Run "%A_ScriptDir%\..\config.xlaunch"

ExitApp


; auto-create auto-startup link:
;FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\My AHK Script.lnk, %A_ScriptDir%
full_command_line := DllCall("GetCommandLine", "str")

; restart script as admin, if not already:
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

;MsgBox A_IsAdmin: %A_IsAdmin%`nCommand line: %full_command_line%


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; from https://superuser.com/questions/726988/how-to-remap-a-program-to-lock-windows-winl/727170#727170
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; WARNING: Programs that use User32\LockWorkStation (i.e. programmatically locking the operating system) may not work correctly! 
  ; This includes Windows itself (i.e. using start menu or task manager to lock will also not work).
  ; Script changes Win-L to show a msgbox and Ctrl-Alt-L to lock windows

  ; The following 3 code lines are auto-executed upon script run, the return line marks an end to the auto-executed code section.
  ; Register user defined subroutine 'OnExitSub' to be executed when this script is terminating
  OnExit, OnExitSub

  ; Disable LockWorkStation, so Windows doesn't intercept Win+L and this script can act on that key combination 
  SetDisableLockWorkstationRegKeyValue( 1 )
return

#l::
  MsgBox, Win-L was pressed! ; Arbitrary code here
  ;Send {^}{+}{F11}
  ;Send {LWin Up}{Control}{Shift}{F11}
  ;Send {Win Up}
  ;SendInput {F11}
return

#e::
  MsgBox, Win-EEEEE was pressed! ; Arbitrary code here
  ;Send {^}{+}{F11}
  ;Send {LWin Up}{Control}{Shift}{F11}
  ;Send {Win Up}
  ;SendInput {F11}
return

^!l::
  ; Ctrl-Alt-L 
  LockScreen()
return

OnExitSub:
  ; Enable LockWorkStation, because this script is ending (so other applications aren't further disturbed)
  SetDisableLockWorkstationRegKeyValue( 0 )
  ExitApp
return

SetDisableLockWorkstationRegKeyValue( value )
  {
  ;MsgBox, regwrite %value%
  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, %value%
  }

LockScreen()
  {
  ; Temporary enable locking
  SetDisableLockWorkstationRegKeyValue( 0 )
  ; Lock
  ;MsgBox, locking ; Arbitrary code here

  DllCall( "LockWorkStation" )
  Sleep, 1000
  ; Disable locking again 
  SetDisableLockWorkstationRegKeyValue( 1 )
  }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; keybindings to lock and/or put machine to sleep
; from https://gist.github.com/davejamesmiller/1965847
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This is part of my AutoHotkey [1] script that puts my computer to sleep when I
; press Win+F12.

; I chose that keyboard shortcut because it's very similar to the Fn+F12
; keyboard shortcut on my laptop.

; I don't have my PC set to require a password to resume, so I also have a
; second version (Win+Shift+F12) in case I want to lock the PC first.

; [1]: http://www.autohotkey.com/


; Win+Shift+F12 - Sleep
#+F12::
    ; Sleep/Suspend:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; Hibernate:
    ;DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    return

; Win+F12 - Lock and sleep
#F12::
    ; Lock:
    ;Run rundll32.exe user32.dll,LockWorkStation
    LockScreen()

    ;Sleep 1000
    ; Sleep/Suspend:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; Hibernate:
    ;DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    return

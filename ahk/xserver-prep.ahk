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
  ; Temporary enable locking
  SetDisableLockWorkstationRegKeyValue( 0 )
  ; Lock
  ;MsgBox, locking ; Arbitrary code here

  DllCall( "LockWorkStation" )
  Sleep, 1000
  ; Disable locking again 
  SetDisableLockWorkstationRegKeyValue( 1 )
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

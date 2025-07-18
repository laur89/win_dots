#Requires AutoHotkey v2
#SingleInstance Force
ListLines(0), KeyHistory(0)
ProcessSetPriority("High")

full_command_line := DllCall("GetCommandLine", "str")

; restart script as admin, if not already:
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    ExitApp
}

;MsgBox "A_IsAdmin: " A_IsAdmin "`nCommand line: " full_command_line

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; from https://superuser.com/questions/726988/how-to-remap-a-program-to-lock-windows-winl/727170#727170
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; WARNING: Programs that use User32\LockWorkStation (i.e. programmatically locking the operating system) may not work correctly! 
  ; This includes Windows itself (i.e. using start menu or task manager to lock will also not work).
  ; Script changes Win-L to show a msgbox and Ctrl-Alt-L to lock windows

  ; The following 3 code lines are auto-executed upon script run, the return line marks an end to the auto-executed code section.
  ; Register user defined subroutine 'OnExitSub' to be executed when this script is terminating
  OnExit OnExitSub

  ; Disable LockWorkStation, so Windows doesn't intercept Win+L and this script can act on that key combination 
  SetDisableLockWorkstationRegKeyValue(1)

  ; Lock the screen if system has been idle:
  IdleCheckLoopMs := 10 * 1000
  LockIdleMs := 10 * 60 * 1000
  idle_lock_enabled := true

  if (idle_lock_enabled) {
    SetOrRemoveLockScreenTimer(true)
  }



; following lock state listener from https://autohotkey.com/boards/viewtopic.php?t=8023:
OnMessage(WM_WTSSESSION_CHANGE := 0x02B1, HANDLE_SESSION_CHANGE_EVENT)
DllCall("Wtsapi32.dll\WTSRegisterSessionNotification", "uint", A_ScriptHwnd, "uint", NOTIFY_FOR_ALL_SESSIONS := 1)

HANDLE_SESSION_CHANGE_EVENT(wParam, lParam, msg, hwnd) {
/*
wParam::::::
WTS_CONSOLE_CONNECT := 0x1 ; A session was connected to the console terminal.
WTS_CONSOLE_DISCONNECT := 0x2 ; A session was disconnected from the console terminal.
WTS_REMOTE_CONNECT := 0x3 ; A session was connected to the remote terminal.
WTS_REMOTE_DISCONNECT := 0x4 ; A session was disconnected from the remote terminal.
WTS_SESSION_LOGON := 0x5 ; A user has logged on to the session.
WTS_SESSION_LOGOFF := 0x6 ; A user has logged off the session.
WTS_SESSION_LOCK := 0x7 ; A session has been locked.
WTS_SESSION_UNLOCK := 0x8 ; A session has been unlocked.
WTS_SESSION_REMOTE_CONTROL := 0x9 ; A session has changed its remote controlled status. To determine the status, call GetSystemMetrics and check the SM_REMOTECONTROL metric.
*/

    Critical(1000)
    Static WTS_SESSION_LOCK := "0x7", WTS_SESSION_UNLOCK := "0x8", WM_WTSSESSION_CHANGE := "0x02B1", WTS_SESSION_LOGON := "0x5", WTS_SESSION_LOGOFF := "0x6"

/*
    Switch wParam {
        Case WTS_SESSION_LOCK:
            action := "locked"
        Case WTS_SESSION_UNLOCK:
            action := "unlocked"
        Case WTS_SESSION_LOGON:
            action := "logon"
        Case WTS_SESSION_LOGOFF:
            action := "logoff"
        default:
            action := "undefined"
    }
*/

    if not (idle_lock_enabled) {
      Return true
    } Else If (wParam=0x6 || wParam=0x7) { ;Logoff or lock
      ;Run, powercfg -change -monitor-timeout-ac 1,,Hide ;Set monitor standby timeout to 1 minute
      ;SendMessage,0x112,0xF170,2,,Program Manager ;Monitor Standby
      SetOrRemoveLockScreenTimer(false)
    } Else If (wParam=0x5 || wParam=0x8) { ;Logon or unlock
      ;Run, powercfg -change -monitor-timeout-ac 20,,Hide ;Set monitor standby timeout to 20 minutes
      SetOrRemoveLockScreenTimer(true)
    }

    Return true
}



;#l:: {
  ;MsgBox "Win-L was pressed!"  ; Arbitrary code here
  ;Send {^}{+}{F11}
  ;Send {LWin Up}{Control}{Shift}{F11}
  ;Send {Win Up}
  ;SendInput {F11}
;}

;#e:: {
  ;MsgBox "Win-EEEEE was pressed!"  ; Arbitrary code here
  ;Send {^}{+}{F11}
  ;Send {LWin Up}{Control}{Shift}{F11}
  ;Send {Win Up}
  ;SendInput {F11}
;}

; right control + left Win to toggle locking on idle on/off:
;>^LWin:: {
  ;global idle_lock_enabled
  ;idle_lock_enabled := !idle_lock_enabled
  ;SetOrRemoveLockScreenTimer(idle_lock_enabled)
;}

^!l:: {
  ; Ctrl-Alt-L 
  LockScreen()
}

OnExitSub(ExitReason, ExitCode)
{
  ; Enable LockWorkStation, because this script is ending (so other applications aren't further disturbed)
  SetDisableLockWorkstationRegKeyValue(0)
  ;ExitApp  ; Do not call ExitApp -- that would prevent other callbacks from being called.
}

SetDisableLockWorkstationRegKeyValue(val) {
  ;MsgBox "regwrite: " val
  RegWrite val, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation"
  
}

LockScreen() {
  ; Temporary enable locking
  SetDisableLockWorkstationRegKeyValue(0)
  ; Lock
  ;MsgBox "locking..."  ; Arbitrary code here

  DllCall( "LockWorkStation" )
  Sleep 1000
  ; Disable locking again 
  SetDisableLockWorkstationRegKeyValue(1)
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

/*
; Win+Shift+F12 - Sleep
#+F12:: {
    ; Sleep/Suspend:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; Hibernate:
    ;DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
}
*/

; Lock and sleep
#F12::
#Delete::
{
    ; Lock:
    ;Run rundll32.exe user32.dll,LockWorkStation
    LockScreen()

    ;Sleep 1000
    ; Sleep/Suspend:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; Hibernate:
    ;DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; screensaver - lock computer after X time of idle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetOrRemoveLockScreenTimer(doSet) {
    if (doSet) {
        SetTimer LockIfIdleLongEnough, IdleCheckLoopMs
    } else {
        SetTimer LockIfIdleLongEnough, 0
    }
}


LockIfIdleLongEnough() {
  If (A_TimeIdle >= LockIdleMs) {
      ;MsgBox "gonnalock in 5s..."
      ;Sleep 5000
      LockScreen()
  }
}

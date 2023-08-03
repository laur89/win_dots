#NoEnv
; #Warn                      ; Enable warnings to assist with detecting common errors.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; script from https://www.autohotkey.com/docs/v1/lib/WinMove.htm#ExCenter
CenterWindow(WinTitle)
{
    WinGetPos,,, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}

; alt+; to center active window on our screen:
!`;::CenterWindow("A")

; or to center a specific window:
;!`;::CenterWindow("ahk_class Notepad")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move active window to Right edge in middle (No Taskbar)
;^1::
;WinExist("A")
;WinGetPos, , , Width, Height, A
;WinMove, (A_ScreenWidth - Width), (A_ScreenHeight/2)-(Height/2)
;Return


; Move active window to Left edge in middle (No Taskbar)
;^2::
;WinExist("A")
;WinGetPos, , , Width, Height, A
;WinMove, A, , 0, (A_ScreenHeight/2)-(Height/2)
;Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

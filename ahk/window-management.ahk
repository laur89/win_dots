#Requires AutoHotkey v2
#SingleInstance Force
ListLines(0), KeyHistory(0)
ProcessSetPriority("High")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; script from https://www.autohotkey.com/docs/v2/lib/WinMove.htm#ExCenter
CenterWindow(WinTitle)
{
    WinGetPos ,, &Width, &Height, WinTitle
    WinMove (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2),,, WinTitle
}

; alt+; to center active window on our screen:
; NOTE: possibly conflicts w/ komorebi's default Komorebic("unstack") binding
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
#NoEnv
#Include %A_ScriptDir%\funcs.ahk
; #Warn                      ; Enable warnings to assist with detecting common errors.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

GroupAdd, ctrlAltRemap, ahk_class Chrome_WidgetWin_1
GroupAdd, ctrlAltRemap, ahk_class MozillaWindowClass
GroupAdd, ctrlAltRemap, ahk_class Notepad
GroupAdd, ctrlAltRemap, ahk_class CabinetWClass  ; windows explorer
;GroupAdd, ctrlAltRemap, ahk_exe msedge.exe ahk_class Chrome_WidgetWin_1   ; <-- to target Edge specifically

#IfWinActive ahk_group ctrlAltRemap
  !0::Send ^0
  !1::Send ^1
  !2::Send ^2
  !3::Send ^3
  !4::Send ^4
  !5::Send ^5
  !6::Send ^6
  !7::Send ^7
  !8::Send ^8
  !9::Send ^9
#If

;;; remap keys for xsrv:
#IfWinActive ahk_class VcXsrv/x
  !q::Send #e
  ; ctrl+ü:
  ;^SC01A::Send #e
  ^SC01A::ControlSend,, SC01A, ahk_class VcXsrv/x
  ;^SC01A::ControlSend, VcXsrv/x, a
#If

; super+shift+z to toggle passwd manager window:
#+z::
  if WinActive("ahk_exe KeePassXC.exe")
    WinClose A
  else
    Run "%PROGRAMFILES%\KeePassXC\KeePassXC.exe"
return

#f::
  ;MsgBox, Win-F was pressed! ; Arbitrary code here
  ;Send {^}{+}{F11}
  ;Send {LWin Up}{Control}{Shift}{F11}
  ;Send {Win Up}
  
  ; discord doesn't seem to respect F11 (see https://support.discord.com/hc/en-us/community/posts/360055174871-Fullscreen-mode)
  if WinActive("ahk_exe Discord.exe")
    Send ^+f
  else
    Send {F11}
return

; alt+i to send win+`, triggering the quake-style terminal (have to be started with wt -w _quake first):
!i::
  DetectHiddenWindows, on
  if WinExist("__quake_term") {
    ;Send {Alt up}
    Send #``
    Sleep, 40
    MoveQuakeTerm("__quake_term")
  } else {
    ;Run wt -w _quake powershell -nologo -NoExit -command "`$Host.UI.RawUI.WindowTitle = '__quake_term'"
    Run wt -w _quake powershell -nologo -NoExit -File "%A_ScriptDir%\posh-with-window-title.ps1" "__quake_term"
    Sleep, 1000
    InitQuakeTerm("__quake_term")
  }
  DetectHiddenWindows, off
return

; close window; alternatively could also use   #c::Send !{F4}
#c::WinClose A

; map ctrl+y to ctrl+shift+z to better mimic redo on loonix:
; TODO: causes keymap language to be changed/toggled! if no other language is available it's a non-issue though.
$^+z::Send ^y

; display the expo:
!e::Send #{Tab}
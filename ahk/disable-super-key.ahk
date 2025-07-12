#Requires AutoHotkey v2
#SingleInstance Force
ListLines(0), KeyHistory(0)
ProcessSetPriority("High")

; note there's also this program for disabling super key: https://github.com/bblanchon/disable-windows-keys

; disable win key by sending any keystroke; still allows using it part of a combo as modifier (from https://stackoverflow.com/a/69143767):
;~LWin::Send {Blind}{vkE8}

GroupAdd "GG", "ahk_class UnrealWindow"

disable_super := true                                           ; Track on/off for disabling super key
Return                                                          ; End of auto-execute section
>^LWin::global disable_super := !disable_super                  ; right control + left Win to toggle on/off

#HotIf WinActive("ahk_group GG") && disable_super
*Lwin::return
*Rwin::return
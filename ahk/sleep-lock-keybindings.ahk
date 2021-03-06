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
    Return

; Win+F12 - Lock and sleep
#F12::
    ; Lock:
    Run rundll32.exe user32.dll`,LockWorkStation
    Sleep 1000
    ; Sleep/Suspend:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; Hibernate:
    ;DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    Return
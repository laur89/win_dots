#NoEnv

GroupAdd, ctrlAltRemap, ahk_class Chrome_WidgetWin_1
GroupAdd, ctrlAltRemap, ahk_class MozillaWindowClass

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

InitQuakeTerm(WinTitle)
{
    ;WinGetPos, x, y, Width, Height, %WinTitle%
    ;WinGetPos,,, Width, Height, "__quake_term"
	WinMove, %WinTitle%, , 0, 0, A_ScreenWidth, (A_ScreenHeight*0.4)
	;WinMove, "__quake_term", , 0, 0, A_ScreenWidth, (A_ScreenHeight*0.4)
}

MoveQuakeTerm(WinTitle)
{
	WinGetPos, x, y, w, h, %WinTitle%
	if (x != 0 or y != 0 or w != A_ScreenWidth) {
		WinMove, %WinTitle%, , 0, 0, A_ScreenWidth
    }
}
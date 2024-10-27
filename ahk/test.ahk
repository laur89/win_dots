Global SetT, Cuar1, Cuar2, Cuar3

InputBox, Reminder, Type a reminder note, , , 250, 100
InputBox, SetT, How long from now (minutes), , , 250, 100

ProgNum:=SetT
SetT:=SetT*60+1
Cuar:=Floor(SetT/4)
Cuar1:=Cuar*1
Cuar2:=Cuar*2
Cuar3:=Cuar*3
xpos := Floor((A_ScreenWidth/2)-1180)
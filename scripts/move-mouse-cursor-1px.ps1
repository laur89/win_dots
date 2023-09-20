# move mouse cursor by one pixel; from https://superuser.com/a/614609/179401
# execute like  $ powershell -nologo -executionpolicy bypass -File C:\Users\laur\move-mouse-cursor-1px.ps1
#
Add-Type -AssemblyName System.Windows.Forms

#Start-Sleep -Seconds 60
$Pos = [System.Windows.Forms.Cursor]::Position
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((($Pos.X) + 1) , $Pos.Y)

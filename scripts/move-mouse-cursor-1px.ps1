# move mouse cursor by one pixel; from https://superuser.com/a/614609/179401
#
Add-Type -AssemblyName System.Windows.Forms

#Start-Sleep -Seconds 60
$Pos = [System.Windows.Forms.Cursor]::Position
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((($Pos.X) + 1) , $Pos.Y)

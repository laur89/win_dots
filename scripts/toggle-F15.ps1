# toggle F15 / scroll lock key to avoid screensaver.
# from https://stackoverflow.com/a/69845081/1803648
#
# execute like  $ powershell -nologo -executionpolicy bypass -File C:\Users\laur\toggle-F15.ps1
#
#Start-Sleep -Seconds 60
$WShell = New-Object -Com "Wscript.Shell"
# this to loop:
#while(1) {$WShell.SendKeys("{F15}"); sleep 200}

# {F15}, {SCROLLLOCK}...
$WShell.SendKeys("{F15}")

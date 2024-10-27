# launch steam game
#
# execute like  $ powershell -nologo -executionpolicy bypass -File C:\Users\laur\launch-steam-game.ps1
#

$Active_game=578080
$Steam_id_to_name = @{
    578080  = 'PUBG'
}


[int]$Time = 10
$Lenght = $Time / 100
For (; $Time -gt 0; $Time--) {
	$msg = "" + ($Time % 60) + " sec"
	$min = [int](([string]($Time/60)).split('.')[0])
	if ($min -gt 0) {
		$msg = "" + $min + " min " + $msg
	}
	Write-Progress -Activity "Launching $($Steam_id_to_name[$Active_game]) in..." -Status $msg -PercentComplete ($Time / $Lenght)
	Start-Sleep -Seconds 1
}

Start-Process "steam://rungameid/$Active_game"
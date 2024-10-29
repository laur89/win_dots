# launch steam game
#
# execute like  $ powershell -nologo -executionpolicy bypass -File C:\Users\laur\launch-steam-game.ps1
#

$Active_game=578080
$Steam_id_to_name = @{
    578080  = 'PUBG'
}


$Startup_msg="Launching $($Steam_id_to_name[$Active_game]) in..."
[int]$T_sec = 10  # countdown time
$Lenght = $T_sec / 100

For (; $T_sec -gt 0; $T_sec--) {
    $msg = "" + ($T_sec % 60) + " sec"
    $min = [int](([string]($T_sec/60)).split('.')[0])
    if ($min -gt 0) {
        $msg = "" + $min + " min " + $msg
    }
    Write-Progress -Activity $Startup_msg -Status $msg -PercentComplete ($T_sec / $Lenght)
    Start-Sleep -Seconds 1
}

Start-Process "steam://rungameid/$Active_game"

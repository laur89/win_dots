$pubg_dir = "${env:ProgramFiles(x86)}\Steam\steamapps\common\PUBG"
$movies_dir = "$pubg_dir\TslGame\Content\Movies"

if (Test-Path $movies_dir) {
    Remove-Item $movies_dir -Force -Recurse
}
$dl_dir = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$work_dir = "$dl_dir\SnapKey"
if (Test-Path $work_dir) {
   Start-Process -WorkingDirectory "$work_dir" "$work_dir\SnapKey.exe"
}
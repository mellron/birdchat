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
Write-Host "Mickey Running..." -ForegroundColor Green
Write-Host "Press any key to stop." -ForegroundColor Yellow
Write-Host ""

$jiggleOffset = 1

$running = $true
while ($running)
{
    [MouseJiggler]::Jiggle($jiggleOffset)
    $jiggleOffset = -$jiggleOffset
    Write-Host "`r[$(Get-Date -Format 'HH:mm:ss')] Mickey..." -NoNewline

    # Check for keypress every second for 60 seconds
    for ($i = 0; $i -lt 60; $i++) {
        if ([Console]::KeyAvailable) {
            $null = [Console]::ReadKey($true)
            $running = $false
            break
        }
        Start-Sleep -Seconds 1
    }
}

Write-Host ""
Write-Host "Mickey Stopped." -ForegroundColor Red
$cSource = @'
using System;
using System.Runtime.InteropServices;

public class MickeyV2
{
    [DllImport("kernel32.dll")]
    static extern uint SetThreadExecutionState(uint esFlags);

    [DllImport("user32.dll")]
    static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    [DllImport("user32.dll")]
    static extern void mouse_event(uint dwFlags, int dx, int dy, uint dwData, UIntPtr dwExtraInfo);

    [StructLayout(LayoutKind.Sequential)]
    struct LASTINPUTINFO
    {
        public uint cbSize;
        public uint dwTime;
    }

    const uint ES_CONTINUOUS = 0x80000000;
    const uint ES_SYSTEM_REQUIRED = 0x00000001;
    const uint ES_DISPLAY_REQUIRED = 0x00000002;

    const uint MOUSEEVENTF_MOVE = 0x0001;

    public static void KeepAwake()
    {
        SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
    }

    public static void AllowSleep()
    {
        SetThreadExecutionState(ES_CONTINUOUS);
    }

    public static int GetIdleSeconds()
    {
        LASTINPUTINFO lii = new LASTINPUTINFO();
        lii.cbSize = (uint)Marshal.SizeOf(lii);
        GetLastInputInfo(ref lii);
        return (int)((Environment.TickCount - lii.dwTime) / 1000);
    }

    public static void Nudge()
    {
        mouse_event(MOUSEEVENTF_MOVE, 1, 0, 0, UIntPtr.Zero);
        System.Threading.Thread.Sleep(50);
        mouse_event(MOUSEEVENTF_MOVE, -1, 0, 0, UIntPtr.Zero);
        KeepAwake();
    }
}
'@
Add-Type -TypeDefinition $cSource

Clear-Host
Write-Host "Mickey V2 Running..." -ForegroundColor Green
Write-Host "Nudges mouse when idle > 30s to keep Teams active." -ForegroundColor Cyan
Write-Host "Press any key to stop." -ForegroundColor Yellow
Write-Host ""

$running = $true
[MickeyV2]::KeepAwake()

while ($running)
{
    $idle = [MickeyV2]::GetIdleSeconds()

    if ($idle -ge 30) {
        [MickeyV2]::Nudge()
        Write-Host "`r[$(Get-Date -Format 'HH:mm:ss')] Nudged (idle ${idle}s)" -NoNewline
    } else {
        Write-Host "`r[$(Get-Date -Format 'HH:mm:ss')] Active (idle ${idle}s)" -NoNewline
    }

    # Check for keypress every second for 30 seconds
    for ($i = 0; $i -lt 30; $i++) {
        if ([Console]::KeyAvailable) {
            $null = [Console]::ReadKey($true)
            $running = $false
            break
        }
        Start-Sleep -Seconds 1
    }
}

[MickeyV2]::AllowSleep()
Write-Host ""
Write-Host "Mickey V2 Stopped." -ForegroundColor Red

$cSource = @'
using System;
using System.Runtime.InteropServices;

public class Mickey
{
    [DllImport("kernel32.dll")]
    static extern uint SetThreadExecutionState(uint esFlags);

    [DllImport("user32.dll")]
    static extern bool SetCursorPos(int X, int Y);

    [DllImport("user32.dll")]
    static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("user32.dll")]
    static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT
    {
        public int X;
        public int Y;
    }

    const uint ES_CONTINUOUS = 0x80000000;
    const uint ES_SYSTEM_REQUIRED = 0x00000001;
    const uint ES_DISPLAY_REQUIRED = 0x00000002;

    public static void KeepAwake()
    {
        SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
    }

    public static void AllowSleep()
    {
        SetThreadExecutionState(ES_CONTINUOUS);
    }

    public static void Move(int offset)
    {
        POINT p;
        GetCursorPos(out p);
        SetCursorPos(p.X + offset, p.Y);
        System.Threading.Thread.Sleep(50);
        SetCursorPos(p.X, p.Y);
        KeepAwake();
    }

    const byte VK_F15 = 0x7E;
    const uint KEYEVENTF_KEYUP = 0x0002;

    public static void PokeWindow(IntPtr hWnd)
    {
        IntPtr prev = GetForegroundWindow();
        if (hWnd == IntPtr.Zero || hWnd == prev) return;
        SetForegroundWindow(hWnd);
        System.Threading.Thread.Sleep(50);
        keybd_event(VK_F15, 0, 0, UIntPtr.Zero);
        keybd_event(VK_F15, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
        System.Threading.Thread.Sleep(50);
        SetForegroundWindow(prev);
    }
}
'@
Add-Type -TypeDefinition $cSource

Clear-Host
Write-Host "Mickey Running..." -ForegroundColor Green
Write-Host "Press any key to stop." -ForegroundColor Yellow
Write-Host ""

# Find the Teams window
$teamsProc = Get-Process | Where-Object { $_.MainWindowTitle -match "Teams" -and $_.MainWindowHandle -ne 0 } | Select-Object -First 1
if ($teamsProc) {
    Write-Host "Found Teams window: $($teamsProc.MainWindowTitle)" -ForegroundColor Cyan
} else {
    Write-Host "Teams window not found - will keep checking." -ForegroundColor DarkYellow
}

$mickeyOffset = 1

$running = $true
[Mickey]::KeepAwake()

while ($running)
{
    [Mickey]::Move($mickeyOffset)
    $mickeyOffset = -$mickeyOffset

    # Poke Teams to keep it active
    $teamsProc = Get-Process | Where-Object { $_.MainWindowTitle -match "Teams" -and $_.MainWindowHandle -ne 0 } | Select-Object -First 1
    if ($teamsProc) {
        [Mickey]::PokeWindow($teamsProc.MainWindowHandle)
        Write-Host "`r[$(Get-Date -Format 'HH:mm:ss')] Mickey + Teams..." -NoNewline
    } else {
        Write-Host "`r[$(Get-Date -Format 'HH:mm:ss')] Mickey..." -NoNewline
    }

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

[Mickey]::AllowSleep()
Write-Host ""
Write-Host "Mickey Stopped." -ForegroundColor Red
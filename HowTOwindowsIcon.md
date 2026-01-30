# HowTOwindowsIcon.md

## Create a Desktop Icon to Run a PowerShell Script (Windows 11)

This guide explains how to create a **desktop icon** that you can double-click to run a PowerShell script (for example, a keep-awake or mouse activity script).

---

## Prerequisites

- Windows 11
- A PowerShell script saved on your computer  
  Example:
  ```
  C:\Users\<yourname>\Scripts\keep-awake.ps1
  ```
- PowerShell execution enabled for your user account

If needed, open **PowerShell (Admin)** and run once:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

## Step 1: Verify the Script Location

Make sure your `.ps1` file exists and runs manually:

```powershell
cd C:\Users\<yourname>\Scripts
.\keep-awake.ps1
```

Stop it with **Ctrl + C** before continuing.

---

## Step 2: Create the Desktop Shortcut

1. Right-click on the **Desktop**
2. Select **New → Shortcut**
3. In **Location of the item**, enter:

```
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<yourname>\Scripts\keep-awake.ps1"
```

4. Click **Next**
5. Name the shortcut:
```
Keep Awake
```
6. Click **Finish**

You now have a clickable desktop icon.

---

## Step 3: Run the Script Using the Icon

- Double-click the new desktop icon
- A PowerShell window will open
- The script runs as long as the window is open

---

## Step 4: Stop the Script

To stop the script at any time:

1. Click inside the PowerShell window
2. Press:
```
Ctrl + C
```

---

## Optional: Change the Icon Image

1. Right-click the shortcut → **Properties**
2. Click **Change Icon…**
3. Browse to:
```
C:\Windows\System32\imageres.dll
```
4. Select an icon (mouse, clock, lightning, etc.)
5. Click **OK → Apply**

---

## Optional: Pin the Icon

- Right-click the shortcut → **Pin to Start**
- Or drag it to the **Taskbar**

---

## Notes

- The PowerShell window remaining visible is normal
- Closing the window stops the script
- If the script performs mouse clicks, be mindful of open applications

---

## Troubleshooting

**Error: “running scripts is disabled”**
- Ensure execution policy was set for `CurrentUser`
- Restart PowerShell and try again

**Nothing happens when clicking the icon**
- Verify the script path is correct
- Test running the script manually in PowerShell

---

## Done

You now have a desktop icon that launches your PowerShell script on demand.

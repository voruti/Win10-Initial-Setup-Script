@powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Win10.ps1" -include "%~dp0Win10.psm1" RequireAdmin -preset "%~dp0myPref.preset" -preset "%~dpn0.preset" WaitForKey Restart

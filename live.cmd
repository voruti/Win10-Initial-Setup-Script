@echo off


set /p command="Enter tweaks to run them: "

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Win10.ps1" -include "%~dp0Win10.psm1" -include "%~dp0myScript.psm1" ClearConsole %command% WaitForKey

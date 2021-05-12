@echo off

cd /D "%~dp0"
git pull
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Win10.ps1" -include "%~dp0Win10.psm1" -include "%~dp0myScript.psm1" ClearConsole -preset "%~dpn0.preset"

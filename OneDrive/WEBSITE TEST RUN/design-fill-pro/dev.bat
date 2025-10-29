@echo off
setlocal
REM Launches the dev PowerShell helper, forwarding all arguments
REM Works even when PowerShell script execution is restricted

set SCRIPT_DIR=%~dp0
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%dev.ps1" %*

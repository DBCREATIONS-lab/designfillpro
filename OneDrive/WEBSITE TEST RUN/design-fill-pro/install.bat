@echo off
REM Design Fill Pro - One-Line Installer
REM This script downloads and runs the full setup

echo Design Fill Pro - Quick Installer
echo.

REM Check if curl is available (Windows 10+)
where curl >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Downloading setup script...
    curl -L -o designfillpro-setup.bat https://raw.githubusercontent.com/DBCREATIONS-lab/designfillpro/main/setup-github-clone.bat
    if %ERRORLEVEL% EQU 0 (
        echo Running setup...
        designfillpro-setup.bat
        del designfillpro-setup.bat
    ) else (
        echo Failed to download setup script
        echo Please visit: https://github.com/DBCREATIONS-lab/designfillpro
        pause
    )
) else (
    echo Curl not found. Please manually download and run:
    echo https://raw.githubusercontent.com/DBCREATIONS-lab/designfillpro/main/setup-github-clone.bat
    echo.
    echo Or visit: https://github.com/DBCREATIONS-lab/designfillpro
    pause
)
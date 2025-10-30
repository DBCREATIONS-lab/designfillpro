@echo off
echo.
echo ==========================================
echo   DESIGN FILL PRO - GITHUB SETUP
echo ==========================================
echo.
echo This script will:
echo [1] Clone the Design Fill Pro repository
echo [2] Install all dependencies
echo [3] Set up development environment
echo [4] Test the installation
echo.

REM Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git from: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

REM Get user input for setup location
set /p PROJECT_DIR="Enter directory where you want to install (or press Enter for current directory): "
if "%PROJECT_DIR%"=="" set PROJECT_DIR=%CD%

echo.
echo Setting up in: %PROJECT_DIR%
echo.

REM Navigate to project directory
cd /d "%PROJECT_DIR%"

REM Clone the repository
echo [1/4] Cloning Design Fill Pro repository...
if exist "designfillpro" (
    echo Repository already exists. Updating...
    cd designfillpro
    git pull origin main
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to update repository
        pause
        exit /b 1
    )
) else (
    git clone https://github.com/DBCREATIONS-lab/designfillpro.git
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to clone repository
        echo Please check your internet connection and try again
        pause
        exit /b 1
    )
    cd designfillpro
)

echo ✓ Repository cloned successfully!
echo.

REM Check for Python
echo [2/4] Checking Python installation...
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

python --version
echo ✓ Python found!
echo.

REM Check for Node.js
echo [3/4] Checking Node.js installation...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Node.js is not installed or not in PATH
    echo Please install Node.js from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

node --version
echo ✓ Node.js found!
echo.

REM Setup backend
echo [4/4] Setting up backend environment...
cd backend

REM Create virtual environment
if not exist ".venv" (
    echo Creating Python virtual environment...
    python -m venv .venv
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to create virtual environment
        pause
        exit /b 1
    )
)

REM Install Python dependencies
echo Installing Python dependencies...
.venv\Scripts\pip.exe install --upgrade pip
.venv\Scripts\pip.exe install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install Python dependencies
    pause
    exit /b 1
)

echo ✓ Backend setup complete!
echo.

REM Setup frontend
echo Setting up frontend environment...
cd ..\frontend

REM Install Node.js dependencies
echo Installing Node.js dependencies...
npm.cmd install
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install Node.js dependencies
    pause
    exit /b 1
)

echo ✓ Frontend setup complete!
echo.

REM Go back to project root
cd ..

echo.
echo ==========================================
echo   SETUP COMPLETE! 🎉
echo ==========================================
echo.
echo Your Design Fill Pro is ready to run!
echo.
echo TO START DEVELOPMENT:
echo.
echo Option 1 - Use the automated script:
echo   .\dev.bat
echo.
echo Option 2 - Start manually:
echo   Backend:  cd backend ^&^& .venv\Scripts\uvicorn.exe app.main:app --reload
echo   Frontend: cd frontend ^&^& npm run dev
echo.
echo URLS when running:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8000
echo   API Docs: http://localhost:8000/docs
echo.
echo PROJECT LOCATION: %CD%
echo.
echo For deployment help, see:
echo   - DEPLOYMENT.md
echo   - PUBLISH-TO-WEBSITE.md
echo   - QUICK-PUBLISH.md
echo.

pause
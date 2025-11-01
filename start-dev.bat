@echo off
echo Starting Design Fill Pro Development Environment...
echo.

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

REM Backend setup and start
echo Setting up Backend...
cd /d "%SCRIPT_DIR%backend"

REM Check if virtual environment exists, create if not
if not exist .venv (
    echo Creating Python virtual environment...
    python -m venv .venv
)

REM Install requirements
echo Installing/updating backend dependencies...
.venv\Scripts\pip.exe install -r requirements.txt

REM Start backend in new window
echo Starting Backend on http://127.0.0.1:8000...
start "Design Fill Pro - Backend" cmd /k "cd /d "%SCRIPT_DIR%backend" && .venv\Scripts\uvicorn.exe app.main:app --reload --host 127.0.0.1 --port 8000"

REM Frontend setup and start
echo.
echo Setting up Frontend...
cd /d "%SCRIPT_DIR%frontend"

REM Check if node_modules exists, install if not
if not exist node_modules (
    echo Installing frontend dependencies...
    npm.cmd install
)

REM Start frontend in new window
echo Starting Frontend on http://localhost:3000...
start "Design Fill Pro - Frontend" cmd /k "cd /d "%SCRIPT_DIR%frontend" && npm.cmd run dev"

echo.
echo ===== Development Environment Started =====
echo Backend:  http://127.0.0.1:8000
echo Frontend: http://localhost:3000
echo API Docs: http://127.0.0.1:8000/docs
echo.
echo Two new command windows should have opened.
echo Press any key to close this window...
pause >nul
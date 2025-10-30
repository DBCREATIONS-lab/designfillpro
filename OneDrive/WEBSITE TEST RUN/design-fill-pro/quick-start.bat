@echo off
echo Starting Design Fill Pro...

REM Get script directory
set SCRIPT_DIR=%~dp0

REM Start backend
start "Backend" cmd /k "cd /d "%SCRIPT_DIR%backend" && .venv\Scripts\uvicorn.exe app.main:app --reload --host 127.0.0.1 --port 8000"

REM Start frontend  
start "Frontend" cmd /k "cd /d "%SCRIPT_DIR%frontend" && npm.cmd run dev"

echo Started! Check the new windows that opened.
echo Backend: http://127.0.0.1:8000
echo Frontend: http://localhost:3000
pause
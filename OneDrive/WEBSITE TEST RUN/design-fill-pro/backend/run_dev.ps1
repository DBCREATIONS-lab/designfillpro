<#
Runs the FastAPI backend in auto-reload mode using the local venv if present.
Also frees the target port before starting to avoid conflicts.

Usage examples:
  ./run_dev.ps1                # starts on 127.0.0.1:8000
  ./run_dev.ps1 -Port 8001     # starts on 127.0.0.1:8001
  ./run_dev.ps1 -Host 0.0.0.0  # listen on all interfaces (LAN)

Note: If scripts are blocked by execution policy, you can run:
  powershell -ExecutionPolicy Bypass -File .\run_dev.ps1
#>

param(
  [int]$Port = 8000,
  [string]$Host = '127.0.0.1'
)

$ErrorActionPreference = 'Stop'

function Free-Port {
  param([int]$Port)
  try {
    $bindings = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue
    if ($bindings) {
      ($bindings | Select-Object -ExpandProperty OwningProcess -Unique) | ForEach-Object {
        $pid = $_
        try {
          Stop-Process -Id $pid -Force
          Write-Host "Stopped PID $pid on port $Port" -ForegroundColor Yellow
        } catch {
          Write-Host "Failed to stop PID $pid: $($_.Exception.Message)" -ForegroundColor Red
        }
      }
    }
  } catch {
    Write-Host "Port check failed: $($_.Exception.Message)" -ForegroundColor Red
  }
}

$backend = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $backend

Free-Port -Port $Port

$venvPy = Join-Path $backend 'venv\Scripts\python.exe'
if (Test-Path $venvPy) {
  & $venvPy -m uvicorn app.main:app --reload --host $Host --port $Port
}
else {
  Write-Host "venv not found. Falling back to system python." -ForegroundColor Yellow
  python -m uvicorn app.main:app --reload --host $Host --port $Port
}

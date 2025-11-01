param(
  [int]$BackendPort = 8000,
  [string]$BackendHost = "127.0.0.1",
  [int]$FrontendPort = 3000
)

$ErrorActionPreference = 'Stop'

function Test-Cmd {
  param([string]$Name)
  try { Get-Command $Name -ErrorAction Stop | Out-Null; return $true } catch { return $false }
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$backend = Join-Path $root 'backend'
$frontend = Join-Path $root 'frontend'

Write-Host "Root: $root" -ForegroundColor Cyan

# ----- Backend -----
$venvDir = Join-Path $backend ".venv"
$venvPy  = Join-Path $venvDir "Scripts/python.exe"

# Ensure virtual environment exists
if (-not (Test-Path $venvPy)) {
  Write-Host "Creating Python virtual environment (.venv) for backend..." -ForegroundColor Yellow
  Set-Location $backend
  python -m venv .venv
}

$python = if (Test-Path $venvPy) { $venvPy } else { 'python' }

# Ensure dependencies installed
try {
  Write-Host "Ensuring backend dependencies are installed..." -ForegroundColor Yellow
  & $python -m pip --version *>$null 2>&1
  if ($LASTEXITCODE -ne 0) { Write-Host "Upgrading pip..." -ForegroundColor DarkYellow; & $python -m ensurepip -U }
  & $python -m pip install --upgrade pip
  & $python -m pip install -r (Join-Path $backend 'requirements.txt')
} catch {
  Write-Warning "Failed to install backend dependencies: $($_.Exception.Message)"
}

$backendCmd = "Set-Location `"$backend`"; `"$python`" -m uvicorn app.main:app --reload --host $BackendHost --port $BackendPort"

# Optionally warn if port is in use
try {
  $existing = Get-NetTCPConnection -LocalPort $BackendPort -State Listen -ErrorAction SilentlyContinue
  if ($existing) { Write-Warning "Port $BackendPort already in use (PID: $($existing.OwningProcess)). The backend may fail to start." }
} catch {}

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit","-Command", $backendCmd | Out-Null
Write-Host "Started backend window (uvicorn on $($BackendHost):$($BackendPort))" -ForegroundColor Green

# ----- Frontend -----
function Get-NpmCmd {
  if (Test-Cmd 'npm.cmd') { return 'npm.cmd' }
  if (Test-Cmd 'npm') { return 'npm' }
  $npmFromProgramFiles = 'C:\\Program Files\\nodejs\\npm.cmd'
  if (Test-Path $npmFromProgramFiles) { return $npmFromProgramFiles }
  return $null
}

$npm = Get-NpmCmd
if (-not $npm) {
  Write-Warning "npm not found. Please install Node.js LTS from https://nodejs.org/en/download and re-run this script."
} else {
  $frontendCmd = @(
    "Set-Location `"$frontend`""
    "if (-not (Test-Path node_modules)) { `"$npm`" install }"
    "`"$npm`" run dev -- -p $FrontendPort"
  ) -join '; '

  try {
    $existingFront = Get-NetTCPConnection -LocalPort $FrontendPort -State Listen -ErrorAction SilentlyContinue
    if ($existingFront) { Write-Warning "Port $FrontendPort already in use (PID: $($existingFront.OwningProcess)). The frontend may fail to start." }
  } catch {}

  Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit","-Command", $frontendCmd | Out-Null
  Write-Host "Started frontend window (Next.js on http://localhost:$FrontendPort)" -ForegroundColor Green
}

Write-Host "Done. Two PowerShell windows should open for backend and frontend." -ForegroundColor Cyan

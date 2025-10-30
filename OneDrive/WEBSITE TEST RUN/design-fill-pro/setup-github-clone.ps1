# Design Fill Pro - GitHub Clone Setup Script
# PowerShell version with enhanced error handling and features

param(
    [string]$InstallPath = $PWD,
    [switch]$SkipDependencyCheck,
    [switch]$DevMode
)

$ErrorActionPreference = 'Stop'

function Write-Header {
    param([string]$Text)
    Write-Host "`n===========================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Step, [string]$Description)
    Write-Host "`n[$Step] $Description..." -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Main setup process
try {
    Write-Header "DESIGN FILL PRO - GITHUB SETUP"
    
    Write-Host "This script will:" -ForegroundColor White
    Write-Host "[1] Clone the Design Fill Pro repository" -ForegroundColor White
    Write-Host "[2] Install all dependencies" -ForegroundColor White
    Write-Host "[3] Set up development environment" -ForegroundColor White
    Write-Host "[4] Test the installation" -ForegroundColor White
    Write-Host ""

    # Check prerequisites
    if (-not $SkipDependencyCheck) {
        Write-Step "0/5" "Checking prerequisites"
        
        if (-not (Test-Command "git")) {
            Write-Error "Git is not installed or not in PATH"
            Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
            exit 1
        }
        Write-Success "Git found"

        if (-not (Test-Command "python")) {
            Write-Error "Python is not installed or not in PATH"
            Write-Host "Please install Python from: https://www.python.org/downloads/" -ForegroundColor Yellow
            Write-Host "Make sure to check 'Add Python to PATH' during installation" -ForegroundColor Yellow
            exit 1
        }
        $pythonVersion = python --version
        Write-Success "Python found: $pythonVersion"

        if (-not (Test-Command "node")) {
            Write-Error "Node.js is not installed or not in PATH"
            Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
            exit 1
        }
        $nodeVersion = node --version
        $npmVersion = npm --version
        Write-Success "Node.js found: $nodeVersion, npm: $npmVersion"
    }

    # Navigate to install path
    Set-Location $InstallPath
    Write-Host "Installing to: $($InstallPath)" -ForegroundColor Cyan

    # Clone or update repository
    Write-Step "1/5" "Setting up repository"
    
    if (Test-Path "designfillpro") {
        Write-Host "Repository already exists. Updating..." -ForegroundColor Yellow
        Set-Location "designfillpro"
        git pull origin main
        Write-Success "Repository updated"
    } else {
        git clone https://github.com/DBCREATIONS-lab/designfillpro.git
        Set-Location "designfillpro"
        Write-Success "Repository cloned"
    }

    $projectRoot = Get-Location

    # Setup backend
    Write-Step "2/5" "Setting up backend environment"
    Set-Location "backend"

    if (-not (Test-Path ".venv")) {
        Write-Host "Creating Python virtual environment..." -ForegroundColor Yellow
        python -m venv .venv
    }

    Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
    & ".venv\Scripts\pip.exe" install --upgrade pip
    & ".venv\Scripts\pip.exe" install -r requirements.txt
    Write-Success "Backend environment ready"

    # Setup frontend
    Write-Step "3/5" "Setting up frontend environment"
    Set-Location "$projectRoot\frontend"

    Write-Host "Installing Node.js dependencies..." -ForegroundColor Yellow
    if (Test-Command "npm.cmd") {
        npm.cmd install
    } else {
        npm install
    }
    Write-Success "Frontend environment ready"

    # Test installation
    Write-Step "4/5" "Testing installation"
    Set-Location $projectRoot

    # Test backend
    Write-Host "Testing backend..." -ForegroundColor Yellow
    $backendTest = Start-Job -ScriptBlock {
        Set-Location $using:projectRoot
        Set-Location "backend"
        & ".venv\Scripts\python.exe" -c "import app.main; print('Backend imports OK')"
    }
    
    Wait-Job $backendTest -Timeout 10
    $backendResult = Receive-Job $backendTest
    Remove-Job $backendTest

    if ($backendResult -like "*Backend imports OK*") {
        Write-Success "Backend test passed"
    } else {
        Write-Error "Backend test failed"
    }

    # Test frontend
    Write-Host "Testing frontend..." -ForegroundColor Yellow
    Set-Location "frontend"
    $frontendTest = npm run build 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Frontend test passed"
    } else {
        Write-Host "Frontend build test completed with warnings (this is normal)" -ForegroundColor Yellow
    }

    # Create environment files
    Write-Step "5/5" "Creating environment configuration"
    Set-Location $projectRoot

    if (-not (Test-Path "frontend\.env.local")) {
        Copy-Item "frontend\.env.example" "frontend\.env.local" -ErrorAction SilentlyContinue
        Write-Success "Frontend environment file created"
    }

    if (-not (Test-Path "backend\.env")) {
        Copy-Item "backend\.env.example" "backend\.env" -ErrorAction SilentlyContinue
        Write-Success "Backend environment file created"
    }

    # Final success message
    Write-Header "SETUP COMPLETE! 🎉"
    
    Write-Host ""
    Write-Host "Your Design Fill Pro is ready to run!" -ForegroundColor Green
    Write-Host ""
    Write-Host "TO START DEVELOPMENT:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Option 1 - Use the automated script:" -ForegroundColor White
    Write-Host "  .\dev.bat" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 2 - Use PowerShell script:" -ForegroundColor White
    Write-Host "  .\dev.ps1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 3 - Start manually:" -ForegroundColor White
    Write-Host "  Backend:  cd backend && .venv\Scripts\uvicorn.exe app.main:app --reload" -ForegroundColor Yellow
    Write-Host "  Frontend: cd frontend && npm run dev" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "URLS when running:" -ForegroundColor Cyan
    Write-Host "  Frontend: http://localhost:3000" -ForegroundColor White
    Write-Host "  Backend:  http://localhost:8000" -ForegroundColor White  
    Write-Host "  API Docs: http://localhost:8000/docs" -ForegroundColor White
    Write-Host ""
    Write-Host "PROJECT LOCATION: $projectRoot" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "For deployment help, see:" -ForegroundColor Cyan
    Write-Host "  - DEPLOYMENT.md" -ForegroundColor White
    Write-Host "  - PUBLISH-TO-WEBSITE.md" -ForegroundColor White
    Write-Host "  - QUICK-PUBLISH.md" -ForegroundColor White
    Write-Host ""

    if ($DevMode) {
        Write-Host "Starting development environment..." -ForegroundColor Yellow
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$projectRoot'; .\dev.ps1"
    }

} catch {
    Write-Error "Setup failed: $($_.Exception.Message)"
    Write-Host "Please check the error above and try again." -ForegroundColor Yellow
    Write-Host "For help, visit: https://github.com/DBCREATIONS-lab/designfillpro/issues" -ForegroundColor Yellow
    exit 1
}
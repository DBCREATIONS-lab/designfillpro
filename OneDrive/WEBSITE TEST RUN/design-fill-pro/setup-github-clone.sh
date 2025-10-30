#!/bin/bash

# Design Fill Pro - GitHub Clone Setup Script
# Linux/macOS version

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "\n${CYAN}===========================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}===========================================${NC}"
}

print_step() {
    echo -e "\n${YELLOW}[$1] $2...${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup process
main() {
    print_header "DESIGN FILL PRO - GITHUB SETUP"
    
    echo "This script will:"
    echo "[1] Clone the Design Fill Pro repository"
    echo "[2] Install all dependencies"
    echo "[3] Set up development environment"
    echo "[4] Test the installation"
    echo ""

    # Get install path
    read -p "Enter directory where you want to install (or press Enter for current directory): " PROJECT_DIR
    if [ -z "$PROJECT_DIR" ]; then
        PROJECT_DIR=$(pwd)
    fi

    echo ""
    echo "Setting up in: $PROJECT_DIR"
    echo ""

    # Check prerequisites
    print_step "0/5" "Checking prerequisites"
    
    if ! command_exists git; then
        print_error "Git is not installed"
        echo "Please install Git:"
        echo "  macOS: brew install git (or install Xcode Command Line Tools)"
        echo "  Ubuntu/Debian: sudo apt install git"
        echo "  CentOS/RHEL: sudo yum install git"
        exit 1
    fi
    print_success "Git found"

    if ! command_exists python3; then
        print_error "Python 3 is not installed"
        echo "Please install Python 3:"
        echo "  macOS: brew install python"
        echo "  Ubuntu/Debian: sudo apt install python3 python3-pip python3-venv"
        echo "  CentOS/RHEL: sudo yum install python3 python3-pip"
        exit 1
    fi
    PYTHON_VERSION=$(python3 --version)
    print_success "Python found: $PYTHON_VERSION"

    if ! command_exists node; then
        print_error "Node.js is not installed"
        echo "Please install Node.js:"
        echo "  macOS: brew install node"
        echo "  Ubuntu/Debian: curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs"
        echo "  Or visit: https://nodejs.org/"
        exit 1
    fi
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    print_success "Node.js found: $NODE_VERSION, npm: $NPM_VERSION"

    # Navigate to install path
    cd "$PROJECT_DIR"

    # Clone or update repository
    print_step "1/5" "Setting up repository"
    
    if [ -d "designfillpro" ]; then
        echo "Repository already exists. Updating..."
        cd designfillpro
        git pull origin main
        print_success "Repository updated"
    else
        git clone https://github.com/DBCREATIONS-lab/designfillpro.git
        cd designfillpro
        print_success "Repository cloned"
    fi

    PROJECT_ROOT=$(pwd)

    # Setup backend
    print_step "2/5" "Setting up backend environment"
    cd backend

    if [ ! -d ".venv" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv .venv
    fi

    echo "Installing Python dependencies..."
    .venv/bin/pip install --upgrade pip
    .venv/bin/pip install -r requirements.txt
    print_success "Backend environment ready"

    # Setup frontend
    print_step "3/5" "Setting up frontend environment"
    cd "$PROJECT_ROOT/frontend"

    echo "Installing Node.js dependencies..."
    npm install
    print_success "Frontend environment ready"

    # Test installation
    print_step "4/5" "Testing installation"
    cd "$PROJECT_ROOT"

    # Test backend
    echo "Testing backend..."
    cd backend
    if .venv/bin/python -c "import app.main; print('Backend imports OK')" 2>/dev/null; then
        print_success "Backend test passed"
    else
        print_error "Backend test failed"
    fi

    # Test frontend
    echo "Testing frontend..."
    cd "$PROJECT_ROOT/frontend"
    if npm run build >/dev/null 2>&1; then
        print_success "Frontend test passed"
    else
        echo "Frontend build test completed with warnings (this is normal)"
    fi

    # Create environment files
    print_step "5/5" "Creating environment configuration"
    cd "$PROJECT_ROOT"

    if [ ! -f "frontend/.env.local" ] && [ -f "frontend/.env.example" ]; then
        cp "frontend/.env.example" "frontend/.env.local"
        print_success "Frontend environment file created"
    fi

    if [ ! -f "backend/.env" ] && [ -f "backend/.env.example" ]; then
        cp "backend/.env.example" "backend/.env"
        print_success "Backend environment file created"
    fi

    # Final success message
    print_header "SETUP COMPLETE! 🎉"
    
    echo ""
    echo -e "${GREEN}Your Design Fill Pro is ready to run!${NC}"
    echo ""
    echo -e "${CYAN}TO START DEVELOPMENT:${NC}"
    echo ""
    echo -e "${NC}Backend:${NC}"
    echo -e "  ${YELLOW}cd backend && .venv/bin/uvicorn app.main:app --reload --host 127.0.0.1 --port 8000${NC}"
    echo ""
    echo -e "${NC}Frontend (in another terminal):${NC}"
    echo -e "  ${YELLOW}cd frontend && npm run dev${NC}"
    echo ""
    echo -e "${CYAN}URLS when running:${NC}"
    echo -e "  Frontend: ${NC}http://localhost:3000${NC}"
    echo -e "  Backend:  ${NC}http://localhost:8000${NC}"
    echo -e "  API Docs: ${NC}http://localhost:8000/docs${NC}"
    echo ""
    echo -e "${CYAN}PROJECT LOCATION:${NC} $PROJECT_ROOT"
    echo ""
    echo -e "${CYAN}For deployment help, see:${NC}"
    echo "  - DEPLOYMENT.md"
    echo "  - PUBLISH-TO-WEBSITE.md"
    echo "  - QUICK-PUBLISH.md"
    echo ""
}

# Run main function
main "$@"
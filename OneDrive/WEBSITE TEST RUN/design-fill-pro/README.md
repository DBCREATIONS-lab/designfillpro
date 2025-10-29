# Design Fill Pro (local dev)

A minimal full‑stack setup for local development:
- Backend: FastAPI (Python) with file upload + image preview generation
- Frontend: Next.js (React) with drag‑and‑drop upload and preview display

## Prerequisites

- Windows + PowerShell
- Backend: Python 3.8+ (3.10+ recommended)
- Frontend: Node.js LTS (install from https://nodejs.org/en/download)

## Quick start

Open two PowerShell windows.

Backend (port 8000)

```powershell
cd "c:\Users\COOLB_000\OneDrive\WEBSITE TEST RUN\design-fill-pro\backend"
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

Verify it’s up:

```powershell
Invoke-RestMethod -Uri http://127.0.0.1:8000/health
```

Frontend (port 3000)

```powershell
cd "c:\Users\COOLB_000\OneDrive\WEBSITE TEST RUN\design-fill-pro\frontend"
npm install
npm run dev
```

Open http://127.0.0.1:3000 in your browser.

CORS is preconfigured in the backend to allow http://localhost:3000 and http://127.0.0.1:3000.

### One-command dev helper (optional)

From the repo root, you can launch both servers in separate windows:

```powershell
cd "c:\Users\COOLB_000\OneDrive\WEBSITE TEST RUN\design-fill-pro"
./dev.ps1
```

Options:

```powershell
./dev.ps1 -BackendPort 8000 -BackendHost 127.0.0.1 -FrontendPort 3000
```

Notes:
- The script will use `.venv\Scripts\python.exe` if it exists for the backend; otherwise it uses `python` on PATH.
- It runs `npm install` automatically for the frontend if `node_modules` is missing.
- If ports are already in use, it prints a warning.

Double‑click option (no PowerShell typing):

- You can also double‑click `dev.bat` in the repo root to launch the same helper. It forwards any parameters, e.g.:

```bat
dev.bat -BackendPort 8001 -FrontendPort 3001
```

## How it works

- POST `http://127.0.0.1:8000/preview-only`
  - Accepts image uploads (png, jpg/jpeg, webp, gif)
  - Streams file to `backend/uploads/` (20 MB limit)
  - Generates a resized preview image with Pillow
  - Response includes:
    - `file_url`, `preview_url`, `file_size_bytes`
    - `preview_width`, `preview_height`
    - `original_width`, `original_height`
    - `complexity`, `depth`
- GET `http://127.0.0.1:8000/uploads/...` serves uploaded files and previews
- GET `http://127.0.0.1:8000/health` returns `{ "status": "ok" }`

## Troubleshooting

- PowerShell script policy prevents running `run_dev.ps1`
  - Run uvicorn directly instead:
    ```powershell
    .\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
    ```
- Port already in use (8000 or 3000)
  - Find PID:
    ```powershell
    Get-NetTCPConnection -LocalPort 8000 -State Listen | Select-Object -ExpandProperty OwningProcess
    ```
  - Then stop it:
    ```powershell
    Stop-Process -Id <PID> -Force
    ```
- Node not found
  - Install Node.js LTS from https://nodejs.org/en/download
  - Open a new PowerShell window after install

## Project layout

```
design-fill-pro/
  backend/
    app/main.py            # FastAPI app
    uploads/               # saved files + previews
    requirements.txt
    README.md
    run_dev.ps1            # optional dev helper
  frontend/
    pages/index.js         # Next.js page with drag&drop upload
    package.json
```

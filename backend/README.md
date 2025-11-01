# Design Fill Pro — Backend (local)

This directory contains a small FastAPI backend for local testing of the Design Fill Pro frontend.

Prerequisites
- Python 3.8+ installed and available on PATH. If not installed, download from https://www.python.org/downloads/ and enable "Add Python to PATH" during install.

Quick start (PowerShell)

1. Open PowerShell and create / activate a virtual environment (recommended):

```powershell
cd "c:\Users\COOLB_000\OneDrive\WEBSITE TEST RUN\design-fill-pro\backend"
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

2. Install dependencies:

```powershell
python -m pip install --upgrade pip
pip install -r requirements.txt
# If you want to run the test script, install requests
pip install requests
```

3. Run the dev server:

```powershell
uvicorn app.main:app --reload
```

By default the server will listen on http://127.0.0.1:8000

Test the health endpoint in PowerShell:

```powershell
Invoke-RestMethod -Uri http://127.0.0.1:8000/
```

Test the `/preview-only` endpoint (PowerShell using curl-like syntax):

```powershell
# Example using curl (Windows includes curl.exe) - replace sample.png with a real file path
curl -X POST "http://127.0.0.1:8000/preview-only" -F "file=@sample.png" -F "complexity=0.7" -F "depth=7.0"
```

Or use the included Python test script `test_preview.py`:

```powershell
python test_preview.py
```

Notes
- Uploads are saved under `backend/uploads/`. Files are served at `http://127.0.0.1:8000/uploads/<filename>`.
- Images get a resized preview at `/uploads/preview_<filename>`.
- Response includes `file_size_bytes` and, for image previews, `preview_width` and `preview_height`.
 - Response includes `file_size_bytes` and, for image previews, `preview_width`, `preview_height`, `original_width`, and `original_height`.
- Only image MIME types are accepted: png, jpg/jpeg, webp, gif (HTTP 415 otherwise).
- Maximum upload size is 20 MB (enforced while streaming the upload to disk).
- Old files are cleaned up automatically (default: 24h retention, runs hourly).
- Health check available at `GET /health`.
- If you haven't installed Python system-wide, ensure you use a terminal where `python` points to the installed interpreter.

Auto-reload (development)

Use the helper script to run with auto-reload:

```powershell
cd "c:\Users\COOLB_000\OneDrive\WEBSITE TEST RUN\design-fill-pro\backend"
./run_dev.ps1             # starts on 127.0.0.1:8000 (frees the port if busy)
# Optional parameters
./run_dev.ps1 -Port 8001  # choose a different port
./run_dev.ps1 -Host 0.0.0.0  # listen on all interfaces
```

If PowerShell blocks script execution, you can run directly without the script:

```powershell
# If you created a virtual environment named .venv above, use this path instead:
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

Frontend (Next.js) quick start

Prerequisites
- Node.js LTS (recommended). Download from https://nodejs.org/en/download or install via winget:

```powershell
winget install --id OpenJS.NodeJS.LTS --source winget --accept-package-agreements --accept-source-agreements
```

Run the frontend dev server (port 3000):

```powershell
cd "c:\Users\COOLB_000\OneDrive\WEBSITE TEST RUN\design-fill-pro\frontend"
npm install
npm run dev
```

Then open http://127.0.0.1:3000 (or http://localhost:3000). CORS is already configured on the backend for port 3000.

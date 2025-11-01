import os
import shutil
import time
import datetime
import asyncio
from pathlib import Path

from fastapi import FastAPI, UploadFile, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from starlette.staticfiles import StaticFiles

app = FastAPI(title="Design Fill Pro - Local Test")

# CORS allows your local frontend to talk to backend
# Add FRONTEND_URL env var for production (e.g., https://yourapp.vercel.app)
FRONTEND_URLS = os.getenv("FRONTEND_URL", "http://localhost:3000,http://127.0.0.1:3000").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=FRONTEND_URLS,
    allow_methods=["*"],
    allow_headers=["*"]
)

# Uploads directory (relative to backend working dir)
UPLOAD_DIR = Path("uploads")
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

# Serve uploaded files at /uploads/*
app.mount("/uploads", StaticFiles(directory=str(UPLOAD_DIR)), name="uploads")

# Upload constraints
MAX_UPLOAD_MB = 20
MAX_UPLOAD_BYTES = MAX_UPLOAD_MB * 1024 * 1024
CHUNK_SIZE = 1024 * 1024  # 1 MB
ALLOWED_IMAGE_MIME = {
    "image/png",
    "image/jpeg",
    "image/jpg",
    "image/webp",
    "image/gif",
}

# Cleanup constraints
RETENTION_HOURS = 24

def _delete_old_files(retention_hours: float) -> dict:
    """Delete files older than the provided retention (in hours) from uploads/.

    Returns a summary dict with counts and total bytes freed.
    """
    summary = {"deleted": 0, "bytes_freed": 0}
    cutoff = time.time() - (retention_hours * 3600)
    for p in UPLOAD_DIR.iterdir():
        try:
            if p.is_file() and p.stat().st_mtime < cutoff:
                size = p.stat().st_size
                p.unlink()
                summary["deleted"] += 1
                summary["bytes_freed"] += size
        except Exception:
            # ignore errors deleting individual files
            pass
    return summary

@app.get("/")
async def root():
    return {"message": "Design Fill Pro local backend running!"}

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.post("/preview-only")
async def preview_only(
    file: UploadFile,
    complexity: float = Form(0.5),
    depth: float = Form(5.0),
):
    """Save an uploaded file, optionally generate an image preview, and return URLs.

    - Saves the original file to the uploads directory.
    - If the file is an image, creates a resized preview image.
    - Returns URLs that can be fetched from /uploads/...
    """
    if file is None or file.filename is None:
        raise HTTPException(status_code=400, detail="No file uploaded")

    if not file.content_type or file.content_type.lower() not in ALLOWED_IMAGE_MIME:
        raise HTTPException(status_code=415, detail="Unsupported media type. Please upload an image (png/jpg/webp/gif).")

    # Basic numeric validation
    try:
        complexity = float(complexity)
        depth = float(depth)
    except Exception:
        raise HTTPException(status_code=400, detail="complexity and depth must be numbers")

    if not (0.0 <= complexity <= 1.0):
        raise HTTPException(status_code=400, detail="complexity must be between 0.0 and 1.0")
    if not (0.0 < depth <= 1000.0):
        raise HTTPException(status_code=400, detail="depth must be > 0 and <= 1000")

    # Normalize filename and save original (streamed with size cap)
    safe_name = os.path.basename(file.filename)
    original_path = UPLOAD_DIR / safe_name
    try:
        bytes_written = 0
        with original_path.open("wb") as out:
            while True:
                chunk = await file.read(CHUNK_SIZE)
                if not chunk:
                    break
                bytes_written += len(chunk)
                if bytes_written > MAX_UPLOAD_BYTES:
                    try:
                        out.close()
                    finally:
                        if original_path.exists():
                            original_path.unlink()
                    raise HTTPException(status_code=413, detail=f"File too large. Max {MAX_UPLOAD_MB} MB.")
                out.write(chunk)
    finally:
        await file.close()

    # Try to generate an image preview if the file is an image
    preview_url = None
    preview_width = None
    preview_height = None
    original_width = None
    original_height = None
    if (file.content_type or "").startswith("image/"):
        try:
            from PIL import Image

            # Determine a max size based on depth/complexity
            # Base 512px, scale by complexity (0..1) and clamp
            base = 512
            size = max(64, min(2048, int(base * (0.5 + complexity))))
            max_size = (size, size)

            preview_name = f"preview_{safe_name}"
            preview_path = UPLOAD_DIR / preview_name

            with Image.open(original_path) as im:
                # Capture original dimensions before resizing
                ow, oh = im.size
                original_width, original_height = ow, oh
                im.thumbnail(max_size)
                # Convert mode if needed to ensure save works
                if im.mode not in ("RGB", "RGBA"):
                    im = im.convert("RGB")
                im.save(preview_path)
                preview_width, preview_height = im.size

            preview_url = f"/uploads/{preview_name}"
        except Exception:
            # If preview generation fails, continue without it
            preview_url = None
            preview_width = None
            preview_height = None
            original_width = None
            original_height = None

    original_url = f"/uploads/{safe_name}"
    file_size_bytes = original_path.stat().st_size if original_path.exists() else None

    return {
        "file_url": original_url,
        "preview_url": preview_url,
        "file_size_bytes": file_size_bytes,
        "preview_width": preview_width,
        "preview_height": preview_height,
        "original_width": original_width,
        "original_height": original_height,
        "tokens_charged": 0,
        "complexity": complexity,
        "depth": depth,
    }


async def _cleanup_loop():
    """Periodically delete files older than RETENTION_HOURS from uploads/."""
    while True:
        try:
            _ = _delete_old_files(RETENTION_HOURS)
        except Exception:
            # ignore overall cleanup loop errors
            pass
        await asyncio.sleep(3600)  # run hourly


@app.on_event("startup")
async def _start_cleanup_task():
    # Fire-and-forget cleanup task
    asyncio.create_task(_cleanup_loop())


@app.get("/admin/uploads/recent")
async def uploads_recent(limit: int = 50):
    """List recent files in the uploads folder sorted by modified time (desc)."""
    try:
        limit = int(limit)
    except Exception:
        raise HTTPException(status_code=400, detail="limit must be an integer")
    if limit < 1 or limit > 500:
        raise HTTPException(status_code=400, detail="limit must be between 1 and 500")

    items = []
    for p in UPLOAD_DIR.iterdir():
        if not p.is_file():
            continue
        try:
            st = p.stat()
            mtime = st.st_mtime
            items.append({
                "name": p.name,
                "url": f"/uploads/{p.name}",
                "size_bytes": st.st_size,
                "modified_ts": mtime,
                "modified": datetime.datetime.fromtimestamp(mtime).isoformat(),
            })
        except Exception:
            continue

    items.sort(key=lambda x: x["modified_ts"], reverse=True)
    return {"count": min(len(items), limit), "items": items[:limit]}


@app.post("/admin/uploads/purge")
async def admin_purge_uploads(hours: float = 24):
    """Delete files older than N hours (default 24). Returns a summary.

    Note: Local-dev only. No authentication is implemented.
    """
    try:
        hours = float(hours)
    except Exception:
        raise HTTPException(status_code=400, detail="hours must be a number")
    if hours <= 0 or hours > 24 * 30:
        raise HTTPException(status_code=400, detail="hours must be > 0 and <= 720")

    summary = _delete_old_files(hours)
    return {"status": "ok", "hours": hours, **summary}
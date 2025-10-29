# Deployment Guide for Design Fill Pro

This guide covers deploying the backend and frontend to production.

## Quick Deploy Options

### Option 1: Docker (Self-hosted)

Build and run with Docker Compose:

```bash
docker-compose up -d
```

- Backend: http://localhost:8000
- Frontend: http://localhost:3000

### Option 2: Vercel (Frontend) + Railway (Backend)

**Backend on Railway:**

1. Push your code to GitHub
2. Go to [Railway](https://railway.app) and create a new project
3. Select "Deploy from GitHub repo" and choose your repo
4. Railway will auto-detect the Dockerfile in `backend/`
5. Add environment variable:
   - `FRONTEND_URL` = your Vercel URL (e.g., `https://yourapp.vercel.app`)
6. Copy the Railway public URL (e.g., `https://yourapp.railway.app`)

**Frontend on Vercel:**

1. Go to [Vercel](https://vercel.com) and import your GitHub repo
2. Set root directory to `frontend`
3. Add environment variable:
   - `NEXT_PUBLIC_API_URL` = your Railway backend URL
4. Deploy

### Option 3: Vercel (Frontend) + Render (Backend)

**Backend on Render:**

1. Push code to GitHub
2. Go to [Render](https://render.com) and create a new Web Service
3. Connect your GitHub repo
4. Render will use `render.yaml` for config
5. Add environment variable:
   - `FRONTEND_URL` = your Vercel URL
6. Copy the Render service URL

**Frontend:** Same as Option 2 above, but use Render URL for `NEXT_PUBLIC_API_URL`

## Environment Variables

### Backend
- `FRONTEND_URL` — Comma-separated list of allowed frontend origins (for CORS)
  - Example: `https://yourapp.vercel.app,https://preview.yourapp.vercel.app`

### Frontend
- `NEXT_PUBLIC_API_URL` — Backend API URL
  - Example: `https://yourapp.railway.app`

## Storage Considerations

The current setup uses local file storage in `backend/uploads/`. For production:

- **Ephemeral filesystems** (Railway, Render free tier): Files are lost on restart. Consider:
  - AWS S3 / Cloudflare R2
  - Supabase Storage
  - Backblaze B2
- **Persistent storage** (paid plans): Railway/Render offer volume mounts

## Local Docker Testing

Build images:
```bash
cd backend
docker build -t design-fill-pro-backend .

cd ../frontend
docker build -t design-fill-pro-frontend .
```

Run individually:
```bash
docker run -p 8000:8000 -e FRONTEND_URL=http://localhost:3000 design-fill-pro-backend
docker run -p 3000:3000 -e NEXT_PUBLIC_API_URL=http://localhost:8000 design-fill-pro-frontend
```

## Notes

- CORS is configured to accept origins from `FRONTEND_URL` env var
- Health check available at `/health` for uptime monitoring
- File cleanup runs hourly (configurable in `app/main.py`)
- Max upload size: 20 MB (configurable)

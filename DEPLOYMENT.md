# Deployment Guide for Design Fill Pro

## 🚀 Quick Deploy Options

### Option 1: One-Click Deploy with Docker (Recommended)

**Prerequisites:** Docker installed on your system

```bash
# Clone and run
git clone https://github.com/DBCREATIONS-lab/designfillpro.git
cd designfillpro
docker-compose up --build
```

Access your app:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

---

### Option 2: Platform-as-a-Service Deployment

#### 🌐 **Frontend Deployment (Vercel)**

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/DBCREATIONS-lab/designfillpro&project-name=design-fill-pro-frontend&root-directory=frontend)

**Manual Steps:**
1. Fork/clone this repository
2. Connect your GitHub account to Vercel
3. Import the project
4. Set root directory to `frontend`
5. Add environment variable: `NEXT_PUBLIC_API_URL=your-backend-url`
6. Deploy!

#### 🚄 **Backend Deployment (Railway)**

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/1YL7g_?referralCode=pDvmkd)

**Manual Steps:**
1. Fork/clone this repository
2. Connect your GitHub account to Railway
3. Create new project and connect repository
4. Set root directory to `backend`
5. Railway will auto-detect Python and use the Dockerfile
6. Add environment variables (see below)
7. Deploy!

#### 🎨 **Alternative: Render**

**Backend:**
1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Connect GitHub repository
3. Create new Web Service
4. Set:
   - Root Directory: `backend`
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`

**Frontend:**
1. Create new Static Site
2. Set:
   - Root Directory: `frontend`
   - Build Command: `npm ci && npm run build`
   - Publish Directory: `frontend/.next`

---

## 🔧 Environment Variables

### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=https://your-backend-domain.com
```

### Backend (.env)
```env
FRONTEND_URL=https://your-frontend-domain.com
PORT=8000
UPLOAD_MAX_SIZE=20971520
UPLOAD_DIR=uploads
```

---

## 🐳 Docker Deployment

### Local Development
```bash
docker-compose up --build
```

### Production with custom domains
```bash
# Edit docker-compose.yml environment variables first
docker-compose -f docker-compose.prod.yml up --build
```

---

## 🔄 GitHub Actions CI/CD

The repository includes automated deployment workflows:

- **`.github/workflows/deploy-vercel.yml`** - Auto-deploy frontend to Vercel
- **`.github/workflows/deploy-railway.yml`** - Auto-deploy backend to Railway  
- **`.github/workflows/deploy-render.yml`** - Auto-deploy to Render

### Setup Required Secrets:

**For Vercel:**
- `VERCEL_TOKEN` - Your Vercel authentication token
- `VERCEL_ORG_ID` - Your Vercel organization ID
- `VERCEL_PROJECT_ID` - Your Vercel project ID

**For Railway:**
- `RAILWAY_TOKEN` - Your Railway authentication token
- `RAILWAY_SERVICE_ID` - Your Railway service ID

**For Render:**
- `RENDER_DEPLOY_HOOK_BACKEND` - Backend deploy webhook URL
- `RENDER_DEPLOY_HOOK_FRONTEND` - Frontend deploy webhook URL

---

## 📱 Platform-Specific Notes

### Vercel (Frontend)
- Automatically detects Next.js
- Supports Edge Functions
- Built-in CDN and SSL
- Custom domains included

### Railway (Backend)  
- Supports Python/Docker
- Built-in PostgreSQL if needed
- Automatic HTTPS
- Easy environment management

### Render
- Free tier available
- Automatic SSL certificates
- Database hosting available
- Easy custom domains

---

## 🛠️ Local Development

See the main [README.md](./README.md) for detailed local development setup.

Quick start:
```bash
# Windows
.\dev.bat

# Or manually
cd backend && .venv\Scripts\uvicorn.exe app.main:app --reload
cd frontend && npm run dev
```

---

## 🔍 Troubleshooting

### Common Issues:

1. **CORS Errors**
   - Update `FRONTEND_URL` in backend environment
   - Update `NEXT_PUBLIC_API_URL` in frontend environment

2. **Build Failures**
   - Check Node.js version (use 18+)
   - Check Python version (use 3.8+)
   - Verify all environment variables are set

3. **File Upload Issues**
   - Check upload directory permissions
   - Verify `UPLOAD_MAX_SIZE` environment variable
   - Ensure backend has write access to uploads folder

4. **Database Connection (if using external DB)**
   - Update connection strings in environment variables
   - Check firewall rules
   - Verify database is accessible from deployment platform

---

## 📧 Support

Need help deploying? Create an issue in the [GitHub repository](https://github.com/DBCREATIONS-lab/designfillpro/issues) with:
- Platform you're deploying to
- Error messages
- Steps you've already tried

---

## 🎯 Production Checklist

- [ ] Environment variables configured
- [ ] CORS settings updated for production domains
- [ ] SSL certificates enabled
- [ ] Custom domains configured (optional)
- [ ] File upload limits set appropriately
- [ ] Error monitoring configured (optional)
- [ ] Backup strategy implemented (optional)
- [ ] CDN configured for static assets (optional)

**🎉 Your Design Fill Pro is ready to launch!**
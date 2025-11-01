# Publishing Your Website from GitHub

## 🌐 How to Publish Design Fill Pro on Your Own Website

This guide shows you how to automatically deploy your Design Fill Pro application from GitHub to your own website or hosting provider.

---

## 🚀 **Method 1: Automatic Deployment via GitHub Actions (Recommended)**

### **For Traditional Web Hosting (Shared Hosting, cPanel, etc.)**

#### **Setup Steps:**

1. **Get your hosting credentials:**
   - FTP/SFTP server address
   - Username and password
   - Port (usually 21 for FTP, 22 for SFTP)

2. **Add secrets to your GitHub repository:**
   - Go to your GitHub repository: https://github.com/DBCREATIONS-lab/designfillpro
   - Click **Settings** → **Secrets and variables** → **Actions**
   - Click **New repository secret** and add these:

   ```
   FTP_SERVER: your-website.com (or IP address)
   FTP_USERNAME: your-ftp-username
   FTP_PASSWORD: your-ftp-password
   
   # For SFTP (more secure alternative):
   SFTP_SERVER: your-website.com
   SFTP_USERNAME: your-sftp-username  
   SFTP_PASSWORD: your-sftp-password
   SFTP_PORT: 22
   ```

3. **Enable the workflow:**
   - The workflows are already created in `.github/workflows/`
   - Choose either `deploy-custom-website.yml` (FTP) or `deploy-sftp.yml` (SFTP)
   - Push any changes to trigger automatic deployment!

#### **What happens automatically:**
- ✅ Builds your frontend with Next.js
- ✅ Uploads files to your website via FTP/SFTP
- ✅ Frontend goes to `/public_html/` (your main website)
- ✅ Backend API goes to `/api/` folder
- ✅ Runs every time you push changes to GitHub

---

## 🏠 **Method 2: GitHub Pages (Free GitHub Hosting)**

Perfect for showcasing your project with a free subdomain like `yourusername.github.io/designfillpro`

#### **Setup Steps:**

1. **Enable GitHub Pages:**
   - Go to your repository settings
   - Scroll down to **Pages** section
   - Select **Source**: GitHub Actions
   - The workflow `deploy-pages.yml` will handle the rest

2. **Your site will be available at:**
   ```
   https://dbcreations-lab.github.io/designfillpro/
   ```

3. **Custom Domain (Optional):**
   - Add a `CNAME` file with your domain name
   - Configure DNS records at your domain provider

---

## 🛠️ **Method 3: Manual Upload via cPanel/Hosting Panel**

If you prefer manual control or can't use GitHub Actions:

#### **Frontend Deployment:**

1. **Build locally:**
   ```bash
   cd frontend
   npm run build
   ```

2. **Upload files:**
   - Navigate to the `frontend/.next/` folder
   - Upload all contents to your website's `/public_html/` folder
   - Or use your hosting panel's file manager

#### **Backend Deployment:**

1. **Prepare files:**
   - Upload the `backend/` folder to your server
   - Install Python dependencies on your server
   - Configure your hosting provider to run Python applications

2. **Common hosting configurations:**
   - **Shared hosting**: May not support Python backends
   - **VPS/Dedicated**: Full control, can run the FastAPI backend
   - **cPanel with Python**: Configure passenger_wsgi.py

---

## 🏢 **Method 4: Popular Hosting Providers**

### **Hostinger, GoDaddy, Bluehost, SiteGround, etc.**

#### **Frontend Only (Static Files):**
```bash
# Build static version
cd frontend  
npm run build
# Upload contents of 'out' folder to public_html
```

#### **With Backend Support:**
- Look for **Python hosting** or **VPS** options
- Many shared hosts don't support Python backends
- Consider deploying backend separately (Railway, Render, etc.)

### **Netlify (Alternative)**
- Connect GitHub repository directly
- Automatic deployments on push
- Custom domains included
- Built-in form handling

### **Cloudflare Pages**
- Free tier available
- Global CDN included
- Custom domains
- Edge computing capabilities

---

## ⚙️ **Configuration for Your Domain**

### **Update Environment Variables:**

**Frontend (.env.local):**
```env
NEXT_PUBLIC_API_URL=https://yourwebsite.com/api
```

**Backend (.env):**
```env
FRONTEND_URL=https://yourwebsite.com
```

### **DNS Configuration:**
If using a custom domain, add these DNS records:

```
Type: A
Name: @
Value: Your-Server-IP

Type: CNAME  
Name: www
Value: yourwebsite.com
```

---

## 🔧 **Hosting Provider Specific Guides**

### **cPanel Hosting:**
1. Use **File Manager** to upload built files
2. Place frontend files in `public_html/`
3. Backend may require **Python App** setup (if supported)

### **Shared Hosting Limitations:**
- Usually **no backend support** (Python/Node.js)
- **Frontend only** deployment recommended
- Use external API services for backend

### **VPS/Dedicated Servers:**
- Full control over server configuration
- Can run Docker containers
- Install and configure web servers (Nginx, Apache)

---

## 🤖 **Automated Deployment Triggers**

Your GitHub Actions workflows will trigger on:

- ✅ **Push to main branch** - Automatic deployment
- ✅ **Manual trigger** - Run workflow manually from GitHub
- ✅ **Pull request merge** - Deploy after code review

---

## 📋 **Deployment Checklist**

Before going live:

- [ ] Test locally with `./dev.bat`
- [ ] Update environment variables for production
- [ ] Configure CORS settings for your domain
- [ ] Test file upload functionality
- [ ] Set up SSL certificate (HTTPS)
- [ ] Configure domain DNS records
- [ ] Test all features on live site
- [ ] Set up monitoring/analytics (optional)

---

## 🆘 **Troubleshooting**

### **Common Issues:**

**1. FTP Connection Failed:**
- Check server address, username, and password
- Verify FTP vs SFTP settings
- Check if your host requires passive mode

**2. Build Errors:**
- Check Node.js version compatibility
- Verify all dependencies are installed
- Check for environment variable issues

**3. Backend Not Working:**
- Ensure hosting provider supports Python
- Check file permissions on server
- Verify API endpoints are accessible

**4. CORS Errors:**
- Update `FRONTEND_URL` in backend configuration
- Check domain spelling and protocol (http vs https)

### **Getting Help:**
- Check your hosting provider's documentation
- Contact their support for Python/Node.js setup
- Test with a simple HTML file first

---

## 🎯 **Recommended Approach**

**For beginners:**
1. Start with **GitHub Pages** (free, automatic)
2. Use **Netlify** or **Vercel** for enhanced features
3. Deploy backend to **Railway** or **Render**

**For custom domains:**
1. Use **GitHub Actions** with FTP/SFTP
2. Deploy to your existing hosting provider
3. Consider CDN for better performance

**For full control:**
1. Use **VPS** or **dedicated server**
2. Set up **Docker** deployment
3. Configure **Nginx** as reverse proxy

---

## 🔗 **Quick Links**

- **Your Repository**: https://github.com/DBCREATIONS-lab/designfillpro
- **GitHub Pages Setup**: Repository Settings → Pages
- **GitHub Secrets**: Repository Settings → Secrets and variables → Actions
- **Workflow Files**: `.github/workflows/` folder

**🎉 Your website will be live and automatically updated every time you push changes to GitHub!**
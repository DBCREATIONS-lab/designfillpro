# 🚀 Design Fill Pro - GitHub Clone Setup

## 📦 **One-Click Installation**

Choose your operating system and run the appropriate setup script:

### **Windows**

#### **Option 1: Simple Batch Script (Recommended)**
```cmd
# Download and run (in Command Prompt or PowerShell)
curl -L -o setup.bat https://raw.githubusercontent.com/DBCREATIONS-lab/designfillpro/main/setup-github-clone.bat && setup.bat
```

#### **Option 2: PowerShell Script (Advanced)**
```powershell
# Download and run (in PowerShell)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/DBCREATIONS-lab/designfillpro/main/setup-github-clone.ps1" -OutFile "setup.ps1"
.\setup.ps1
```

### **macOS / Linux**

```bash
# Download and run
curl -L -o setup.sh https://raw.githubusercontent.com/DBCREATIONS-lab/designfillpro/main/setup-github-clone.sh
chmod +x setup.sh
./setup.sh
```

---

## 📋 **What the Setup Script Does**

✅ **Checks prerequisites** (Git, Python, Node.js)  
✅ **Clones the repository** from GitHub  
✅ **Sets up Python virtual environment**  
✅ **Installs all backend dependencies**  
✅ **Installs all frontend dependencies**  
✅ **Creates environment configuration files**  
✅ **Tests the installation**  
✅ **Provides next steps**  

---

## 🔧 **Manual Setup (Alternative)**

If you prefer to set up manually:

### **1. Prerequisites**

**Install these first:**
- **Git**: https://git-scm.com/downloads
- **Python 3.8+**: https://www.python.org/downloads/
- **Node.js LTS**: https://nodejs.org/

### **2. Clone Repository**

```bash
git clone https://github.com/DBCREATIONS-lab/designfillpro.git
cd designfillpro
```

### **3. Setup Backend**

```bash
cd backend
python -m venv .venv

# Windows
.venv\Scripts\pip install -r requirements.txt

# macOS/Linux  
.venv/bin/pip install -r requirements.txt
```

### **4. Setup Frontend**

```bash
cd ../frontend
npm install
```

### **5. Create Environment Files**

```bash
# Copy example environment files
cp frontend/.env.example frontend/.env.local
cp backend/.env.example backend/.env
```

---

## 🚀 **Running the Application**

### **Option 1: Automated Script (Windows)**

```cmd
.\dev.bat
```

### **Option 2: Manual Start**

**Backend:**
```bash
cd backend

# Windows
.venv\Scripts\uvicorn app.main:app --reload

# macOS/Linux
.venv/bin/uvicorn app.main:app --reload
```

**Frontend (new terminal):**
```bash
cd frontend
npm run dev
```

### **🌐 Access Your Application**

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000  
- **API Documentation**: http://localhost:8000/docs

---

## 🔧 **Troubleshooting**

### **Common Issues:**

**1. Git not found**
- Install Git from: https://git-scm.com/downloads
- Make sure it's added to your PATH

**2. Python not found**
- Install Python from: https://www.python.org/downloads/
- Check "Add Python to PATH" during installation

**3. Node.js not found**
- Install Node.js from: https://nodejs.org/
- Restart your terminal after installation

**4. Permission errors (Linux/macOS)**
```bash
# Make script executable
chmod +x setup.sh
```

**5. PowerShell execution policy (Windows)**
```powershell
# Allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**6. Port already in use**
```bash
# Check what's using the port
netstat -tulpn | grep :8000  # Linux/macOS
netstat -ano | findstr :8000  # Windows

# Kill the process using the port
kill -9 <PID>  # Linux/macOS
taskkill /PID <PID> /F  # Windows
```

---

## 🎯 **Quick Commands Reference**

| Task | Command |
|------|---------|
| **Start Development** | `.\dev.bat` (Windows) |
| **Update Repository** | `git pull origin main` |
| **Install New Dependencies** | `pip install <package>` (backend)<br>`npm install <package>` (frontend) |
| **Build Frontend** | `npm run build` |
| **Reset Environment** | Delete `.venv` and `node_modules`, then re-run setup |

---

## 📁 **Project Structure After Setup**

```
designfillpro/
├── backend/
│   ├── .venv/              # Python virtual environment
│   ├── app/
│   │   └── main.py         # FastAPI application
│   ├── requirements.txt    # Python dependencies
│   └── .env               # Backend configuration
├── frontend/
│   ├── node_modules/      # Node.js dependencies
│   ├── pages/             # Next.js pages
│   ├── package.json       # Frontend dependencies
│   └── .env.local         # Frontend configuration
├── .github/
│   └── workflows/         # Deployment workflows
├── dev.bat               # Development starter (Windows)
├── dev.ps1               # Development starter (PowerShell)
├── DEPLOYMENT.md         # Deployment guide
├── PUBLISH-TO-WEBSITE.md # Website publishing guide
└── README.md             # Main documentation
```

---

## 🚀 **Next Steps After Setup**

1. **✅ Test locally** - Make sure everything works
2. **🎨 Customize** - Modify the code for your needs
3. **🌐 Deploy** - Use the deployment guides to go live
4. **📚 Read docs** - Check out all the `.md` files for guides

---

## 📞 **Getting Help**

- **📖 Documentation**: Check the `.md` files in the project
- **🐛 Issues**: Create an issue on GitHub
- **💬 Discussions**: Use GitHub Discussions
- **🔗 Repository**: https://github.com/DBCREATIONS-lab/designfillpro

---

## 🎉 **Success!**

If the setup completed successfully, you now have:

✅ **Local development environment** ready to use  
✅ **All dependencies** installed and configured  
✅ **Environment files** created  
✅ **Working application** you can start with `.\dev.bat`  
✅ **Deployment options** ready when you need them  

**Happy coding! 🚀**
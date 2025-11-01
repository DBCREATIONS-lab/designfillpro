#!/bin/bash

# Server Deployment Script for Design Fill Pro
# Run this script on your VPS/dedicated server

echo "🚀 Design Fill Pro - Server Deployment Script"
echo "=============================================="

# Configuration
DOMAIN="yourwebsite.com"
EMAIL="your-email@domain.com"
PROJECT_DIR="/var/www/design-fill-pro"
REPO_URL="https://github.com/DBCREATIONS-lab/designfillpro.git"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "📦 Installing dependencies..."

# Update system
apt update && apt upgrade -y

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl enable docker
    systemctl start docker
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install Nginx
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    apt install nginx -y
    systemctl enable nginx
fi

# Install Certbot for SSL
if ! command -v certbot &> /dev/null; then
    echo "Installing Certbot..."
    apt install certbot python3-certbot-nginx -y
fi

echo "📂 Setting up project directory..."

# Create project directory
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# Clone or update repository
if [ -d ".git" ]; then
    echo "Updating existing repository..."
    git pull origin main
else
    echo "Cloning repository..."
    git clone $REPO_URL .
fi

echo "🐳 Setting up Docker containers..."

# Create production environment file
cat > .env << EOF
# Production Environment Variables
FRONTEND_URL=https://$DOMAIN
NEXT_PUBLIC_API_URL=https://$DOMAIN/api
DOMAIN=$DOMAIN
EOF

# Build and start containers
docker-compose -f docker-compose.prod.yml up -d --build

echo "🌐 Configuring Nginx..."

# Create Nginx configuration
cat > /etc/nginx/sites-available/$DOMAIN << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    
    # Frontend (Next.js)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # Backend API
    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # Handle file uploads
        client_max_body_size 25M;
    }
    
    # Static files and uploads
    location /uploads/ {
        proxy_pass http://localhost:8000/uploads/;
        proxy_set_header Host \$host;
    }
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

if [ $? -eq 0 ]; then
    systemctl reload nginx
    echo "✅ Nginx configuration successful"
else
    echo "❌ Nginx configuration failed"
    exit 1
fi

echo "🔒 Setting up SSL certificate..."

# Get SSL certificate
certbot --nginx -d $DOMAIN -d www.$DOMAIN --email $EMAIL --agree-tos --no-eff-email

echo "🔄 Setting up auto-deployment..."

# Create deployment script
cat > /usr/local/bin/deploy-design-fill-pro << 'EOF'
#!/bin/bash
cd /var/www/design-fill-pro
git pull origin main
docker-compose -f docker-compose.prod.yml up -d --build
echo "Deployment completed at $(date)"
EOF

chmod +x /usr/local/bin/deploy-design-fill-pro

# Create systemd service for auto-updates
cat > /etc/systemd/system/design-fill-pro-deploy.service << EOF
[Unit]
Description=Design Fill Pro Auto Deploy
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/deploy-design-fill-pro
User=root

[Install]
WantedBy=multi-user.target
EOF

# Create timer for daily updates (optional)
cat > /etc/systemd/system/design-fill-pro-deploy.timer << EOF
[Unit]
Description=Design Fill Pro Auto Deploy Timer
Requires=design-fill-pro-deploy.service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable design-fill-pro-deploy.timer
systemctl start design-fill-pro-deploy.timer

echo "🔥 Configuring firewall..."

# Configure UFW firewall
ufw allow ssh
ufw allow 'Nginx Full'
ufw --force enable

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "Your Design Fill Pro website is now live at:"
echo "🌐 https://$DOMAIN"
echo ""
echo "Management commands:"
echo "• Deploy updates: /usr/local/bin/deploy-design-fill-pro"
echo "• Check status: docker-compose -f $PROJECT_DIR/docker-compose.prod.yml ps"
echo "• View logs: docker-compose -f $PROJECT_DIR/docker-compose.prod.yml logs"
echo "• Restart services: docker-compose -f $PROJECT_DIR/docker-compose.prod.yml restart"
echo ""
echo "Auto-deployment is enabled and will check for updates daily."
echo "SSL certificate will auto-renew via Certbot."
echo ""
echo "🎯 Next steps:"
echo "1. Test your website at https://$DOMAIN"
echo "2. Update DNS records to point to this server"
echo "3. Configure any additional settings as needed"
echo ""
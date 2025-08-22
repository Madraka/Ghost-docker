# Ghost with Nginx Proxy Manager

Easy-to-use web interface for managing reverse proxy, SSL certificates, and domains.

## Features

- 🎨 **Web-based GUI** - Manage everything from browser
- 🔒 **Automatic SSL** - Let's Encrypt integration
- 📊 **Statistics** - Traffic monitoring
- 🚀 **Easy setup** - No configuration files needed
- 🔧 **Multi-domain** - Handle multiple sites

## Quick Setup

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit environment variables:**
   ```bash
   nano .env
   ```

3. **Start services:**
   ```bash
   docker-compose -f docker-compose.npm.yml up -d
   ```

4. **Access Nginx Proxy Manager:**
   - URL: http://your-server-ip:81
   - Default login: `admin@example.com`
   - Default password: `changeme`

## Configuration Steps

### 1. Initial Setup
1. Login to NPM admin panel (port 81)
2. Change default admin credentials
3. Go to "Proxy Hosts" section

### 2. Add Ghost Proxy Host
1. Click "Add Proxy Host"
2. **Details Tab:**
   - Domain Names: `your-domain.com`
   - Scheme: `http`
   - Forward Hostname/IP: `ghost`
   - Forward Port: `2368`
   - Cache Assets: ✅
   - Block Common Exploits: ✅
   - Websockets Support: ✅

3. **SSL Tab:**
   - SSL Certificate: "Request a new SSL Certificate"
   - Force SSL: ✅
   - HTTP/2 Support: ✅
   - HSTS Enabled: ✅
   - Email: your-email@domain.com
   - Agree to Let's Encrypt Terms: ✅

4. Click "Save"

### 3. Database Setup (First Run)
NPM will automatically create its database in the shared MySQL instance.

## Access URLs

- **Ghost Blog:** https://your-domain.com
- **Ghost Admin:** https://your-domain.com/ghost
- **NPM Admin:** http://your-server-ip:81

## Advantages

- ✅ **No SSL hassle** - Automatic Let's Encrypt
- ✅ **GUI management** - Point and click setup
- ✅ **Multiple domains** - Easy to add more sites
- ✅ **Real-time stats** - Monitor traffic
- ✅ **Custom headers** - Advanced configuration

## Troubleshooting

### Can't access NPM admin panel
```bash
# Check if container is running
docker-compose -f docker-compose.npm.yml ps

# Check NPM logs
docker-compose -f docker-compose.npm.yml logs nginx-proxy-manager
```

### SSL certificate issues
1. Ensure domain points to your server
2. Check port 80/443 are accessible
3. Verify email address in SSL settings

### Ghost connection issues
- Ensure `ghost` hostname is used in NPM
- Check if Ghost container is running
- Verify port 2368 is accessible internally

## Security Notes

- Change default NPM admin credentials immediately
- Use strong database passwords
- Enable 2FA if available
- Regular backups of NPM data

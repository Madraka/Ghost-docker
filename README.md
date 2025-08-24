# Ghost Docker Setup

🇬🇧 English README | [🇹🇷 Türkçe README](README.tr.md)

[![GitHub Stars](https://img.shields.io/github/stars/Madraka/Ghost-docker?style=social)](https://github.com/Madraka/Ghost-docker/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/Madraka/Ghost-docker?style=social)](https://github.com/Madraka/Ghost-docker/network/members)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Ghost](https://img.shields.io/badge/Ghost-5.x-green.svg)](https://ghost.org/)

This project contains all necessary files to run Ghost blog platform with Docker in both local development and production environments.

## Features

- 🐳 **Official Ghost Docker image** (Alpine-based)
- 🗄️ **MySQL database integration**
- � **Multiple reverse proxy options:**
  - 🔧 **Nginx** - Traditional setup with manual SSL
  - 🎨 **Nginx Proxy Manager** - GUI-based management
  - ⚡ **Traefik** - Modern cloud-native proxy
  - ☁️ **Cloudflare Tunnel** - Zero-config secure tunnel
  - 🚀 **Caddy** - Simple automatic HTTPS
- 📧 **Email configuration support**
- 🔧 **Separate configurations for development and production**
- 📊 **Adminer for database management (development)**
- 🛡️ **Security headers and rate limiting**
- 🔄 **Easy migration between proxy solutions**

## Quick Start

### Automated Setup (Recommended)

The easiest way to get started is using our setup script which handles all configurations:

```bash
git clone https://github.com/Madraka/Ghost-docker.git
cd Ghost-docker
chmod +x setup.sh
./setup.sh
```

The script will guide you through:
- Environment selection (Development/Production)
- Proxy selection (for production)
- Automatic configuration
- Container startup

### Manual Setup

#### Development (Local)

For local development without proxy:

1. **Clone and enter directory:**
   ```bash
   git clone https://github.com/Madraka/Ghost-docker.git
   cd Ghost-docker
   ```

2. **Start development environment:**
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

3. **Access Ghost:**
   - Blog: http://localhost:2368
   - Admin Panel: http://localhost:2368/ghost
   - Adminer (DB): http://localhost:8080

#### Production (With Proxy)

For production, choose one of the proxy configurations from `proxy-configs/` directory:

```bash
# Example with Nginx Proxy Manager
cd proxy-configs/nginx-proxy-manager
cp .env.example .env
# Edit .env with your settings
nano .env
docker-compose -f docker-compose.npm.yml up -d
```

#### Production (Without Proxy)

⚠️ **Not recommended for public sites** - Use only for testing or internal networks:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## Reverse Proxy Options

This project includes multiple reverse proxy configurations to suit different needs:

| Proxy | Difficulty | GUI | Auto SSL | Best For |
|-------|------------|-----|----------|----------|
| **Nginx** | Medium | ❌ | ❌ | Traditional setups, full control |
| **Nginx Proxy Manager** | Easy | ✅ | ✅ | Beginners, GUI lovers |
| **Traefik** | Medium | ✅ | ✅ | Container orchestration |
| **Cloudflare Tunnel** | Easy | ✅ | ✅ | Zero-config, maximum security |
| **Caddy** | Easy | ❌ | ✅ | Simple config, modern features |

### Quick Recommendations

- **Beginners:** Nginx Proxy Manager or Cloudflare Tunnel
- **Advanced Users:** Nginx or Traefik  
- **Maximum Security:** Cloudflare Tunnel
- **Simplest Config:** Caddy
- **Enterprise:** Nginx or Traefik

For detailed setup instructions, see [`proxy-configs/README.md`](proxy-configs/README.md)

### Production Environment

1. **Create environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` file:**
   - Set strong passwords
   - Configure your domain name
   - Set up email settings

3. **Create SSL certificates:**
   ```bash
   mkdir -p nginx/ssl
   # Place your SSL certificates in nginx/ssl/ directory
   # Required files: cert.pem and key.pem
   ```

4. **Update production configuration:**
   - Update domain and email settings in `config.production.json`
   - Update domain name in `nginx/nginx.conf`

5. **Start production environment:**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

## File Structure

```
.
├── Dockerfile                   # Custom Docker image (optional)
├── docker-compose.dev.yml      # Development environment
├── docker-compose.prod.yml     # Production environment (basic)
├── config.development.json     # Development configuration
├── config.production.json      # Production configuration
├── .env.example                # Environment variables template
├── nginx/                      # Basic Nginx configuration
│   └── nginx.conf              # Nginx configuration
├── mysql/                      # MySQL optimization
│   └── my.cnf                  # MySQL configuration
├── proxy-configs/              # 🔄 Multiple reverse proxy options
│   ├── nginx/                  # Traditional Nginx setup
│   ├── nginx-proxy-manager/    # GUI-based proxy management
│   ├── traefik/                # Modern cloud-native proxy
│   ├── cloudflare-tunnel/      # Zero-config secure tunnel
│   ├── caddy/                  # Simple automatic HTTPS
│   └── README.md               # Proxy comparison guide
├── setup.sh                   # Automated setup script
├── README.md                   # English documentation
└── README.tr.md               # Turkish documentation
```

## Commands

### Development

```bash
# Start environment
docker-compose -f docker-compose.dev.yml up -d

# Follow logs
docker-compose -f docker-compose.dev.yml logs -f ghost-dev

# Stop environment
docker-compose -f docker-compose.dev.yml down

# Clean up with volumes
docker-compose -f docker-compose.dev.yml down -v
```

### Production

```bash
# Start environment
docker-compose -f docker-compose.prod.yml up -d

# Follow logs
docker-compose -f docker-compose.prod.yml logs -f ghost

# Stop environment
docker-compose -f docker-compose.prod.yml down

# Create backup
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup.sql
```

## 🔄 Ghost Version Management

This setup provides dynamic Ghost version control through environment variables, allowing you to easily upgrade or downgrade Ghost versions without editing multiple docker-compose files.

### How It Works

All docker-compose files use the `GHOST_VERSION` environment variable:
```yaml
services:
  ghost:
    image: ghost:${GHOST_VERSION:-alpine}
```

The `:-alpine` provides a default value if `GHOST_VERSION` is not set.

### Available Ghost Versions

You can use any official Ghost Docker tag:

| Version | Tag | Description |
|---------|-----|-------------|
| **Latest Stable** | `alpine` | Always latest stable (auto-updates) |
| **Version 5** | `5-alpine` | Latest version 5.x |
| **Specific Version** | `5.87.0-alpine` | Exact version (recommended for production) |
| **Version 4** | `4-alpine` | Latest version 4.x (legacy) |

### Setting Ghost Version

#### Method 1: Environment File (.env)

Set `GHOST_VERSION` in your `.env` file:

```bash
# For latest stable version
GHOST_VERSION=alpine

# For specific version (recommended for production)
GHOST_VERSION=5.87.0-alpine

# For version 5.x latest
GHOST_VERSION=5-alpine
```

#### Method 2: Command Line

```bash
# Set version for current session
export GHOST_VERSION=5.87.0-alpine

# Start with specific version
GHOST_VERSION=5.87.0-alpine docker-compose -f docker-compose.prod.yml up -d
```

### Upgrade/Downgrade Process

#### Development Environment
```bash
# 1. Stop current containers
docker-compose -f docker-compose.dev.yml down

# 2. Update GHOST_VERSION in .env file
echo "GHOST_VERSION=5.87.0-alpine" >> .env

# 3. Pull new image
docker pull ghost:5.87.0-alpine

# 4. Start with new version
docker-compose -f docker-compose.dev.yml up -d
```

#### Production Environment
```bash
# 1. Create backup first (important!)
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup_before_upgrade.sql

# 2. Stop containers
docker-compose -f docker-compose.prod.yml down

# 3. Update GHOST_VERSION in .env file
nano .env  # Edit GHOST_VERSION=new-version-here

# 4. Pull new image
docker pull ghost:new-version-here

# 5. Start with new version
docker-compose -f docker-compose.prod.yml up -d

# 6. Check logs for any issues
docker-compose -f docker-compose.prod.yml logs -f ghost
```

#### Proxy Configurations
For proxy setups, update the `.env` file in the respective proxy directory:
```bash
# Example: Nginx Proxy Manager
cd proxy-configs/nginx-proxy-manager
nano .env  # Update GHOST_VERSION
docker-compose -f docker-compose.npm.yml down
docker-compose -f docker-compose.npm.yml up -d
```

### Version Recommendations

| Environment | Recommended | Reason |
|------------|------------|---------|
| **Development** | `alpine` | Always latest features for testing |
| **Staging** | `5-alpine` | Latest stable for pre-production testing |
| **Production** | `5.87.0-alpine` | Specific version for maximum stability |

### Data Safety

Your content is always preserved during version changes because:
- ✅ **Content in Docker volumes** - Survives container recreation
- ✅ **Database separate** - Independent of Ghost updates
- ✅ **Automatic migrations** - Ghost handles database schema updates

### Rollback Process

If an upgrade causes issues:
```bash
# 1. Stop containers
docker-compose down

# 2. Restore previous version in .env
GHOST_VERSION=previous-version

# 3. Restore database backup if needed
docker-compose exec -i mysql mysql -u ghost -p ghost_production < backup_before_upgrade.sql

# 4. Start with previous version
docker-compose up -d
```

## Database Backup
```

## SSL Certificate Setup

Production environment requires SSL certificates. You can use Let's Encrypt:

```bash
# Get SSL certificate using Certbot (on server)
sudo certbot certonly --standalone -d your-domain.com
sudo cp /etc/letsencrypt/live/your-domain.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/your-domain.com/privkey.pem nginx/ssl/key.pem
```

## Database Backup

```bash
# Create backup
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore backup
docker-compose -f docker-compose.prod.yml exec -i mysql mysql -u ghost -p ghost_production < backup.sql
```

## Environment Variables

Required environment variables for production (`.env` file):

| Variable | Description | Example |
|----------|-------------|---------|
| `DB_ROOT_PASSWORD` | MySQL root password | `your-strong-root-password` |
| `DB_PASSWORD` | Ghost database password | `your-strong-ghost-password` |
| `GHOST_URL` | Your domain URL | `https://your-domain.com` |
| `MAIL_SERVICE` | Email service provider | `Gmail` |
| `MAIL_USER` | Email username | `your-email@gmail.com` |
| `MAIL_PASSWORD` | Email password/app password | `your-app-password` |
| `MAIL_FROM` | From email address | `your-email@gmail.com` |

## Troubleshooting

### Ghost can't connect to database
```bash
# Check container logs
docker-compose logs ghost

# Test MySQL connection
docker-compose exec mysql mysql -u ghost -p ghost_production
```

### Port conflicts
- Development: Ports 2368, 3306, 8080
- Production: Ports 2368, 80, 443

Make sure these ports are not in use by other services.

### Permission issues
```bash
# Fix content directory permissions
docker-compose exec ghost chown -R node:node /var/lib/ghost/content
```

## Security Notes

1. **Use strong passwords in production**
2. **Regularly renew SSL certificates**
3. **Keep MySQL root password secure**
4. **Configure firewall rules**
5. **Take regular backups**
6. **Update Ghost regularly (see Update section below)**

## Ghost Updates & Data Safety

### 🔄 Update Strategy

**Current Setup: Manual Updates (Recommended for Production)**

This setup uses fixed Ghost version (`ghost:5-alpine`) which means:
- ✅ **No automatic updates** - Your site won't break unexpectedly
- ✅ **Data safety** - Your content and settings are preserved
- ✅ **Predictable behavior** - Same version until you manually update
- ✅ **Testing opportunity** - You can test updates in development first

### 📊 Data Persistence

Your data is safe during updates because:
- **Content stored in Docker volumes** - Survives container recreation
- **Database in separate container** - Independent of Ghost updates
- **Themes and uploads preserved** - Stored in persistent volumes

### 🚀 How to Update Ghost

#### Development Environment
```bash
# 1. Backup your content (optional but recommended)
docker-compose -f docker-compose.dev.yml exec mysql mysqldump -u ghost -p ghost_dev > backup_dev.sql

# 2. Pull latest Ghost image
docker pull ghost:5-alpine

# 3. Recreate containers with new image
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml up -d

# 4. Check everything works
docker-compose -f docker-compose.dev.yml logs -f ghost-dev
```

#### Production Environment
```bash
# 1. ALWAYS backup first
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup_$(date +%Y%m%d_%H%M%S).sql

# 2. Test the update in development first
# (Use development commands above)

# 3. Update production
docker pull ghost:5-alpine
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d

# 4. Verify everything works
docker-compose -f docker-compose.prod.yml logs -f ghost
```

### 🔄 Auto-Update Option (Advanced)

If you want automatic updates (use with caution in production):

**For Development:**
```yaml
# In docker-compose.dev.yml, change:
image: ghost:5-alpine
# To:
image: ghost:alpine  # Always latest
```

**For Production with Watchtower:**
```yaml
# Add to docker-compose.prod.yml
services:
  watchtower:
    image: containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 86400 --cleanup  # Check daily
    restart: unless-stopped
```

### 📋 Update Checklist

- [ ] Backup database
- [ ] Test in development
- [ ] Check Ghost release notes
- [ ] Update in production
- [ ] Verify admin panel works
- [ ] Test theme functionality
- [ ] Check email sending
- [ ] Monitor for 24 hours

### 🛡️ Rollback Strategy

If something goes wrong:
```bash
# 1. Stop current containers
docker-compose down

# 2. Use specific older version
# Change image to: ghost:5.xx.x-alpine (specific version)

# 3. Restore database if needed
docker-compose exec -i mysql mysql -u ghost -p ghost_production < backup.sql

# 4. Start containers
docker-compose up -d
```

## Performance Optimization

### MySQL Tuning
The included `mysql/my.cnf` file contains optimized settings for Ghost:
- Increased buffer pool size
- Optimized log file size
- UTF8MB4 character set for emoji support

### Nginx Optimization
- Gzip compression enabled
- Static file caching
- Rate limiting configured
- Security headers included

## Development Workflow

1. **Make changes to Ghost themes or content**
2. **Test in development environment**
3. **Create backup of production data**
4. **Deploy to production environment**
5. **Monitor logs for any issues**

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test both development and production environments
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

If you encounter any issues:
1. Check container logs
2. Verify port usage
3. Review configuration files
4. Check the troubleshooting section
5. Open an issue on GitHub

## Acknowledgments

- [Ghost](https://ghost.org/) - The publication platform
- [Docker](https://docker.com/) - Containerization platform
- [Nginx](https://nginx.org/) - Web server and reverse proxy
- [MySQL](https://mysql.com/) - Database system

---

**Made with ❤️ for the Ghost community**

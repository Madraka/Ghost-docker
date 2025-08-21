# Ghost Docker Setup

🇬🇧 English README | [🇹🇷 Türkçe README](README.tr.md)

[![GitHub Stars](https://img.shields.io/github/stars/Madraka/Ghost-docker?style=social)](https://github.com/Madraka/Ghost-docker/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/Madraka/Ghost-docker?style=social)](https://github.com/Madraka/Ghost-docker/network/members)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Ghost](https://img.shields.io/badge/Ghost-5.x-green.svg)](https://ghost.org/)

This project contains all necessary files to run Ghost blog platform with Docker in both local development and production environments.

## Features

- 🐳 Official Ghost Docker image (Alpine-based)
- 🗄️ MySQL database integration
- 🔒 Nginx reverse proxy with SSL support
- 📧 Email configuration support
- 🔧 Separate configurations for development and production
- 📊 Adminer for database management (development)
- 🚀 Production-ready configuration
- 🛡️ Security headers and rate limiting

## Quick Start

### Development Environment

1. **Clone the project and navigate to directory:**
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

### Auto Setup (Recommended)

For an automated setup process, you can use the included setup script:

```bash
git clone https://github.com/Madraka/Ghost-docker.git
cd Ghost-docker
chmod +x setup.sh
./setup.sh
```

The script will guide you through the setup process for both development and production environments.

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
├── docker-compose.prod.yml     # Production environment
├── config.development.json     # Development configuration
├── config.production.json      # Production configuration
├── .env.example                # Environment variables template
├── nginx/
│   └── nginx.conf              # Nginx configuration
├── mysql/
│   └── my.cnf                  # MySQL configuration
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

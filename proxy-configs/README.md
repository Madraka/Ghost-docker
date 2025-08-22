# Reverse Proxy Configurations for Ghost

This directory contains various reverse proxy configurations for running Ghost in production. Each proxy solution offers different advantages and use cases.

## Available Proxy Solutions

| Proxy | Difficulty | GUI | Auto SSL | Best For |
|-------|------------|-----|----------|----------|
| [Nginx](nginx/) | Medium | ❌ | ❌ | Traditional setups, full control |
| [Nginx Proxy Manager](nginx-proxy-manager/) | Easy | ✅ | ✅ | Beginners, GUI lovers |
| [Traefik](traefik/) | Medium | ✅ | ✅ | Container orchestration |
| [Cloudflare Tunnel](cloudflare-tunnel/) | Easy | ✅ | ✅ | Zero-config, maximum security |
| [Caddy](caddy/) | Easy | ❌ | ✅ | Simple config, modern features |

## Quick Comparison

### 🔒 Nginx (Traditional)
- **Pros:** Battle-tested, full control, extensive documentation
- **Cons:** Manual SSL management, complex configuration
- **Use Case:** When you need maximum control and customization

### 🎨 Nginx Proxy Manager (GUI)
- **Pros:** Web interface, automatic SSL, easy to use
- **Cons:** Additional overhead, less customizable
- **Use Case:** Perfect for beginners or GUI preference

### ⚡ Traefik (Cloud-Native)
- **Pros:** Service discovery, automatic SSL, modern architecture
- **Cons:** Learning curve, Docker-centric
- **Use Case:** Microservices, container orchestration

### ☁️ Cloudflare Tunnel (Zero-Config)
- **Pros:** No open ports, global CDN, DDoS protection
- **Cons:** Requires Cloudflare account, vendor lock-in
- **Use Case:** Maximum security, zero server configuration

### 🚀 Caddy (Modern)
- **Pros:** Automatic HTTPS, simple config, modern features
- **Cons:** Newer ecosystem, fewer plugins
- **Use Case:** Simple deployments, automatic SSL

## How to Choose

### For Beginners
1. **Cloudflare Tunnel** - Zero configuration needed
2. **Nginx Proxy Manager** - Easy GUI interface
3. **Caddy** - Simple configuration file

### For Advanced Users
1. **Nginx** - Maximum control and customization
2. **Traefik** - Container orchestration and service discovery

### For Specific Needs

**Maximum Security:** Cloudflare Tunnel
**Easiest Setup:** Nginx Proxy Manager
**Best Performance:** Nginx
**Most Modern:** Traefik or Caddy
**Enterprise:** Nginx or Traefik

## Setup Instructions

Each proxy configuration includes:
- Complete Docker Compose file
- Environment variables template
- Detailed setup instructions
- Troubleshooting guide
- Security recommendations

### General Steps
1. Choose your proxy solution
2. Navigate to the respective directory
3. Follow the README instructions
4. Copy and edit environment variables
5. Start with Docker Compose

## Migration Between Proxies

All configurations use the same Ghost and MySQL setup, making migration easy:

1. Stop current proxy: `docker-compose down`
2. Backup your data: `docker-compose exec mysql mysqldump...`
3. Switch to new proxy directory
4. Update environment variables
5. Start new proxy: `docker-compose up -d`

## Common Environment Variables

All proxy solutions use these common variables:

```env
# Database
DB_ROOT_PASSWORD=your-strong-root-password
DB_PASSWORD=your-strong-ghost-password

# Ghost
GHOST_URL=https://your-domain.com

# Email
MAIL_SERVICE=Gmail
MAIL_USER=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_FROM=your-email@gmail.com
```

Additional variables specific to each proxy are documented in their respective directories.

## Security Considerations

Regardless of proxy choice:
- Use strong passwords
- Keep software updated
- Monitor access logs
- Enable rate limiting
- Use HTTPS everywhere
- Regular security audits

## Performance Tips

- Enable compression (gzip/brotli)
- Configure caching headers
- Use CDN when possible
- Monitor resource usage
- Optimize SSL/TLS settings
- Enable HTTP/2 or HTTP/3

## Support

Each proxy configuration includes:
- Detailed documentation
- Common troubleshooting steps
- Performance optimization tips
- Security best practices

For Ghost-specific issues, refer to the main project documentation.

## Contributing

To add a new proxy configuration:
1. Create new directory under `proxy-configs/`
2. Include complete Docker Compose setup
3. Add comprehensive README
4. Update this comparison table
5. Test thoroughly before submitting

---

**Choose the proxy that best fits your needs and expertise level!** 🚀

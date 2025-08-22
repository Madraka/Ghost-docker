# Ghost with Traefik

Modern reverse proxy with automatic HTTPS, service discovery, and real-time configuration.

## Features

- 🚀 **Automatic SSL** - Let's Encrypt integration
- 📊 **Web Dashboard** - Real-time monitoring
- 🔄 **Dynamic Configuration** - No restarts needed
- 🏷️ **Label-based** - Configure via Docker labels
- ⚡ **High Performance** - Built for cloud-native

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
   docker-compose -f docker-compose.traefik.yml up -d
   ```

4. **Access services:**
   - Ghost: https://your-domain.com
   - Traefik Dashboard: http://your-server-ip:8080

## How It Works

Traefik uses Docker labels to automatically discover and configure services:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.ghost.rule=Host(`your-domain.com`)"
  - "traefik.http.routers.ghost.tls.certresolver=letsencrypt"
```

## Configuration Features

### Automatic HTTPS
- Let's Encrypt certificates
- Automatic renewal
- HTTP to HTTPS redirect

### Security Headers
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block
- X-Content-Type-Options: nosniff
- SSL redirect enabled

### Load Balancing
- Automatic service discovery
- Health checks
- Multiple backend support

## Access URLs

- **Ghost Blog:** https://your-domain.com
- **Ghost Admin:** https://your-domain.com/ghost
- **Traefik Dashboard:** http://your-server-ip:8080

## Dashboard Features

The Traefik dashboard provides:
- Service overview
- Router configuration
- Certificate status
- Health checks
- Real-time metrics

## Advanced Configuration

### Custom Middleware
Add custom middleware in docker-compose labels:

```yaml
labels:
  # Rate limiting
  - "traefik.http.middlewares.ratelimit.ratelimit.burst=100"
  - "traefik.http.routers.ghost.middlewares=ratelimit"
  
  # Basic auth for admin
  - "traefik.http.middlewares.auth.basicauth.users=admin:$$2y$$10$$..."
```

### Multiple Domains
Add multiple domains to the same service:

```yaml
labels:
  - "traefik.http.routers.ghost.rule=Host(`domain1.com`) || Host(`domain2.com`)"
```

## Troubleshooting

### Certificate issues
```bash
# Check Traefik logs
docker-compose -f docker-compose.traefik.yml logs traefik

# Verify ACME configuration
docker exec traefik cat /letsencrypt/acme.json
```

### Service discovery issues
```bash
# Check if services are detected
curl http://localhost:8080/api/http/services

# Verify labels are correct
docker inspect ghost | grep -A 20 Labels
```

### Dashboard not accessible
- Ensure port 8080 is open
- Check if `api.insecure=true` is set
- Verify Traefik container is running

## Security Considerations

- **Dashboard Security:** Consider securing the dashboard with authentication
- **Network Isolation:** Use Docker networks for service isolation
- **SSL Configuration:** Regularly update SSL certificates
- **Access Logs:** Monitor access patterns

## Migration from Nginx

1. Stop current Nginx setup
2. Update Ghost URL configuration
3. Start Traefik setup
4. Verify SSL certificates are issued
5. Test all functionality

## Production Tips

- Use external certificate resolver for multiple instances
- Enable access logs for monitoring
- Set up monitoring and alerting
- Regular backup of ACME certificates

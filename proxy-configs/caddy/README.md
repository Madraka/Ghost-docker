# Ghost with Caddy

Modern web server with automatic HTTPS, simple configuration, and powerful features.

## Features

- 🔒 **Automatic HTTPS** - Zero-config SSL certificates
- 📝 **Simple Config** - Human-readable Caddyfile
- 🔄 **Auto Reload** - Configuration changes without restart
- 🚀 **High Performance** - Built for modern web
- 📊 **Built-in Metrics** - Prometheus-compatible metrics
- 🛡️ **Security First** - Secure defaults out of the box

## Quick Setup

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit environment variables:**
   ```bash
   nano .env
   ```

3. **Customize Caddyfile (optional):**
   ```bash
   nano Caddyfile
   ```

4. **Start services:**
   ```bash
   docker-compose -f docker-compose.caddy.yml up -d
   ```

## Caddyfile Explanation

The `Caddyfile` uses simple, human-readable syntax:

```caddyfile
your-domain.com {
    reverse_proxy ghost:2368
    encode gzip
    header X-Frame-Options "SAMEORIGIN"
}
```

### Key Features in Our Config

- **Automatic HTTPS** - Caddy handles SSL certificates
- **Compression** - Gzip encoding for better performance
- **Security Headers** - XSS protection, frame options, etc.
- **Rate Limiting** - Protect admin panel from abuse
- **Logging** - JSON formatted access logs

## Access URLs

- **Ghost Blog:** https://your-domain.com
- **Ghost Admin:** https://your-domain.com/ghost
- **Caddy Metrics:** http://your-server-ip:2019/metrics

## Advanced Configuration

### Custom Headers
```caddyfile
your-domain.com {
    reverse_proxy ghost:2368
    
    header {
        Custom-Header "Custom Value"
        -Unwanted-Header
    }
}
```

### Basic Authentication
```caddyfile
admin.your-domain.com {
    reverse_proxy ghost:2368
    
    basicauth {
        admin $2a$14$hashed_password
    }
}
```

### File Server for Static Content
```caddyfile
static.your-domain.com {
    root * /var/www/static
    file_server
}
```

### Load Balancing
```caddyfile
your-domain.com {
    reverse_proxy ghost1:2368 ghost2:2368 {
        health_uri /
        health_interval 30s
    }
}
```

## SSL Certificate Management

Caddy automatically:
- Obtains certificates from Let's Encrypt
- Renews certificates before expiration
- Serves HTTP-01 and TLS-ALPN-01 challenges
- Stores certificates in `/data/caddy`

### Custom Certificate Authority
```caddyfile
{
    acme_ca https://acme.zerossl.com/v2/DV90
    email your-email@domain.com
}
```

## Monitoring & Metrics

Access Prometheus metrics:
```bash
curl http://localhost:2019/metrics
```

Key metrics include:
- Request count and duration
- Response codes
- Active connections
- Certificate status

## Troubleshooting

### Certificate Issues
```bash
# Check Caddy logs
docker-compose -f docker-compose.caddy.yml logs caddy

# Verify domain accessibility
curl -I https://your-domain.com
```

### Configuration Errors
```bash
# Validate Caddyfile syntax
docker exec caddy caddy validate --config /etc/caddy/Caddyfile

# Reload configuration
docker exec caddy caddy reload --config /etc/caddy/Caddyfile
```

### Performance Issues
```bash
# Check resource usage
docker stats caddy

# Monitor access logs
docker exec caddy tail -f /var/log/caddy/access.log
```

## Security Features

### Automatic Security Headers
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- X-Frame-Options: SAMEORIGIN
- Referrer-Policy: strict-origin-when-cross-origin

### Rate Limiting
Protects against abuse:
```caddyfile
rate_limit {
    zone admin
    key {remote}
    events 30
    window 1m
}
```

### IP Filtering
```caddyfile
@blocked {
    remote_ip 192.168.1.100
}
respond @blocked "Access Denied" 403
```

## Performance Optimization

### Caching
```caddyfile
@static {
    path *.css *.js *.png *.jpg *.gif *.ico *.svg
}
header @static Cache-Control "public, max-age=31536000"
```

### Compression
```caddyfile
encode gzip zstd {
    match {
        header Content-Type text/*
        header Content-Type application/json*
        header Content-Type application/javascript*
        header Content-Type application/xhtml+xml*
        header Content-Type application/atom+xml*
        header Content-Type application/rss+xml*
        header Content-Type image/svg+xml*
    }
}
```

## Migration from Other Proxies

### From Nginx
1. Convert nginx.conf directives to Caddyfile syntax
2. Update SSL certificate paths (Caddy manages automatically)
3. Test configuration with `caddy validate`

### From Apache
1. Convert .htaccess rules to Caddyfile
2. Update virtual host configurations
3. Verify all redirects work correctly

## Production Tips

- **Monitor certificate expiration** (though Caddy auto-renews)
- **Regular config backups** of Caddyfile
- **Set up log rotation** for access logs
- **Use environment variables** for sensitive data
- **Enable metrics collection** for monitoring

## Advantages over Traditional Proxies

- ✅ **Zero SSL configuration** - Automatic certificate management
- ✅ **Simple syntax** - Easy to read and maintain
- ✅ **Built-in security** - Secure defaults
- ✅ **Auto-reload** - Changes without downtime
- ✅ **Modern features** - HTTP/2, HTTP/3 support
- ✅ **Plugin ecosystem** - Extensible architecture

## Limitations

- Relatively newer compared to Nginx/Apache
- Less third-party documentation
- Some advanced features require plugins
- Learning curve for complex configurations

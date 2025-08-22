# Ghost with Cloudflare Tunnel

Secure, zero-configuration tunnel that exposes your Ghost blog through Cloudflare's global network.

## Features

- 🔒 **No open ports** - No firewall configuration needed
- 🌍 **Global CDN** - Cloudflare's worldwide network
- 🛡️ **DDoS Protection** - Built-in attack mitigation
- 🚀 **Zero Config** - No SSL certificates to manage
- 📊 **Analytics** - Built-in traffic analytics
- 🔐 **Access Control** - Cloudflare Access integration

## Prerequisites

1. **Cloudflare Account** - Free account required
2. **Domain on Cloudflare** - Your domain must use Cloudflare nameservers
3. **Zero Trust Plan** - Free tier includes 50 users

## Setup Steps

### 1. Create Cloudflare Tunnel

1. Go to [Cloudflare Zero Trust Dashboard](https://one.dash.cloudflare.com/)
2. Navigate to **Access** → **Tunnels**
3. Click **Create a tunnel**
4. Choose **Cloudflared**
5. Give your tunnel a name (e.g., "ghost-blog")
6. Copy the tunnel token

### 2. Configure Environment

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit .env file:**
   ```bash
   nano .env
   ```

3. **Add your tunnel token:**
   ```env
   CLOUDFLARE_TUNNEL_TOKEN=your-actual-tunnel-token-here
   GHOST_URL=https://your-domain.com
   ```

### 3. Configure Public Hostname

In Cloudflare Zero Trust Dashboard:

1. Go to your tunnel settings
2. Click **Public Hostnames** tab
3. Click **Add a public hostname**
4. Configure:
   - **Subdomain:** `blog` (or leave empty for root)
   - **Domain:** `your-domain.com`
   - **Service Type:** `HTTP`
   - **URL:** `ghost:2368`

### 4. Start Services

```bash
docker-compose -f docker-compose.cloudflare.yml up -d
```

## Access URLs

- **Ghost Blog:** https://your-domain.com
- **Ghost Admin:** https://your-domain.com/ghost
- **Cloudflare Dashboard:** https://one.dash.cloudflare.com/

## Advanced Configuration

### Multiple Subdomains

Add multiple public hostnames in Cloudflare:

- `blog.your-domain.com` → `ghost:2368`
- `admin.your-domain.com` → `ghost:2368` (with path `/ghost/*`)

### Access Control

Protect admin routes with Cloudflare Access:

1. Go to **Access** → **Applications**
2. Create new application
3. Configure:
   - **Domain:** `your-domain.com`
   - **Path:** `/ghost/*`
   - **Policy:** Email domain, specific users, etc.

### Configuration File Method

For advanced setups, use configuration file:

1. Uncomment the `cloudflared-config` service
2. Edit `cloudflared-config.yml`
3. Add your tunnel credentials

## Monitoring

### Tunnel Status
```bash
# Check tunnel logs
docker-compose -f docker-compose.cloudflare.yml logs cloudflared

# Check tunnel status in Cloudflare dashboard
```

### Analytics
- View traffic analytics in Cloudflare dashboard
- Monitor performance metrics
- Track security events

## Troubleshooting

### Tunnel not connecting
```bash
# Check cloudflared logs
docker-compose logs cloudflared

# Verify tunnel token is correct
echo $CLOUDFLARE_TUNNEL_TOKEN
```

### Domain not resolving
1. Verify domain is on Cloudflare
2. Check DNS settings in Cloudflare
3. Ensure tunnel is active

### Ghost not accessible
1. Verify Ghost container is running
2. Check internal network connectivity
3. Confirm public hostname configuration

## Security Benefits

- **No Exposed Ports** - Server ports remain closed
- **DDoS Protection** - Cloudflare shields your server
- **Bot Management** - Automatic bot filtering
- **WAF Protection** - Web Application Firewall
- **Rate Limiting** - Built-in request limiting

## Cost Considerations

- **Cloudflare Tunnel** - Free for up to 50 users
- **Bandwidth** - Unlimited on all plans
- **Additional Features** - Some advanced features require paid plans

## Migration Steps

### From Other Proxies

1. **Keep existing setup running**
2. **Configure Cloudflare Tunnel**
3. **Test with subdomain first**
4. **Update DNS to point to tunnel**
5. **Remove old proxy configuration**

### Backup Strategy

```bash
# Tunnel configuration is stored in Cloudflare
# Local backup only needs environment variables
cp .env .env.backup
```

## Production Tips

- Use Teams/Access for additional security
- Enable Cloudflare Analytics for insights
- Consider Cloudflare Images for media optimization
- Set up monitoring alerts in Cloudflare
- Regular review of access logs

## Limitations

- Requires Cloudflare account
- Domain must use Cloudflare DNS
- Some advanced networking features limited
- Dependent on Cloudflare service availability

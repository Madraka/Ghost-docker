# Ghost Docker Setup

Bu proje Ghost blog platformunu Docker ile local development ve production ortamında çalıştırmak için gerekli tüm dosyaları içerir.

## Özellikler

- 🐳 Multi-stage Dockerfile (development ve production)
- 🗄️ MySQL veritabanı entegrasyonu
- 🔒 Nginx reverse proxy ile SSL desteği
- 📧 E-posta konfigürasyonu
- 🔧 Development ve production ortamları için ayrı konfigürasyonlar
- 📊 Adminer ile veritabanı yönetimi (development)
- 🚀 Production-ready konfigürasyon

## Hızlı Başlangıç

### Development Ortamı

1. **Projeyi klonlayın ve dizine girin:**
   ```bash
   cd /Users/madraka/Desktop/de.listiy.com
   ```

2. **Development ortamını başlatın:**
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

3. **Ghost'a erişin:**
   - Blog: http://localhost:2368
   - Admin Panel: http://localhost:2368/ghost
   - Adminer (DB): http://localhost:8080

### Production Ortamı

1. **Environment dosyasını oluşturun:**
   ```bash
   cp .env.example .env
   ```

2. **`.env` dosyasını düzenleyin:**
   - Güçlü parolalar ayarlayın
   - Domain adınızı girin
   - E-posta ayarlarını yapılandırın

3. **SSL sertifikalarını oluşturun:**
   ```bash
   mkdir -p nginx/ssl
   # SSL sertifikalarınızı nginx/ssl/ dizinine koyun
   # cert.pem ve key.pem dosyaları gerekli
   ```

4. **Production konfigürasyonunu güncelleyin:**
   - `config.production.json` dosyasında domain ve e-posta ayarlarını güncelleyin
   - `nginx/nginx.conf` dosyasında domain adını güncelleyin

5. **Production ortamını başlatın:**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

## Dosya Yapısı

```
.
├── Dockerfile                   # Multi-stage Docker image
├── docker-compose.dev.yml      # Development ortamı
├── docker-compose.prod.yml     # Production ortamı
├── config.development.json     # Development konfigürasyonu
├── config.production.json      # Production konfigürasyonu
├── .env.example                # Environment değişkenleri örneği
├── nginx/
│   └── nginx.conf              # Nginx konfigürasyonu
├── mysql/
│   └── my.cnf                  # MySQL konfigürasyonu
└── README.md
```

## Komutlar

### Development

```bash
# Ortamı başlat
docker-compose -f docker-compose.dev.yml up -d

# Logları izle
docker-compose -f docker-compose.dev.yml logs -f ghost-dev

# Ortamı durdur
docker-compose -f docker-compose.dev.yml down

# Volumes ile birlikte temizle
docker-compose -f docker-compose.dev.yml down -v
```

### Production

```bash
# Ortamı başlat
docker-compose -f docker-compose.prod.yml up -d

# Logları izle
docker-compose -f docker-compose.prod.yml logs -f ghost

# Ortamı durdur
docker-compose -f docker-compose.prod.yml down

# Backup alma
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup.sql
```

## SSL Sertifikası

Production ortamı için SSL sertifikası gereklidir. Let's Encrypt kullanabilirsiniz:

```bash
# Certbot ile SSL sertifikası alma (sunucuda)
sudo certbot certonly --standalone -d your-domain.com
sudo cp /etc/letsencrypt/live/your-domain.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/your-domain.com/privkey.pem nginx/ssl/key.pem
```

## Veritabanı Yedekleme

```bash
# Backup alma
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup_$(date +%Y%m%d_%H%M%S).sql

# Backup geri yükleme
docker-compose -f docker-compose.prod.yml exec -i mysql mysql -u ghost -p ghost_production < backup.sql
```

## Troubleshooting

### Ghost bağlanamıyor
```bash
# Container loglarını kontrol edin
docker-compose logs ghost

# MySQL bağlantısını test edin
docker-compose exec mysql mysql -u ghost -p ghost_production
```

### Port çakışması
- Development: Port 2368, 3306, 8080
- Production: Port 2368, 80, 443

Bu portların kullanılmadığından emin olun.

## Güvenlik Notları

1. **Production'da güçlü parolalar kullanın**
2. **SSL sertifikalarını düzenli olarak yenileyin**
3. **MySQL root parolasını güvenli tutun**
4. **Firewall kurallarını ayarlayın**
5. **Düzenli backup alın**

## Destek

Herhangi bir sorun yaşarsanız:
1. Container loglarını kontrol edin
2. Port kullanımını kontrol edin
3. Konfigürasyon dosyalarını gözden geçirin

# Ghost Docker Setup

[🇬🇧 English README](README.md) | 🇹🇷 Türkçe README

[![GitHub Stars](https://img.shields.io/github/stars/Madraka/Ghost-docker?style=social)](https://github.com/Madraka/Ghost-docker/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/Madraka/Ghost-docker?style=social)](https://github.com/Madraka/Ghost-docker/network/members)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Ghost](https://img.shields.io/badge/Ghost-5.x-green.svg)](https://ghost.org/)

Bu proje Ghost blog platformunu Docker ile local development ve production ortamında çalıştırmak için gerekli tüm dosyaları içerir.

## Özellikler

- 🐳 **Resmi Ghost Docker image** (Alpine tabanlı)
- 🗄️ **MySQL veritabanı entegrasyonu**
- � **Çoklu reverse proxy seçenekleri:**
  - 🔧 **Nginx** - Geleneksel kurulum, manuel SSL
  - 🎨 **Nginx Proxy Manager** - GUI tabanlı yönetim
  - ⚡ **Traefik** - Modern bulut-native proxy
  - ☁️ **Cloudflare Tunnel** - Sıfır-config güvenli tünel
  - 🚀 **Caddy** - Basit otomatik HTTPS
- 📧 **E-posta konfigürasyon desteği**
- 🔧 **Development ve production için ayrı konfigürasyonlar**
- 📊 **Adminer ile veritabanı yönetimi (development)**
- 🛡️ **Güvenlik başlıkları ve hız sınırlama**
- � **Proxy çözümleri arası kolay geçiş**

## Hızlı Başlangıç

### Development Ortamı

1. **Projeyi klonlayın ve dizine girin:**
   ```bash
   git clone https://github.com/Madraka/Ghost-docker.git
   cd Ghost-docker
   ```

2. **Development ortamını başlatın:**
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

3. **Ghost'a erişin:**
   - Blog: http://localhost:2368
   - Admin Panel: http://localhost:2368/ghost
   - Adminer (DB): http://localhost:8080

### Otomatik Kurulum (Önerilen)

Otomatik kurulum süreci için dahil edilen kurulum scriptini kullanabilirsiniz:

```bash
git clone https://github.com/Madraka/Ghost-docker.git
cd Ghost-docker
chmod +x setup.sh
./setup.sh
```

Script hem development hem production ortamları için kurulum sürecinde size rehberlik edecektir.

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
6. **Ghost'u düzenli güncelleyin (aşağıdaki Güncelleme bölümüne bakın)**

## Ghost Güncellemeleri ve Veri Güvenliği

### 🔄 Güncelleme Stratejisi

**Mevcut Kurulum: Manuel Güncellemeler (Production için Önerilen)**

Bu kurulum sabit Ghost versiyonu (`ghost:5-alpine`) kullanır, bu da şu anlama gelir:
- ✅ **Otomatik güncelleme yok** - Siteniz beklenmedik şekilde bozulmaz
- ✅ **Veri güvenliği** - İçeriğiniz ve ayarlarınız korunur
- ✅ **Öngörülebilir davranış** - Siz manuel güncelleme yapana kadar aynı versiyon
- ✅ **Test fırsatı** - Güncellemeleri önce development'ta test edebilirsiniz

### 📊 Veri Kalıcılığı

Güncellemeler sırasında verileriniz güvende çünkü:
- **İçerik Docker volume'larında** - Container yeniden oluşturulsa bile kalır
- **Veritabanı ayrı container'da** - Ghost güncellemelerinden bağımsız
- **Temalar ve yüklemeler korunur** - Kalıcı volume'larda saklanır

### 🚀 Ghost Nasıl Güncellenir

#### Development Ortamı
```bash
# 1. İçeriğinizi yedekleyin (isteğe bağlı ama önerilen)
docker-compose -f docker-compose.dev.yml exec mysql mysqldump -u ghost -p ghost_dev > backup_dev.sql

# 2. En son Ghost image'ını çekin
docker pull ghost:5-alpine

# 3. Container'ları yeni image ile yeniden oluşturun
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml up -d

# 4. Her şeyin çalıştığını kontrol edin
docker-compose -f docker-compose.dev.yml logs -f ghost-dev
```

#### Production Ortamı
```bash
# 1. HER ZAMAN önce yedek alın
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup_$(date +%Y%m%d_%H%M%S).sql

# 2. Güncellemeyi önce development'ta test edin
# (Yukarıdaki development komutlarını kullanın)

# 3. Production'ı güncelleyin
docker pull ghost:5-alpine
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d

# 4. Her şeyin çalıştığını doğrulayın
docker-compose -f docker-compose.prod.yml logs -f ghost
```

### 🔄 Otomatik Güncelleme Seçeneği (İleri Seviye)

Otomatik güncellemeler istiyorsanız (production'da dikkatli kullanın):

**Development İçin:**
```yaml
# docker-compose.dev.yml'de değiştirin:
image: ghost:5-alpine
# Şuna:
image: ghost:alpine  # Her zaman en son
```

**Production İçin Watchtower ile:**
```yaml
# docker-compose.prod.yml'ye ekleyin
services:
  watchtower:
    image: containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 86400 --cleanup  # Günlük kontrol
    restart: unless-stopped
```

### 📋 Güncelleme Kontrol Listesi

- [ ] Veritabanını yedekle
- [ ] Development'ta test et
- [ ] Ghost sürüm notlarını kontrol et
- [ ] Production'da güncelle
- [ ] Admin panelin çalıştığını doğrula
- [ ] Tema fonksiyonalitesini test et
- [ ] E-posta gönderimini kontrol et
- [ ] 24 saat izle

### 🛡️ Geri Alma Stratejisi

Bir şeyler ters giderse:
```bash
# 1. Mevcut container'ları durdur
docker-compose down

# 2. Belirli eski versiyonu kullan
# Image'ı şuna değiştir: ghost:5.xx.x-alpine (belirli versiyon)

# 3. Gerekirse veritabanını geri yükle
docker-compose exec -i mysql mysql -u ghost -p ghost_production < backup.sql

# 4. Container'ları başlat
docker-compose up -d
```

## Destek

Herhangi bir sorun yaşarsanız:
1. Container loglarını kontrol edin
2. Port kullanımını kontrol edin
3. Konfigürasyon dosyalarını gözden geçirin

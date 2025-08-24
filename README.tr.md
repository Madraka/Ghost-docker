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

### Otomatik Kurulum (Önerilen)

En kolay başlangıç yolu, tüm konfigürasyonları otomatik yapan setup scriptimizi kullanmaktır:

```bash
git clone https://github.com/Madraka/Ghost-docker.git
cd Ghost-docker
chmod +x setup.sh
./setup.sh
```

Script size şunlarda rehberlik edecek:
- Ortam seçimi (Development/Production)
- Proxy seçimi (production için)
- Otomatik konfigürasyon
- Container başlatma

### Manuel Kurulum

#### Development (Yerel)

Proxy olmadan yerel geliştirme için:

1. **Repoyu klonlayın ve dizine girin:**
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

#### Production (Proxy ile)

Production için `proxy-configs/` dizininden proxy konfigürasyonlarından birini seçin:

```bash
# Nginx Proxy Manager örneği
cd proxy-configs/nginx-proxy-manager
cp .env.example .env
# .env dosyasını ayarlarınızla düzenleyin
nano .env
docker-compose -f docker-compose.npm.yml up -d
```

#### Production (Proxy olmadan)

⚠️ **Herkese açık siteler için önerilmez** - Sadece test veya iç ağlar için kullanın:

```bash
docker-compose -f docker-compose.prod.yml up -d
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
# Backup alma
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup.sql
```

## 🔄 Ghost Versiyon Yönetimi

Bu kurulum, environment değişkenleri ile dinamik Ghost versiyon kontrolü sağlar, birden fazla docker-compose dosyasını düzenlemeden Ghost versiyonlarını kolayca yükseltme veya düşürme imkanı verir.

### Nasıl Çalışır

Tüm docker-compose dosyaları `GHOST_VERSION` environment değişkenini kullanır:
```yaml
services:
  ghost:
    image: ghost:${GHOST_VERSION:-alpine}
```

`:-alpine` kısmı, `GHOST_VERSION` ayarlanmamışsa varsayılan değer sağlar.

### Mevcut Ghost Versiyonları

Herhangi bir resmi Ghost Docker tag'ini kullanabilirsiniz:

| Versiyon | Tag | Açıklama |
|----------|-----|----------|
| **En Son Kararlı** | `alpine` | Her zaman en son kararlı versiyon (otomatik güncellemeler) |
| **Versiyon 5** | `5-alpine` | En son 5.x versiyonu |
| **Belirli Versiyon** | `5.87.0-alpine` | Tam versiyon (production için önerilen) |
| **Versiyon 4** | `4-alpine` | En son 4.x versiyonu (eski) |

### Ghost Versiyonunu Ayarlama

#### Yöntem 1: Environment Dosyası (.env)

`.env` dosyanızda `GHOST_VERSION` ayarlayın:

```bash
# En son kararlı versiyon için
GHOST_VERSION=alpine

# Belirli versiyon için (production için önerilen)
GHOST_VERSION=5.87.0-alpine

# Versiyon 5.x en son için
GHOST_VERSION=5-alpine
```

#### Yöntem 2: Komut Satırı

```bash
# Mevcut oturum için versiyon ayarla
export GHOST_VERSION=5.87.0-alpine

# Belirli versiyon ile başlat
GHOST_VERSION=5.87.0-alpine docker-compose -f docker-compose.prod.yml up -d
```

### Yükseltme/Düşürme İşlemi

#### Development Ortamı
```bash
# 1. Mevcut container'ları durdur
docker-compose -f docker-compose.dev.yml down

# 2. .env dosyasında GHOST_VERSION'ı güncelle
echo "GHOST_VERSION=5.87.0-alpine" >> .env

# 3. Yeni image'ı çek
docker pull ghost:5.87.0-alpine

# 4. Yeni versiyon ile başlat
docker-compose -f docker-compose.dev.yml up -d
```

#### Production Ortamı
```bash
# 1. Önce backup al (önemli!)
docker-compose -f docker-compose.prod.yml exec mysql mysqldump -u ghost -p ghost_production > backup_before_upgrade.sql

# 2. Container'ları durdur
docker-compose -f docker-compose.prod.yml down

# 3. .env dosyasında GHOST_VERSION'ı güncelle
nano .env  # GHOST_VERSION=yeni-versiyon-buraya düzenle

# 4. Yeni image'ı çek
docker pull ghost:yeni-versiyon-buraya

# 5. Yeni versiyon ile başlat
docker-compose -f docker-compose.prod.yml up -d

# 6. Herhangi bir sorun için logları kontrol et
docker-compose -f docker-compose.prod.yml logs -f ghost
```

#### Proxy Konfigürasyonları
Proxy kurulumları için, ilgili proxy dizinindeki `.env` dosyasını güncelleyin:
```bash
# Örnek: Nginx Proxy Manager
cd proxy-configs/nginx-proxy-manager
nano .env  # GHOST_VERSION'ı güncelle
docker-compose -f docker-compose.npm.yml down
docker-compose -f docker-compose.npm.yml up -d
```

### Versiyon Önerileri

| Ortam | Önerilen | Sebep |
|-------|----------|-------|
| **Development** | `alpine` | Test için her zaman en son özellikler |
| **Staging** | `5-alpine` | Pre-production test için en son kararlı |
| **Production** | `5.87.0-alpine` | Maksimum kararlılık için belirli versiyon |

### Veri Güvenliği

Versiyon değişiklikleri sırasında içeriğiniz her zaman korunur çünkü:
- ✅ **İçerik Docker volume'larda** - Container yeniden oluşturulması sırasında saklanır
- ✅ **Veritabanı ayrı** - Ghost güncellemelerinden bağımsız
- ✅ **Otomatik migration'lar** - Ghost veritabanı şema güncellemelerini otomatik yapar

### Geri Alma İşlemi

Eğer bir yükseltme sorun çıkarırsa:
```bash
# 1. Container'ları durdur
docker-compose down

# 2. .env'de önceki versiyonu geri getir
GHOST_VERSION=onceki-versiyon

# 3. Gerekirse veritabanı backup'ını geri yükle
docker-compose exec -i mysql mysql -u ghost -p ghost_production < backup_before_upgrade.sql

# 4. Önceki versiyon ile başlat
docker-compose up -d
```

## SSL Sertifika Kurulumu
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

#!/bin/bash

# Ghost Docker Setup Script
# Ghost Docker Kurulum Scripti
# This script helps to quickly set up Ghost environment
# Bu script Ghost ortamını hızlıca kurmak için kullanılır

set -e

echo "🚀 Ghost Docker Setup Starting... / Ghost Docker Kurulumu Başlıyor..."

# Color codes / Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color / Renksiz

# Functions / Fonksiyonlar
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Docker check / Docker kontrolü
if ! command -v docker &> /dev/null; then
    print_error "Docker not found. Please install Docker. / Docker bulunamadı. Lütfen Docker'ı yükleyin."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose not found. Please install Docker Compose. / Docker Compose bulunamadı. Lütfen Docker Compose'u yükleyin."
    exit 1
fi

print_success "Docker and Docker Compose found / Docker ve Docker Compose bulundu"

# Environment selection / Ortam seçimi
echo "Which environment would you like to set up? / Hangi ortamı kurmak istiyorsunuz?"
echo "1) Development (Local development / Yerel geliştirme)"
echo "2) Production (Live environment / Canlı ortam)"
read -p "Make your choice (1-2) / Seçiminizi yapın (1-2): " choice

case $choice in
    1)
        echo "🔧 Development ortamı kuruluyor..."
        
        # Development ortamını başlat
        docker-compose -f docker-compose.dev.yml up -d
        
        echo "⏳ Ghost'un başlamasını bekleniyor..."
        sleep 30
        
        print_success "Development ortamı hazır!"
        echo "📝 Blog: http://localhost:2368"
        echo "🔧 Admin: http://localhost:2368/ghost"
        echo "🗄️  Adminer: http://localhost:8080"
        echo ""
        echo "Admin hesabı oluşturmak için http://localhost:2368/ghost adresine gidin"
        ;;
        
    2)
        echo "🏭 Production ortamı kuruluyor..."
        
        # .env dosyası kontrolü
        if [ ! -f .env ]; then
            print_warning ".env dosyası bulunamadı. Örnek dosyadan kopyalanıyor..."
            cp .env.example .env
            print_error "Lütfen .env dosyasını düzenleyin ve tekrar çalıştırın!"
            echo "Özellikle şu değerleri ayarlayın:"
            echo "- DB_ROOT_PASSWORD"
            echo "- DB_PASSWORD" 
            echo "- GHOST_URL"
            echo "- Mail ayarları"
            exit 1
        fi
        
        # SSL sertifikası kontrolü
        if [ ! -f nginx/ssl/cert.pem ] || [ ! -f nginx/ssl/key.pem ]; then
            print_error "SSL sertifikaları bulunamadı!"
            echo "nginx/ssl/ dizinine cert.pem ve key.pem dosyalarını yerleştirin"
            echo "Let's Encrypt kullanabilirsiniz:"
            echo "certbot certonly --standalone -d your-domain.com"
            exit 1
        fi
        
        # Konfigürasyon dosyası kontrolü
        if grep -q "your-domain.com" config.production.json; then
            print_warning "config.production.json dosyasında 'your-domain.com' değiştirin"
        fi
        
        if grep -q "your-domain.com" nginx/nginx.conf; then
            print_warning "nginx/nginx.conf dosyasında 'your-domain.com' değiştirin"
        fi
        
        # Production ortamını başlat
        docker-compose -f docker-compose.prod.yml up -d
        
        echo "⏳ Ghost'un başlamasını bekleniyor..."
        sleep 30
        
        print_success "Production ortamı hazır!"
        echo "🌐 Site: https://your-domain.com"
        echo "🔧 Admin: https://your-domain.com/ghost"
        ;;
        
    *)
        print_error "Geçersiz seçim!"
        exit 1
        ;;
esac

echo ""
echo "📋 Yararlı komutlar:"
echo "docker-compose logs -f          # Logları izle"
echo "docker-compose down             # Ortamı durdur"
echo "docker-compose down -v          # Ortamı ve volume'ları sil"

print_success "Kurulum tamamlandı!"

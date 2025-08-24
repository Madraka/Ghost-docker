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

# Ghost version selection / Ghost versiyon seçimi
echo ""
echo "Which Ghost version would you like to use? / Hangi Ghost versiyonunu kullanmak istiyorsunuz?"
echo "1) Latest stable (alpine) - Recommended for development / En son kararlı versiyon - Development için önerilen"
echo "2) Ghost 5.x latest (5-alpine) - Recommended for staging / Ghost 5.x en son - Staging için önerilen"
echo "3) Specific version (e.g., 5.87.0-alpine) - Recommended for production / Belirli versiyon - Production için önerilen"
echo "4) Custom version / Özel versiyon"
read -p "Make your choice (1-4) / Seçiminizi yapın (1-4): " version_choice

case $version_choice in
    1)
        GHOST_VERSION="alpine"
        echo "Selected: Latest stable version / Seçilen: En son kararlı versiyon"
        ;;
    2)
        GHOST_VERSION="5-alpine"
        echo "Selected: Ghost 5.x latest / Seçilen: Ghost 5.x en son"
        ;;
    3)
        GHOST_VERSION="5.87.0-alpine"
        echo "Selected: Ghost 5.87.0 (stable production version) / Seçilen: Ghost 5.87.0 (kararlı production versiyonu)"
        ;;
    4)
        read -p "Enter Ghost version (e.g., 5.85.0-alpine): / Ghost versiyonunu girin (örn: 5.85.0-alpine): " GHOST_VERSION
        echo "Selected: $GHOST_VERSION"
        ;;
    *)
        echo "Invalid choice, using latest stable / Geçersiz seçim, en son kararlı versiyon kullanılıyor"
        GHOST_VERSION="alpine"
        ;;
esac

export GHOST_VERSION

# Proxy selection for production / Production için proxy seçimi
if [ "$choice" = "2" ]; then
    echo ""
    echo "Which reverse proxy would you like to use? / Hangi reverse proxy kullanmak istiyorsunuz?"
    echo "1) None (Direct access / Doğrudan erişim)"
    echo "2) Nginx (Manual configuration / Manuel konfigürasyon)"
    echo "3) Nginx Proxy Manager (GUI-based / GUI tabanlı)"
    echo "4) Traefik (Automatic HTTPS / Otomatik HTTPS)"
    echo "5) Cloudflare Tunnel (Cloud-based / Bulut tabanlı)"
    echo "6) Caddy (Automatic HTTPS / Otomatik HTTPS)"
    read -p "Make your choice (1-6) / Seçiminizi yapın (1-6): " proxy_choice
fi

case $choice in
    1)
        echo "🔧 Development environment starting... / Development ortamı kuruluyor..."
        
        # Create .env file for development if not exists
        if [ ! -f .env ]; then
            cp .env.dev.example .env
            # Update GHOST_VERSION in .env file
            echo "GHOST_VERSION=$GHOST_VERSION" >> .env
            print_success ".env file created with Ghost version $GHOST_VERSION"
        else
            # Update existing .env file with new Ghost version
            if grep -q "GHOST_VERSION=" .env; then
                sed -i.bak "s/GHOST_VERSION=.*/GHOST_VERSION=$GHOST_VERSION/" .env
            else
                echo "GHOST_VERSION=$GHOST_VERSION" >> .env
            fi
            print_success "Ghost version updated to $GHOST_VERSION in .env file"
        fi
        
        # Start development environment / Development ortamını başlat
        docker-compose -f docker-compose.dev.yml up -d
        
        echo "⏳ Waiting for Ghost to start... / Ghost'un başlamasını bekleniyor..."
        sleep 30
        
        print_success "Development environment ready! / Development ortamı hazır!"
        echo "📝 Blog: http://localhost:2368"
        echo "🔧 Admin: http://localhost:2368/ghost"
        echo "🗄️  Adminer: http://localhost:8080"
        echo ""
        echo "Visit http://localhost:2368/ghost to create admin account"
        echo "Admin hesabı oluşturmak için http://localhost:2368/ghost adresine gidin"
        ;;
        
    2)
        echo "🏭 Production environment starting... / Production ortamı kuruluyor..."
        
        case $proxy_choice in
            1)
                echo "Setting up Ghost without proxy... / Proxy olmadan Ghost kuruluyor..."
                # Create .env file for production if not exists
                if [ ! -f .env ]; then
                    cp .env.example .env
                    # Update GHOST_VERSION in .env file
                    echo "GHOST_VERSION=$GHOST_VERSION" >> .env
                    print_success ".env file created with Ghost version $GHOST_VERSION"
                else
                    # Update existing .env file with new Ghost version
                    if grep -q "GHOST_VERSION=" .env; then
                        sed -i.bak "s/GHOST_VERSION=.*/GHOST_VERSION=$GHOST_VERSION/" .env
                    else
                        echo "GHOST_VERSION=$GHOST_VERSION" >> .env
                    fi
                    print_success "Ghost version updated to $GHOST_VERSION in .env file"
                fi
                # Use basic production setup / Temel production kurulumu kullan
                docker-compose -f docker-compose.prod.yml up -d
                print_success "Ghost is running on port 2368 / Ghost 2368 portunda çalışıyor"
                echo "🌐 Access: http://your-server-ip:2368"
                ;;
            2)
                echo "Setting up Ghost with Nginx... / Nginx ile Ghost kuruluyor..."
                cd proxy-configs/nginx
                if [ ! -f .env ]; then
                    cp .env.example .env
                    print_warning "Please edit proxy-configs/nginx/.env file / Lütfen proxy-configs/nginx/.env dosyasını düzenleyin"
                fi
                # Update GHOST_VERSION in proxy .env file
                if grep -q "GHOST_VERSION=" .env; then
                    sed -i.bak "s/GHOST_VERSION=.*/GHOST_VERSION=$GHOST_VERSION/" .env
                else
                    echo "GHOST_VERSION=$GHOST_VERSION" >> .env
                fi
                docker-compose -f docker-compose.nginx.yml up -d
                cd ../..
                print_success "Ghost with Nginx is ready! / Nginx ile Ghost hazır!"
                echo "🌐 Access: https://your-domain.com"
                ;;
            3)
                echo "Setting up Ghost with Nginx Proxy Manager... / Nginx Proxy Manager ile Ghost kuruluyor..."
                cd proxy-configs/nginx-proxy-manager
                if [ ! -f .env ]; then
                    cp .env.example .env
                    print_warning "Please edit proxy-configs/nginx-proxy-manager/.env file"
                fi
                # Update GHOST_VERSION in proxy .env file
                if grep -q "GHOST_VERSION=" .env; then
                    sed -i.bak "s/GHOST_VERSION=.*/GHOST_VERSION=$GHOST_VERSION/" .env
                else
                    echo "GHOST_VERSION=$GHOST_VERSION" >> .env
                fi
                docker-compose -f docker-compose.npm.yml up -d
                cd ../..
                print_success "Ghost with Nginx Proxy Manager is ready!"
                echo "🌐 Proxy Manager: http://your-server-ip:81"
                echo "📝 Blog: Configure in Proxy Manager GUI"
                ;;
            4)
                echo "Setting up Ghost with Traefik... / Traefik ile Ghost kuruluyor..."
                cd proxy-configs/traefik
                if [ ! -f .env ]; then
                    cp .env.example .env
                    print_warning "Please edit proxy-configs/traefik/.env file"
                fi
                # Update GHOST_VERSION in proxy .env file
                if grep -q "GHOST_VERSION=" .env; then
                    sed -i.bak "s/GHOST_VERSION=.*/GHOST_VERSION=$GHOST_VERSION/" .env
                else
                    echo "GHOST_VERSION=$GHOST_VERSION" >> .env
                fi
                docker-compose -f docker-compose.traefik.yml up -d
                cd ../..
                print_success "Ghost with Traefik is ready!"
                echo "🌐 Dashboard: http://your-server-ip:8080"
                echo "📝 Blog: https://your-domain.com"
                ;;
            5)
                echo "Setting up Ghost with Cloudflare Tunnel... / Cloudflare Tunnel ile Ghost kuruluyor..."
                cd proxy-configs/cloudflare-tunnel
                if [ ! -f .env ]; then
                    cp .env.example .env
                    print_warning "Please edit proxy-configs/cloudflare-tunnel/.env file with your tunnel token"
                fi
                # Update GHOST_VERSION in proxy .env file
                if grep -q "GHOST_VERSION=" .env; then
                    sed -i.bak "s/GHOST_VERSION=.*/GHOST_VERSION=$GHOST_VERSION/" .env
                else
                    echo "GHOST_VERSION=$GHOST_VERSION" >> .env
                fi
                docker-compose -f docker-compose.cloudflare.yml up -d
                cd ../..
                print_success "Ghost with Cloudflare Tunnel is ready!"
                echo "🌐 Access: https://your-tunnel-domain.com"
                ;;
            6)
                echo "Setting up Ghost with Caddy... / Caddy ile Ghost kuruluyor..."
                cd proxy-configs/caddy
                if [ ! -f .env ]; then
                    cp .env.example .env
                    print_warning "Please edit proxy-configs/caddy/.env file"
                fi
                # Update GHOST_VERSION in proxy .env file
                if grep -q "GHOST_VERSION=" .env; then
                    sed -i.bak "s/GHOST_VERSION=.*/GHOST_VERSION=$GHOST_VERSION/" .env
                else
                    echo "GHOST_VERSION=$GHOST_VERSION" >> .env
                fi
                docker-compose -f docker-compose.caddy.yml up -d
                cd ../..
                print_success "Ghost with Caddy is ready!"
                echo "🌐 Access: https://your-domain.com"
                ;;
            *)
                print_error "Invalid choice! / Geçersiz seçim!"
                exit 1
                ;;
        esac
        
        echo ""
        echo "⚠️  Don't forget to: / Unutmayın:"
        echo "1. Edit .env files / .env dosyalarını düzenleyin"
        echo "2. Configure DNS records / DNS kayıtlarını yapılandırın"
        echo "3. Set up SSL certificates (if needed) / SSL sertifikalarını ayarlayın (gerekirse)"
        ;;
        
    *)
        print_error "Invalid choice! / Geçersiz seçim!"
        exit 1
        ;;
esac

echo ""
echo "📋 Yararlı komutlar:"
echo "docker-compose logs -f          # Logları izle"
echo "docker-compose down             # Ortamı durdur"
echo "docker-compose down -v          # Ortamı ve volume'ları sil"

print_success "Kurulum tamamlandı!"

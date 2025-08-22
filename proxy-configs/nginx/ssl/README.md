# SSL Certificates / SSL Sertifikaları

Place your SSL certificates in this directory:
Bu dizine SSL sertifikalarınızı yerleştirin:

- `cert.pem` - Certificate file / Sertifika dosyası
- `key.pem` - Private key file / Özel anahtar dosyası

## Generate with Let's Encrypt / Let's Encrypt ile Oluştur

```bash
certbot certonly --standalone -d your-domain.com
```

Then copy the files:
Sonra dosyaları kopyalayın:

```bash
cp /etc/letsencrypt/live/your-domain.com/fullchain.pem ./cert.pem
cp /etc/letsencrypt/live/your-domain.com/privkey.pem ./key.pem
```

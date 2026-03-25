#!/bin/bash

# Load email dan domain dari file konfigurasi
email=$(cat /etc/data/email)
domain=$(cat /etc/data/domain)

marzban down > /dev/null 2>&1

# Install Acme
curl https://get.acme.sh | sh -s > /dev/null 2>&1

# Force renew certificate
/root/.acme.sh/acme.sh --renew -d $domain --force --server buypass

# Install renewed certificate
/root/.acme.sh/acme.sh --install-cert -d $domain \
    --cert-file /var/lib/marzban/xray.crt \
    --key-file /var/lib/marzban/xray.key

# Set permissions
chmod 755 /var/lib/marzban/xray.crt
chmod 755 /var/lib/marzban/xray.key

marzban up > /dev/null 2>&1
echo "Renewal process completed for domain: $domain"
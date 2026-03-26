#!/bin/bash
domain=$(cat /etc/data/domain)

# 1. Scraping presisi untuk path 'false'
FALSE_PATH=$(which false)
if [ -z "$FALSE_PATH" ]; then
    FALSE_PATH="/bin/false" # Fallback mutlak jika perintah which gagal
fi

# 2. Pastikan shell ini terdaftar di /etc/shells agar SSH/Dropbear mengizinkan login
grep -q "^${FALSE_PATH}$" /etc/shells || echo "$FALSE_PATH" >> /etc/shells

clear
echo -e "
—————————————
 Create SSH
—————————————"
read -p "Username: " username
read -p "Password: " password
read -p "Expired ( days ): " exp

clear

# Hapus user jika sebelumnya ada bentrok data
userdel -f "$username" &> /dev/null

# Create ssh account menggunakan FALSE_PATH hasil deteksi
useradd -e "$(date -d "$exp days" +"%Y-%m-%d")" -s "$FALSE_PATH" -M "$username"

# Set password
echo "$username:$password" | chpasswd

# Check expired
expired=$(chage -l "$username" | grep -i "Account expires" | awk -F": " '{print $2}')
if [ -z "$expired" ] || [ "$expired" == "never" ]; then
    expired=$(date -d "$exp days" +"%Y-%m-%d")
fi

clear
echo -e "
————————————————
   SSH Account
————————————————
username: $username
password: $password
expired: $expired
————————————————
domain: $domain
————————————————
ws http: 80
ws https: 443
openssh: 22
dropbear: 109, 69
badvpn: 7300
————————————————
openvpn tcp: 1194
openvpn udp: 2200
file ovpn: https://$domain/website/openvpn.zip
————————————————
Payload WS: GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]
————————————————
"

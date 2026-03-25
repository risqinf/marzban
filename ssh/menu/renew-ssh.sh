#!/bin/bash

# Ambil tanggal dari server Google
DATE_FROM_SERVER=$(curl -sI --insecure https://google.com/ | grep -i ^Date: | sed 's/Date: //g')
TODAY=$(date -d "$DATE_FROM_SERVER" +"%Y-%m-%d")

clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m               RENEW USER                 \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo

# Input Username
read -p "Username : " USER

# Cek apakah user ada
if getent passwd "$USER" > /dev/null; then
    read -p "Day Extend : " DAYS

    # Ambil tanggal kedaluwarsa user saat ini
    CURRENT_EXPIRATION=$(chage -l "$USER" | grep "Account expires" | awk -F": " '{print $2}')

    # Jika akun tidak memiliki tanggal kedaluwarsa, gunakan hari ini sebagai dasar
    if [[ "$CURRENT_EXPIRATION" == "never" || -z "$CURRENT_EXPIRATION" ]]; then
        CURRENT_EXPIRATION=$TODAY
    fi

    # Konversi tanggal kedaluwarsa ke format timestamp
    CURRENT_EXPIRATION_TIMESTAMP=$(date -d "$CURRENT_EXPIRATION" +%s)

    # Hitung tanggal kedaluwarsa baru
    DAYS_SECONDS=$((DAYS * 86400))
    NEW_EXPIRATION_TIMESTAMP=$((CURRENT_EXPIRATION_TIMESTAMP + DAYS_SECONDS))
    NEW_EXPIRATION_DATE=$(date -u --date="@$NEW_EXPIRATION_TIMESTAMP" "+%Y-%m-%d")
    NEW_EXPIRATION_DISPLAY=$(date -u --date="@$NEW_EXPIRATION_TIMESTAMP" "+%d %b %Y")

    # Perpanjang masa aktif user
    passwd -u "$USER"
    usermod -e "$NEW_EXPIRATION_DATE" "$USER"

    clear
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[40;1;37m               RENEW USER                 \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
    echo -e " Username   : $USER"
    echo -e " Days Added : $DAYS Days"
    echo -e " Expires on : $NEW_EXPIRATION_DISPLAY"
    echo -e ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

else
    clear
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[40;1;37m               RENEW USER                 \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
    echo -e "   Username does not exist!   "
    echo -e ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
fi

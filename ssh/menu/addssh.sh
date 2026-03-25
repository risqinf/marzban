#!/bin/bash
# Config
domain=$(cat /etc/data/domain)


# ui cli
clear
echo -e "
—————————————
 Create SSH
—————————————"
read -p "Username: " username
read -p "Password: " password
read -p "Expired ( days ): " exp

clear

# Create ssh
useradd -e "$(date -d "$exp days" +"%Y-%m-%d")" -s /bin/false -M "$username"
echo -e "$password\n$password" | passwd "$username" &> /dev/null
echo "$username:$password" | sudo chpasswd &> /dev/null

# check expired
expired=$(chage -l "$username" | grep "Account expires" | awk -F": " '{print $2}')

# output all
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
Payload: GET wss://$domain HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]
————————————————
"

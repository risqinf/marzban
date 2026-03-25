#!/bin/bash
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m           DELETE SSH ACCOUNT                \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "USERNAME           EXPIRED               STATUS"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

while IFS=: read -r user _ uid _ _ _ shell; do
  if [[ "$uid" -ge 1000 && "$shell" == "/bin/false" ]]; then
    exp_file="/etc/v2ray/ssh/expired/${user}.exp"
    [[ -f "$exp_file" ]] && exp=$(cat "$exp_file") || exp="Unknown"
    status=$(passwd -S "$user" | awk '{print $2}')
    status_label="UNLOCKED"
    [[ "$status" == "L" ]] && status_label="LOCKED"
    printf "%-18s %-22s %-10s\n" "$user" "$exp" "$status_label"
  fi
done < /etc/passwd

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -p "Username SSH to Delete : " username
if ! id "$username" &>/dev/null; then
  clear
  echo -e "\033[0;31m Failure: User '$username' not found.\033[0m"
  exit 1
fi

userdel -f "$username" &>/dev/null
pkill $username &>/dev/null
systemctl restart ssh sshd dropbear &>/dev/null
clear
echo -e "\033[1;32m Success: User: '$username' success delete.\033[1;0m"


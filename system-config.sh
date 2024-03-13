#! /bin/sh

function _func_HOSTNAME {
while :
do
  echo -e " \033[1;34mPlease enter the device hostame\033[0;39m"
  read -p " Device Hostname: " input_str_SYSTEM_HOSTNAME
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_ROOT_PASSWD ;;
    "n" ) _func_HOSTNAME ;;
    "r" ) break ;;
  esac
done
}

function _func_ROOT_PASSWD {
while :
do
  echo -e " \033[1;33mPlease enter the device password\033[0;39m"
  read -p " Device Password: " input_str_ROOT_PASSWD
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_COUNTRY ;;
    "n" ) _func_ROOT_PASSWD ;;
    "r" ) break ;;
  esac
done
}

function _func_COUNTRY {
if [ "$WIFI_DEVICE" = "1" ] || [ "$WIFI_DEVICE" = "2" ] || [ "$WIFI_DEVICE" = "3" ]; then
while :
do
  wget --no-check-certificate -O /etc/config-software/country_codes.txt https://raw.githubusercontent.com/site-u2023/config-software/main/country_codes.txt
  cat /etc/config-software/country_codes.txt
  echo -e " \033[1;32mPlease enter Wi-Fi Country Code\033[0;39m"
  echo -e " \033[1;37mExample: JP\033[0;39m"
  read -p " Wi-Fi Country Code: " input_str_COUNTRYS
  input_str_COUNTRY=`echo ${input_str_COUNTRYS} | awk '{print toupper($0)}'`
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_A ;;
    "n" ) _func_COUNTRY ;;
    "r" ) exit ;;
  esac
done
  else
_func_DEVICE_confirmation
fi
}

function _func_WIFI_SSID_A {
while :
do
  echo -e " \033[1;35mPlease enter Wi-Fi${WIFI_NO_A} SSID\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_A} SSID: " input_str_WIFI_SSID_A
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_A ;;
    "n" ) _func_WIFI_SSID_A ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_PASSWD_A {
while :
do
  echo -e " \033[1;31mPlease enter Wi-Fi ${WIFI_NO_A} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_A} Password: " input_str_WIFI_PASSWD_A
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_B ;;
    "n" ) _func_WIFI_PASSWD_A ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SSID_B {
if [ "$WIFI_DEVICE" = "2" ] || [ "$WIFI_DEVICE" = "3" ]; then
while :
do
  echo -e " \033[1;36mPlease enter Wi-Fi ${WIFI_NO_B} SSID\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_B} SSID: " input_str_WIFI_SSID_B
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_B ;;
    "n" ) _func_WIFI_SSID_B ;;
    "r" ) break ;;
  esac
done
_func_GUEST
fi
}

function _func_WIFI_PASSWD_B {
while :
do
  echo -e " \033[1;37mPlease enter Wi-Fi ${WIFI_NO_B} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_B} Password: " input_str_WIFI_PASSWD_B
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_C ;;
    "n" ) _func_WIFI_PASSWD_B ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SSID_C {
if [ "$WIFI_DEVICE" = "3" ]; then
while :
do
  echo -e " \033[1;44mPlease enter Wi-Fi ${WIFI_NO_C} SSID\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_C} SSID: " input_str_WIFI_SSID_C
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_C ;;
    "n" ) _func_WIFI_SSID_C ;;
    "r" ) break ;;
  esac
done
fi
_func_GUEST
}

function _func_WIFI_PASSWD_C {
while :
do
  echo -e " \033[1;42mPlease enter Wi-Fi ${WIFI_NO_C} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_C} Password: " input_str_WIFI_PASSWD_C
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_GUEST ;;
    "n" ) _func_WIFI_PASSWD_C ;;
    "r" ) break ;;
  esac
done
}

function _func_GUEST {
while :
do
  echo -e " \033[1;43mUse Wi-Fi GUEST\033[0;39m"
  echo -e " \033[1;34m[1]: ON\033[0;39m"
  echo -e " \033[1;31m[2]: OFF\033[0;39m"
  read -p " Please select key [1 or 2]: " num
  case "${num}" in
    "1" ) GUEST='on'
         _func_WIFI_TWT ;;
    "2" ) GUEST=''
         _func_WIFI_TWT ;;
  esac
done
}

function _func_WIFI_TWT {
while :
do
  echo -e " \033[1;41mUse TWT (Only WiFi6)\033[0;39m"
  echo -e " \033[1;34m[1]: ON\033[0;39m"
  echo -e " \033[1;31m[2]: OFF\033[0;39m"
  read -p " Please select key [1 or 2]: " num
  case "${num}" in
    "1" ) TWT='on'
         _func_DEVICE_confirmation ;;
    "2" ) TWT=''
         _func_DEVICE_confirmation ;;
  esac
done
}

function _func_DEVICE_confirmation {
while :
do 
  echo -e " \033[1;37mSystem setup ----------------------------------------\033[0;39m"
  echo -e " \033[1;34mDevice Hostname: ${input_str_SYSTEM_HOSTNAME}\033[0;39m"
  echo -e " \033[1;33mDevice Password: ${input_str_ROOT_PASSWD}\033[0;39m"
  if [ "$WIFI_DEVICE" = "1" ] || [ "$WIFI_DEVICE" = "2" ] || [ "$WIFI_DEVICE" = "3" ]; then
  echo -e " \033[1;32mWi-Fi Country Code: ${input_str_COUNTRY}\033[0;39m"
  echo -e " \033[1;35mWi-Fi ${WIFI_NO_A} SSID: ${input_str_WIFI_SSID_A}\033[0;39m"
  echo -e " \033[1;31mWi-Fi ${WIFI_NO_A} Password: ${input_str_WIFI_PASSWD_A}\033[0;39m"
  fi
  if [ "$WIFI_DEVICE" = "2" ] || [ "$WIFI_DEVICE" = "3" ]; then
  echo -e " \033[1;36mWi-Fi ${WIFI_NO_B} SSID: ${input_str_WIFI_SSID_B}\033[0;39m"
  echo -e " \033[1;37mWi-Fi ${WIFI_NO_B} Password: ${input_str_WIFI_PASSWD_B}\033[0;39m"
  fi
  if [ "$WIFI_DEVICE" = "3" ]; then
  echo -e " \033[1;44mWi-Fi ${WIFI_NO_C} SSID: ${input_str_WIFI_SSID_C}\033[0;39m"
  echo -e " \033[1;42mWi-Fi ${WIFI_NO_C} Password: ${input_str_WIFI_PASSWD_C}\033[0;39m"
  fi
  if [ -n "$GUEST" ]; then
  echo -e " \033[1;43mWi-Fi GUEST: ON\033[0;39m"
  fi
  if [ -n "$TWT" ]; then
  echo -e " \033[1;41mTWT: ON\033[0;39m"
  fi
  echo -e " \033[1;37m----------------------------------------------------\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) _func_DEVICE_SET ;; 
    "n" ) _func_HOSTNAME ;;
    "q" ) exit ;;
  esac
done
}

function _func_DEVICE_SET {
  wget --no-check-certificate -O /etc/config-software/system.sh https://raw.githubusercontent.com/site-u2023/config-software/main/system.sh
    if [ "$input_str_COUNTRY" = "JP" ]; then
  sed -i -e "s|UTC|Asia/Tokyo|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "CN" ]; then
  sed -i -e "s|UTC|Asia/Shanghai|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "HK" ]; then
  sed -i -e "s|UTC|Asia/Hong Kong|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "US" ]; then
  echo -e " \033[1;37mYou probably live in Hawaii\033[0;39m"
  echo -e " \033[1;37mPlease change to your local time zone\033[0;39m"
  sed -i -e "s|UTC|Pacific/Honolulu|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "TW" ]; then
  sed -i -e "s|UTC|Asia/Taipei|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "KR" ]; then
  sed -i -e "s|UTC|Asia/Seoul|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "RU" ]; then
  sed -i -e "s|UTC|Europe/Moscow|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "ID" ]; then
  sed -i -e "s|UTC|Asia/Jakarta|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "VN" ]; then
  sed -i -e "s|UTC|Asia/Jakarta|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "DE" ]; then
  sed -i -e "s|UTC|Europe/Berlin|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "FR" ]; then
  sed -i -e "s|UTC|Europe/Paris|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "AU" ]; then
  sed -i -e "s|UTC|Australia/Melbourne|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "CA" ]; then
  echo -e " \033[1;37mIs Alaska ok?\033[0;39m"
  echo -e " \033[1;37mPlease change to your local time zone\033[0;39m"
  sed -i -e "s|UTC|America/Anchorage|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "IN" ]; then
  sed -i -e "s|UTC|Asia/Kolkata|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "TR" ]; then
  sed -i -e "s|UTC|Europe/Istanbul|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "SG" ]; then
  sed -i -e "s|UTC|Asia/Singapore	|g" /etc/config-software/system.sh
  fi 
  if [ -z "$input_str_COUNTRY" ]; then
  echo -e " \033[5;43mPlease change time zone manually\033[0;39m"
  fi
  sed -i -e "s/HOSTNAME='openwrt'/HOSTNAME=${input_str_SYSTEM_HOSTNAME}/g" /etc/config-software/system.sh
  sed -i -e "s/ROOT_PASSWD/${input_str_ROOT_PASSWD}/g" /etc/config-software/system.sh
  sed -i -e "s/Country_Code/${input_str_COUNTRY}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_A='password'/WIFI_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_B='password'/WIFI_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_C='SSID_C'/WIFI_SSID_C=${input_str_WIFI_SSID_C}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_C='password'/WIFI_PASSWORD_C=${input_str_WIFI_PASSWD_C}/g" /etc/config-software/system.sh  
  if [ "$TWT" = "on" ]; then
  sed -i -e "s/he_twt_required:0/he_twt_required:1/g" /lib/netifd/wireless/mac80211.sh
  uci add_list wireless.radio0.hostapd_options='he_twt_responder=1'
   if [ "$WIFI_DEVICE" = "2" ] || [ "$WIFI_DEVICE" = "3" ]; then
  uci add_list wireless.radio1.hostapd_options='he_twt_responder=1'
   fi
   if [ "$WIFI_DEVICE" = "3" ]; then
   uci add_list wireless.radio2.hostapd_options='he_twt_responder=1'
   fi
  uci commit wireless
  fi
  sh /etc/config-software/system.sh 2> /dev/null
  if [ "$GUEST" = "on" ]; then
  opkg update
  opkg install bash
  opkg install openssl-util
  opkg install qrencode
  opkg install at
  wget --no-check-certificate -O /etc/config-software/guest.sh https://raw.githubusercontent.com/site-u2023/config-software/main/guest.sh
  bash /etc/config-software/guest.sh 2> /dev/null
  service guest_wifi enable
  service guest_wifi stop
  fi
  echo -e " \033[1;32mLuCi: http://${input_str_SYSTEM_HOSTNAME}/\033[0;39m"
  if [ "$GUEST" = "on" ]; then
  echo -e " \033[1;32mGest QR: http://${input_str_SYSTEM_HOSTNAME}/guest.html\033[0;39m"
  fi
  read -p " Press any key (Reboot the device)"
  reboot
}

mkdir -p /etc/config-software
while :
do
  echo -e " \033[1;37mStart system initialization\033[0;39m"
  echo -e " \033[1;34mDevice Hostname\033[0;39m"
  echo -e " \033[1;33mDevice Password\033[0;39m"
  if [ -n /etc/config/wireless ]; then
  touch /etc/config/wireless
  fi
  WIFI_A=`uci show wireless | grep "band='2g'" | cut -d'.' -f2 | awk '{ print $1 }'`
  WIFI_B=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
  WIFI_C=`uci show wireless | grep "band='6g'" | cut -d'.' -f2 | awk '{ print $1 }'`
  WIFI_DEVICE=`uci show wireless | grep 'wifi-device' | wc -l`
  if [ "radio0" = "${WIFI_A}" ]; then
  WIFI_NO_A='2G'
  fi
  if [ "radio1" = "${WIFI_A}" ]; then
  WIFI_NO_B='2G'
  fi
  if [ "radio2" = "${WIFI_A}" ]; then
  WIFI_NO_C='2G'
  fi
  if [ "radio0" = "${WIFI_B}" ]; then
  WIFI_NO_A='5G'
  fi
  if [ "radio1" = "${WIFI_B}" ]; then
  WIFI_NO_B='5G'
  fi
  if [ "radio2" = "${WIFI_B}" ]; then
  WIFI_NO_C='5G'
  fi
  if [ "radio0" = "${WIFI_C}" ]; then
  WIFI_NO_A='6G'
  fi
  if [ "radio1" = "${WIFI_C}" ]; then
  WIFI_NO_B='6G'
  fi
  if [ "radio2" = "${WIFI_C}" ]; then
  WIFI_NO_C='6G'
  fi
  if [ "$WIFI_DEVICE" = "1" ]; then
  echo -e " \033[1;32mWi-Fi Country Code\033[0;39m"
  echo -e " \033[1;35mWi-Fi radio0 ${WIFI_NO_A} SSID\033[0;39m"
  echo -e " \033[1;31mWi-Fi radio0 ${WIFI_NO_A} Password\033[0;39m"
  echo -e " \033[1;43mWi-Fi GUEST\033[0;39m"
  echo -e " \033[1;41mTWT (Target Wake Time)\033[0;39m"
  fi
  if [ "$WIFI_DEVICE" = "2" ]; then
  echo -e " \033[1;35mWi-Fi radio0 ${WIFI_NO_A} SSID\033[0;39m"
  echo -e " \033[1;31mWi-Fi radio0 ${WIFI_NO_A} Password\033[0;39m"
  echo -e " \033[1;36mWi-Fi radio1 ${WIFI_NO_B} SSID\033[0;39m"
  echo -e " \033[1;37mWi-Fi radio1 ${WIFI_NO_B} Password\033[0;39m"
  echo -e " \033[1;43mWi-Fi GUEST\033[0;39m"
  echo -e " \033[1;41mTWT (Target Wake Time)\033[0;39m"
  fi
  if [ "$WIFI_DEVICE" = "3" ]; then
  echo -e " \033[1;35mWi-Fi radio0 ${WIFI_NO_A} SSID\033[0;39m"
  echo -e " \033[1;31mWi-Fi radio0 ${WIFI_NO_A} Password\033[0;39m"
  echo -e " \033[1;36mWi-Fi radio1 ${WIFI_NO_B} SSID\033[0;39m"
  echo -e " \033[1;37mWi-Fi radio1 ${WIFI_NO_B} Password\033[0;39m"
  echo -e " \033[1;44mWi-Fi radio2 ${WIFI_NO_C} SSID\033[0;39m"
  echo -e " \033[1;42mWi-Fi radio2 ${WIFI_NO_C} Password\033[0;39m"
  echo -e " \033[1;43mWi-Fi GUEST\033[0;39m"
  echo -e " \033[1;41mTWT (Target Wake Time)\033[0;39m"
  fi
  if [ "$WIFI_DEVICE" = "0" ]; then
  echo -e " \033[1;41mWi-Fi not found\033[0;39m"
  fi
  read -p " Please select key [y or q]:" num
  case "${num}" in
    "y" ) _func_HOSTNAME ;;
    "q" ) exit ;;
  esac
done

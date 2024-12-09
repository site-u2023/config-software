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
if [ ! -z ${WIFI_NO_A} ] || [ ! -z ${WIFI_NO_B} ] || [ ! -z ${WIFI_NO_C} ]; then
while :
do
  wget --no-check-certificate -O /etc/config-software/country_codes.txt https://raw.githubusercontent.com/site-u2023/config-software/main/country_codes.txt
  cat /etc/config-software/country_codes.txt
  echo -e " \033[1;35mPlease enter Wi-Fi Country Code\033[0;39m"
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
fi
_func_DEVICE_confirmation
}

function _func_WIFI_SSID_A {
if [ ! -z ${WIFI_NO_A} ]; then
while :
do
  echo -e " \033[1;32mPlease enter Wi-Fi ${RADIO_A} ${WIFI_NO_A} SSID\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_A} SSID: " input_str_WIFI_SSID_A
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_A ;;
    "n" ) _func_WIFI_SSID_A ;;
    "r" ) break ;;
  esac
done
fi
_func_WIFI_SSID_B 
}

function _func_WIFI_PASSWD_A {
while :
do
  echo -e " \033[1;36mPlease enter Wi-Fi ${RADIO_A} ${WIFI_NO_A} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_A} Password: " input_str_WIFI_PASSWD_A
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_AA ;;
    "n" ) _func_WIFI_PASSWD_A ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SSID_AA {
if [ ! -z ${WIFI_NO_AA} ]; then
while :
do
  echo -e " \033[1;32mPlease enter Wi-Fi ${RADIO_AA} ${WIFI_NO_AA} SSID\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_AA} SSID: " input_str_WIFI_SSID_AA
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_AA ;;
    "n" ) _func_WIFI_SSID_AA ;;
    "r" ) break ;;
  esac
done
fi
_func_WIFI_SSID_B 
}

function _func_WIFI_PASSWD_AA {
while :
do
  echo -e " \033[1;36mPlease enter Wi-Fi ${RADIO_AA} ${WIFI_NO_AA} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_AA} Password: " input_str_WIFI_PASSWD_AA
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_B ;;
    "n" ) _func_WIFI_PASSWD_AA ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SSID_B {
if [ ! -z ${WIFI_NO_B} ]; then
while :
do
  echo -e " \033[1;32mPlease enter Wi-Fi ${RADIO_B} ${WIFI_NO_B} SSID\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_B} SSID: " input_str_WIFI_SSID_B
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_B ;;
    "n" ) _func_WIFI_SSID_B ;;
    "r" ) break ;;
  esac
done
fi
_func_WIFI_SSID_C
}

function _func_WIFI_PASSWD_B {
while :
do
  echo -e " \033[1;36mPlease enter Wi-Fi ${RADIO_B} ${WIFI_NO_B} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_B} Password: " input_str_WIFI_PASSWD_B
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_BB ;;
    "n" ) _func_WIFI_PASSWD_B ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SSID_BB {
if [ ! -z ${WIFI_NO_BB} ]; then
while :
do
  echo -e " \033[1;32mPlease enter Wi-Fi ${RADIO_BB} ${WIFI_NO_BB} SSID\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_BB} SSID: " input_str_WIFI_SSID_BB
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_BB ;;
    "n" ) _func_WIFI_SSID_BB ;;
    "r" ) break ;;
  esac
done
fi
_func_WIFI_SSID_C
}

function _func_WIFI_PASSWD_BB {
while :
do
  echo -e " \033[1;36mPlease enter Wi-Fi ${RADIO_BB} ${WIFI_NO_BB} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_BB} Password: " input_str_WIFI_PASSWD_BB
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_C ;;
    "n" ) _func_WIFI_PASSWD_BB ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SSID_C {
if [ ! -z ${WIFI_NO_C} ]; then
while :
do
  echo -e " \033[1;32mPlease enter Wi-Fi ${RADIO_C} ${WIFI_NO_C} SSID\033[0;39m"
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
if [ ! -z ${WIFI_NO_C} ]; then
while :
do
  echo -e " \033[1;36mPlease enter Wi-Fi ${RADIO_C} ${WIFI_NO_C} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_C} Password: " input_str_WIFI_PASSWD_C
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_CC ;;
    "n" ) _func_WIFI_PASSWD_C ;;
    "r" ) break ;;
  esac
done
fi
}

function _func_WIFI_SSID_CC {
if [ ! -z ${WIFI_NO_CC} ]; then
while :
do
  echo -e " \033[1;32mPlease enter Wi-Fi ${RADIO_CC} ${WIFI_NO_CC} SSID\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_CC} SSID: " input_str_WIFI_SSID_CC
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_CC ;;
    "n" ) _func_WIFI_SSID_CC ;;
    "r" ) break ;;
  esac
done
fi
_func_GUEST 
}

function _func_WIFI_PASSWD_CC {
while :
do
  echo -e " \033[1;36mPlease enter Wi-Fi ${RADIO_CC} ${WIFI_NO_CC} password\033[0;39m"
  echo -e " \033[1;35mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_CC} Password: " input_str_WIFI_PASSWD_CC
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_GUEST ;;
    "n" ) _func_WIFI_PASSWD_CC ;;
    "r" ) break ;;
  esac
done
}

function _func_GUEST {
while :
do
  echo -e " \033[1;41mUse Wi-Fi GUEST\033[0;39m"
  echo -e " \033[1;31m[0]: OFF\033[0;39m"
  echo -e " \033[1;34m[1]: ON\033[0;39m"
  read -p " Please select key [0/1 or r]: " num
  case "${num}" in
    "0" ) GUEST=''
          _func_WIFI_TWT ;;
    "1" ) GUEST='on' 
          _func_WIFI_TWT ;;
    "r" ) break ;;     
  esac
done
}

function _func_WIFI_TWT {
if [ ${WIFI_NO_B} = '5G' ]; then
while :
do
  echo -e " \033[1;41mUse TWT (Only WiFi6)\033[0;39m"
  echo -e " \033[1;31m[0]: OFF\033[0;39m"
  echo -e " \033[1;34m[1]: ON\033[0;39m"
  read -p " Please select key [0/1 or r]: " num
  case "${num}" in
    "0" ) TWT=''
          _func_ZZDFS ;;
    "1" ) TWT='on'
          _func_ZZDF ;;
    "r" ) break ;;    
  esac
done
fi
_func_DEVICE_confirmation
}

function _func_ZZDFS {
while :
do
  echo -e " \033[1;41mUse DFS Check NEW\033[0;39m"
  echo -e " \033[1;31m[0]: OFF\033[0;39m"
  echo -e " \033[1;34m[1]: ON\033[0;39m"
  read -p " Please select key [0/1 or r]: " num
  case "${num}" in
    "0" ) ZZDFS=''
          _func_DEVICE_confirmation ;;
    "1" ) ZZDFS='on'
          _func_DEVICE_confirmation ;;
    "r" ) break ;;   
  esac
done
}

function _func_DEVICE_confirmation {
while :
do 
  echo -e " \033[1;37mSystem setup ----------------------------------------\033[0;39m"
  echo -e " \033[1;34mDevice Hostname: ${input_str_SYSTEM_HOSTNAME}\033[0;39m"
  echo -e " \033[1;33mDevice Password: ${input_str_ROOT_PASSWD}\033[0;39m"
  echo -e " \033[1;35mWi-Fi Country Code: ${input_str_COUNTRY}\033[0;39m"
  if [ ! -z ${WIFI_NO_A} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_A} ${WIFI_NO_A} SSID: ${input_str_WIFI_SSID_A}\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_A} ${WIFI_NO_A} Password: ${input_str_WIFI_PASSWD_A}\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_AA} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_AA} ${WIFI_NO_AA} SSID: ${input_str_WIFI_SSID_AA}\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_AA} ${WIFI_NO_AA} Password: ${input_str_WIFI_PASSWD_AA}\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_B} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_B} ${WIFI_NO_B} SSID: ${input_str_WIFI_SSID_B}\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_B} ${WIFI_NO_B} Password: ${input_str_WIFI_PASSWD_B}\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_BB} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_BB} ${WIFI_NO_BB} SSID: ${input_str_WIFI_SSID_BB}\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_BB} ${WIFI_NO_BB} Password: ${input_str_WIFI_PASSWD_BB}\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_C} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_C} ${WIFI_NO_C} SSID: ${input_str_WIFI_SSID_C}\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_C} ${WIFI_NO_C} Password: ${input_str_WIFI_PASSWD_C}\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_CC} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_CC} ${WIFI_NO_CC} SSID: ${input_str_WIFI_SSID_CC}\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_CC} ${WIFI_NO_CC} Password: ${input_str_WIFI_PASSWD_CC}\033[0;39m"
  fi
  if [ -n "$GUEST" ]; then
  echo -e " \033[1;41mWi-Fi GUEST: ON\033[0;39m"
  fi
  if [ -n "$TWT" ]; then
  echo -e " \033[1;41mTWT: ON\033[0;39m"
  fi
  if [ -n "$ZZDFS" ]; then
  echo -e " \033[1;41mZZDFS033[0;39m"
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
  sed -i -e "s|JST-9|CST-8|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "HK" ]; then
  sed -i -e "s|UTC|Asia/Hong Kong|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|HKT-8|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "US" ]; then
  echo -e " \033[1;37mYou probably live in Hawaii\033[0;39m"
  echo -e " \033[1;37mPlease change to your local time zone\033[0;39m"
  sed -i -e "s|UTC|Pacific/Honolulu|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|HST10|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "TW" ]; then
  sed -i -e "s|UTC|Asia/Taipei|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|CST-8|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "KR" ]; then
  sed -i -e "s|UTC|Asia/Seoul|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|KST-9|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "RU" ]; then
  sed -i -e "s|UTC|Europe/Moscow|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|MSK-3|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "ID" ]; then
  sed -i -e "s|UTC|Asia/Jakarta|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|WIB-7|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "VN" ]; then
  sed -i -e "s|UTC|Asia/Jakarta|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|WIB-7|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "DE" ]; then
  sed -i -e "s|UTC|Europe/Berlin|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|CET-1CEST,M3.5.0,M10.5.0/3|g" /etc/config-software/system.sh
  fi
  if [ "$input_str_COUNTRY" = "FR" ]; then
  sed -i -e "s|UTC|Europe/Paris|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|CET-1CEST,M3.5.0,M10.5.0/3|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "AU" ]; then
  sed -i -e "s|UTC|Australia/Melbourne|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|AEST-10AEDT,M10.1.0,M4.1.0/3|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "CA" ]; then
  echo -e " \033[1;37mIs Alaska ok?\033[0;39m"
  echo -e " \033[1;37mPlease change to your local time zone\033[0;39m"
  sed -i -e "s|UTC|America/Anchorage|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|AKST9AKDT,M3.2.0,M11.1.0|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "IN" ]; then
  sed -i -e "s|UTC|Asia/Kolkata|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|IST-5:30|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "TR" ]; then
  sed -i -e "s|UTC|Europe/Istanbul|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|<+03>-3|g" /etc/config-software/system.sh
  fi 
  if [ "$input_str_COUNTRY" = "SG" ]; then
  sed -i -e "s|UTC|Asia/Singapore|g" /etc/config-software/system.sh
  sed -i -e "s|JST-9|<+08>-8|g" /etc/config-software/system.sh
  fi 
  if [ -z "$input_str_COUNTRY" ]; then
  echo -e " \033[5;43mPlease change time zone manually\033[0;39m"
  sed -i -e "s|JST-9||g" /etc/config-software/system.sh
  fi
  sed -i -e "s/HOSTNAME='openwrt'/HOSTNAME=${input_str_SYSTEM_HOSTNAME}/g" /etc/config-software/system.sh
  sed -i -e "s/ROOT_PASSWD/${input_str_ROOT_PASSWD}/g" /etc/config-software/system.sh
  sed -i -e "s/Country_Code/${input_str_COUNTRY}/g" /etc/config-software/system.sh
  sed -i -e "s/RADIO_A='radio'/RADIO_A=${RADIO_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_A='password'/WIFI_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/config-software/system.sh
  sed -i -e "s/RADIO_AA='radio'/RADIO_AA=${RADIO_AA}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_AA='SSID_AA'/WIFI_SSID_AA=${input_str_WIFI_SSID_AA}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_AA='password'/WIFI_PASSWORD_AA=${input_str_WIFI_PASSWD_AA}/g" /etc/config-software/system.sh
  sed -i -e "s/RADIO_B='radio'/RADIO_B=${RADIO_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_B='password'/WIFI_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" /etc/config-software/system.sh
  sed -i -e "s/RADIO_BB='radio'/RADIO_BB=${RADIO_BB}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_BB='SSID_BB'/WIFI_SSID_BB=${input_str_WIFI_SSID_BB}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_BB='password'/WIFI_PASSWORD_BB=${input_str_WIFI_PASSWD_BB}/g" /etc/config-software/system.sh
  sed -i -e "s/RADIO_C='radio'/RADIO_C=${RADIO_C}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_C='SSID_C'/WIFI_SSID_C=${input_str_WIFI_SSID_C}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_C='password'/WIFI_PASSWORD_C=${input_str_WIFI_PASSWD_C}/g" /etc/config-software/system.sh
  sed -i -e "s/RADIO_CC='radio'/RADIO_CC=${RADIO_CC}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_CC='SSID_CC'/WIFI_SSID_CC=${input_str_WIFI_SSID_CC}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_CC='password'/WIFI_PASSWORD_CC=${input_str_WIFI_PASSWD_CC}/g" /etc/config-software/system.sh
  sh /etc/config-software/system.sh 2> /dev/null
  if [ "$TWT" = "on" ]; then
  sed -i -e "s/he_twt_required:0/he_twt_required:1/g" /lib/netifd/wireless/mac80211.sh
  uci add_list wireless.${RADIO_B}.hostapd_options='he_twt_responder=1'
  uci add_list wireless.${RADIO_BB}.hostapd_options='he_twt_responder=1'
  uci commit wireless
  fi
  if [ "$ZZDFS" = "on" ]; then
  wget --no-check-certificate -O /etc/config-software/zzdfs-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/zzdfs-config.sh
  sh /etc/config-software/zzdfs-config.sh 2> /dev/null
  service zzdfs enable
  fi
  if [ "$GUEST" = "on" ]; then
  OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
    if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "19" ]]; then
      opkg update
      opkg install bash
      opkg install qrencode
      opkg install at
      wget --no-check-certificate -O /etc/config-software/guest.sh https://raw.githubusercontent.com/site-u2023/config-software/main/guest.sh
      bash /etc/config-software/guest.sh 2> /dev/null
      service guest_wifi enable
    fi
  fi
  echo -e " \033[1;32mLuCi: http://${input_str_SYSTEM_HOSTNAME}.lan\033[0;39m"
  if [ "$GUEST" = "on" ]; then
  echo -e " \033[1;32mGuest Wi-Fi: http://${input_str_SYSTEM_HOSTNAME}.lan/guest.html\033[0;39m"
  fi
  if [ "$ZZDFS" = "on" ]; then
  echo -e " \033[1;32mDFS Check NOW: How to check logs 'dfslog'\033[0;39m"
  fi
  read -p " Press any key (Reboot the device)"
  reboot
}

mkdir -p /etc/config-software
while :
do
  echo -e " \033[1;37mSystem setup started\033[0;39m"
  echo -e " \033[1;37mBasic Settings\033[0;39m"
  echo -e " \033[1;34mDevice Hostname\033[0;39m"
  echo -e " \033[1;33mDevice Password\033[0;39m"
  if [ -n /etc/config/wireless ]; then
  touch /etc/config/wireless
  fi
  WIFI_A=`uci show wireless | grep "band='2g'" | cut -d'.' -f2 | awk '{ print $1 }' | sed -n '1p'`
  WIFI_AA=`uci show wireless | grep "band='2g'" | cut -d'.' -f2 | awk '{ print $1 }' | sed -n '2p'`
  WIFI_B=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }' | sed -n '1p'`
  WIFI_BB=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }' | sed -n '2p'`
  WIFI_C=`uci show wireless | grep "band='6g'" | cut -d'.' -f2 | awk '{ print $1 }' | sed -n '1p'`
  WIFI_CC=`uci show wireless | grep "band='6g'" | cut -d'.' -f2 | awk '{ print $1 }' | sed -n '2P'`
  if [ "radio0" = "${WIFI_A}" ]; then
  WIFI_NO_A='2G'
  RADIO_A='radio0'
  fi
  if [ "radio0" = "${WIFI_AA}" ]; then
  WIFI_NO_AA='2G'
  RADIO_AA='radio0'
  fi
  if [ "radio1" = "${WIFI_A}" ]; then
  WIFI_NO_A='2G'
  RADIO_A='radio1'
  fi
  if [ "radio1" = "${WIFI_AA}" ]; then
  WIFI_NO_AA='2G'
  RADIO_AA='radio1'
  fi
  if [ "radio2" = "${WIFI_A}" ]; then
  WIFI_NO_A='2G'
  RADIO_A='radio2'
  fi
  if [ "radio2" = "${WIFI_AA}" ]; then
  WIFI_NO_AA='2G'
  RADIO_AA='radio2'
  fi
  if [ "radio0" = "${WIFI_B}" ]; then
  WIFI_NO_B='5G'
  RADIO_B='radio0'
  fi
  if [ "radio0" = "${WIFI_BB}" ]; then
  WIFI_NO_BB='5G'
  RADIO_BB='radio0'
  fi
  if [ "radio1" = "${WIFI_B}" ]; then
  WIFI_NO_B='5G'
  RADIO_B='radio1'
  fi
  if [ "radio1" = "${WIFI_BB}" ]; then
  WIFI_NO_BB='5G'
  RADIO_BB='radio1'
  fi
  if [ "radio2" = "${WIFI_B}" ]; then
  WIFI_NO_B='5G'
  RADIO_B='radio2'
  fi
  if [ "radio2" = "${WIFI_BB}" ]; then
  WIFI_NO_BB='5G'
  RADIO_BB='radio2'
  fi
  if [ "radio0" = "${WIFI_C}" ]; then
  WIFI_NO_C='6G'
  RADIO_C='radio0'
  fi
  if [ "radio0" = "${WIFI_CC}" ]; then
  WIFI_NO_CC='6G'
  RADIO_CC='radio0'
  fi
  if [ "radio1" = "${WIFI_C}" ]; then
  WIFI_NO_C='6G'
  RADIO_C='radio1'
  fi
  if [ "radio1" = "${WIFI_CC}" ]; then
  WIFI_NO_CC='6G'
  RADIO_CC='radio1'
  fi
  if [ "radio2" = "${WIFI_C}" ]; then
  WIFI_NO_C='6G'
  RADIO_C='radio2'
  fi
  if [ "radio2" = "${WIFI_CC}" ]; then
  WIFI_NO_CC='6G'
  RADIO_CC='radio2'
  fi
  
  echo -e " \033[1;35mWi-Fi Country Code\033[0;39m"
  if [ ! -z ${WIFI_NO_A} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_A} ${WIFI_NO_A} SSID\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_A} ${WIFI_NO_A} Password\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_AA} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_AA} ${WIFI_NO_AA} SSID\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_AA} ${WIFI_NO_AA} Password\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_B} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_B} ${WIFI_NO_B} SSID\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_B} ${WIFI_NO_B} Password\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_BB} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_BB} ${WIFI_NO_BB} SSID\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_BB} ${WIFI_NO_BB} Password\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_C} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_C} ${WIFI_NO_C} SSID\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_C} ${WIFI_NO_C} Password\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_CC} ]; then
  echo -e " \033[1;32mWi-Fi ${RADIO_CC} ${WIFI_NO_CC} SSID\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${RADIO_CC} ${WIFI_NO_CC} Password\033[0;39m"
  fi
  if [ ! -z ${WIFI_NO_A} ] || [ ! -z ${WIFI_NO_B} ] || [ ! -z ${WIFI_NO_C} ]; then
  echo -e " \033[1;41mWi-Fi GUEST\033[0;39m"
  fi
  if [ ${WIFI_NO_B} = '5G' ]; then
  echo -e " \033[1;41mTWT (Target Wake Time)\033[0;39m"
  echo -e " \033[1;41mDFS Check NEW\033[0;39m"
  fi
  read -p " Please select key [y or q]:" num
  case "${num}" in
    "y" ) _func_HOSTNAME ;;
    "q" ) exit ;;
  esac
done

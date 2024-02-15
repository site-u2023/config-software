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
while :
do
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
  echo -e " \033[1;32mExpecting: key between 8 and 63 characters\033[0;39m"
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
}

function _func_WIFI_PASSWD_B {
while :
do
  echo -e " \033[1;37mPlease enter Wi-Fi ${WIFI_NO_B} password\033[0;39m"
  echo -e " \033[1;32mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_B} Password: " input_str_WIFI_PASSWD_B
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SEARCH ;;
    "n" ) _func_WIFI_PASSWD_B ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SEARCH {
    if [ "$WIFI_DEVICE" = "$WIFI_NO" ]; then
     _func_WIFI_SSID_C
    else
     _func_WIFI_TWT
    fi
}

function _func_WIFI_SSID_C {
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
}

function _func_WIFI_PASSWD_C {
while :
do
  echo -e " \033[1;42mPlease enter Wi-Fi ${WIFI_NO_C} password\033[0;39m"
  echo -e " \033[1;32mExpecting: key between 8 and 63 characters\033[0;39m"
  read -p " Wi-Fi ${WIFI_NO_C} Password: " input_str_WIFI_PASSWD_C
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_TWT ;;
    "n" ) _func_WIFI_PASSWD_C ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_TWT {
while :
do
  echo -e " \033[1;41mUse TWT (Only WiFi6)\033[0;39m"
  echo -e " \033[1;41m[1]: ON\033[0;39m"
  echo -e " \033[1;41m[2]: OFF\033[0;39m"
  read -p " Please select key [1/2]: " num
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
  echo -e " \033[1;32mWi-Fi Country Code: ${input_str_COUNTRY}\033[0;39m"
  echo -e " \033[1;35mWi-Fi ${WIFI_NO_A} SSID: ${input_str_WIFI_SSID_A}\033[0;39m"
  echo -e " \033[1;31mWi-Fi ${WIFI_NO_A} Password: ${input_str_WIFI_PASSWD_A}\033[0;39m"
  echo -e " \033[1;36mWi-Fi ${WIFI_NO_B} SSID: ${input_str_WIFI_SSID_B}\033[0;39m"
  echo -e " \033[1;37mWi-Fi ${WIFI_NO_B} Password: ${input_str_WIFI_PASSWD_B}\033[0;39m"
   if [ "$WIFI_DEVICE" = "$WIFI_NO" ]; then
  echo -e " \033[1;44mWi-Fi ${WIFI_NO_C} SSID: ${input_str_WIFI_SSID_C}\033[0;39m"
  echo -e " \033[1;42mWi-Fi ${WIFI_NO_C} Password: ${input_str_WIFI_PASSWD_C}\033[0;39m"
   fi
   if [ -n "$TWT" ]; then
  echo -e " \033[1;41mTWT ON\033[0;39m"
   else
   echo -e " \033[1;41mTWT OFF\033[0;39m"  
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
  sed -i -e "s/HOSTNAME='openwrt'/HOSTNAME=${input_str_SYSTEM_HOSTNAME}/g" /etc/config-software/system.sh
  sed -i -e "s/ROOT_PASSWD/${input_str_ROOT_PASSWD}/g" /etc/config-software/system.sh
  sed -i -e "s/Country_Code/${input_str_COUNTRY}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_A='password'/WIFI_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_B='password'/WIFI_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_C='SSID_C'/WIFI_SSID_C=${input_str_WIFI_SSID_C}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_C='password'/WIFI_PASSWORD_C=${input_str_WIFI_PASSWD_C}/g" /etc/config-software/system.sh  
  echo -e " \033[7;40mPlease change time zone manually\033[0;39m"
   if [ "$TWT" = "on" ]
    then
  sed -i -e "s/he_twt_required:0/he_twt_required:1/g" /lib/netifd/wireless/mac80211.sh
  uci add_list wireless.radio0.hostapd_options='he_twt_responder=1'
  uci add_list wireless.radio1.hostapd_options='he_twt_responder=1'
  uci commit wireless
   fi
   if [ "$input_str_COUNTRY" = "ja" ]
    then
  sed -i -e "s|UTC|Asia/Tokyo|g" /etc/config-software/system.sh
   fi
  sh /etc/config-software/system.sh 2> /dev/null
  read -p " Press any key (Reboot the device)"
  reboot
  exit
}

WIFI_A=`uci show wireless | grep "band='2g'" | cut -d'.' -f2 | awk '{ print $1 }'`
WIFI_B=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
WIFI_C=`uci show wireless | grep "band='6g'" | cut -d'.' -f2 | awk '{ print $1 }'`
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
while :
do
  echo -e " \033[1;37mStart system initialization\033[0;39m"
  echo -e " \033[1;34mDevice Hostname\033[0;39m"
  echo -e " \033[1;33mDevice Password\033[0;39m"
  echo -e " \033[1;32mWi-Fi Country Code\033[0;39m"
  echo -e " \033[1;35mWi-Fi radio0${WIFI_NO_A} SSID\033[0;39m"
  echo -e " \033[1;31mWi-Fi radio0 ${WIFI_NO_A} Password\033[0;39m"
  echo -e " \033[1;36mWi-Fi radio1 ${WIFI_NO_B} SSID\033[0;39m"
  echo -e " \033[1;37mWi-Fi radio1 ${WIFI_NO_B} Password\033[0;39m"
  WIFI_DEVICE=`uci show wireless | grep 'wifi-device' | wc -l`
  WIFI_NO=3
  if [ "$WIFI_DEVICE" = "$WIFI_NO" ]; then
  echo -e " \033[1;44mWi-Fi radio2 ${WIFI_NO_C} SSID\033[0;39m"
  echo -e " \033[1;42mWi-Fi radio2 ${WIFI_NO_C} Password\033[0;39m"
  fi
  echo -e " \033[1;41mTWT (Target Wake Time)\033[0;39m"
  read -p " Please select key [y or q]:" num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/country_codes.txt https://raw.githubusercontent.com/site-u2023/config-software/main/country_codes.txt
          _func_HOSTNAME ;;
    "n" ) exit ;;
  esac
done

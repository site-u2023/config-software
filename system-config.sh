#! /bin/sh


function _func_HOSTNAME {
while :
do
  echo -e " \033[1;34mPlease enter the device hostame\033[0;39m"
  read -p " Device Hostname: " input_str_SYSTEM_HOSTNAME
  read -p " All right? [y/n or r]: " num
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
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[1;37mar: العربية (Arabic)\033[0;39m"
  echo -e " \033[1;37mbg: български (Bulgarian)\033[0;39m"
  echo -e " \033[1;37mbn: বাংলা (Bengali)\033[0;39m"
  echo -e " \033[1;37mca: Català (Catalan)\033[0;39m"
  echo -e " \033[1;37mcs: Čeština (Czech)\033[0;39m"
  echo -e " \033[1;37mda: Dansk (Danish)\033[0;39m"
  echo -e " \033[1;37mde: Deutsch (German)\033[0;39m"
  echo -e " \033[1;37mel: Ελληνικά (Greek)\033[0;39m"
  echo -e " \033[1;37mes: Español (Spanish)\033[0;39m"
  echo -e " \033[1;37mfi: Suomi (Finnish)\033[0;39m"
  echo -e " \033[1;37mfr: Français (French)\033[0;39m"
  echo -e " \033[1;37mhe: עִבְרִית (Hebrew)\033[0;39m"
  echo -e " \033[1;37mhu: Magyar (Hungarian)\033[0;39m"
  echo -e " \033[1;37mit: Italiano (Italian)\033[0;39m"
  echo -e " \033[1;37mja: 日本語 (Japanese)\033[0;39m"
  echo -e " \033[1;37mko: 한국어 (Korean)\033[0;39m"
  echo -e " \033[1;37mlt: Lietuvių (Lithuanian)\033[0;39m"
  echo -e " \033[1;37mmr: Marāṭhī (Marathi)\033[0;39m"
  echo -e " \033[1;37mms: Bahasa Melayu (Malay)\033[0;39m"
  echo -e " \033[1;37mnl: Nederlands (Dutch)\033[0;39m"
  echo -e " \033[1;37mno: Norsk (Norwegian)\033[0;39m"
  echo -e " \033[1;37mpl: Polski (Polish)\033[0;39m"
  echo -e " \033[1;37mpt: Português (Portuguese)\033[0;39m"
  echo -e " \033[1;37mpt-br: Português do Brasil (Brazilian Portuguese)\033[0;39m"
  echo -e " \033[1;37mro: Română (Romanian)\033[0;39m"
  echo -e " \033[1;37mru: Русский (Russian)\033[0;39m"
  echo -e " \033[1;37msk: Slovenčina (Slovak)\033[0;39m"
  echo -e " \033[1;37msv: Svenska (Swedish)\033[0;39m"
  echo -e " \033[1;37mtr: Türkçe (Turkish)\033[0;39m"
  echo -e " \033[1;37muk: Українська (Ukrainian)\033[0;39m"
  echo -e " \033[1;37mvi: Tiếng Việt (Vietnamese)\033[0;39m"
  echo -e " \033[1;37mzh-cn: 简体中文 (Chinese Simplified)\033[0;39m"
  echo -e " \033[1;37mzh-tw: 繁體中文 (Chinese Traditional)\033[0;39m"
  echo -e " \033[1;37mPlease enter country code\033[0;39m"
  echo -e " \033[1;37mExample: ar\033[0;39m"
  read -p " Country: " input_str_COUNTRY
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[1;32mPlease enter Wi-Fi${WIFI_NO_A} SSID\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_A} SSID: " input_str_WIFI_SSID_A
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[1;35mPlease enter WiFi ${WIFI_NO_A} password\033[0;39m"
  read -p " WiFi ${WIFI_NO_A} Password: " input_str_WIFI_PASSWD_A
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[1;31mPlease enter WiFi ${WIFI_NO_B} SSID\033[0;39m"
  read -p " WiFi ${WIFI_NO_B} SSID: " input_str_WIFI_SSID_B
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[1;36mPlease enter WiFi ${WIFI_NO_B} password\033[0;39m"
  read -p " WiFi ${WIFI_NO_B} Password: " input_str_WIFI_PASSWD_B
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[1;37mPlease enter WiFi ${WIFI_NO_C} SSID\033[0;39m"
  read -p " WiFi ${WIFI_NO_C} SSID: " input_str_WIFI_SSID_C
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[1;37mPlease enter WiFi ${WIFI_NO_C} password\033[0;39m"
  read -p " WiFi ${WIFI_NO_C} Password: " input_str_WIFI_PASSWD_C
  read -p " All right? [y/n or r]: " num
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
  echo -e " \033[7;40mUse TWT (Only WiFi6)\033[0;39m"
  echo -e " \033[7;40mTWT: ON\033[0;39m"
  read -p " All right? [y/n or r]: " num
  case "${num}" in
    "y" ) TWT=on
          _func_DEVICE_confirmation ;;
    "n" ) _func_WIFI_TWT ;;
    "r" ) break ;;
  esac
done
}

function _func_DEVICE_confirmation {
while :
do 
  echo -e " \033[1;37msystem setup ----------------------------------------\033[0;39m"
  echo -e " \033[1;34mDevice hostname: ${input_str_SYSTEM_HOSTNAME}\033[0;39m"
  echo -e " \033[1;33mDevice Password: ${input_str_ROOT_PASSWD}\033[0;39m"
  echo -e " \033[1;32mCountry: ${input_str_COUNTRY}\033[0;39m"
  echo -e " \033[1;32mWiFi ${WIFI_NO_A} SSID: ${input_str_WIFI_SSID_A}\033[0;39m"
  echo -e " \033[1;35mWiFi ${WIFI_NO_A} Password: ${input_str_WIFI_PASSWD_A}\033[0;39m"
  echo -e " \033[1;31mWiFi ${WIFI_NO_B} SSID: ${input_str_WIFI_SSID_B}\033[0;39m"
  echo -e " \033[1;36mWiFi ${WIFI_NO_B} Password: ${input_str_WIFI_PASSWD_B}\033[0;39m"
   if [ "$WIFI_DEVICE" = "$WIFI_NO" ]
    then
  echo -e " \033[1;37mWiFi ${WIFI_NO_C} SSID: ${input_str_WIFI_SSID_C}\033[0;39m"
  echo -e " \033[1;37mWiFi ${WIFI_NO_C} Password: ${input_str_WIFI_PASSWD_C}\033[0;39m"
   fi
   if [ "$TWT" = "on" ]
    then
  echo -e " \033[1;36mTWT ON\033[0;39m"
   fi
  echo -e " \033[1;37m----------------------------------------------------\033[0;39m"
  read -p " All right? [y/n or q]: " num
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
  sed -i -e "s/COUNTRY='Country_Code'/COUNTRY=${input_str_COUNTRY}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_A='password'/WIFI_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_B='password'/WIFI_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_C='SSID_C'/WIFI_SSID_C=${input_str_WIFI_SSID_C}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_C='password'/WIFI_PASSWORD_C=${input_str_WIFI_PASSWD_C}/g" /etc/config-software/system.sh  
   if [ "$TWT" = "on" ]
    then
  sed -i -e "s/he_twt_required:0/he_twt_required:1/g" /lib/netifd/wireless/mac80211.sh
  uci add_list wireless.radio0.hostapd_options='he_twt_responder=1'
  uci add_list wireless.radio1.hostapd_options='he_twt_responder=1'
  uci commit wireless
   fi
  sh /etc/config-software/system.sh 2> /dev/null
  read -p " Press any key (Reboot the device)"
  reboot
  exit
}

WIFI_A=`uci show wireless | grep '5g' | cut -d'.' -f2 | awk '{ print $1 }'`
WIFI_B=`uci show wireless | grep '2g' | cut -d'.' -f2 | awk '{ print $1 }'`
WIFI_C=`uci show wireless | grep '5g' | cut -d'.' -f2 | awk '{ print $2 }'`
WIFI_D=`uci show wireless | grep '2g' | cut -d'.' -f2 | awk '{ print $2 }'`
if [ "radio0" = "${WIFI_A}" ]; then
WIFI_NO_A='5G:radio0'
fi
if [ "radio1" = "${WIFI_A}" ]; then
WIFI_NO_B='5G:radio1'
fi
if [ "radio2" = "${WIFI_A}" ]; then
WIFI_NO_C='5G:radio2'
fi
if [ "radio0" = "${WIFI_B}" ]; then
WIFI_NO_A='2G:radio0'
fi
if [ "radio1" = "${WIFI_B}" ]; then
WIFI_NO_B='2G:radio1'
fi
if [ "radio2" = "${WIFI_B}" ]; then
WIFI_NO_C='2G:radio2'
fi
if [ "radio0" = "${WIFI_C}" ]; then
WIFI_NO_A='5G:radio0'
fi
if [ "radio1" = "${WIFI_C}" ]; then
WIFI_NO_B='5G:radio1'
fi
if [ "radio2" = "${WIFI_C}" ]; then
WIFI_NO_C='5G:radio2'
fi
if [ "radio0" = "${WIFI_D}" ]; then
WIFI_NO_A='2G:radio0'
fi
if [ "radio1" = "${WIFI_D}" ]; then
WIFI_NO_B='2G:radio1'
fi
if [ "radio2" = "${WIFI_D}" ]; then
WIFI_NO_C='2G:radio2'
fi
while :
do
  echo -e " \033[1;37mStart system initialization\033[0;39m"
  echo -e " \033[1;34mDevice hostname\033[0;39m"
  echo -e " \033[1;33mDevice Password\033[0;39m"
  echo -e " \033[1;32mWiFi ${WIFI_NO_A} SSID\033[0;39m"
  echo -e " \033[1;35mWiFi ${WIFI_NO_A} Password\033[0;39m"
  echo -e " \033[1;31mWiFi ${WIFI_NO_B} SSID\033[0;39m"
  echo -e " \033[1;36mWiFi ${WIFI_NO_B} Password\033[0;39m"
  echo -e " \033[1;36mTWT (Target Wake Time)\033[0;39m"
  WIFI_DEVICE=`uci show wireless | grep 'wifi-device' | wc -l`
  WIFI_NO=3
  if [ "$WIFI_DEVICE" = "$WIFI_NO" ]; then
  echo -e " \033[1;37m・WiFi ${WIFI_NO_C} SSID\033[0;39m"
  echo -e " \033[1;37m・WiFi ${WIFI_NO_C} Password\033[0;39m"
  fi
  read -p " Start [y/n]:" num
  case "${num}" in
    "y" ) _func_HOSTNAME ;;
    "n" ) exit ;;
  esac
done

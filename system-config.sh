#! /bin/sh


function _func_HOSTNAME {
while :
do
  echo -e " \033[1;34mデバイスのホストネームを入力して下さい\033[0;39m"
  read -p " デバイスのホストネーム: " input_str_SYSTEM_HOSTNAME
  read -p " 宜しいですか? [y/n or r]: " num
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
  echo -e " \033[1;33mデバイスのパスワードを入力して下さい\033[0;39m"
  read -p " デバイスのパスワード: " input_str_ROOT_PASSWD
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_A ;;
    "n" ) _func_ROOT_PASSWD ;;
    "r" ) break ;;
  esac
done
}

function _func_WIFI_SSID_A {
while :
do
  echo -e " \033[1;32mWi-Fi${WIFI_NO_A}のSSIDを入力して下さい\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_A}のSSID: " input_str_WIFI_SSID_A
  read -p " 宜しいですか? [y/n or r]: " num
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
  echo -e " \033[1;35mWi-Fi${WIFI_NO_A}のパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_A}のパスワード: " input_str_WIFI_PASSWD_A
  read -p " 宜しいですか? [y/n or r]: " num
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
  echo -e " \033[1;31mWi-Fi${WIFI_NO_B}のSSIDを入力して下さい\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_B}のSSID: " input_str_WIFI_SSID_B
  read -p " 宜しいですか? [y/n or r]: " num
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
  echo -e " \033[1;36mWi-Fi${WIFI_NO_B}のパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_B}のパスワード: " input_str_WIFI_PASSWD_B
  read -p " 宜しいですか? [y/n or r]: " num
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
     _func_DEVICE_confirmation
    fi
}

function _func_WIFI_SSID_C {
while :
do
  echo -e " \033[1;37mWi-Fi${WIFI_NO_C}のSSIDを入力して下さい\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_C}のSSID: " input_str_WIFI_SSID_C
  read -p " 宜しいですか? [y/n or r]: " num
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
  echo -e " \033[1;37mWi-Fi${WIFI_NO_C}のパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi${WIFI_NO_C}のパスワード: " input_str_WIFI_PASSWD_C
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DEVICE_confirmation ;;
    "n" ) _func_WIFI_PASSWD_C ;;
    "r" ) break ;;
  esac
done
}

function _func_DEVICE_confirmation {
while :
do 
  echo -e " \033[1;37mシステム設定 ----------------------------------------\033[0;39m"
  echo -e " \033[1;34mデバイスのホストネーム: ${input_str_SYSTEM_HOSTNAME}\033[0;39m"
  echo -e " \033[1;33mデバイスのパスワード: ${input_str_ROOT_PASSWD}\033[0;39m"
  echo -e " \033[1;32mWi-Fi${WIFI_NO_A}のSSID: ${input_str_WIFI_SSID_A}\033[0;39m"
  echo -e " \033[1;35mWi-Fi${WIFI_NO_A}のパスワード: ${input_str_WIFI_PASSWD_A}\033[0;39m"
  echo -e " \033[1;31mWi-Fi${WIFI_NO_B}のSSID: ${input_str_WIFI_SSID_B}\033[0;39m"
  echo -e " \033[1;36mWi-Fi${WIFI_NO_B}のパスワード: ${input_str_WIFI_PASSWD_B}\033[0;39m"
   if [ "$WIFI_DEVICE" = "$WIFI_NO" ]
    then
  echo -e " \033[1;37mWi-Fi${WIFI_NO_C}のSSID: ${input_str_WIFI_SSID_C}\033[0;39m"
  echo -e " \033[1;37mWi-Fi${WIFI_NO_C}のパスワード: ${input_str_WIFI_PASSWD_C}\033[0;39m"
   fi
  echo -e " \033[1;37m----------------------------------------------------\033[0;39m"
  read -p " これで宜しければ設定を開始します [y/n or q]: " num
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
  sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_A='password'/WIFI_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_B='password'/WIFI_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_SSID_C='SSID_C'/WIFI_SSID_C=${input_str_WIFI_SSID_C}/g" /etc/config-software/system.sh
  sed -i -e "s/WIFI_PASSWORD_C='password'/WIFI_PASSWORD_C=${input_str_WIFI_PASSWD_C}/g" /etc/config-software/system.sh
  sh /etc/config-software/system.sh 2> /dev/null
  read -p " 何かキーを押してデバイスを再起動してください"
  reboot
  exit
}

WIFI_A=`uci show wireless | grep '5g'| cut -d'.' -f2 | awk '{ print $1 }'`
WIFI_B=`uci show wireless | grep '2g'| cut -d'.' -f2 | awk '{ print $1 }'`
WIFI_C=`uci show wireless | grep '5g'| cut -d'.' -f2 | awk '{ print $2 }'`
WIFI_D=`uci show wireless | grep '2g'| cut -d'.' -f2 | awk '{ print $2 }'`
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
  echo -e " \033[1;37mシステム初期設定を開始します\033[0;39m"
  echo -e " \033[1;34m・デバイスのホストネーム\033[0;39m"
  echo -e " \033[1;33m・デバイスのパスワード\033[0;39m"
  echo -e " \033[1;32m・Wi-Fi${WIFI_NO_A}のSSID\033[0;39m"
  echo -e " \033[1;35m・Wi-Fi${WIFI_NO_A}のパスワード\033[0;39m"
  echo -e " \033[1;31m・Wi-Fi${WIFI_NO_B}のSSID\033[0;39m"
  echo -e " \033[1;36m・Wi-Fi${WIFI_NO_B}のパスワード\033[0;39m"
  WIFI_DEVICE=`uci show wireless | grep 'wifi-device' | wc -l`
  WIFI_NO=3
  if [ "$WIFI_DEVICE" = "$WIFI_NO" ]; then
  echo -e " \033[1;37m・Wi-Fi${WIFI_NO_C}のSSID\033[0;39m"
  echo -e " \033[1;37m・Wi-Fi${WIFI_NO_C}のパスワード\033[0;39m"
  fi
  read -p " 開始します [y/n]:" num
  case "${num}" in
    "y" ) _func_HOSTNAME ;;
    "n" ) exit ;;
  esac
done


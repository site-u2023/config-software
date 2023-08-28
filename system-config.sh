#! /bin/sh


function _func_HOSTNAME
while :
do
  echo -e " \033[1;32mデバイスの名称を入力して下さい\033[0;39m"
  read -p " デバイスの名称: " input_str_SYSTEM_HOSTNAME
  read -p " 本当に宜しいですか? [y/n or e]: " num
  case "${num}" in
    "y" ) sed -i -e "s/HOSTNAME='openwrt'/HOSTNAME=${input_str_SYSTEM_HOSTNAME}/g" /etc/device.sh; _func_ROOT_PASSWD ;;
    "n" ) _func_HOSTNAME ;;
    "e" ) exit ;;
  esac
done

function _func_ROOT_PASSWD
while :
do
  echo -e " \033[1;31m${input_str_SYSTEM_HOSTNAME}のパスワードを入力して下さい\033[0;39m"
  read -p " ${input_str_SYSTEM_HOSTNAME}のパスワード: " input_str_ROOT_PASSWD
  read -p " 本当に宜しいですか? [y/n or e]: " num
  case "${num}" in
    "y" ) sed -i -e "s/ROOT_PASSWD/${input_str_ROOT_PASSWD}/g" /etc/device.sh; _func_WIFI_SSID_A ;;
    "n" ) _func_ROOT_PASSWD ;;
    "e" ) exit ;;
  esac
done

function _func_WIFI_SSID_A
while :
do
  echo -e " \033[1;32mWi-FiのSSID Aを入力して下さい\033[0;39m"
  read -p " Wi-FiのSSID A: " input_str_WIFI_SSID_A
  read -p " 本当に宜しいですか? [y/n or e]: " num
  case "${num}" in
    "y" ) sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/device.sh; _func_WIFI_PASSWD_A ;;
    "n" ) _func_WIFI_SSID_A ;;
    "e" ) exit ;;
  esac
done

function _func_WIFI_PASSWD_A
while :
do
  echo -e " \033[1;33mWi-Fi Aのパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi Aのパスワード: " input_str_WIFI_PASSWD_A
  read -p " 本当に宜しいですか? [y/n or e]: " num
  case "${num}" in
    "y" ) sed -i -e "s/wifi_PASSWORD_A='password'/wifi_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/device.sh; _func_WIFI_SSID_B ;;
    "n" ) _func_WIFI_PASSWD_A ;;
    "e" ) exit ;;
  esac
done

function _func_WIFI_SSID_B
while :
do
  echo -e " \033[1;32mWi-FiのSSID Bを入力して下さい\033[0;39m"
  read -p " Wi-FiのSSID B: " input_str_WIFI_SSID_B
  read -p " 本当に宜しいですか? [y/n or e]: " num
  case "${num}" in
    "y" ) sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/device.sh; _func_WIFI_PASSWD_B ;;
    "n" ) _func_WIFI_SSID_B ;;
    "e" ) exit ;;
  esac
done

function _func_WIFI_PASSWD_B
while :
do
  echo -e " \033[1;33mWi-Fi Bのパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi Bのパスワード: " input_str_WIFI_PASSWD_B
  read -p " 本当に宜しいですか? [y/n or e]: " num
  case "${num}" in
    "y" ) sed -i -e "s/wifi_PASSWORD_B='password'/wifi_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" /etc/device.sh;
          sh /etc/device-config.sh;
          read -p " 何かキーを押すと${input_str_SYSTEM_HOSTNAME}が再起動します";
          reboot ;;
    "n" ) _func_WIFI_PASSWD_B ;;
    "e" ) exit ;;
  esac
done

while :
do
  echo -e " \033[1;37mシステム初期設定を開始します\033[0;39m"
  read -p " 開始します [y/n]:" num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/device-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/device.sh;
          _func_HOSTNAME ;;
    "n" ) exit ;;
  esac
done
exit

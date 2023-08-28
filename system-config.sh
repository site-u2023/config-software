#! /bin/sh

function _func_HOSTNAME
while :
do
  echo -e " \033[1;32mデバイスの名称を入力して下さい\033[0;39m"
  read -p " デバイスの名称: " input_str_SYSTEM_HOSTNAME
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_ROOT_PASSWD ;;
    "n" ) _func_HOSTNAME ;;
    "r" ) exit ;;
  esac
done

function _func_ROOT_PASSWD
while :
do
  echo -e " \033[1;31m${input_str_SYSTEM_HOSTNAME}のパスワードを入力して下さい\033[0;39m"
  read -p " デバイスのパスワード: " input_str_ROOT_PASSWD
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_A ;;
    "n" ) _func_ROOT_PASSWD ;;
    "r" ) exit ;;
  esac
done

function _func_WIFI_SSID_A
while :
do
  echo -e " \033[1;32mWi-FiのSSID Aを入力して下さい\033[0;39m"
  read -p " Wi-Fi A のSSID: " input_str_WIFI_SSID_A
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_A ;;
    "n" ) _func_WIFI_SSID_A ;;
    "r" ) exit ;;
  esac
done

function _func_WIFI_PASSWD_A
while :
do
  echo -e " \033[1;33mWi-Fi Aのパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi A のパスワード: " input_str_WIFI_PASSWD_A
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_B ;;
    "n" ) _func_WIFI_PASSWD_A ;;
    "r" ) exit ;;
  esac
done

function _func_WIFI_SSID_B
while :
do
  echo -e " \033[1;32mWi-FiのSSID Bを入力して下さい\033[0;39m"
  read -p " Wi-Fi B のSSID: " input_str_WIFI_SSID_B
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_B ;;
    "n" ) _func_WIFI_SSID_B ;;
    "r" ) exit ;;
  esac
done

function _func_WIFI_PASSWD_B
while :
do
  echo -e " \033[1;33mWi-Fi Bのパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi B のパスワード: " input_str_WIFI_PASSWD_B
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DEVICE_confirmation ;;
    "n" ) _func_WIFI_PASSWD_B ;;
    "r" ) exit ;;
  esac
done

function _func_DEVICE_confirmation
while :
do
  echo -e " \033[1;37mシステム設定 --------------------------------------------------\033[0;39m"
  echo -e " \033[1;37m デバイス の名称: ${input_str_SYSTEM_HOSTNAME}\033[0;39m"
  echo -e " \033[1;37m デバイス のパスワード: ${input_str_ROOT_PASSWD}\033[0;39m"
  echo -e " \033[1;37m Wi-Fi A のSSID: ${input_str_WIFI_SSID_A}\033[0;39m"
  echo -e " \033[1;37m Wi-Fi A のパスワード: ${input_str_WIFI_PASSWD_A}\033[0;39m"
  echo -e " \033[1;37m Wi-Fi B のSSID: ${input_str_WIFI_SSID_B}\033[0;39m"
  echo -e " \033[1;37m Wi-Fi B のパスワード: ${input_str_WIFI_PASSWD_B}\033[0;39m"
  echo -e " \033[1;37m---------------------------------------------------------------\033[0;39m"
  read -p " これで宜しければ設定を開始します [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DEVICE_SET ;; 
    "n" ) _func_HOSTNAME ;;
    "r" ) exit ;;
  esac
done

function _func_DEVICE_SET
{
  wget --no-check-certificate -O /etc/device.sh https://raw.githubusercontent.com/site-u2023/config-software/main/device.sh;
  sed -i -e "s/HOSTNAME='openwrt'/HOSTNAME=${input_str_SYSTEM_HOSTNAME}/g" /etc/device.sh; _func_ROOT_PASSWD;
  sed -i -e "s/ROOT_PASSWD/${input_str_ROOT_PASSWD}/g" /etc/device.sh;
  sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/device.sh;
  sed -i -e "s/wifi_PASSWORD_A='password'/wifi_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/device.sh;
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/device.sh;
  sed -i -e "s/wifi_PASSWORD_B='password'/wifi_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" /etc/device.sh;     
  sh /etc/device.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
}

while :
do
  echo -e " \033[1;37mシステム初期設定を開始します\033[0;39m"
  read -p " 開始します [y/n]:" num
  case "${num}" in
    "y" ) _func_HOSTNAME ;;
    "n" ) exit ;;
  esac
done
exit

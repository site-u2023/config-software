#! /bin/sh

function _func_HOSTNAME
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

function _func_ROOT_PASSWD
while :
do
  echo -e " \033[1;34mデバイスのパスワードを入力して下さい\033[0;39m"
  read -p " デバイスのパスワード: " input_str_ROOT_PASSWD
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_A ;;
    "n" ) _func_ROOT_PASSWD ;;
    "r" ) break ;;
  esac
done

function _func_WIFI_SSID_A
while :
do
  echo -e " \033[1;32mWi-Fi(wwan0)のSSIDを入力して下さい\033[0;39m"
  read -p " Wi-Fi(wwan0)のSSID: " input_str_WIFI_SSID_A
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_A ;;
    "n" ) _func_WIFI_SSID_A ;;
    "r" ) break ;;
  esac
done

function _func_WIFI_PASSWD_A
while :
do
  echo -e " \033[1;32mWi-Fi(wwan0)のパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi(wwan0)のパスワード: " input_str_WIFI_PASSWD_A
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SSID_B ;;
    "n" ) _func_WIFI_PASSWD_A ;;
    "r" ) break ;;
  esac
done

function _func_WIFI_SSID_B
while :
do
  echo -e " \033[1;32mWi-Fi(wwan1)のSSIDを入力して下さい\033[0;39m"
  read -p " Wi-Fi(wwan1)のSSID: " input_str_WIFI_SSID_B
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_B ;;
    "n" ) _func_WIFI_SSID_B ;;
    "r" ) break ;;
  esac
done

function _func_WIFI_PASSWD_B
while :
do
  echo -e " \033[1;32mWi-Fi(wwan1)のパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi(wwan1)のパスワード: " input_str_WIFI_PASSWD_B
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_SEARCH ;;
    "n" ) _func_WIFI_PASSWD_B ;;
    "r" ) break ;;
  esac
done

function _func_WIFI_SEARCH
{
WIFI_DEVICE=`fgrep 'wifi-device' /etc/config/wireless | wc -l`
WIFI_NO=3
    if [ "$WIFI_DEVICE" = "$WIFI_NO" ]
    then
     _func_WIFI_SSID_C
    else
     _func_DEVICE_confirmation
    fi
}

function _func_WIFI_SSID_C
while :
do
  echo -e " \033[1;35mWi-Fi(wwan2)のSSIDを入力して下さい\033[0;39m"
  read -p " Wi-Fi(wwan2)のSSID: " input_str_WIFI_SSID_C
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_WIFI_PASSWD_C ;;
    "n" ) _func_WIFI_SSID_C ;;
    "r" ) break ;;
  esac
done

function _func_WIFI_PASSWD_C
while :
do
  echo -e " \033[1;35mWi-Fi(wwan2)のパスワードを入力して下さい\033[0;39m"
  read -p " Wi-Fi(wwan2)のパスワード: " input_str_WIFI_PASSWD_C
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DEVICE_confirmation ;;
    "n" ) _func_WIFI_PASSWD_C ;;
    "r" ) break ;;
  esac
done

function _func_DEVICE_confirmation
while :
do 
  echo -e " \033[1;37mシステム設定 --------------------------------------------------\033[0;39m"
  echo -e " \033[1;34mデバイスのホストネーム: ${input_str_SYSTEM_HOSTNAME}\033[0;39m"
  echo -e " \033[1;34mデバイスのパスワード: ${input_str_ROOT_PASSWD}\033[0;39m"
  echo -e " \033[1;32mWi-Fi(wwan0)のSSID: ${input_str_WIFI_SSID_A}\033[0;39m"
  echo -e " \033[1;32mWi-Fi(wwan0)のパスワード: ${input_str_WIFI_PASSWD_A}\033[0;39m"
  echo -e " \033[1;32mWi-Fi(wwan1)のSSID: ${input_str_WIFI_SSID_B}\033[0;39m"
  echo -e " \033[1;32mWi-Fi(wwan1)のパスワード: ${input_str_WIFI_PASSWD_B}\033[0;39m"
   if [ "$WIFI_DEVICE" = "$WIFI_NO" ]
    then
  echo -e " \033[1;35mWi-Fi(wwan2)のSSID: ${input_str_WIFI_SSID_C}\033[0;39m"
  echo -e " \033[1;35mWi-Fi(wwan2)のパスワード: ${input_str_WIFI_PASSWD_C}\033[0;39m"
   fi
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
  wget --no-check-certificate -O /etc/system.sh https://raw.githubusercontent.com/site-u2023/config-software/main/system.sh
  sed -i -e "s/HOSTNAME='openwrt'/HOSTNAME=${input_str_SYSTEM_HOSTNAME}/g" /etc/system.sh
  sed -i -e "s/ROOT_PASSWD/${input_str_ROOT_PASSWD}/g" /etc/system.sh
  sed -i -e "s/WIFI_SSID_A='SSID_A'/WIFI_SSID_A=${input_str_WIFI_SSID_A}/g" /etc/system.sh
  sed -i -e "s/wifi_PASSWORD_A='password'/wifi_PASSWORD_A=${input_str_WIFI_PASSWD_A}/g" /etc/system.sh
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_B}/g" /etc/system.sh
  sed -i -e "s/wifi_PASSWORD_B='password'/wifi_PASSWORD_B=${input_str_WIFI_PASSWD_B}/g" //etc/system.sh  
  sed -i -e "s/WIFI_SSID_B='SSID_B'/WIFI_SSID_B=${input_str_WIFI_SSID_C}/g" /etc/system.sh
  sed -i -e "s/wifi_PASSWORD_B='password'/wifi_PASSWORD_B=${input_str_WIFI_PASSWD_C}/g" //etc/system.sh  
  sh /etc/system.sh 2> /dev/null
  read -p " 何かキーを押してデバイスを再起動してください"
  reboot
  exit
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


#! /bin/sh
# OpenWrt >= 21.02:


function _func_button_INST {
while :
do
  echo -e " \033[1;34mボタン設定とインストール（WPSボタン用）のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/button.sh https://raw.githubusercontent.com/site-u2023/config-software/main/button.sh
          sh /etc/config-software/button.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_button_investigation {
while :
do
echo -e " \033[1;32mボタン設定とインストールのスクリプトをダウンロードします\033[0;39m"
echo -e " \033[1;33m調査の為ボタン設定とインストールが先に必要です\033[0;39m"
read -p " 宜しいですか? [y/n]: " num
case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/button.sh https://raw.githubusercontent.com/site-u2023/config-software/main/button.sh
          sed -i -e "s/wps/${str_BUTTON}/g" /etc/config-software/button.sh
          sh /etc/config-software/button.sh
          break ;;
    "n" ) break ;;
  esac
done
echo -e " \033[1;37mボタン調査を開始します\033[0;39m"
echo -e " \033[1;37m利用可能ボタン\033[0;39m"
ls /etc/rc.button/
echo -e ""
echo -e " \033[1;32m`uname -n`\033[0;39m"の利用したいボタンを押して離して下さい
echo -e ""
read -p " ボタンを押して放したら何かキーを押して下さい"
str=`ls /etc/rc.button/`
str_BUTTON=`logread | tail -n 1  | grep button | awk '{ print $11 }'`
if [ -z "$str_BUTTON" ]; then
echo -e " \033[1;33mボタンを押して放していないか該当ボタンがありません\033[0;39m"
read -p " 何かキーを押して終了して下さい"
exit
fi
case $str in
  *"$str_BUTTON"*)
    echo -e " \033[1;32m${str_BUTTON}\033[0;39m"が調査したボタンです
    echo -e " \033[1;32m${str_BUTTON}\033[0;39m"を設定します
    ;;
esac
}

function _func_button_REMOVE {
while :
do
  echo -e " \033[1;31mボタン設定をリムーブし以前の設定に復元します\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
   case "${num}" in
    "y" ) opkg remove kmod-button-hotplug
          cp /etc/config/system.button.bak /etc/config/system
          rm /etc/config/system.button.bak
          rm /etc/hotplug.d/button/buttons
          rm /etc/hotplug.d/button/00-button
          rm /usr/bin/wifionoff
          break ;;
    "n" ) break ;;
  esac
done
}

OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;32mバージョンチェック: OK\033[0;39m"
else
 read -p " バージョンが違う為終了します"
 exit
fi

while :
do
  echo -e " \033[1;37mbutton-config ----------------------------------------\033[0;39m"
  echo -e " \033[1;34m[w]\033[0;39m": ボタン設定とインストール（wpsボタン用）
  echo -e " \033[1;32m[c]\033[0;39m": ボタン設定とインストール後該当ボタン調査再設定
  echo -e " \033[1;31m[r]\033[0;39m": ボタン設定をリムーブし以前の設定に復元
  echo -e " \033[1;37m[q]\033[0;39m": 終了
  echo -e " \033[1;37m------------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [w/c/r or q]: " num 
  case "${num}" in
    "w" ) _func_button_INST ;;
    "c" ) _func_button_investigation ;;
    "r" ) _func_button_REMOVE ;;
    "q" ) exit ;;
  esac
done

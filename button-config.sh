#! /bin/sh
# OpenWrt >= 21.02:


function _func_button_INST {
while :
do
  echo -e " \033[1;3ボタン設定とインストール（WPSボタン用）のスクリプトをダウンロードします\033[0;39m"
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
  echo -e " \033[1;32mボタン調査を開始します\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) ls /etc/rc.button/
          

          break ;;
    "n" ) break ;;
  esac
done
}

function _func_button_REMOVE {
while :
do
  echo -e " \033[1;32mボタン設定をリムーブし以前の設定に復元します\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) opkg remove kmod-button-hotplug
          cp /etc/config/system.button.bak /etc/config/system
          rm /etc/config/system.button.bak
          rm /etc/hotplug.d/button/buttons
          rm /etc/hotplug.d/button/00-button
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
  echo -e " \033[1;37mインストールは失敗する事があります\033[0;39m"
  echo -e " \033[1;34mpackage-config ---------------------------------------\033[0;39m"
  echo -e " \033[1;32m[w]\033[0;39m": ボタン設定とインストール（WPSボタン用）
  echo -e " \033[1;31m[c]\033[0;39m": ボタン調査
  echo -e " \033[1;32m[r]\033[0;39m": ボタン設定をリムーブし以前の設定に復元
  echo -e " \033[1;37m[q]\033[0;39m": 終了
  echo -e " \033[1;37m------------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [f/c or q]: " num 
  case "${num}" in
    "w" ) _func_button_INST ;;
    "c" ) _func_button_investigation ;;
    "r" ) _func_button_REMOVE ;;
    "q" ) exit ;;
  esac
done

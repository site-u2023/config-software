#! /bin/sh
# OpenWrt >= 21.02:


function _func_button_INST {
while :
do
  echo -e " \033[1;34mボタン（スイッチ）設定とインストール（WPSボタン用）のスクリプトをダウンロードします\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/button.sh https://raw.githubusercontent.com/site-u2023/config-software/main/button.sh
          sh /etc/config-software/button.sh ;;
    "n" ) exit;;
  esac
done
}

function _func_button_investigation {
echo -e " \033[1;32m参考URL: https://openwrt.org/docs/guide-user/hardware/hardware.button#examples\033[0;39m"
mkdir -p /etc/hotplug.d/button
cat << "EOF" > /etc/hotplug.d/button/buttons
logger "the button was ${BUTTON} and the action was ${ACTION}"
EOF
echo -e " \033[1;37mボタン（スイッチ）調査を開始します\033[0;39m"
echo -e " \033[1;32m`uname -n`\033[0;39m"の利用したいボタン（スイッチ）を押して離して下さい
echo -e ""
read -p " ボタン（スイッチ）を押して放し（切替）何かキーを押して下さい"
str_BUTTON=`logread | tail -n 1  | grep button | awk '{ print $11 }'`
str_ACTION=`logread | tail -n 1  | grep button | awk '{ print $16 }'`
if [ -z "$str_BUTTON" ]; then
echo -e " \033[1;33mボタン（スイッチ）を押して放していない、または非対応ボタン（スイッチ）です\033[0;39m"
read -p " Please any key"
exit
fi
echo -e " \033[1;35m${str_BUTTON}\033[0;39m"が調査したボタン（スイッチ）です
echo -e " \033[1;35m${str_ACTION}\033[0;39m"が調査したアクションです
read -p " Please any key"
_func_HANDLER
}

function _func_HANDLER {
while :
do
  echo -e "\033[1;37m 操作したいコマンドを入力下さい\033[0;39m"
  echo -e "\033[1;33m 例: reboot\033[0;39m"
  read -p " コマンド: " str_HANDLER
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MIN ;;
    "n" ) _func_HANDLER ;;
    "r" ) break ;;
  esac
done
}

function _func_MIN {
while :
do
  echo -e "\033[1;37m ボタン操作の最小受付時間を入力下さい\033[0;39m"
  echo -e "\033[1;33m 例: 0\033[0;39m"
  read -p " 最小時間（秒）: " str_MIN
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MAX ;;
    "n" ) _func_MIN ;;
    "r" ) break ;;
  esac
done
}

function _func_MAX {
while :
do
  echo -e "\033[1;37m ボタン操作の最大受付時間を入力下さい\033[0;39m"
  echo -e "\033[1;33m 例: 10\033[0;39m"
  read -p " 最大時間（秒）: " str_MAX
  read -p " Please select key[y/n or r]: " num
  case "${num}" in
    "y" ) _func_SET ;;
    "n" ) _func_MAX ;;
    "r" ) break ;;
  esac
done
}

function _func_SET {
while :
do
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  echo -e " \033[1;35mボタン（スイッチ）名: ${str_BUTTON}\033[0;39m"
  echo -e " \033[1;35mアクション: ${str_ACTION}\033[0;39m"
  echo -e " \033[1;32mコマンド: ${str_HANDLER}\033[0;39m"
  echo -e " \033[1;32m最小受付時間（秒）: ${str_MIN}\033[0;39m"
  echo -e " \033[1;32m最大受付時間（秒）: ${str_MAX}\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_INST ;;
    "n" ) _func_button_investigation ;;
    "r" ) break ;;
  esac
done
}

function _func_INST {
wget --no-check-certificate -O /etc/config-software/button2.sh https://raw.githubusercontent.com/site-u2023/config-software/main/button2.sh
sed -i -e "s/BUTTON='wps'/BUTTON='${str_BUTTON}'/g" /etc/config-software/button2.sh
sed -i -e "s/ACTION='released'/ACTION='${str_ACTION}'/g" /etc/config-software/button2.sh
sed -i -e "s/HANDLER='reboot'/HANDLER='${str_HANDLER}'/g" /etc/config-software/button2.sh
sed -i -e "s/MIN='0'/MIN='${str_MIN}'/g" /etc/config-software/button2.sh
sed -i -e "s/MAX='10'/MAX='${str_MAX}'/g" /etc/config-software/button2.sh
sh /etc/config-software/button2.sh
}

function _func_button_REMOVE {
while :
do
  echo -e " \033[1;31mボタン（スイッチ）設定をリムーブし以前の設定に復元します\033[0;39m"
  read -p " Please select key [y/n]: " num
   case "${num}" in
    "y" ) opkg remove kmod-button-hotplug
          cp /etc/config/system.button.bak /etc/config/system
          rm -f /etc/config/system.button.bak
          rm -f /etc/config/system.button2.bak
          rm -f /etc/hotplug.d/button/butons
          rm -f /etc/hotplug.d/button/00-button
          rm -f /usr/bin/wifionoff
          echo -e " \033[1;36mボタン（スイッチ）設定を以前の設定に復元しリムーブが完了しました\033[0;39m"
          read -p " Press any key (to reboot the device)"
          reboot ;;
    "n" ) break ;;
  esac
done
}

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "19" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
 else
   read -p " Exit due to different versions"
 exit
fi

while :
do
  echo -e " \033[1;37mbutton-config ----------------------------------------\033[0;39m"
  echo -e " \033[1;34m[w]: ボタン（スイッチ）設定とインストール（wpsボタン用）\033[0;39m"
  echo -e " \033[1;32m[c]: ボタン（スイッチ）調査後ボタンとスイッチとインストール（カスタム）\033[0;39m"
  echo -e " \033[1;31m[r]: ボタン設定をリムーブし以前の設定に復元\033[0;39m"
  echo -e " \033[1;37m[q]: 終了\033[0;39m"
  echo -e " \033[1;37m------------------------------------------------------\033[0;39m"
  read -p " Please select key [w/c/r or q]: " num 
  case "${num}" in
    "w" ) _func_button_INST ;;
    "c" ) _func_button_investigation ;;
    "r" ) _func_button_REMOVE ;;
    "q" ) exit ;;
  esac
done

#! /bin/sh
# OpenWrt >= 21.02:

function _func_button_INSTALL {
cp /etc/config/system /etc/config/system.button2.bak

# install
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
opkg install kmod-button-hotplug

mkdir -p /etc/hotplug.d/button
# 00-button
cat << "EOF" > /etc/hotplug.d/button/00-button
source /lib/functions.sh
 
do_button () {
    local button
    local action
    local handler
    local min
    local max
 
    config_get button "${1}" button
    config_get action "${1}" action
    config_get handler "${1}" handler
    config_get min "${1}" min
    config_get max "${1}" max
 
    [ "${ACTION}" = "${action}" -a "${BUTTON}" = "${button}" -a -n "${handler}" ] && {
        [ -z "${min}" -o -z "${max}" ] && eval ${handler}
        [ -n "${min}" -a -n "${max}" ] && {
            [ "${min}" -le "${SEEN}" -a "${max}" -ge "${SEEN}" ] && eval ${handler}
        }
    }
}
 
config_load system
config_foreach do_button button
EOF

BUTTON='wps'
ACTION='released'
HANDLER='reboot'
MIN='0'
MAX='10'
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action=${ACTION}
uci set system.@button[-1].handler=${HANDLER}
uci set system.@button[-1].min=${MIN}
uci set system.@button[-1].max=${MAX}

# set
uci commit system

echo -e " \033[1;36mインストールと設定が完了しました\033[0;39m"
read -p " 何かキーを押してデバイスを再起動してください"
reboot

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
  read -p " ボタン設定とインストール（カスタム）を開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_button_INSTALL ;;
    "n" ) exit ;;
  esac
done

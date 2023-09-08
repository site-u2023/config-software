#! /bin/sh
# OpenWrt >= 21.02:

function _func_button_INSTALL {
cp /etc/config/system /etc/config/system.button.bak

# install
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
opkg install kmod-button-hotplug

mkdir -p /etc/hotplug.d/button
# log調査用
cat << "EOF" > /etc/hotplug.d/button/buttons
logger "the button was ${BUTTON} and the action was ${ACTION}"
EOF
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

BUTTON='wps' # AOSS BUTTON
# WiFi ON ワンプッシュボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="/usr/bin/wifionoff"
uci set system.@button[-1].min="0"
uci set system.@button[-1].max="2"
uci commit system
 
cat << "EOF" > /usr/bin/wifionoff
#!/bin/sh
[ "${BUTTON}" = "wps" ] && [ "${ACTION}" = "released" ] && {
    SW="$(uci -q get wireless.@wifi-device[0].disabled)"
    [ "${SW}" = "1" ] \
        && uci set wireless.@wifi-device[0].disabled='0'; uci set wireless.@wifi-device[1].disabled='0' \
        || uci set wireless.@wifi-device[0].disabled='1'; uci set wireless.@wifi-device[0].disabled='1'
    wifi
}
EOF
chmod 755 /usr/bin/wifionoff

wireless.default_radio1.disabled='1'
uci delete wireless.radio0.disabled
uci delete wireless.radio1.disabled

# USBストレージアンマウント 3～7秒 ボタンリリース
if [ -n "$str_USB" ]; then
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="for i in \$(mount | awk '/dev\/sd[b-z]/{print \$1}'); do umount \${i}; done"
uci set system.@button[-1].min="3"
uci set system.@button[-1].max="7"
uci commit system
fi

# restart 7～13秒 ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="reboot"
uci set system.@button[-1].min="8"
uci set system.@button[-1].max="13"

# 初期化 17～23秒 ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="firstboot && reboot now"
uci set system.@button[-1].min="18"
uci set system.@button[-1].max="23"

# set
uci commit system

echo -e " \033[1;36mインストールが完了しました\033[0;39m"
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
  echo -e " \033[1;32m 1秒\033[0;39m" Wi-Fiオン・オフ ボタンリリース
  str_USB=`dmesg | grep -s usb`
  if [ -n "$str_USB" ]; then
  echo -e " \033[1;32m 5秒\033[0;39m" USBストレージアンマウント ボタンリリース
  fi
  echo -e " \033[1;33m10秒\033[0;39m" デバイス再起動 ボタンリリース
  echo -e " \033[1;31m20秒\033[0;39m" デバイス初期化 ボタンリリース
  read -p " ボタン設定とインストール（wpsボタン）を開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_button_INSTALL ;;
    "n" ) exit ;;
  esac
done

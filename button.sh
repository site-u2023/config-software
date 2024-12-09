#! /bin/sh
# OpenWrt >= 21.02:

function _func_button_INSTALL {
cp /etc/config/system /etc/config/system.button.bak

# install
if [ -e ${UPDATE} ]; then
opkg update
UPDATE="1"
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

BUTTON='wps' # AOSS BUTTON
# WiFi ON ワンプッシュボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action='released'
uci set system.@button[-1].handler='/usr/bin/wifionoff'
uci set system.@button[-1].min='0'
uci set system.@button[-1].max='2'

cat << "EOF" > /usr/bin/wifionoff
#!/bin/sh
[ "${BUTTON}" = "wps" ] && [ "${ACTION}" = "released" ] && {
    SW="$(uci -q get wireless.@wifi-device[0].disabled)"
    [ "${SW}" = "1" ] \
        && uci set wireless.@wifi-device[0].disabled='0' \
        || uci set wireless.@wifi-device[0].disabled='1'
}

[ "${BUTTON}" = "wps" ] && [ "${ACTION}" = "released" ] && {
    SW="$(uci -q get wireless.@wifi-device[1].disabled)"
    [ "${SW}" = "1" ] \
        && uci set wireless.@wifi-device[1].disabled='0' \
        || uci set wireless.@wifi-device[1].disabled='1'
}
    uci commit wireless; /etc/init.d/network restart
EOF
chmod 755 /usr/bin/wifionoff
WIFI_DEVICE=`fgrep 'wifi-device' /etc/config/wireless | wc -l`
WIFI_NO='3'
if [ "$WIFI_DEVICE" = "$WIFI_NO" ]; then
sed -i "/uci commit wireless/d" /usr/bin/wifionoff
cat << "EOF" >> /usr/bin/wifionoff

[ "${BUTTON}" = "wps" ] && [ "${ACTION}" = "released" ] && {
    SW="$(uci -q get wireless.@wifi-device[2].disabled)"
    [ "${SW}" = "1" ] \
        && uci set wireless.@wifi-device[2].disabled='0' \
        || uci set wireless.@wifi-device[2].disabled='1'
}
    uci commit wireless; /etc/init.d/network restart
EOF
fi

# USBストレージアンマウント 3～7秒 ボタンリリース
if [ -n "$str_USB" ]; then
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action='released'
uci set system.@button[-1].handler="for i in \$(mount | awk '/dev\/sd[b-z]/{print \$1}'); do umount \${i}; done"
uci set system.@button[-1].min='3'
uci set system.@button[-1].max='7'
fi

# restart 7～13秒 ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action='released'
uci set system.@button[-1].handler='reboot'
uci set system.@button[-1].min='8'
uci set system.@button[-1].max='13'

# 初期化 17～23秒 ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action='released'
uci set system.@button[-1].handler="firstboot && reboot now"
uci set system.@button[-1].min='18'
uci set system.@button[-1].max='23'

# set
uci commit system

read -p " Press any key (to reboot the device)"
reboot

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
  echo -e " \033[1;32m 1秒 Wi-Fiオン・オフ ボタン（スイッチ）リリース\033[0;39m"
  str_USB=`dmesg | grep -s usb`
  if [ -n "$str_USB" ]; then
  echo -e " \033[1;32m 5秒 USBストレージアンマウント ボタン（スイッチ）リリース\033[0;39m"
  fi
  echo -e " \033[1;33m10秒 デバイス再起動 ボタン（スイッチ）リリース\033[0;39m"
  echo -e " \033[1;31m20秒 デバイス初期化 ボタン（スイッチ）リリース\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) _func_button_INSTALL ;;
    "n" ) exit ;;
  esac
done

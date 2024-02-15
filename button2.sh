#! /bin/sh
# OpenWrt >= 21.02:

function _func_button_INSTALL {
cp /etc/config/system /etc/config/system.button2.bak

# install
UPDATE="/tmp/opkg-lists/openwrt_telephony"
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

read -p " Press any key (to reboot the device)"
reboot

}

OPENWRT_RELEAS=`cat /etc/banner | grep OpenWrt | awk '{ print $2 }' | cut -c 1-2`
if [ "${OPENWRT_RELEAS}" = "23" ] || [ "${OPENWRT_RELEAS}" = "22" ] || [ "${OPENWRT_RELEAS}" = "21" ] || [ "${OPENWRT_RELEAS}" = "SN" ]; then
 echo -e " \033[1;37mversion check: OK\033[0;39m"
 else
 read -p " Different version"
 exit
fi

while :
do
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) _func_button_INSTALL ;;
    "n" ) exit ;;
  esac
done

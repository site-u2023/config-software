#! /bin/sh
# OpenWrt >= 21.02:

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


# WiFi ON ワンプッシュボタンリリース
BUTTON='wps' # AOSS BUTTON

# Toggle Wi-Fi using a script (ON-OFF) 0~3s release
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="/usr/bin/wifionoff"
uci set system.@button[-1].min="0"
uci set system.@button[-1].max="3"
uci commit system
 
cat << "EOF" > /usr/bin/wifionoff
#!/bin/sh
[ "${BUTTON}" = "BTN_1" ] && [ "${ACTION}" = "pressed" ] && {
    SW="$(uci -q get wireless.@wifi-device[0].disabled)"
    [ "${SW}" = "1" ] \
        && uci set wireless.@wifi-device[0].disabled="0" \
        || uci set wireless.@wifi-device[0].disabled="1"
    wifi
}
EOF
chmod u+x /usr/bin/wifionoff

# restart 7～13秒 ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="sleep 70 && touch /etc/banner && reboot"
uci set system.@button[-1].min="7"
uci set system.@button[-1].max="13"

# 初期化 17～23秒 ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="firstboot && reboot now"
uci set system.@button[-1].min="17"
uci set system.@button[-1].max="23"

# set
uci commit system
/etc/init.d/system reload



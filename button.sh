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

# WiFi ON 1秒ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="uci set wireless.radio0.disabled=0; uci set wireless.radio1.disabled=0; uci set wireless.radio2.disabled=0; uci commit; wifi"
uci set system.@button[-1].min="0"
uci set system.@button[-1].max="2"

# WiFi OFF 5秒ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="uci set wireless.radio0.disabled=1; uci set wireless.radio1.disabled=1; uci set wireless.radio2.disabled=1; uci commit; wifi"
uci set system.@button[-1].min="3"
uci set system.@button[-1].max="7"

# restart 10秒ボタンリリース
uci add system button
uci set system.@button[-1].button=${BUTTON}
uci set system.@button[-1].action="released"
uci set system.@button[-1].handler="sleep 70 && touch /etc/banner && reboot"
uci set system.@button[-1].min="8"
uci set system.@button[-1].max="15"
# set
uci commit system
/etc/init.d/system reload

#! /bin/sh
# # this script based https://github.com/NilsRo/Openwrt-radio-check
CHECK=$(iw dev phy0-ap0 info | awk '/channel/{print $2}')
if [ -z ${CHECK} ]; then
        printf "Wifi restart because of DFS bug!\n"
        wifi down radio0
        sleep 2
        wifi up radio0
else
        if [ $(uci get wireless.radio0.channel) -ne ${CHECK} ]; then
                printf "Wifi restart because of channel!\n"
                wifi down radio0
                sleep 2
                wifi up radio0
       fi
fi


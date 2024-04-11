#! /bin/sh
mkdir -p /etc/config-software
cat << "EOF" > /etc/config-software/dfs_check.sh
#! /bin/sh
# this script based  https://github.com/NilsRo/Openwrt-radio-check
RADIO=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
CHS=`echo ${RADIO} | wc -w`
if [ ${CHS} = 2 ];then
RADIO=`echo ${RADIO}| awk '{print $2}'`
fi
if [ ${RADIO} = "radio0" ]; then
CH="0"
fi
if [ ${RADIO} = "radio1" ]; then
CH="1"
fi
if [ ${RADIO} = "radio2" ]; then
CH="2"
fi
DEV=`iw dev | awk '/Interface/{print $2}' | grep ${CH}`
CHANNEL=$(iw dev ${DEV} info | awk '/channel/{print $2}')
if [ -z ${CHANNEL} ]; then
        printf "Wifi restart because of DFS bug!\n"
        wifi down ${RADIO}
        sleep 2
        wifi up ${RADIO}
else
        if [ $(uci get wireless.${RADIO}.channel) -ne ${CHANNEL} ]; then
                printf "Wifi restart because of channel!\n"
                wifi down ${RADIO}
                sleep 2
                wifi up ${RADIO}
       fi
fi
EOF
chmod +x /etc/config-software/dfs_check.sh


cat << "EOF" > /etc/init.d/dfs_check
#!/bin/sh /etc/rc.common

START=99
STOP=01
    
start() {
    sed -i "/dfs_check.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    logger "perimeter DFS Check ON"
    echo "*/15 * * * * sh /etc/config-software/dfs_check.sh # DFS Check ON" >> /etc/crontabs/root
    /etc/init.d/cron restart
    exit 0
}
restart() {
    exit 0
}
stop() {
    logger "perimeter DFS Check OFF"
    sed -i "/dfs_check.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    exit 0
}
EOF
chmod +x /etc/init.d/dfs_check

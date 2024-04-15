#! /bin/sh
RADIO=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
uci set wireless.${RADIO}.channels='36 40 44 48'
uci commit wireless
wifi reload ${RADIO}
mkdir -p /etc/config-software/
cat << "EOF" > /etc/config-software/dfs_check_new.sh
#! /bin/sh

DFS_CHANNEL="auto"
DFS_BAND="40"

read INTERVAL < /tmp/config-software/interval.txt
SCHEDULE=`expr $((${INTERVAL} * 121))`
RADIO=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
CHS=`echo ${RADIO} | wc -w`
if [ ${CHS} = 2 ];then
    RADIO=`echo ${RADIO}| awk '{print $2}'`
fi
echo `uci get wireless.${RADIO}.channel` >> /tmp/config-software/channel.txt
echo `uci get wireless.${RADIO}.htmode` >> /tmp/config-software/htmode.txt
read CHANNEL < /tmp/config-software/channel.txt
read HTMODE < /tmp/config-software/htmode.txt
MODE=`echo ${HTMODE} | grep -o "[A-Z]*"`
BAND=`echo ${HTMODE} | grep -o "[0-9]*"`
CH=`echo ${RADIO} | grep -o "[0-9]*"`
DEV=`iw dev | awk '/Interface/{print $2}' | grep ${CH}`
IW_CHANNEL=$(iw dev ${DEV} info | awk '/channel/{print $2}')
if [ -z ${IW_CHANNEL} ]; then
    printf "Wifi restart because of DFS bug!\n"
    wifi reload ${RADIO}
else
    if [ $(uci get wireless.${RADIO}.channel) -ne ${CHANNEL} ] || [ $(uci get wireless.${RADIO}.htmode) = ${HTMODE} ]; then
        printf "Wifi restart because of channel!\n"
        wifi reload ${RADIO}
    fi
fi
DATE=`date '+%H:%M:%S'`
DATE=`date +%s -d ${DATE}`
DATE_DISABLED=`exec logread | grep "DFS->DISABLED" | tail -n 1 | awk '{ print $4 }'`
DATE_DISABLED=`date +%s -d ${DATE_DISABLED}` 2> /dev/null
DATE_ENABLED=`exec logread | grep "DFS->ENABLED" | tail -n 1 | awk '{ print $4 }'`
DATE_ENABLED=`date +%s -d ${DATE_ENABLED}` 2> /dev/null
if [ -n "$DATE_DISABLED" ] && [ -z "$DATE_ENABLED" ]; then
    TIME=`expr $((${DATE} - ${DATE_DISABLED}))`
	if [ ${TIME} -lt ${SCHEDULE} ]; then
        printf "Wifi channel change because of DFS ON!\n"
        uci set wireless.${RADIO}.channel=${DFS_CHANNEL}
        uci set wireless.${RADIO}.htmode=${MODE}${DFS_BAND}
        uci commit wireless
        wifi reload ${RADIO}
        exit 0
	fi
fi
if [ -n "$DATE_DISABLED" ] && [ -n "$DATE_ENABLED" ]; then
    if [ "$DATE_DISABLED" -lt "$DATE_ENABLED" ]; then
        TIME=`expr $((${DATE} - ${DATE_ENABLED}))`
    	if [ ${TIME} -lt ${SCHEDULE} ]; then
            printf "Wifi channel recovery because of DFS OFF!\n"
            uci set wireless.${RADIO}.channel=${CHANNEL}
            uci set wireless.${RADIO}.htmode=${MODE}${BAND}
            uci commit wireless
            wifi reload ${RADIO}
            exit 0
        fi
    else
        if [ "$DATE_ENABLED" -lt "$DATE_DISABLED" ]; then
            TIME=`expr $((${DATE} - ${DATE_DISABLED}))`
        	if [ ${TIME} -lt ${SCHEDULE} ]; then
                printf "Wifi channel change because of DFS ON!\n"
                uci set wireless.${RADIO}.channel=${DFS_CHANNEL}
                uci set wireless.${RADIO}.htmode=${MODE}${DFS_BAND}
                uci commit wireless
                wifi reload ${RADIO}
                exit 0
            fi
        fi
    fi
fi
if [ -n "$DATE_ENABLED" ]; then
    TIME=`expr $((${DATE} - ${DATE_ENABLED}))`
    if [ ${TIME} -lt ${SCHEDULE} ]; then
        printf "Wifi channel recovery because of DFS OFF!\n"
        uci set wireless.${RADIO}.channel=${CHANNEL}
        uci set wireless.${RADIO}.htmode=${MODE}${BAND}
        uci commit wireless
        wifi reload ${RADIO}
        exit 0
    fi
fi
EOF
chmod +x /etc/config-software/dfs_check_new.sh


cat << "EOF" > /etc/init.d/dfs_check_new
#!/bin/sh /etc/rc.common

INTERVAL="5" # DFS check interval (minutes)
    
START=99
STOP=01
    
start() {
    logger "perimeter DFS Check ON"
    sed -i "/dfs_check_new.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    echo "*/${INTERVAL} * * * * sh /etc/config-software/dfs_check_new.sh # DFS Check NEW ON" >> /etc/crontabs/root
    mkdir -p /tmp/config-software/
    echo ${INTERVAL} > /tmp/config-software/interval.txt
    /etc/init.d/cron restart
    exit 0
}
restart() {
    exit 0
}
stop() {
    logger "perimeter DFS Check NEW OFF"
    sed -i "/dfs_check_new.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    rm -rf /tmp/config-software
    exit 0
}
EOF
chmod +x /etc/init.d/dfs_check_new

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
    logger "DFS Check NEW:bug"
    wifi reload ${RADIO}
else
    if [ $(uci get wireless.${RADIO}.channel) -ne ${CHANNEL} ] || [ $(uci get wireless.${RADIO}.htmode) != ${HTMODE} ]; then
        logger "DFS Check NEW:verification"
        wifi reload ${RADIO}
    fi
fi
DATE=`date +%s`
DATE_DISABLE=`exec logread | grep "DFS->DISABLED" | tail -n 1 | awk '{ print $4 }'`
DATE_ENABLE=`exec logread | grep "DFS->ENABLED" | tail -n 1 | awk '{ print $4 }'`
if [ -n "${DATE_DISABLE}" ] && [ -z "${DATE_ENABLE}" ]; then
    if [ $(uci get wireless.${RADIO}.channel) -ne ${DFS_CHANNEL} ] && [ $(uci get wireless.${RADIO}.htmode) != ${MODE}${DFS_BAND} ]; then
        DATE_DISABLEDS=`date +%s -d "${DATE_DISABLE}"`
        TIME=`expr $((${DATE} - ${DATE_DISABLEDS}))`
    	if [ ${TIME} -lt ${SCHEDULE} ]; then
            logger "DFS Check NEW:enable"
            uci set wireless.${RADIO}.channel=${DFS_CHANNEL}
            uci set wireless.${RADIO}.htmode=${MODE}${DFS_BAND}
            uci commit wireless
            wifi reload ${RADIO}
            exit 0
        fi
    else
        logger "DFS Check NEW:use"
        exit 0
	fi
fi
if [ -n "${DATE_DISABLE}" ] && [ -n "${DATE_ENABLE}" ]; then
    if [ "${DATE_DISABLE}" -lt "${DATE_ENABLE}" ]; then
        if [ $(uci get wireless.${RADIO}.channel) -ne ${CHANNEL} ] && [ $(uci get wireless.${RADIO}.htmode) != ${HTMODE} ]; then
            DATE_ENABLEDS=`date +%s -d "${DATE_ENABLE}"`
            TIME=`expr $((${DATE} - ${DATE_ENABLEDS}))`
        	if [ ${TIME} -lt ${SCHEDULE} ]; then
                logger "DFS Check NEW:disable"
                uci set wireless.${RADIO}.channel=${CHANNEL}
                uci set wireless.${RADIO}.htmode=${MODE}${BAND}
                uci commit wireless
                wifi reload ${RADIO}
                exit 0
            fi
        else
            logger "DFS Check NEW:normal"
            exit 0
        fi
    else
        if [ "${DATE_ENABLE}" -lt "${DATE_DISABLE}" ]; then
            if [ $(uci get wireless.${RADIO}.channel) -ne ${DFS_CHANNEL} ] && [ $(uci get wireless.${RADIO}.htmode) != ${MODE}${DFS_BAND} ]; then
                DATE_DISABLEDS=`date +%s -d "${DATE_DISABLE}"`
                TIME=`expr $((${DATE} - ${DATE_DISABLEDS}))`
            	if [ ${TIME} -lt ${SCHEDULE} ]; then
                    logger "DFS Check NEW:enable"
                    uci set wireless.${RADIO}.channel=${DFS_CHANNEL}
                    uci set wireless.${RADIO}.htmode=${MODE}${DFS_BAND}
                    uci commit wireless
                    wifi reload ${RADIO}
                    exit 0
                fi
            else
                logger "DFS Check NEW:use"
                exit 0  
            fi
        fi
    fi
fi
if [ -n "${DATE_ENABLE}" ]; then
    if [ $(uci get wireless.${RADIO}.channel) -ne ${CHANNEL} ] && [ $(uci get wireless.${RADIO}.htmode) != ${HTMODE} ]; then
        DATE_ENABLEDS=`date +%s -d "${DATE_ENABLE}"`
        TIME=`expr $((${DATE} - ${DATE_ENABLEDS}))`
        if [ ${TIME} -lt ${SCHEDULE} ]; then
            logger "DFS Check NEW:disable"
            uci set wireless.${RADIO}.channel=${CHANNEL}
            uci set wireless.${RADIO}.htmode=${MODE}${BAND}
            uci commit wireless
            wifi reload ${RADIO}
            exit 0
        fi
    else
        logger "DFS Check NEW:normal"
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
    logger "DFS Check NEW:start"
    rm -rf /tmp/config-software
    sed -i "/dfs_check_new.sh/d" /etc/crontabs/root
    echo "*/${INTERVAL} * * * * sh /etc/config-software/dfs_check_new.sh # DFS Check NEW enable" >> /etc/crontabs/root
    /etc/init.d/cron restart
    mkdir -p /tmp/config-software/
    echo ${INTERVAL} > /tmp/config-software/interval.txt
    exit 0
}
restart() {
    logger "DFS Check NEW:restart"
    rm -rf /tmp/config-software
    sed -i "/dfs_check_new.sh/d" /etc/crontabs/root
    echo "*/${INTERVAL} * * * * sh /etc/config-software/dfs_check_new.sh # DFS Check NEW enable" >> /etc/crontabs/root
    /etc/init.d/cron restart
    mkdir -p /tmp/config-software/
    echo ${INTERVAL} > /tmp/config-software/interval.txt
    sh /etc/config-software/dfs_check_new.sh
    exit 0
}
stop() {
    logger "DFS Check NEW:stop"
    sed -i "/dfs_check_new.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    rm -rf /tmp/config-software
    exit 0
}
EOF
chmod +x /etc/init.d/dfs_check_new


cat <<"EOF" >> /usr/bin/dfslog
#!/bin/sh
sh /etc/config-software/dfs-config.sh
echo DFS Check NOW ---------------------------------
echo DFS Check NOW log:
exec logread | grep "DFS Check NEW" | awk '{ print $1,$2,$3,$4,$5,$8,$9,$10,$11 }'
echo DFS operating status:
exec logread | grep "DFS->DISABLED" | tail -n 1 | awk '{ print $1,$2,$3,$4,$5,$11 }'
exec logread | grep "DFS->ENABLED"  | tail -n 1 | awk '{ print $1,$2,$3,$4,$5,$11 }'
echo -----------------------------------------------
EOF
chmod +x /usr/bin/dfslog



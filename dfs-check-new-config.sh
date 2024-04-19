opkg update
opkg install coreutils-date

#! /bin/sh

cat << "EOF" > /etc/init.d/dfs_check_new
#!/bin/sh /etc/rc.common

INTERVAL=5     # check interval (min)
DFS_CHANNEL=36 # fallback channel
DFS_BAND=40    # fallback band

START=99
STOP=01
     
start() {
    mkdir -p /tmp/config-software/
    echo ${INTERVAL} > /tmp/config-software/interval.txt
    expr $((${INTERVAL} * 60)) > /tmp/config-software/schedule.txt
    RADIO=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
    CHS=`echo ${RADIO} | wc -w`
    if [ ${CHS} = 2 ];then
        RADIO=`echo ${RADIO}| awk '{print $2}'`
    fi
    echo ${RADIO} >> /tmp/config-software/radio.txt
    echo `uci get wireless.${RADIO}.channel` > /tmp/config-software/channel.txt
    echo `uci get wireless.${RADIO}.htmode` > /tmp/config-software/htmode.txt
    echo ${DFS_CHANNEL} > /tmp/config-software/dfs_channel.txt
    echo ${DFS_BAND} > /tmp/config-software/dfs_band.txt
    DATE=`date +%s`
    BOOT=`uptime -s | awk '{ print $1,$2 }'`
    BOOTS=`date +%s -d "${BOOT}"`
    DFS=`expr $((${BOOTS} + 60))`
    if [ "${DATE}" -lt "${DFS}" ]; then
        logger "DFS Check NEW: Boot_Interval_${INTERVAL}min"
        sleep 75
        sh /etc/config-software/dfs_check_new.sh
    else
        logger "DFS Check NEW: Start_Interval_${INTERVAL}min"
    fi
    sed -i "/dfs_check_new.sh/d" /etc/crontabs/root
    echo "*/${INTERVAL} * * * * sh /etc/config-software/dfs_check_new.sh # DFS Check NEW enable" >> /etc/crontabs/root
    /etc/init.d/cron restart
    exit 0
}
restart() {
    exit 0
}
stop() {
    logger "DFS Check NEW: Stop"
    sed -i "/dfs_check_new.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    rm -rf /tmp/config-software
    exit 0
}
EOF
chmod +x /etc/init.d/dfs_check_new


mkdir -p /etc/config-software/
cat << "EOF" > /etc/config-software/dfs_check_new.sh
#! /bin/sh
read SCHEDULE < /tmp/config-software/schedule.txt
read RADIO < /tmp/config-software/radio.txt
read CHANNEL < /tmp/config-software/channel.txt
read HTMODE < /tmp/config-software/htmode.txt
read DFS_CHANNEL < /tmp/config-software/dfs_channel.txt
read DFS_BAND < /tmp/config-software/dfs_band.txt
MODE=`echo ${HTMODE} | grep -o "[A-Z]*"`
BAND=`echo ${HTMODE} | grep -o "[0-9]*"`
CH=`echo ${RADIO} | grep -o "[0-9]*"`
DEV=`iw dev | awk '/Interface/{print $2}' | grep ${CH}`
IWCHANNEL=$(iw dev ${DEV} info | awk '/channel/{print $2}')
if [ -z "${IWCHANNEL}" ]; then
    wifi reload ${RADIO}
    logger "DFS Check NEW: Abnormality"
fi
PHY=`echo ${DEV} | awk -F'-' '{print $1}'`
HOSTPAD=`exec logread | grep "/var/run/hostapd-${PHY}.conf" | awk '{ print $1,$2,$3,$4,"JST",$5 }'| tail -n 1`
DATE_DISABLE=`exec logread | grep "DFS->DISABLED" | awk '{ print $1,$2,$3,$4,"JST",$5 }' | tail -n 1`
DATE_ENABLE=`exec logread | grep "DFS->ENABLED" | awk '{ print $1,$2,$3,$4,"JST",$5 }' | tail -n 1`
if [ -n "${HOSTPAD}" ]; then
    DATE=`date +%s`
    HOSTPADS=`date +%s -d "${HOSTPAD}"`
    TIME=`expr $((${DATE} - ${HOSTPADS}))`
    if [ ${TIME} -lt ${SCHEDULE} ]; then
        echo `uci get wireless.${RADIO}.channel` > /tmp/config-software/channel.txt
        echo `uci get wireless.${RADIO}.htmode` > /tmp/config-software/htmode.txt
        read CHANNEL < /tmp/config-software/channel.txt
        read HTMODE < /tmp/config-software/htmode.txt
        MODE=`echo ${HTMODE} | grep -o "[A-Z]*"`
        BAND=`echo ${HTMODE} | grep -o "[0-9]*"`
        logger "DFS Check NEW: Channel_Changes"
    fi
fi
if [ -n "${DATE_DISABLE}" ] && [ -z "${DATE_ENABLE}" ]; then
    if [ ${CHANNEL} -ne ${DFS_CHANNEL} ] || [ ${BAND} != ${DFS_BAND} ]; then
        DATE=`date +%s`
        DATE_DISABLEDS=`date +%s -d "${DATE_DISABLE}"`
        TIME=`expr $((${DATE} - ${DATE_DISABLEDS}))`
    	if [ ${TIME} -lt ${SCHEDULE} ]; then
            uci set wireless.${RADIO}.channel=${DFS_CHANNEL}
            uci set wireless.${RADIO}.htmode=${MODE}${DFS_BAND}
            uci commit wireless
            wifi reload ${RADIO}
            logger "DFS Check NEW: DFS_Check_ON"
            exit 0
        fi
    else
        exit 0
	fi
fi
if [ -n "${DATE_DISABLE}" ] && [ -n "${DATE_ENABLE}" ]; then
    DATE_DISABLEDS=`date +%s -d "${DATE_DISABLE}"`
    DATE_ENABLEDS=`date +%s -d "${DATE_ENABLE}"`
    if [ "${DATE_DISABLEDS}" -lt "${DATE_ENABLEDS}" ]; then
        if [ ${CHANNEL} -eq ${DFS_CHANNEL} ] || [ ${BAND} = ${DFS_BAND} ]; then
            DATE=`date +%s`
            TIME=`expr $((${DATE} - ${DATE_ENABLEDS}))`
        	if [ ${TIME} -lt ${SCHEDULE} ]; then
                uci set wireless.${RADIO}.channel=${CHANNEL}
                uci set wireless.${RADIO}.htmode=${MODE}${BAND}
                uci commit wireless
                wifi reload ${RADIO}
                logger "DFS Check NEW: DFS_Check_OFF"
                exit 0
            fi
        else
            exit 0
        fi
    else
        DATE_DISABLEDS=`date +%s -d "${DATE_DISABLE}"`
        DATE_ENABLEDS=`date +%s -d "${DATE_ENABLE}"`
        if [ "${DATE_ENABLEDS}" -lt "${DATE_DISABLEDS}" ]; then
            if [ ${CHANNEL} -ne ${DFS_CHANNEL} ] || [ ${BAND} != ${DFS_BAND} ]; then
                DATE=`date +%s`
                TIME=`expr $((${DATE} - ${DATE_DISABLEDS}))`
            	if [ ${TIME} -lt ${SCHEDULE} ]; then
                    uci set wireless.${RADIO}.channel=${DFS_CHANNEL}
                    uci set wireless.${RADIO}.htmode=${MODE}${DFS_BAND}
                    uci commit wireless
                    wifi reload ${RADIO}
                    logger "DFS Check NEW: DFS_Check_ON"
                    exit 0
                fi
            else
                exit 0  
            fi
        fi
    fi
fi
if [ -n "${DATE_ENABLE}" ]; then
   if [ ${CHANNEL} -eq ${DFS_CHANNEL} ] && [ ${BAND} = ${DFS_BAND} ]; then
        DATE=`date +%s`
        DATE_ENABLEDS=`date +%s -d "${DATE_ENABLE}"`
        TIME=`expr $((${DATE} - ${DATE_ENABLEDS}))`
        if [ ${TIME} -lt ${SCHEDULE} ]; then
            uci set wireless.${RADIO}.channel=${CHANNEL}
            uci set wireless.${RADIO}.htmode=${MODE}${BAND}
            uci commit wireless
            wifi reload ${RADIO}
            logger "DFS Check NEW: DFS_Check_ON"
            exit 0
        fi
    else
        exit 0
    fi
fi
EOF
chmod +x /etc/config-software/dfs_check_new.sh


cat <<"EOF" > /usr/bin/dfslog
#!/bin/sh
echo -e "\033[1;36mDFS Check NOW -----------------------\033[0;39m"
echo -e "\033[1;37mLOG:\033[0;39m"
exec logread | grep "DFS Check NEW" | awk '{ print $1,$2,$3,$4,$5,$11 }' | tail -n 10
echo -e "\033[1;37mCONFIG CHANGE:\033[0;39m"
read RADIO < /tmp/config-software/radio.txt
CH=`echo ${RADIO} | grep -o "[0-9]*"`
DEV=`iw dev | awk '/Interface/{print $2}' | grep ${CH}`
PHY=`echo ${DEV} | awk -F'-' '{print $1}'`
exec logread | grep "/var/run/hostapd-${PHY}.conf" | awk '{ print $1,$2,$3,$4,$5,"hostapd-'${PHY}'" }' | tail -n 1
echo -e "\033[1;37mDISABLED:\033[0;39m"
exec logread | grep "DFS->DISABLED" | awk '{ print $1,$2,$3,$4,$5,$11 }' | tail -n 1
echo -e "\033[1;37mENABLED:\033[0;39m"
exec logread | grep "DFS->ENABLED" | awk '{ print $1,$2,$3,$4,$5,$11 }' | tail -n 1
echo -e "\033[1;36m--------------------------------------\033[0;39m"
read INTERVAL < /tmp/config-software/interval.txt
echo -e "\033[1;37mNow Interval: ${INTERVAL} min\033[0;39m"
read CHANNEL < /tmp/config-software/channel.txt
echo -e "\033[1;37mNow channel: ${CHANNEL} Ch\033[0;39m"
read HTMODE < /tmp/config-software/htmode.txt
echo -e "\033[1;37mNow htmode: ${HTMODE}\033[0;39m"
EOF
chmod +x /usr/bin/dfslog


cat <<"EOF" > /usr/bin/dfstime
#! /bin/sh
read INTERVAL < /tmp/config-software/interval.txt
if [ -n "$1" ]; then
	description_INTERVAL="$1"
	sed -i -e "s/INTERVAL=${INTERVAL}/INTERVAL=${description_INTERVAL}/g" /etc/init.d/dfs_check_new
	service dfs_check_new start
    echo " Set time: ${description_INTERVAL} min"
	exit 0
else
	while :
	do
		echo -e " \033[1;37mInterval time setting\033[0;39m"
        echo -e " \033[1;37mNow Interval: ${INTERVAL} min\033[0;39m"
        read -p " Interval time change (y or q): " input_CHANGE
        if [ "${input_CHANGE}" = "q" ]; then
            exit 0
        fi
		read -p " Interval time (min): " input_INTERVAL
		read -p " Please select key [y or q]: " num
		case "${num}" in
		"y" ) sed -i -e "s/INTERVAL=${INTERVAL}/INTERVAL=${input_INTERVAL}/g" /etc/init.d/dfs_check_new
			  service dfs_check_new start
			  echo " Set time: ${input_INTERVAL} min"
		      exit 0 ;;
	    "q" ) exit 0 ;;
	    esac
    done
fi
EOF
chmod +x /usr/bin/dfstime

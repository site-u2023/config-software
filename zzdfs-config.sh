#! /bin/ash

cat << "EOF" > /etc/init.d/zzdfs
#!/bin/sh /etc/rc.common

INTERVAL=5    # check interval (min)
FB_BAND=40    # fallback band
FB_CHANNEL=36 # fallback channel

START=99
STOP=01
     
start() {
    uci get system.@system[0].log_file 2&>1
    if [ $? = 1 ]; then
        uci set system.@system[0].log_file='/var/log/syslog'
        uci set system.@system[0].log_remote='0'
        uci commit system
        service log restart
        service system restart
    fi
    sleep 1m 15s
    mkdir -p /tmp/config-software/
    RADIO=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
    CHS=`echo ${RADIO} | wc -w`
    if [ ${CHS} = 2 ];then
        RADIO=`echo ${RADIO}| awk '{print $2}'`
    fi
    CH=`echo ${RADIO} | grep -o "[0-9]*"`
    echo $(iw dev | awk '/Interface/{print $2}' | grep ${CH}) > /tmp/config-software/dev
    echo ${INTERVAL} > /tmp/config-software/interval
    echo ${RADIO} > /tmp/config-software/radio
    echo ${FB_BAND} > /tmp/config-software/fb_band
    echo ${FB_CHANNEL} > /tmp/config-software/fb_channel
    logger "ZZDFS: Start"
    sed -i "/zzdfs.sh/d" /etc/crontabs/root
    echo "*/${INTERVAL} * * * * sh /etc/config-software/zzdfs.sh # ZZDFS" >> /etc/crontabs/root
    /etc/init.d/cron restart
    exit 0
}
restart() {
    exit 0
}
stop() {
    logger "ZZDFS: Stop"
    sed -i "/zzdfs.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    rm -rf /tmp/config-software
    exit 0
}
EOF
chmod +x /etc/init.d/zzdfs


mkdir -p /etc/config-software/
cat << "EOF" > /etc/config-software/zzdfs.sh
#! /bin/sh

read DEV < /tmp/config-software/dev
iwinfo ${DEV} info 2>&1 | grep -q 'No such wireless device'
if [ $? = 0 ]; then
    read RADIO < /tmp/config-software/radio
    WIFI=`uci get wireless.${RADIO}.disabled`
    if [ "${WIFI}" != 1 ]; then 
        exec logread 2>&1 | grep "DFS->DISABLED"
        if [ $? = 0 ]; then
            logger "ZZDFS: ZZDFS_On"
            sed -i -e "s/DFS->DISABLED/DFS->disabled/g" /var/log/syslog
            sed -i "/zzdfs.sh/d" /etc/crontabs/root
            /etc/init.d/cron restart
            read INTERVAL < /tmp/config-software/interval
            read FB_CHANNEL < /tmp/config-software/fb_channel
            read FB_BAND < /tmp/config-software/fb_band
            CHANNEL=$(uci get wireless.${RADIO}.channel | tee /tmp/config-software/channel)
            HTMODE=$(uci get wireless.${RADIO}.htmode | tee /tmp/config-software/htmode)
            MODE=`echo ${HTMODE} | grep -o "[A-Z]*"`
            uci set wireless.${RADIO}.channel=${FB_CHANNEL}
            uci set wireless.${RADIO}.htmode=${MODE}${FB_BAND}
            uci commit wireless
            wifi reload ${RADIO}
            sleep 30m
            logger "ZZDFS: ZZDFS_Off"
            uci set wireless.${RADIO}.channel=${CHANNEL}
            uci set wireless.${RADIO}.htmode=${HTMODE}
            uci commit wireless
            wifi reload  ${RADIO}
            sleep 1m 10s
            echo "*/${INTERVAL} * * * * sh /etc/config-software/zzdfs.sh # ZZDFS" >> /etc/crontabs/root
            /etc/init.d/cron restart
        else
            logger "ZZDFS: No_Radio"
            sed -i "/zzdfs.sh/d" /etc/crontabs/root
            /etc/init.d/cron restart
            sleep 1m 10s
            wifi reload ${RADIO}
            read INTERVAL < /tmp/config-software/interval
            echo "*/${INTERVAL} * * * * sh /etc/config-software/zzdfs.sh # ZZDFS" >> /etc/crontabs/root
            /etc/init.d/cron restart
        fi
    else
        logger "ZZDFS: ${RADIO}_Disable"
        fi
    fi    
fi
EOF


cat <<"EOF" > /usr/bin/zzdfst
#! /bin/sh
read INTERVAL < /tmp/config-software/interval
if [ -n "$1" ]; then
    logger "ZZDFS: Interval_Change"
	description_INTERVAL="$1"
	sed -i -e "s/INTERVAL=${INTERVAL}/INTERVAL=${description_INTERVAL}/g" /etc/init.d/zzdfs
    echo ${description_INTERVAL} > /tmp/config-software/interval
    sed -i "/zzdfs.sh/d" /etc/crontabs/root
    echo "*/${description_INTERVAL} * * * * sh /etc/config-software/zzdfs.sh # DFS ZZDFS" >> /etc/crontabs/root
    /etc/init.d/cron restart
    echo " Set time: ${description_INTERVAL} min"
	exit 0
else
	while :
	do
        logger "ZZDFS: Interval_Change"
		echo -e " \033[1;37mInterval time setting\033[0;39m"
        echo -e " \033[1;37mNow Interval: ${INTERVAL} min\033[0;39m"
        read -p " Interval time change (y or q): " input_CHANGE
        if [ "${input_CHANGE}" = "q" ]; then
            exit 0
        fi
		read -p " Interval time (min): " input_INTERVAL
		read -p " Please select key [y or q]: " num
		case "${num}" in
		"y" ) sed -i -e "s/INTERVAL=${INTERVAL}/INTERVAL=${input_INTERVAL}/g" /etc/init.d/zzdfs
              echo ${input_INTERVAL} > /tmp/config-software/interval
              sed -i "/zzdfs.sh/d" /etc/crontabs/root
              echo "*/${input_INTERVAL} * * * * sh /etc/config-software/zzdfs.sh # ZZDFS" >> /etc/crontabs/root
              /etc/init.d/cron restart
			  echo " Set time: ${input_INTERVAL} min"
		      exit 0 ;;
	    "q" ) exit 0 ;;
	    esac
    done
fi
EOF
chmod +x /usr/bin/zzdfst


cat <<"EOF" > /usr/bin/zzdfsl
#!/bin/sh
echo -e "\033[1;36mZZDFS\033[0;39m"
echo -e "\033[1;36mLOG ------------------------------------\033[0;39m"
echo -e "\033[1;37mLOG:\033[0;39m"
exec logread | grep "ZZDFS" | awk '{ print $1,$2,$3,$4,$5,$9 }' | tail -n 10
echo -e "\033[1;37mDISABLED:\033[0;39m"
exec logread | grep "DFS->disabled" | awk '{ print $1,$2,$3,$4,$5,$11 }' | tail -n 1
echo -e "\033[1;37mENABLED:\033[0;39m"
exec logread | grep "DFS->ENABLED" | awk '{ print $1,$2,$3,$4,$5,$11 }' | tail -n 1
echo -e "\033[1;36mINFORMATION ----------------------------\033[0;39m"
read INTERVAL < /tmp/config-software/interval
echo -e "\033[1;37mInterval: ${INTERVAL}min\033[0;39m"
read FB_BAND < /tmp/config-software/fb_band
read FB_CHANNEL < /tmp/config-software/fb_channel
read RADIO < /tmp/config-software/radio
HTMODE=$(uci get wireless.${RADIO}.htmode)
MODE=`echo ${HTMODE} | grep -o "[A-Z]*"`
echo -e "\033[1;37mFALLBACK Channel/ Htmode: ${FB_CHANNEL}Ch/ ${MODE}${FB_BAND}\033[0;39m"
read RADIO < /tmp/config-software/radio
CHANNEL=$(uci get wireless.${RADIO}.channel)
HTMODE=$(uci get wireless.${RADIO}.htmode)
WIFI=`uci get wireless.${RADIO}.disabled` 2>/dev/null
if [ "${WIFI}" != 1 ]; then
    echo -e "\033[1;37mWi-Fi 5G ${RADIO} ENABLE\033[0;39m"   
else
    echo -e "\033[1;37mWi-Fi 5G ${RADIO} DISABLE\033[0;39m"
fi
echo -e "\033[1;37mWi-Fi 5G Channel/ Htmode: ${CHANNEL}Ch/ ${HTMODE}\033[0;39m"
echo -e "\033[1;36m----------------------------------------\033[0;39m"
EOF
chmod +x /usr/bin/zzdfsl

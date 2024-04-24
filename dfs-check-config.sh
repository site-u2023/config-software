#! /bin/ash

cat << "EOF" > /etc/init.d/dfs_check
#!/bin/sh /etc/rc.common

INTERVAL=5    # check interval (min)
FB_BAND=40    # fallback band
FB_CHANNEL=36 # fallback channel

START=99
STOP=01
     
start() {
    sleep 75s
    mkdir -p /tmp/config-software/
    RADIO=`uci show wireless | grep "band='5g'" | cut -d'.' -f2 | awk '{ print $1 }'`
    CHS=`echo ${RADIO} | wc -w`
    if [ ${CHS} = 2 ];then
        RADIO=`echo ${RADIO}| awk '{print $2}'`
    fi
    CH=`echo ${RADIO} | grep -o "[0-9]*"`
    DEV=`iw dev | awk '/Interface/{print $2}' | grep ${CH}`
    echo ${INTERVAL} > /tmp/config-software/interval
    echo ${DEV} > /tmp/config-software/dev
    echo ${RADIO} > /tmp/config-software/radio
    echo ${FB_BAND} > /tmp/config-software/fb_band
    echo ${FB_CHANNEL} > /tmp/config-software/fb_channel
    logger "DFS Check: Start"
    sed -i "/dfs_check.sh/d" /etc/crontabs/root
    echo "*/${INTERVAL} * * * * sh /etc/config-software/dfs_check.sh # DFS Check" >> /etc/crontabs/root
    /etc/init.d/cron restart
    exit 0
}
restart() {
    exit 0
}
stop() {
    logger "DFS Check: Stop"
    sed -i "/dfs_chec.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    rm -rf /tmp/config-software
    exit 0
}
EOF
chmod +x /etc/init.d/dfs_check


mkdir -p /etc/config-software/
cat << "EOF" > /etc/config-software/dfs_check.sh
#! /bin/sh

read RADIO < /tmp/config-software/radio
read DEV < /tmp/config-software/dev
IW_CHANNEL=`iw dev ${DEV} info | awk '/channel/{print $2}'`
if [ -z ${IW_CHANNEL} ]; then
    read RADIO < /tmp/config-software/radio
    wifi reload ${RADIO}
    logger "DFS Check: Abnormality"
fi
    
iw info ${DEV} info 2>&1 | grep -q 'No such wireless device'
if [ $? = 0 ]; then
    logger "DFS Check: DFS_Check_ON"
    sed -i "/dfs_chec.sh/d" /etc/crontabs/root
    /etc/init.d/cron restart
    read INTERVAL < /tmp/config-software/interval
    read FB_CHANNEL < /tmp/config-software/fb_channel
    read FB_BAND < /tmp/config-software/fb_band
    CHANNEL=$(uci get wireless.${RADIO}.channel)
    HTMODE=$(uci get wireless.${RADIO}.htmode)
    MODE=`echo ${HTMODE} | grep -o "[A-Z]*"`
    echo ${CHANNEL} > /tmp/config-software/channel
    echo ${HTMODE} > /tmp/config-software/htmode
    uci set wireless.${RADIO}.channel=${FB_CHANNEL}
    uci set wireless.${RADIO}.htmode=${MODE}${FB_BAND}
    uci commit wireless
    wifi reload ${RADIO}
    sleep 30m
    logger "DFS Check: DFS_Check_OFF"
    sed -i "/dfs_chec.sh/d" /etc/crontabs/root
    echo "*/${INTERVAL} * * * * sh /etc/config-software/dfs_check.sh # DFS Check" >> /etc/crontabs/root
    /etc/init.d/cron restart
    uci set wireless.${RADIO}.channel=${CHANNEL}
    uci set wireless.${RADIO}.htmode=${HTMODE}
    uci commit wireless
    wifi reload  ${RADIO}
fi
EOF


cat <<"EOF" > /usr/bin/dfstime
#! /bin/sh
read INTERVAL < /tmp/config-software/interval
if [ -n "$1" ]; then
    logger "DFS Check: Interval_Change"
	description_INTERVAL="$1"
	sed -i -e "s/INTERVAL=${INTERVAL}/INTERVAL=${description_INTERVAL}/g" /etc/init.d/dfs_check
    echo ${description_INTERVAL} > /tmp/config-software/interval
    sed -i "/dfs_check.sh/d" /etc/crontabs/root
    echo "*/${description_INTERVAL} * * * * sh /etc/config-software/dfs_check.sh # DFS Check" >> /etc/crontabs/root
    /etc/init.d/cron restart
    echo " Set time: ${description_INTERVAL} min"
	exit 0
else
	while :
	do
        logger "DFS Check: Interval_Change"
		echo -e " \033[1;37mInterval time setting\033[0;39m"
        echo -e " \033[1;37mNow Interval: ${INTERVAL} min\033[0;39m"
        read -p " Interval time change (y or q): " input_CHANGE
        if [ "${input_CHANGE}" = "q" ]; then
            exit 0
        fi
		read -p " Interval time (min): " input_INTERVAL
		read -p " Please select key [y or q]: " num
		case "${num}" in
		"y" ) sed -i -e "s/INTERVAL=${INTERVAL}/INTERVAL=${input_INTERVAL}/g" /etc/init.d/dfs_check
              echo ${input_INTERVAL} > /tmp/config-software/interval
              sed -i "/dfs_check.sh/d" /etc/crontabs/root
              echo "*/${input_INTERVAL} * * * * sh /etc/config-software/dfs_check.sh # DFS Check" >> /etc/crontabs/root
              /etc/init.d/cron restart
			  echo " Set time: ${input_INTERVAL} min"
		      exit 0 ;;
	    "q" ) exit 0 ;;
	    esac
    done
fi
EOF
chmod +x /usr/bin/dfstime


cat <<"EOF" > /usr/bin/dfslog
#!/bin/sh
echo -e "\033[1;36mDFS Check\033[0;39m"
echo -e "\033[1;36mLOG ------------------------------------\033[0;39m"
echo -e "\033[1;37mLOG:\033[0;39m"
exec logread | grep "DFS Check" | awk '{ print $1,$2,$3,$4,$5,$10 }' | tail -n 10
echo -e "\033[1;37mDISABLED:\033[0;39m"
exec logread | grep "DFS->DISABLED" | awk '{ print $1,$2,$3,$4,$5,$11 }' | tail -n 1
echo -e "\033[1;37mENABLED:\033[0;39m"
exec logread | grep "DFS->ENABLED" | awk '{ print $1,$2,$3,$4,$5,$11 }' | tail -n 1
echo -e "\033[1;36mWi-Fi ----------------------------------\033[0;39m"
read INTERVAL < /tmp/config-software/interval
echo -e "\033[1;37mNow Interval: ${INTERVAL} min\033[0;39m"
read CHANNEL < /tmp/config-software/channel
echo -e "\033[1;37mNow Channel: ${CHANNEL} Ch\033[0;39m"
read HTMODE < /tmp/config-software/htmode
echo -e "\033[1;37mNow Htmode: ${HTMODE}\033[0;39m"
echo -e "\033[1;36mSpeed test -----------------------------\033[0;39m"
echo -e "\033[1;37mDFS Check run time:\033[0;39m"
time sh /etc/config-software/dfs_check.sh
echo -e "\033[1;36m----------------------------------------\033[0;39m"
EOF
chmod +x /usr/bin/dfslog

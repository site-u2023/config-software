#! /bin/sh

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
 else
   read -p " Exit due to different versions"
 exit
fi

opkg install adblock-fast
opkg install luci-app-adblock-fast
opkg install luci-i18n-adblock-fast-ja
opkg install ip6tables-mod-nat
opkg install kmod-ipt-nat6
opkg --force-overwrite install gawk grep sed coreutils-sort

uci set adblock-fast.config.enabled=1
uci set adblock-fast.config.procd_trigger_wan6='1'
uci set adblock-fast.file_url=file_url
uci set adblock-fast.file_url.url='https://raw.githubusercontent.com/tofukko/filter/master/Adblock_Plus_list.txt'
uci set adblock-fast.file_url.action='block'
uci set adblock-fast.file_url.enabled='1'
uci commit adblock-fast
/etc/init.d/adblock-fast enable
/etc/init.d/adblock-fast start


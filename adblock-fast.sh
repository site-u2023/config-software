#! /bin/sh

UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
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
service adblock-fast enable
service adblock-fast start

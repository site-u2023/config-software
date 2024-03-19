#!/bin/sh

. /lib/functions/network.sh
network_flush_cache
network_find_wan6 NET_IF6
network_get_ipaddr6 NET_ADDR6 "${NET_IF6}"
NURO_V6=`echo ${NET_ADDR6} | cut -d: -f1-3`

function _func_NURO_A {
echo -e " \033[1;36mパターンA (V6プラスタイプ)\033[0;39m"
# network backup
cp /etc/config/network /etc/config/network.map-e-nuro.old
# DHCP LAN
uci set dhcp.lan=dhcp
uci set dhcp.lan.dhcpv6='server'
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'
# WAN
uci set network.wan.auto='0'
# DHCP WAN6
uci set dhcp.wan6=dhcp
uci set dhcp.wan6.interface='wan6'
uci set dhcp.wan6.ignore='1'
uci set dhcp.wan6.master='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'
uci set dhcp.wan6.ndp='relay'
# WAN6
uci set network.wan6=interface
uci set network.wan6.device='wan'
uci set network.wan6.proto='dhcpv6'
uci set network.wan6.ip6prefix=${IPV6_PREFIX}::/56
# WANMAP
WANMAP='wanmap'
uci set network.${WANMAP}=interface
uci set network.${WANMAP}.proto='map'
uci set network.${WANMAP}.maptype='map-e'
uci set network.${WANMAP}.peeraddr=${BR_ADDR}
uci set network.${WANMAP}.ipaddr=${IPV4_PREFIX}
uci set network.${WANMAP}.ip4prefixlen='20'
uci set network.${WANMAP}.ip6prefix=${IPV6_PREFIX}::
uci set network.${WANMAP}.ip6prefixlen='36'
uci set network.${WANMAP}.ealen='20'
uci set network.${WANMAP}.psidlen='8'
uci set network.${WANMAP}.offset='4'
uci set network.${WANMAP}.legacymap='1'
uci set network.${WANMAP}.mtu='1460'
uci set network.${WANMAP}.encaplimit='ignore'
uci set network.${WANMAP}.tunlink='wan6'
# FW
ZOON_NO='1'
uci del_list firewall.@zone[${ZOON_NO}].network='wan'
uci add_list firewall.@zone[${ZOON_NO}].network=${WANMAP}
# delete
uci -q delete dhcp.lan.dns
uci -q delete dhcp.lan.dhcp_option
# IPV4
uci add_list network.lan.dns='118.238.201.33' #	dns1.nuro.jp
uci add_list network.lan.dns='152.165.245.17' #	dns1.nuro.jp
#uci add_list network.lan.dns='118.238.201.49' # dns2.nuro.jp
#uci add_list network.lan.dns='152.165.245.1'# dns2.nuro.jp
uci add_list dhcp.lan.dhcp_option='6,1.1.1.1,8.8.8.8'
uci add_list dhcp.lan.dhcp_option='6,1.0.0.1,8.8.4.4'
# IPV6
uci add_list network.lan.dns='240d:0010:0004:0005::33'
uci add_list network.lan.dns='240d:12:4:1b01:152:165:245:17'
#uci add_list network.lan.dns='240d:0010:0004:0006::49'
#uci add_list network.lan.dns='240d:12:4:1b00:152:165:245:1'
uci add_list dhcp.lan.dns='2606:4700:4700::1111'
uci add_list dhcp.lan.dns='2001:4860:4860::8888'
uci add_list dhcp.lan.dns='2606:4700:4700::1001'
uci add_list dhcp.lan.dns='2001:4860:4860::8844'
uci commit
echo -e "\033[1;33m wan ipaddr6: ${NET_ADDR6}\033[0;33m"
echo -e "\033[1;32m wan6 ip6prefix: \033[0;39m"${IPV6_PREFIX}::/56
echo -e "\033[1;32m ${WANMAP} peeraddr: \033[0;39m"${BR_ADDR}
echo -e "\033[1;32m ${WANMAP} ip4prefixlen: \033[0;39m"20
echo -e "\033[1;32m ${WANMAP} ip6pfx: \033[0;39m"${IPV6_PREFIX}::
echo -e "\033[1;32m ${WANMAP} ip6prefixlen: \033[0;39m"36
echo -e "\033[1;32m ${WANMAP} ealen: \033[0;39m"20
echo -e "\033[1;32m ${WANMAP} psidlen: \033[0;39m"8
echo -e "\033[1;32m ${WANMAP} offset: \033[0;39m"4
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit 0
}

function _func_NURO_B {
echo -e " \033[1;31mパターンB (OCNタイプ)\033[0;39m"
# network backup
cp /etc/config/network /etc/config/network.map-e-nuro.old
# DHCP LAN
uci set dhcp.lan=dhcp
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.dhcpv6='server'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'
# WAN
uci set network.wan.auto='0'
# DHCP WAN6
uci set network.wan6=interface
uci set network.wan6.device='wan'
uci set dhcp.wan6.interface='wan6'
uci set dhcp.wan6=dhcp
uci set dhcp.wan6.ignore='1'
uci set dhcp.wan6.master='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'
uci set dhcp.wan6.ndp='relay'
# WAN6RA
WAN6RA='wan6ra'
uci set network.${WAN6RA}=interface
uci set network.${WAN6RA}.device='wan'
uci set network.${WAN6RA}.proto='static'
uci set network.${WAN6RA}.ip6gw=${IPV6_PREFIX}::1
uci set network.${WAN6RA}.ip6prefix=${IPV6_PREFIX}}::/56
uci add_list network.${WAN6RA}.ip6addr=${IPV6_PREFIX}::1001
# WANMAP
WANMAP='wanmap'
uci set network.${WANMAP}=interface
uci set network.${WANMAP}.proto='map'
uci set network.${WANMAP}.maptype='map-e'
uci set network.${WANMAP}.peeraddr=${BR_ADDR}
uci set network.${WANMAP}.ipaddr=${IPV4_PREFIX}
uci set network.${WANMAP}.ip4prefixlen='20'
uci set network.${WANMAP}.ip6prefix=${IPV6_PREFIX}::
uci set network.${WANMAP}.ip6prefixlen='36'
uci set network.${WANMAP}.ealen='20'
uci set network.${WANMAP}.psidlen='8'
uci set network.${WANMAP}.offset='4'
uci set network.${WANMAP}.legacymap='1'
uci set network.${WANMAP}.mtu='1460'
# FW
ZOON_NO='1'
uci del_list firewall.@zone[${ZOON_NO}].network='wan'
uci add_list firewall.@zone[${ZOON_NO}].network=${WANMAP}
uci add_list firewall.@zone[${ZOON_NO}].network=${WAN6RA}
# delete
uci -q delete dhcp.lan.dns
uci -q delete dhcp.lan.dhcp_option
# IPV4
uci add_list network.lan.dns='118.238.201.33' #	dns1.nuro.jp
uci add_list network.lan.dns='152.165.245.17' #	dns1.nuro.jp
#uci add_list network.lan.dns='118.238.201.49' # dns2.nuro.jp
#uci add_list network.lan.dns='152.165.245.1'# dns2.nuro.jp
uci add_list dhcp.lan.dhcp_option='6,1.1.1.1,8.8.8.8'
uci add_list dhcp.lan.dhcp_option='6,1.0.0.1,8.8.4.4'
# IPV6
uci add_list network.lan.dns='240d:0010:0004:0005::33'
uci add_list network.lan.dns='240d:12:4:1b01:152:165:245:17'
#uci add_list network.lan.dns='240d:0010:0004:0006::49'
#uci add_list network.lan.dns='240d:12:4:1b00:152:165:245:1'
uci add_list dhcp.lan.dns='2606:4700:4700::1111'
uci add_list dhcp.lan.dns='2001:4860:4860::8888'
uci add_list dhcp.lan.dns='2606:4700:4700::1001'
uci add_list dhcp.lan.dns='2001:4860:4860::8844'
uci commit
echo -e "\033[1;33m wan ipaddr6: ${NET_ADDR6}\033[0;33m"
echo -e "\033[1;32m ${WAN6RA} device: \033[0;39m"wan
echo -e "\033[1;32m ${WAN6RA} ip6gw: \033[0;39m"${IPV6_PREFIX}::1
echo -e "\033[1;32m ${WAN6RA} ip6prefix: \033[0;39m"${IPV6_PREFIX}}::/56
echo -e "\033[1;32m ${WAN6RA} ip6addr: \033[0;39m"${IPV6_PREFIX}::1001
echo -e "\033[1;32m ${WANMAP} peeraddr: \033[0;39m"${BR_ADDR}
echo -e "\033[1;32m ${WANMAP} ip4prefixlen: \033[0;39m"'20'
echo -e "\033[1;32m ${WANMAP} ip6pfx: \033[0;39m"${IPV6_PREFIX}::
echo -e "\033[1;32m ${WANMAP} ip6prefixlen: \033[0;39m"'36'
echo -e "\033[1;32m ${WANMAP} ealen: \033[0;39m"'20'
echo -e "\033[1;32m ${WANMAP} psidlen: \033[0;39m"'8'
echo -e "\033[1;32m ${WANMAP} offset: \033[0;39m"'4'
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit 0
}

function _func_PORT {
cat /tmp/map-wanmap.rules | awk '/PORTSETS/'
}

function _func_RECOVERY {
cp /etc/config/network.map-e-nuro.old /etc/config/network.map-e-nuro
rm /etc/config/network.map-e-nuro.old
/etc/init.d/network reload
}

opkg update
opkg install map

if [ ${NURO_V6} = 240d:000f:0000 ]; then
BR_ADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:0000"
IPV4_PREFIX="219.104.128.0"
fi
if [ ${NURO_V6} = 240d:000f:1000 ]; then
BR_ADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:1000"
IPV4_PREFIX="219.104.144.0"
fi
if [ ${NURO_V6} = 240d:000f:2000 ]; then
BR_ADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:2000"
IPV4_PREFIX="219.104.160.0"
fi
if [ ${NURO_V6} = 240d:000f:3000 ]; then
BR_ADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:3000"
IPV4_PREFIX="219.104.176.0"
fi
echo "未対応"
exit 0

while :
do
  echo -e " \033[1;33mnuro光 MAP-eの設定を開始します\033[0;39m"
  echo -e " \033[1;37muro光 -----------------------------------------------\033[0;39m"
  echo -e " \033[1;36m[a]: パターンA (V6プラスタイプ)\033[0;39m"
  echo -e " \033[1;31m[b]: パターンB (OCNタイプ)\033[0;39m"
  echo -e " \033[1;33m[p]: 利用可能ポート確認\033[0;39m"
  echo -e " \033[7;40m[r]: リカバリー\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [e/o/p or r]: " num
  case "${num}" in
    "a" ) _func_NURO_A ;;
    "b" ) _func_NURO_B ;;
    "p" ) _func_PORT ;;
    "r" ) _func_RECOVERY ;;
  esac
 done 



#!/bin/sh

. /lib/functions/network.sh
network_flush_cache
network_find_wan6 NET_IF6
network_get_ipaddr6 NET_ADDR6 "${NET_IF6}"
NURO_V6=`echo ${NET_ADDR6} | cut -d: -f1-3`

function _func_NURO {
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
uci set network.wan6.ip6prefix=${IPV6_PREFIX}::/36
# WANMAP
WANMAP='wanmap'
uci set network.${WANMAP}=interface
uci set network.${WANMAP}.proto='map'
uci set network.${WANMAP}.maptype='map-e'
uci set network.${WANMAP}.peeraddr=${BRADDR}
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
uci -q delete dhcp.lan.dhcp_option
uci -q delete dhcp.lan.dns
# IPV4
uci add_list dhcp.lan.dhcp_option="6,1.1.1.1,8.8.8.8"
uci add_list dhcp.lan.dhcp_option="6,1.0.0.1,8.8.4.4"
# IPV6
uci add_list dhcp.lan.dns="2606:4700:4700::1111"
uci add_list dhcp.lan.dns="2001:4860:4860::8888"
uci add_list dhcp.lan.dns="2606:4700:4700::1001"
uci add_list dhcp.lan.dns="2001:4860:4860::8844"

uci commit

echo -e "\033[1;33m wan ipaddr6: ${NET_ADDR6}\033[0;33m"
echo -e "\033[1;32m wan6 ip6prefix: \033[0;39m"${IPV6_PREFIX}::/36
echo -e "\033[1;32m ${WANMAP} peeraddr: \033[0;39m"${BRADDR}
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

if [ ${NURO_V6} = 240d:000f:0000 ]; then
BRADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:0000"
IPV4_PREFIX="219.104.128.0"
_func_NURO
fi
if [ ${NURO_V6} = 240d:000f:1000 ]; then
BRADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:1000"
IPV4_PREFIX="219.104.144.0"
_func_NURO
fi
if [ ${NURO_V6} = 240d:000f:2000 ]; then
BRADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:2000"
IPV4_PREFIX="219.104.160.0"
_func_NURO
fi
if [ ${NURO_V6} = 240d:000f:3000 ]; then
BRADDR="2001:3b8:200:ff9::1"
IPV6_PREFIX="240d:000f:3000"
IPV4_PREFIX="219.104.176.0"
_func_NURO
fi
echo "未対応"
exit 0

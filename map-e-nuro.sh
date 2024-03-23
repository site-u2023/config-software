#!/bin/sh
# Vr.3.03
# License: CC0

. /lib/functions/network.sh
network_flush_cache
network_find_wan6 NET_IF6
network_get_prefix6 NET_PFX6 "${NET_IF6}"

#set -e
export LANG=C
expr "$NET_PFX6" : '[[:xdigit:]:]\{2,\}$' >/dev/null
echo $NET_PFX6 |grep -sqEv '[[:xdigit:]]{5}|:::|::.*::' 
cn=$(echo $NET_PFX6 |grep -o : |wc -l)
test $cn -ge 2 -a $cn -le 7
NET_PFX6=$(echo $NET_PFX6 |sed '
    s/^:/0000:/
    s/:$/:0000/
    s/.*/:&:/
    :add0
    s/:\([^:]\{1,3\}\):/:0\1:/g
    t add0
    s/:\(.*\):/\1/' )
if echo $NET_PFX6 |grep -sq :: ; then
    NET_PFX6=$(echo $NET_PFX6 |sed s/::/:$(echo -n :::::: |tail -c $((8-cn)) |sed 's/:/0000:/g')/ )
else
        test $cn -eq 7
fi
NURO_V6=`echo $NET_PFX6 |cut -b -11`


function _func_NURO_A {
INSTALL_MAP=`opkg list-installed map`
if [ ${INSTALL_MAP:0:3} = map ]; then
echo "map is installed"
else
opkg update && opkg install map
fi
echo -e " \033[1;34mパターンA (V6プラスタイプ)\033[0;39m"
# network backup
cp /etc/config/network /etc/config/network.map-e-nuro.old
cp /etc/config/network /etc/config/dhcp.map-e-nuro.old
cp /etc/config/firewall /etc/config/firewall.map-e-nuro.old
# DHCP LAN
uci set dhcp.lan=dhcp
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.dhcpv6='server'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'
# WAN
uci set network.wan.auto='1'
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
#uci add_list network.lan.dns='152.165.245.1' # dns2.nuro.jp
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
INSTALL_MAP=`opkg list-installed map`
if [ ${INSTALL_MAP:0:3} = map ]; then
echo "map is installed"
else
opkg update && opkg install map
fi
echo -e " \033[1;31mパターンB (OCNタイプ)\033[0;39m"
# network backup
cp /etc/config/network /etc/config/network.map-e-nuro.old
cp /etc/config/network /etc/config/dhcp.map-e-nuro.old
cp /etc/config/firewall /etc/config/firewall.map-e-nuro.old
# DHCP LAN
uci set dhcp.lan=dhcp
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.dhcpv6='server'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'
# WAN
uci set network.wan.auto='1'
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
uci set network.${WAN6RA}.ip6prefix=${IPV6_PREFIX}::/56
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
#uci add_list network.lan.dns='152.165.245.1' # dns2.nuro.jp
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

function _func_MULTISESSION {
echo -e " \032[1;32mマルチセッション (ニチバン対策)\033[0;39m"
cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.old
wget --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map.sh.new
}

function _func_PORT {
echo -e " \033[1;33m利用可能ポート\033[0;39m"
cat /tmp/map-wanmap.rules | awk '/PORTSETS/'
}

function _func_RECOVERY {
echo -e " \033[1;41mリカバリー\033[0;39m"
cp /etc/config/network.map-e-nuro.old /etc/config/network
cp /etc/config/dhcp.map-e-nuro.old /etc/config/dhcp
cp /etc/config/firewall.map-e-nuro.old /etc/config/firewall
#rm /etc/config/network.map-e-nuro.old
#rm /etc/config/dhcp.map-e-nuro.old
#rm /etc/config/firewall.map-e-nuro.old
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit 0
}

function _func_RECOVERY_MULTISESSION {
echo -e " \033[1;43mリカバリー マルチセッション\033[0;39m"
cp /lib/netifd/proto/map.sh.old /lib/netifd/proto/map.sh
#rm /lib/netifd/proto/map.sh.old
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit 0
}


RULE_0=240d:000f:0
RULE_1=240d:000f:1
RULE_2=240d:000f:2
RULE_3=240d:000f:3
if [ -z ${NURO_V6} ]; then
read -p " IPv6を取得出来ません"
exit 0
else
    if [ ${NURO_V6} = ${RULE_0} ] || [ ${NURO_V6} = ${RULE_1} ] || [ ${NURO_V6} = ${RULE_2} ] || [ ${NURO_V6} = ${RULE_3} ]; then
        if [ ${NURO_V6} = ${RULE_0} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:0000"
        IPV4_PREFIX="219.104.128.0"
        echo "rulr 0"
        fi
        if [ ${NURO_V6} = ${RULE_1} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:1000"
        IPV4_PREFIX="219.104.144.0"
        echo "rule 1"
        fi
        if [ ${NURO_V6} = ${RULE_2} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:2000"
        IPV4_PREFIX="219.104.160.0"
        echo "rule 2"
        fi
        if [ ${NURO_V6} = ${RULE_3} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:3000"
        IPV4_PREFIX="219.104.176.0"
        echo "rule 3"
        fi
    else
    echo  ${NURO_V6}
    read -p " 非対応のIPV6アドレスです"
    exit 0
    fi
fi

while :
do
  echo -e " \033[1;37mnuro光 MAP-eの設定を開始します\033[0;39m"
  echo -e " \033[1;37m NET_PFX6: ${NET_PFX6}\033[0;39m"
  echo -e " \033[1;37m PREFIX  : ${NURO_V6}\033[0;39m"
  echo -e " \033[1;37muro光 -----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[a]: パターンA (V6プラスタイプ)\033[0;39m"
  echo -e " \033[1;31m[b]: パターンB (OCNタイプ)\033[0;39m"
  echo -e " \033[1;32m[n]: マルチセッション (ニチバン対策)\033[0;39m" 
  echo -e " \033[1;33m[p]: 利用可能ポート確認\033[0;39m"
  echo -e " \033[1;41m[r]: リカバリー\033[0;39m"
  echo -e " \033[1;43m[m]: リカバリー マルチセッション\033[0;39m"
  echo -e " \033[7;40m[q]: 退出\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [a/b/n/p/r/m or q]: " num
  case "${num}" in
    "a" ) _func_NURO_A ;;
    "b" ) _func_NURO_B ;;
    "n" ) _func_MULTISESSION ;;
    "p" ) _func_PORT ;;
    "r" ) _func_RECOVERY ;;
    "m" ) _func_RECOVERY_MULTISESSION ;;
    "q" ) _func_PORT ;;
  esac
 done 


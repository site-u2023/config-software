#!/bin/sh
# Information provided by https://github.com/tinysun & https://qiita.com/obsolete-standard/items/e410530cecb0a21d3ecc
# Vr.4.01
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


function _func_NURO {
OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "19" ]]; then
  opkg update && opkg install map
  echo -e " \033[1;34mnuro map-e\033[0;39m"
elif [[ "${OPENWRT_RELEAS}" = "SN" ]]; then
  apk update
  apk add map
fi

# network backup
cp /etc/config/network /etc/config/network.map-e-nuro.old
cp /etc/config/network /etc/config/dhcp.map-e-nuro.old
cp /etc/config/firewall /etc/config/firewall.map-e-nuro.old
# DHCP LAN
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.dhcpv6='server'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'
# WAN
uci set network.wan.auto='1'
# DHCP WAN6
uci set dhcp.wan6=dhcp
#uci set dhcp.wan6.ignore='1'
uci set dhcp.wan6.master='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'
uci set dhcp.wan6.ndp='relay'
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
#uci set network.${WANMAP}.legacymap='1'
uci set network.${WANMAP}.mtu='1452'
uci set network.${WANMAP}.encaplimit='ignore'
#uci set network.${WANMAP}.tunlink='wan6'
# Version-specific settings
OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "SN" || "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" ]]; then
  #uci set dhcp.wan6.interface='wan6'
  uci set dhcp.wan6.ignore='1'
  uci set network.${WANMAP}.legacymap='1'
  uci set network.${WANMAP}.tunlink='wan6'
elif [[ "${OPENWRT_RELEAS}" = "19" ]]; then
  uci add_list network.${WANMAP}.tunlink='wan6'
fi
# FW
ZOON_NO='1'
uci del_list firewall.@zone[${ZOON_NO}].network='wan'
uci add_list firewall.@zone[${ZOON_NO}].network=${WANMAP}
# delete
uci -q delete dhcp.lan.dns
uci -q delete dhcp.lan.dhcp_option
# IPV4
uci add_list network.lan.dns='118.238.201.33' # dns1.nuro.jp
uci add_list network.lan.dns='152.165.245.17' # dns1.nuro.jp
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
echo -e "\033[1;32m ${WANMAP} peeraddr: \033[0;39m"${BR_ADDR}
echo -e "\033[1;32m ${WANMAP} ip4prefixlen: \033[0;39m"20
echo -e "\033[1;32m ${WANMAP} ip6pfx: \033[0;39m"${IPV6_PREFIX}::
echo -e "\033[1;32m ${WANMAP} ip6prefixlen: \033[0;39m"36
echo -e "\033[1;32m ${WANMAP} ealen: \033[0;39m"20
echo -e "\033[1;32m ${WANMAP} psidlen: \033[0;39m"8
echo -e "\033[1;32m ${WANMAP} offset: \033[0;39m"4
read -p " 何かキーを押してデバイスを再起動してください"
reboot
return 0
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
return 0
}

function _func_NICHIBAN {
cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.old
OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "SN" || "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" ]]; then
  wget --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map.sh.new
  read -p " 何かキーを押してデバイスを再起動してください"
  reboot
  return 0
elif [[ "${OPENWRT_RELEAS}" = "19" ]]; then
  wget --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map19.sh.new
  read -p " 何かキーを押してデバイスを再起動してください"
  reboot
  return 0
fi


}

function _func_NICHIBAN_PORT {
cat /tmp/map-wanmap.rules | awk '/PORTSETS/'
read -p " 何かキーを押してください"
return 0
}

function _func_NICHIBAN_RECOVERY {
cp /lib/netifd/proto/map.sh.old /lib/netifd/proto/map.sh
read -p " 何かキーを押してデバイスを再起動してください"
reboot
return 0
}

RULE_0=240d:000f:0
RULE_1=240d:000f:1
RULE_2=240d:000f:2
RULE_3=240d:000f:3

if [ -z ${NURO_V6} ]; then
    read -p " IPv6を取得出来ません"
    exit 0
else
    if [ ${NURO_V6} = ${RULE_0} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:0000"
        IPV4_PREFIX="219.104.128.0"
        echo "rulr 0"
    elif [ ${NURO_V6} = ${RULE_1} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:1000"
        IPV4_PREFIX="219.104.144.0"
        echo "rule 1"
    elif [ ${NURO_V6} = ${RULE_2} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:2000"
        IPV4_PREFIX="219.104.160.0"
        echo "rule 2"
    elif [ ${NURO_V6} = ${RULE_3} ]; then
        BR_ADDR="2001:3b8:200:ff9::1"
        IPV6_PREFIX="240d:000f:3000"
        IPV4_PREFIX="219.104.176.0"
        echo "rule 3"
    else
        echo  "${NURO_V6}"
        read -p " 未対応のIPV6アドレスです"
        exit 0
    fi
fi

while :
do
  echo -e " \033[1;37mnuro光 MAP-eの設定を開始します\033[0;39m"
  echo -e " \033[1;37mNET_PFX6: ${NET_PFX6}\033[0;39m"
  echo -e " \033[1;37mnuro光 ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[n]: nuro map-e\033[0;39m"
  echo -e " \033[1;44m[r]: nuro map-e リカバリー\033[0;39m"
  echo -e " \033[1;31m[m]: マルチセッション対応（ニチバン対策）\033[0;39m"
  echo -e " \033[1;31m[p]: 利用可能ポート確認\033[0;39m"
  echo -e " \033[1;41m[x]: マルチセッション対応（ニチバン対策）リカバリー\033[0;39m"
  echo -e " \033[7;40m[q]: 退出\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [n/r/m/p/x or q]: " num
  case "${num}" in
    "n" ) _func_NURO ;;
    "r" ) _func_RECOVERY ;;
    "m" ) _func_NICHIBAN ;;
    "p" ) _func_NICHIBAN_PORT ;;
    "x" ) _func_NICHIBAN_RECOVERY ;;
    "q" ) exit 0 ;;
  esac
done


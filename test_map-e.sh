#!/bin/sh

hextet[3]=$((${hextet[3]} & 0xff00))
if $rfc; then
  hextet[4]=0
  hextet[5]=$(( ( ${octet[0]} << 8  ) | ${octet[1]} ))
  hextet[6]=$(( ( ${octet[2]} << 8  ) | ${octet[3]} ))
  hextet[7]=$psid
else
  hextet[4]=${octet[0]}
  hextet[5]=$(( ${octet[1]} << 8 | ${octet[2]} ))
  hextet[6]=$(( ${octet[3]} << 8 ))
  hextet[7]=$(( $psid << 8 ))
fi

declare -a ce
for i in 0 1 2 3; do
  ce[$i]=$(printf %x ${hextet[$i]})
done

ealen=$(( 56 - $ip6prefixlen ))
ip4prefixlen=$(( 32 - (ealen - psidlen) ))

declare -a hextet2
if [ $ip6prefixlen -eq 38 ]; then
  hextet2[0]=${hextet[0]}
  hextet2[1]=${hextet[1]}
  hextet2[2]=$(( ${hextet[2]} & 0xfc00))
elif [ $ip6prefixlen -eq 31 ]; then
  hextet2[0]=${hextet[0]}
  hextet2[1]=$(( ${hextet[1]} & 0xfffe ))
fi

declare -a ip6prefix
for i in 0 1 2; do
  ip6prefix[$i]=$(printf %x ${hextet2[$i]})
done

prefix31_hex=$(printf 0x%x $prefix31)
if [[ $prefix31_hex -ge 0x24047a80 ]] && [[ $prefix31_hex -lt 0x24047a84 ]]; then
  peeraddr="2001:260:700:1::1:275"
elif [[ $prefix31_hex -ge 0x24047a84 ]] && [[ $prefix31_hex -lt 0x24047a88 ]]; then
  peeraddr="2001:260:700:1::1:276"
elif [[ $prefix31_hex -ge 0x240b0010 ]] && [[ $prefix31_hex -lt 0x240b0014 ]]; then
  peeraddr="2404:9200:225:100::64"
elif [[ $prefix31_hex -ge 0x240b0250 ]] && [[ $prefix31_hex -lt 0x240b0254 ]]; then
  peeraddr="2404:9200:225:100::64"
elif [ -n "${ruleprefix38_20[`printf 0x%x $prefix38`]}" ]; then
  peeraddr="2001:380:a120::9"
else
  peeraddr=""
fi

ipaddr=(${ipaddr//,/ })
ip4a="$(IFS="."; echo "${ipaddr[*]}")"
ip6pfx="$(IFS=":"; echo "${ip6prefix[*]}")" 
PFX=$new_ip6_prefix
CE="$(IFS=":"; echo "${ce[*]}")"
IPV4=${octet[0]}.${octet[1]}.${octet[2]}.${octet[3]}
PSID=$psid
BR=$peeraddr

cp /etc/config/network /etc/config/network.map-e.old
cp /etc/config/network /etc/config/dhcp.map-e.old
cp /etc/config/firewall /etc/config/firewall.map-e.old

uci set network.wan.auto='0'
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.dhcpv6='relay'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'
uci set dhcp.wan6=dhcp
uci set dhcp.wan6.master='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'
uci set dhcp.wan6.ndp='relay'

uci set network.wan6.proto='dhcpv6'
uci set network.wan6.reqaddress='try'
uci set network.wan6.reqprefix='auto'
uci set network.wan6.ip6prefix=${CE}::/64

WANMAPE='wanmape'
uci set network.${WANMAPE}=interface
uci set network.${WANMAPE}.proto='map'
uci set network.${WANMAPE}.maptype='map-e'
uci set network.${WANMAPE}.peeraddr=${peeraddr}
uci set network.${WANMAPE}.ipaddr=${ip4a}
uci set network.${WANMAPE}.ip4prefixlen=${ip4prefixlen}
uci set network.${WANMAPE}.ip6prefix=${ip6pfx}::
uci set network.${WANMAPE}.ip6prefixlen=${ip6prefixlen}
uci set network.${WANMAPE}.ealen=${ealen}
uci set network.${WANMAPE}.psidlen=${psidlen}
uci set network.${WANMAPE}.offset=${offset}
uci set network.${WANMAPE}.mtu='1460'
uci set network.${WANMAPE}.encaplimit='ignore'

ZOON_NO='1'
uci del_list firewall.@zone[${ZOON_NO}].network='wan'
uci add_list firewall.@zone[${ZOON_NO}].network=${WANMAPE}

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "SN" || "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" ]]; then
  uci set dhcp.wan6.interface='wan6'
  uci set dhcp.wan6.ignore='1'
  uci set network.${WANMAPE}.legacymap='1'
  uci set network.${WANMAPE}.tunlink='wan6'
elif [[ "${OPENWRT_RELEAS}" = "19" ]]; then
  uci add_list network.${WANMAPE}.tunlink='wan6'
fi

uci commit

echo -e "\033[1;33m wan ipaddr6: ${NET_ADDR6}\033[0;33m"
echo -e "\033[1;32m

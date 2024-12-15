#! /bin/sh

cp /etc/config/network /etc/config/network.adguard.bak
cp /etc/config/dhcp /etc/config/dhcp.adguard.bak
cp /etc/config/firewall /etc/config/firewall.adguard.bak

function _func_Package {
opkg install adguardhome
_func_Install 
}

function _func_Native {
#　Check version
mkdir -p /tmp/config-software
wget --no-check-certificate -O /tmp/config-software/AdGuardHome_list https://github.com/AdguardTeam/AdGuardHome
AdGuardHome_list=`cat /tmp/config-software/AdGuardHome_list`
latest_ver=`echo $AdGuardHome_list | awk '{print substr($0,index($0,"AdGuard Home v") ,30)}' | awk '{ sub("</span>.*$",""); print $0; }' | grep -o -E "(v[0-9]+\.){1}[0-9]+(\.[0-9]+)?" | head -n1`
echo -e " \033[1;33m Install Version : ${latest_ver}\033[0;39m"
read -p "  Press any key"
# Install
opkg install ca-bundle
mkdir -p /etc/AdGuardHome
wget --no-check-certificate -O /etc/AdGuardHome/AdGuardHome_linux_armv7.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/download/${latest_ver}/AdGuardHome_linux_armv7.tar.gz
tar -xzvf /etc/AdGuardHome/AdGuardHome_linux_armv7.tar.gz -C /etc/
rm -rf /etc/AdGuardHome/AdGuardHome_linux_armv7.tar.gz
/etc/AdGuardHome/AdGuardHome -s install
_func_Install 
}

function _func_Install {
service adguardhome enable
service adguardhome start
NET_ADDR=$(/sbin/ip -o -4 addr list br-lan | awk 'NR==1{ split($4, ip_addr, "/"); print ip_addr[1] }')
NET_ADDR6=$(/sbin/ip -o -6 addr list br-lan scope global | awk 'NR==1{ split($4, ip_addr, "/"); print ip_addr[1] }')
echo "Router IPv4 : ""${NET_ADDR}"
echo "Router IPv6 : ""${NET_ADDR6}"
uci set dhcp.@dnsmasq[0].noresolv="0"
uci set dhcp.@dnsmasq[0].cachesize="1000"
uci set dhcp.@dnsmasq[0].rebind_protection='0'
uci set dhcp.@dnsmasq[0].port="54"
uci -q delete dhcp.@dnsmasq[0].server
uci add_list dhcp.@dnsmasq[0].server="${NET_ADDR}"
uci -q delete dhcp.lan.dhcp_option
uci -q delete dhcp.lan.dns
uci add_list dhcp.lan.dhcp_option='6,'"${NET_ADDR}" 
uci add_list dhcp.lan.dhcp_option='3,'"${NET_ADDR}"
for OUTPUT in $(ip -o -6 addr list br-lan scope global | awk '{ split($4, ip_addr, "/"); print ip_addr[1] }')
do
	echo "Adding $OUTPUT to IPV6 DNS"
	uci add_list dhcp.lan.dns=$OUTPUT
done
uci commit dhcp
/etc/init.d/dnsmasq restart

uci set firewall.adguardhome_dns_53='redirect'
uci set firewall.adguardhome_dns_53.src='lan'
uci set firewall.adguardhome_dns_53.proto='tcp udp'
uci set firewall.adguardhome_dns_53.src_dport='53'
uci set firewall.adguardhome_dns_53.target='DNAT'
uci set firewall.adguardhome_dns_53.name='Adguard Home'
uci set firewall.adguardhome_dns_53.dest='lan'
uci set firewall.adguardhome_dns_53.dest_port='53'

uci set firewall.adguardhome_dns_53.family="any"
uci commit firewall
/etc/init.d/firewall restart
exit
}

UPDATE="/tmp/opkg-lists/openwrt_telephony"
if [ ! -e ${UPDATE} ]; then
opkg update
fi

while :
do
  echo -e " \033[1;34m[p]: Package install\033[0;39m"
  echo -e " \033[1;33m[n]: Native install\033[0;39m"
  read -p " Which do you install [p or n]: " num
  case "${num}" in
    "p" ) _func_Package ;;
    "n" ) _func_Native ;;
  esac
 done

#!/bin/ash
# Check version
TMP_DIR="/tmp/config-software"
ADGUARD_URL="https://github.com/AdguardTeam/AdGuardHome"
mkdir -p "$TMP_DIR"
echo -e "\033[1;34m[INFO]\033[0;39m Downloading AdGuardHome list..."
if wget --no-check-certificate -O "$TMP_DIR/AdGuardHome_list" "$ADGUARD_URL"; then
    latest_ver=$(grep -o -E "AdGuard Home v[0-9]+\.[0-9]+(\.[0-9]+)?" "$TMP_DIR/AdGuardHome_list" | head -n1 | grep -o -E "v[0-9]+\.[0-9]+(\.[0-9]+)?")   
    if [ -n "$latest_ver" ]; then
        echo -e "\033[1;33mInstall Version: ${latest_ver}\033[0;39m"
        read -p "Press any key to continue..."
    else
        echo -e "\033[1;31m[ERROR]\033[0;39m Failed to parse version information from AdGuardHome list."
    fi
else
    echo -e "\033[1;31m[ERROR]\033[0;39m Failed to download AdGuardHome list from $ADGUARD_URL."
fi
rm -rf "$TMP_DIR"
# Install
opkg update
opkg install ca-bundle
mkdir -p /etc/AdGuardHome
wget --no-check-certificate -O /etc/AdGuardHome/AdGuardHome_linux_armv7.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/download/${latest_ver}/AdGuardHome_linux_armv7.tar.gz
tar -xzvf /etc/AdGuardHome/AdGuardHome_linux_armv7.tar.gz -C /etc/
rm -rf /etc/AdGuardHome/AdGuardHome_linux_armv7.tar.gz
/etc/AdGuardHome/AdGuardHome -s install
/etc/init.d/AdGuardHome enable
/etc/init.d/AdGuardHome start
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

#! /bin/sh

# scripts
. /lib/functions/network.sh
network_flush_cache
network_find_wan6 NET_IF6
network_get_physdev NET_L2D6 "${NET_IF6}"
# network_find_wan NET_IF
# network_get_physdev NET_L2D "${NET_IF}"

# ネットワークを変更する
cp /etc/config/network /etc/config/network.dump.bak
cp /etc/config/dhcp /etc/config/dhcp.dump.bak
cp /etc/config/firewall /etc/config/firewall.dump.bak
cp /etc/config/wireless /etc/config/wireless.dump.bak
uci add_list network.@device[0].ports=${NET_L2D6}
uci delete network.wan
uci delete network.wan6
uci delete network.lan
uci -q delete network.globals.ula_prefix

uci commit

# IPV4
BRIDGE='lan'
uci set network.${BRIDGE}=interface
uci set network.${BRIDGE}.proto='static'
uci set network.${BRIDGE}.device='br-lan'
uci set network.${BRIDGE}.ipaddr='192.168.1.2'
uci set network.${BRIDGE}.netmask='255.255.255.0'
uci set network.${BRIDGE}.gateway='192.168.1.1'
uci set network.${BRIDGE}.dns='192.168.1.1'
uci set network.${BRIDGE}.delegate='0'

# IPV6
BRIDGE6='lan6'
uci set network.${BRIDGE6}=interface
uci set network.${BRIDGE6}.proto='dhcpv6'
uci set network.${BRIDGE6}.device='@br-lan'
uci set network.${BRIDGE6}.reqaddress='try'
uci set network.${BRIDGE6}.reqprefix='no'
uci set network.${BRIDGE6}.type='bridge'

# 既存のワイヤレスネットワークを変更する
uci set wireless.default_radio0.network=${BRIDGE}
uci set wireless.default_radio1.network=${BRIDGE}

# NTPサーバー
uci delete system.ntp.server
uci set system.ntp=timeserver
uci set system.ntp.enable_server='0'
uci set system.ntp.use_dhcp='1'
uci set system.ntp.server='192.168.1.1'

uci commit

# DHCPサーバーを無効にする
/etc/init.d/odhcpd disable
/etc/init.d/odhcpd stop

# DNSを無効にする
/etc/init.d/dnsmasq disable
/etc/init.d/dnsmasq stop

# ファイアウォールを無効にする
/etc/init.d/firewall disable
/etc/init.d/firewall stop

# マルチキャスト
uci set network.globals.packet_steering='1'
uci set network.globals.igmp_snooping='1'

# wpa_supplicantを無効にする
rm /usr/sbin/wpa_supplicant

# {
# デーモンを永続的に無効にする
# for i in firewall dnsmasq odhcpd; do
#   if /etc/init.d/"$i" enabled; then
#     /etc/init.d/"$i" disable
#     /etc/init.d/"$i" stop
#   fi
# done
# }

# 複数の AP にわたってホスト名を表示できるようにする
opkg update
opkg install fping
sed -i "/exit 0/d" /etc/rc.local
echo "fping -g 192.168.1.0/24" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local
echo "0 */1 * * * fping -g 192.168.1.0/24" >> /etc/crontabs/root

echo -e "\033[1;35m ${BRIDGE} device: \033[0;39m"${NET_L2D6}

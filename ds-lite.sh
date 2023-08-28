#!/bin/sh

# network backup
cp /etc/config/network /etc/config/network.old

# DHCP LAN
uci set dhcp.lan=dhcp
uci set dhcp.lan.dhcpv6='server'
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'

# DHCP WAN6
uci set dhcp.wan6=dhcp
uci set dhcp.wan6.interface='wan6'
uci set dhcp.wan6.ignore='1'
uci set dhcp.wan6.master='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'
uci set dhcp.wan6.ndp='relay'

# DS-LITE
DSLITE='ds_lite'
uci set network.${DSLITE}=interface
uci set network.${DSLITE}.proto='dslite'
uci set network.${DSLITE}.peeraddr='AFTR_ADDRESS'
uci set network.${DSLITE}.encaplimit='ignore'

# FW
ZOON_NO='1'
uci add_list firewall.@zone[${ZOON_NO}].network=${DSLITE}

uci commit

cp /lib/netifd/proto/dslite /lib/netifd/proto/dslite.sh.sh.old
sed -i -e "s/mtu:-1280/mtu:-1460/g" /lib/netifd/proto/dslite.sh

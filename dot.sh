#! /bin/sh

opkg update
opkg install stubby
/etc/init.d/dnsmasq stop
uci set dhcp.@dnsmasq[0].noresolv="1"
uci set dhcp.@dnsmasq[0].localuse="1"
uci -q delete dhcp.@dnsmasq[0].server
uci -q get stubby.global.listen_address \
| sed -e "s/\s/\n/g;s/@/#/g" \
| while read -r STUBBY_SERV
do uci add_list dhcp.@dnsmasq[0].server="${STUBBY_SERV}"
done

uci set network.wan.peerdns='0'
uci set network.wan.dns='127.0.0.1'
uci set network.wan6.peerdns='0'
uci set network.wan6.dns='0::1'
uci commit
/etc/init.d/dnsmasq start
/etc/init.d/network reload
# ブート失敗対策
sed -i "/exit 0/d" /etc/rc.local
echo "/etc/init.d/stubby restart" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local 


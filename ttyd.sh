#!/bin/sh

cat <<"EOF" >> /usr/bin/confsoft
#!/bin/sh
mkdir -p /etc/config-software
wget --no-check-certificate -O /etc/config-software/openwrt-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/openwrt-config.sh
sh /etc/config-software/openwrt-config.sh
EOF
chmod +x /usr/bin/confsoft

opkg update
opkg install ttyd
opkg install luci-app-ttyd

uci set ttyd.@ttyd[0]=ttyd
uci set ttyd.@ttyd[0].interface='@lan'
uci set ttyd.@ttyd[0].command='/bin/login -f root'
uci set ttyd.@ttyd[0].ipv6='1'
uci set ttyd.@ttyd[0].debug='7'
uci set ttyd.@ttyd[0].url_arg='1'
uci add_list ttyd.@ttyd[0].client_option='fontSize=25'
uci add_list ttyd.@ttyd[0].client_option='theme={"background": "black"}'
uci add_list ttyd.@ttyd[0].client_option='titleFixed=ttyd'
uci set ttyd.ttyd=ttyd
uci set ttyd.ttyd.port='8888'
uci set ttyd.ttyd.interface='@lan'
uci set ttyd.ttyd.ipv6='1'
uci set ttyd.ttyd.debug='7'
uci set ttyd.ttyd.command='confsoft'
uci set ttyd.ttyd.url_arg='1'
uci add_list ttyd.ttyd.client_option='fontSize=25'
uci add_list ttyd.ttyd.client_option='theme={"background": "blue"}'
uci add_list ttyd.ttyd.client_option='titleFixed=config-software'

uci commit ttyd
service ttyd enable
#/etc/init.d/rpcd restart

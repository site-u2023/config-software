#! /bin/sh

# Device Password
ubus call luci setPassword '{ "username": "root", "password": "ROOT_PASSWD" }'

# SSH access interface
uci set dropbear.@dropbear[0].Interface='lan'
uci commit dropbear

# system setup
HOSTNAME='openwrt' # Router Name
DESCRIPTION=`cat /etc/openwrt_version` # Description
NOTES=`date` # Remarks
uci set system.@system[0]=system
uci set system.@system[0].hostname=${HOSTNAME}
uci set system.@system[0].description="${DESCRIPTION}"
uci set system.@system[0].zonename='UTC'
uci set system.@system[0].conloglevel='6' # Log output level: caution
uci set system.@system[0].cronloglevel='9' # Cron log level: warning
# NTP server
uci set system.ntp.enable_server='1'
uci set system.ntp.use_dhcp='0'
uci set system.ntp.interface='lan'
uci delete system.ntp.server
uci add_list system.ntp.server='0.pool.ntp.org'
uci add_list system.ntp.server='1.pool.ntp.org'
uci add_list system.ntp.server='2.pool.ntp.org' 
uci add_list system.ntp.server='3.pool.ntp.org'
uci commit system
/etc/init.d/system reload
/etc/init.d/sysntpd restart
# note
uci set system.@system[0].notes="${NOTES}"
uci commit system
/etc/init.d/system reload

# Software flow offload
uci set firewall.@defaults[0].flow_offloading='1'
uci commit firewall
# /etc/init.d/firewall restart

# Hardware flow offload
Hardware_flow_offload=`grep 'mediatek' /etc/openwrt_release`
if [ "${Hardware_flow_offload:16:8}" = "mediatek" ]; then
 uci set firewall.@defaults[0].flow_offloading_hw='1'
 uci commit firewall
 # /etc/init.d/firewall restart
fi

# packet steering
uci set network.globals.packet_steering='1'
uci commit network

# custom DNS
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
#
uci set dhcp.@dnsmasq[0].cachesize='2000'
#
uci set dhcp.lan.leasetime='24h'
# set
uci commit dhcp
# /etc/init.d/dnsmasq restart
# /etc/init.d/odhcpd restart

# Wi-Fi A channels
COUNTRY='Country_Code'
WIFI_SSID_A='SSID_A'
WIFI_PASSWORD_A='password'
uci set wireless.radio0.country=${COUNTRY}
uci set wireless.radio0.txpower='10'
# uci set wireless.radio0.noscan='1'
uci set wireless.radio0.frag='2347'
uci set wireless.radio0.rts='2346'
uci set wireless.radio0.cell_density='1'
uci set wireless.default_radio0.encryption='sae-mixed'
uci set wireless.default_radio0.ssid=${WIFI_SSID_A}
uci set wireless.default_radio0.key=${WIFI_PASSWORD_A}
uci set wireless.default_radio0.multicast_to_unicast='1'
uci set wireless.default_radio0.isolate='1'
uci set wireless.default_radio0.multicast_to_unicast_all='1'
uci set wireless.default_radio0.macaddr='random' # Random Mac Address
# uci set wireless.default_radio0.wpa_disable_eapol_key_retries='1'
# Wi-Fi B channel
COUNTRY='Country_Code'
WIFI_SSID_B='SSID_B'
WIFI_PASSWORD_B='password'
uci set wireless.radio1.country=${COUNTRY}
uci set wireless.radio1.txpower='10'
# uci set wireless.radio1.noscan='1'
uci set wireless.radio1.frag='2347'
uci set wireless.radio1.rts='2346'
uci set wireless.radio1.cell_density='1'
uci set wireless.default_radio1.encryption='sae-mixed'
uci set wireless.default_radio1.ssid=${WIFI_SSID_B}
uci set wireless.default_radio1.key=${WIFI_PASSWORD_B}
uci set wireless.default_radio1.multicast_to_unicast='1'
uci set wireless.default_radio1.isolate='1'
uci set wireless.default_radio1.multicast_to_unicast_all='1'
uci set wireless.default_radio1.macaddr='random' # Random Mac Address
# uci set wireless.default_radio1.wpa_disable_eapol_key_retries='1'
# Wi-Fi C channel
COUNTRY='Country_Code'
WIFI_SSID_C='SSID_C'
WIFI_PASSWORD_C='password'
uci set wireless.radio2.country=${COUNTRY}
uci set wireless.radio2.txpower='10'
# uci set wireless.radio2.noscan='1'
uci set wireless.radio2.frag='2347'
uci set wireless.radio2.rts='2346'
uci set wireless.radio2.cell_density='1'
uci set wireless.default_radio2.encryption='sae-mixed'
uci set wireless.default_radio2.ssid=${WIFI_SSID_C}
uci set wireless.default_radio2.key=${WIFI_PASSWORD_C}
uci set wireless.default_radio2.multicast_to_unicast='1'
uci set wireless.default_radio2.isolate='1'
uci set wireless.default_radio2.multicast_to_unicast_all='1'
uci set wireless.default_radio2.macaddr='random' # Random Mac Address
# uci set wireless.default_radio1.wpa_disable_eapol_key_retries='1'
# set
uci delete wireless.radio0.disabled
uci delete wireless.radio1.disabled
uci delete wireless.radio2.disabled
uci commit wireless
# /etc/init.d/network restart

# PING Destination
uci set luci.diag.dns='one.one.one.one'
uci set luci.diag.ping='one.one.one.one'
uci set luci.diag.route='one.one.one.one'
uci commit luci
# /etc/init.d/rpcd reload

# CRON (reboot)
echo "00 04 * * * sleep 70 && touch /etc/banner && reboot" >> /etc/crontabs/root
# /etc/init.d/cron restart

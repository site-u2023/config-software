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
ZOONNAME='UTC'
TIMEZOON='JST-9'

uci set system.@system[0]=system
uci set system.@system[0].hostname=${HOSTNAME}
uci set system.@system[0].description="${DESCRIPTION}"
uci set system.@system[0].zonename=${ZOONNAME}
uci set system.@system[0].timezone=${TIMEZOON}
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

COUNTRY='Country_Code'
# Wi-Fi A channels
RADIO_A='radio'
WIFI_SSID_A='SSID_A'
WIFI_PASSWORD_A='password'
uci set wireless.${RADIO_A}.country=${COUNTRY}
uci set wireless.${RADIO_A}.txpower='10'
# uci set wireless.${RADIO_A}.noscan='1'
uci set wireless.${RADIO_A}.frag='2347'
uci set wireless.${RADIO_A}.rts='2346'
uci set wireless.${RADIO_A}.cell_density='1'
uci set wireless.default_${RADIO_A}.encryption='sae-mixed'
uci set wireless.default_${RADIO_A}.ssid=${WIFI_SSID_A}
uci set wireless.default_${RADIO_A}.key=${WIFI_PASSWORD_A}
uci set wireless.default_${RADIO_A}.multicast_to_unicast='1'
uci set wireless.default_${RADIO_A}.isolate='1'
uci set wireless.default_${RADIO_A}.multicast_to_unicast_all='1'
uci set wireless.default_${RADIO_A}.macaddr='random' # Random Mac Address
# uci set wireless.default_${RADIO_A}.wpa_disable_eapol_key_retries='1'
# Wi-Fi AA channels
RADIO_AA='radio'
WIFI_SSID_AA='SSID_AA'
WIFI_PASSWORD_AA='password'
uci set wireless.${RADIO_AA}.country=${COUNTRY}
uci set wireless.${RADIO_AA}.txpower='10'
# uci set wireless.${RADIO_AA}.noscan='1'
uci set wireless.${RADIO_AA}.frag='2347'
uci set wireless.${RADIO_AA}.rts='2346'
uci set wireless.${RADIO_AA}.cell_density='1'
uci set wireless.default_${RADIO_AA}.encryption='sae-mixed'
uci set wireless.default_${RADIO_AA}.ssid=${WIFI_SSID_AA}
uci set wireless.default_${RADIO_AA}.key=${WIFI_PASSWORD_AA}
uci set wireless.default_${RADIO_AA}.multicast_to_unicast='1'
uci set wireless.default_${RADIO_AA}.isolate='1'
uci set wireless.default_${RADIO_AA}.multicast_to_unicast_all='1'
uci set wireless.default_${RADIO_AA}.macaddr='random' # Random Mac Address
# uci set wireless.default_${RADIO_AA}.wpa_disable_eapol_key_retries='1'
# Wi-Fi B channel
RADIO_B='radio'
WIFI_SSID_B='SSID_B'
WIFI_PASSWORD_B='password'
uci set wireless.${RADIO_B}.country=${COUNTRY}
uci set wireless.${RADIO_B}.txpower='10'
# uci set wireless.${RADIO_B}.noscan='1'
uci set wireless.${RADIO_B}.frag='2347'
uci set wireless.${RADIO_B}.rts='2346'
uci set wireless.${RADIO_B}.cell_density='1'
uci set wireless.default_${RADIO_B}.encryption='sae-mixed'
uci set wireless.default_${RADIO_B}.ssid=${WIFI_SSID_B}
uci set wireless.default_${RADIO_B}.key=${WIFI_PASSWORD_B}
uci set wireless.default_${RADIO_B}.multicast_to_unicast='1'
uci set wireless.default_${RADIO_B}.isolate='1'
uci set wireless.default_${RADIO_B}.multicast_to_unicast_all='1'
uci set wireless.default_${RADIO_B}.macaddr='random' # Random Mac Address
# uci set wireless.default_${RADIO_B}.wpa_disable_eapol_key_retries='1'
# Wi-Fi BB channel
RADIO_BB='radio'
WIFI_SSID_BB='SSID_BB'
WIFI_PASSWORD_BB='password'
uci set wireless.${RADIO_BB}.country=${COUNTRY}
uci set wireless.${RADIO_BB}.txpower='10'
# uci set wireless.${RADIO_BB}.noscan='1'
uci set wireless.${RADIO_BB}.frag='2347'
uci set wireless.${RADIO_BB}.rts='2346'
uci set wireless.${RADIO_BB}.cell_density='1'
uci set wireless.default_${RADIO_BB}.encryption='sae-mixed'
uci set wireless.default_${RADIO_BB}.ssid=${WIFI_SSID_BB}
uci set wireless.default_${RADIO_BB}.key=${WIFI_PASSWORD_BB}
uci set wireless.default_${RADIO_BB}.multicast_to_unicast='1'
uci set wireless.default_${RADIO_BB}.isolate='1'
uci set wireless.default_${RADIO_BB}.multicast_to_unicast_all='1'
uci set wireless.default_${RADIO_BB}.macaddr='random' # Random Mac Address
# uci set wireless.default_${RADIO_BB}.wpa_disable_eapol_key_retries='1'
# Wi-Fi C channel
RADIO_C='radio'
WIFI_SSID_C='SSID_C'
WIFI_PASSWORD_C='password'
uci set wireless.${RADIO_C}.country=${COUNTRY}
uci set wireless.${RADIO_C}.txpower='10'
# uci set wireless.${RADIO_C}.noscan='1'
uci set wireless.${RADIO_C}.frag='2347'
uci set wireless.${RADIO_C}.rts='2346'
uci set wireless.${RADIO_C}.cell_density='1'
uci set wireless.default_${RADIO_C}.encryption='sae-mixed'
uci set wireless.default_${RADIO_C}.ssid=${WIFI_SSID_C}
uci set wireless.default_${RADIO_C}.key=${WIFI_PASSWORD_C}
uci set wireless.default_${RADIO_C}.multicast_to_unicast='1'
uci set wireless.default_${RADIO_C}.isolate='1'
uci set wireless.default_${RADIO_C}.multicast_to_unicast_all='1'
uci set wireless.default_${RADIO_C}.macaddr='random' # Random Mac Address
# uci set wireless.default_${RADIO_C}.wpa_disable_eapol_key_retries='1'
# Wi-Fi CC channel
RADIO_CC='radio'
WIFI_SSID_CC='SSID_CC'
WIFI_PASSWORD_CC='password'
uci set wireless.${RADIO_CC}.country=${COUNTRY}
uci set wireless.${RADIO_CC}.txpower='10'
# uci set wireless.${RADIO_CC}.noscan='1'
uci set wireless.${RADIO_CC}.frag='2347'
uci set wireless.${RADIO_CC}.rts='2346'
uci set wireless.${RADIO_CC}.cell_density='1'
uci set wireless.default_${RADIO_CC}.encryption='sae-mixed'
uci set wireless.default_${RADIO_CC}.ssid=${WIFI_SSID_CC}
uci set wireless.default_${RADIO_CC}.key=${WIFI_PASSWORD_CC}
uci set wireless.default_${RADIO_CC}.multicast_to_unicast='1'
uci set wireless.default_${RADIO_CC}.isolate='1'
uci set wireless.default_${RADIO_CC}.multicast_to_unicast_all='1'
uci set wireless.default_${RADIO_CC}.macaddr='random' # Random Mac Address
# uci set wireless.default_${RADIO_C}.wpa_disable_eapol_key_retries='1'
# set
uci delete wireless.${RADIO_A}.disabled
uci delete wireless.default_${RADIO_A}.disabled
uci delete wireless.${RADIO_AA}.disabled
uci delete wireless.default_${RADIO_AA}.disabled
uci delete wireless.${RADIO_B}.disabled
uci delete wireless.default_${RADIO_B}.disabled
uci delete wireless.${RADIO_BB}.disabled
uci delete wireless.default_${RADIO_BB}.disabled
uci delete wireless.${RADIO_C}.disabled
uci delete wireless.default_${RADIO_C}.disabled
uci delete wireless.${RADIO_CC}.disabled
uci delete wireless.default_${RADIO_CC}.disabled
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

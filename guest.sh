#!/bin/sh


cat << "EOF" > /etc/init.d/wifi_guest
#!/bin/bash /etc/rc.common

TYPE="WPA2"
TRDISABLE="1"
SSID="guest_optout_nomap"
ENCRYPTION="psk2"

START=99
STOP=01

start() {
    echo $TYPE > /tmp/.guest_type
    echo $SSID > /tmp/.guest_ssid
    PASSWORD=`date | md5sum | head -c 8; echo;`
    echo $PASSWORD > /tmp/.guest_password
    qrencode --foreground=0000FF -o /www/wifi.svg -t SVG "WIFI:T:${TYPE};R:${TRDISABLE};S:${SSID};P:${PASSWORD};;" 
    echo If you do not wish to use guest Wi-Fi, > /tmp/.guest_comment
    echo please deactivate the service on your device. > /tmp/.guest_comment2
    WIFI_DEV="$(uci get wireless.@wifi-iface[0].device)"
    uci -q delete wireless.guest
    uci set wireless.guest="wifi-iface"
    uci set wireless.guest.device="${WIFI_DEV}"
    uci set wireless.guest.mode="ap"
    uci set wireless.guest.network="lan"
    uci set wireless.guest.ssid="${SSID}"
    uci set wireless.guest.encryption="${ENCRYPTION}"
    uci set wireless.guest.key="${PASSWORD}"
    uci set wireless.guest.macaddr="random"
    uci set wireless.guest.multicast_to_unicast_all='1'
    uci set wireless.guest.isolate='1'
    uci delete wireless.${WIFI_DEV}.disabled
    uci commit wireless
    wifi reload
    logger "perimeter Wi-Fi Guest ON"
    exit 0
}
restart() {
    echo $TYPE > /tmp/.guest_type
    echo $SSID > /tmp/.guest_ssid
    PASSWORD=`date | md5sum | head -c 8; echo;`
    echo $PASSWORD > /tmp/.guest_password
    qrencode --foreground=0000FF -o /www/wifi.svg -t SVG "WIFI:T:${TYPE};R:${TRDISABLE};S:${SSID};P:${PASSWORD};;" 
    echo If you do not wish to use guest Wi-Fi, > /tmp/.guest_comment
    echo please deactivate the service on your device. > /tmp/.guest_comment2
    uci set wireless.guest.key="${PASSWORD}"
    uci commit wireless
    wifi reload
    logger "perimeter Wi-Fi Guest RESTART"
    exit 0
}
stop() {
    echo CURRENTLY CLOSED > /tmp/.guest_type
    echo > /tmp/.guest_ssid
    echo > /tmp/.guest_password
    qrencode --foreground=FF0000 -o /www/wifi.svg -t SVG "Guest service is suspended"
    echo If you wish to use Guest Wi-Fi, > /tmp/.guest_comment
    echo please activate the service on your device. > /tmp/.guest_comment2
    uci -q delete wireless.guest
    uci commit wireless
    wifi reload
    logger "perimeter Wi-Fi Guest OFF"
    exit 0
}
EOF
chmod +x /etc/init.d/wifi_guest
service wifi_guest enable
service wifi_guest start


cat << "EOF" > /www/cgi-bin/wifi_guest_qr
#!/bin/bash

TYPE=$(</tmp/.guest_type)
SSID=$(</tmp/.guest_ssid)
PASSWORD=$(</tmp/.guest_password)
COMMENT=$(</tmp/.guest_comment)
COMMENT2=$(</tmp/.guest_comment2)

echo "Content-Type: text/html"
echo ""
echo "<!DOCTYPE html>"
echo '<html lang="UTF-8">'
echo "<head>"
echo "<title>Wi-Fi Guest</title>"
echo '<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0">'
echo '<meta http-equiv="refresh" content="360" />'
echo "</head>"
echo '<body bgcolor="blue">'
echo "<div style='text-align:center;color:#fff;font-family:UnitRoundedOT,Helvetica Neue,Helvetica,Arial,sans-serif;font-size:28px;font-weight:500;'>"
echo "<h1>Guest Wi-Fi</h1>"
echo "<p><b><font color="yellow">${COMMENT}</font></b></p>"
echo "<p><b><font color="yellow">${COMMENT2}</font></b></p>"
echo '<img src=../wifi.svg style="width:33%"></img><br>'
echo "<p><b>${TYPE}</b></p>"
echo "<p><b>${SSID}</b></p>"
echo "<p><b>${PASSWORD}</b></p>"
echo "</div>"
echo "</body>"
echo "</html>"
EOF
chmod +x /www/cgi-bin/wifi_guest_qr

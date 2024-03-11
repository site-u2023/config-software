#!/bin/sh

cat << "EOF" > /etc/init.d/wifi_guest
#!/bin/bash /etc/rc.common

SSID="guest"
SECURITY="WPA2"
ENCRYPTION="psk2"

START=99
STOP=01

start() {
    PASSWORD=`date | md5sum | head -c 8; echo;`
    echo $PASSWORD > /tmp/.guest_password
    qrencode -o /www/wifi.svg -t SVG "WIFI:S:${SSID};T:${SECURITY};P:${PASSWORD};;"  
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
    PASSWORD=`date | md5sum | head -c 8; echo;`
    echo $PASSWORD > /tmp/.guest_password
    qrencode -o /www/wifi.svg -t SVG "WIFI:S:${SSID};T:${SECURITY};P:${PASSWORD};;"  
    uci set wireless.guest.key="${PASSWORD}"
    uci commit wireless
    wifi reload
    logger "perimeter Wi-Fi Guest RESTART"
    exit 0
}
stop() {
    qrencode -o /www/wifi.svg -t SVG "Guest service is suspended."
    echo Service STOP > /tmp/.guest_password
    uci -q delete wireless.guest
    uci commit wireless
    wifi reload
    logger "perimeter Wi-Fi Guest OFF"
    exit 0
}

EOF
chmod +x /etc/init.d/wifi_guest


cat << "EOF" > /www/cgi-bin/wifi_guest_qr
#!/bin/bash

PASSWORD=$(</tmp/.guest_password)

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
echo "<p>SSID: <b>guest</b></p>"
echo "<p>PASSWORD: <b>${PASSWORD}</b></p>"
echo '<img src=../wifi.svg style="width:25%"></img><br>'
echo "<p>The password is randomly changed when the service is started or restarted.</b></p>"
echo "</div>"
echo "</body>"
echo "</html>"
EOF
chmod +x /www/cgi-bin/wifi_guest_qr


#!/bin/sh


cat << "EOF" > /etc/init.d/guest_wifi
#!/bin/bash /etc/rc.common

TYPE="WPA2"
TRDISABLE="1"
SSID_F="guest@"
SSID_B="_optout_nomap"
ENCRYPTION="psk-mixed"
TIMEOUT="60"
INTERFACE="lan"

START=99
STOP=01

start() {
    DEL=`atq | awk '{ print $1 }' | sed -n 1p`
    if [ ${DEL} ]; then
    atrm ${DEL}
    fi
    echo "Please disable the service don't use guest Wi-Fi." > /tmp/.guest_comment1
    echo ${TYPE} > /tmp/.guest_type
    echo "service guest_wifi stop" | at now +${TIMEOUT} minutes
    TIMEOUT_SSID=""${SSID_F}"`atq | awk '{ print $5 }' | cut -d':' -f1,2`${SSID_B}"
    echo ${TIMEOUT_SSID} > /tmp/.guest_ssid
    RANDOM_PASSWORD=`openssl rand -base64 6`
    echo $RANDOM_PASSWORD > /tmp/.guest_password
    FOREGROUND=`openssl rand -hex 3`
    qrencode --foreground=${FOREGROUND} --inline --type=SVG --output=- --size 4 "WIFI:S:${TIMEOUT_SSID};T:${TYPE};R:${TRDISABLE};P:${RANDOM_PASSWORD};;" > /tmp/.guest_qr
    echo "<font color="yellow">Stops after "${TIMEOUT}" min.</font>" > /tmp/.guest_comment2
    WIFI_DEV="$(uci get wireless.@wifi-iface[0].device)"
    uci -q delete wireless.guest
    uci set wireless.guest="wifi-iface"
    uci set wireless.guest.device="${WIFI_DEV}"
    uci set wireless.guest.mode="ap"
    uci set wireless.guest.network="${INTERFACE}"
    uci set wireless.guest.ssid="${TIMEOUT_SSID}"
    uci set wireless.guest.encryption="${ENCRYPTION}"
    uci set wireless.guest.key="${RANDOM_PASSWORD}"
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
    exit 0
}
stop() {
    DEL=`atq | awk '{ print $1 }' | sed -n 1p`
    if [ ${DEL} ]; then
    atrm ${DEL}
    fi
    echo "Please enable the service to use guest Wi-Fi." > /tmp/.guest_comment1
    qrencode --foreground="808080" --background="0000FF" --inline --type=SVG --output=- --size 4 "WIFI:S:Out of service.;T:${TYPE};R:${TRDISABLE};P:Out of service.;;" > /tmp/.guest_qr
    echo "<font color="red">Out of service.</font>"  > /tmp/.guest_comment2
    echo > /tmp/.guest_type
    echo > /tmp/.guest_ssid
    echo > /tmp/.guest_password
    uci -q delete wireless.guest
    uci commit wireless
    wifi reload
    logger "perimeter Guest Wi-Fi OFF"
    exit 0
}
EOF
chmod +x /etc/init.d/guest_wifi


cat << "EOF" > /www/cgi-bin/guest
#!/bin/bash

QR=$(</tmp/.guest_qr)
SSID=$(</tmp/.guest_ssid)
PASSWORD=$(</tmp/.guest_password)
COMMENT1=$(</tmp/.guest_comment1)
COMMENT2=$(</tmp/.guest_comment2)
TIMEOUT=`atq | awk '{ print $5 }' | cut -d':' -f1,2`

echo "Content-Type: text/html"
echo ""
echo "<!DOCTYPE html>"
echo '<html lang="en">'
echo "<head>"
echo "<title>Guest Wi-Fi</title>"
echo '<meta charset="UTF-8" name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0">'
echo '<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">'
echo '<meta http-equiv="Pragma" content="no-cache">'
echo '<meta http-equiv="Expires" content="0">'
echo "</head>"
echo '<body bgcolor="blue">'
echo "<div style='text-align:center;color:#fff;font-family:UnitRoundedOT,Helvetica Neue,Helvetica,Arial,sans-serif;font-size:28px;font-weight:500;'>"
echo "<h1>Guest Wi-Fi</h1>"
echo "<p><font>${COMMENT1}</font></p>"
echo "<p>${QR}</p>"
echo "<p>${COMMENT2}</p>"
echo "<p>${SSID}</p>"
echo "<p>${PASSWORD}</p>"
echo "</div>"
echo "</body>"
echo "</html>"
EOF
chmod +x /www/cgi-bin/guest


cat << "EOF" > /www/guest.html
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta http-equiv="refresh" content="0; URL=cgi-bin/guest" />
</head>
<body>
<a href="cgi-bin/guest/style.css?ver=240313" rel="stylesheet">Guest Wi-Fi</a>
</body>
</html>
EOF
chmod +r /www/guest.html
echo -e " \033[1;37mIf a white QR code appears, it's a miracle.\033[0;39m"

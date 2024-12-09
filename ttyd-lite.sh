#!/bin/sh

cat <<"EOF" >> /usr/bin/confsoft
#!/bin/sh
mkdir -p /etc/config-software
wget --no-check-certificate -O /etc/config-software/openwrt-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/openwrt-config.sh
sh /etc/config-software/openwrt-config.sh
EOF
chmod +x /usr/bin/confsoft

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "19" ]]; then
  UPDATE="/tmp/opkg-lists/openwrt_telephony"
  if [ ! -e ${UPDATE} ]; then
    opkg update
  fi
    opkg install ttyd
elif if [[ "${OPENWRT_RELEAS}" = "SN" ]]; then
  apk update
  apk add ttyd
fi



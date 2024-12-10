#! /bin/sh
# OpenWrt >= 21.02:

function _func_INSTALL {
if [ -e ${UPDATE} ]; then
apk update
UPDATE="1"
fi
mkdir -p /etc/config-software/list-installed
echo 0 > /etc/config-software/list-installed/Flash
apk info | awk '{ print $1 }' > /etc/config-software/list-installed/Before

cat << EOF > /etc/config-software/list-installed/Before
luci
luci-ssl
dashboard
openssh-sftp-server
luci-app-ttyd
coreutils
irqbalance
sqm-scripts
luci-app-sqm
luci-app-statistics
nlbwmon
luci-app-nlbwmon
wifischedule
luci-app-wifischedule
luci-theme-openwrt
luci-theme-material
luci-theme-openwrt-2020
attendedsysupgrade-common
luci-app-attendedsysupgrade
luci-app-log-viewer
luci-app-cpu-perf
luci-app-temp-status
internet-detector
luci-app-internet-detector
luci-theme-argon
EOF

# LuCi
apk add luci
# LiCi SSL
apk add luci-ssl

# Dashboard
apk add luci-mod-dashboard

# SFTP
apk add openssh-sftp-server

# TTYD
apk add luci-app-ttyd
uci set ttyd.@ttyd[0]=ttyd
uci set ttyd.@ttyd[0].interface='@lan'
uci set ttyd.@ttyd[0].command='/bin/login -f root '
uci set ttyd.@ttyd[0].ipv6='1'
uci set ttyd.@ttyd[0].debug='7'
uci set ttyd.@ttyd[0].url_arg='1'
uci commit ttyd

# BUSYBOX
apk add coreutils

# Irqbalance
CPU_INFO=`fgrep 'processor' /proc/cpuinfo | wc -l`
if [ "$CPU_INFO" -gt 3 ]
then
 apk add irqbalance
 uci set irqbalance.irqbalance=irqbalance
 uci set irqbalance.irqbalance.enabled='1'
 uci commit irqbalance
 # /etc/init.d/irqbalance start
fi

# SQM
DOWNLOAD='0' #initial value
UPLOAD='0' #initial value
apk add luci-app-sqm
. /lib/functions/network.sh
network_flush_cache
network_find_wan6 NET_IF6
network_get_physdev NET_L2D6 "${NET_IF6}"
uci set sqm.@queue[0].enabled='1'
uci set sqm.@queue[0].interface=${NET_L2D6}
uci set sqm.@queue[0].download=${DOWNLOAD}
uci set sqm.@queue[0].upload=${UPLOAD}
uci commit sqm
/etc/init.d/sqm start
/etc/init.d/sqm enable

# statistics
apk add luci-app-statistics
/etc/init.d/collectd enable

# nlbwmon
apk add luci-app-nlbwmon

# wifi schedule
apk add wifischedule
apk add luci-app-wifischedule

# Additional Themes
# OpnWrt
apk add luci-theme-openwrt
# material
apk add luci-theme-material
# openwrt-2020
apk add luci-theme-openwrt-2020

# Attended Sysupgrade
apk add attendedsysupgrade-common
apk add luci-app-attendedsysupgrade

# USB
if [ -n "$str_USB" ]; then
cat << EOF >> /etc/config-software/list-installed/Before
block-mount
kmod-usb-storage
kmod-usb-storage-uas
usbutils
gdisk
libblkid1
kmod-usb-ledtrig-usbport
luci-app-ledtrig-usbport
dosfstools
kmod-fs-vfat
e2fsprogs
kmod-fs-ext4
f2fs-tools
kmod-fs-f2fs
exfat-fsck
kmod-fs-exfat
ntfs-3g
kmod-fs-ntfs3
hfsfsck
kmod-fs-hfs
kmod-fs-hfsplus
hdparm
hd-idle
luci-app-hd-idle
EOF

  apk add block-mount
  apk add kmod-usb-storage
  apk add kmod-usb-storage-uas
  apk add usbutils
  apk add gdisk
  apk add libblkid1
  apk add kmod-usb-ledtrig-usbport
  apk add luci-app-ledtrig-usbport
  apk add dosfstools
  apk add kmod-fs-vfat
  apk add e2fsprogs
  apk add kmod-fs-ext4
  apk add f2fs-tools
  apk add kmod-fs-f2fs
  apk add exfat-fsck
  apk add kmod-fs-exfat
  apk add ntfs-3g
  apk add kmod-fs-ntfs3
  apk add hfsfsck
  apk add kmod-fs-hfs
  apk add kmod-fs-hfsplus
  apk add hdparm
  apk add hd-idle
  apk add luci-app-hd-idle
fi
apk info | awk '{ print $1 }' > /etc/config-software/list-installed/After
awk -F, 'FNR==NR{a[$1]++; next} !a[$1]' /etc/config-software/list-installed/After /etc/config-software/list-installed/Before > /etc/config-software/list-installed/Difference
if [ -s /etc/config-software/list-installed/Difference ]; then
 while :
 do
 echo -e "\033[1;33m`cat /etc/config-software/list-installed/Difference`\033[0;39m"
 echo -e " \033[1;31mInstallation failed\033[0;39m"
 read -p " Retry installation [y/n]: " num
  case "${num}" in
  "y" ) _func_INSTALL ;;
  "n" )  read -p " Press any key (to reboot the device)"
         reboot ;;
  esac
done
else
 echo -e " \033[1;36mInstallation completed\033[0;39m"
 read -p " Press any key (to reboot the device)"
 reboot
fi
}

 while :
 do
  AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;32mAvailable flash sizes: ${AVAILABLE_FLASH}KB\033[0;39m"
  echo -e " \033[1;37mAutomatic full installation (for novices)\033[0;39m"
  echo -e " \033[1;37m・LuCi\033[0;39m"
  echo -e " \033[1;37m・LuCi SSL\033[0;39m"
  echo -e " \033[1;37m・Dashboard\033[0;39m"
  echo -e " \033[1;37m・SFTP server\033[0;39m"
  echo -e " \033[1;37m・ttyd\033[0;39m"
  echo -e " \033[1;37m・coreutils\033[0;39m"
  echo -e " \033[1;37m・irqbalance (4 core systems or more)\033[0;39m"
  echo -e " \033[1;37m・SQM\033[0;39m"
  echo -e " \033[1;37m・statistics\033[0;39m"
  echo -e " \033[1;37m・nlbwmon\033[0;39m"
  echo -e " \033[1;37m・wifi schedule\033[0;39m"
  echo -e " \033[1;37m・Themes (openWrt, material, openWrt2020)\033[0;39m"
  echo -e " \033[1;37m・Attended Sysupgrade\033[0;39m"
str_USB=`dmesg | ls /sys/bus/usb/devices | grep -s usb`
if [ -n "$str_USB" ]; then
  echo -e " \033[1;37m・USB：Base packages \033[0;39m"
  echo -e " \033[1;37m・USB：LED\033[0;39m"
  echo -e " \033[1;37m・USB：FAT32 \033[0;39m"
  echo -e " \033[1;37m・USB：ext4\033[0;39m"
  echo -e " \033[1;37m・USB：f2fs\033[0;39m"
  echo -e " \033[1;37m・USB：exFAT\033[0;39m"
  echo -e " \033[1;37m・USB：NTFS\033[0;39m"
  echo -e " \033[1;37m・USB：HFS & HFS+\033[0;39m"
  echo -e " \033[1;37m・USB：HDD\033[0;39m"
fi
  read -p " Start installing package [y/n]: " num
  case "${num}" in
    "y" ) _func_INSTALL ;;
    "n" ) exit ;;
  esac
done

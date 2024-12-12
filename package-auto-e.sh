#! /bin/sh
# OpenWrt >= 21.02:

function _func_INSTALL {
if [ -e ${UPDATE} ]; then
opkg update
UPDATE="1"
fi
mkdir -p /etc/config-software/list-installed
echo 0 > /etc/config-software/list-installed/Flash
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/Before

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
opkg install luci
# LiCi SSL
opkg install luci-ssl

# Dashboard
opkg install luci-mod-dashboard

# SFTP
opkg install openssh-sftp-server

# TTYD
opkg install luci-app-ttyd
uci set ttyd.@ttyd[0]=ttyd
uci set ttyd.@ttyd[0].interface='@lan'
uci set ttyd.@ttyd[0].command='/bin/login -f root '
uci set ttyd.@ttyd[0].ipv6='1'
uci set ttyd.@ttyd[0].debug='7'
uci set ttyd.@ttyd[0].url_arg='1'
uci commit ttyd

# BUSYBOX
opkg install coreutils

# Irqbalance
CPU_INFO=`fgrep 'processor' /proc/cpuinfo | wc -l`
if [ "$CPU_INFO" -gt 3 ]
then
 opkg install irqbalance
 uci set irqbalance.irqbalance=irqbalance
 uci set irqbalance.irqbalance.enabled='1'
 uci commit irqbalance
 # /etc/init.d/irqbalance start
fi

# SQM
DOWNLOAD='0' #initial value
UPLOAD='0' #initial value
opkg install luci-app-sqm
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
opkg install luci-app-statistics
/etc/init.d/collectd enable

# nlbwmon
opkg install luci-app-nlbwmon

# wifi schedule
opkg install wifischedule
opkg install luci-app-wifischedule

# Additional Themes
# OpnWrt
opkg install luci-theme-openwrt
# material
opkg install luci-theme-material
# openwrt-2020
opkg install luci-theme-openwrt-2020

# Attended Sysupgrade
opkg install attendedsysupgrade-common
opkg install luci-app-attendedsysupgrade

# custom feed (log viewer, cpu status, cpu perf, temp status, Internet detector, disk info)
wget --no-check-certificate -O /etc/config-software/pacage_list https://github.com/gSpotx2f/packages-openwrt/raw/master/current/
PACAGE_LIST=`cat /etc/config-software/pacage_list |sed -ne '/ <script type/,/<\/script>/p' |sed -e 's/<[^>]*>//g'`
#echo $PACAGE_LIST

# log viewer
LOG_VIEWER=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-log-viewer") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $LOG_VIEWER
wget --no-check-certificate -O /tmp/luci-app-log-viewer_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${LOG_VIEWER}.ipk
opkg install /tmp/luci-app-log-viewer_all.ipk
rm /tmp/luci-app-log-viewer_all.ipk

# cpu status
CPU_STATUS_V=`echo ${PACAGE_LIST} | awk '{ if (gsub(/luci-app-cpu-status-mini/, "HOGEHOGE")) print }' | awk '{print substr($0,index($0,"current/luci-app-cpu-status") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $CPU_STATUS_V
wget --no-check-certificate -O /tmp/luci-app-cpu-status_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${CPU_STATUS_V}.ipk
opkg install /tmp/luci-app-cpu-status_all.ipk
rm /tmp/luci-app-cpu-status_all.ipk

# cpu perf
CPU_PERF_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-cpu-perf") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $CPU_PERF_V
wget --no-check-certificate -O /tmp/luci-app-cpu-perf_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${CPU_PERF_V}.ipk
opkg install /tmp/luci-app-cpu-perf_all.ipk
rm /tmp/luci-app-cpu-perf_all.ipk

# temp status
TEMP_STATUS_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-temp-status") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $TEMP_STATUS_V
wget --no-check-certificate -O /tmp/luci-app-temp-status_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${TEMP_STATUS_V}.ipk
opkg install /tmp/luci-app-temp-status_all.ipk
rm /tmp/luci-app-temp-status_all.ipk

# Internet detector
INTERNET_DETECTOR=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/internet-detector_") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $INTERNET_DETECTOR
wget --no-check-certificate -O /tmp/internet-detector_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${INTERNET_DETECTOR}.ipk
opkg install /tmp/internet-detector_all.ipk
rm /tmp/internet-detector_all.ipk
/etc/init.d/internet-detector enable
LUCI_APP_INTERNET_DETECTER_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-internet-detector") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $LUCI_APP_INTERNET_DETECTER_V
wget --no-check-certificate -O /tmp/luci-app-internet-detector_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${LUCI_APP_INTERNET_DETECTER_V}.ipk
opkg install /tmp/luci-app-internet-detector_all.ipk
rm /tmp/luci-app-internet-detector_all.ipk

# USB
if [ -n "$str_USB" ]; then
cat << EOF >> /etc/config-software/list-installed/Before
luci-app-disks-info
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

LUCI_APP_DISKA_INFO_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-disks-info") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $LUCI_APP_DISKA_INFO_V
wget --no-check-certificate -O /tmp/luci-app-disks-info_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${LUCI_APP_DISKA_INFO_V}.ipk
opkg install /tmp/luci-app-disks-info_all.ipk
rm /tmp/luci-app-disks-info_all.ipk

  opkg install block-mount
  opkg install kmod-usb-storage
  opkg install kmod-usb-storage-uas
  opkg install usbutils
  opkg install gdisk
  opkg install libblkid1
  opkg install kmod-usb-ledtrig-usbport
  opkg install luci-app-ledtrig-usbport
  opkg install dosfstools
  opkg install kmod-fs-vfat
  opkg install e2fsprogs
  opkg install kmod-fs-ext4
  opkg install f2fs-tools
  opkg install kmod-fs-f2fs
  opkg install exfat-fsck
  opkg install kmod-fs-exfat
  opkg install ntfs-3g
  opkg install kmod-fs-ntfs3
  opkg install hfsfsck
  opkg install kmod-fs-hfs
  opkg install kmod-fs-hfsplus
  opkg install hdparm
  opkg install hd-idle
  opkg install luci-app-hd-idle
fi
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/After
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
  echo -e " \033[1;37m・log viewer (custom feed)\033[0;39m"
  echo -e " \033[1;37m・cpu status (custom feed)\033[0;39m"
  echo -e " \033[1;37m・cpu perf (custom feed)\033[0;39m"
  echo -e " \033[1;37m・temp status (custom feed)\033[0;39m"
  echo -e " \033[1;37m・internet detector (custom feed)\033[0;39m"
  echo -e " \033[1;37m・Theme ARGON (custom feed)\033[0;39m"
  echo -e " \033[1;37m・Attended Sysupgrade\033[0;39m"
str_USB=`dmesg | ls /sys/bus/usb/devices | grep -s usb`
if [ -n "$str_USB" ]; then
  echo -e " \033[1;37m・Disk Info (custom feed)\033[0;39m"
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

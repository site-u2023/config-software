#! /bin/sh
# OpenWrt >= 21.02:


function _func_Languages {
while :
do
  echo -e " \033[1;37mar: العربية (Arabic)\033[0;39m"
  echo -e " \033[1;37mbg: български (Bulgarian)\033[0;39m"
  echo -e " \033[1;37mbn: বাংলা (Bengali)\033[0;39m"
  echo -e " \033[1;37mca: Català (Catalan)\033[0;39m"
  echo -e " \033[1;37mcs: Čeština (Czech)\033[0;39m"
  echo -e " \033[1;37mda: Dansk (Danish)\033[0;39m"
  echo -e " \033[1;37mde: Deutsch (German)\033[0;39m"
  echo -e " \033[1;37mel: Ελληνικά (Greek)\033[0;39m"
  echo -e " \033[1;37mes: Español (Spanish)\033[0;39m"
  echo -e " \033[1;37mfi: Suomi (Finnish)\033[0;39m"
  echo -e " \033[1;37mfr: Français (French)\033[0;39m"
  echo -e " \033[1;37mhe: עִבְרִית (Hebrew)\033[0;39m"
  echo -e " \033[1;37mhu: Magyar (Hungarian)\033[0;39m"
  echo -e " \033[1;37mit: Italiano (Italian)\033[0;39m"
  echo -e " \033[1;37mja: 日本語 (Japanese)\033[0;39m"
  echo -e " \033[1;37mko: 한국어 (Korean)\033[0;39m"
  echo -e " \033[1;37mlt: Lietuvių (Lithuanian)\033[0;39m"
  echo -e " \033[1;37mmr: Marāṭhī (Marathi)\033[0;39m"
  echo -e " \033[1;37mms: Bahasa Melayu (Malay)\033[0;39m"
  echo -e " \033[1;37mnl: Nederlands (Dutch)\033[0;39m"
  echo -e " \033[1;37mno: Norsk (Norwegian)\033[0;39m"
  echo -e " \033[1;37mpl: Polski (Polish)\033[0;39m"
  echo -e " \033[1;37mpt: Português (Portuguese)\033[0;39m"
  echo -e " \033[1;37mpt-br: Português do Brasil (Brazilian Portuguese)\033[0;39m"
  echo -e " \033[1;37mro: Română (Romanian)\033[0;39m"
  echo -e " \033[1;37mru: Русский (Russian)\033[0;39m"
  echo -e " \033[1;37msk: Slovenčina (Slovak)\033[0;39m"
  echo -e " \033[1;37msv: Svenska (Swedish)\033[0;39m"
  echo -e " \033[1;37mtr: Türkçe (Turkish)\033[0;39m"
  echo -e " \033[1;37muk: Українська (Ukrainian)\033[0;39m"
  echo -e " \033[1;37mvi: Tiếng Việt (Vietnamese)\033[0;39m"
  echo -e " \033[1;37mzh-cn: 简体中文 (Chinese Simplified)\033[0;39m"
  echo -e " \033[1;37mzh-tw: 繁體中文 (Chinese Traditional)\033[0;39m"
  echo -e " \033[1;37mPlease enter country code\033[0;39m"
  echo -e " \033[1;37mLanguage packs will not install without code entry (Standard: English)\033[0;39m"
  echo -e " \033[1;37mExample: ja\033[0;39m"
  read -p " Language: " input_str_Languages
  read -p " All right? [y/n or r]: " num
  echo -e " \033[1;32mLanguages: $input_str_Languages\033[0;39m"
  case "${num}" in
    "y" ) _func_INSTALL ;;
    "n" ) _func_Languages ;;
    "r" ) exit ;;
  esac
done
}

function _func_INSTALL {
UPDATE="/tmp/opkg-lists/openwrt_telephony"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
mkdir -p /etc/config-software/list-installed
echo 0 > /etc/config-software/list-installed/Flash
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/Before

cat << EOF > /etc/config-software/list-installed/Before
luci
luci-ssl
openssh-sftp-server
luci-app-ttyd
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
auc
luci-app-log-viewer
luci-app-cpu-perf
luci-app-temp-status
internet-detector
luci-app-internet-detector
luci-theme-argon
luci-i18n-base-$input_str_Languages
luci-i18n-opkg-$input_str_Languages
luci-i18n-firewall-$input_str_Languages
luci-i18n-ttyd-$input_str_Languages
luci-i18n-sqm-$input_str_Languages
luci-i18n-statistics-$input_str_Languages
luci-i18n-nlbwmon-$input_str_Languages
luci-i18n-wifischedule-$input_str_Languages
luci-i18n-attendedsysupgrade-$input_str_Languages
EOF

# LuCi
opkg install luci
# LiCi SSL
opkg install luci-ssl
# Language
opkg install luci-i18n-base-$input_str_Languages
opkg install luci-i18n-opkg-$input_str_Languages
opkg install luci-i18n-firewall-$input_str_Languages

# SFTP
opkg install openssh-sftp-server

# TTYD
opkg install luci-app-ttyd
opkg install luci-i18n-ttyd-$input_str_Languages
uci set ttyd.@ttyd[0]=ttyd
uci set ttyd.@ttyd[0].interface='@lan'
uci set ttyd.@ttyd[0].command='/bin/login -f root '
uci set ttyd.@ttyd[0].ipv6='1'
uci set ttyd.@ttyd[0].debug='7'
uci set ttyd.@ttyd[0].url_arg='1'
uci commit ttyd

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
opkg install luci-i18n-sqm-$input_str_Languages
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
opkg install luci-i18n-statistics-$input_str_Languages
/etc/init.d/collectd enable

# nlbwmon
opkg install luci-app-nlbwmon
opkg install luci-i18n-nlbwmon-$input_str_Languages

# wifi schedule
opkg install wifischedule
opkg install luci-app-wifischedule
opkg install luci-i18n-wifischedule-$input_str_Languages

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
opkg install luci-i18n-attendedsysupgrade-$input_str_Languages
opkg install auc

# custom feed

# log viewer
wget --no-check-certificate -O /tmp/luci-app-log-viewer_1.1-0_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-log-viewer_1.1-0_all.ipk
opkg install /tmp/luci-app-log-viewer_1.1-0_all.ipk
rm /tmp/luci-app-log-viewer_1.1-0_all.ipk

# cpu status
wget --no-check-certificate -O /tmp/luci-app-cpu-status_0.4-3_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-cpu-status_0.4-3_all.ipk
opkg install /tmp/luci-app-cpu-status_0.4-3_all.ipk
rm /tmp/luci-app-cpu-status_0.4-3_all.ipk

# cpu perf
wget --no-check-certificate -O /tmp/luci-app-cpu-perf_0.4-1_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-cpu-perf_0.4-1_all.ipk
opkg install /tmp/luci-app-cpu-perf_0.4-1_all.ipk
rm /tmp/luci-app-cpu-perf_0.4-1_all.ipk
/etc/init.d/cpu-perf start

# temp status
wget --no-check-certificate -O /tmp/luci-app-temp-status_0.3-5_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-temp-status_0.3-5_all.ipk
opkg install /tmp/luci-app-temp-status_0.3-5_all.ipk
rm /tmp/luci-app-temp-status_0.3-5_all.ipk

# Internet detector
opkg install mailsend
wget --no-check-certificate -O /tmp/internet-detector_1.0-3_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/internet-detector_1.0-3_all.ipk
opkg install /tmp/internet-detector_1.0-3_all.ipk
rm /tmp/internet-detector_1.0-3_all.ipk
/etc/init.d/internet-detector start
/etc/init.d/internet-detector enable
wget --no-check-certificate -O /tmp/luci-app-internet-detector_1.0-1_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-internet-detector_1.0-1_all.ipk
opkg install /tmp/luci-app-internet-detector_1.0-1_all.ipk
rm /tmp/luci-app-internet-detector_1.0-1_all.ipk

# Theme ARGON (template)
opkg install luci-compat
opkg install luci-lib-ipkg
wget --no-check-certificate -O /tmp/luci-theme-argon.ipk https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.3.1/luci-theme-argon_2.3.1_all.ipk
opkg install /tmp/luci-theme-argon.ipk
rm /tmp/luci-theme-argon.ipk

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
luci-i18n-hd-idle-$input_str_Languages
EOF
  wget --no-check-certificate -O /tmp/luci-app-disks-info_0.4-2_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-disks-info_0.4-2_all.ipk
  opkg install /tmp/luci-app-disks-info_0.4-2_all.ipk
  rm /tmp/luci-app-disks-info_0.4-2_all.ipk
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
  opkg install luci-i18n-hd-idle-$input_str_Languages
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

OPENWRT_RELEAS=`cat /etc/banner | grep OpenWrt | awk '{ print $2 }' | cut -c 1-2`
if [ "${OPENWRT_RELEAS}" = "23" ] || [ "${OPENWRT_RELEAS}" = "22" ] || [ "${OPENWRT_RELEAS}" = "21" ] || [ "${OPENWRT_RELEAS}" = "SN" ]; then
 echo -e " \033[1;37mversion check: OK\033[0;39m"
 else
 read -p " Exit due to different versions"
 exit
fi

 while :
 do
  AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;32mAvailable flash sizes: ${AVAILABLE_FLASH}KB\033[0;39m"
  echo -e " \033[1;37mAutomatic full installation (for novices)\033[0;39m"
  echo -e " \033[1;37m・LuCi\033[0;39m"
  echo -e " \033[1;37m・LuCi SSL\033[0;39m"
  echo -e " \033[1;37m・LuCi Language\033[0;39m"
  echo -e " \033[1;37m・SFTP server\033[0;39m"
  echo -e " \033[1;37m・ttyd\033[0;39m"
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
  read -p " Start installing the package [y/n]: " num
  case "${num}" in
    "y" ) _func_Languages ;;
    "n" ) exit ;;
  esac
done

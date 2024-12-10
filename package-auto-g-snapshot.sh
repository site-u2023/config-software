#! /bin/sh
# OpenWrt >= SnapShot:


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
  echo -e " \033[1;37mLanguage packs will not install without code entry\033[0;39m"
  echo -e " \033[1;37mExample: ja\033[0;39m"
  read -p " Language: " input_str_Languages
  read -p " Press any key [y/n or r]: " num
  echo -e " \033[1;32mLanguages: $input_str_Languages\033[0;39m"
  case "${num}" in
    "y" ) if [ -z "$input_str_Languages" ]; then
          _func_Languages
          fi
          _func_INSTALL ;;
    "n" ) _func_Languages ;;
    "r" ) exit ;;
  esac
done
}

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
luci-mod-dashboard
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
luci-i18n-dashboard-$input_str_Languages
luci-i18n-base-$input_str_Languages
luci-i18n-firewall-$input_str_Languages
luci-i18n-ttyd-$input_str_Languages
luci-i18n-sqm-$input_str_Languages
luci-i18n-statistics-$input_str_Languages
luci-i18n-nlbwmon-$input_str_Languages
luci-i18n-wifischedule-$input_str_Languages
luci-i18n-attendedsysupgrade-$input_str_Languages
EOF

# LuCi
apk add luci
# LiCi SSL
apk add luci-ssl
# Language
apk add luci-i18n-base-$input_str_Languages
apk add luci-i18n-firewall-$input_str_Languages

# Dashboard
apk add luci-mod-dashboard
apk add luci-i18n-dashboard-$input_str_Languages

# SFTP
apk add openssh-sftp-server

# TTYD
apk add luci-app-ttyd
apk add luci-i18n-ttyd-$input_str_Languages
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
apk add luci-i18n-sqm-$input_str_Languages
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
apk add luci-i18n-statistics-$input_str_Languages
/etc/init.d/collectd enable

# nlbwmon
apk add luci-app-nlbwmon
apk add luci-i18n-nlbwmon-$input_str_Languages

# wifi schedule
apk add wifischedule
apk add luci-app-wifischedule
apk add luci-i18n-wifischedule-$input_str_Languages

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
apk add luci-i18n-attendedsysupgrade-$input_str_Languages

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
luci-i18n-hd-idle-$input_str_Languages
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
  apk add luci-i18n-hd-idle-$input_str_Languages
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

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "SN" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
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
    "y" ) _func_Languages ;;
    "n" ) exit ;;
  esac
done

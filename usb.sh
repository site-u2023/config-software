#! /bin/sh
# OpenWrt >= 21.02:

# USB判定
{
str_USB=`dmesg | grep -s usb`
if [ -n "$str_USB" ]; then
cat << EOF >> /etc/config-software/list-installed/schedule
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
EOF
fi
}

# ----------------------------------------------------------------

function _func_USB_INSTALL
{

UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi

# USBベース
opkg install block-mount
opkg install kmod-usb-storage
opkg install kmod-usb-storage-uas
opkg install usbutils
opkg install gdisk
opkg install libblkid1
# USBポート_LEDトリガー
opkg install kmod-usb-ledtrig-usbport
opkg install luci-app-ledtrig-usbport
# reboot




}

# ----------------------------------------------------------------


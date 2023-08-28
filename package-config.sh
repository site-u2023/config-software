#! /bin/sh
# OpenWrt >= 21.02:

 function _func_INSTALL
 {
# パッケージ
opkg update

# LuCi
opkg install luci

# LuCi日本語化
opkg install luci-i18n-base-ja 
opkg install luci-i18n-opkg-ja
opkg install luci-i18n-firewall-ja

# SFTP
opkg install openssh-sftp-server
 
 
# CPU負荷分散
CPU_INFO=`fgrep 'processor' /proc/cpuinfo | wc -l`
if [ "$CPU_INFO" -gt 3 ]
then
 opkg install irqbalance;
 uci set irqbalance.irqbalance=irqbalance;
 uci set irqbalance.irqbalance.enabled='1';
 uci commit irqbalance;
 /etc/init.d/irqbalance start
fi

# SQM
DOWNLOAD='0' #初期値
UPLOAD='0' #初期値
opkg install luci-app-sqm
opkg install luci-i18n-sqm-ja
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

# ネットワーク統計インターフェイス
opkg install luci-i18n-statistics-ja
/etc/init.d/rpcd restart

# 帯域幅モニター
opkg install luci-i18n-nlbwmon-ja

# WiFiスケジュール
opkg install wifischedule
opkg install luci-app-wifischedule
opkg install luci-i18n-wifischedule-ja

# 追加テーマ
# OpnWrt
opkg install luci-theme-openwrt
# マテリアル
opkg install luci-theme-material
# モダン
opkg install luci-theme-openwrt-2020

# カスタム フィード

# ログ情報
wget --no-check-certificate -O /tmp/luci-app-log_0.6-2_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-log_0.6-2_all.ipk
opkg install /tmp/luci-app-log_0.6-2_all.ipk
rm /tmp/luci-app-log_0.6-2_all.ipk
/etc/init.d/rpcd restart

# CPUステータス
wget --no-check-certificate -O /tmp/luci-app-cpu-status_0.4-2_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-cpu-status_0.4-2_all.ipk
opkg install /tmp/luci-app-cpu-status_0.4-2_all.ipk
rm /tmp/luci-app-cpu-status_0.4-2_all.ipk
/etc/init.d/rpcd reload

# CPUパフォーマンス
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ]; then
 wget --no-check-certificate -O /tmp/luci-app-cpu-perf_0.4-0_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/23.05/luci-app-cpu-perf_0.4-0_all.ipk;
 opkg install /tmp/luci-app-cpu-perf_0.4-0_all.ipk;
 rm /tmp/luci-app-cpu-perf_0.4-0_all.ipk;
 /etc/init.d/rpcd restart;
 /etc/init.d/cpu-perf start
else
 wget --no-check-certificate -O /tmp/luci-app-cpu-perf_0.4-0_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-cpu-perf_0.4-0_all.ipk;
 opkg install /tmp/luci-app-cpu-perf_0.4-0_all.ipk;
 rm /tmp/luci-app-cpu-perf_0.4-0_all.ipk;
 /etc/init.d/rpcd restart;
 /etc/init.d/cpu-perf start
fi

# 温度センサー
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ]; then
  wget --no-check-certificate -O /tmp/luci-app-temp-status_0.3-5_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/23.05/luci-app-temp-status_0.3-5_all.ipk;
  opkg install /tmp/luci-app-temp-status_0.3-5_all.ipk;
  rm /tmp/luci-app-temp-status_0.3-5_all.ipk;
  /etc/init.d/rpcd reload
else
　wget --no-check-certificate -O /tmp/luci-app-temp-status_0.3-5_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-temp-status_0.3-5_all.ipk;
　opkg install /tmp/luci-app-temp-status_0.3-5_all.ipk;
　rm /tmp/luci-app-temp-status_0.3-5_all.ipk;
　/etc/init.d/rpcd reload
fi

# インターネット可用性確認
wget --no-check-certificate -O /tmp/internet-detector_1.0-2_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/internet-detector_1.0-2_all.ipk
opkg install /tmp/internet-detector_1.0-2_all.ipk
rm /tmp/internet-detector_1.0-2_all.ipk
/etc/init.d/internet-detector start
/etc/init.d/internet-detector enable
wget --no-check-certificate -O /tmp/luci-app-internet-detector_1.0-1_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-internet-detector_1.0-1_all.ipk
opkg install /tmp/luci-app-internet-detector_1.0-1_all.ipk
rm /tmp/luci-app-internet-detector_1.0-1_all.ipk
/etc/init.d/rpcd restart
opkg install mailsend

# テーマ ARGON (テンプレート)
opkg install luci-compat
opkg install luci-lib-ipkg
wget --no-check-certificate -O /tmp/luci-theme-argon.ipk https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.3.1/luci-theme-argon_2.3.1_all.ipk
opkg install /tmp/luci-theme-argon.ipk
rm /tmp/luci-theme-argon.ipk
/etc/init.d/rpcd restart

# USB
str_USB=`dmesg | grep -s usb`
if [ -n "$str_USB" ]; then
  opkg install block-mount;
  opkg install kmod-usb-storage;
  opkg install kmod-usb-storage-uas;
  opkg install usbutils;
  opkg install gdisk;
  opkg install libblkid1;
  opkg install kmod-usb-ledtrig-usbport;
  opkg install luci-app-ledtrig-usbport;
  opkg install dosfstools;
  opkg install kmod-fs-vfat;
  opkg install e2fsprogs;
  opkg install kmod-fs-ext4;
  opkg install f2fs-tools;
  opkg install kmod-fs-f2fs;
  opkg install exfat-fsck;
  opkg install kmod-fs-exfat;
  opkg install ntfs-3g;
  opkg install kmod-fs-ntfs3;
  opkg install hfsfsck;
  opkg install kmod-fs-hfs;
  opkg install kmod-fs-hfsplus3;
  opkg install hdparm;
  opkg install hd-idle
  echo " インストール: USBドライバー&ツール"
else
  echo " USBデバイスはありません"
fi
echo " CPUコア: ${CPU_INFO}"
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

while :
do
{
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェックOK\033[0;39m"
else
 read -p " バージョンが違うため終了します"
 exit
fi
}
  echo -e " \033[1;35mパッケージインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_INSTALL ;;
    "n" ) exit ;;
  esac
done

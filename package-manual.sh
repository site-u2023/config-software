#! /bin/sh
# OpenWrt >= 21.02:

function _func_listinstalled {

# LuCi
if [ -z "$LUCI" ]; then
opkg install luci
fi

# LuCi日本語化
if [ -z "$LUCI_JA" ]; then
opkg install luci-i18n-base-ja
fi
if [ -z "$LUCI_JA_OPKG" ]; then
opkg install luci-i18n-opkg-ja
fi
if [ -z "$LUCI_JA_FIREWALL" ]; then
opkg install luci-i18n-firewall-ja
fi

# SFTPサーバー
if [ -z "$SFTP" ]; then
opkg install openssh-sftp-server
fi

# WEB-SSHクライアント
if [ -z "$TTYD" ]; then
opkg install luci-app-ttyd
fi
if [ -z "$TTYD_JA" ]; then
opkg install luci-i18n-ttyd-ja
fi

# CPU負荷分散
if [ -z "$CPU" ]; then
opkg install irqbalance
uci set irqbalance.irqbalance=irqbalance
uci set irqbalance.irqbalance.enabled='1'
uci commit irqbalance
fi

# SQM
if [ -z "$SQM" ]; then
opkg install sqm-scripts
DOWNLOAD='0' #初期値
UPLOAD='0' #初期値
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
fi
if [ -z "$SQM_APP" ]; then
opkg install luci-app-sqm
fi
if [ -z "$SQM_APP_JA" ]; then
opkg install luci-i18n-sqm-ja
fi

# ネットワーク統計インターフェイス
if [ -z "$STATUS" ]; then
opkg install luci-app-statistics
fi
if [ -z "$STATUS_JA" ]; then
opkg install luci-i18n-statistics-ja
fi

# 帯域幅モニター
if [ -z "$NLBWMON" ]; then
opkg install nlbwmon
fi
if [ -z "$NLBWMON_APP" ]; then
opkg install luci-app-nlbwmon
fi
if [ -z "$NLBWMON_APP_JA" ]; then
opkg install luci-i18n-nlbwmon-ja
fi

# WiFiスケジュール
if [ -z "$WIFISCHEDULE" ]; then
opkg install wifischedule
fi
if [ -z "$WIFISCHEDULE_APP" ]; then
opkg install luci-app-wifischedule
fi
if [ -z "$WIFISCHEDULE_APP_JA" ]; then
opkg install luci-i18n-wifischedule-ja
fi

# テーマ
if [ -z "$THEME_OPENWRT" ]; then
opkg install luci-theme-openwrt
fi
if [ -z "$THEME_MATERIAL" ]; then
opkg install luci-theme-material
fi
if [ -z "$THEME_2020" ]; then
opkg install luci-theme-openwrt-2020
fi

# カスタムフィード

# ログ情報
if [ -z "$LOG" ]; then
wget --no-check-certificate -O /tmp/luci-app-log_0.6-2_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-log_0.6-2_all.ipk
opkg install /tmp/luci-app-log_0.6-2_all.ipk
rm /tmp/luci-app-log_0.6-2_all.ipk
fi

# CPUステータス
if [ -z "$CPU_STATUS" ]; then
wget --no-check-certificate -O /tmp/luci-app-cpu-status_0.4-2_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-cpu-status_0.4-2_all.ipk
opkg install /tmp/luci-app-cpu-status_0.4-2_all.ipk
rm /tmp/luci-app-cpu-status_0.4-2_all.ipk
fi

# CPUパフォーマンス
if [ -z "$CPU_PERFORMANCE" ]; then
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
 if [ "${OPENWRT_RELEAS:0:2}" = "23" ]; then
 wget --no-check-certificate -O /tmp/luci-app-cpu-perf_0.4-0_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/23.05/luci-app-cpu-perf_0.4-0_all.ipk
 opkg install /tmp/luci-app-cpu-perf_0.4-0_all.ipk
 rm /tmp/luci-app-cpu-perf_0.4-0_all.ipk
 /etc/init.d/cpu-perf start
 else
 wget --no-check-certificate -O /tmp/luci-app-cpu-perf_0.4-0_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-cpu-perf_0.4-0_all.ipk
 opkg install /tmp/luci-app-cpu-perf_0.4-0_all.ipk
 rm /tmp/luci-app-cpu-perf_0.4-0_all.ipk
 /etc/init.d/cpu-perf start
 fi
fi

# 温度センサー
if [ -z "$TMP_STATUS" ]; then
 OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
 if [ "${OPENWRT_RELEAS:0:2}" = "23" ]; then
 wget --no-check-certificate -O /tmp/luci-app-temp-status_0.3-5_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/23.05/luci-app-temp-status_0.3-5_all.ipk
 opkg install /tmp/luci-app-temp-status_0.3-5_all.ipk
 rm /tmp/luci-app-temp-status_0.3-5_all.ipk
 else
 wget --no-check-certificate -O /tmp/luci-app-temp-status_0.3-5_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-temp-status_0.3-5_all.ipk
 opkg install /tmp/luci-app-temp-status_0.3-5_all.ipk
 rm /tmp/luci-app-temp-status_0.3-5_all.ipk
 fi
fi

# インターネット可用性確認
if [ -z "$DETECTER" ]; then
wget --no-check-certificate -O /tmp/internet-detector_1.0-3_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/internet-detector_1.0-3_all.ipk
opkg install /tmp/internet-detector_1.0-3_all.ipk
rm /tmp/internet-detector_1.0-3_all.ipk
/etc/init.d/internet-detector start
/etc/init.d/internet-detector enable
fi
if [ -z "$DETECTER_APP" ]; then
wget --no-check-certificate -O /tmp/luci-app-internet-detector_1.0-1_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-internet-detector_1.0-1_all.ipk
opkg install /tmp/luci-app-internet-detector_1.0-1_all.ipk
rm /tmp/luci-app-internet-detector_1.0-1_all.ipk
fi

# テーマ ARGON (テンプレート)
if [ -z "$ARGON" ]; then
wget --no-check-certificate -O /tmp/luci-theme-argon.ipk https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.3.1/luci-theme-argon_2.3.1_all.ipk
opkg install /tmp/luci-theme-argon.ipk
rm /tmp/luci-theme-argon.ipk
fi
if [ -z "$COMPAT" ]; then
opkg install luci-compat
fi
if [ -z "$LIB" ]; then
opkg install luci-lib-ipkg
fi

# USB
if [ -z "$block_mount" ]; then
opkg install block-mount
fi
if [ -z "$kmod_usb_storage" ]; then
opkg install kmod-usb-storage
fi
if [ -z "$kmod_usb_storage_uas" ]; then
opkg install kmod-usb-storage-uas
fi
if [ -z "$usbutils" ]; then
opkg install usbutils
fi
if [ -z "$gdisk" ]; then
opkg install gdisk
fi
if [ -z "$libblkid1" ]; then
opkg install libblkid1
fi
# USBポート_LEDトリガー
if [ -z "$kmod_usb_ledtrig_usbport" ]; then
opkg install kmod-usb-ledtrig-usbport
fi
if [ -z "$luci_app_ledtrig_usbport" ]; then
opkg install luci-app-ledtrig-usbport
fi

# FAT32
if [ -z "$dosfstools" ]; then
opkg install dosfstools
fi
if [ -z "$kmod_fs_vfat" ]; then
opkg install kmod-fs-vfat
fi
# ext4
if [ -z "$e2fsprogs" ]; then
opkg install e2fsprogs
fi
if [ -z "$kmod_fs_ext4" ]; then
opkg install kmod-fs-ext4
fi
# f2fs
if [ -z "$f2fs_tools" ]; then
opkg install f2fs-tools
fi
if [ -z "$kmod_fs_f2fs" ]; then
opkg install kmod-fs-f2fs
fi
# exFAT
if [ -z "$exfat_fsck" ]; then
opkg install exfat-fsck
fi
if [ -z "$kmod_fs_exfat" ]; then
opkg install kmod-fs-exfat
fi
# NTFS
if [ -z "$ntfs_3g" ]; then
opkg install ntfs-3g
fi
if [ -z "$kmod_fs_ntfs3" ]; then
opkg install kmod-fs-ntfs3
fi
# HFS & HFS+
if [ -z "$hfsfsck" ]; then
opkg install hfsfsck
fi
if [ -z "$kmod_fs_hfs" ]; then
opkg install kmod-fs-hfs
fi
if [ -z "$kmod_fs_hfsplus" ]; then
opkg install kmod-fs-hfsplus
fi
# HDDアイドル
if [ -z "$hdparm" ]; then
opkg install hdparm
fi
if [ -z "$hd_idle" ]; then
opkg install hd-idle
fi
if [ -z "$luci_app_hd_idle" ]; then
opkg install luci-app-hd-idle
fi
if [ -z "$luci_i18n_hd_idle_ja" ]; then
opkg install luci-i18n-hd-idle-ja
fi


opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/After
awk -F, 'FNR==NR{a[$1]++; next} !a[$1]' /etc/config-software/list-installed/After /etc/config-software/list-installed/Before > /etc/config-software/list-installed/Difference
if [ -s /etc/config-software/list-installed/Difference ]; then
 while :
 do
 echo -e "\033[1;33m`cat /etc/config-software/list-installed/Difference`\033[0;39m"
 echo -e " \033[1;31mインストールに失敗しました\033[0;39m"
 read -p " インストールを再試行して下さい [y/n]: " num
  case "${num}" in
  "y" ) _func_listinstalled ;;
  "n" )  read -p " 何かキーを押してデバイスを再起動してください"
         reboot ;;
  esac
done
else
 echo -e " \033[1;36mインストールが完了しました\033[0;39m"
 read -p " 何かキーを押してデバイスを再起動してください"
 reboot
fi

}

# ----------------------------------------------------------------

function _func_listinstalled_Before {
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
mkdir -p /etc/config-software/list-installed
echo 0 > /etc/config-software/list-installed/Flash
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/Before
_func_luci
}

function _func_luci {
LUCI=`opkg list-installed luci | awk '{ print $1 }'`
if [ -z "$LUCI" ]; then
while :
do
{
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mLuCIをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci: $((`opkg info luci | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  }
  case "${num}" in
    "y" ) echo luci >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) LUCI='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_lucii18nbaseja
}

function _func_lucii18nbaseja {
LUCI_JA=`opkg list-installed luci-i18n-base-ja | awk '{ print $1 }'`
LUCI_JA_OPKG=`opkg list-installed luci-i18n-opkg-ja | awk '{ print $1 }'`
LUCI_JA_FIREWALL=`opkg list-installed luci-i18n-firewall-ja | awk '{ print $1 }'`
if [ -z "$LUCI_JA" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mLuCI日本語化をインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-i18n-base-ja: $((`opkg info luci-i18n-base-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-opkg-ja: $((`opkg info luci-i18n-opkg-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-firewall-ja: $((`opkg info luci-i18n-firewall-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-i18n-base-ja >> /etc/config-software/list-installed/Before
          echo luci-i18n-opkg-ja >> /etc/config-software/list-installed/Before
          echo luci-i18n-firewall-ja >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-base-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-opkg-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-firewall-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) LUCI_JA='1'
          LUCI_JA_OPKG='1'
          LUCI_JA_FIREWALL='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_opensshsftpserver
}

function _func_opensshsftpserver {
SFTP=`opkg list-installed openssh-sftp-server | awk '{ print $1 }'`
if [ -z "$SFTP" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mSFTPサーバーをインストールしますか\033[0;39m"
  echo -e " \033[1;32mopenssh-sftp-server: $((`opkg info openssh-sftp-server | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo openssh-sftp-server >> /etc/config-software/list-installed/Before
          echo $((`opkg info openssh-sftp-server | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) SFTP='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_luci_app_ttyd
}

function _luci_app_ttyd {
TTYD=`opkg list-installed luci-app-ttyd | awk '{ print $1 }'`
TTYD_JA=`opkg list-installed luci-i18n-ttyd-ja | awk '{ print $1 }'`
if [ -z "$TTYD_JA" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mWEB-SSHクライアントをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-app-ttyd: $((`opkg info luci-app-ttyd | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-ttyd-ja: $((`opkg info luci-i18n-ttyd-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-ttyd >> /etc/config-software/list-installed/Before
          echo luci-i18n-ttyd-ja >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-app-ttyd | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-ttyd-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) TTYD='1'
          TTYD_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_irqbalance
}

function _func_irqbalance {
CPU=`opkg list-installed irqbalance | awk '{ print $1 }'`
if [ -z "$CPU" ]; then
 CPU_INFO=`fgrep 'processor' /proc/cpuinfo | wc -l`
 if [ "$CPU_INFO" -gt 3 ]; then
while :
do
    echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
    echo -e " \033[1;32mCPU負荷分散をインストールしますか\033[0;39m"
    echo -e " \033[1;32mirqbalance: $((`opkg info irqbalance | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
    read -p " キーを選択してください [y/n or q]: " num
    case "${num}" in
      "y" ) echo irqbalance >> /etc/config-software/list-installed/Before
            echo $((`opkg info irqbalance | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
            break ;;
      "n" ) CPU='1'
            break ;;
      "q" ) exit ;;
    esac
done
fi
fi
_func_sqmscripts
}

function _func_sqmscripts {
SQM=`opkg list-installed sqm-scripts | awk '{ print $1 }'`
SQM_APP=`opkg list-installed luci-app-sqm | awk '{ print $1 }'`
SQM_APP_JA=`opkg list-installed luci-i18n-sqm-ja | awk '{ print $1 }'`
if [ -z "$SQM_APP_JA" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mSQMをインストールしますか\033[0;39m"
  echo -e " \033[1;32msqm-scripts: $((`opkg info sqm-scripts | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-sqm: $((`opkg info luci-app-sqm | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-sqm-ja: $((`opkg info luci-i18n-sqm-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo sqm-scripts >> /etc/config-software/list-installed/Before
          echo luci-app-sqm >> /etc/config-software/list-installed/Before
          echo luci-i18n-sqm-ja >> /etc/config-software/list-installed/Before
          echo $((`opkg info sqm-scripts | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-sqm | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-sqm-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) SQM='1'
          SQM_APP='1'
          SQM_APP_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_luciappstatistics
}

function _func_luciappstatistics {
STATUS=`opkg list-installed luci-app-statistics | awk '{ print $1 }'`
STATUS_JA=`opkg list-installed luci-i18n-statistics-ja | awk '{ print $1 }'`
if [ -z "$STATUS_JA" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mネットワーク統計インターフェイスをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-app-statistics: $((`opkg info luci-app-statistics | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-statistics-ja: $((`opkg info luci-i18n-statistics-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-statistics >> /etc/config-software/list-installed/Before
          echo luci-i18n-statistics-ja >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-app-statistics | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-statistics-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) STATUS='1'
          STATUS_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_nlbwmon
}

function _func_nlbwmon {
NLBWMON=`opkg list-installed nlbwmon | awk '{ print $1 }'`
NLBWMON_APP=`opkg list-installed luci-app-nlbwmon | awk '{ print $1 }'`
NLBWMON_APP_JA=`opkg list-installed luci-i18n-nlbwmon-ja | awk '{ print $1 }'`
if [ -z "$NLBWMON_APP_JA" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32m帯域幅モニターをインストールしますか\033[0;39m"
  echo -e " \033[1;32mnlbwmon: $((`opkg info nlbwmon | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-nlbwmon: $((`opkg info luci-app-nlbwmon | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-nlbwmon-ja: $((`opkg info luci-i18n-nlbwmon-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo nlbwmon >> /etc/config-software/list-installed/schedule
          echo luci-app-nlbwmon >> /etc/config-software/list-installed/schedule
          echo luci-i18n-nlbwmon-ja >> /etc/config-software/list-installed/Before
          echo $((`opkg info nlbwmon | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-nlbwmon | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-nlbwmon-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) NLBWMON='1'
          NLBWMON_APP='1'
          NLBWMON_APP_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_wifischedule
}

function _func_wifischedule {
WIFISCHEDULE=`opkg list-installed wifischedule | awk '{ print $1 }'`
WIFISCHEDULE_APP=`opkg list-installed luci-app-wifischedule | awk '{ print $1 }'`
WIFISCHEDULE_APP_JA=`opkg list-installed luci-i18n-wifischedule-ja | awk '{ print $1 }'`
if [ -z "$WIFISCHEDULE_APP_JA" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mWiFiスケジュールをインストールしますか\033[0;39m"
  echo -e " \033[1;32mwifischedule: $((`opkg info wifischedule | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-wifischedule: $((`opkg info luci-app-wifischedule | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-wifischedule-ja: $((`opkg info luci-i18n-wifischedule-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo wifischedule >> /etc/config-software/list-installed/schedule
          echo luci-app-wifischedule >> /etc/config-software/list-installed/Before
          echo luci-i18n-wifischedule-ja >> /etc/config-software/list-installed/Before
          echo $((`opkg info wifischedule | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-wifischedule | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-wifischedule-ja | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) WIFISCHEDULE='1'
          WIFISCHEDULE_APP='1'
          WIFISCHEDULE_APP_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_lucithemeopenwrt
}

function _func_lucithemeopenwrt {
THEME_OPENWRT=`opkg list-installed luci-theme-openwrt | awk '{ print $1 }'`
if [ -z "$THEME_OPENWRT" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mテーマ OpenWrtをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-theme-openwrt: $((`opkg info luci-theme-openwrt | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-openwrt >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-theme-openwrt | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) THEME_OPENWRT='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_lucithemematerial
}

function _func_lucithemematerial {
THEME_MATERIAL=`opkg list-installed luci-theme-material | awk '{ print $1 }'`
if [ -z "$THEME_MATERIAL" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mテーマ マテリアルをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-theme-material: $((`opkg info luci-theme-material | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-material >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-theme-material | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) THEME_MATERIAL='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_lucithemeopenwrt2020
}

function _func_lucithemeopenwrt2020 {
THEME_2020=`opkg list-installed luci-theme-openwrt-2020 | awk '{ print $1 }'`
if [ -z "$THEME_2020" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mテーマ OpenWrt2020をインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-theme-openwrt-2020: $((`opkg info luci-theme-openwrt-2020 | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-openwrt-2020 >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-theme-openwrt-2020 | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) THEME_2020='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_luciapplog
}

function _func_luciapplog {
LOG=`opkg list-installed luci-app-log | awk '{ print $1 }'`
if [ -z "$LOG" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;32mログ情報をインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-app-log: $((5791/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-log >> /etc/config-software/list-installed/Before
          echo $((5791/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) LOG='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_luciappcpustatus
}

function _func_luciappcpustatus {
CPU_STATUS=`opkg list-installed luci-app-cpu-status | awk '{ print $1 }'`
if [ -z "$CPU_STATUS" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;32mCPUステータスをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-app-cpu-status: $((1445/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-cpu-status >> /etc/config-software/list-installed/Before
          echo $((1445/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) CPU_STATUS='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_luciappcpuperf
}

function _func_luciappcpuperf {
CPU_PERFORMANCE=`opkg list-installed luci-app-cpu-perf | awk '{ print $1 }'`
if [ -z "$CPU_PERFORMANCE" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;32mCPUパフォーマンスをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-app-cpu-perf: $((6519/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-cpu-perf >> /etc/config-software/list-installed/Before
          echo $((0/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) CPU_PERFORMANCE='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_luciapptempstatus
}

function _func_luciapptempstatus {
TMP_STATUS=`opkg list-installed luci-app-temp-status | awk '{ print $1 }'`
if [ -z "$TMP_STATUS" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;32m温度センサーをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-app-temp-status: $((2032/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-temp-status >> /etc/config-software/list-installed/Before
          echo $((2032/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) TMP_STATUS='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_internetdetector
}

function _func_internetdetector {
DETECTER=`opkg list-installed internet-detector | awk '{ print $1 }'`
DETECTER_APP=`opkg list-installed luci-app-internet-detector | awk '{ print $1 }'`
if [ -z "$DETECTER_APP" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;32mインターネット可用性確認をインストールしますか\033[0;39m"
  echo -e " \033[1;32minternet-detector: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-internet-detector: $((7771/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo internet-detector >> /etc/config-software/list-installed/Before
          echo luci-app-internet-detector >> /etc/config-software/list-installed/Before
          echo $((10680/1024)) >> /etc/config-software/list-installed/Flash
          echo $((7771/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) DETECTER='1'
          DETECTER_APP='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_lucithemeargon
}

function _func_lucithemeargon {
ARGON=`opkg list-installed luci-theme-argon | awk '{ print $1 }'`
COMPAT=`opkg list-installed luci-compat | awk '{ print $1 }'`
LIB=`opkg list-installed luci-lib-ipkg | awk '{ print $1 }'`
if [ -z "$ARGON" ]; then
while :
do
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;32mテーマARGONをインストールしますか\033[0;39m"
  echo -e " \033[1;32mluci-theme-argon: $((388904/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-compat: $((46213/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-lib-ipkg: $((2062/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-theme-argon\033[0;39m"
  echo -e " \033[1;32mluci-compat\033[0;39m"
  echo -e " \033[1;32mluci-lib-ipkg\033[0;39m"  
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-argon >> /etc/config-software/list-installed/Before
          echo luci-compat >> /etc/config-software/list-installed/Before
          echo luci-lib-ipkg >> /etc/config-software/list-installed/Before
          echo $((388904/1024)) >> /etc/config-software/list-installed/Flash
          echo $((46213/1024)) >> /etc/config-software/list-installed/Flash
          echo $((2062/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) ARGON='1'
          COMPAT='1'
          LIB='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_USB
}

# USB判定
function _func_USB {
str_USB=`dmesg | grep -s usb`
if [ -n "$str_USB" ]; then
block_mount=`opkg list-installed block-mount | awk '{ print $1 }'`
kmod_usb_storage=`opkg list-installed kmod-usb-storage | awk '{ print $1 }'`
kmod_usb_storage_uas=`opkg list-installed kmod-usb-storage-uas| awk '{ print $1 }'`
usbutils=`opkg list-installed usbutils | awk '{ print $1 }'`
gdisk=`opkg list-installed gdisk | awk '{ print $1 }'`
libblkid1=`opkg list-installed libblkid1 | awk '{ print $1 }'`
kmod_usb_ledtrig_usbport=`opkg list-installed kmod-usb-ledtrig-usbport | awk '{ print $1 }'`
luci_app_ledtrig_usbport=`opkg list-installed luci-app-ledtrig-usbport | awk '{ print $1 }'`
if [ -z "$block_mount" ] || [  -z "$kmod_usb_storage" ] || [  -z "$kmod_usb_storage_uas" ] || [  -z "$usbutils" ] || [ -z "$gdisk" ] || [ -z  "$libblkid1" ] || [  -z "$kmod_usb_ledtrig_usbport" ] || [  -z "$luci_app_ledtrig_usbport" ]; then
while :
do
{
  echo -e " \033[1;32mインストールサイズ計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;32mUSBベースパッケージをインストールしますか\033[0;39m"
  echo -e " \033[1;32mblock-mount : $((`opkg info block-mount | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-usb-storage : $((`opkg info kmod-usb-storage | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-usb-storage-uas : $((`opkg info kmod-usb-storage-uas | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32musbutils : $((`opkg info usbutils | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mgdisk : $((`opkg info gdisk | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mlibblkid1 : $((`opkg info libblkid1 | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-usb-ledtrig-usbport : $((`opkg info kmod-usb-ledtrig-usbport | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-ledtrig-usbport : $((`opkg info luci-app-ledtrig-usbport | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  }
  case "${num}" in
    "y" ) echo block-mount >> /etc/config-software/list-installed/Before
          echo kmod-usb-storage >> /etc/config-software/list-installed/Before
          echo kmod-usb-storage-uas >> /etc/config-software/list-installed/Before
          echo usbutils >> /etc/config-software/list-installed/Before
          echo gdisk >> /etc/config-software/list-installed/Before
          echo libblkid1 >> /etc/config-software/list-installed/Before
          echo kmod-usb-ledtrig-usbport >> /etc/config-software/list-installed/Before
          echo luci-app-ledtrig-usbport >> /etc/config-software/list-installed/Before
          echo $((`opkg info block-mount | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-usb-storage | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-usb-storage-uas | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info usbutils | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info gdisk | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info libblkid1 | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-usb-ledtrig-usbport | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-ledtrig-usbport | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          break ;;
    "n" ) block_mount='1'
          kmod_usb_storage='1'
          kmod_usb_storage_uas='1'
          usbutils='1'
          gdisk='1'
          libblkid1='1'
          kmod_usb_ledtrig_usbport='1'
          luci_app_ledtrig_usbport='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
fi
_func_listinstalled_After 
# _func_FAT32
}

function _func_FAT32

function _func_

function _func_

function _func_

function _func_

function _func_

function _func_

function _func_


function _func_listinstalled_After {
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/After
awk -F, 'FNR==NR{a[$1]++; next} !a[$1]' /etc/config-software/list-installed/After /etc/config-software/list-installed/Before > /etc/config-software/list-installed/Difference
if [ -s /etc/config-software/list-installed/Difference ]; then
  while :
  do
    echo -e "\033[1;33m`cat /etc/config-software/list-installed/Difference`\033[0;39m"
    echo -e " \033[1;32mインストールサイズ合計: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
    echo -e " \033[1;32m利用可能フラッシュサイズ: ${AVAILABLE_FLASH}KB\033[0;39m"
    echo -e " \033[1;37m選択したパッケージのインストールを開始します\033[0;39m"
    read -p " 開始します [y/n or q]: " num
     case "${num}" in
      "y" ) _func_listinstalled ;;
      "n" ) _func_listinstalled_Before ;;
      "q" ) exit ;; 
    esac
  done
else
  echo -e " \033[1;36mインストールはありません\033[0;39m"
  read -p " 何かキーを押して終了して下さい"
fi
}

# ----------------------------------------------------------------

OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
 else
 read -p " バージョンが違うため終了します"
 exit
fi

 while :
 do
  AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;32m利用可能フラッシュサイズ: ${AVAILABLE_FLASH}KB\033[0;39m"
  echo -e " \033[1;37m選択インストール\033[0;39m"
  echo -e " \033[1;37mパッケージの選択を開始します\033[0;39m"
  echo -e " \033[1;37m・LuCi: luci（スナップショット）\033[0;39m"
  echo -e " \033[1;37m・LuCi日本語化: luci-i18n-base-ja\033[0;39m"
  echo -e " \033[1;37m・SFTPサーバー: openssh-sftp-server\033[0;39m"
  echo -e " \033[1;37m・WEB-SSHクライアント: luci-app-ttyd\033[0;39m"
  echo -e " \033[1;37m・CPU負荷分散: irqbalance\033[0;39m"
  echo -e " \033[1;37m・SQM: sqm-scripts\033[0;39m"
  echo -e " \033[1;37m・ネットワーク統計インターフェイス: luci-app-statistics\033[0;39m"
  echo -e " \033[1;37m・帯域幅モニター: nlbwmon\033[0;39m"
  echo -e " \033[1;37m・WiFiスケジュール:  wifischedule\033[0;39m"
  echo -e " \033[1;37m・テーマ OpenWrt: luci-theme-openwrt\033[0;39m"
  echo -e " \033[1;37m・テーマ マテリアル: luci-theme-material\033[0;39m"
  echo -e " \033[1;37m・テーマ OpenWrt2020: luci-theme-openwrt-2020\033[0;39m"
  echo -e " \033[1;37m・ログ情報: luci-app-log（カスタムフィード）\033[0;39m"
  echo -e " \033[1;37m・CPUステータス: luci-app-cpu-status（カスタムフィード）\033[0;39m"
  echo -e " \033[1;37m・CPUパフォーマンス: luci-app-cpu-perf（カスタムフィード）\033[0;39m"
  echo -e " \033[1;37m・温度センサー（カスタムフィード）\033[0;39m"
  echo -e " \033[1;37m・インターネット可用性確認: internet-detector（カスタムフィード）\033[0;39m"
  echo -e " \033[1;37m・テーマ ARGON: luci-theme-argon（カスタムフィード）\033[0;39m"
  str_USB=`dmesg | grep -s usb`
  if [ -n "$str_USB" ]; then
  echo -e " \033[1;37m・USB: block-mount\033[0;39m"
  echo -e " \033[1;37m・USB: kmod-usb-storage\033[0;39m"
  echo -e " \033[1;37m・USB: kmod-usb-storage-uas\033[0;39m"
  echo -e " \033[1;37m・USB: usbutils\033[0;39m"
  echo -e " \033[1;37m・USB: gdisk\033[0;39m"
  echo -e " \033[1;37m・USB: libblkid1\033[0;39m"
  echo -e " \033[1;37m・USB: kmod-usb-ledtrig-usbport\033[0;39m"
  echo -e " \033[1;37m・USB: luci-app-ledtrig-usbport\033[0;39m"
  echo -e " \033[1;37m・FAT32: dosfstools\033[0;39m"
  echo -e " \033[1;37m・FAT32: kmod-fs-vfat\033[0;39m"
  echo -e " \033[1;37m・ext4: e2fsprogs\033[0;39m"
  echo -e " \033[1;37m・ext4: kmod-fs-ext4\033[0;39m"
  echo -e " \033[1;37m・f2fs: f2fs-tools\033[0;39m"
  echo -e " \033[1;37m・f2fs: kmod-fs-f2fs\033[0;39m"
  echo -e " \033[1;37m・exFAT: exfat-fsck\033[0;39m"
  echo -e " \033[1;37m・exFAT: kmod-fs-exfat\033[0;39m"
  echo -e " \033[1;37m・NTFS: ntfs-3g\033[0;39m"
  echo -e " \033[1;37m・NTFS: kmod-fs-ntfs3\033[0;39m"
  echo -e " \033[1;37m・HFS & HFS+: hfsfsck\033[0;39m"
  echo -e " \033[1;37m・HFS & HFS+: kmod-fs-hfs\033[0;39m"
  echo -e " \033[1;37m・HFS & HFS+: kmod-fs-hfsplus\033[0;39m"
  echo -e " \033[1;37m・HDDアイドル: hdparm\033[0;39m"
  echo -e " \033[1;37m・HDDアイドル: hd-idle\033[0;39m"
  echo -e " \033[1;37m・HDDアイドル: luci-app-hd-idle\033[0;39m"
  echo -e " \033[1;37m・HDDアイドル: luci-i18n-hd-idle-ja\033[0;39m"
  fi
  read -p " 選択を開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_listinstalled_Before ;;
    "n" ) exit ;;
  esac
 done

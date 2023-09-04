#! /bin/sh
# OpenWrt >= 21.02:


function _func_PACKAGE_INSTALL {

# アップデート
if [ ! -e ${UPDATE} ]; then
opkg update
fi


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
if [ -z "$NLBWMON_JA" ]; then
opkg install luci-app-nlbwmon
fi
if [ -z "$NLBWMON_JA" ]; then
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

# 追加テーマ
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
wget --no-check-certificate -O /tmp/luci-app-log_0.6-2_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/current/luci-app-log_0.6-2_all.ipk
opkg install /tmp/luci-app-log_0.6-2_all.ipk
rm /tmp/luci-app-log_0.6-2_all.ipk
fi

# CPUパフォーマンス
if [ -z "$CPU_PERFORMANCE" ]; then
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
 if [ "${OPENWRT_RELEAS:0:2}" = "23" ]; then
 wget --no-check-certificate -O /tmp/luci-app-cpu-perf_0.4-0_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/23.05/luci-app-cpu-perf_0.4-0_all.ipk opkg install /tmp/luci-app-cpu-perf_0.4-0_all.ipk
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

opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/After
diff -u /etc/config-software/list-installed/Before /etc/config-software/list-installed/After | grep ^+ | grep -v ^+++ | sed s/^+// > /etc/config-software/list-installed/Difference
if [ ! -s $`cat /etc/config-software/list-installed/Difference` ]; then
 echo -e " \033[1;37mインストールは完了しました\033[0;39m"
 read -p " 何かキーを押してデバイスを再起動してください"
 reboot
else
 echo -e " \033[1;37m失敗したインストール\033[0;39m"
 echo -e "\033[1;37m`cat /etc/config-software/list-installed/Difference`\033[0;39m"
 echo -e " \033[1;37m失敗したインストールを再試行します\033[0;39m"
 read -p " 何かキーを押すと再度スクリプトを開始します"
 _func_PACKAGE_INSTALL
fi

}

# ----------------------------------------------------------------

function _func_PACKAGE_SELECTOR {
mkdir -p /etc/config-software/list-installed
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/Before
}

# LuCiA
LUCI=`opkg list-installed luci | awk '{ print $1 }'`
if [ -n "$LUCI" ]; then
while :
do
  echo -e " \033[1;33mLuciをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) LUCI='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# LuCi日本語化
LUCI_JA=`opkg list-installed luci-i18n-base-ja | awk '{ print $1 }'`
LUCI_JA_OPKG=`opkg list-installed luci-i18n-opkg-ja | awk '{ print $1 }'`
LUCI_JA_FIREWALL=`opkg list-installed luci-i18n-firewall-ja | awk '{ print $1 }'`
if [ -z "$LUCI_JA" ]; then
while :
do
  echo -e " \033[1;33mLuci日本語化をインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-i18n-base-ja >> /etc/config-software/list-installed/Before
          echo luci-i18n-opkg-ja >> /etc/config-software/list-installed/Before
          echo luci-i18n-firewall-ja >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) LUCI_JA='1'
          LUCI_JA_OPKG='1'
          LUCI_JA_FIREWALL='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# SFTPサーバー
SFTP=`opkg list-installed openssh-sftp-server | awk '{ print $1 }'`
if [ -z "$SFTP" ]; then
while :
do
  echo -e " \033[1;33mSFTPサーバーをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo openssh-sftp-server >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) SFTP='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# CPU負荷分散
CPU=`opkg list-installed irqbalance | awk '{ print $1 }'`
while :
do
if [ -z "$CPU" ]; then
 CPU_INFO=`fgrep 'processor' /proc/cpuinfo | wc -l`
 if [ "$CPU_INFO" -gt 3 ]; then
while :
do
    echo -e " \033[1;33mCPU負荷分散をインストールしますか\033[0;39m"
    read -p " キーを選択してください [y/n or q]: " num
    case "${num}" in
      "y" ) echo irqbalance >> /etc/config-software/list-installed/Before
            break ;;
      "n" ) CPU='1'
            break ;;
      "q" ) exit ;;
    esac
done
fi

# SQM
SQM=`opkg list-installed sqm-scripts | awk '{ print $1 }'`
SQM_APP=`opkg list-installed luci-app-sqm | awk '{ print $1 }'`
SQM_APP_JA=`opkg list-installed luci-i18n-sqm-ja | awk '{ print $1 }'`
if [ -z "$SQM" ]; then
while :
do
  echo -e " \033[1;33mSQMをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo sqm-scripts >> /etc/config-software/list-installed/Before
          echo luci-app-sqm >> /etc/config-software/list-installed/Before
          echo luci-i18n-sqm-ja >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) SQM='1'
          SQM_APP='1'
          SQM_APP_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# ネットワーク統計インターフェイス
STATUS=`opkg list-installed luci-app-statistics | awk '{ print $1 }'`
STATUS_JA=`opkg list-installed luci-i18n-statistics-ja | awk '{ print $1 }'`
if [ -z "$STATUS" ]; then
while :
do
  echo -e " \033[1;33mネットワーク統計インターフェイスをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-statistics >> /etc/config-software/list-installed/Before
          echo luci-i18n-statistics-ja >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) STATUS='1'
          STATUS_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# 帯域幅モニター
NLBWMON=`opkg list-installed nlbwmon | awk '{ print $1 }'`
NLBWMON_JA=`opkg list-installed luci-app-nlbwmon | awk '{ print $1 }'`
NLBWMON_JA=`opkg list-installed luci-i18n-nlbwmon-ja | awk '{ print $1 }'`
if [ -z "$NLBWMON" ]; then
while :
do
  echo -e " \033[1;33m帯域幅モニターをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo nlbwmon >> /etc/config-software/list-installed/schedule
          echo luci-app-nlbwmon >> /etc/config-software/list-installed/schedule
          echo luci-i18n-nlbwmon-ja >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) NLBWMON='1'
          NLBWMON_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# WiFiスケジュール
WIFISCHEDULE=`opkg list-installed wifischedule | awk '{ print $1 }'`
WIFISCHEDULE_APP=`opkg list-installed luci-app-wifischedule | awk '{ print $1 }'`
WIFISCHEDULE_APP_JA=`opkg list-installed luci-i18n-wifischedule-ja | awk '{ print $1 }'`
if [ -z "$WIFISCHEDULE" ]; then
while :
do
  echo -e " \033[1;33mWiFiスケジュールをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci >> /etc/config-software/list-installed/schedule
          echo luci-app-wifischedule >> /etc/config-software/list-installed/Before
          echo luci-i18n-wifischedule-ja >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) WIFISCHEDULE='1'
          WIFISCHEDULE_APP='1'
          WIFISCHEDULE_APP_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# 追加テーマ
THEME_OPENWRT=`opkg list-installed luci-theme-openwrt | awk '{ print $1 }'`
THEME_MATERIAL=`opkg list-installed luci-theme-material | awk '{ print $1 }'`
THEME_2020=`opkg list-installed luci-theme-openwrt-2020 | awk '{ print $1 }'`
if [ -z "$THEME_OPENWRT" ]; then
while :
do
  echo -e " \033[1;33m追加テーマをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-openwrt >> /etc/config-software/list-installed/Before
          echo luci-theme-material >> /etc/config-software/list-installed/Before
          echo luci-theme-openwrt-2020 >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) THEME_OPENWRT='1'
          THEME_MATERIAL='1'
          THEME_2020='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# ログ情報
LOG=`opkg list-installed luci-app-log | awk '{ print $1 }'`
if [ -z "$LOG" ]; then
while :
do
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;33mログ情報をインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-log >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) LOG='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# CPUステータス
CPU_STATUS=`opkg list-installed luci-app-cpu-status | awk '{ print $1 }'`
if [ -z "$CPU_STATUS" ]; then
while :
do
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;33mCPUステータスをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-cpu-status >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) CPU_STATUS='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# CPUパフォーマンス
CPU_PERFORMANCE=`opkg list-installed luci-app-cpu-perf | awk '{ print $1 }'`
if [ -z "$CPU_PERFORMANCE" ]; then
while :
do
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;33mCPUパフォーマンスをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-cpu-perf >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) CPU_PERFORMANCE='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# 温度センサー
TMP_STATUS=`opkg list-installed luci-app-temp-status | awk '{ print $1 }'`
if [ -z "$TMP_STATUS" ]; then
while :
do
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;33mCPUパフォーマンスをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-temp-status >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) TMP_STATUS='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# インターネット可用性確認
DETECTER=`opkg list-installed internet-detector | awk '{ print $1 }'`
DETECTER_APP=`opkg list-installed luci-app-internet-detector | awk '{ print $1 }'`
if [ -z "$DETECTER" ]; then
while :
do
  echo -e " \033[1;34mカスタムフィード\033[0;39m"
  echo -e " \033[1;33mCPUパフォーマンスをインストールしますか\033[0;39m"
  read -p " キーを選択してください [y/n or q]: " num
  case "${num}" in
    "y" ) echo internet-detector >> /etc/config-software/list-installed/Before
          echo luci-app-internet-detector >> /etc/config-software/list-installed/Before
          break ;;
    "n" ) DETECTER='1'
          DETECTER_APP='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi

# DIFF
DIFF=`opkg list-installed diffutils | awk '{ print $1 }'`
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ -z "$DIFF" ]; then
 if [ ! -e ${UPDATE} ]; then
 opkg update
 fi
opkg install diffutils
fi

opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/After
diff -u /etc/config-software/list-installed/Before /etc/config-software/list-installed/After | grep ^+ | grep -v ^+++ | sed s/^+// > /etc/config-software/list-installed/Difference
if [ ! -s $`cat /etc/config-software/list-installed/Difference` ]; then
  echo -e " \033[1;37mインストールはありません\033[0;39m"
  read -p " 何かキーを押して終了して下さい"
  exit
fi

while :
do
  echo -e "\033[1;37m`cat /etc/config-software/list-installed/Difference`\033[0;39m"
  read -p " インストールを開始します [y/n or q]: " num
   case "${num}" in
    "y" ) _func_PACKAGE_INSTALL ;;
    "n" ) _func_PACKAGE_SELECTOR ;;
    "q" ) exit ;; 
  esac
done

# ----------------------------------------------------------------

while :
do
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
else
 read -p " バージョンが違うため終了します"
 exit
fi

  echo -e " \033[1;35mパッケージの選択をしてからインストールを開始します\033[0;39m"
  read -p " パッケージの選択を開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_PACKAGE_SELECTOR ;;
    "n" ) exit ;;
  esac
done

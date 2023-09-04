#! /bin/sh
# OpenWrt >= 21.02:




function _func_listinstalled_Before {
mkdir -p /etc/config-software/list-installed
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/Before
_func_luci
}

function _func_luci {
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
_func_lucii18nbaseja
}

function _func_lucii18nbaseja {
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
_func_opensshsftpserver
}

function _func_opensshsftpserver {
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
_func_irqbalance
}

function _func_irqbalance {
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
_func_sqmscripts
}

function _func_sqmscripts {
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
_func_luciappstatistics
}

function _func_luciappstatistics {
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
_func_nlbwmon
}

function _func_nlbwmon {
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
_func_wifischedule
}

function _func_wifischedule {
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
_func_lucithemeopenwrt
}

function _func_lucithemeopenwrt {
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
_func_luciapplog
}

function _func_luciapplog {
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
_func_luciappcpustatus
}

function _func_luciappcpustatus {
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
_func_luciappcpuperf
}

function _func_luciappcpuperf {
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
_func_luciapptempstatus
}

function _func_luciapptempstatus {
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
_func_internetdetector
}

function _func_internetdetector {
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
_func_diffutils
}

function _func_diffutils {
DIFF=`opkg list-installed diffutils | awk '{ print $1 }'`
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ -z "$DIFF" ]; then
 if [ ! -e ${UPDATE} ]; then
 opkg update
 fi
opkg install diffutils
fi
_func_listinstalled_After
}

function _func_listinstalled_After {
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
    "y" ) ;;
    "n" ) _func_listinstalled_Before ;;
    "q" ) exit ;; 
  esac
done
}

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
    "y" ) _func_listinstalled_Before ;;
    "n" ) exit ;;
  esac
done

#! /bin/sh
# OpenWrt >= 21.02:


function _func_Languages_code {
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
  read -p " Please select key [y/n or r]: " num
  echo -e " \033[1;32mLanguages: $input_str_Languages\033[0;39m"
  case "${num}" in
    "y" ) if [ -z "$input_str_Languages" ]; then
          _func_Languages_code
          fi
          _func_listinstalled_Before ;;
    "n" ) _func_Languages ;;
    "r" ) exit ;;
  esac
done
}

function _func_listinstalled_Before {
if [ -e ${UPDATE} ]; then
opkg update
UPDATE="1"
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
  echo -e " \033[1;32mInstallable size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
  echo -e " \033[1;33mInstall LuCI\033[0;39m"
  echo -e " \033[1;32mluci: $((`opkg info luci | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
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
_func_luci_ssl
}

function _func_luci_ssl {
LUCI_SSL=`opkg list-installed luci-ssl | awk '{ print $1 }'`
if [ -z "$LUCI_SSL" ]; then
while :
do
{
  echo -e " \033[1;33mInstall LuCI SSL\033[0;39m"
  echo -e " \033[1;32mluci-ssl: $((`opkg info luci-ssl | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  }
  case "${num}" in
    "y" ) echo luci-ssl >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-ssl | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) LUCI_SSL='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_lucii18nbaseja
}

function _func_lucii18nbaseja {
LUCI_JA=`opkg list-installed luci-i18n-base-$input_str_Languages | awk '{ print $1 }'`
#LUCI_JA_OPKG=`opkg list-installed luci-i18n-opkg-$input_str_Languages | awk '{ print $1 }'`
LUCI_JA_FIREWALL=`opkg list-installed luci-i18n-firewall-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$LUCI_JA" ] || [ -z "$LUCI_JA_OPKG" ] || [ -z "$LUCI_JA_FIREWALL" ]; then
while :
do
  echo -e " \033[1;33mInstall LuCi language pack\033[0;39m"
  echo -e " \033[1;32mluci-i18n-base-$input_str_Languages: $((`opkg info luci-i18n-base-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
# echo -e " \033[1;32mluci-i18n-opkg-$input_str_Languages: $((`opkg info luci-i18n-opkg-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-firewall-$input_str_Languages: $((`opkg info luci-i18n-firewall-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-i18n-base-$input_str_Languages >> /etc/config-software/list-installed/Before
#         echo luci-i18n-opkg-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo luci-i18n-firewall-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-base-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
#         echo $((`opkg info luci-i18n-opkg-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-i18n-firewall-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) LUCI_JA='1'
#         LUCI_JA_OPKG='1'
          LUCI_JA_FIREWALL='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_dashboard
}

function _func_dashboard {
DBB=`opkg list-installed luci-mod-dashboard | awk '{ print $1 }'`
DBB_JA=`opkg list-installed luci-i18n-dashboard-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$DBB" ] || [ -z "$DBB_JA" ]; then
while :
do
  echo -e " \033[1;33mInstall Dashboard\033[0;39m"
  echo -e " \033[1;32mluci-mod-dashboard: $((`opkg info luci-mod-dashboard | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-dashboard-$input_str_Languages: $((`opkg info luci-i18n-dashboard-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-mod-dashboard >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-mod-dashboard | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-dashboard-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-dashboard-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) DBB='1'
          DBB_JA='1'
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
  echo -e " \033[1;33mInstall SFTP server\033[0;39m"
  echo -e " \033[1;32mopenssh-sftp-server: $((`opkg info openssh-sftp-server | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo openssh-sftp-server >> /etc/config-software/list-installed/Before
          echo $((`opkg info openssh-sftp-server | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) SFTP='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_luci_app_ttyd
}

function _func_luci_app_ttyd {
TTYD=`opkg list-installed luci-app-ttyd | awk '{ print $1 }'`
TTYD_JA=`opkg list-installed luci-i18n-ttyd-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$TTYD" ] || [ -z "$TTYD_JA" ]; then
while :
do
  echo -e " \033[1;33mInstall ttyd\033[0;39m"
  echo -e " \033[1;32mluci-app-ttyd: $((`opkg info luci-app-ttyd | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-ttyd-$input_str_Languages: $((`opkg info luci-i18n-ttyd-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-ttyd >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-app-ttyd | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-ttyd-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-ttyd-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) TTYD='1'
          TTYD_JA='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_coreutils
}

function _func_coreutils {
CORE=`opkg list-installed coreutils | awk '{ print $1 }'`
if [ -z "$CORE" ]; then
while :
do
    echo -e " \033[1;33mInstall coreutils\033[0;39m"
    echo -e " \033[1;32mcoreutils: $((`opkg info coreutils | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
    read -p " Please select key [y/n or q]: " num
    case "${num}" in
      "y" ) echo irqbalance >> /etc/config-software/list-installed/Before
            echo $((`opkg info coreutils | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
            echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
            break ;;
      "n" ) CORE='1'
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
    echo -e " \033[1;33mInstall irqbalance\033[0;39m"
    echo -e " \033[1;32mirqbalance: $((`opkg info irqbalance | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
    read -p " Please select key [y/n or q]: " num
    case "${num}" in
      "y" ) echo irqbalance >> /etc/config-software/list-installed/Before
            echo $((`opkg info irqbalance | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
            echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
SQM_APP_JA=`opkg list-installed luci-i18n-sqm-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$SQM" ] || [ -z "$SQM_APP" ] || [ -z "$SQM_APP_JA" ]; then
while :
do
  echo -e " \033[1;33mInstall SQM\033[0;39m"
  echo -e " \033[1;32msqm-scripts: $((`opkg info sqm-scripts | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-sqm: $((`opkg info luci-app-sqm | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-sqm-$input_str_Languages: $((`opkg info luci-i18n-sqm-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo sqm-scripts >> /etc/config-software/list-installed/Before
          echo luci-app-sqm >> /etc/config-software/list-installed/Before
          echo $((`opkg info sqm-scripts | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-sqm | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-sqm-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-sqm-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
STATUS_JA=`opkg list-installed luci-i18n-statistics-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$STATUS" ] || [ -z "$STATUS_JA" ]; then
while :
do
  echo -e " \033[1;33mInstall statistics\033[0;39m"
  echo -e " \033[1;32mluci-app-statistics: $((`opkg info luci-app-statistics | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-statistics-$input_str_Languages: $((`opkg info luci-i18n-statistics-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-statistics >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-app-statistics | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-statistics-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-statistics-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
NLBWMON_APP_JA=`opkg list-installed luci-i18n-nlbwmon-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$NLBWMON" ] || [ -z "$NLBWMON_APP" ] || [ -z "$NLBWMON_APP_JA" ]; then
while :
do
  echo -e " \033[1;33mInstall nlbwmon\033[0;39m"
  echo -e " \033[1;32mnlbwmon: $((`opkg info nlbwmon | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-nlbwmon: $((`opkg info luci-app-nlbwmon | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-nlbwmon-$input_str_Languages: $((`opkg info luci-i18n-nlbwmon-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo nlbwmon >> /etc/config-software/list-installed/schedule
          echo luci-app-nlbwmon >> /etc/config-software/list-installed/schedule
          echo $((`opkg info nlbwmon | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-nlbwmon | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-nlbwmon-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-nlbwmon-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
WIFISCHEDULE_APP_JA=`opkg list-installed luci-i18n-wifischedule-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$WIFISCHEDULE" ] || [ -z "$WIFISCHEDULE_APP" ] || [ -z "$WIFISCHEDULE_APP_JA" ]; then
while :
do
  echo -e " \033[1;33mInstall wifi schedule\033[0;39m"
  echo -e " \033[1;32mwifischedule: $((`opkg info wifischedule | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-wifischedule: $((`opkg info luci-app-wifischedule | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-wifischedule-$input_str_Languages: $((`opkg info luci-i18n-wifischedule-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo wifischedule >> /etc/config-software/list-installed/schedule
          echo luci-app-wifischedule >> /etc/config-software/list-installed/Before
          echo $((`opkg info wifischedule | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-wifischedule | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-wifischedule-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-wifischedule-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
  echo -e " \033[1;33mInstall Themes openWrt\033[0;39m"
  echo -e " \033[1;32mluci-theme-openwrt: $((`opkg info luci-theme-openwrt | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-openwrt >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-theme-openwrt | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
  echo -e " \033[1;33mInstall Themes material\033[0;39m"
  echo -e " \033[1;32mluci-theme-material: $((`opkg info luci-theme-material | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-material >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-theme-material | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
  echo -e " \033[1;33mInstall Themes  OpenWrt2020\033[0;39m"
  echo -e " \033[1;32mluci-theme-openwrt-2020: $((`opkg info luci-theme-openwrt-2020 | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-openwrt-2020 >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-theme-openwrt-2020 | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) THEME_2020='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_attendedsysupgrade
}

function _func_attendedsysupgrade {
Attended_common=`opkg list-installed attendedsysupgrade-common | awk '{ print $1 }'`
Attended=`opkg list-installed luci-app-attendedsysupgrade | awk '{ print $1 }'`
Attended_ja=`opkg list-installed luci-i18n-attendedsysupgrade-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$Attended_common" ] || [ -z "$Attended" ] || [ -z "$Attended_ja" ]; then
while :
do
  echo -e " \033[1;33mInstall Attended Sysupgrade\033[0;39m"
  echo -e " \033[1;32mattendedsysupgrade-common: $((`opkg info attendedsysupgrade-common | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-attendedsysupgrade: $((`opkg info luci-app-attendedsysupgrade | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-attendedsysupgrade-$input_str_Languages: $((`opkg info luci-i18n-attendedsysupgrade-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo attendedsysupgrade-common >> /etc/config-software/list-installed/Before
          echo luci-app-attendedsysupgrade >> /etc/config-software/list-installed/Before
          echo $((`opkg info attendedsysupgrade-common | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-attendedsysupgrade | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-attendedsysupgrade-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-attendedsysupgrade-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) Attended_common='1'
          Attended='1'
          Attended_ja='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_luciapplog
}

function _func_luciapplog {
LOG=`opkg list-installed luci-app-log-viewer | awk '{ print $1 }'`
if [ -z "$LOG" ]; then
while :
do
  echo -e " \033[1;34mcustom feed\033[0;39m"
  echo -e " \033[1;33mInstall log viewer\033[0;39m"
  echo -e " \033[1;32mluci-app-log-viewer: $((5791/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-log-viewer >> /etc/config-software/list-installed/Before
          echo $((5791/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
  echo -e " \033[1;34mcustom feed\033[0;39m"
  echo -e " \033[1;33mInstall cpu status\033[0;39m"
  echo -e " \033[1;32mluci-app-cpu-status: $((1445/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-cpu-status >> /etc/config-software/list-installed/Before
          echo $((1445/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
  echo -e " \033[1;34mcustom feed\033[0;39m"
  echo -e " \033[1;33mInstall cpu perf\033[0;39m"
  echo -e " \033[1;32mluci-app-cpu-perf: $((6519/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-cpu-perf >> /etc/config-software/list-installed/Before
          echo $((0/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
  echo -e " \033[1;34mcustom feed\033[0;39m"
  echo -e " \033[1;33mInstall temp status\033[0;39m"
  echo -e " \033[1;32mluci-app-temp-status: $((2032/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-temp-status >> /etc/config-software/list-installed/Before
          echo $((2032/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
if [ -z "$DETECTER" ] || [ -z "$DETECTER_APP" ]; then
while :
do
  echo -e " \033[1;34mcustom feed\033[0;39m"
  echo -e " \033[1;33mInstall internet detector\033[0;39m"
  echo -e " \033[1;32minternet-detector: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-internet-detector: $((7771/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo internet-detector >> /etc/config-software/list-installed/Before
          echo luci-app-internet-detector >> /etc/config-software/list-installed/Before
          echo $((10680/1024)) >> /etc/config-software/list-installed/Flash
          echo $((7771/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
if [ -z "$ARGON" ] || [ -z "$COMPAT" ] || [ -z "$LIB" ]; then
while :
do
  echo -e " \033[1;34mcustom feed\033[0;39m"
  echo -e " \033[1;33mInstall Theme ARGON\033[0;39m"
  echo -e " \033[1;32mluci-theme-argon: $((388904/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-compat: $((46213/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-lib-ipkg: $((2062/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-theme-argon\033[0;39m"
  echo -e " \033[1;32mluci-compat\033[0;39m"
  echo -e " \033[1;32mluci-lib-ipkg\033[0;39m"  
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-theme-argon >> /etc/config-software/list-installed/Before
          echo luci-compat >> /etc/config-software/list-installed/Before
          echo luci-lib-ipkg >> /etc/config-software/list-installed/Before
          echo $((388904/1024)) >> /etc/config-software/list-installed/Flash
          echo $((46213/1024)) >> /etc/config-software/list-installed/Flash
          echo $((2062/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
if [ -n "$str_USB" ]; then
_func_DISK_INFO
else
luci_app_disks_info='1'
block_mount='1'
kmod_usb_storage='1'
kmod_usb_storage_uas='1'
usbutils='1'
gdisk='1'
libblkid1='1'
kmod_usb_ledtrig_usbport='1'
luci_app_ledtrig_usbport='1'
dosfstools='1'
kmod_fs_vfat='1'
e2fsprogs='1'
kmod_fs_ext4='1'
f2fs_tools='1'
kmod_fs_f2fs='1'
exfat_fsck='1'
kmod_fs_exfat='1'
ntfs_3g='1'
kmod_fs_ntfs3='1'
hfsfsck='1'
kmod_fs_hfs='1'
kmod_fs_hfsplus='1'
hdparm='1'
hd_idle='1'
luci_app_hd_idle='1'
luci_i18n_hd_idle_ja='1'

_func_listinstalled_After
fi
}

# ディスクインフォ
function _func_DISK_INFO {
luci_app_disks_info=`opkg list-installed luci-app-disks-info | awk '{ print $1 }'`
if [ -z "$luci_app_disks_info" ]; then
while :
do
  echo -e " \033[1;34mcustom feed\033[0;39m"
  echo -e " \033[1;33mInstall Disks Info\033[0;39m"
  echo -e " \033[1;32mluci-app-disks-info: $((481/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo luci-app-disks-info >> /etc/config-software/list-installed/Before
          echo $((481/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) luci_app_disks_info='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_USB_BASE
}

# USBベース
function _func_USB_BASE {
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
  echo -e " \033[1;33mInstall USB Base packages\033[0;39m"
  echo -e " \033[1;32mblock-mount : $((`opkg info block-mount | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-usb-storage : $((`opkg info kmod-usb-storage | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-usb-storage-uas : $((`opkg info kmod-usb-storage-uas | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32musbutils : $((`opkg info usbutils | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mgdisk : $((`opkg info gdisk | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mlibblkid1 : $((`opkg info libblkid1 | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-usb-ledtrig-usbport : $((`opkg info kmod-usb-ledtrig-usbport | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-ledtrig-usbport : $((`opkg info luci-app-ledtrig-usbport | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
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
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
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
_func_ext4
}

function _func_ext4 {
e2fsprogs=`opkg list-installed e2fsprogs | awk '{ print $1 }'`
kmod_fs_ext4=`opkg list-installed kmod-fs-ext4 | awk '{ print $1 }'`
if [ -z "$e2fsprogs" ] || [ -z "$kmod_fs_ext4" ]; then
while :
do
  echo -e " \033[1;33mInstall ext4\033[0;39m"
  echo -e " \033[1;32me2fsprogs: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-fs-ext4: $((7771/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo e2fsprogs >> /etc/config-software/list-installed/Before
          echo kmod-fs-ext4 >> /etc/config-software/list-installed/Before
          echo $((`opkg info e2fsprogs | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-fs-ext4 | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) e2fsprogs='1'
          kmod_fs_ext4='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_f2fs
}

function _func_f2fs {
f2fs_tools=`opkg list-installed f2fs-tools | awk '{ print $1 }'`
kmod_fs_f2fs=`opkg list-installed kmod-fs-f2fs | awk '{ print $1 }'`
if [ -z "$f2fs_tools" ] || [ -z "$kmod_fs_f2fs" ]; then
while :
do
  echo -e " \033[1;33mInstall f2fs\033[0;39m"
  echo -e " \033[1;32mf2fs-tools: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-fs-f2fs: $((7771/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo f2fs-tools >> /etc/config-software/list-installed/Before
          echo kmod-fs-f2fs >> /etc/config-software/list-installed/Before
          echo $((`opkg info f2fs-tools | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-fs-f2fs | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) f2fs_tools='1'
          kmod_fs_f2fs='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_FAT32
}

function _func_FAT32 {
dosfstools=`opkg list-installed dosfstools | awk '{ print $1 }'`
kmod_fs_vfat=`opkg list-installed kmod-fs-vfat | awk '{ print $1 }'`
if [ -z "$dosfstools" ] || [ -z "$kmod_fs_vfat" ]; then
while :
do
  echo -e " \033[1;33mInstall FAT32\033[0;39m"
  echo -e " \033[1;32mdosfstools: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-fs-vfat: $((7771/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo dosfstools >> /etc/config-software/list-installed/Before
          echo kmod-fs-vfat >> /etc/config-software/list-installed/Before
          echo $((`opkg info dosfstools | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-fs-vfat | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) dosfstools='1'
          kmod_fs_vfat='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_exFAT
}

function _func_exFAT {
exfat_fsck=`opkg list-installed exfat-fsck | awk '{ print $1 }'`
kmod_fs_exfat=`opkg list-installed kmod-fs-exfat | awk '{ print $1 }'`
if [ -z "$exfat_fsck" ] || [ -z "$kmod_fs_exfat" ]; then
while :
do
  echo -e " \033[1;33mInstall exFAT\033[0;39m"
  echo -e " \033[1;32mexfat-fsck: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-fs-exfat: $((7771/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo exfat-fsck >> /etc/config-software/list-installed/Before
          echo kmod-fs-exfat >> /etc/config-software/list-installed/Before
          echo $((`opkg info exfat-fsck | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-fs-exfat | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) exfat_fsck='1'
          kmod_fs_exfat='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_NTFS
}

function _func_NTFS {
ntfs_3g=`opkg list-installed ntfs-3g | awk '{ print $1 }'`
kmod_fs_ntfs3=`opkg list-installed kmod-fs-ntfs3 | awk '{ print $1 }'`
if [ -z "$ntfs_3g" ] || [ -z "$kmod_fs_ntfs3" ]; then
while :
do
  echo -e " \033[1;33mInstall NTFS\033[0;39m"
  echo -e " \033[1;32mntfs-3g: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-fs-ntfs3: $((7771/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo ntfs-3g >> /etc/config-software/list-installed/Before
          echo kmod-fs-ntfs3 >> /etc/config-software/list-installed/Before
          echo $((`opkg info ntfs-3g | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-fs-ntfs3 | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) ntfs_3g='1'
          kmod_fs_ntfs3='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_HFS
}

function _func_HFS {
hfsfsck=`opkg list-installed hfsfsck | awk '{ print $1 }'`
kmod_fs_hfs=`opkg list-installed kmod-fs-hfs | awk '{ print $1 }'`
kmod_fs_hfsplus=`opkg list-installed kmod-fs-hfsplus | awk '{ print $1 }'`
if [ -z "$hfsfsck" ] || [ -z "$kmod_fs_hfs" ] || [ -z "$kmod_fs_hfsplus" ]; then
while :
do
  echo -e " \033[1;33mInstall HFS & HFS+\033[0;39m"
  echo -e " \033[1;32mhfsfsck: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-fs-hfs: $((7771/1024))KB\033[0;39m"
  echo -e " \033[1;32mkmod-fs-hfsplus: $((5415/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo hfsfsck >> /etc/config-software/list-installed/Before
          echo kmod-fs-hfs >> /etc/config-software/list-installed/Before
          echo kmod-fs-hfsplus >> /etc/config-software/list-installed/Before
          echo $((`opkg info hfsfsck | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-fs-hfs | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info kmod-fs-hfsplus | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) hfsfsck='1'
          kmod_fs_hfs='1'
          kmod_fs_hfsplus='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_HDD
}

function _func_HDD {
hdparm=`opkg list-installed hdparm | awk '{ print $1 }'`
hd_idle=`opkg list-installed hd-idle | awk '{ print $1 }'`
luci_app_hd_idle=`opkg list-installed luci-app-hd-idle | awk '{ print $1 }'`
luci_i18n_hd_idle_ja=`opkg list-installed luci-i18n-hd-idle-$input_str_Languages | awk '{ print $1 }'`
if [ -z "$hdparm" ] || [ -z "$hd_idle" ] || [ -z "$luci_app_hd_idle" ] || [ -z "$luci_i18n_hd_idle_ja" ]; then
while :
do
  echo -e " \033[1;33mInstall HDD\033[0;39m"
  echo -e " \033[1;32mhd-idle: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-app-hd-idle: $((7771/1024))KB\033[0;39m"
  echo -e " \033[1;32mhfsfsck: $((10680/1024))KB\033[0;39m"
  echo -e " \033[1;32mluci-i18n-hd-idle-$input_str_Languages: $((7771/1024))KB\033[0;39m"
  read -p " Please select key [y/n or q]: " num
  case "${num}" in
    "y" ) echo hdparm >> /etc/config-software/list-installed/Before
          echo hd-idle >> /etc/config-software/list-installed/Before
          echo luci-app-hd-idle >> /etc/config-software/list-installed/Before
          echo $((`opkg info hdparm | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info hd-idle | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo $((`opkg info luci-app-hd-idle | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo luci-i18n-hd-idle-$input_str_Languages >> /etc/config-software/list-installed/Before
          echo $((`opkg info luci-i18n-hd-idle-$input_str_Languages | grep Size | awk '{ print $2 }'`/1024)) >> /etc/config-software/list-installed/Flash
          echo -e " \033[1;32mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
          break ;;
    "n" ) hdparm='1'
          hd_idle='1'
          luci_app_hd_idle='1'
          luci_i18n_hd_idle_ja='1'
          break ;;
    "q" ) exit ;;
  esac
done
fi
_func_listinstalled_After
}


function _func_listinstalled_After {
opkg list-installed | awk '{ print $1 }' > /etc/config-software/list-installed/After
awk -F, 'FNR==NR{a[$1]++; next} !a[$1]' /etc/config-software/list-installed/After /etc/config-software/list-installed/Before > /etc/config-software/list-installed/Difference
if [ -s /etc/config-software/list-installed/Difference ]; then
  while :
  do
    echo -e "\033[1;34m`cat /etc/config-software/list-installed/Difference`\033[0;39m"
    echo -e " \033[1;35mTotal installation size: `awk '{sum += $1} END {print sum}' < /etc/config-software/list-installed/Flash`KB\033[0;39m"
    echo -e " \033[1;35mAvailable flash sizes: ${AVAILABLE_FLASH}KB\033[0;39m"
    echo -e " \033[1;37mStart installation of the selected package\033[0;39m"
    read -p " Please select key [y/n or q]: " num
     case "${num}" in
      "y" ) _func_listinstalled ;;
      "n" ) _func_listinstalled_Before ;;
      "q" ) exit ;; 
    esac
  done
else
  echo -e " \033[1;36mNo installations\033[0;39m"
  read -p " Please any key"
  exit
fi
}

function _func_listinstalled {

# LuCi
if [ -z "$LUCI" ]; then
opkg install luci
fi
# LuCi SSl
if [ -z "$LUCI_SSL" ]; then
opkg install luci-ssl
fi
# LuCi Language
if [ -z "$LUCI_JA" ]; then
opkg install luci-i18n-base-$input_str_Languages
fi
#if [ -z "$LUCI_JA_OPKG" ]; then
#opkg install luci-i18n-opkg-$input_str_Languages
#fi
if [ -z "$LUCI_JA_FIREWALL" ]; then
opkg install luci-i18n-firewall-$input_str_Languages
fi

# Dashboard
if [ -z "$DBB" ]; then
opkg install luci-mod-dashboard
fi
if [ -z "$DBB_JA" ]; then
opkg install luci-i18n-dashboard-$input_str_Languages
fi

# SFTP Server
if [ -z "$SFTP" ]; then
opkg install openssh-sftp-server
fi

# ttyd
if [ -z "$TTYD" ]; then
opkg install luci-app-ttyd
uci set ttyd.@ttyd[0]=ttyd
uci set ttyd.@ttyd[0].interface='@lan'
uci set ttyd.@ttyd[0].command='/bin/login -f root '
uci set ttyd.@ttyd[0].ipv6='1'
uci set ttyd.@ttyd[0].debug='7'
uci set ttyd.@ttyd[0].url_arg='1'
uci commit ttyd
fi
if [ -z "$TTYD_JA" ]; then
opkg install luci-i18n-ttyd-$input_str_Languages
fi

# coreutils
if [ -z "$CORE" ]; then
opkg install coreutils
fi

# Irqbalance
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
opkg install luci-i18n-sqm-$input_str_Languages
fi

# statistics
if [ -z "$STATUS" ]; then
opkg install luci-app-statistics
/etc/init.d/collectd enable
fi
if [ -z "$STATUS_JA" ]; then
opkg install luci-i18n-statistics-$input_str_Languages
fi

# nlbwmon
if [ -z "$NLBWMON" ]; then
opkg install nlbwmon
fi
if [ -z "$NLBWMON_APP" ]; then
opkg install luci-app-nlbwmon
fi
if [ -z "$NLBWMON_APP_JA" ]; then
opkg install luci-i18n-nlbwmon-$input_str_Languages
fi

# wifi schedule
if [ -z "$WIFISCHEDULE" ]; then
opkg install wifischedule
fi
if [ -z "$WIFISCHEDULE_APP" ]; then
opkg install luci-app-wifischedule
fi
if [ -z "$WIFISCHEDULE_APP_JA" ]; then
opkg install luci-i18n-wifischedule-$input_str_Languages
fi

# Themes
if [ -z "$THEME_OPENWRT" ]; then
opkg install luci-theme-openwrt
fi
if [ -z "$THEME_MATERIAL" ]; then
opkg install luci-theme-material
fi
if [ -z "$THEME_2020" ]; then
opkg install luci-theme-openwrt-2020
fi

# Attended Sysupgrade
if [ -z "$Attended_common" ]; then
opkg install attendedsysupgrade-common
fi
if [ -z "$Attended" ]; then
opkg install luci-app-attendedsysupgrade
fi
if [ -z "$Attended_ja" ]; then
opkg install luci-i18n-attendedsysupgrade-$input_str_Languages
fi

# custom feed (log viewer, cpu status, cpu perf, temp status, Internet detector, disk info)
wget --no-check-certificate -O /etc/config-software/pacage_list https://github.com/gSpotx2f/packages-openwrt/raw/master/current/
PACAGE_LIST=`cat /etc/config-software/pacage_list |sed -ne '/ <script type/,/<\/script>/p' |sed -e 's/<[^>]*>//g'`
#echo $PACAGE_LIST

# log viewer
if [ -z "$LOG" ]; then
LOG_VIEWER=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-log-viewer") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
echo $LOG_VIEWER
wget --no-check-certificate -O /tmp/luci-app-log-viewer_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${LOG_VIEWER}.ipk
opkg install /tmp/luci-app-log-viewer_all.ipk
rm /tmp/luci-app-log-viewer_all.ipk
fi

# cpu status
if [ -z "$CPU_STATUS" ]; then
CPU_STATUS_V=`echo ${PACAGE_LIST} | awk '{ if (gsub(/luci-app-cpu-status-mini/, "HOGEHOGE")) print }' | awk '{print substr($0,index($0,"current/luci-app-cpu-status") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $CPU_STATUS_V
wget --no-check-certificate -O /tmp/luci-app-cpu-status_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${CPU_STATUS_V}.ipk
opkg install /tmp/luci-app-cpu-status_all.ipk
rm /tmp/luci-app-cpu-status_all.ipk
fi

# cpu perf
if [ -z "$CPU_PERFORMANCE" ]; then
CPU_PERF_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-cpu-perf") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $CPU_PERF_V
wget --no-check-certificate -O /tmp/luci-app-cpu-perf_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${CPU_PERF_V}.ipk
opkg install /tmp/luci-app-cpu-perf_all.ipk
rm /tmp/luci-app-cpu-perf_all.ipk
fi

# temp status
if [ -z "$TMP_STATUS" ]; then
TEMP_STATUS_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-temp-status") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $TEMP_STATUS_V
wget --no-check-certificate -O /tmp/luci-app-temp-status_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${TEMP_STATUS_V}.ipk
opkg install /tmp/luci-app-temp-status_all.ipk
rm /tmp/luci-app-temp-status_all.ipk
fi

# Internet detector
if [ -z "$DETECTER" ]; then
INTERNET_DETECTOR=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/internet-detector_") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $INTERNET_DETECTOR
wget --no-check-certificate -O /tmp/internet-detector_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${INTERNET_DETECTOR}.ipk
opkg install /tmp/internet-detector_all.ipk
rm /tmp/internet-detector_all.ipk
/etc/init.d/internet-detector enable
fi
if [ -z "$DETECTER_APP" ]; then
LUCI_APP_INTERNET_DETECTER_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-internet-detector") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $LUCI_APP_INTERNET_DETECTER_V
wget --no-check-certificate -O /tmp/luci-app-internet-detector_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${LUCI_APP_INTERNET_DETECTER_V}.ipk
opkg install /tmp/luci-app-internet-detector_all.ipk
rm /tmp/luci-app-internet-detector_all.ipk
fi

# Theme ARGON (template)
ARGON_VERSION='2.3.1'
if [ -z "$ARGON" ]; then
wget --no-check-certificate -O /tmp/luci-theme-argon.ipk https://github.com/jerrykuku/luci-theme-argon/releases/download/v${ARGON_VERSION}/luci-theme-argon_${ARGON_VERSION}_all.ipk
opkg install /tmp/luci-theme-argon.ipk
rm /tmp/luci-theme-argon.ipk
fi
if [ -z "$COMPAT" ]; then
opkg install luci-compat
fi
if [ -z "$LIB" ]; then
opkg install luci-lib-ipkg
fi

# disks info
if [ -z "$luci_app_disks_info" ]; then
LUCI_APP_DISKA_INFO_V=`echo ${PACAGE_LIST} | awk '{print substr($0,index($0,"current/luci-app-disks-info") ,60)}' | awk '{ sub(".ipk.*$",""); print $0; }'`
#echo $LUCI_APP_DISKA_INFO_V
wget --no-check-certificate -O /tmp/luci-app-disks-info_all.ipk https://github.com/gSpotx2f/packages-openwrt/raw/master/${LUCI_APP_DISKA_INFO_V}.ipk
opkg install /tmp/luci-app-disks-info_all.ipk
rm /tmp/luci-app-disks-info_all.ipk
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
# USB LED USBPORT
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
  "y" ) _func_listinstalled ;;
  "n" )  read -p " Please any key (to reboot the device)"
         reboot ;;
  esac
done
else
 echo -e " \033[1;36mInstallation completed\033[0;39m"
 read -p " Please any key (to reboot the device)"
 reboot
fi
}

 while :
 do
  AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;32mAvailable flash sizes: ${AVAILABLE_FLASH}KB\033[0;39m"
  echo -e " \033[1;37mSelective installation\033[0;39m"
  echo -e " \033[1;37m・LuCi (Snapshot only)\033[0;39m"
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
  echo -e " \033[1;37m・USB：ext4\033[0;39m"
  echo -e " \033[1;37m・USB：f2fs\033[0;39m"
  echo -e " \033[1;37m・USB：FAT32 \033[0;39m"
  echo -e " \033[1;37m・USB：exFAT\033[0;39m"
  echo -e " \033[1;37m・USB：NTFS\033[0;39m"
  echo -e " \033[1;37m・USB：HFS & HFS+\033[0;39m"
  echo -e " \033[1;37m・USB：HDD\033[0;39m"
  fi
  echo -e " \033[1;37mselective installation\033[0;39m"
  read -p " Start installing package [y/n]: " num
  case "${num}" in
    "y" ) _func_Languages_code ;;
    "n" ) exit ;;
  esac
 done

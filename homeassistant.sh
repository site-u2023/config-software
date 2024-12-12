#! /bin/sh
. /lib/functions/network.sh
NET_IF="lan"
network_flush_cache
network_get_ipaddr NET_ADDR "${NET_IF}"

function _func_HomeAssistant {
while :
do
AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;37mAvailable Memory Space: ${AVAILABLE_MEMORY}KB\033[0;39m"
  echo -e " \033[1;37mAvailable Flash Space: ${AVAILABLE_FLASH}KB\033[0;39m"
  echo -e " \033[1;37mRecommended Memory Capacity: 262144KB\033[0;39m"
  echo -e " \033[1;37mRecommended Flash Capacity: 262144KB\033[0;39m"
  echo -e " \033[1;36mHome Assistant ---------------------------------------\033[0;39m"
  echo -e " \033[1;36m[c]: Install Home Assistant\033[0;39m"
  echo -e " \033[1;31m[b]: Delete Home Assistant\033[0;39m"
  echo -e " \033[1;37m[q]: Quit\033[0;39m"   
  echo -e " \033[1;36m------------------------------------------------------\033[0;39m"
  read -p " Please select key [c/b or q]: " num
  case "${num}" in
    "c" ) _func_HomeAssistant_Confirm ;;    
    "b" ) _func_HomeAssistant_Before ;;
    "q" ) exit ;;
  esac
done
}

function _func_HomeAssistant_Confirm {
while :
do
  echo -e " \033[1;35mStart Home Assistant installation\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_HomeAssistant_Install ;;
    "n" ) _func_HomeAssistant ;;
    "r" ) _func_HomeAssistant ;;
  esac
done
}

function _func_HomeAssistant_Install {
wget https://raw.githubusercontent.com/openlumi/homeassistant_on_openwrt/23.05/ha_install.sh -O - | sh
echo -e " \033[1;32mIInstallation is complete\033[0;39m"
echo -e " \033[1;32mAdministrative Web Interface: http://${NET_ADDR}:8123\033[0;39m"
read -p " Press any key (to reboot the device)"
reboot
exit
}

function _func_HomeAssistant_Before {
while :
do
  echo -e " \033[1;37mDelete Home Assistant\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_HomeAssistant_Restoration ;;
    "n" ) _func_HomeAssistant ;;
    "r" ) _func_HomeAssistant ;;
  esac
done
}

function _func_HomeAssistant_Restoration {
/etc/init.d/homeassistant stop
pip3 uninstall homeassistant
rm -R /etc/homeassistant
rm -R /usr/lib/python*/site-packages/hass_frontend
rm -R /usr/lib/python*/site-packages/hass_nabucasa-*
rm -R /usr/lib/python*/site-packages/home_assistant_frontend-*
rm -R /etc/homeassistant
rm /etc/init.d/homeassistant
reboot
exit
}

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "23" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
   _func_HomeAssistant
 else
   read -p " Exit due to different versions"
 exit
fi

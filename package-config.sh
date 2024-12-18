#! /bin/sh
# OpenWrt >= 21.02:


function _func_full_INST {
while :
do
  echo -e " \033[1;34Download automatic full installation scripts\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-auto.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto.sh
          sh /etc/config-software/package-auto.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_choice_INST {
while :
do
  echo -e " \033[1;33mDownload selective installation scripts\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-manual.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-manual.sh
          sh /etc/config-software/package-manual.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_after_INST {
while :
do
  echo -e " \033[1;31mDownload and run script to confirm installed package after flashing\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/install-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/install-config.sh
          sh /etc/config-software/install-config.sh
          read -p " Press any key"
          break ;;
    "n" ) break ;;
  esac
done
}

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
elif [[ "${OPENWRT_RELEAS}" = "SN" ]]; then
   wget --no-check-certificate -O /etc/config-software/package-auto-snapshot.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto-snapshot.sh
   sh /etc/config-software/package-auto-snapshot.sh
   exit
else
  read -p " Exit due to different versions"
fi

while :
do
  echo -e " \033[1;32mInstallation may fail\033[0;39m"
  echo -e " \033[1;37mPackage-config ---------------------------------------\033[0;39m"
  echo -e " \033[1;34m[f]: Automatic full installation\033[0;39m"
  echo -e " \033[1;33m[s]: Selective installation\033[0;39m"
  echo -e " \033[1;31m[a]: Confirmation of packages installed after flashing\033[0;39m"
  echo -e " \033[1;37m[q]: Quit\033[0;39m"
  echo -e " \033[1;32m------------------------------------------------------\033[0;39m"
  read -p " Please select key [f/s/a or q]: " num 
  case "${num}" in
    "f" ) _func_full_INST ;;
    "s" ) _func_choice_INST ;;
    "a" ) _func_after_INST ;;
    "q" ) exit ;;
  esac
done

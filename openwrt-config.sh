#! /bin/sh
# License: CC0
# OpenWrt >= 21.02:

function _func_INTERNET {
while :
do
  echo -e " \033[1;34mDownload scripts for Internet connection\033[0;39m"
  echo -e " \033[7;33mJapanese specification\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/internet-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/internet-config.sh
          sh /etc/config-software/internet-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_SYSTEM {
while :
do
  echo -e " \033[1;33mDownload scripts for initial system\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/system-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/system-config.sh
          sh /etc/config-software/system-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_PACKAGE {
while :
do
  echo -e " \033[1;32mDownload script for package setup (automatic or selective)\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-config.sh
          sh /etc/config-software/package-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_AD_DNS {
while :
do
  echo -e " \033[1;35mDownload scripts for ad blocker and DNS encryption\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/ad-dns-blocking-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ad-dns-blocking-config.sh
          sh /etc/config-software/ad-dns-blocking-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_ACCESSPOINT {
while :
do
  echo -e " \033[1;31mDownload scripts for access point\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/dumb-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dumb-config.sh
          sh /etc/config-software/dumb-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_HA {
while :
do
  echo -e " \033[1;36mDownload scripts for Home Assistant\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/homeassistant.sh https://raw.githubusercontent.com/site-u2023/config-software/main/homeassistant.sh
          sh /etc/config-software/homeassistant.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_ETC {
while :
do
  echo -e " \033[1;37mDownload other scripts\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/etc-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/etc-config.sh
          sh /etc/config-software/etc-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_QUIT {
while :
do
  echo -e " \033[7;40mDelete this and related scripts\033[0;39m"
  echo -e " \033[7;40mRestoration files will not be deleted\033[0;39m"
  read -p " Please select key [y/n or r]: " num
   case "${num}" in
    "y" ) rm -rf /etc/config-software
          rm -rf /usr/bin/confsoft
          echo -e " \033[7;40m This script and related scripts have been deleted and quit\033[0;39m"
          exit ;;
    "n" ) echo -e " \033[7;40m Quit\033[0;39m"
          exit ;;
    "r" ) break ;;
   esac 
done
}

for i in `seq 30 38` `seq 40 47` ; do
    for j in 0 1 2 3 4 5 6 7 ; do
        printf "\033[${j};${i}m"
        printf " ${j};${i} "
        printf "\033[0;39;49m"
        printf " "
    done
    printf "\n"
done
sleep 1

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "20" || "${OPENWRT_RELEAS}" = "19" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
 else
   read -p " Exit due to different versions"
 exit
fi

  AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
  AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  echo -e " \033[1;37mOpenWrt-Config\033[0;39m"
  echo -e " \033[1;37mLast update: April 12, 2024 at 11:57 AM.(JST)\033[0;39m"
  echo -e " \033[1;37mAvailable Memory Space: ${AVAILABLE_MEMORY}KB\033[0;39m"
  echo -e " \033[1;37mAvailable Flash Space: ${AVAILABLE_FLASH}KB\033[0;39m"
  str_USB=`dmesg | ls /sys/bus/usb/devices | grep -s usb`
  if [ -n "$str_USB" ]; then
    echo -e " \033[1;37mUSB device: Have\033[0;39m"
  else
    echo -e " \033[1;37mUSB device: Have not\033[0;39m"
  fi
  echo -e " \033[1;37mDirectory to install scripts: /etc/config-software/\033[0;39m" 
  echo -e " \033[1;37mhttps://github.com/site-u2023/config-software\033[0;39m" 
  echo -e " \033[1;37mhttps://qiita.com/site_u\033[0;39m" 
  echo -e " \033[6;41mWe take no responsibility for the use of this script\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p "  Press any key"
  echo -e 
  
while :
do
  echo -e " \033[1;33mMultilingual support (Partially unchanged)\033[0;39m"
  echo -e " \033[1;37mopenwrt-config --------------------------------------\033[0;39m"
  echo -e " \033[1;34m[i]: Internet connection setup in Japan (MAP-e, DS-LITE, PPPoE)\033[0;39m"
  echo -e " \033[1;33m[s]: Initial system setup (host name,password,wifi,etc.)\033[0;39m"
  echo -e " \033[1;32m[p]: Install recommended packages (automatic or selective)\033[0;39m"
  echo -e " \033[1;35m[b]: Install ad blocker and DNS encryption\033[0;39m"
  echo -e " \033[1;31m[a]: Access point connection setup (Dumb/Bridge)\033[0;39m"
  echo -e " \033[1;36m[h]: Install Home Assistant\033[0;39m"
  echo -e " \033[1;37m[e]: Other: BUTTON, IPERF3, SAMBA4, LBS, DFS Check, Guest Wi-Fi\033[0;39m"
  echo -e " \033[7;40m[q]: Quit (Delete this script or not)\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [i/s/p/b/a/h/e or q]: " num
  case "${num}" in
    "i" ) _func_INTERNET ;;
    "s" ) _func_SYSTEM ;;
    "p" ) _func_PACKAGE ;;
    "b" ) _func_AD_DNS ;;
    "a" ) _func_ACCESSPOINT ;;
    "h" ) _func_HA ;;
    "e" ) _func_ETC ;;
    "q" ) _func_QUIT ;;
  esac
 done

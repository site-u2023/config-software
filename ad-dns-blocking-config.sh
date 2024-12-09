#! /bin/sh
# License: CC0

function _func_AdGuard_INST {
while :
do
  echo -e " \033[1;34mDownload AdGuard HOME configuration script\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/adguard-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard-config.sh
          sh /etc/config-software/adguard-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_AdBlock_INST {
while :
do
  echo -e " \033[1;32mDownload AdBlock configuration script\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/adblock-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adblock-config.sh
          sh /etc/config-software/adblock-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_DoH {
while :
do
  echo -e " \033[1;32mDNS over HTTPS（DoH）Download configuration script\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/doh.sh https://raw.githubusercontent.com/site-u2023/config-software/main/doh.sh
          sh /etc/config-software/doh.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_DoT {
while :
do
  echo -e " \033[1;32mDNS over TLS（DoT）Download configuration script\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/dot.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dot.sh
          sh /etc/config-software/dot.sh
          break ;;
    "n" ) break ;;
  esac
done
}

while :
do
{
OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "SN" || "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "19" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
 else
   read -p " Exit due to different versions"
 exit
fi
}
  echo -e " \033[7;33mAdGuard HOME and AdBlock are used exclusively\033[0;39m"
  echo -e " \033[7;33mAdGuard and DNS over HTTPS (DoH) are used exclusively\033[0;39m"
  echo -e " \033[7;33mAdGuard and DNS over TLS (DoT) are used exclusively\033[0;39m"
  echo -e " \033[7;33mDNS over HTTPS (DoH) and DNS over TLS (DoT) are used exclusively\033[0;39m"
  echo -e " \033[1;35mAd dns blocking config ------------------------------\033[0;39m"
  echo -e " \033[1;34m[g]: AdGuard HOME configuration and installation\033[0;39m"
  echo -e " \033[1;32m[b]: AdBlockd installation and configuration (Japan only)\033[0;39m"
  echo -e " \033[1;31m[h]: DNS over HTTPS (DoH) configuration and installation\033[0;39m"
  echo -e " \033[1;33m[t]: DNS over TLS (DoT) configuration and installation\033[0;39m"
  echo -e " \033[1;37m[q]: Quit\033[0;39m"
  echo -e " \033[1;35m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [g/b/h/t or q]: " num
  case "${num}" in
    "g" ) _func_AdGuard_INST;;
    "b" ) _func_AdBlock_INST ;;
    "h" ) _func_DoH ;;
    "t" ) _func_DoT ;;
    "q" ) exit ;;
  esac
 done 

#! /bin/sh
. /lib/functions/network.sh
NET_IF="lan"
network_flush_cache
network_get_ipaddr NET_ADDR "${NET_IF}"

function _func_AdGuard {
if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
  echo -e " \033[1;37mAdGuard already installed\033[0;39m"
fi
DISTRIB_ARCH=$(grep 'DISTRIB_ARCH' /etc/openwrt_release | cut -d"'" -f2)
if  [ "${DISTRIB_ARCH}" = "aarch64_cortex-a53" ] || [ "${DISTRIB_ARCH}" = "arm_cortex-a7_neon-vfpv4" ] || [ "${DISTRIB_ARCH}" = "x86_64" ]; then
  echo -e " \033[1;37mSupported Architectures\033[0;39m"
while :
do
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[c]: AdGuard HOME configuration and installation\033[0;39m"
  echo -e " \033[1;33m[s]: Web interface configuration (port, username and password only)\033[0;39m"
  echo -e " \033[1;32m[b]: Removing and restoring AdGuard HOME to previous settings\033[0;39m"
  echo -e " \033[1;37m[q]: Quit\033[0;39m"   
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " Please select key [c/s/b or q]: " num
  case "${num}" in
    "c" ) _func_AdGuard_Confirm ;;
    "s" ) _func_AdGuard_Admin ;;        
    "b" ) _func_AdGuard_Before ;;
    "q" ) exit ;;
  esac
done
 else
  echo -e " \033[1;37mhttps://openwrt.org/packages/architectures\033[0;39m" 
  echo -e " \033[1;37mUnsupported Web interface configuration\033[0;39m" 
while :
do
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[c]: AdGuard HOME installation\033[0;39m"
  echo -e " \033[1;32m[b]: Removing and restoring AdGuard HOME to previous settings\033[0;39m"
  echo -e " \033[1;37m[q]: Quit\033[0;39m"   
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " Please select key [c/b or q]: " num
  case "${num}" in
    "c" ) _func_AdGuard_Only ;;      
    "b" ) _func_AdGuard_Before ;;
    "q" ) exit ;;
  esac
done
fi
}

function _func_AdGuard_Only {
while :
do
  echo -e " \033[1;32mInstall: adguardhome $((`opkg info adguardhome | grep Size | awk '{ print $2 }'`/1024))KB Version ${ADGUARD_VERSION}\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/adguard.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard.sh
          sh /etc/config-software/adguard.sh
          echo -e " \033[1;32mInstallation complete\033[0;39m"
          echo -e " \033[1;32mhttp://${NET_ADDR}:3000\033[0;39m"
          read -p " Press any key (to reboot the device)"
          reboot ;;    
    "n" ) break ;;
  esac
done
}

function _func_AdGuard_Confirm {
AD_INST="ad_inst"
if [ -e ${UPDATE} ]; then
opkg update
UPDATE="1"
fi
while :
do
  echo -e " \033[1;35mStart AdGuard HOME setup and installation\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface port number entry\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface user name entry\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface password entry\033[0;39m"
  echo -e " \033[1;32mInstall: adguardhome $((`opkg info adguardhome | grep Size | awk '{ print $2 }'`/1024))KB Version ${ADGUARD_VERSION}\033[0;39m"
  echo -e " \033[1;32mInstall: htpasswd: 63.90KB\033[0;39m"
  echo -e " \033[1;32mInstall: libaprutil $((`opkg info libaprutil | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mInstall: libapr $((`opkg info libapr | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mInstallル: libexpat $((`opkg info libexpat | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  read -p " Start inputting setpoints [y/n]: " num
  case "${num}" in
    "y" ) JA_FILTER='set'
          _func_AdGuard_Filter ;;
    "n" ) break ;;
  esac
done
}

function _func_AdGuard_Admin {
while :
do
  echo -e " \033[1;35mStart AdGuard HOME setup and installation\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface port number entry\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface user name entry\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface password entry\033[0;39m"
  read -p " Start inputting setpoints [y/n]: " num
  case "${num}" in
    "y" ) _func_AdGuard_Filter ;;
    "n" ) break ;;
  esac
done
}

function _func_AdGuard_Filter {
while :
do
  echo -e " \033[1;37mSet Japanese filter\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) JAPAN_FILTER="japan_filter" ;
          _func_AdGuard_PORT ;;
    "n" ) _func_AdGuard_PORT ;;
    "r" ) _func_AdGuard ;;    
  esac
done
}

function _func_AdGuard_PORT {
while :
do
  echo -e "\033[1;37m Web interfaceEnter port number\033[0;39m"
  echo -e "\033[1;33m Example: 8000\033[0;39m"
  read -p " port number: " input_str_PORT
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_USER ;;
    "n" ) _func_AdGuard_PORT ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_USER {
while :
do
  echo -e "\033[1;37m Web interface user name\033[0;39m"
  echo -e "\033[1;33m Example: root\033[0;39m"
  read -p " user name: " input_str_USER
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_PASSWD ;;
    "n" ) _func_AdGuard_USER ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_PASSWD {
while :
do
  echo -e " \033[1;37mWeb interface password\033[0;39m"
  echo -e " \033[1;33mExample: password\033[0;39m"
  read -p " password: " input_str_PASSWD
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_Confirm2 ;;
    "n" ) _func_AdGuard_PASSWD ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_Confirm2 {
while :
do
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  echo -e " \033[1;32mPort Number: ${input_str_PORT}\033[0;39m"
  echo -e " \033[1;32mUser Name: ${input_str_USER}\033[0;39m"
  echo -e " \033[1;32mPassword: ${input_str_PASSWD}\033[0;39m"
  if [ "set" = "${JA_FILTER}" ]; then
  echo -e " \033[1;32mFilter: japanese\033[0;39m"
  fi
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  echo -e " \033[1;32mAdministrative Web Interface: http://${NET_ADDR}:${input_str_PORT}\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_SET ;;
    "n" ) _func_AdGuard_PORT ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_SET {
if [ -e ${UPDATE} ]; then
opkg update
UPDATE="1"
fi
if [ -n "${JAPAN_FILTER}" ]; then
wget --no-check-certificate -O /etc/adguardhome.yaml-new https://raw.githubusercontent.com/site-u2023/config-software/main/adguardhome.yaml
 else
wget --no-check-certificate -O /etc/adguardhome.yaml-new https://raw.githubusercontent.com/site-u2023/config-software/main/adguardhome.yaml-g
fi
if  [ "${DISTRIB_ARCH}" = "='aarch64_cortex-a53'" ]; then
wget --no-check-certificate -O /usr/bin/htpasswd https://github.com/site-u2023/config-software/raw/main/htpasswd
fi
if  [ "${DISTRIB_ARCH}" = "='arm_cortex-a7_neon-vfpv4'" ]; then
wget --no-check-certificate -O /usr/bin/htpasswd https://github.com/site-u2023/config-software/raw/main/htpasswd-arm
fi
if  [ "${DISTRIB_ARCH}" = "='x86_64'" ]; then
wget --no-check-certificate -O /usr/bin/htpasswd https://github.com/site-u2023/config-software/raw/main/htpasswd-x86
fi
chmod +x /usr/bin/htpasswd
opkg install --nodeps libaprutil
opkg install --nodeps libapr
opkg install --nodeps libexpat
opkg install --nodeps libuuid1
if [ -n "${AD_INST}" ]; then
wget --no-check-certificate -O /etc/config-software/adguard.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard.sh
sh /etc/config-software/adguard.sh
fi
if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
service adguardhome stop
fi
if [ -e "/etc/adguardhome.yaml" ]; then
cp /etc/adguardhome.yaml /etc/adguardhome.yaml.old
fi
cp /etc/adguardhome.yaml-new /etc/adguardhome.yaml
sed -i "/\  address:/c \  address: 0.0.0.0:${input_str_PORT}" /etc/adguardhome.yaml
sed -i "5c \  - name: ${input_str_USER}" /etc/adguardhome.yaml
Bcrypt_PASSWD=`htpasswd -B -n -b ${input_str_USER} ${input_str_PASSWD}`
sed -i "6c \    password: ${Bcrypt_PASSWD#${input_str_USER}:}" /etc/adguardhome.yaml
sed -i -e "s/192.168.1.1:54/${NET_ADDR}:54/g" /etc/adguardhome.yaml
echo -e " \033[1;32mInstallation and configuration complete\033[0;39m"
echo -e " \033[1;32mhttp://${NET_ADDR}:${input_str_PORT}\033[0;39m"
read -p " Press any key (to reboot the device)"
reboot
}

function _func_AdGuard_Before {
while :
do
  echo -e " \033[1;37mRemove and restore AdGuard HOME to its previous settings\033[0;39m"
  echo -e " \033[1;37mRemove: adguardhome\033[0;39m"
  echo -e " \033[1;37mRemove: htpasswd\033[0;39m"
  echo -e " \033[1;37mRemove: libaprutil\033[0;39m"
  echo -e " \033[1;37mRemove: libapr\033[0;39m"
  echo -e " \033[1;37mRemove: libexpat\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_Restoration ;;
    "n" ) _func_AdGuard ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_Restoration {
service adguardhome stop
service adguardhome disable
opkg remove adguardhome
rm /usr/bin/htpasswd
opkg remove --nodeps libaprutil
opkg remove --nodeps libapr
opkg remove --nodeps libexpat
cp /etc/config/network.adguard.bak /etc/config/network
rm /etc/config/network.adguard.bak
cp /etc/config/dhcp.adguard.bak /etc/config/dhcp
rm /etc/config/dhcp.adguard.bak
cp /etc/config/firewall.adguard.bak /etc/config/firewall
rm /etc/config/firewall.adguard.bak
rm /etc/config-software/adguard-config.sh
rm /etc/config-software/adguard.sh
echo -e " \033[1;32mRemove and restore to previous settings completed\033[0;39m"
read -p " Press any key (to reboot the device)"
reboot
exit
}


if [ "adblock" = "`opkg list-installed adblock | awk '{ print $1 }'`" ]; then
 read -p " AdBlock already installed"
 exit
fi
if [ "adblock-fast" = "`opkg list-installed adblock-fast | awk '{ print $1 }'`" ]; then
 read -p " AdBlock-fast already installed"
 exit
fi
if [ "https-dns-proxy" = "`opkg list-installed https-dns-proxy | awk '{ print $1 }'`" ]; then
 read -p " https-dns-proxy already installed"
 exit
fi
if [ "stubby" = "`opkg list-installed stubby | awk '{ print $1 }'`" ]; then
 read -p " DNS over TLS (DoT) already installed"
 exit
fi
OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
 else
   read -p " Exit due to different versions"
 exit
fi
if [ -e ${UPDATE} ]; then
opkg update
UPDATE="1"
fi
AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
ADGUARD_VERSION=`opkg info adguardhome | grep Version | awk '{ print $2 }'`
ADGUARD_SIZE=$((`opkg info adguardhome | grep Size | awk '{ print $2 }'`/1024))
echo -e " \033[1;37mAvailable Memory Space: ${AVAILABLE_MEMORY}KB\033[0;39m"
if [ -z "${AVAILABLE_FLASH}" ]; then
 echo -e " \033[1;37mAvailable Flash Space: No overlay\033[0;39m"
AVAILABLE_FLASH=${AVAILABLE_MEMORY}
else
 echo -e " \033[1;37mAvailable Flash Space: ${AVAILABLE_FLASH}KB\033[0;39m"
fi
echo -e " \033[1;37mInstalled Capacity: ${ADGUARD_SIZE}KB\033[0;39m"
if [ "${AVAILABLE_FLASH}" -gt ${ADGUARD_SIZE} ]; then
 echo -e " \033[1;37mRecommended Memory Capacity: 51200KB\033[0;39m"
 echo -e " \033[1;37mRecommended Flash Capacity: 102400KB\033[0;39m"
 echo -e " \033[1;37minstallable\033[0;39m"
 _func_AdGuard
else
 read -p " Exit due to insufficient flash space"
exit
fi

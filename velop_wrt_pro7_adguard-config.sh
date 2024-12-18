#! /bin/sh
. /lib/functions/network.sh
NET_IF="lan"
network_flush_cache
network_get_ipaddr NET_ADDR "${NET_IF}"

function _func_AdGuard_Confirm {
AD_INST="ad_inst"
mkdir -p /tmp/config-software
wget --no-check-certificate -O /tmp/config-software/AdGuardHome_list https://github.com/AdguardTeam/AdGuardHome
AdGuardHome_list=`cat /tmp/config-software/AdGuardHome_list`
latest_ver=`echo $AdGuardHome_list | awk '{print substr($0,index($0,"AdGuard Home v") ,30)}' | awk '{ sub("</span>.*$",""); print $0; }' | grep -o -E "(v[0-9]+\.){1}[0-9]+(\.[0-9]+)?" | head -n1`
while :
do
  echo -e " \033[1;35mStart AdGuardHome setup and installation\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface port number entry\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface user name entry\033[0;39m"
  echo -e " \033[1;32mAdministrative web interface password entry\033[0;39m"
  echo -e " \033[1;32mInstall: AdGuardHome Version ${latest_ver}\033[0;39m"
  echo -e " \033[1;32mInstall: ca-bundle $((`opkg info ca-bundle | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
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
  echo -e " \033[1;35mStart AdGuardHomeE setup and installation\033[0;39m"
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
    "r" ) break ;;    
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
    "r" ) break ;;
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
    "r" ) break ;;
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
    "r" ) break ;;
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
    "r" ) break ;;
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
wget --no-check-certificate -O /usr/bin/htpasswd https://github.com/site-u2023/config-software/raw/main/htpasswd-arm
chmod +x /usr/bin/htpasswd
opkg install --nodeps libaprutil
opkg install --nodeps libapr
opkg install --nodeps libexpat
opkg install --nodeps libuuid1
if [ -n "${AD_INST}" ]; then
opkg install ca-bundle
wget --no-check-certificate -O /etc/config-software/adguard.sh https://raw.githubusercontent.com/site-u2023/config-software/main/velop_wrt_pro7_adguard.sh
sh /etc/config-software/adguard.sh
fi
/etc/init.d/AdGuardHome 2>&1 | grep -q '/etc/init.d/AdGuardHome: not found'
if  [ $? == 1 ]; then
/etc/init.d/AdGuardHome stop
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
  echo -e " \033[1;37mRemove and restore AdGuardHome to its previous settings\033[0;39m"
  echo -e " \033[1;37mRemove: adguardhome\033[0;39m"
  echo -e " \033[1;37mRemove: ca-bundle\033[0;39m"
  echo -e " \033[1;37mRemove: htpasswd\033[0;39m"
  echo -e " \033[1;37mRemove: libaprutil\033[0;39m"
  echo -e " \033[1;37mRemove: libapr\033[0;39m"
  echo -e " \033[1;37mRemove: libexpat\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_Restoration ;;
    "n" ) break ;;
    "r" ) exit ;;
  esac
done
}

function _func_AdGuard_Restoration {
/etc/init.d/AdGuardHome stop
/etc/init.d/AdGuardHome disable
/etc/AdGuardHome/AdGuardHome -s uninstall
uci -q delete dhcp.@dnsmasq[0].noresolv
uci -q delete dhcp.@dnsmasq[0].cachesize
uci set dhcp.@dnsmasq[0].rebind_protection='1'
uci -q delete dhcp.@dnsmasq[0].server
uci -q delete dhcp.@dnsmasq[0].port
uci -q delete dhcp.lan.dhcp_option
uci -q delete dhcp.lan.dns
uci add_list dhcp.lan.dhcp_option="6,1.1.1.1,1.0.0.1"
uci add_list dhcp.lan.dhcp_option="6,8.8.8.8,8.8.4.4"
uci add_list dhcp.lan.dns="2606:4700:4700::1111"
uci add_list dhcp.lan.dns="2606:4700:4700::1001"
uci add_list dhcp.lan.dns="2001:4860:4860::8888"
uci add_list dhcp.lan.dns="2001:4860:4860::8844"
uci set network.wan.peerdns="0"
uci set network.wan6.peerdns="0"
uci -q delete network.wan.dns
uci -q delete network.wan6.dns
uci -q delete firewall.adguardhome_dns_53
uci commit
reboot
exit
}

if [ "adblock" = "`opkg list-installed adblock | awk '{ print $1 }'`" ]; then
  read -p " AdBlock already installed"
  exit
elif [ "https-dns-proxy" = "`opkg list-installed https-dns-proxy | awk '{ print $1 }'`" ]; then
  read -p " https-dns-proxy already installed"
  exit
elif [ "stubby" = "`opkg list-installed stubby | awk '{ print $1 }'`" ]; then
  read -p " DNS over TLS (DoT) already installed"
  exit
fi

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "19" ]]; then
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
while :
do
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[c]: AdGuardHome configuration and installation\033[0;39m"
  echo -e " \033[1;33m[s]: Web interface configuration (port, username and password only)\033[0;39m"
  echo -e " \033[1;32m[b]: Removing and restoring AdGuardHome to previous settings\033[0;39m"
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

#! /bin/sh



function _func_HTTPS {
while :
do
  echo -e " \033[1;35mStart installation and configuration of DNS over HTTPS (DoH)\033[0;39m"
  echo -e " \033[1;37mInstall: https-dns-proxy\033[0;39m"
  echo -e " \033[1;37mInstall: luci-app-https-dns-proxy\033[0;39m"
  echo -e " \033[1;37mInstall: luci-i18n-https-dns-proxy-ja\033[0;39m" 
  read -p " All right? [y/n]: " num
  case "${num}" in
    "y" ) _func_HTTPS_SET ;;
    "n" ) exit ;;
  esac
done
}

function _func_HTTPS_SET {
UPDATE="/tmp/opkg-lists/openwrt_telephony"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
opkg install https-dns-proxy
opkg install luci-app-https-dns-proxy
#opkg install luci-i18n-https-dns-proxy-$input_str_Languages

while uci -q delete https-dns-proxy.@https-dns-proxy[0]; do :; done
uci set https-dns-proxy.dns="https-dns-proxy"
uci set https-dns-proxy.dns.bootstrap_dns="1.1.1.1,1.0.0.1"
uci set https-dns-proxy.dns.resolver_url="https://cloudflare-dns.com/dns-query"
uci set https-dns-proxy.dns.listen_addr="127.0.0.1"
uci set https-dns-proxy.dns.listen_port="5053"

uci commit https-dns-proxy
/etc/init.d/rpcd restart
/etc/init.d/https-dns-proxy restart
echo -e " \033[1;37mInstallation and configuration complete\033[0;39m"
read -p " Press any key"
exit
}

function _func_HTTPS_Before {
while :
do
  echo -e " \033[1;37mDNS over HTTPS（DoH）settings to previous settings\033[0;39m"
  echo -e " \033[1;37mRemove: luci-app-https-dns-proxy\033[0;39m"
  echo -e " \033[1;37mRemove: https-dns-proxy\033[0;39m"
  read -p " Press any key [y/n or r]: " num

  case "${num}" in
    "y" ) _func_HTTPS_Restoration ;;
    "n" ) _func_HTTPS ;;
    "r" ) _func_HTTPS ;;
  esac
done
}

function _func_HTTPS_Restoration {
opkg remove luci-app-https-dns-proxy
opkg remove https-dns-proxy
read -p " Press any key (to reboot the device)"
reboot
exit
}

if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
 read -p " AdGuard already installed"
 exit
fi
if [ "stubby" = "`opkg list-installed stubby | awk '{ print $1 }'`" ]; then
 read -p " DNS over TLS (DoT) already installed"
 exit
fi

OPENWRT_RELEAS=`cat /etc/banner | grep OpenWrt | awk '{ print $2 }' | cut -c 1-2`
if [ "${OPENWRT_RELEAS}" = "23" ] || [ "${OPENWRT_RELEAS}" = "22" ] || [ "${OPENWRT_RELEAS}" = "21" ] || [ "${OPENWRT_RELEAS}" = "SN" ]; then
 echo -e " \033[1;37mVersion chec: OK\033[0;39m"
 else
 read -p " Different version"
 exit
fi

while :
do
  echo -e " \033[1;3mSTUBBY ------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: DNS over HTTPS（DoH）configuration\033[0;39m"
  echo -e " \033[1;31m[b]: DNS over HTTPS（DoH）settings to previous settings\033[0;39m"
  echo -e " \033[1;33m[r]: Quit\033[0;39m"    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " Press any key [e/b or r]: " num
  case "${num}" in
    "e" ) _func_HTTPS ;;
    "b" ) _func_HTTPS_Before ;;
    "r" ) exit ;;
  esac
done

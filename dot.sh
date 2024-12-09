#! /bin/sh

function _func_STUBBY {
while :
do
  echo -e " \033[1;35mStart DNS over TLS (DoT) installation\033[0;39m"
  echo -e " \033[1;37mInstall: stubby\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) _func_STUBBY_SET ;;
    "n" ) exit ;;
  esac
done
}

function _func_STUBBY_SET {
cp /etc/config/dhcp /etc/config/dhcp.dot.bak
cp /etc/config/network /etc/config/network.dot.bak
if [ -e ${UPDATE} ]; then
opkg update
UPDATE="1"
fi
opkg install stubby
/etc/init.d/dnsmasq stop
uci set dhcp.@dnsmasq[0].noresolv="1"
uci set dhcp.@dnsmasq[0].localuse="1"
uci -q delete dhcp.@dnsmasq[0].server
uci -q get stubby.global.listen_address \
| sed -e "s/\s/\n/g;s/@/#/g" \
| while read -r STUBBY_SERV
do uci add_list dhcp.@dnsmasq[0].server="${STUBBY_SERV}"
done
uci set network.wan.peerdns='0'
uci set network.wan.dns='127.0.0.1'
uci set network.wan6.peerdns='0'
uci set network.wan6.dns='0::1'
uci commit
/etc/init.d/dnsmasq start
/etc/init.d/network reload
# Boot failure countermeasures
sed -i "/exit 0/d" /etc/rc.local
echo "/etc/init.d/stubby restart" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local
echo -e " \033[1;37mInstallation and configuration completed\033[0;39m"
read -p " Press any key (to reboot the device)"
reboot
exit
}

function _func_STUBBY_Before {
while :
do
  echo -e " \033[1;37mRestore DNS over TLS (DoT) settings to previous settings\033[0;39m"
  echo -e " \033[1;37mRemove: stubby\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_STUBBY_Restoration ;;
    "n" ) _func_STUBBY ;;
    "r" ) _func_STUBBY ;;
  esac
done
}

function _func_STUBBY_Restoration {
opkg remove stubby
cp /etc/config/dhcp.dot.bak /etc/config/dhcp
cp /etc/config/network.dot.bak /etc/config/network
rm etc/config/dhcp.dot.bak
rm /etc/config/network.dot.bak
sed -i -e "s|/etc/init.d/stubby restart||g" /etc/rc.local
rm /etc/config-software/dot.sh
read -p " Press any key (to reboot the device)"
reboot
exit
}

if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
 read -p " AdGuard already installed"
 exit
fi
if [ "https-dns-proxy" = "`opkg list-installed https-dns-proxy | awk '{ print $1 }'`" ]; then
 read -p " https-dns-proxy already installed"
 exit
fi

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "24" || "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "19" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
 else
   read -p " Exit due to different versions"
 exit
fi

while :
do
  echo -e " \033[1;3mDoT ---------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: DNS over TLS (DoT) configuration\033[0;39m"
  echo -e " \033[1;31m[b]: DNS over TLS (DoT) settings to previous settings\033[0;39m"
  echo -e " \033[1;33m[q]: Quit\033[0;39m"    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " Please select key [e/b or q]: " num
  case "${num}" in
    "e" ) _func_STUBBY ;;
    "b" ) _func_STUBBY_Before ;;
    "q" ) exit ;;
  esac
done

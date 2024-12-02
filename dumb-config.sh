#! /bin/sh

function _func_Dumb_IPV4
while :
do
  echo -e "\033[1;37m Enter IPV4 address of access point\033[0;39m"
  echo -e "\033[1;33m Example: 192.168.1.2\033[0;39m"
  read -p " IPV4 address: " input_str_IPV4
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_GATEWAY ;;
    "n" ) _func_Dumb_IPV4 ;;
    "r" ) break ;;
  esac
done

function _func_Dumb_GATEWAY
while :
do
  echo -e "\033[1;37m Enter gateway of access point\033[0;39m"
  echo -e "\033[1;33m Example: 192.168.1.1\033[0;39m"
  read -p " gateway: " input_str_GATEWAY
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_confirmation ;;
    "n" ) _func_Dumb_GATEWAY ;;
    "r" ) break ;;
  esac
done

function _func_Dumb_confirmation
while :
do
  echo -e " \033[1;37mAccess point ----------------------------------------\033[0;39m"
  echo -e " \033[1;32mIPV4 address: ${input_str_IPV4}\033[0;39m"
  echo -e " \033[1;32mGateway: ${input_str_GATEWAY}\033[0;39m"
  echo -e " \033[1;37mPackage: fping Size: Install 17kB\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_SET ;;
    "n" ) _func_Dumb_IPV4 ;;
    "r" ) break ;;
  esac
done

function _func_Dumb_SET
{
wget --no-check-certificate -O /etc/config-software/dumb.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dumb.sh
sed -i -e "s/IPADDR='192.168.1.2'/IPADDR='${input_str_IPV4}'/g" /etc/config-software/dumb.sh
sed -i -e "s/GATEWAY='192.168.1.1'/GATEWAY='${input_str_GATEWAY}'/g" /etc/config-software/dumb.sh
sh /etc/config-software/dumb.sh 2> /dev/null
read -p " Press any key (to reboot the device)"
reboot
}

function _func_Dumb_Before
while :
do
  echo -e " \033[1;37mRestore access point settings to previous settings\033[0;39m"
  read -p " Press any key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_Before_Restoration ;;
    "n" ) _func_Dumb ;;
    "r" ) break ;;
  esac
done

function _func_Dumb_Before_Restoration
{
cp /etc/config/system.dump.bak /etc/config/system
rm /etc/config/system.dump.bak
cp /etc/config/network.dump.bak /etc/config/network
rm /etc/config/network.dump.bak
cp /etc/config/dhcp.dump.bak /etc/config/dhcp
rm /etc/config/dhcp.dump.bak
cp /etc/config/firewall.dump.bak /etc/config/firewall
rm /etc/config/firewall.dump.bak
cp /etc/config/wireless.dump.bak /etc/config/wireless
rm /etc/config/wireless.dump.bak
cp /etc/config/dropbear.dump.bak /etc/config/dropbear
rm /etc/config/dropbear.dump.bak
/etc/init.d/odhcpd enable
/etc/init.d/odhcpd start
/etc/init.d/dnsmasq enable
/etc/init.d/dnsmasq start
/etc/init.d/firewall enable
/etc/init.d/firewall start
rm /etc/config-software/dumb.sh
echo -e " \033[1;32mAfter reboot, login with ${input_str_IPV4}\033[0;39m"
read -p " Press any key (to reboot the device)"
reboot
exit
}

OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
if [[ "${OPENWRT_RELEAS}" = "23" || "${OPENWRT_RELEAS}" = "22" || "${OPENWRT_RELEAS}" = "21" || "${OPENWRT_RELEAS}" = "19" ]]; then
   echo -e " The version of this device is \033[1;33m$OPENWRT_RELEAS\033[0;39m"
   echo -e " Version Check: \033[1;36mOK\033[0;39m"
 else
   read -p " Exit due to different versions"
 exit
fi

while :
do
  echo -e " \033[1;33mPrepare IPV4 address and gateway of access point\033[0;39m"
  echo -e " \033[1;31mAccess point -------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: Access point settings\033[0;39m"
  echo -e " \033[1;32m[b]: Restore previous settings\033[0;39m"
  echo -e " \033[1;31m[q]: Quit\033[0;39m"    
  echo -e " \033[1;31m--------------------------------------------------------------\033[0;39m"
  read -p " Please select key [e/b or q]: " num
  case "${num}" in
    "e" ) _func_Dumb_IPV4 ;;
    "b" ) _func_Dumb_Before ;;
    "q" ) exit ;;
  esac
done

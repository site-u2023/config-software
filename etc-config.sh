#! /bin/sh

function _func_BUTTON {
while :
do
  echo -e " \033[1;34mDownload button configuration and installation scripts\033[0;39m"
  read -p " Press any key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/button-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/button-config.sh
          sh /etc/config-software/button-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_IPERF3 {
while :
do
  echo -e " \033[1;33mDownload and install the IPERF3 configuration script\033[0;39m"
  read -p " Press any key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/init.d/iperf3 https://raw.githubusercontent.com/site-u2023/iperf/main/iperf3
          chmod +x /etc/init.d/iperf3
          UPDATE="/tmp/opkg-lists/openwrt_telephony"
          if [ ! -e ${UPDATE} ]; then
          opkg update
          fi
          opkg install iperf3
          NET_IF="lan"
          . /lib/functions/network.sh
          network_flush_cache
          network_get_ipaddr NET_ADDR "${NET_IF}"
          sed -i -e "s/192.168.1.1/${NET_ADDR}/g" /etc/init.d/iperf3
          echo -e " \033[1;32mInstallation is complete\033[0;39m"
          echo -e " \033[1;36menable: service iperf3 enable\033[0;39m"
          echo -e " \033[1;36mdisable: service iperf3 disable\033[0;39m"
          echo -e " \033[1;36mStart: service iperf3 start\033[0;39m"
          echo -e " \033[1;36mStop: service iperf3 stop\033[0;39m"
          read -p " Start service [y/n]: " snum
            case "${snum}" in
                "y" ) echo -e " \033[1;36mStart IPERF3\033[0;39m"
                      service iperf3 start ;;
                "n" ) break ;;
            esac 
          read -p " Press any key"
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_WiFi_location_service {
while :
do
  echo -e " \033[1;32mExecute Location Based Service (LBS) stop setting\033[0;39m"
  echo -e " \033[1;36m`uci show wireless.default_radio0.ssid`\033[0;39m"
  echo -e " \033[1;36m`uci show wireless.default_radio1.ssid`\033[0;39m"
  echo -e " \033[1;36m`uci show wireless.default_radio2.ssid`\033[0;39m"
  echo -e " \033[1;32mAdd _optout_nomap to the SSID name\033[0;39m"
  read -p " Press any key [y/n]: " num
  case "${num}" in
    "y" ) sed -i -e 's/\s*$//' /etc/config/wireless
          sed -i -e "/option ssid/s/'$//" /etc/config/wireless
          sed -i -e "/option ssid/s/$/_optout_nomap'/g" /etc/config/wireless
          /etc/init.d/network restart   
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_SAMBA4 {
while :
do
  echo -e " \033[1;32mPerform SAMBA4 and WSDD2 installation\033[0;39m"
  read -p " Press any key [y/n]: " num
  case "${num}" in
    "y" ) UPDATE="/tmp/opkg-lists/openwrt_telephony"
          if [ ! -e ${UPDATE} ]; then
          opkg update
          fi
          opkg install luci-app-samba4 wsdd2
          /etc/init.d/samba4 enable
          /etc/init.d/samba4 start  
          read -p " Press any key"
          break ;;
    "n" ) break ;;
  esac
done  
}

while :
do
  echo -e " \033[1;37metc -------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[1]:Button Setup and Installation\033[0;39m"
  echo -e " \033[1;33m[2]:IPERF3 installation and service addition\033[0;39m"
  echo -e " \033[1;32m[3]:Location Based Service (LBS) Stop\033[0;39m"
  echo -e " \033[1;35m[4]:SAMBA4 and WSDD2 installation\033[0;39m"
  echo -e " \033[1;31m[5]\033[0;39m"
  echo -e " \033[1;36m[6]\033[0;39m" 
  echo -e " \033[7;40m[q]:Quit\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Press any key [1/2/3/4 or q]: " num
  case "${num}" in
    "1" ) _func_BUTTON ;;
    "2" ) _func_IPERF3 ;;
    "3" ) _func_WiFi_location_service ;;
    "4" ) _func_SAMBA4 ;;
    "5" ) ;;
    "6" ) ;;
    "q" ) exit ;;
  esac
 done

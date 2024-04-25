#! /bin/sh

function _func_BUTTON {
while :
do
  echo -e " \033[1;34mDownload button configuration and installation scripts\033[0;39m"
  read -p " Please select key [y/n]: " num
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
  echo -e " \033[1;33mDownload and install IPERF3 configuration script\033[0;39m"
  echo -e " \033[1;33mDUMP not supported\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/init.d/iperf3 https://raw.githubusercontent.com/site-u2023/iperf/main/iperf3
          chmod +x /etc/init.d/iperf3
          opkg update
          opkg install iperf3
          NET_IF="lan"
          . /lib/functions/network.sh
          network_flush_cache
          network_get_ipaddr NET_ADDR "${NET_IF}"
          sed -i -e "s/192.168.1.1/${NET_ADDR}/g" /etc/init.d/iperf3
          echo -e " \033[1;32mInstallation is complete\033[0;39m"
          echo -e " \033[1;36mEnable: service iperf3 enable\033[0;39m"
          echo -e " \033[1;36mDisable: service iperf3 disable\033[0;39m"
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
  echo -e " \033[1;32mAdd _optout_nomap to the SSID name\033[0;39m"
  read -p " Please select key [y/n]: " num
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
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) opkg update
          opkg install luci-app-samba4 wsdd2
          /etc/init.d/samba4 enable
          /etc/init.d/samba4 start  
          read -p " Press any key"
          break ;;
    "n" ) break ;;
  esac
done  
}

function _func_DFS {
while :
do
  echo -e " \033[1;33mDownload and install ZZDFS configuration script\033[0;39m"
  echo -e " \033[1;34m[b]: ZZDFS\033[0;39m"
  read -p " Please select key [d or n]: " num
  case "${num}" in
    "d" ) wget --no-check-certificate -O /etc/config-software/zzdfs-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/zzdfs-config.sh
          sh /etc/config-software/zzdfs-config.sh 2> /dev/null
          service dfs_check enable
          service dfs_check start
          echo "Check your Wi-Fi settings"
          echo "How to check logs: dfslog"
          read -p " Press any key"
          break ;;
    "n" ) break ;;
  esac
done

}

function _func_GUEST {
while :
do
  echo -e " \033[1;32mGuest Wi-Fi installation\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) opkg update
          opkg install bash
          opkg install openssl-util
          opkg install qrencode
          opkg install at
          wget --no-check-certificate -O /etc/config-software/guest.sh https://raw.githubusercontent.com/site-u2023/config-software/main/guest.sh
          bash /etc/config-software/guest.sh 2> /dev/null
          service wifi_guest start
          HOSTMANE=`uci get system.@system[0].hostname`
          echo -e " \033[1;32mGuest Wi-Fi: http://${HOSTMANE}/guest.html\033[0;39m"
          echo -e " \033[1;32mQR code: http://${HOSTMANE}/qr.svg\033[0;39m"
          read -p " Press any key"
          break ;;
    "n" ) break ;;
  esac
done  
}

while :
do
  echo -e " \033[1;37mETC -------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[1]:Button Setup and Installation\033[0;39m"
  echo -e " \033[1;33m[2]:IPERF3 installation and service addition\033[0;39m"
  echo -e " \033[1;32m[3]:Location Based Service (LBS) Stop\033[0;39m"
  echo -e " \033[1;35m[4]:SAMBA4 and WSDD2 installation\033[0;39m"
  echo -e " \033[1;31m[5]:ZZDFS\033[0;39m"
  echo -e " \033[1;36m[6]:Guest Wi-Fi\033[0;39m" 
  echo -e " \033[7;40m[q]:Quit\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [1/2/3/4/5 or q]: " num
  case "${num}" in
    "1" ) _func_BUTTON ;;
    "2" ) _func_IPERF3 ;;
    "3" ) _func_WiFi_location_service ;;
    "4" ) _func_SAMBA4 ;;
    "5" ) _func_DFS ;;
    "6" ) _func_GUEST ;;
    "q" ) exit ;;
  esac
 done

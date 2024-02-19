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
  read -p " Please select key [y/n]: " num
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

function _func_DFS {
while :
do
  echo -e " \033[1;33mDownload and install DFS_Check configuration script\033[0;39m"
  read -p " Please select key [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/dfs_check.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dfs_check.sh
          wget --no-check-certificate -O /etc/init.d/dfs_check https://raw.githubusercontent.com/site-u2023/config-software/main/dfs_check
          chmod +x /etc/dfs_check.sh
          chmod +x /etc/init.d/dfs_check
          DEV=`iw dev | awk '/Interface/{print $2}' | awk '{print substr($0,1,index($0,"-") )}' | grep 2`
          CHECK=$(iw dev ${DEV}ap0 info | awk '/channel/{print $2}')
          echo $CHECK
          if [ ${CHECK} -ge "100" ]; then
          sed -i -e "s/radio0/radio2/g" /etc/dfs_check.sh
          sed -i -e "s/phy0-/${DEV}/g" /etc/dfs_check.sh
          echo "*/15 * * * * sh /etc/dfs_check.sh" >> /etc/crontabs/root
          echo "DFS Check setup is complete"
          read -p " Press any key"
          exit
          fi
          DEV=`iw dev | awk '/Interface/{print $2}' | awk '{print substr($0,1,index($0,"-") )}' | grep 1`
          CHECK=$(iw dev ${DEV}ap0 info | awk '/channel/{print $2}')
          echo $CHECK
          if [ ${CHECK} -ge "100" ]; then
          sed -i -e "s/radio0/radio1/g" /etc/dfs_check.sh
          sed -i -e "s/phy0-/${DEV}/g" /etc/dfs_check.sh
          echo "*/15 * * * * sh /etc/dfs_check.sh" >> /etc/crontabs/root
          echo "DFS Check setup is complete"
          read -p " Press any key"
          exit
          fi
          DEV=`iw dev | awk '/Interface/{print $2}' | awk '{print substr($0,1,index($0,"-") )}' | grep 0`
          CHECK=$(iw dev ${DEV}ap0 info | awk '/channel/{print $2}')
          echo $CHECK
          if [ ${CHECK} -ge "100" ]; then
          sed -i -e "s/radio0/radio0/g" /etc/dfs_check.sh
          sed -i -e "s/phy0-/${DEV}/g" /etc/dfs_check.sh
          echo "*/15 * * * * sh /etc/dfs_check.sh" >> /etc/crontabs/root
          echo "DFS Check setup is complete"
          read -p " Press any key"
          exit
          fi
          service dfs_check disable
          service dfs_check stop
          echo "Check your Wi-Fi settings"
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
  echo -e " \033[1;31m[5]:DFS Check\033[0;39m"
  echo -e " \033[1;36m[6]\033[0;39m" 
  echo -e " \033[7;40m[q]:Quit\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [1/2/3/4/5 or q]: " num
  case "${num}" in
    "1" ) _func_BUTTON ;;
    "2" ) _func_IPERF3 ;;
    "3" ) _func_WiFi_location_service ;;
    "4" ) _func_SAMBA4 ;;
    "5" ) _func_DFS ;;
    "6" ) ;;
    "q" ) exit ;;
  esac
 done

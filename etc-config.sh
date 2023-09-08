#! /bin/sh

function _func__func_BUTTON {
while :
do
  echo -e " \033[1;34mボタン設定とインストールのスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/init.d/iperf3 https://raw.githubusercontent.com/site-u2023/config-software/main/button-config.sh
          sh button-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_IPERF3 [
while :
do
  echo -e " \033[1;34mIPERF3設定のスクリプトをダウンロードしてインストールします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/init.d/iperf3 https://raw.githubusercontent.com/site-u2023/iperf/main/iperf3
          chmod +x /etc/init.d/iperf3
          UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
          if [ ! -e ${UPDATE} ]; then
          opkg update
          fi
          opkg install iperf3
          NET_IF="lan"
          . /lib/functions/network.sh
          network_flush_cache
          network_get_ipaddr NET_ADDR "${NET_IF}"
          sed -i -e "s/192.168.1.1/${NET_ADDR}/g" /etc/init.d/iperf3
          echo -e " \033[1;32mインストールが完了しました\033[0;39m"
          echo -e " \033[1;36m有効: service iperf3 enable\033[0;39m"
          echo -e " \033[1;36m無効: service iperf3 disable\033[0;39m"
          echo -e " \033[1;36m開始: service iperf3 start\033[0;39m"
          echo -e " \033[1;36m終了: service iperf3 stop\033[0;39m"
          read -p " サービスを開始しますか? [y/n]: " snum
            case "${snum}" in
                "y" ) echo -e " \033[1;36mIPERF3を開始します\033[0;39m"
                      service iperf3 start ;;
                "n" ) break ;;
            esac 
          read -p " 何かキーを押して下さい"
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_WiFi_location_service {
while :
do
  echo -e " \033[1;33mWiFi位置情報サービス停止設定を実行します\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) sed -i -e 's/\s*$//' /etc/config/wireless
          sed -i -e "/option ssid/s/'$//" /etc/config/wireless
          sed -i -e "/option ssid/s/$/_optout_nomap'/g" /etc/config/wireless
          /etc/init.d/network restart
          echo -e " \033[1;36m`uci show wireless.default_radio0.ssid`\033[0;39m"
          echo -e " \033[1;36m`uci show wireless.default_radio1.ssid`\033[0;39m"
          echo -e " \033[1;36m`uci show wireless.default_radio2.ssid`\033[0;39m"
          echo -e " \033[1;32m設定が完了しました\033[0;39m"
          echo -e " \033[1;33mクライアントのSSID末尾に _optout_nomap を追加して下さい\033[0;39m"
          read -p " 何かキーを押して下さい"
          break ;;
    "n" ) break ;;
  esac
done
}

while :
do
  echo -e " \033[1;37metc -------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[1]\033[0;39m": ボタン設定とインストール
  echo -e " \033[1;33m[2]\033[0;39m": IPERF3インストール及びサービス追加
  echo -e " \033[1;32m[3]\033[0;39m": WiFi位置情報サービス停止設定
  echo -e " \033[1;35m[4]\033[0;39m": 
  echo -e " \033[1;31m[5]\033[0;39m": 
  echo -e " \033[1;36m[6]\033[0;39m": 
  echo -e " \033[7;40m[q]\033[0;39m": 終了
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [1/2/3/4/5/6 or q]: " num
  case "${num}" in
    "1" ) _func_BUTTON ;;
    "2" ) _func_IPERF3 ;;
    "3" ) _func_WiFi_location_service ;;
    "4" ) exit ;;
    "5" ) exit ;;
    "6" ) exit ;;
    "q" ) exit ;;
  esac
 done

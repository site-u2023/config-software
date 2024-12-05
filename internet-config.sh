#! /bin/sh
# License: CC0

function _func_MAP_e_VirtualConnect {
while :
do
  echo -e " \033[1;33m要ONU直結\033[0;39m"
  echo -e " \033[1;33mHGW非対応\033[0;39m"
  echo -e " \033[1;34mOCNバーチャルコネクト --------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: OCNバーチャルコネクトのインストールと設定 (マルチセッション対応)\033[0;39m"
  echo -e " \033[1;31m[b]: OCNバーチャルコネクトのリムーブと以前の設定に復元\033[0;39m"
  echo -e " \033[1;32m[n]: マルチセッション対応設定のみ実行\033[0;39m"
  echo -e " \033[1;35m[o]: マルチセッション対応設定を以前の設定に復元\033[0;39m"
  echo -e " \033[1;33m[r]: 戻る\033[0;39m"
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " 選択してください [e/b/n/o or r]: " num
  case "${num}" in
    "e" ) _func_MAP_e_VirtualConnect_confirmation ;;
    "b" ) _func_MAP_e_VirtualConnect_Before ;;
    "n" ) _func_MAP_e_Nichiban_map ;;
    "o" ) _func_MAP_e_Nichiban_map_Before ;;
    "r" ) break ;;
  esac
done
}

function _func_MAP_e_VirtualConnect_confirmation {
while :
do
  echo -e " \033[1;37mOCNバーチャルコネクトの設定とインストールとを実行します\033[0;39m"
  echo -e " \033[1;37mインストール: map 6kB\033[0;39m"
  echo -e " \033[1;37mインストール: bash 375kB\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MAP_e_VirtualConnect_SET ;;
    "n" ) _func_MAP_e_VirtualConnect ;;
    "r" ) break ;;
  esac
done
}

function _func_MAP_e_VirtualConnect_SET {
opkg update
opkg install bash
opkg install map
cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.old
wget -6 --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map.sh.new
wget -6 --no-check-certificate -O /etc/config-software/map-e.sh https://raw.githubusercontent.com/site-u2023/config-software/main/map-e.sh
sed -i "/Onry_V6plus/d"  /etc/config-software/map-e.sh
bash /etc/config-software/map-e.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_MAP_e_VirtualConnect_Before {
while :
do
  echo -e " \033[1;37mOCNバーチャルコネクトの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mパッケージ: mapはリムーブしません\033[0;39m"
  echo -e " \033[1;37mパッケージ: bashはリムーブしません\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MAP_e_Restoration ;;
    "n" ) _func_MAP_e_VirtualConnect ;;
    "r" ) break ;;
  esac
done
}

function _func_MAP_e_V6plus {
while :
do
  echo -e " \033[1;33m要ONU直結\033[0;39m"
  echo -e " \033[1;33mHGW非対応\033[0;39m"
  echo -e " \033[1;33mV6プラス・IPv6オプション -----------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: V6プラス・IPv6オプションの設定を実行 (マルチセッション対応)\033[0;39m"
  echo -e " \033[1;31m[b]: 以前の設定に復元\033[0;39m"
  echo -e " \033[1;32m[n]: マルチセッション対応設定のみ実行\033[0;39m"
  echo -e " \033[1;35m[o]: マルチセッション対応設定を以前の設定に復元\033[0;39m"
  echo -e " \033[1;33m[r]: 戻る\033[0;39m"
  echo -e " \033[1;33m------------------------------------------------------\033[0;39m"
  read -p " 選択してください [e/b/n/o or r]: " num
  case "${num}" in
    "e" ) _func_MAP_e_V6plus_confirmation ;;
    "b" ) _func_MAP_e_V6plus_Before ;;
    "n" ) _func_MAP_e_Nichiban_map ;;
    "o" ) _func_MAP_e_Nichiban_map_Before ;;
    "r" ) break ;;
  esac
done
}

function _func_MAP_e_V6plus_confirmation {
while :
do
  echo -e " \033[1;37mV6プラス・IPv6オプションの設定を実行します\033[0;39m"
  echo -e " \033[1;37mパッケージ: map サイズ: 6kBをインストールします\033[0;39m"
  echo -e " \033[1;37mパッケージ: bash サイズ: 375kBをインストールします\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MAP_e_V6plus_SET ;;
    "n" ) _func_MAP_e_V6plus ;;
    "r" ) break ;;
  esac
done
}

function _func_MAP_e_V6plus_SET {
opkg update
opkg install bash
opkg install map
cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.old
wget -6 --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map.sh.new
wget -6 --no-check-certificate -O /etc/config-software/map-e.sh https://raw.githubusercontent.com/site-u2023/config-software/main/map-e.sh
sed -i "/Onry_OCN/d"  /etc/config-software/map-e.sh
bash /etc/config-software/map-e.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_MAP_e_V6plus_Before {
while :
do
  echo -e " \033[1;37mV6プラス・IPv6オプションの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mパッケージ: mapはリムーブしません\033[0;39m"
  echo -e " \033[1;37mパッケージ: bashはリムーブしません\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MAP_e_Restoration ;;
    "n" ) _func_MAP_e_V6plus ;;
    "r" ) break ;;
  esac
done
}
function _func_MAP_e_Restoration {
cp /etc/config/network.map-e.old /etc/config/network
cp /etc/config/dhcp.map-e.old /etc/config/dhcp
cp /etc/config/firewall.map-e.old /etc/config/firewall
rm /etc/config/network.map-e.old
rm /etc/config/dhcp.map-e.old
rm /etc/config/firewall.map-e.old
cp /lib/netifd/proto/map.sh.old /lib/netifd/proto/map.sh
rm /lib/netifd/proto/map.sh.old
rm /etc/config-software/map-e.sh
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_MAP_e_Nichiban_map {
while :
do
  echo -e " \033[1;37m マルチセッション対応の設定を実行します\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MAP_e_Nichiban_map_SET ;;
    "n" ) _func_MAP_e_VirtualConnect ;;
    "r" ) break ;;
  esac
done
}

function _func_MAP_e_Nichiban_map_SET {
cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.old
wget --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map.sh.new
read -p " 何かキーを押してデバイスを再起動してください"
reboot
}

function _func_MAP_e_Nichiban_map_Before {
while :
do
  echo -e " \033[1;37mマルチセッション対応の設定を以前の設定に復元します\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_MAP_e_Nichiban_map_Restoration ;;
    "n" ) _func_MAP_e_VirtualConnect ;;
    "r" ) break ;;
  esac
done
}

function _func_MAP_e_Nichiban_map_Restoration {
cp /lib/netifd/proto/map.sh.old /lib/netifd/proto/map.sh
rm /lib/netifd/proto/map.sh.old
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_MAP_e_Nuro {
wget -6 --no-check-certificate -O /etc/config-software/map-e-nuro.sh https://raw.githubusercontent.com/site-u2023/config-software/main/map-e-nuro.sh
sh /etc/config-software/map-e-nuro.sh
}

function _func_DS_LITE_Transix {
while :
do
  echo -e " \033[1;35mトランジックス ---------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: （NTT東日本エリア）トランジックスの設定を実行\033[0;39m"
  echo -e " \033[1;32m[w]: （NTT西日本エリア）トランジックスの設定を実行\033[0;39m"
  echo -e " \033[1;31m[b]: 以前の設定に復元\033[0;39m"
  echo -e " \033[1;33m[r]: 戻る\033[0;39m" 
  echo -e " \033[1;32m------------------------------------------------------\033[0;39m"
  read -p " 選択してください [e/w/b or r]: " num
  case "${num}" in
    "e" ) _func_DS_LITE_Transix_confirmation_east ;;
    "w" ) _func_DS_LITE_Transix_confirmation_west ;;
    "b" ) _func_DS_LITE_Transix_Before ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_Transix_confirmation_east {
while :
do
  echo -e " \033[1;34m（東日本エリア）トランジックスの設定を実行します\033[0;39m"
  echo -e " \033[1;37mgw.transix.jp: 2404:8e00::feed:100\033[0;39m" 
  echo -e " \033[1;37mパッケージ: ds-lite サイズ: 1kBをインストールします\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DS_LITE_Transix_east_SET ;;
    "n" ) _func_DS_LITE_Transix ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_Transix_east_SET {
opkg update
opkg install ds-lite
wget --no-check-certificate -O /etc/config-software/ds-lite.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ds-lite.sh
sed -i -e "s/AFTR_ADDRESS/2404:8e00::feed:100/g" /etc/config-software/ds-lite.sh
sh /etc/config-software/ds-lite.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_DS_LITE_Transix_confirmation_west {
while :
do
  echo -e " \033[1;32m（西日本エリア）トランジックスの設定を実行します\033[0;39m"
  echo -e " \033[1;37mgw.transix.jp: 2404:8e01::feed:100\033[0;39m" 
  echo -e " \033[1;37mパッケージ: ds-lite サイズ: 1kBをインストールします\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DS_LITE_Transix_west_SET ;;
    "n" ) _func_DS_LITE_Transix ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_Transix_west_SET {
opkg update
opkg install ds-lite
wget --no-check-certificate -O /etc/config-software/ds-lite.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ds-lite.sh
sed -i -e "s/AFTR_ADDRESS/2404:8e01::feed:100/g" /etc/config-software/ds-lite.sh
sh /etc/config-software/ds-lite.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_DS_LITE_Transix_Before {
while :
do
  echo -e " \033[1;37mトランジックスの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mパッケージ: ds-liteはリムーブしません\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DS_LITE_Before_Restoration ;;
    "n" ) _func_DS_LITE_Transix ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_Xpass {
while :
do
  echo -e " \033[1;31mクロスパス -------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: クロスパスの設定を実行\033[0;39m"
  echo -e " \033[1;31m[b]: 以前の設定に復元\033[0;39m"
  echo -e " \033[1;33m[r]: 戻る\033[0;39m"    
  echo -e " \033[1;35m------------------------------------------------------\033[0;39m"
  read -p " 選択してください [e/b or r]: " num
  case "${num}" in
    "e" ) _func_DS_LITE_Xpass_confirmation ;;
    "b" ) _func_DS_LITE_Xpass_Before ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_Xpass_confirmation {
while :
do
  echo -e " \033[1;37mクロスパスの設定を実行します\033[0;39m"
  echo -e " \033[1;37mxpass: 2001:f60:0:200::1:1\033[0;39m"
  echo -e " \033[1;37mパッケージ: ds-lite サイズ: 1kBをインストールします\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DS_LITE_Xpass_SET ;;
    "n" ) _func_DS_LITE_Xpass ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_Xpass_SET {
opkg update
opkg install ds-lite
wget --no-check-certificate -O /etc/config-software/ds-lite.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ds-lite.sh
sed -i -e "s/AFTR_ADDRESS/2001:f60:0:200::1:1/g" /etc/config-software/ds-lite.sh
sh /etc/config-software/ds-lite.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_DS_LITE_Xpass_Before {
while :
do
  echo -e " \033[1;37mクロスパスの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mパッケージ: ds-liteはリムーブしません\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DS_LITE_Before_Restoration ;;
    "n" ) _func_DS_LITE_Xpass ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_V6connect {
while :
do
  echo -e " \033[1;36mv6 コネクト -----------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: v6コネクトの設定を実行\033[0;39m"
  echo -e " \033[1;31m[b]: 以前の設定に復元\033[0;39m"
  echo -e " \033[1;33m[r]: 戻る\033[0;39m"    
  echo -e " \033[1;31m-----------------------------------------------------\033[0;39m"
  read -p " 選択してください [e/b or r]: " num
  case "${num}" in
    "e" ) _func_DS_LITE_V6connect_confirmation ;;
    "b" ) _func_DS_LITE_V6connect_Before ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_V6connect_confirmation {
while :
do
  echo -e " \033[1;37mv6 コネクトの設定を実行します\033[0;39m"
  echo -e " \033[1;37mdslite.v6connect.net: 2001:c28:5:301::11\033[0;39m"
  echo -e " \033[1;37mパッケージ: ds-lite サイズ: 1kBをインストールします\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DS_LITE_V6connect_SET ;;
    "n" ) _func_DS_LITE_V6connect ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_V6connect_SET {
opkg update
opkg install ds-lite
wget --no-check-certificate -O /etc/config-software/ds-lite.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ds-lite.sh
sed -i -e "s/AFTR_ADDRESS/2001:c28:5:301::11/g" /etc/config-software/ds-lite.sh
sh /etc/config-software/ds-lite.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_DS_LITE_V6connect_Before {
while :
do
  echo -e " \033[1;37mv6 コネクトの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mパッケージ: ds-liteはリムーブしません\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_DS_LITE_Before_Restoration ;;
    "n" ) _func_DS_LITE_V6connect ;;
    "r" ) break ;;
  esac
done
}

function _func_DS_LITE_Before_Restoration {
cp /etc/config/network.dslite.old /etc/config/network
rm /etc/config/network.dslite.old
cp /lib/netifd/proto/dslite.sh.old /lib/netifd/proto/dslite.sh
rm /etc/config-software/ds-lite.sh
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_PPPoE {
while :
do
  echo -e " \033[1;33m認証ID (ユーザー名)及びパスワードを準備下さい\033[0;39m"
  echo -e " \033[1;37mPPPoE -----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[4]: PPPoEのIPv4接続の設定を実行\033[0;39m"
  echo -e " \033[1;32m[6]: PPPoEのIPv4及びIPv6接続の設定を実行\033[0;39m"
  echo -e " \033[1;31m[b]: PPPoEのIPv4接続を以前の設定に復元\033[0;39m"
  echo -e " \033[1;35m[w]: PPPoEのIPv4及びIPv6接続を以前の設定に復元\033[0;39m"
  echo -e " \033[1;33m[r]: 戻る\033[0;39m"    
  echo -e " \033[1;36m-----------------------------------------------------\033[0;39m"
  read -p " 選択してください [4/6/b/w or r]: " num
  case "${num}" in
    "4" ) _func_PPPoE_ID ;;
    "6" ) _func_PPPoE_ID4 ;;
    "b" ) _func_PPPo_Before ;;
    "w" ) _func_PPPo_Before6 ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_ID {
while :
do
  echo -e "\033[1;37m IPv4接続の認証ID (ユーザー名)を入力して下さい\033[0;39m"
  read -p " PAP・CHAユーザー名: " input_str_ID
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPoE_PASSWORD ;;
    "n" ) _func_PPPoE_ID ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_PASSWORD {
while :
do
  echo -e "\033[1;37m IPv4接続の認証パスワードを入力して下さい\033[0;39m"
  read -p " PAP・CHAパスワード: " input_str_PASSWORD
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPoE_confirmation ;;
    "n" ) _func_PPPoE_PASSWORD ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_confirmation {
while :
do
  echo -e " \033[1;34mPPPoE IPv4 ------------------------------------------\033[0;39m"
  echo -e " \033[1;37m PAP・CHA認証ID (ユーザー名): ${input_str_ID}\033[0;39m"
  echo -e " \033[1;37m PAP・CHA認証パスワード     : ${input_str_PASSWORD}\033[0;39m"
  echo -e " \033[1;34m-----------------------------------------------------\033[0;39m"
  read -p " 設定を開始します [y/n or r]: " num
  case "${num}" in 
    "y" ) _func_PPPoE_SET ;;
    "n" ) _func_PPPoE ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_SET {
cp /etc/config/network /etc/config/network.pppoe.bak
uci set network.wan=interface
uci set network.wan.proto='pppoe'
uci set network.wan.username=${input_str_ID}
uci set network.wan.password=${input_str_PASSWORD}
uci commit network
echo -e " \033[1;37m ${input_str_ID}\033[0;39m"
echo -e " \033[1;37m ${input_str_PASSWORD}\033[0;39m"
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_PPPo_Before {
while :
do
  echo -e " \033[1;37mPPPoEのIPv4接続設定を以前の設定に復元します\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPo_Before_Restoration ;;
    "n" ) _func_PPPoE ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPo_Before_Restoration {
cp /etc/config/network.pppoe.bak /etc/config/network
rm /etc/config/network.pppoe.bak
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_PPPoE_ID4 {
while :
do
  echo -e "\033[1;37m IPv4接続の認証ID ユーザー名を入力して下さい\033[0;39m"
  read -p " PAP・CHAユーザー名: " input_str_ID4
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPoE_PASSWORD4 ;;
    "n" ) _func_PPPoE_ID4 ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_PASSWORD4 {
while :
do
  echo -e "\033[1;37m IPv4接続の認証パスワードを入力して下さい\033[0;39m"
  read -p " PAP・CHAパスワード: " input_str_PASSWORD4
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPoE_ID6 ;;
    "n" ) _func_PPPoE_PASSWORD4 ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_ID6 {
while :
do
  echo -e "\033[1;37m IPv6接続の認証ID (ユーザー名)を入力して下さい\033[0;39m"
  read -p " PAP・CHAユーザー名: " input_str_ID6
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPoE_PASSWORD6 ;;
    "n" ) _func_PPPoE_ID6 ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_PASSWORD6 {
while :
do
  echo -e "\033[1;37m IPv6接続の認証パスワードを入力して下さい\033[0;39m"
  read -p " PAP・CHAパスワード: " input_str_PASSWORD6
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPoE_confirmation6 ;;
    "n" ) _func_PPPoE_PASSWORD6 ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_confirmation6 {
while :
do
  echo -e " \033[1;32mPPPoE IPv4 IPv6 -------------------------------------\033[0;39m"
  echo -e " \033[1;37m PAP・CHA IPv4認証ID (ユーザー名): ${input_str_ID4}\033[0;39m"
  echo -e " \033[1;37m PAP・CHA IPv4認証パスワード     : ${input_str_PASSWORD4}\033[0;39m"
  echo -e " \033[1;37m PAP・CHA IPv6認証ID (ユーザー名): ${input_str_ID6}\033[0;39m"
  echo -e " \033[1;37m PAP・CHA IPv6認証パスワード     : ${input_str_PASSWORD6}\033[0;39m"
  echo -e " \033[1;32m-----------------------------------------------------\033[0;39m"
  read -p " 設定を開始します [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPoE_SET6 ;;
    "n" ) _func_PPPoE ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPoE_SET6 {
cp /etc/config/network /etc/config/network.pppoe6.bak
uci set network.wan=interface
uci set network.wan.proto='pppoe'
uci set network.wan.username=${input_str_ID4}
uci set network.wan.password=${input_str_PASSWORD4}
uci set network.wan6=interface
uci set network.wan6.proto='pppoe'
uci set network.wan6.username=${input_str_ID6}
uci set network.wan6.password=${input_str_PASSWORD6}
uci set firewall.@rule[3].src_port='547'
uci commit network
uci commit firewall
echo -e " \033[1;37m ${input_str_ID4}\033[0;39m"
echo -e " \033[1;37m ${input_str_PASSWORD4}\033[0;39m"
echo -e " \033[1;37m ${input_str_ID6}\033[0;39m"
echo -e " \033[1;37m ${input_str_PASSWORD6}\033[0;39m"
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_PPPo_Before6 {
while :
do
  echo -e " \033[1;37mPPPoEのIPv4及びIPv6接続設定を以前の設定に復元します\033[0;39m"
  read -p " 宜しいですか [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PPPo_Before_Restoration6 ;;
    "n" ) _func_PPPoE ;;
    "r" ) break ;;
  esac
done
}

function _func_PPPo_Before_Restoration6 {
cp /etc/config/network.pppoe6.bak /etc/config/network
rm /etc/config/network.pppoe6.bak
read -p " 何かキーを押してデバイスを再起動してください"
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
  echo -e " \033[1;33mJapanese notation\033[0;39m"
  echo -e " \033[1;33m要ONU直結\033[0;39m"
  echo -e " \033[1;37minternet-config -------------------------------------\033[0;39m"
  echo -e " \033[1;34m[v]: OCNバーチャルコネクト自動設定 (マルチセッション対応)\033[0;39m"
  echo -e " \033[1;33m[p]: V6プラス・IPv6オプション自動設定 (マルチセッション対応)\033[0;39m"
  echo -e " \033[1;32m[n]: NURO光 MAP-e自動設定 (検証中)\033[0;39m"  
  echo -e " \033[1;35m[t]: トランジックス自動設定\033[0;39m"
  echo -e " \033[1;31m[x]: クロスパス自動設定\033[0;39m"
  echo -e " \033[1;36m[c]: v6 コネクト自動設定\033[0;39m"
  echo -e " \033[1;37m[o]: PPPoE (iPv4・IPv6): 要認証ID (ユーザー名)・パスワード\033[0;39m"
  echo -e " \033[7;40m[q]: 終了\033[0;39m"
  echo -e " \033[1;37m----------------------------------------------------\033[0;39m"
  read -p " 選択してください [v/p/n/t/x/c/o or q]: " num
  case "${num}" in
    "v" ) _func_MAP_e_VirtualConnect ;;
    "p" ) _func_MAP_e_V6plus ;;
    "n" ) _func_MAP_e_Nuro ;;
    "t" ) _func_DS_LITE_Transix ;;
    "x" ) _func_DS_LITE_Xpass ;;
    "c" ) _func_DS_LITE_V6connect ;;
    "o" ) _func_PPPoE ;;
    "q" ) exit ;;
  esac
done

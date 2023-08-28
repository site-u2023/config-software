#! /bin/sh

function _func_Dumb_IPV4
while :
do
  echo -e "\033[1;37m アクセスポイントのIPV4アドレスを入力して下さい\033[0;39m"
  read -p " IPV4アドレス: " input_str_IPV4
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_GATEWAY ;;
    "n" ) _func_Dumb_IPV4 ;;
    "r" ) _func_Dumb ;;
  esac
done

function _func_Dumb_GATEWAY
while :
do
  echo -e "\033[1;37m アクセスポイントのゲートウェイを入力して下さい\033[0;39m"
  read -p " ゲートウェイ: " input_str_GATEWAY
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_confirmation ;;
    "n" ) _func_Dumb_GATEWAY ;;
    "r" ) _func_Dumb ;;
  esac
done

function _func_Dumb_confirmation
while :
do
  echo -e " \033[1;37mアクセスポイント -----------------------------------------------\033[0;39m"
  echo -e " \033[1;32m IPV4アドレス: ${input_str_IPV4}\033[0;39m"
  echo -e " \033[1;32m ゲートウェイ: ${input_str_GATEWAY}\033[0;39m"
  echo -e " \033[1;37m---------------------------------------------------------------\033[0;39m"
  read -p " これで宜しければ設定を開始します [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_SET ;;
    "n" ) _func_Dumb_IPV4 ;;
    "r" ) _func_main ;;
  esac
done

function _func_Dumb_SET
{
wget --no-check-certificate -O /etc/dumb.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dumb.sh
sed -i -e "s/ipaddr='192.168.1.2'/ipaddr='${input_str_IPV4}'/g" /etc/dumb.sh
sed -i -e "s/gateway='192.168.1.1'/gateway='${input_str_GATEWAY}'/g" /etc/dumb.sh
sed -i -e "s/dns='192.168.1.1'/dns='${input_str_GATEWAY}'/g" /etc/dumb.sh
sh /etc/dumb.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動してください"
reboot
}

function _func_Dumb_Before
while :
do
  echo -e " \033[1;37mアクセスポイントの設定を以前の設定に復元します\033[0;39m"
  read -p " 本当に宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_Before_Restoration ;;
    "n" ) _func_Dumb ;;
    "r" ) _func_main ;;
  esac
done

function _func_Dumb_Before_Restoration
{
cp /etc/config/network.dump.bak /etc/config/network
rm /etc/config/network.dump.bak
cp /etc/config/dhcp.dump.bak /etc/config/dhcp
rm /etc/config/dhcp.dump.bak
cp /etc/config/firewall.dump.bak /etc/config/firewall
rm /etc/config/firewall.dump.bak
cp /etc/config/wireless.dump.bak /etc/config/wireless
rm /etc/config/wireless.dump.bak
/etc/init.d/odhcpd enable
/etc/init.d/odhcpd start
/etc/init.d/dnsmasq enable
/etc/init.d/dnsmasq start
/etc/init.d/firewall enable
/etc/init.d/firewall start
rm /etc/dumb.sh
read -p " 何かキーを押してデバイスを再起動してください"
reboot
}

function _func_Dumb
while :
do
  echo -e " \033[1;37mアクセスポイント ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]\033[0;39m": アクセスポイントの設定を実行します
  echo -e " \033[1;31m[b]\033[0;39m": 以前の設定に復元します
  echo -e " \033[1;33m[r]\033[0;39m": 戻る    
  echo -e " \033[1;37m---------------------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [e/b or r]: " num
  case "${num}" in
    "e" ) _func_Dumb_IPV4 ;;
    "b" ) _func_Dumb_Before ;;
    "r" ) _func_main ;;
  esac
done

while :
do
  echo -e " \033[1;37mアクセスポイントの設定を開始します\033[0;39m"
  read -p " 開始します [y/n]:" num
  case "${num}" in
    "y" ) _func_Dumb ;;
    "n" ) exit ;;
  esac
done
exit

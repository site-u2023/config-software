#! /bin/sh

function _func_STUBBY {
while :
do
  echo -e " \033[1;35mDNS over TLS（DoT）のインストールを開始します\033[0;39m"
  echo -e " \033[1;37mインストール: stubby\033[0;39m"
  read -e -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_STUBBY_SET ;;
    "n" ) exit ;;
  esac
done
}

function _func_STUBBY_SET {
cp /etc/config/dhcp /etc/config/dhcp.dot.bak
cp /etc/config/network /etc/config/network.dot.bak

UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
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
# ブート失敗対策
sed -i "/exit 0/d" /etc/rc.local
echo "/etc/init.d/stubby restart" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local
echo -e " \033[1;37mインストールと設定が完了しました\033[0;39m"
read -e -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}

function _func_STUBBY_Before {
while :
do
  echo -e " \033[1;37mDNS over TLS（DoT）の設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mリムーブ: stubby\033[0;39m"
  read -p " 本当に宜しいですか? [y/n or r]: " num
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
read -e -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
 read -e -p " AdGuardがインストールされている為終了します"
 exit
fi
if [ "https-dns-proxy" = "`opkg list-installed https-dns-proxy | awk '{ print $1 }'`" ]; then
 read -e -p " https-dns-proxyがインストールされている為終了します"
 exit
fi
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
else
 read -e -p " バージョンが違うため終了します"
 exit
fi
while :
do
  echo -e " \033[1;3mSTUBBY ------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]\033[0;39m": DNS over TLS（DoT）の設定を実行します
  echo -e " \033[1;31m[b]\033[0;39m": DNS over TLS（DoT）の設定を以前の設定に復元します
  echo -e " \033[1;33m[r]\033[0;39m": 戻る    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -e -p " キーを選択してください [e/b or r]: " num
  case "${num}" in
    "e" ) _func_STUBBY ;;
    "b" ) _func_STUBBY_Before ;;
    "r" ) exit ;;
  esac
done

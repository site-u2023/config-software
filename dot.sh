#! /bin/sh

function _func_STUBBY
{
cp /etc/config/dhcp /etc/config/dhcp.dot.bak
cp /etc/config/network /etc/config/network.dot.bak

opkg update
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

read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

while :
do
{
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
else
 read -p " バージョンが違うため終了します"
 exit
fi
}
  echo -e " \033[1;35mSTUBBYのインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_STUBBY ;;
    "n" ) exit ;;
  esac
done

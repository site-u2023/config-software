#! /bin/sh

function _func_adblock
{
opkg update
opkg install adblock
opkg install luci-i18n-adblock-ja
opkg install tcpdump-mini
uci set adblock.global.adb_backupdir="/etc/adblock"
uci commit adblock

cp /etc/adblock/adblock.sources.gz /etc/adblock/adblock.sources.tofu.gz
gunzip /etc/adblock/adblock.sources.tofu.gz

sed -i -e '$d' /etc/adblock/adblock.sources.tofu
sed -i -e '$d' /etc/adblock/adblock.sources.tofu
cat <<"EOF" >> /etc/adblock/adblock.sources.tofu
                },
                "tofu": {
                                "url": "https://raw.githubusercontent.com/tofukko/filter/master/Adblock_Plus_list.txt",
                                "rule": "BEGIN{FS=\"[|^]\"}/^\\|\\|([[:alnum:]_-]{1,63}\\.)+[[:alpha:]]+\\^(\\$third-party)?$/{print tolower($3)}",
                                "size": "XL",
                                "focus": "tofu",
                                "descurl": "https://github.com/tofukko/filter"
               }
}
EOF

gzip /etc/adblock/adblock.sources.tofu

uci set adblock.global.adb_srcarc="/etc/adblock/adblock.sources.tofu.gz"

uci commit adblock

uci set adblock.global.adb_enabled="1"
uci set adblock.global.adb_backup="1"
uci set adblock.global.adb_backupdir="/etc/adblock"
uci set adblock.global.adb_backup_mode="1"
uci add_list adblock.global.adb_sources='tofu'
uci commit adblock
/etc/init.d/adblock enable
/etc/init.d/adblock start

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
  echo -e " \033[1;35mAdBlockのインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_adblock ;;
    "n" ) exit ;;
  esac
done

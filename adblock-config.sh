#! /bin/sh

function _func_AdBlock
while :
do
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]\033[0;39m": AdBlockdのインストールを開始します
  echo -e " \033[1;31m[b]\033[0;39m": AdBlockdの設定を以前の設定に復元します
  echo -e " \033[1;33m[q]\033[0;39m": 終了    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [e/b or q]: " num
  case "${num}" in
    "c" ) _func_AdBlock_Confirm ;;
    "b" ) _func_AdBlock_Before ;;
    "q" ) exit ;;
  esac
done

function _func_AdBlock_Confirm
{
  echo -e " \033[1;35mAdBlockdのインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdBlock_SET ;;
    "n" ) break ;;
  esac
}
 
function _func_AdBlock_SET
{
opkg update
opkg install adblock
opkg install luci-i18n-adblock-ja
opkg install tcpdump-mini
uci set adblock.global.adb_backupdir="/etc/adblock"

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

function _func_AdBlock_Before
while :
do
  echo -e " \033[1;37mAdGuardの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mパッケージ: AdBlockをリムーブします\033[0;39m"
  echo -e " \033[1;37mパッケージ: luci-i18n-adblock-jaをリムーブします\033[0;39m"
  echo -e " \033[1;37mパッケージ: tcpdump-miniをリムーブします\033[0;39m"
  read -p " 本当に宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdBlock_Restoration ;;
    "n" ) _func_AdBlock ;;
    "r" ) _func_AdBlock ;;
  esac
done

function _func_AdBlock_Restoration
{
opkg remove luci-i18n-adblock-ja
opkg remove adblock
opkg remove tcpdump-mini
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
else
 read -p " バージョンが違うため終了します";
 exit
fi
_func_AdBlock

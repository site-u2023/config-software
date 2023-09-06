#! /bin/sh

function _func_AdBlock
while :
do
if [ "adblock" = "`opkg list-installed adblock | awk '{ print $1 }'`" ]; then
  echo -e " \033[1;37mAdBlockが既にインストールされています\033[0;39m"
fi
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]\033[0;39m": AdBlockdのインストールと設定（豆腐フィルタアドイン）
  echo -e " \033[1;31m[b]\033[0;39m": AdBlockdのリムーブと以前の設定に復元
  echo -e " \033[1;33m[q]\033[0;39m": 終了    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " キーを選択して下さい [e/b or q]: " num
  case "${num}" in
    "e" ) _func_AdBlock_Confirm ;;
    "b" ) _func_AdBlock_Before ;;
    "q" ) exit ;;
  esac
done

function _func_AdBlock_Confirm
while :
do
  echo -e " \033[1;35mAdBlockdの設定とインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdBlock_SET ;;
    "n" ) break ;;
  esac
done
 
function _func_AdBlock_SET
{
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
opkg install adblock
opkg install luci-app-adblock
opkg install luci-i18n-adblock-ja
opkg install tcpdump-mini

wget --no-check-certificate -O /etc/config-software/adblock.sh　https://raw.githubusercontent.com/site-u2023/config-software/main/adblock.sh
sh /etc/config-software/adblock.sh

read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}

function _func_AdBlock_Before
while :
do
  echo -e " \033[1;37mAdGuardの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mリムーブ: AdBlock\033[0;39m"
  echo -e " \033[1;37mリムーブ: luci-i18n-adblock-ja\033[0;39m"
  echo -e " \033[1;37mリムーブ: tcpdump-miniをリムーブ\033[0;39m"
  read -p " 本当に宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdBlock_Restoration ;;
    "n" ) _func_AdBlock ;;
    "r" ) _func_AdBlock ;;
  esac
done

function _func_AdBlock_Restoration
{
service adblock stop
service adblock disable
opkg remove luci-i18n-adblock-ja
opkg remove luci-app-adblock
opkg remove adblock
opkg remove tcpdump-mini
rm -rf /etc/adblock
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}


if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
 read -p " AdGuardがインストールされている為終了します"
 exit
fi
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
 _func_AdBlock
else
 read -p " バージョンが違うため終了します"
 exit
fi

#! /bin/sh


function _func_AdGuard_INST {
while :
do
  echo -e " \033[1;34mAdGuard HOME設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/adguard-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard-config.sh
          sh /etc/config-software/adguard-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_AdBlock_INST {
while :
do
  echo -e " \033[1;32mAdBlock設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/adblock-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adblock-config.sh
          sh /etc/config-software/adblock-config.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_DoH {
while :
do
  echo -e " \033[1;32mDNS over HTTPS（DoH）設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/doh.sh https://raw.githubusercontent.com/site-u2023/config-software/main/doh.sh
          sh /etc/config-software/doh.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_DoT {
while :
do
  echo -e " \033[1;32mDNS over TLS（DoT）設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/dot.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dot.sh
          sh /etc/config-software/dot.sh
          break ;;
    "n" ) break ;;
  esac
done
}

while :
do
{
OPENWRT_RELEAS=`cat /etc/banner | grep OpenWrt | awk '{ print $2 }' | cut -c 1-2`
if [ "${OPENWRT_RELEAS}" = "23" ] || [ "${OPENWRT_RELEAS}" = "22" ] || [ "${OPENWRT_RELEAS}" = "21" ] || [ "${OPENWRT_RELEAS}" = "SN" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
 else
 read -p " バージョンが違うため終了します"
 exit
fi
}
  echo -e " \033[7;33mAdGuard HOMEとAdBlockは排他利用\033[0;39m"
  echo -e " \033[7;33mAdGuardとDNS over HTTPS（DoH）は排他利用\033[0;39m"
  echo -e " \033[7;33mAdGuardとDNS over TLS（DoT）は排他利用\033[0;39m"
  echo -e " \033[7;33mDNS over HTTPS（DoH）とDNS over TLS（DoT）は排他利用\033[0;39m"
  echo -e " \033[1;37mad dns blocking config ------------------------------\033[0;39m"
  echo -e " \033[1;34m[g]\033[0;39m": AdGuard HOMEの設定とインストール（カスタムフィルターアドイン）
  echo -e " \033[1;32m[b]\033[0;39m": AdBlockdのインストールと設定（カスタムフィルターアドイン）
  echo -e " \033[1;31m[h]\033[0;39m": DNS over HTTPS（DoH）のインストールと設定
  echo -e " \033[1;33m[t]\033[0;39m": DNS over TLS（DoT）Stubbyのインストールと設定
  echo -e " \033[1;37m[q]\033[0;39m": 終了
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [g/b/h/t or q]: " num
  case "${num}" in
    "g" ) _func_AdGuard_INST ;;
    "b" ) _func_AdBlock_INST ;;
    "h" ) _func_DoH ;;
    "t" ) _func_DoT ;;
    "q" ) exit ;;
  esac
 done 

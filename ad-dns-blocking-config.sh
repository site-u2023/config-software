#! /bin/sh


function _func_AdGuard_INST {
while :
do
  echo -e " \033[1;34mAdGuard設定のスクリプトをダウンロードします\033[0;39m"
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
  echo -e " \033[1;32mDNS over HTTPS (DoH)設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/doh.sh https://raw.githubusercontent.com/site-u2023/config-software/main/doh.sh
          sh /etc/config-software/doh.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_DoT  {
while :
do
  echo -e " \033[1;32mDNS over TLS (DoT)設定のスクリプトをダウンロードします\033[0;39m"
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
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
 else
 read -p " 非対応バージョンのため終了します"
 exit
fi
}
  echo -e " \033[1;37mAdGuardとAdBlockは排他利用\033[0;39m"
  echo -e " \033[1;37mAdGuardとDNS over HTTPS (DoH)は排他利用\033[0;39m"
  echo -e " \033[1;37mAdGuardとDNS over TLS (DoT)は排他利用\033[0;39m"
  echo -e " \033[1;37mDNS over HTTPS (DoH)とDNS over TLS (DoT)\033[0;39m"
  echo -e " \033[1;37mad dns blocking config ------------------------------\033[0;39m"
  echo -e " \033[1;34m[g]\033[0;39m": AdGuardの設定とインストール（280blockerアドイン）
  echo -e " \033[1;32m[b]\033[0;39m": AdBlockdのインストールと設定（豆腐フィルタアドイン）
  echo -e " \033[1;34m[h]\033[0;39m": DNS over HTTPS (DoH)のインストールと設定
  echo -e " \033[1;32m[t]\033[0;39m": DNS over TLS (DoT)のインストールと設定
  echo -e " \033[1;31m[q]\033[0;39m": 終了
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [g/b or q]: " num
  case "${num}" in
    "g" ) _func_AdGuard_INST ;;
    "b" ) _func_AdBlock_INST ;;
    "h" ) _func_DoH ;;
    "t" ) _func_DoT ;;
    "q" ) exit ;;
  esac
 done 

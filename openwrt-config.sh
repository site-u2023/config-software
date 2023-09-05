#! /bin/sh
# OpenWrt >= 21.02:

function _func_SYSTEM
while :
do
  echo -e " \033[1;31mシステム初期設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/system-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/system-config.sh
          sh /etc/config-software/system-config.sh
          break ;;
    "n" ) break ;;
  esac
done

function _func_INTERNET
while :
do
  echo -e " \033[1;32mインターネット接続設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/internet-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/internet-config.sh
          sh /etc/config-software/internet-config.sh
          break ;;
    "n" ) break ;;
  esac
done

function _func_PACKAGE
while :
do
  echo -e " \033[1;35mパッケージインストールのスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-config.sh
          sh /etc/config-software/package-config.sh
          break ;;
    "n" ) break ;;
  esac
done

function _func_ACCESSPOINT
while :
do
  echo -e " \033[1;35mアクセスポイント設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/dumb-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dumb-config.sh
          sh /etc/config-software/dumb-config.sh
          break ;;
    "n" ) break ;;
  esac
done

function _func_AD_DNS
while :
do
  echo -e " \033[1;31mDNS暗号化・広告ブロッカーインストールのスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/ad-dns-blocking-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ad-dns-blocking-config.sh
          sh /etc/config-software/ad-dns-blocking-config.sh
          break ;;
    "n" ) break ;;
  esac
done

function _func_ETC
while :
do
  echo -e " \033[1;36mその他のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software//etc-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/etc-config.sh
          sh /etc/config-software/etc-config.sh
          break ;;
    "n" ) break ;;
  esac
done

function _func_QUIT
while :
do
  echo -e " \033[1;37mこのスクリプト及び関連スクリプトを削除します\033[0;39m"
  echo -e " \033[1;37m復元用ファイルは削除されません\033[0;39m"
  read -p " 削除しますか? [y/n or r]: " num
   case "${num}" in
    "y" ) rm -rf /etc/config-software
          echo -e " \033[1;37mこのスクリプト及び関連スクリプトを削除して終了しました\033[0;39m"
          exit ;;
    "n" ) echo -e " \033[1;37m終了しました\033[0;39m"
          exit ;;
    "r" ) break ;;
   esac 
done


OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;32mバージョンチェック: OK\033[0;39m"
 else
 read -p " 非対応バージョンのため終了します"
 exit
fi

  AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
  AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  echo -e " \033[1;37mOpenWrt-CONFIG 03.3.3\033[0;39m"
  echo -e " \033[1;37mAugust 25, 2023\033[0;39m"
  echo -e " \033[1;37m利用可能メモリー容量: ${AVAILABLE_MEMORY}KB\033[0;39m"
  echo -e " \033[1;37m利用可能フラッシュ容量: ${AVAILABLE_FLASH}KB\033[0;39m"
  echo -e " \033[1;37mスクリプト設置ディレクトリ: /etc/config-software\033[0;39m" 
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " 何かキーを押して下さい"

while :
do
  echo -e " \033[1;33m推奨設定順序: システム > インターネット > パッケージ\033[0;39m"  
  echo -e " \033[1;37mopenwrt-config --------------------------------------\033[0;39m"
  echo -e " \033[1;34m[s]\033[0;39m": システム初期設定（ホストネーム・パスワード等）
  echo -e " \033[1;33m[i]\033[0;39m": インターネット（MAP-e・DS-LITE・PPPoE）接続設定
  echo -e " \033[1;32m[p]\033[0;39m": 推奨パッケージインストール（USB自動判別）
  echo -e " \033[1;35m[a]\033[0;39m": アクセスポイント（Dumb / ブリッジ）設定
  echo -e " \033[1;31m[d]\033[0;39m": 広告ブロッカー・DNS暗号化インストール
  echo -e " \033[1;36m[e]\033[0;39m": その他：IPERF3 / WiFi位置情報サービス停止
  echo -e " \033[7;40m[q]\033[0;39m": 終了
  echo -e " \033[1;37m---------------------------------------------------- \033[0;39m"
  read -p " キーを選択してください [s/i/p/a/d/e or q]: " num
  case "${num}" in
    "s" ) _func_SYSTEM ;;
    "i" ) _func_INTERNET ;;
    "p" ) _func_PACKAGE ;;
    "a" ) _func_ACCESSPOINT ;;
    "d" ) _func_AD_DNS ;;
    "e" ) _func_ETC ;;
    "q" ) _func_QUIT ;;
  esac
 done 

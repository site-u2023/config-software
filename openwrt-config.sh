#! /bin/sh


function _func_SYSTEM
while :
do
  echo -e " \033[1;34mシステム初期設定のスクリプトをダウンロードします\033[0;39m"
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
AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
  echo -e " \033[1;37mスクリプト設置ディレクトリ: /etc/config-software\033[0;39m" 
  echo -e " \033[1;37m推奨設定順序: システム > インターネット > パッケージ\033[0;39m" 
  echo -e " \033[1;37mopenwrt-config ------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[s]\033[0;39m": システム初期設定
  echo -e " \033[1;32m[i]\033[0;39m": インターネット接続設定
  echo -e " \033[1;35m[p]\033[0;39m": パッケージインストール（USB自動判別）
  echo -e " \033[1;31m[a]\033[0;39m": アクセスポイント（Dumb）設定
  echo -e " \033[1;37m[r]\033[0;39m": スクリプトリムーブ後終了
  echo -e " \033[7;40m[q]\033[0;39m": 終了
  echo -e " \033[1;37m------------------------------------- August 27, 2023 Ver.2.9.5\033[0;39m"
  read -p " キーを選択してください [s/i/p/a or r/q]: " num
  case "${num}" in
    "s" ) _func_SYSTEM ;;
    "i" ) _func_INTERNET ;;
    "p" ) _func_PACKAGE ;;
    "a" ) _func_ACCESSPOINT ;;
    "r" ) echo -e " \033[1;31mこのスクリプト及び関連スクリプトをリムーブ後終了しました\033[0;39m"
          rm -rf /etc/config-software
          break ;;
    "q" ) echo -e " \033[1;31m終了しました\033[0;39m"
          break ;;
  esac
 done 

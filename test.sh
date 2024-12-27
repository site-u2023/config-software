#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

# インターネット接続設定スクリプトのダウンロード
download_internet_script() {
  echo -e "\033[1;34mDownload scripts for Internet connection\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/internet-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/internet-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/internet-config.sh
  else
    echo "Download failed!"
  fi
}

# システム設定スクリプトのダウンロード
download_system_script() {
  echo -e "\033[1;33mDownload scripts for initial system setup\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/system-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/system-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/system-config.sh
  else
    echo "Download failed!"
  fi
}

# パッケージ設定スクリプトのダウンロード
download_package_script() {
  echo -e "\033[1;32mDownload script for package setup\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/package-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/package-config.sh
  else
    echo "Download failed!"
  fi
}

# 広告及びDNSブロック設定スクリプト
download_ad-dns-blocking_script() {
  echo -e "\033[1;37mDownload script for ad-blocking setup\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/ad-dns-blocking-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ad-dns-blocking-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/ad-dns-blocking-config.sh
  else
    echo "Download failed!"
  fi
}

# アクセスポイント設定スクリプト
download_dumb_script() {
  echo -e "\033[1;37mDownload script for dumb setup\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/dumb-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/dumb-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/dumb-config.sh
  else
    echo "Download failed!"
  fi
}

# その他の設定スクリプト
download_other_script() {
  echo -e "\033[1;37mDownload other scripts\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/etc-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/etc-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/etc-config.sh
  else
    echo "Download failed!"
  fi
}

# スクリプト削除
delete() {
  echo -e "Deleting script and exiting."
  rm -rf /etc/config-software
  rm -rf /usr/bin/confsoft
  exit
}

# バージョンチェック
check_version() {
  OPENWRT_RELEASE=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
  case "$OPENWRT_RELEASE" in
    19|20|21|22|23|24|SN)
      echo "The version of this device is \033[1;33m$OPENWRT_RELEASE\033[0;39m"
      echo "Version Check: \033[1;36mOK\033[0;39m"
      ;;
    *)
      echo "Incompatible version."
      exit 1
      ;;
  esac
}


# メモリとフラッシュの空き容量確認
check_memory() {
  AVAILABLE_MEMORY=$(free | fgrep 'Mem:' | awk '{ print $4 }')
  AVAILABLE_FLASH=$(df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }')
  echo -e "Available Memory: $((AVAILABLE_MEMORY / 1024)) MB"
  echo -e "Available Flash: $((AVAILABLE_FLASH / 1024)) MB"
}

# メインメニュー
main_menu() {
  while :; do
    echo -e "Please select an option:"
    echo -e "[i] Internet Setup (Japanese line only)"
    echo -e "[s] System Setup"
    echo -e "[p] Package Setup"
    echo -e "[d] Dumb Setup"
    echo -e "[o] Other Configurations"
    echo -e "[r] Delete & exit scripts"
    echo -e "[q] Quit"

    read -p "Select option: " option
    case "$option" in
      "i") download_internet_script ;;
      "s") download_system_script ;;
      "p") download_package_script ;;
      "d") download_dumb_script ;;
      "e") download_other_script ;;
      "r") delete ;;
      "q") exit ;;
      *) echo "Invalid option!" ;;
    esac
  done
}

# 初期処理
check_version
check_memory
main_menu

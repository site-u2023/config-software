#!/bin/sh
# License: CC0

# バージョン確認
check_version() {
  OPENWRT_RELEAS=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
  
  if [[ ! "${OPENWRT_RELEAS}" =~ ^(19|21|22|23|24)$ ]]; then
    echo "Unsupported OpenWRT version: ${OPENWRT_RELEAS}"
    echo "Supported versions: 19, 21, 22, 23, 24"
    exit 1
  fi
  
  echo "OpenWRT version: ${OPENWRT_RELEAS} - Supported"
}

# メモリ確認
check_memory() {
  MEMORY=$(free | grep Mem | awk '{print $2}')
  
  # メモリが256MB未満なら警告
  if [ "$MEMORY" -lt 262144 ]; then
    echo "Warning: Low memory detected. Ensure you have at least 256MB of RAM."
  else
    echo "Memory check passed."
  fi
}

# wgetを使って設定スクリプトをダウンロードして実行
download_and_execute() {
  local script_name=$1
  local script_url=$2
  
  echo "Downloading ${script_name} configuration..."
  wget --no-check-certificate -O "/etc/config-software/${script_name}.sh" "${script_url}"
  
  if [ $? -eq 0 ]; then
    sh "/etc/config-software/${script_name}.sh"
  else
    echo "Error downloading ${script_name}. Please check the URL or your network connection."
    exit 1
  fi
}

# メインメニュー表示と選択処理
main_menu() {
  while :; do
    echo -e "\033[1;35mPlease choose an option:\033[0m"
    echo -e " \033[1;34m[g]\033[0m: Install AdGuard HOME"
    echo -e " \033[1;32m[b]\033[0m: Install AdBlock"
    echo -e " \033[1;31m[h]\033[0m: Configure DNS over HTTPS (DoH)"
    echo -e " \033[1;33m[t]\033[0m: Configure DNS over TLS (DoT)"
    echo -e " \033[1;37m[q]\033[0m: Quit"
    
    read -p "Select an option: " option
    
    case "$option" in
      g) download_and_execute "adguard-config" "https://raw.githubusercontent.com/site-u2023/config-software/main/adguard-config.sh" ;;
      b) download_and_execute "adblock-config" "https://raw.githubusercontent.com/site-u2023/config-software/main/adblock-config.sh" ;;
      h) download_and_execute "doh" "https://raw.githubusercontent.com/site-u2023/config-software/main/doh.sh" ;;
      t) download_and_execute "dot" "https://raw.githubusercontent.com/site-u2023/config-software/main/dot.sh" ;;
      q) exit 0 ;;
      *) echo "Invalid option, please try again." ;;
    esac
  done
}

# 初期処理
check_version
check_memory
main_menu

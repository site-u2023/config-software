#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

# スクリプトのダウンロードと実行を行う関数
download_and_execute() {
    local script_name=$1
    local url=$2
    local description=$3
    local color_code=$4

    echo -e "\033[${color_code}m${description}\033[0;39m"
    wget --no-check-certificate -O "/etc/config-software/${script_name}" "${url}"
    if [ $? -eq 0 ]; then
        sh "/etc/config-software/${script_name}"
    else
        echo "Download failed!"
    fi
}

# スクリプト削除と終了
delete_and_exit() {
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
            echo -e "The version of this device is \033[1;33m$OPENWRT_RELEASE\033[0;39m"
            echo -e "Version Check: \033[1;36mOK\033[0;39m"
            ;;
        *)
            echo "Incompatible version."
            exit 1
            ;;
    esac
}

# メモリとフラッシュの空き容量確認
check_memory() {
    AVAILABLE_MEMORY=$(free | awk '/Mem:/ { print $4 }')
    AVAILABLE_FLASH=$(df | awk '/overlayfs:\/overlay/ { print $4 }')
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
        echo -e "[b] Bridge Setup"
        echo -e "[a] Ads and DNS blockers Setup"
        echo -e "[o] Other Configurations"
        echo -e "[d] Delete & exit scripts"
        echo -e "[q] Quit"

        read -p "Select option: " option
        case "$option" in
            "i")
                download_and_execute "internet-config.sh" \
                    "https://raw.githubusercontent.com/site-u2023/config-software/main/internet-config.sh" \
                    "Download scripts for Internet connection" "1;34"
                ;;
            "s")
                download_and_execute "system-config.sh" \
                    "https://raw.githubusercontent.com/site-u2023/config-software/main/system-config.sh" \
                    "Download scripts for initial system setup" "1;33"
                ;;
            "p")
                download_and_execute "package-config.sh" \
                    "https://raw.githubusercontent.com/site-u2023/config-software/main/package-config.sh" \
                    "Download script for package setup" "1;32"
                ;;
            "b")
                download_and_execute "bridge-config.sh" \
                    "https://raw.githubusercontent.com/site-u2023/config-software/main/bridge-config.sh" \
                    "Download script for bridge setup" "1;37"
                ;;
            "a")
                download_and_execute "ad-dns-blocker-config.sh" \
                    "https://raw.githubusercontent.com/site-u2023/config-software/main/ad-dns-blocker-config.sh" \
                    "Download script for ads and DNS blockers setup" "1;37"
                ;;
            "o")
                download_and_execute "etc-config.sh" \
                    "https://raw.githubusercontent.com/site-u2023/config-software/main/etc-config.sh" \
                    "Download other scripts" "1;37"
                ;;
            "d")
                delete_and_exit
                ;;
            "q")
                exit
                ;;
            *)
                echo "Invalid option!"
                ;;
        esac
    done
}

# 初期処理
check_version
check_memory
main_menu

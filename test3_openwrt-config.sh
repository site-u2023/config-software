#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

LOG_FILE="/var/log/script_execution.log"

# ログをファイルに記録する関数
log_message() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# スクリプトのダウンロードと実行を行う関数
download_and_execute() {
    local script_name=$1
    local url=$2
    local description=$3
    local color_code=$4

    echo -e "\033[${color_code}m${description}\033[0;39m"
    log_message "Starting download: $description from $url"
    
    wget --no-check-certificate -O "/etc/config-software/${script_name}" "${url}"
    
    if [ $? -eq 0 ]; then
        log_message "Download successful: $script_name"
        sh "/etc/config-software/${script_name}"
        if [ $? -eq 0 ]; then
            log_message "Execution successful: $script_name"
        else
            log_message "Execution failed: $script_name"
            echo "Execution failed!"
        fi
    else
        log_message "Download failed: $script_name"
        echo "Download failed!"
    fi
}

# スクリプト削除と終了
delete_and_exit() {
    echo -e "Deleting script and exiting."
    log_message "Deleting scripts and exiting."
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
            log_message "Version check: OpenWRT $OPENWRT_RELEASE - OK"
            ;;
        *)
            echo "Incompatible version."
            log_message "Version check: Incompatible version $OPENWRT_RELEASE"
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
    log_message "Memory check: Available memory: $((AVAILABLE_MEMORY / 1024)) MB, Available flash: $((AVAILABLE_FLASH / 1024)) MB"
}

# スクリプトの設定リスト
declare -A script_list
script_list=(
    ["i"]="internet-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/internet-config.sh Internet Setup (Japanese line only) 1;34"
    ["s"]="system-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/system-config.sh System Setup 1;33"
    ["p"]="package-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-config.sh Package Setup 1;32"
    ["b"]="bridge-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/bridge-config.sh Bridge Setup 1;37"
    ["a"]="ad-dns-blocker-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ad-dns-blocker-config.sh Ads and DNS blockers Setup 1;37"
    ["o"]="etc-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/etc-config.sh Other Configurations 1;37"
)

# メインメニュー
main_menu() {
    while :; do
        echo -e "Please select an option:"
        for key in "${!script_list[@]}"; do
            IFS=" " read -r script_name url description color_code <<< "${script_list[$key]}"
            echo -e "[$key] $description"
        done
        echo -e "[d] Delete & exit scripts"
        echo -e "[q] Quit"

        read -p "Select option: " option
        if [ "$option" == "q" ]; then
            log_message "Exiting script"
            exit
        elif [ "$option" == "d" ]; then
            delete_and_exit
        elif [[ -v script_list["$option"] ]]; then
            IFS=" " read -r script_name url description color_code <<< "${script_list[$option]}"
            download_and_execute "$script_name" "$url" "$description" "$color_code"
        else
            echo "Invalid option!"
            log_message "Invalid option selected: $option"
        fi
    done
}

# 初期処理
check_version
check_memory
main_menu

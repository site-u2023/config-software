#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

LOG_FILE="/var/log/all_in_one_script_execution.log"
COLOR_FILE="/etc/config-software/colors.txt"
MENU_FILE="/etc/config-software/menu.txt"
BASE_URL="https://github.com/site-u2023/config-software/blob/main/"
CONFIG_DIR="/etc/config-software"

# ログをファイルに記録する関数
log_message() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# スクリプトのダウンロードと実行を行う関数
download_and_execute() {
    local script_name=$1
    local description=$2
    local color_code=$(grep "$description" "$COLOR_FILE" | cut -d' ' -f2)

    mkdir -p "$CONFIG_DIR"
    echo -e "\033[${color_code}m${description}\033[0;39m"
    log_message "Starting download: $description from ${BASE_URL}${script_name}"

    wget --no-check-certificate -O "${CONFIG_DIR}/${script_name}" "${BASE_URL}${script_name}" 2>> "$LOG_FILE"

    if [ $? -eq 0 ]; then
        # ダウンロード成功時
        log_message "Download successful: $script_name"
        sh "${CONFIG_DIR}/${script_name}"
        if [ $? -eq 0 ]; then
            log_message "Execution successful: $script_name"
        else
            log_message "Execution failed: $script_name"
            echo "Execution failed!"
        fi
    else
        # ダウンロード失敗時
        log_message "Download failed or link unavailable: $script_name"
        echo "The link may be temporarily unavailable or under maintenance. Please try again later."
    fi
}

# スクリプト削除と終了
delete_and_exit() {
    echo -e "Deleting script and exiting."
    log_message "Deleting scripts and exiting."
    rm -rf "$CONFIG_DIR"
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

# メニュー表示
main_menu() {
    while :; do
        echo -e "Please select an option:"

        while IFS= read -r line; do
            description=$(echo "$line" | cut -d' ' -f1)
            echo -e "$description"
        done < "$MENU_FILE"

        read -p "Select option: " option
        case "$option" in
            "i")
                download_and_execute "internet-config.sh" "Internet Setup (Japanese line only)"
                ;;
            "s")
                download_and_execute "system-config.sh" "System Setup"
                ;;
            "p")
                download_and_execute "package-config.sh" "Package Setup"
                ;;
            "b")
                download_and_execute "bridge-config.sh" "Bridge Setup"
                ;;
            "a")
                download_and_execute "ad-dns-blocker-config.sh" "Ads and DNS blockers Setup"
                ;;
            "o")
                download_and_execute "etc-config.sh" "Other Configurations"
                ;;
            "d")
                delete_and_exit
                ;;
            "q")
                log_message "Exiting script"
                exit
                ;;
            *)
                echo "Invalid option!"
                log_message "Invalid option selected: $option"
                ;;
        esac
    done
}

# 初期処理
check_version
check_memory
main_menu

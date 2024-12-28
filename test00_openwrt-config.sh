#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

LOG_FILE="/var/log/all_in_one_script_execution.log"
BASE_URL="https://raw.githubusercontent.com/site-u2023/config-software/main"

# 外部ファイルの読み込み
COLORS_FILE="/etc/config-software/colors.txt"
MENU_ITEMS_FILE="/etc/config-software/menu_items.txt"

# ログをファイルに記録する関数
log_message() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# 外部ファイルの読み込み
load_colors() {
    if [ -f "$COLORS_FILE" ]; then
        . "$COLORS_FILE"
    else
        echo "Error: Colors file not found!"
        exit 1
    fi
}

load_menu_items() {
    if [ -f "$MENU_ITEMS_FILE" ]; then
        MENU_ITEMS=$(cat "$MENU_ITEMS_FILE")
    else
        echo "Error: Menu items file not found!"
        exit 1
    fi
}

# スクリプトのダウンロードと実行を行う関数
download_and_execute() {
    local script_name=$1
    local url=$2
    local description=$3
    local color_code=$4

    echo -e "\033[${color_code}m${description}\033[0;39m"
    log_message "Starting download: $description from $url"

    wget --no-check-certificate --spider "$url" 2>&1 | grep -q "HTTP/1.1 200 OK"
    if [ $? -eq 0 ]; then
        log_message "Download successful: $script_name"
        wget --no-check-certificate -O "/etc/config-software/${script_name}" "${url}"
        if [ $? -eq 0 ]; then
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
    else
        log_message "Download failed: Maintenance in progress for $script_name"
        echo "Maintenance in progress. The link may be temporarily unavailable."
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

        # メニューオプションを表示
        echo "$MENU_ITEMS" | while IFS=, read -r key description relative_url color; do
            echo -e "\033[${color}m[${key}] ${description}\033[0;39m"
        done

        read -p "Select option: " option
        case "$option" in
            $(echo "$MENU_ITEMS" | awk -F, '{print $1}' | tr '\n' '|')q)
                if [ "$option" = "q" ]; then
                    log_message "Exiting script"
                    exit
                else
                    script_name=$(echo "$MENU_ITEMS" | grep "^${option}," | cut -d',' -f3)
                    description=$(echo "$MENU_ITEMS" | grep "^${option}," | cut -d',' -f2)
                    relative_url=$(echo "$MENU_ITEMS" | grep "^${option}," | cut -d',' -f4)
                    color=$(echo "$MENU_ITEMS" | grep "^${option}," | cut -d',' -f5)
                    download_and_execute "$script_name" "${BASE_URL}/${relative_url}" "$description" "$color"
                fi
                ;;
            *)
                echo "Invalid option!"
                log_message "Invalid option selected: $option"
                ;;
        esac
    done
}

# 初期処理
load_colors
load_menu_items
check_memory
main_menu

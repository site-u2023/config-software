#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

LOG_FILE="/var/log/all_in_one_script_execution.log"
CONFIG_DIR="/etc/config-software"
SCRIPTS_LIST="$CONFIG_DIR/openwrt-config.list"

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

    echo "$description"
    log_message "Starting download: $description from $url"
    
    # 外部からスクリプトをダウンロード
    wget --no-check-certificate -O "${CONFIG_DIR}/${script_name}" "${url}"
    
    if [ $? -eq 0 ]; then
        log_message "Download successful: $script_name"
        # ダウンロードしたスクリプトをローカルで実行
        sh "${CONFIG_DIR}/${script_name}"
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
    echo "Deleting script and exiting."
    log_message "Deleting scripts and exiting."
    rm -rf "${CONFIG_DIR}"
    rm -f /usr/bin/confsoft
    exit
}

# バージョンチェック
check_version() {
    OPENWRT_RELEASE=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
    case "$OPENWRT_RELEASE" in
        19|20|21|22|23|24)
            echo "The version of this device is $OPENWRT_RELEASE"
            echo "Version Check: OK"
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
    echo "Available Memory: $((AVAILABLE_MEMORY / 1024)) MB"
    echo "Available Flash: $((AVAILABLE_FLASH / 1024)) MB"
    log_message "Memory check: Available memory: $((AVAILABLE_MEMORY / 1024)) MB, Available flash: $((AVAILABLE_FLASH / 1024)) MB"
}

# スクリプトリストの読み込み
load_script_list() {
    # スクリプトリストファイルが存在しない場合は作成
    if [ ! -f "$SCRIPTS_LIST" ]; then
        echo "Error: Script list file does not exist."
        log_message "Error: Script list file does not exist."
        exit 1
    fi

    # スクリプトリストを配列に格納
    while IFS=' ' read -r SCRIPT_NAME URL DESCRIPTION COLOR_CODE; do
        # 空行やコメント行を無視
        if [ -z "$SCRIPT_NAME" ] || [[ "$SCRIPT_NAME" == \#* ]]; then
            continue
        fi
        # 配列に格納する
        SCRIPT_LIST["$SCRIPT_NAME"]="$URL|$DESCRIPTION|$COLOR_CODE"
    done < "$SCRIPTS_LIST"
}

# メインメニュー
main_menu() {
    while :; do
        echo -e "Please select an option:"
        # スクリプトリストを表示
        for SCRIPT_NAME in "${!SCRIPT_LIST[@]}"; do
            IFS="|" read -r URL DESCRIPTION COLOR_CODE <<< "${SCRIPT_LIST[$SCRIPT_NAME]}"
            echo -e "[$SCRIPT_NAME] $DESCRIPTION"
        done
        echo -e "[d] Delete & exit scripts"
        echo -e "[q] Quit"

        read -p "Select option: " option
        case "$option" in
            "q")
                log_message "Exiting script"
                exit
                ;;
            "d")
                delete_and_exit
                ;;
            *)
                if [ -n "${SCRIPT_LIST[$option]}" ]; then
                    IFS="|" read -r URL DESCRIPTION COLOR_CODE <<< "${SCRIPT_LIST[$option]}"
                    download_and_execute "$option.sh" "$URL" "$DESCRIPTION" "$COLOR_CODE"
                else
                    echo "Invalid option!"
                    log_message "Invalid option selected: $option"
                fi
                ;;
        esac
    done
}

# 初期処理
check_version
check_memory
load_script_list
main_menu

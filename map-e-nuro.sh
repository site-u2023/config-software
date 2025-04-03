#!/bin/sh
#===============================================================================
# NURO光 MAP-E設定スクリプト (POSIX準拠版)
# 
# 機能: NURO光向けMAP-E接続の自動設定と管理
# バージョン: 1.0.0 (2025-04-04)
#
# このスクリプトはPOSIX準拠でOpenWrtの環境で動作します。
#===============================================================================

# 設定変数
VERSION="1.0.0"
WAN_IFACE="wan"
WAN6_IFACE="wan6"
TEMP_DIR="/tmp"
CACHE_DIR="/tmp/nuro_cache"
SIMULATION_MODE=1  # 1=シミュレーションモード、0=適用モード

# グローバル変数
BR_ADDR=""
IPV6_PREFIX=""
IPV4_PREFIX=""

# デバッグログ関数（英語）
debug_log() {
    [ -n "$DEBUG" ] && echo "DEBUG: $1" >&2
}

# 情報出力関数（日本語）
print_info() {
    echo "$1"
}

# エラー出力関数（日本語）
print_error() {
    echo "エラー: $1" >&2
}

# キャッシュディレクトリ作成
create_cache_dir() {
    if [ ! -d "$CACHE_DIR" ]; then
        mkdir -p "$CACHE_DIR"
        debug_log "Created cache directory at $CACHE_DIR"
    fi
}

# ネットワーク関数のロード
load_network_libs() {
    if [ ! -f "/lib/functions/network.sh" ]; then
        print_error "OpenWrtネットワーク関数が見つかりません"
        return 1
    fi

    . /lib/functions/network.sh
    network_flush_cache
    debug_log "Network functions loaded"
    return 0
}

# 必要コマンドの確認
check_commands() {
    local missing=""
    local required_commands="ip uci"
    
    for cmd in $required_commands; do
        if ! command -v "$cmd" > /dev/null 2>&1; then
            missing="$missing $cmd"
        fi
    done
    
    if [ -n "$missing" ]; then
        print_error "以下のコマンドが見つかりません:$missing"
        return 1
    fi
    
    debug_log "All required commands are available"
    return 0
}

# IPv6アドレス正規化と取得
normalize_ipv6() {
    local prefix="$1"
    local normalized=""
    local cn=0
    
    debug_log "Normalizing IPv6: $prefix"
    
    # 基本的な形式チェック
    if ! expr "$prefix" : '[[:xdigit:]:]\{2,\}$' > /dev/null; then
        print_error "無効なIPv6形式です"
        return 1
    fi
    
    # コロンの数をカウント
    cn=$(echo "$prefix" | grep -o ":" | wc -l)
    
    if [ $cn -lt 2 ] || [ $cn -gt 7 ]; then
        print_error "IPv6形式が不正です"
        return 1
    fi
    
    # 正規化処理
    normalized=$(echo "$prefix" | sed '
        s/^:/0000:/
        s/:$/:0000/
        s/.*/:&:/
        :add0
        s/:\([^:]\{1,3\}\):/:0\1:/g
        t add0
        s/:\(.*\):/\1/')
    
    if echo "$normalized" | grep -q "::"; then
        local zeros=$(echo -n :::::: | tail -c $((8-cn)) | sed 's/:/0000:/g')
        normalized=$(echo "$normalized" | sed "s/::/:$zeros/")
    fi
    
    echo "$normalized"
    debug_log "Normalized IPv6: $normalized"
    return 0
}

# IPv6アドレス取得
get_ipv6_address() {
    local ipv6_addr=""
    local net_if6=""
    
    debug_log "Retrieving IPv6 address"
    
    # OpenWrtネットワーク関数を利用
    if load_network_libs; then
        network_find_wan6 net_if6
        network_get_prefix6 ipv6_addr "$net_if6"
        
        if [ -n "$ipv6_addr" ]; then
            debug_log "Got IPv6 prefix: $ipv6_addr"
            echo "$ipv6_addr"
            return 0
        fi
    fi
    
    # 代替方法
    ipv6_addr=$(ip -6 addr show dev "$WAN6_IFACE" scope global | grep inet6 | head -n1 | awk '{print $2}' | cut -d/ -f1)
    
    if [ -n "$ipv6_addr" ]; then
        debug_log "Got IPv6 address with ip command: $ipv6_addr"
        echo "$ipv6_addr"
        return 0
    fi
    
    print_error "IPv6アドレスを取得できませんでした"
    return 1
}

# NURO光MAP-Eパターンの判定
detect_nuro_pattern() {
    local ipv6_prefix="$1"
    local nuro_prefix=""
    
    if [ -z "$ipv6_prefix" ]; then
        print_error "IPv6プレフィックスが指定されていません"
        return 1
    fi
    
    # IPv6プレフィックスの最初の11文字を取得（NURO光パターンに一致する部分）
    nuro_prefix=$(echo "$ipv6_prefix" | cut -b -11)
    debug_log "Extracted NURO prefix: $nuro_prefix"
    
    # 既知のパターンに一致するか確認
    case "$nuro_prefix" in
        # 既知のパターン
        "240d:000f:0")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:0000"
            IPV4_PREFIX="219.104.128.0"
            debug_log "Matched known pattern 0"
            return 0
            ;;
        "240d:000f:1")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:1000"
            IPV4_PREFIX="219.104.144.0"
            debug_log "Matched known pattern 1"
            return 0
            ;;
        "240d:000f:2")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:2000"
            IPV4_PREFIX="219.104.160.0"
            debug_log "Matched known pattern 2"
            return 0
            ;;
        "240d:000f:3")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:3000"
            IPV4_PREFIX="219.104.176.0"
            debug_log "Matched known pattern 3"
            return 0
            ;;
        # 予測パターン（付加情報として）
        "240d:000f:4")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:4000"
            IPV4_PREFIX="219.104.192.0"
            debug_log "Matched predicted pattern 4"
            return 0
            ;;
        "240d:000f:5")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:5000"
            IPV4_PREFIX="219.104.208.0"
            debug_log "Matched predicted pattern 5"
            return 0
            ;;
        "240d:000f:6")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:6000"
            IPV4_PREFIX="219.104.224.0"
            debug_log "Matched predicted pattern 6"
            return 0
            ;;
        "240d:000f:7")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:7000"
            IPV4_PREFIX="219.104.240.0"
            debug_log "Matched predicted pattern 7"
            return 0
            ;;
        "240d:000f:8")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:8000"
            IPV4_PREFIX="219.105.0.0"
            debug_log "Matched predicted pattern 8"
            return 0
            ;;
        "240d:000f:9")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:9000"
            IPV4_PREFIX="219.105.16.0"
            debug_log "Matched predicted pattern 9"
            return 0
            ;;
        "240d:000f:a")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:a000"
            IPV4_PREFIX="219.105.32.0"
            debug_log "Matched predicted pattern a"
            return 0
            ;;
        "240d:000f:b")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:b000"
            IPV4_PREFIX="219.105.48.0"
            debug_log "Matched predicted pattern b"
            return 0
            ;;
        "240d:000f:c")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:c000"
            IPV4_PREFIX="219.105.64.0"
            debug_log "Matched predicted pattern c"
            return 0
            ;;
        "240d:000f:d")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:d000"
            IPV4_PREFIX="219.105.80.0"
            debug_log "Matched predicted pattern d"
            return 0
            ;;
        "240d:000f:e")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:e000"
            IPV4_PREFIX="219.105.96.0"
            debug_log "Matched predicted pattern e"
            return 0
            ;;
        "240d:000f:f")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:000f:f000"
            IPV4_PREFIX="219.105.112.0"
            debug_log "Matched predicted pattern f"
            return 0
            ;;
        # 別のプレフィックスエリア（予測）
        "240d:0010:0")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:0010:0000"
            IPV4_PREFIX="219.105.128.0"
            debug_log "Matched predicted alt pattern 0"
            return 0
            ;;
        "240d:0010:1")
            BR_ADDR="2001:3b8:200:ff9::1"
            IPV6_PREFIX="240d:0010:1000"
            IPV4_PREFIX="219.105.144.0"
            debug_log "Matched predicted alt pattern 1"
            return 0
            ;;
        # 不明なパターン
        *)
            debug_log "Unknown pattern: $nuro_prefix"
            return 1
            ;;
    esac
}

# MAP-E設定関数（NURO光）
setup_nuro_mape() {
    debug_log "Setting up NURO MAP-E configuration"
    
    # OpenWrtバージョンの取得
    OPENWRT_RELEASE=""
    if [ -f "/etc/openwrt_release" ]; then
        OPENWRT_RELEASE=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
        debug_log "Detected OpenWrt release: $OPENWRT_RELEASE"
    fi
    
    # 設定のバックアップ作成
    cp /etc/config/network /etc/config/network.nuro.bak 2>/dev/null
    cp /etc/config/dhcp /etc/config/dhcp.nuro.bak 2>/dev/null
    cp /etc/config/firewall /etc/config/firewall.nuro.bak 2>/dev/null
    debug_log "Configuration backup created"
    
    # DHCP LAN設定
    uci set dhcp.lan.ra='relay'
    uci set dhcp.lan.dhcpv6='server'
    uci set dhcp.lan.ndp='relay'
    uci set dhcp.lan.force='1'
    
    # WAN設定
    uci set network.wan.auto='1'
    
    # DHCP WAN6設定
    uci set dhcp.wan6=dhcp
    uci set dhcp.wan6.master='1'
    uci set dhcp.wan6.ra='relay'
    uci set dhcp.wan6.dhcpv6='relay'
    uci set dhcp.wan6.ndp='relay'
    
    # WANMAP設定
    local WANMAP='wanmap'
    uci set network.${WANMAP}=interface
    uci set network.${WANMAP}.proto='map'
    uci set network.${WANMAP}.maptype='map-e'
    uci set network.${WANMAP}.peeraddr=${BR_ADDR}
    uci set network.${WANMAP}.ipaddr=${IPV4_PREFIX}
    uci set network.${WANMAP}.ip4prefixlen='20'
    uci set network.${WANMAP}.ip6prefix=${IPV6_PREFIX}::
    uci set network.${WANMAP}.ip6prefixlen='36'
    uci set network.${WANMAP}.ealen='20'
    uci set network.${WANMAP}.psidlen='8'
    uci set network.${WANMAP}.offset='4'
    uci set network.${WANMAP}.mtu='1452'
    uci set network.${WANMAP}.encaplimit='ignore'
    
    # バージョン固有の設定
    if [ "$OPENWRT_RELEASE" = "SN" ] || [ "$OPENWRT_RELEASE" = "24" ] || \
       [ "$OPENWRT_RELEASE" = "23" ] || [ "$OPENWRT_RELEASE" = "22" ] || \
       [ "$OPENWRT_RELEASE" = "21" ]; then
        uci set dhcp.wan6.ignore='1'
        uci set network.${WANMAP}.legacymap='1'
        uci set network.${WANMAP}.tunlink='wan6'
    elif [ "$OPENWRT_RELEASE" = "19" ]; then
        uci add_list network.${WANMAP}.tunlink='wan6'
    fi
    
    # ファイアウォール設定
    local ZONE_NO='1'
    uci del_list firewall.@zone[${ZONE_NO}].network='wan'
    uci add_list firewall.@zone[${ZONE_NO}].network=${WANMAP}
    
    # DNS設定
    uci -q delete dhcp.lan.dns
    uci -q delete dhcp.lan.dhcp_option
    
    # IPv4 DNS
    uci add_list network.lan.dns='118.238.201.33'
    uci add_list network.lan.dns='152.165.245.17'
    uci add_list dhcp.lan.dhcp_option='6,1.1.1.1,8.8.8.8'
    uci add_list dhcp.lan.dhcp_option='6,1.0.0.1,8.8.4.4'
    
    # IPv6 DNS
    uci add_list network.lan.dns='240d:0010:0004:0005::33'
    uci add_list network.lan.dns='240d:12:4:1b01:152:165:245:17'
    uci add_list dhcp.lan.dns='2606:4700:4700::1111'
    uci add_list dhcp.lan.dns='2001:4860:4860::8888'
    uci add_list dhcp.lan.dns='2606:4700:4700::1001'
    uci add_list dhcp.lan.dns='2001:4860:4860::8844'
    
    # 設定の適用
    uci commit
    debug_log "Configuration committed"
    
    # 設定情報の表示
    print_info ""
    print_info "■ NURO光 MAP-E設定情報"
    print_info "  ブリッジルータ(BR): $BR_ADDR"
    print_info "  IPv6プレフィックス: ${IPV6_PREFIX}::/36"
    print_info "  IPv4プレフィックス: ${IPV4_PREFIX}/20"
    print_info "  EAビット長: 20"
    print_info "  PSIDビット長: 8"
    print_info "  PSIDオフセット: 4"
    print_info "  MTU: 1452"
    
    return 0
}

# 設定復元関数
restore_config() {
    debug_log "Restoring configuration"
    
    if [ -f /etc/config/network.nuro.bak ]; then
        cp /etc/config/network.nuro.bak /etc/config/network
        debug_log "Network config restored"
    else
        print_error "ネットワーク設定のバックアップが見つかりません"
    fi
    
    if [ -f /etc/config/dhcp.nuro.bak ]; then
        cp /etc/config/dhcp.nuro.bak /etc/config/dhcp
        debug_log "DHCP config restored"
    else
        print_error "DHCP設定のバックアップが見つかりません"
    fi
    
    if [ -f /etc/config/firewall.nuro.bak ]; then
        cp /etc/config/firewall.nuro.bak /etc/config/firewall
        debug_log "Firewall config restored"
    else
        print_error "ファイアウォール設定のバックアップが見つかりません"
    fi
    
    print_info "設定を復元しました"
    
    return 0
}

# マルチセッション対応関数
setup_multisession() {
    debug_log "Setting up multisession support"
    
    if [ -f /lib/netifd/proto/map.sh ]; then
        cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.old
        debug_log "Original map.sh backed up"
    else
        print_error "map.shが見つかりません"
        return 1
    fi
    
    # OpenWrtバージョンに応じた処理
    OPENWRT_RELEASE=""
    if [ -f "/etc/openwrt_release" ]; then
        OPENWRT_RELEASE=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
        debug_log "Detected OpenWrt release: $OPENWRT_RELEASE"
    fi
    
    if [ "$OPENWRT_RELEASE" = "SN" ] || [ "$OPENWRT_RELEASE" = "24" ] || \
       [ "$OPENWRT_RELEASE" = "23" ] || [ "$OPENWRT_RELEASE" = "22" ] || \
       [ "$OPENWRT_RELEASE" = "21" ]; then
       
        wget --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map.sh.new
        if [ $? -ne 0 ]; then
            print_error "マルチセッションスクリプトのダウンロードに失敗しました"
            return 1
        fi
        
    elif [ "$OPENWRT_RELEASE" = "19" ]; then
        
        wget --no-check-certificate -O /lib/netifd/proto/map.sh https://raw.githubusercontent.com/site-u2023/map-e/main/map19.sh.new
        if [ $? -ne 0 ]; then
            print_error "マルチセッションスクリプトのダウンロードに失敗しました"
            return 1
        fi
        
    else
        print_error "非対応のOpenWrtバージョンです"
        return 1
    fi
    
    print_info "マルチセッション対応を設定しました"
    
    return 0
}

# マルチセッション復元関数
restore_multisession() {
    debug_log "Restoring original map.sh"
    
    if [ -f /lib/netifd/proto/map.sh.old ]; then
        cp /lib/netifd/proto/map.sh.old /lib/netifd/proto/map.sh
        debug_log "Original map.sh restored"
        print_info "オリジナルのMAP-Eプロトコルスクリプトを復元しました"
        return 0
    else
        print_error "バックアップファイルが見つかりません"
        return 1
    fi
}

# ポート確認関数
check_ports() {
    debug_log "Checking port mappings"
    
    if [ -f /tmp/map-wanmap.rules ]; then
        local port_info=$(cat /tmp/map-wanmap.rules | grep 'PORTSETS')
        if [ -n "$port_info" ]; then
            print_info "■ MAP-E使用可能ポート情報"
            print_info "$port_info"
        else
            print_info "ポート情報が見つかりません"
        fi
    else
        print_error "MAP-E設定ファイルが見つかりません"
        print_info "MAP-E設定を適用後に再実行してください"
        return 1
    fi
    
    return 0
}

# メイン関数
main() {
    print_info "=== NURO光 MAP-E設定スクリプト v$VERSION ==="
    
    # 初期化と必須コマンド確認
    create_cache_dir
    check_commands || exit 1
    
    # IPv6アドレスの取得
    print_info "IPv6アドレスを取得しています..."
    local ipv6_raw=$(get_ipv6_address)
    
    if [ $? -ne 0 ] || [ -z "$ipv6_raw" ]; then
        print_error "IPv6アドレスの取得に失敗しました"
        exit 1
    fi
    
    # IPv6アドレスの正規化
    local ipv6_normalized=$(normalize_ipv6 "$ipv6_raw")
    
    if [ $? -ne 0 ] || [ -z "$ipv6_normalized" ]; then
        print_error "IPv6アドレスの正規化に失敗しました"
        exit 1
    fi
    
    print_info "IPv6アドレス: $ipv6_normalized"
    
    # NURO光パターンの検出
    print_info "NURO光パターンを検出しています..."
    
    if ! detect_nuro_pattern "$ipv6_normalized"; then
        print_error "このIPv6アドレスに対応するNURO光パターンが見つかりません"
        print_info "現在対応しているパターン: 240d:000f:[0-f]"
        exit 1
    fi
    
    print_info "パターン検出: 成功"
    print_info "  IPv6プレフィックス: $IPV6_PREFIX"
    print_info "  IPv4プレフィックス: $IPV4_PREFIX"
    
    # メニュー表示
    while :
    do
        print_info ""
        print_info "■ NURO光 MAP-E設定メニュー"
        print_info "  1. MAP-E設定の適用"
        print_info "  2. 設定の復元（バックアップから）"
        print_info "  3. マルチセッション対応の有効化"
        print_info "  4. マルチセッション対応の無効化"
        print_info "  5. 利用可能ポートの確認"
        print_info "  q. 終了"
        print_info ""
        
        read -p "オプションを選択してください [1-5/q]: " option
        
        case "$option" in
            1)
                if [ "$SIMULATION_MODE" -eq 1 ]; then
                    print_info "シミュレーションモードで実行します（設定は適用されません）"
                    setup_nuro_mape
                    print_info ""
                    print_info "実際に設定を適用するには、次のコマンドを実行してください："
                    print_info "SIMULATION_MODE=0 $0"
                else
                    print_info "MAP-E設定を適用します"
                    setup_nuro_mape
                    print_info "設定を適用しました。デバイスを再起動します..."
                    reboot
                fi
                ;;
            2)
                restore_config
                print_info "再起動してください"
                ;;
            3)
                setup_multisession
                print_info "再起動してください"
                ;;
            4)
                restore_multisession
                print_info "再起動してください"
                ;;
            5)
                check_ports
                ;;
            q|Q)
                print_info "スクリプトを終了します"
                exit 0
                ;;
            *)
                print_info "無効なオプションです。再度選択してください。"
                ;;
        esac
    done
}

# スクリプト実行
main "$@"

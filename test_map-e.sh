#!/bin/bash

# 変数定義
rfc=true  # RFCの設定を有効にする場合
psid=100  # PSIDの設定
offset=0   # オフセット設定
ip6prefixlen=38  # IPv6プレフィックス長
psidlen=16  # PSIDの長さ
octet=(192 168 1 1)  # 例としてのIPv4オクテット
hextet=()  # ヘクステット配列

# RFCに基づく設定
if $rfc; then
  hextet[4]=0
  hextet[5]=$(( ( ${octet[0]} << 8  ) | ${octet[1]} ))
  hextet[6]=$(( ( ${octet[2]} << 8  ) | ${octet[3]} ))
  hextet[7]=$psid
else
  hextet[4]=${octet[0]}
  hextet[5]=$(( ${octet[1]} << 8 | ${octet[2]} ))
  hextet[6]=$(( ${octet[3]} << 8  ))
  hextet[7]=$(( $psid << 8 ))
fi

# ヘクステットを16進数で変換
declare -a ce
for i in 0 1 2 3; do
  ce[$i]=$(printf %x ${hextet[$i]})
done

# プレフィックスの計算
ealen=$(( 56 - $ip6prefixlen ))
ip4prefixlen=$(( 32 - (ealen - psidlen) ))

declare -a hextet2
if [ $ip6prefixlen -eq 38 ]; then
  hextet2[0]=${hextet[0]}
  hextet2[1]=${hextet[1]}
  hextet2[2]=$(( ${hextet[2]} & 0xfc00))
elif [ $ip6prefixlen -eq 31 ]; then
  hextet2[0]=${hextet[0]}
  hextet2[1]=$(( ${hextet[1]} & 0xfffe  ))
fi

# プレフィックスの16進数変換
declare -a ip6prefix
for i in 0 1 2; do
  ip6prefix[$i]=$(printf %x ${hextet2[$i]})
done

# プレフィックスに基づくpeeraddr設定
prefix31_hex=$(printf 0x%x $prefix31)
if [[ $prefix31_hex -ge 0x24047a80 ]] && [[ $prefix31_hex -lt 0x24047a84 ]]; then
  peeraddr="2001:260:700:1::1:275"
elif [[ $prefix31_hex -ge 0x24047a84 ]] && [[ $prefix31_hex -lt 0x24047a88 ]]; then
  peeraddr="2001:260:700:1::1:276"
# 追加の条件処理...
else
  peeraddr=""
fi

# UCI設定部分
uci set network.wan.auto='0'
uci set dhcp.lan.ra='relay'
uci set dhcp.lan.dhcpv6='relay'
uci set dhcp.lan.ndp='relay'
uci set dhcp.lan.force='1'
uci set dhcp.wan6=dhcp
uci set dhcp.wan6.master='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'
uci set dhcp.wan6.ndp='relay'

uci set network.wan6.proto='dhcpv6'
uci set network.wan6.reqaddress='try'
uci set network.wan6.reqprefix='auto'
uci set network.wan6.ip6prefix=${CE}::/64

WANMAPE='wanmape'
uci set network.${WANMAPE}=interface
uci set network.${WANMAPE}.proto='map'
uci set network.${WANMAPE}.maptype='map-e'
uci set network.${WANMAPE}.peeraddr=${peeraddr}
uci set network.${WANMAPE}.ipaddr=${ip4a}
uci set network.${WANMAPE}.ip4prefixlen=${ip4prefixlen}
uci set network.${WANMAPE}.ip6prefix=${ip6pfx}::

uci commit

echo -e "設定が完了しました。"

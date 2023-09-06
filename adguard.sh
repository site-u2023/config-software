#! /bin/sh

cp /etc/config/network /etc/config/network.adguard.bak
cp /etc/config/dhcp /etc/config/dhcp.adguard.bak
cp /etc/config/firewall /etc/config/firewall.adguard.bak

UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
opkg install adguardhome
service adguardhome enable
service adguardhome start
NET_ADDR=$(/sbin/ip -o -4 addr list br-lan | awk 'NR==1{ split($4, ip_addr, "/"); print ip_addr[1] }')
NET_ADDR6=$(/sbin/ip -o -6 addr list br-lan scope global | awk 'NR==1{ split($4, ip_addr, "/"); print ip_addr[1] }')
echo "Router IPv4 : ""${NET_ADDR}"
echo "Router IPv6 : ""${NET_ADDR6}"
uci set dhcp.@dnsmasq[0].noresolv="0"
uci set dhcp.@dnsmasq[0].cachesize="1000"
uci set dhcp.@dnsmasq[0].rebind_protection='0'
uci set dhcp.@dnsmasq[0].port="54"
uci -q delete dhcp.@dnsmasq[0].server
uci add_list dhcp.@dnsmasq[0].server="${NET_ADDR}"
uci -q delete dhcp.lan.dhcp_option
uci -q delete dhcp.lan.dns
uci add_list dhcp.lan.dhcp_option='6,'"${NET_ADDR}" 
uci add_list dhcp.lan.dhcp_option='3,'"${NET_ADDR}"
for OUTPUT in $(ip -o -6 addr list br-lan scope global | awk '{ split($4, ip_addr, "/"); print ip_addr[1] }')
do
	echo "Adding $OUTPUT to IPV6 DNS"
	uci add_list dhcp.lan.dns=$OUTPUT
done
uci commit dhcp
/etc/init.d/dnsmasq restart
# DNSインターセプト@IPTables(ファイアウォール3)
# IPV4
uci set firewall.adguardhome_dns_53='redirect'
uci set firewall.adguardhome_dns_53.src='lan'
uci set firewall.adguardhome_dns_53.proto='tcp udp'
uci set firewall.adguardhome_dns_53.src_dport='53'
uci set firewall.adguardhome_dns_53.target='DNAT'
uci set firewall.adguardhome_dns_53.name='Adguard Home'
uci set firewall.adguardhome_dns_53.dest='lan'
uci set firewall.adguardhome_dns_53.dest_port='53'
# IPV6
uci set firewall.adguardhome_dns_53.family="any"
uci commit firewall
/etc/init.d/firewall restart

cat << 'EOF' > /etc/adguardhome.yaml
http:
  address: 0.0.0.0:3000
  session_ttl: 720h
users:
  - name: root
    password: PASSWD
auth_attempts: 5
block_auth_min: 15
http_proxy: ""
language: ""
theme: auto
debug_pprof: false
dns:
  bind_hosts:
    - 0.0.0.0
  port: 53
  anonymize_client_ip: false
  protection_enabled: true
  blocking_mode: default
  blocking_ipv4: ""
  blocking_ipv6: ""
  blocked_response_ttl: 10
  protection_disabled_until: null
  parental_block_host: family-block.dns.adguard.com
  safebrowsing_block_host: standard-block.dns.adguard.com
  ratelimit: 20
  ratelimit_whitelist: []
  refuse_any: true
  upstream_dns:
    - '# LAN domain intercept'
    - '[/lan/]127.0.0.1:54'
    - '[//]127.0.0.1:54'
    - '# DNS-over-QUIC'
    - quic://unfiltered.adguard-dns.com
    - '# DNS-over-TLS'
    - '# tls://1dot1dot1dot1.cloudflare-dns.com'
    - '# tls://dns.google'
  　- tls://unfiltered.adguard-dns.com
    - '# DNS-over-HTTPS(coercion HTTP/3)'
    - '# h3://dns.cloudflare.com/dns-query'
    - '# h3://dns.google/dns-query'
    - h3://unfiltered.adguard-dns.com/dns-query
    - '# DNS-over-HTTPS'
    - '# https://dns.cloudflare.com/dns-query'
    - '# https://dns.google/dns-query'
    - https://unfiltered.adguard-dns.com/dns-query
    - '# NTP service'
    - '[/jp.pool.ntp.org/]1.1.1.1'
    - '[/jp/pool.ntp.org/]1.0.0.1'
    - '[/jp.pool.ntp.org/]2606:4700:4700::1111'
    - '[/jp/pool.ntp.org/]2606:4700:4700::1001'
  upstream_dns_file: ""
  bootstrap_dns:
    - 1.1.1.1
    - 8.8.4.4
    - 1.0.0.1
    - 8.8.8.8
    - 2606:4700:4700::1111
    - 2001:4860:4860::8844
    - 2606:4700:4700::1001
    - 2001:4860:4860::8888
  all_servers: false
  fastest_addr: false
  fastest_timeout: 1s
  allowed_clients: []
  disallowed_clients: []
  blocked_hosts:
    - version.bind
    - id.server
    - hostname.bind
  trusted_proxies:
    - 127.0.0.0/8
    - ::1/128
  cache_size: 4194304
  cache_ttl_min: 0
  cache_ttl_max: 0
  cache_optimistic: false
  bogus_nxdomain: []
  aaaa_disabled: false
  enable_dnssec: false
  edns_client_subnet:
    custom_ip: ""
    enabled: false
    use_custom: false
  max_goroutines: 300
  handle_ddr: true
  ipset: []
  ipset_file: ""
  bootstrap_prefer_ipv6: false
  filtering_enabled: true
  filters_update_interval: 24
  parental_enabled: true
  safebrowsing_enabled: true
  safebrowsing_cache_size: 1048576
  safesearch_cache_size: 1048576
  parental_cache_size: 1048576
  cache_time: 30
  safe_search:
    enabled: true
    bing: true
    duckduckgo: true
    google: true
    pixabay: true
    yandex: true
    youtube: true
  rewrites: []
  blocked_services:
    schedule:
      time_zone: UTC
    ids:
      - 500px
      - 9gag
      - activision_blizzard
      - aliexpress
      - battle_net
      - bilibili
      - blizzard_entertainment
      - clubhouse
      - crunchyroll
      - dailymotion
      - deezer
      - disneyplus
      - douban
      - ebay
      - electronic_arts
      - epic_games
      - flickr
      - gog
      - hbomax
      - icloud_private_relay
      - imgur
      - iqiyi
      - kakaotalk
      - kik
      - lazada
      - leagueoflegends
      - linkedin
      - mail_ru
      - mastodon
      - minecraft
      - nintendo
      - nvidia
      - ok
      - onlyfans
      - origin
      - pinterest
      - playstation
      - qq
      - rakuten_viki
      - riot_games
      - roblox
      - rockstar_games
      - shopee
      - skype
      - snapchat
      - soundcloud
      - steam
      - telegram
      - tidal
      - tinder
      - twitch
      - ubisoft
      - valorant
      - viber
      - vimeo
      - vk
      - voot
      - wechat
      - weibo
      - xboxlive
      - zhihu
      - amazon
      - cloudflare
      - discord
      - facebook
      - hulu
      - instagram
      - line
      - netflix
      - reddit
      - spotify
      - tiktok
      - twitter
      - whatsapp
      - youtube
  upstream_timeout: 10s
  private_networks: []
  use_private_ptr_resolvers: true
  local_ptr_upstreams:
    - 192.168.1.1:54
  use_dns64: false
  dns64_prefixes: []
  serve_http3: false
  use_http3_upstreams: false
tls:
  enabled: false
  server_name: ""
  force_https: false
  port_https: 443
  port_dns_over_tls: 853
  port_dns_over_quic: 853
  port_dnscrypt: 0
  dnscrypt_config_file: ""
  allow_unencrypted_doh: false
  certificate_chain: ""
  private_key: ""
  certificate_path: ""
  private_key_path: ""
  strict_sni_check: false
querylog:
  ignored: []
  interval: 2160h
  size_memory: 1000
  enabled: true
  file_enabled: true
statistics:
  ignored: []
  interval: 24h
  enabled: true
filters:
  - enabled: true
    url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt
    name: AdGuard DNS filter
    id: 1
  - enabled: false
    url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt
    name: AdAway Default Blocklist
    id: 2
  - enabled: true
    url: https://280blocker.net/files/280blocker_domain_ag_202309.txt
    name: 280blocker
    id: 1693396666
whitelist_filters: []
user_rules:
  - ""
dhcp:
  enabled: false
  interface_name: ""
  local_domain_name: lan
  dhcpv4:
    gateway_ip: ""
    subnet_mask: ""
    range_start: ""
    range_end: ""
    lease_duration: 86400
    icmp_timeout_msec: 1000
    options: []
  dhcpv6:
    range_start: ""
    lease_duration: 86400
    ra_slaac_only: false
    ra_allow_slaac: false
clients:
  runtime_sources:
    whois: true
    arp: true
    rdns: true
    dhcp: true
    hosts: true
  persistent: []
log_file: ""
log_max_backups: 0
log_max_size: 100
log_max_age: 3
log_compress: false
log_localtime: false
verbose: false
os:
  group: ""
  user: ""
  rlimit_nofile: 0
schema_version: 23
EOF

service adguardhome restart

#! /bin/sh

opkg update
opkg install https-dns-proxy
opkg install luci-app-https-dns-proxy
opkg install luci-i18n-https-dns-proxy-ja

while uci -q delete https-dns-proxy.@https-dns-proxy[0]; do :; done
uci set https-dns-proxy.dns="https-dns-proxy"
uci set https-dns-proxy.dns.bootstrap_dns="1.1.1.1,1.0.0.1"
uci set https-dns-proxy.dns.resolver_url="https://cloudflare-dns.com/dns-query"
uci set https-dns-proxy.dns.listen_addr="127.0.0.1"
uci set https-dns-proxy.dns.listen_port="5053"

uci commit https-dns-proxy
/etc/init.d/rpcd restart
/etc/init.d/https-dns-proxy restart

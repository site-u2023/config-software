#! /bin/sh

uci set adblock-fast.config.enabled=1
uci set adblock-fast.file_url=file_url
uci set adblock-fast.file_url.url='https://raw.githubusercontent.com/tofukko/filter/master/Adblock_Plus_list.txt'
uci set adblock-fast.file_url.action='block'
uci set adblock-fast.file_url.enabled='1'
uci commit adblock-fast
service adblock-fast enable
service adblock-fast start

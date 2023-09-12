#! /bin/sh

uci set adblock-fast.config.enabled=1
uci set adblock-fast.@file_url[14]=file_url
uci set adblock-fast.@file_url[14].action='block'
uci set adblock-fast.@file_url[14].url='https://raw.githubusercontent.com/tofukko/filter/master/Adblock_Plus_list.txt'

uci commit adblock-fast

/etc/init.d/adblock-fast start

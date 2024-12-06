#! /bin/sh


opkg install adblock
opkg install luci-app-adblock
opkg install luci-i18n-adblock-ja
opkg install tcpdump-mini

uci set adblock.global.adb_backupdir="/etc/adblock"

cp /etc/adblock/adblock.sources.gz /etc/adblock/adblock.sources.tofu.gz
gunzip /etc/adblock/adblock.sources.tofu.gz

sed -i -e '$d' /etc/adblock/adblock.sources.tofu
sed -i -e '$d' /etc/adblock/adblock.sources.tofu
cat <<"EOF" >> /etc/adblock/adblock.sources.tofu
                },
                "tofu": {
                                "url": "https://raw.githubusercontent.com/tofukko/filter/master/Adblock_Plus_list.txt",
                                "rule": "BEGIN{FS=\"[|^]\"}/^\\|\\|([[:alnum:]_-]{1,63}\\.)+[[:alpha:]]+\\^(\\$third-party)?$/{print tolower($3)}",
                                "size": "XL",
                                "focus": "tofu",
                                "descurl": "https://github.com/tofukko/filter"
                }
}
EOF

gzip /etc/adblock/adblock.sources.tofu

uci set adblock.global.adb_srcarc="/etc/adblock/adblock.sources.tofu.gz"
uci set adblock.global.adb_enabled="1"
uci set adblock.global.adb_backup="1"
uci set adblock.global.adb_backupdir="/etc/adblock"
uci set adblock.global.adb_backup_mode="1"
uci add_list adblock.global.adb_sources='tofu'

uci commit adblock
/etc/init.d/adblock enable
/etc/init.d/adblock start

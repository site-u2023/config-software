#!/bin/sh

echo -e " \033[1;31mフラッシュ後にインストールしたパッケージ\033[0;39m"

FLASH_TIME="$(awk '
$1 == "Installed-Time:" && ($2 < OLDEST || OLDEST=="") {
  OLDEST=$2
}
END {
  print OLDEST
}
' /usr/lib/opkg/status)"

awk -v FT="$FLASH_TIME" '
$1 == "Package:" {

  PKG=$2
  USR=""
}
$1 == "Status:" && $3 ~ "user" {
  USR=1
}
$1 == "Installed-Time:" && USR && $2 != FT {
  print PKG
}
' /usr/lib/opkg/status | sort

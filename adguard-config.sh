#! /bin/sh
. /lib/functions/network.sh
NET_IF="lan"
network_flush_cache
network_get_ipaddr NET_ADDR "${NET_IF}"

function _func_AdGuard {
while :
do
if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
  echo -e " \033[1;37mAdGuardが既にインストールされています\033[0;39m"
fi
  echo -e " \033[1;33mJapanese notation\033[0;39m"
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[c]: AdGuard HOMEの設定とインストール（カスタムフィルターアドイン）\033[0;39m"
  echo -e " \033[1;33m[s]: 管理用ウェブインターフェイス設定（ポート・ユーザー名・パスワードのみ）\033[0;39m"
  echo -e " \033[1;32m[b]: AdGuard HOMEのリムーブと以前の設定に復元\033[0;39m"
  echo -e " \033[1;37m[q]: 終了\033[0;39m"
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " キーを選択して下さい [c/s/b or q]: " num
  case "${num}" in
    "c" ) 
{
UPDATE="/tmp/opkg-lists/openwrt_telephony"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
ADGUARD_VERSION=`opkg info adguardhome | grep Version | awk '{ print $2 }'`
ADGUARD_SIZE=$((`opkg info adguardhome | grep Size | awk '{ print $2 }'`/1024))
echo -e " \033[1;37m利用可能メモリー容量: ${AVAILABLE_MEMORY}KB\033[0;39m"
  if [ -z "${AVAILABLE_FLASH}" ]; then
echo -e " \033[1;37m利用可能フラッシュ容量: /overlayfs:/overlayがありません\033[0;39m"
AVAILABLE_FLASH=${AVAILABLE_MEMORY}
  else
echo -e " \033[1;37m利用可能フラッシュ容量: ${AVAILABLE_FLASH}KB\033[0;39m"
  fi
echo -e " \033[1;37mインストール容量: ${ADGUARD_SIZE}KB\033[0;39m"
  if [ "${AVAILABLE_FLASH}" -gt ${ADGUARD_SIZE} ]; then
   echo -e " \033[1;37mメモリー容量推奨値: 51200KB\033[0;39m"
   echo -e " \033[1;37mフラッシュ容量推奨値: 102400KB\033[0;39m"
   echo -e " \033[1;37mインストール可能です\033[0;39m"
  else
   read -p " フラッシュ容量が足りない為終了します"
   exit
  fi
}
          AD_INST='ad_inst'
          _func_AdGuard_Confirm ;;
    "s" ) _func_AdGuard_Admin ;;        
    "b" ) _func_AdGuard_Before ;;
    "q" ) exit ;;
  esac
done
}

function _func_AdGuard_Confirm {
UPDATE="/tmp/opkg-lists/openwrt_telephony"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
while :
do
  echo -e " \033[1;35mAdGuard HOMEの設定とインストールを開始します\033[0;39m"
  echo -e " \033[1;32m管理用ウェブインターフェイスポート番号入力\033[0;39m"
  echo -e " \033[1;32m管理用ウェブインターフェイスユーザー名入力\033[0;39m"
  echo -e " \033[1;32m管理用ウェブインターフェイスパスワード入力\033[0;39m"
  echo -e " \033[1;32mインストール: adguardhome $((`opkg info adguardhome | grep Size | awk '{ print $2 }'`/1024))KB Version ${ADGUARD_VERSION}\033[0;39m"
  echo -e " \033[1;32mインストール: htpasswd: 63.90KB\033[0;39m"
  echo -e " \033[1;32mインストール: libaprutil $((`opkg info libaprutil | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mインストール: libapr $((`opkg info libapr | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mインストール: libexpat $((`opkg info libexpat | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mアドイン: AdGuard Japanese filter（有効）\033[0;39m"
  echo -e " \033[1;32mアドイン: 280blocker（無効）\033[0;39m"
  echo -e " \033[1;32mアドイン: 豆腐フィルタ（無効）\033[0;39m"
  read -p " 設定値の入力を開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdGuard_PORT ;;
    "n" ) break ;;
  esac
done
}

function _func_AdGuard_Admin {
while :
do
  echo -e " \033[1;35mAdGuard HOMEの設定とインストールを開始します\033[0;39m"
  echo -e " \033[1;32m管理用ウェブインターフェイスポート番号入力\033[0;39m"
  echo -e " \033[1;32m管理用ウェブインターフェイスユーザー名入力\033[0;39m"
  echo -e " \033[1;32m管理用ウェブインターフェイスパスワード入力\033[0;39m"
  read -p " 設定値の入力を開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdGuard_PORT ;;
    "n" ) break ;;
  esac
done
Admin='1'
}

function _func_AdGuard_PORT {
while :
do
  echo -e "\033[1;37m AdGuard HOME管理用ウェブインターフェイスのポート番号を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: 8000\033[0;39m"
  read -p " ポート番号: " input_str_PORT
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_USER ;;
    "n" ) _func_AdGuard_PORT ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_USER {
while :
do
  echo -e "\033[1;37m AdGuard HOME管理用ウェブインターフェイスのユーザー名を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: root\033[0;39m"
  read -p " ユーザー名: " input_str_USER
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_PASSWD ;;
    "n" ) _func_AdGuard_USER ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_PASSWD {
while :
do
  echo -e " \033[1;37mAdGuard HOME管理用ウェブインターフェイスのパスワードを入力して下さい\033[0;39m"
  echo -e " \033[1;33m例: password\033[0;39m"
  read -p " パスワード: " input_str_PASSWD
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_Confirm2 ;;
    "n" ) _func_AdGuard_PASSWD ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_Confirm2 {
while :
do
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  echo -e " \033[1;32mポート番号: ${input_str_PORT}\033[0;39m"
  echo -e " \033[1;32mユーザー名: ${input_str_USER}\033[0;39m"
  echo -e " \033[1;32mパスワード: ${input_str_PASSWD}\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  echo -e " \033[1;32m管理用ウェブインターフェイス: http://${NET_ADDR}:${input_str_PORT}\033[0;39m"
  read -p " これで宜しければ管理用ウェブインターフェイスの設定を開始します [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_SET ;;
    "n" ) _func_AdGuard_PORT ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_SET {
UPDATE="/tmp/opkg-lists/openwrt_telephony"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
service adguardhome stop
fi
wget --no-check-certificate -O /etc/adguardhome.yaml https://raw.githubusercontent.com/site-u2023/config-software/main/adguardhome.yaml
DISTRIB_ARCH=`cat /etc/openwrt_release | grep DISTRIB_ARCH  | cut -c 15-17`
if  [ "${DISTRIB_ARCH}" = "x86" ] ; then
echo -e " \033[1;37mArchitecture: x86_64\033[0;39m"
wget --no-check-certificate -O /usr/bin/htpasswd https://github.com/site-u2023/config-software/raw/main/htpasswd-vm
 else
wget --no-check-certificate -O /usr/bin/htpasswd https://github.com/site-u2023/config-software/raw/main/htpasswd
fi
chmod +x /usr/bin/htpasswd
opkg install --nodeps libaprutil
opkg install --nodeps libapr
opkg install --nodeps libexpat
sed -i "/\  address:/c \  address: 0.0.0.0:${input_str_PORT}" /etc/adguardhome.yaml
sed -i "5c \  - name: ${input_str_USER}" /etc/adguardhome.yaml
Bcrypt_PASSWD=`htpasswd -B -n -b ${input_str_USER} ${input_str_PASSWD}`
sed -i "6c \    password: ${Bcrypt_PASSWD#${input_str_USER}:}" /etc/adguardhome.yaml
sed -i "/280blocker_domain_ag_/c \    url: https://280blocker.net/files/280blocker_domain_ag_`date '+%Y%m01' | awk '{print substr($0, 1, 6)}'`.txt" /etc/adguardhome.yaml
if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
service adguardhome start
fi
echo -e " \033[1;32m管理用ウェブインターフェイスの設定が完了しました\033[0;39m"
if [ ${AD_INST} = "ad_inst" ]; then
wget --no-check-certificate -O /etc/config-software/adguard.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard.sh
sh /etc/config-software/adguard.sh
echo "00 03 01 * * sed -i "service adguardhome stop" /etc/adguardhome.yaml" >> /etc/crontabs/root
echo "01 03 01 * * sed -i "/280blocker_domain_ag_/c \    url: https://280blocker.net/files/280blocker_domain_ag_`date '+%Y%m01' | awk '{print substr($0, 1, 6)}'`.txt" /etc/adguardhome.yaml" >> /etc/crontabs/root
echo "02 03 01 * * sed -i "service adguardhome start" /etc/adguardhome.yaml" >> /etc/crontabs/root
echo -e " \033[1;32mインストールと設定が完了しました\033[0;39m"
echo -e " \033[1;32m管理用ウェブインターフェイス: http://${NET_ADDR}:${input_str_PORT}\033[0;39m"
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
else
echo -e " \033[1;32m管理用ウェブインターフェイス: http://${NET_ADDR}:${input_str_PORT}\033[0;39m"
read -p " 何かキーを押してデバイスを再起動して下さい"
exit
fi
}

function _func_AdGuard_Before {
while :
do
  echo -e " \033[1;37mAdGuard HOMEをリムーブして以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mリムーブ: adguardhome\033[0;39m"
  echo -e " \033[1;37mリムーブ: htpasswd\033[0;39m"
  echo -e " \033[1;37mリムーブ: libaprutil\033[0;39m"
  echo -e " \033[1;37mリムーブ: libapr\033[0;39m"
  echo -e " \033[1;37mリムーブ: libexpat\033[0;39m"
  read -p " 本当に宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_Restoration ;;
    "n" ) _func_AdGuard ;;
    "r" ) _func_AdGuard ;;
  esac
done
}

function _func_AdGuard_Restoration {
service adguardhome stop
service adguardhome disable
opkg remove adguardhome
rm /usr/bin/htpasswd
opkg remove --nodeps libaprutil
opkg remove --nodeps libapr
opkg remove --nodeps libexpat
cp /etc/config/network.adguard.bak /etc/config/network
rm /etc/config/network.adguard.bak
cp /etc/config/dhcp.adguard.bak /etc/config/dhcp
rm /etc/config/dhcp.adguard.bak
cp /etc/config/firewall.adguard.bak /etc/config/firewall
rm /etc/config/firewall.adguard.bak
rm /etc/config-software/adguard-config.sh
rm /etc/config-software/adguard.sh
echo -e " \033[1;32mリムーブと以前の設定に復元が完了しました\033[0;39m"
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}


if [ "adblock" = "`opkg list-installed adblock | awk '{ print $1 }'`" ]; then
 read -p " AdBlockがインストールされている為終了します"
 exit
fi
if [ "adblock-fast" = "`opkg list-installed adblock-fast | awk '{ print $1 }'`" ]; then
 read -p " AdBlock-fastがインストールされている為終了します"
 exit
fi
if [ "https-dns-proxy" = "`opkg list-installed https-dns-proxy | awk '{ print $1 }'`" ]; then
 read -p " https-dns-proxyがインストールされている為終了します"
 exit
fi
if [ "stubby" = "`opkg list-installed stubby | awk '{ print $1 }'`" ]; then
 read -p " DNS over TLS (DoT) がインストールされている為終了します"
 exit
fi
OPENWRT_RELEAS=`cat /etc/banner | grep OpenWrt | awk '{ print $2 }' | cut -c 1-2`
if [ "${OPENWRT_RELEAS}" = "23" ] || [ "${OPENWRT_RELEAS}" = "22" ] || [ "${OPENWRT_RELEAS}" = "21" ] || [ "${OPENWRT_RELEAS}" = "SN" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
  _func_AdGuard
 else
 read -p " バージョンが違うため終了します"
 exit
fi

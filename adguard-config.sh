#! /bin/sh
. /lib/functions/network.sh
NET_IF="lan"
network_flush_cache
network_get_ipaddr NET_ADDR "${NET_IF}"

function _func_AdGuard
while :
do
if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
  echo -e " \033[1;37mAdGuardが既にインストールされています\033[0;39m"
fi
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[c]\033[0;39m": AdGuardの設定とインストール（280blockerアドイン）
  echo -e " \033[1;33m[b]\033[0;39m": AdGuardのリムーブと以前の設定に復元
  echo -e " \033[1;37m[q]\033[0;39m": 終了    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " キーを選択して下さい [c/b or q]: " num
  case "${num}" in
    "c" ) 
{
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
ADGUARD_VERSION=`opkg info adguardhome | grep Version | awk '{ print $2 }'`
ADGUARD_SIZE=$((`opkg info adguardhome | grep Size | awk '{ print $2 }'`/1024))
echo -e " \033[1;37m利用可能メモリー容量: ${AVAILABLE_MEMORY}KB\033[0;39m"
echo -e " \033[1;37m利用可能フラッシュ容量: ${AVAILABLE_FLASH}KB\033[0;39m"
echo -e " \033[1;37mインストール容量: ${ADGUARD_SIZE}KB\033[0;39m"
  if [ "${AVAILABLE_FLASH}" -gt ${ADGUARD_SIZE} ]; then
   echo -e " \033[1;37mインストール可能です\033[0;39m"
  else
   read -p " フラッシュ容量が足りない為終了します"
   exit
  fi
}
          _func_AdGuard_Confirm ;;
    "b" ) _func_AdGuard_Before ;;
    "q" ) exit ;;
  esac
done

function _func_AdGuard_Confirm
while :
do
  echo -e " \033[1;35mAdGuardの設定とインストールを開始します\033[0;39m"
  echo -e " \033[1;37m管理用ウェブインターフェイスポート番号入力\033[0;39m"
  echo -e " \033[1;37m管理用ウェブインターフェイスユーザー名入力\033[0;39m"
  echo -e " \033[1;37m管理用ウェブインターフェイスパスワード入力\033[0;39m"
  echo -e " \033[1;37mインストール: adguardhome ${ADGUARD_VERSION} ${ADGUARD_SIZE}kB\033[0;39m"
  echo -e " \033[1;37mインストール: htpasswd 63.90kB\033[0;39m"
  echo -e " \033[1;37mインストール: libaprutil 75.04kB\033[0;39m"
  echo -e " \033[1;37mインストール: libapr 92.12kB\033[0;39m"
  echo -e " \033[1;37mインストール: libexpat 45.10kB\033[0;39m"
  read -p " 設定値の入力を開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdGuard_PORT ;;
    "n" ) break ;;
  esac
done

function _func_AdGuard_PORT
while :
do
  echo -e "\033[1;37m AdGuard管理用ウェブインターフェイスのポート番号を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: 8000\033[0;39m"
  read -p " ポート番号: " input_str_PORT
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_USER ;;
    "n" ) _func_AdGuard_PORT ;;
    "r" ) _func_AdGuard ;;
  esac
done

function _func_AdGuard_USER
while :
do
  echo -e "\033[1;37m AdGuard管理用ウェブインターフェイスのユーザー名を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: root\033[0;39m"
  read -p " ユーザー名: " input_str_USER
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_PASSWD ;;
    "n" ) _func_AdGuard_USER ;;
    "r" ) _func_AdGuard ;;
  esac
done

function _func_AdGuard_PASSWD
while :
do
  echo -e " \033[1;37mAdGuard管理用ウェブインターフェイスのパスワードを入力して下さい\033[0;39m"
  echo -e " \033[1;33m例: password\033[0;39m"
  read -p " パスワード: " input_str_PASSWD
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_Confirm2 ;;
    "n" ) _func_AdGuard_PASSWD ;;
    "r" ) _func_AdGuard ;;
  esac
done

function _func_AdGuard_Confirm2
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

function _func_AdGuard_SET
{
wget --no-check-certificate -O /etc/adguardhome.yaml https://raw.githubusercontent.com/site-u2023/config-software/main/adguardhome.yaml
wget --no-check-certificate -O /usr/bin/htpasswd https://github.com/site-u2023/config-software/raw/main/htpasswd
chmod +x /usr/bin/htpasswd
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
opkg install --nodeps libaprutil
opkg install --nodeps libapr
opkg install --nodeps libexpat
sed -i "2c \  address: 0.0.0.0:${input_str_PORT}" /etc/adguardhome.yaml
sed -i "5c \  - name: ${input_str_USER}" /etc/adguardhome.yaml
Bcrypt_PASSWD=`htpasswd -B -n -b ${input_str_USER} ${input_str_PASSWD}`
sed -i "6c \    password: ${Bcrypt_PASSWD#${input_str_USER}:}" /etc/adguardhome.yaml
sed -i "/280blocker_domain_ag_/c \    url: https://280blocker.net/files/280blocker_domain_ag_`date '+%Y%m01' | awk '{print substr($0, 1, 6)}'`.txt" /etc/adguardhome.yaml
echo -e " \033[1;32m管理用ウェブインターフェイスの設定が完了しました\033[0;39m"
read -p " 何かキーを押してインストールを開始して下さい"
wget --no-check-certificate -O /etc/config-software/adguard.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard.sh
sh /etc/config-software/adguard.sh
echo "00 2 3 * * sed -i "/280blocker_domain_ag_/c \    url: https://280blocker.net/files/280blocker_domain_ag_`date '+%Y%m01' | awk '{print substr($0, 1, 6)}'`.txt" /etc/adguardhome.yaml" >> /etc/crontabs/root
echo -e " \033[1;32mインストールと設定が完了しました\033[0;39m
echo -e " \033[1;32m管理用ウェブインターフェイス: http://${NET_ADDR}:${input_str_PORT}\033[0;39m"
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
fi
}

function _func_AdGuard_Before
while :
do
  echo -e " \033[1;37mAdGuardをリムーブして以前の設定に復元します\033[0;39m"
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

function _func_AdGuard_Restoration
{
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
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
 _func_AdGuard
else
 read -p " バージョンが違うため終了します"
 exit
fi

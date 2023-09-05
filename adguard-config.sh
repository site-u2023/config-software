#! /bin/sh

function _func_AdGuard
while :
do
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[c]\033[0;39m": AdGuardの容量判定を実行します
  echo -e " \033[1;31m[b]\033[0;39m": AdGuardをリムーブして以前の設定に復元します
  echo -e " \033[1;33m[q]\033[0;39m": 終了    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [c/b or q]: " num
  case "${num}" in
    "c" ) 
{
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
ADGUARD_SIZE=$((`opkg info adguardhome | grep Size | awk '{ print $2 }'`/1024))
echo -e " \033[1;37m利用可能メモリー容量: ${AVAILABLE_MEMORY}KB\033[0;39m"
echo -e " \033[1;37m利用可能フラッシュ容量: ${AVAILABLE_FLASH}KB\033[0;39m"
echo -e " \033[1;37mインストール容量: ${ADGUARD_SIZE}KB\033[0;39m"
  if [ "${AVAILABLE_FLASH}" -gt ${ADGUARD_SIZE} ]; then
   echo -e " \033[1;37mインストール可能です\033[0;39m"
   read -p " 何かキーを押して下さい"
  else
   read -p " フラッシュ容量が足りないため終了します"
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
  echo -e " \033[1;35mAdGuardのインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdGuard_PORT ;;
    "n" ) break ;;
  esac
done

function _func_AdGuard_PORT
while :
do
  echo -e "\033[1;37m AdGuardのポート番号を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: 3000\033[0;39m"
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
  echo -e "\033[1;37m AdGuardのユーザー名を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: admin\033[0;39m"
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
  echo -e "\033[1;37m AdGuardのパスワードを入力して下さい\033[0;39m"
  echo -e "\033[1;33m ※htpasswdで生成したBcryptの暗号ハッシュ\033[0;39m"
  echo -e '\033[1;33m 例: $2y$05$5k0xQSF.ioRhGmleXF1SeOW59LE6JzZoz/Ob1ukV7TbhqN2xRv5rK\033[0;39m'
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
  echo -e " \033[1;34mAdGuard ----------------------------------------------\033[0;39m"
  echo -e " \033[1;32mポート番号: ${input_str_PORT}\033[0;39m"
  echo -e " \033[1;32mユーザー名: ${input_str_USER}\033[0;39m"
  echo -e " \033[1;32mパスワード: ${input_str_PASSWD}\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " これで宜しければ設定を開始します [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdGuard_SET ;;
    "n" ) _func_AdGuard_PORT ;;
    "r" ) _func_AdGuard ;;
  esac
done

function _func_AdGuard_SET
{
wget --no-check-certificate -O /etc/config-software/adguard.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard.sh
sed -i -e "s/address: 0.0.0.0:3000/address: 0.0.0.0:${input_str_PORT}/g" /etc/config-software/adguard.sh
sed -i -e "s/name: root/name: ${input_str_USER}/g" /etc/config-software/adguard.sh
sed -i -e "s|password: PASSWD|password: ${input_str_PASSWD}|g" /etc/config-software/adguard.sh
sed -i -e "s/280blocker_domain_ag_202309/280blocker_domain_ag_`date '+%Y%m01' | awk '{print substr($0, 1, 6)}'`/g" /etc/config-software/adguard.sh
sh /etc/config-software/adguard.sh
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

function _func_AdGuard_Before
while :
do
  echo -e " \033[1;37mAdGuardの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mパッケージ: adguardhomeをリムーブします\033[0;39m"
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
cp /etc/config/network.adguard.bak /etc/config/network
rm /etc/config/network.adguard.bak
cp /etc/config/dhcp.adguard.bak /etc/config/dhcp
rm /etc/config/dhcp.adguard.bak
cp /etc/config/firewall.adguard.bak /etc/config/firewall
rm /etc/config/firewall.adguard.bak
rm /etc/config-software/adguard-config.sh
rm /etc/config-software/adguard.sh
read -p " 何かキーを押してデバイスを再起動してください"
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

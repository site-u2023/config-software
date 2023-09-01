#! /bin/sh

function _func_PORT
while :
do
  echo -e "\033[1;37m AdGuardのポート番号を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: 3000\033[0;39m"
  read -p " ポート番号: " input_str_PORT
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_USER ;;
    "n" ) _func_PORT ;;
    "r" ) break ;;
  esac
done

function _func_USER
while :
do
  echo -e "\033[1;37m AdGuardのユーザー名を入力して下さい\033[0;39m"
  echo -e "\033[1;33m 例: admin\033[0;39m"
  read -p " ユーザー名: " input_str_USER
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_PASSWD ;;
    "n" ) _func_USER ;;
    "r" ) break ;;
  esac
done

function _func_PASSWD
while :
do
  echo -e "\033[1;37m AdGuardのパスワードを入力して下さい\033[0;39m"
  echo -e "\033[1;33m ※htpasswdで生成したBcryptの暗号ハッシュ\033[0;39m"
  echo -e '\033[1;33m 例: $2y$05$5k0xQSF.ioRhGmleXF1SeOW59LE6JzZoz/Ob1ukV7TbhqN2xRv5rK\033[0;39m'
  read -p " パスワード: " input_str_PASSWD
  read -p " 宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_confirmation ;;
    "n" ) _func_PASSWD ;;
    "r" ) break ;;
  esac
done

function _func_confirmation
while :
do
  echo -e " \033[1;37mアクセスポイント ------------------------------------\033[0;39m"
  echo -e " \033[1;32mポート番号: ${input_str_PORT}\033[0;39m"
  echo -e " \033[1;32mユーザー名: ${input_str_USER}\033[0;39m"
  echo -e " \033[1;32mパスワード: ${input_str_PASSWD}\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " これで宜しければ設定を開始します [y/n or r]: " num
  case "${num}" in
    "y" ) _func_SET ;;
    "n" ) _func_USER ;;
    "r" ) break ;;
  esac
done

function _func_SET
{
wget --no-check-certificate -O /etc/config-software/adguard.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard.sh
sed -i -e "s/address: 0.0.0.0:3000/address: 0.0.0.0:${input_str_PORT}/g" /etc/config-software/adguard.sh
sed -i -e "s/name: root/name: ${input_str_USER}/g" /etc/config-software/adguard.sh
sed -i -e "s|password: PASSWD|password: ${input_str_PASSWD}|g" /etc/config-software/adguard.sh
sh /etc/config-software/adguard.sh
read -p " 何かキーを押してデバイスを再起動してください"
reboot
exit
}

while :
do
{
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
else
 read -p " バージョンが違うため終了します"
 exit
fi
}
{
AVAILABLE_MEMORY=`free | fgrep 'Mem:' | awk '{ print $4 }'`
AVAILABLE_FLASH=`df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }'`
echo -e " \033[1;37m利用可能メモリーサイズ: ${AVAILABLE_MEMORY}KB\033[0;39m"
echo -e " \033[1;37m利用可能フラッシュサイズ: ${AVAILABLE_FLASH}KB\033[0;39m"
}
  echo -e " \033[1;35mAdGuardのインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_PORT ;;
    "n" ) exit ;;
  esac
done

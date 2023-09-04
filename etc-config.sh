#! /bin/sh

function _func_IPERF3
while :
do
  echo -e " \033[1;34mIPERF3設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/iperf3.sh https://raw.githubusercontent.com/site-u2023/iperf/main/iperf3.sh
          sh /etc/config-software/iperf3.sh
          break ;;
    "n" ) break ;;
  esac
done

while :
do
  echo -e " \033[1;37metc -------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[1]\033[0;39m": IPERF3設定
  echo -e " \033[1;33m[2]\033[0;39m": 
  echo -e " \033[1;32m[3]\033[0;39m": 
  echo -e " \033[1;35m[4]\033[0;39m": 
  echo -e " \033[1;31m[5]\033[0;39m": 
  echo -e " \033[1;36m[6]\033[0;39m": 
  echo -e " \033[7;40m[q]\033[0;39m": 終了
  echo -e " \033[1;37m------------------------------------- August 27, 2023\033[0;39m"
  read -p " キーを選択してください [1/2/3/4/5/6 or q]: " num
  case "${num}" in
    "1" ) _func_IPERF3 ;;
    "2" ) exit ;;
    "3" ) exit ;;
    "4" ) exit ;;
    "5" ) exit ;;
    "6" ) exit ;;
    "q" ) exit ;;
  esac
 done

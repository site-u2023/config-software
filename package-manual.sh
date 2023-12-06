while :
do
  echo -e " \033[1;33mLanguage --------------------------------------------\033[0;39m"
  echo -e " \033[1;36m[e]: English\033[0;39m"
  echo -e " \033[1;31m[o]: Other\033[0;39m"
  echo -e " \033[1;33m[g]: Quit\033[0;39m"
  echo -e " \033[1;33m-----------------------------------------------------\033[0;39m"
  read -p " Press any key [e/o or q]: " num
  case "${num}" in
    "e" ) wget --no-check-certificate -O /etc/config-software/package-manual-e.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-manual-e.sh
          sh /etc/config-software/package-manual-e.sh ;;
    "o" ) wget --no-check-certificate -O /etc/config-software/package-manual-g.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-manual-g.sh
          sh /etc/config-software/package-manual-g.sh ;;
    "q" ) exit ;;
  esac
 done 

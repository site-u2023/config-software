while :
do
  echo -e " \033[1;33mPAuto package language -------------------------------\033[0;39m"
  echo -e " \033[1;36m[e]: English\033[0;39m"
  echo -e " \033[1;31m[o]: Other\033[0;39m"
  echo -e " \033[1;33m[q]: Quit\033[0;39m"
  echo -e " \033[1;33m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [e/o or q]: " num
  case "${num}" in
    "e" ) wget --no-check-certificate -O /etc/config-software/package-auto-e.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto-e-snapshot.sh
          sh /etc/config-software/package-auto-e.sh ;;
    "o" ) wget --no-check-certificate -O /etc/config-software/package-auto-g.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto-g-snapshot.sh
          sh /etc/config-software/package-auto-g.sh ;;
    "q" ) exit ;;
  esac
 done 

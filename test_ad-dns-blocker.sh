#!/bin/sh
. /lib/functions/network.sh

NET_IF="lan"
network_flush_cache
network_get_ipaddr NET_ADDR "${NET_IF}"

# Function to manage AdGuard Home installation
func_adguard() {
  if opkg list-installed | grep -q "^adguardhome "; then
    echo "AdGuard Home is already installed."
  else
    echo "AdGuard Home is not installed. Proceeding with installation."
  fi

  DISTRIB_ARCH=$(grep 'DISTRIB_ARCH' /etc/openwrt_release | cut -d"'" -f2)
  case "$DISTRIB_ARCH" in
    "aarch64_cortex-a53"|"arm_cortex-a7_neon-vfpv4"|"x86_64")
      echo "Architecture supported: $DISTRIB_ARCH"
      ;;
    *)
      echo "Unsupported architecture. Please check: https://openwrt.org/packages/architectures"
      return 1
      ;;
  esac

  while true; do
    cat <<-EOF
      AdGuard Menu:
      [c] Configure and Install AdGuard Home
      [s] Configure Web Interface (Port, Username, Password)
      [b] Remove and Restore to Previous Settings
      [q] Quit
    EOF

    read -rp "Select an option [c/s/b/q]: " choice
    case "$choice" in
      c) configure_adguard_home ;;
      s) configure_web_interface ;;
      b) remove_restore_adguard_home ;;
      q) exit 0 ;;
      *) echo "Invalid option." ;;
    esac
  done
}

configure_adguard_home() {
  echo "Starting AdGuard Home installation..."
  opkg update
  opkg install adguardhome
  echo "AdGuard Home installation completed."
  echo "Access AdGuard Home at: http://${NET_ADDR}:3000"
}

configure_web_interface() {
  echo "Configuring web interface..."
  read -rp "Enter port number (e.g., 3000): " PORT
  read -rp "Enter username: " USERNAME
  read -rsp "Enter password: " PASSWORD
  echo

  htpasswd -cb /etc/adguardhome/credentials $USERNAME $PASSWORD

  sed -i "s/port:.*/port: $PORT/" /etc/adguardhome.yaml
  echo "Web interface configured. Access at: http://${NET_ADDR}:$PORT"
}

remove_restore_adguard_home() {
  echo "Removing AdGuard Home..."
  opkg remove adguardhome
  rm -rf /etc/adguardhome
  echo "AdGuard Home removed and settings restored."
}

# Main entry point
func_adguard

#!/data/data/com.termux/files/usr/bin/bash
config_menu() {
  echo "1) Change default distribution"
  echo "2) Change default desktop environment"
  echo "3) Change X11 display"
  echo "4) View configuration"
  echo "0) Back"
  read -r -p "Selection: " c
  case "$c" in
    1) distro_select;;
    2) desktop_menu;;
    3)
      read -r -p "Display (default :1): " v
      if [[ -z "$v" ]]; then
        info "Display unchanged."
      elif [[ "$v" =~ ^:[0-9]+$ ]]; then
        REDMUX_DISPLAY="$v"
        save_config
        info "Display saved: $REDMUX_DISPLAY"
      else
        warn "Invalid display. Use a value such as :1 or :2."
      fi
      ;;
    4) cat "$REDMUX_CONFIG";;
    0) return 0;;
    *) warn "Invalid selection. Choose 0 to 4.";;
  esac
}

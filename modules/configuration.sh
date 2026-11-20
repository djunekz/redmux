#!/data/data/com.termux/files/usr/bin/bash
config_menu() {
  echo "1) Change default distribution"
  echo "2) Change default desktop environment"
  echo "3) Change X11 display"
  echo "4) View configuration"
  echo "5) Graphics mode"
  echo "6) X11 resolution"
  echo "7) UI DPI"
  echo "8) VNC settings"
  echo "9) Toggle legacy X11 drawing"
  echo "10) Toggle X11 debug logging"
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
    5)
      read -r -p "Graphics mode [auto/software/virgl/turnip]: " v
      if [[ "$v" =~ ^(auto|software|virgl|turnip)$ ]]; then REDMUX_GPU_MODE="$v"; save_config; graphics_status; else warn "Invalid graphics mode."; fi
      ;;
    6)
      read -r -p "Resolution (WIDTHxHEIGHT, empty for automatic): " v
      if [[ -z "$v" || "$v" =~ ^[0-9]{3,4}x[0-9]{3,4}$ ]]; then REDMUX_RESOLUTION="$v"; save_config; info "Resolution saved."; else warn "Invalid resolution."; fi
      ;;
    7)
      read -r -p "DPI (empty for automatic, 60-999): " v
      if [[ -z "$v" || "$v" =~ ^[6-9][0-9]$|^[1-9][0-9]{2,3}$ ]]; then REDMUX_DPI="$v"; save_config; info "DPI saved."; else warn "Invalid DPI."; fi
      ;;
    8)
      read -r -p "VNC display (for example :2): " v
      if [[ "$v" =~ ^:[1-9][0-9]{0,2}$ ]]; then REDMUX_VNC_DISPLAY="$v"; fi
      read -r -p "VNC resolution [WIDTHxHEIGHT]: " v
      if [[ "$v" =~ ^[0-9]{3,4}x[0-9]{3,4}$ ]]; then REDMUX_VNC_RESOLUTION="$v"; fi
      read -r -p "VNC depth [16/24/32]: " v
      if [[ "$v" =~ ^(16|24|32)$ ]]; then REDMUX_VNC_DEPTH="$v"; fi
      save_config
      info "VNC settings saved."
      ;;
    9)
      if [[ "$REDMUX_X11_LEGACY" == 1 ]]; then REDMUX_X11_LEGACY=0; else REDMUX_X11_LEGACY=1; fi
      save_config
      info "Legacy X11 drawing: $REDMUX_X11_LEGACY"
      ;;
    10)
      if [[ "$REDMUX_X11_DEBUG" == 1 ]]; then REDMUX_X11_DEBUG=0; else REDMUX_X11_DEBUG=1; fi
      save_config
      info "X11 debug logging: $REDMUX_X11_DEBUG"
      ;;
    0) return 0;;
    *) warn "Invalid selection. Choose 0 to 10.";;
  esac
}

config_file_command() {
  local action="${1:-}" path="${2:-}" original
  case "$action" in
    export)
      [[ -n "$path" ]] || die "Usage: redmux config export PATH"
      save_config
      cp "$REDMUX_CONFIG" "$path" || die "Could not export the configuration file."
      info "Configuration exported to $path"
      ;;
    import)
      [[ -n "$path" && -f "$path" ]] || die "Usage: redmux config import PATH"
      original="$REDMUX_CONFIG"
      REDMUX_DISTRO=debian
      REDMUX_DESKTOP=xfce
      REDMUX_DESKTOPS=xfce
      REDMUX_DISPLAY=:1
      REDMUX_RESOLUTION=
      REDMUX_DPI=
      REDMUX_GPU_MODE=auto
      REDMUX_VNC_DISPLAY=:2
      REDMUX_VNC_RESOLUTION=1280x720
      REDMUX_VNC_DEPTH=24
      REDMUX_X11_LEGACY=0
      REDMUX_X11_DEBUG=0
      REDMUX_CONFIG="$path"
      load_config
      REDMUX_CONFIG="$original"
      validate_runtime_config
      save_config
      info "Validated configuration imported from $path"
      ;;
    reset)
      confirm "Reset REDMUX settings to defaults? Installed Linux environments will not be removed." || return 0
      REDMUX_DISTRO=debian
      REDMUX_DESKTOP=xfce
      REDMUX_DESKTOPS=xfce
      REDMUX_DISPLAY=:1
      REDMUX_RESOLUTION=
      REDMUX_DPI=
      REDMUX_GPU_MODE=auto
      REDMUX_VNC_DISPLAY=:2
      REDMUX_VNC_RESOLUTION=1280x720
      REDMUX_VNC_DEPTH=24
      REDMUX_X11_LEGACY=0
      REDMUX_X11_DEBUG=0
      save_config
      info "REDMUX configuration reset. Installed packages and Linux filesystems were left untouched."
      ;;
    *)
      die "Usage: redmux config [export PATH|import PATH|reset]"
      ;;
  esac
}

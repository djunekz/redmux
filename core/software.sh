#!/data/data/com.termux/files/usr/bin/bash
software_guest_ready() {
  local distro="${1:-$REDMUX_DISTRO}"
  distro_supported "$distro" || die "Unsupported distribution: $distro"
  distro_installed "$distro" || die "$distro is not installed. Run redmux install first."
}
apps_command() {
  local action="${1:-}" distro="$REDMUX_DISTRO"
  shift || true
  if [[ "${1:-}" == --distro ]]; then distro="${2:-}"; shift 2; fi
  software_guest_ready "$distro"
  case "$action" in
    search)
      [[ -n "${1:-}" ]] || die "Usage: redmux apps search QUERY"
      proot-distro login --shared-tmp "$distro" -- apt-cache search "$1"
      ;;
    install)
      (( $# > 0 )) || die "Usage: redmux apps install PACKAGE [PACKAGE ...]"
      local package
      for package in "$@"; do [[ "$package" =~ ^[a-z0-9][a-z0-9+.-]*$ ]] || die "Invalid package name: $package"; done
      proot-distro login --shared-tmp "$distro" -- apt-get update
      proot-distro login --shared-tmp "$distro" -- apt-get install -y -- "$@"
      ;;
    remove)
      (( $# > 0 )) || die "Usage: redmux apps remove PACKAGE [PACKAGE ...]"
      local package
      for package in "$@"; do [[ "$package" =~ ^[a-z0-9][a-z0-9+.-]*$ ]] || die "Invalid package name: $package"; done
      proot-distro login --shared-tmp "$distro" -- apt-get remove -y -- "$@"
      ;;
    list)
      proot-distro login --shared-tmp "$distro" -- dpkg-query -W -f='${binary:Package}\t${Version}\n'
      ;;
    *)
      die "Usage: redmux apps search|install|remove|list"
      ;;
  esac
}
themes_install() {
  local distro="$REDMUX_DISTRO"
  software_guest_ready "$distro"
  proot-distro login --shared-tmp "$distro" -- apt-get update
  proot-distro login --shared-tmp "$distro" -- apt-get install -y papirus-icon-theme arc-theme numix-gtk-theme fonts-noto-color-emoji fonts-cantarell
  info "Theme and icon packages installed. Select them in the desktop appearance settings."
}
wine_install() {
  local distro="$REDMUX_DISTRO"
  software_guest_ready "$distro"
  proot-distro login --shared-tmp "$distro" -- apt-get update
  proot-distro login --shared-tmp "$distro" -- apt-get install -y wine winetricks
  info "Wine installation completed if the distribution provides packages for this architecture."
}
wine_run() {
  local distro="$REDMUX_DISTRO"
  software_guest_ready "$distro"
  (( $# > 0 )) || die "Usage: redmux wine-run FILE.exe [ARGUMENTS ...]"
  proot-distro login --shared-tmp "$distro" -- wine "$@"
}
termux_api_install() {
  require_termux
  if ! command -v termux-battery-status >/dev/null 2>&1; then
    pkg install -y termux-api || die "Could not install the Termux:API command-line package."
  fi
  info "Termux:API commands are ready. Install the matching Termux:API Android application separately."
}
gui_manager() {
  local action="${1:-}" target="${2:-}"
  case "$action" in
    --start|start)
      case "$target" in
        x11|tx11) session_start "${@:3}";;
        vnc) vnc_start "${@:3}";;
        *) die "Usage: redmux gui --start x11|vnc";;
      esac
      ;;
    --stop|stop)
      case "$target" in
        x11|tx11) session_stop;;
        vnc) vnc_stop "${3:-}";;
        *) die "Usage: redmux gui --stop x11|vnc";;
      esac
      ;;
    --kill|kill)
      session_stop
      vnc_stop || true
      ;;
    *)
      die "Usage: redmux gui --start x11|vnc, --stop x11|vnc, or --kill"
      ;;
  esac
}

#!/data/data/com.termux/files/usr/bin/bash
autostart_file="$HOME/.termux/boot/redmux"
autostart_command() {
  case "${1:-status}" in
    enable)
      mkdir -p "$(dirname "$autostart_file")"
      umask 077
      {
        printf '%s\n' '#!/data/data/com.termux/files/usr/bin/bash'
        printf '%s\n' 'sleep 5'
        printf '%s\n' 'redmux start'
      } > "$autostart_file"
      chmod 700 "$autostart_file"
      info "REDMUX autostart enabled. Install the Termux:Boot Android app and allow it to run at boot."
      ;;
    disable)
      rm -f "$autostart_file"
      info "REDMUX autostart entry removed."
      ;;
    status)
      [[ -x "$autostart_file" ]] && info "REDMUX autostart is enabled." || info "REDMUX autostart is disabled."
      ;;
    *)
      die "Usage: redmux autostart enable|disable|status"
      ;;
  esac
}

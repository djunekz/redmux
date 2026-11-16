#!/data/data/com.termux/files/usr/bin/bash
session_start() {
  local d="${1:-$REDMUX_DISTRO}" desktop cmd
  distro_supported "$d" || die "Unsupported distribution: $d"
  distro_installed "$d" || die "$d is not installed. Run redmux install."
  if [[ "$REDMUX_DESKTOPS" == *,* ]]; then
    local -a installed_desktops=()
    local item
    for item in ${REDMUX_DESKTOPS//,/ }; do
      if desktop_installed "$item"; then installed_desktops+=("$(desktop_name "$item")"); fi
    done
    if (( ${#installed_desktops[@]} )); then
      local selected
      selected="$(choose "Select a desktop for this session:" "${installed_desktops[@]}")"
      desktop="$(case "$selected" in "XFCE4") echo xfce;; "KDE Plasma") echo kde;; "LXQt") echo lxqt;; "MATE") echo mate;; "LXDE") echo lxde;; "GNOME") echo gnome;; esac)"
    else
      desktop="$REDMUX_DESKTOP"
    fi
  else
    desktop="$REDMUX_DESKTOP"
  fi
  x11_prepare
  x11_start
  cmd="$(desktop_command "$desktop")" || die "Desktop $desktop is not supported."
  log "Launching $desktop pada $d ($REDMUX_DISPLAY)."
  proot-distro login --shared-tmp "$d" -- /bin/bash -lc "export DISPLAY='$REDMUX_DISPLAY'; export PULSE_SERVER=127.0.0.1; export XDG_RUNTIME_DIR=/tmp/redmux-runtime; mkdir -p \"\$XDG_RUNTIME_DIR\"; chmod 700 \"\$XDG_RUNTIME_DIR\"; $cmd"
}
session_stop() {
  log "Stopping REDMUX desktop processes."
  pkill -f 'startxfce4|startplasma-x11|startlxqt|mate-session|startlxde|gnome-session' 2>/dev/null || true
  x11_stop
  info "Session stop request sent."
}
session_status() {
  echo "REDMUX version : $REDMUX_VERSION"
  echo "Distro default : $REDMUX_DISTRO"
  echo "Desktop default: $REDMUX_DESKTOP"
  echo "Installed desktops: $REDMUX_DESKTOPS"
  echo "Display        : $REDMUX_DISPLAY"
  if command -v proot-distro >/dev/null; then echo "proot-distro   : available"; else echo "proot-distro   : not installed"; fi
  if x11_detect; then echo "Termux-X11 CLI : available"; else echo "Termux-X11 CLI : belum available"; fi
  if pgrep -f "termux-x11 $REDMUX_DISPLAY" >/dev/null 2>&1; then echo "X11 session    : berjalan"; else echo "X11 session    : not detected"; fi
}

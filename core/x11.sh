#!/data/data/com.termux/files/usr/bin/bash
x11_detect() {
  command -v termux-x11 >/dev/null 2>&1
}
x11_prepare() {
  if ! x11_detect; then
    warn "Termux:X11 CLI was not found. Installing the CLI package automatically."
    pkg install -y x11-repo || die "Failed to add the X11 repository."
    pkg install -y termux-x11-nightly || die "Failed to install termux-x11-nightly."
    x11_detect || die "The Termux:X11 CLI was not detected after installation."
    warn "Install the Android Termux:X11 app from its official project if it is not already installed."
  fi
}

x11_start() {
  local display="${REDMUX_DISPLAY:-:1}"
  if pgrep -f "termux-x11 $display" >/dev/null 2>&1; then
    log "Termux:X11 sudah berjalan pada $display."
  else
    log "Memulai Termux:X11 pada $display."
    termux-x11 "$display" >/dev/null 2>&1 &
    echo $! > "$REDMUX_DATA_DIR/x11.pid"
    sleep 2
  fi
}
x11_stop() {
  if [[ -f "$REDMUX_DATA_DIR/x11.pid" ]]; then
    local pid; pid="$(cat "$REDMUX_DATA_DIR/x11.pid")"
    kill "$pid" 2>/dev/null || true
    rm -f "$REDMUX_DATA_DIR/x11.pid"
  fi
}

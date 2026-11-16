#!/data/data/com.termux/files/usr/bin/bash
x11_detect() {
  command -v termux-x11 >/dev/null 2>&1
}
x11_prepare() {
  if x11_detect; then return 0; fi
  warn "The Termux:X11 command-line package is missing."
  confirm "Install the Termux:X11 package now?" || return 1
  pkg install -y x11-repo || { warn "Failed to add the X11 package repository."; return 1; }
  pkg install -y termux-x11-nightly || { warn "Failed to install the Termux:X11 package."; return 1; }
  x11_detect || { warn "The termux-x11 command is still unavailable after installation."; return 1; }
  warn "Install the Android Termux:X11 application separately if it is not already installed."
}
x11_start() {
  local display="${REDMUX_DISPLAY:-:1}"
  if pgrep -f "termux-x11 $display" >/dev/null 2>&1; then
    log "Termux:X11 is already running on $display."
    return 0
  fi
  log "Starting Termux:X11 on $display."
  termux-x11 "$display" >/dev/null 2>&1 &
  umask 077
  printf '%s\n' "$!" > "$REDMUX_DATA_DIR/x11.pid"
  sleep 2
  local pid
  pid="$(cat "$REDMUX_DATA_DIR/x11.pid" 2>/dev/null || true)"
  if [[ ! "$pid" =~ ^[0-9]+$ ]] || ! kill -0 "$pid" 2>/dev/null; then
    rm -f "$REDMUX_DATA_DIR/x11.pid"
    warn "Termux:X11 did not remain running after startup."
    return 1
  fi
}
x11_stop() {
  local pid_file="$REDMUX_DATA_DIR/x11.pid"
  if [[ ! -f "$pid_file" ]]; then return 0; fi
  local pid command_line
  pid="$(cat "$pid_file" 2>/dev/null || true)"
  if [[ "$pid" =~ ^[0-9]+$ ]] && (( pid > 1 )) && kill -0 "$pid" 2>/dev/null; then
    command_line="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)"
    if [[ "$command_line" == *termux-x11* ]]; then
      kill -TERM "$pid" 2>/dev/null || true
      log "Stopped the REDMUX-managed Termux:X11 process (PID $pid)."
    else
      warn "The saved X11 PID no longer belongs to the Termux:X11 command; it was not terminated."
    fi
  fi
  rm -f "$pid_file"
}

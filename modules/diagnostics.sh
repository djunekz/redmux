#!/data/data/com.termux/files/usr/bin/bash
diagnostics() {
  echo "=== REDMUX DIAGNOSTICS ==="
  local c
  for c in pkg dpkg-query proot-distro termux-x11; do
    if command -v "$c" >/dev/null 2>&1; then printf '[OK] %s\n' "$c"; else printf '[MISSING] %s\n' "$c"; fi
  done
  echo
  echo "Storage: ${HOME}"
  df -h "$HOME"
  echo "Config : $REDMUX_CONFIG"
  echo "Logs   : $LOG_FILE"
  [[ -f "$REDMUX_STATE" ]] && { echo "Install state: resume available"; sed 's/^/  /' "$REDMUX_STATE"; } || echo "Install state: tidak ada proses tertunda"
  echo "The Android Termux:X11 app must be installed separately from its CLI package."
}

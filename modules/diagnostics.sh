#!/data/data/com.termux/files/usr/bin/bash
diagnostics() {
  echo "=== REDMUX DIAGNOSTICS ==="
  local c
  for c in pkg dpkg-query proot-distro termux-x11 termux-battery-status virgl_test_server virgl_test_server_android; do
    if command -v "$c" >/dev/null 2>&1; then printf '[OK] %s\n' "$c"; else printf '[MISSING] %s\n' "$c"; fi
  done
  echo
  echo "Storage: ${HOME}"
  df -h "$HOME"
  echo "Config : $REDMUX_CONFIG"
  echo "Logs   : $LOG_FILE"
  echo "RAM    : $(awk '/MemTotal/ {printf "%.1f GiB", $2 / 1048576}' /proc/meminfo 2>/dev/null || printf unknown)"
  echo "CPU    : $(getprop ro.product.cpu.abi 2>/dev/null || uname -m)"
  [[ -f "$REDMUX_STATE" ]] && { echo "Install state: resume available"; sed 's/^/  /' "$REDMUX_STATE"; } || echo "Install state: no pending installation"
  echo
  graphics_status
  echo "The Android Termux:X11 app must be installed separately from its CLI package."
  echo "VNC is optional and can be installed with: redmux vnc-install"
}

#!/data/data/com.termux/files/usr/bin/bash
vnc_server_command() {
  proot-distro login --shared-tmp "$REDMUX_DISTRO" -- /bin/bash -lc 'command -v tigervncserver || command -v vncserver'
}
vnc_install() {
  require_termux
  distro_supported "$REDMUX_DISTRO" || die "Unsupported distribution: $REDMUX_DISTRO"
  distro_installed "$REDMUX_DISTRO" || die "$REDMUX_DISTRO is not installed. Run redmux install first."
  ui_step "Installing the optional TigerVNC server"
  proot-distro login --shared-tmp "$REDMUX_DISTRO" -- /bin/bash -lc 'export DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get install -y tigervnc-standalone-server tigervnc-common dbus-x11'
  ui_ok "VNC server packages installed"
  info "Set a VNC password inside Linux with: redmux shell, then vncpasswd"
}
vnc_start() {
  local d="${1:-$REDMUX_DISTRO}" server desktop command
  distro_supported "$d" || die "Unsupported distribution: $d"
  distro_installed "$d" || die "$d is not installed. Run redmux install first."
  server="$(proot-distro login --shared-tmp "$d" -- /bin/bash -lc 'command -v tigervncserver || command -v vncserver' 2>/dev/null | tail -n 1)"
  [[ -n "$server" ]] || die "VNC server is not installed. Run redmux vnc-install."
  desktop="$REDMUX_DESKTOP"
  desktop_installed "$desktop" "$d" || die "The configured desktop is not installed in $d."
  command="$(desktop_command "$desktop")" || die "Unsupported desktop: $desktop"
  proot-distro login --shared-tmp "$d" -- /bin/bash -lc "mkdir -p ~/.vnc && printf '%s\n' '#!/bin/sh' 'unset SESSION_MANAGER' 'unset DBUS_SESSION_BUS_ADDRESS' '$command' > ~/.vnc/xstartup && chmod 700 ~/.vnc/xstartup"
  proot-distro login --shared-tmp "$d" -- /bin/bash -lc "if command -v tigervncserver >/dev/null 2>&1; then tigervncserver '$REDMUX_VNC_DISPLAY' -geometry '$REDMUX_VNC_RESOLUTION' -depth '$REDMUX_VNC_DEPTH' -localhost yes; else vncserver '$REDMUX_VNC_DISPLAY' -geometry '$REDMUX_VNC_RESOLUTION' -depth '$REDMUX_VNC_DEPTH' -localhost yes; fi"
  info "VNC desktop requested on display $REDMUX_VNC_DISPLAY."
  info "Connect from a VNC client to 127.0.0.1:$((5900 + ${REDMUX_VNC_DISPLAY#:}))."
}
vnc_stop() {
  local d="${1:-$REDMUX_DISTRO}"
  distro_supported "$d" || die "Unsupported distribution: $d"
  distro_installed "$d" || die "$d is not installed."
  proot-distro login --shared-tmp "$d" -- /bin/bash -lc "if command -v tigervncserver >/dev/null 2>&1; then tigervncserver -kill '$REDMUX_VNC_DISPLAY'; elif command -v vncserver >/dev/null 2>&1; then vncserver -kill '$REDMUX_VNC_DISPLAY'; else exit 127; fi"
}
vnc_status() {
  local d="${1:-$REDMUX_DISTRO}"
  distro_supported "$d" || die "Unsupported distribution: $d"
  distro_installed "$d" || die "$d is not installed."
  proot-distro login --shared-tmp "$d" -- /bin/bash -lc "if command -v tigervncserver >/dev/null 2>&1; then tigervncserver -list; elif command -v vncserver >/dev/null 2>&1; then vncserver -list; else printf '%s\n' 'VNC server not installed'; exit 1; fi"
}

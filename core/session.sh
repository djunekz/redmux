#!/data/data/com.termux/files/usr/bin/bash
session_process_matches() {
  local pid="$1" command_line
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  kill -0 "$pid" 2>/dev/null || return 1
  command_line="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)"
  [[ "$command_line" == *proot-distro* || "$command_line" == *"/proot"* ]]
}
session_start() {
  local d="$REDMUX_DISTRO" desktop cmd session_pid session_status session_group=0 gfx dpi_setup resolution_setup requested_desktop='' no_gpu=0
  REDMUX_X11_LEGACY_RUNTIME="$REDMUX_X11_LEGACY"
  REDMUX_X11_DEBUG_RUNTIME="$REDMUX_X11_DEBUG"
  while (( $# )); do
    case "$1" in
      --nogpu) no_gpu=1;;
      --legacy) REDMUX_X11_LEGACY_RUNTIME=1;;
      --debug) REDMUX_X11_DEBUG_RUNTIME=1;;
      --desktop|--xstartup)
        (( $# >= 2 )) || die "A desktop key is required after $1."
        shift
        requested_desktop="${1:-}"
        ;;
      --desktop=*|--xstartup=*) requested_desktop="${1#*=}";;
      --help)
        printf '%s\n' 'Usage: redmux start [distro] [--desktop KEY] [--nogpu] [--legacy] [--debug]'
        return 0
        ;;
      debian|ubuntu|kali) d="$1";;
      *) die "Unknown start option or distribution: $1";;
    esac
    shift
  done
  local pid_file="$REDMUX_DATA_DIR/session.pid"
  local group_file="$REDMUX_DATA_DIR/session.group"
  distro_supported "$d" || die "Unsupported distribution: $d"
  distro_installed "$d" || die "$d is not installed. Run redmux install."
  if [[ -f "$pid_file" ]]; then
    session_pid="$(cat "$pid_file" 2>/dev/null || true)"
    if session_process_matches "$session_pid"; then
      die "A REDMUX desktop session is already running (PID $session_pid). Run redmux stop first."
    fi
    rm -f "$pid_file" "$group_file"
  fi
  if [[ -n "$requested_desktop" ]]; then
    desktop="$(desktop_key "$requested_desktop")" || die "Unsupported desktop startup target: $requested_desktop"
    desktop_installed "$desktop" "$d" || die "The requested desktop is not installed in $d."
  elif [[ "$REDMUX_DESKTOPS" == *,* ]]; then
    local -a installed_desktops=()
    local item
    for item in ${REDMUX_DESKTOPS//,/ }; do
      if desktop_installed "$item" "$d"; then installed_desktops+=("$(desktop_name "$item")"); fi
    done
    if (( ${#installed_desktops[@]} )) && [[ -t 0 ]]; then
      local selected
      selected="$(choose "Select a desktop for this session:" "${installed_desktops[@]}")"
      desktop="$(case "$selected" in "XFCE4") echo xfce;; "KDE Plasma") echo kde;; "LXQt") echo lxqt;; "MATE") echo mate;; "LXDE") echo lxde;; "GNOME") echo gnome;; "Openbox") echo openbox;; "i3 Window Manager") echo i3;; "Cinnamon") echo cinnamon;; "dwm") echo dwm;; "bspwm") echo bspwm;; "Awesome") echo awesome;; "Fluxbox") echo fluxbox;; "IceWM") echo icewm;; "Window Maker") echo wmaker;; esac)"
    else
      desktop="$REDMUX_DESKTOP"
    fi
  else
    desktop="$REDMUX_DESKTOP"
  fi
  x11_prepare || die "Termux:X11 is not ready. Run redmux diagnose and try again."
  graphics_start || true
  [[ "$no_gpu" == 1 ]] && REDMUX_GPU_RUNTIME=software
  x11_start || { graphics_stop; die "Termux:X11 could not be started."; }
  if command -v pulseaudio >/dev/null 2>&1; then
    pulseaudio --start --exit-idle-time=-1 >/dev/null 2>&1 || warn "PulseAudio could not be started; desktop audio may be unavailable."
  fi
  cmd="$(desktop_command "$desktop")" || die "Desktop $desktop is not supported."
  gfx="$(graphics_environment)"
  dpi_setup=''
  resolution_setup=''
  [[ -z "$REDMUX_DPI" ]] || dpi_setup="export QT_FONT_DPI='$REDMUX_DPI'; command -v xrdb >/dev/null 2>&1 && printf 'Xft.dpi: %s\n' '$REDMUX_DPI' | xrdb -merge || true;"
  [[ -z "$REDMUX_RESOLUTION" ]] || resolution_setup="command -v xrandr >/dev/null 2>&1 && xrandr --fb '$REDMUX_RESOLUTION' >/dev/null 2>&1 || true;"
  log "Launching $desktop on $d ($REDMUX_DISPLAY)."
  local -a launch=(proot-distro login --shared-tmp "$d" -- /bin/bash -lc "$gfx export DISPLAY='$REDMUX_DISPLAY'; export PULSE_SERVER=127.0.0.1; export XDG_RUNTIME_DIR=/tmp/redmux-runtime; mkdir -p \"\$XDG_RUNTIME_DIR\"; chmod 700 \"\$XDG_RUNTIME_DIR\"; $dpi_setup $resolution_setup $cmd")
  umask 077
  if command -v setsid >/dev/null 2>&1; then
    setsid "${launch[@]}" &
    session_group=1
  else
    "${launch[@]}" &
  fi
  session_pid=$!
  printf '%s\n' "$session_pid" > "$pid_file"
  printf '%s\n' "$session_group" > "$group_file"
  if wait "$session_pid"; then session_status=0; else session_status=$?; fi
  if [[ "$(cat "$pid_file" 2>/dev/null || true)" == "$session_pid" ]]; then
    rm -f "$pid_file" "$group_file"
  fi
  return "$session_status"
}
session_stop() {
  local pid_file="$REDMUX_DATA_DIR/session.pid"
  local group_file="$REDMUX_DATA_DIR/session.group"
  local session_pid session_group
  if [[ -f "$pid_file" ]]; then
    session_pid="$(cat "$pid_file" 2>/dev/null || true)"
    session_group="$(cat "$group_file" 2>/dev/null || printf '0')"
    if [[ "$session_pid" =~ ^[0-9]+$ ]] && (( session_pid > 1 )) && session_process_matches "$session_pid"; then
      if [[ "$session_group" == 1 ]]; then
        kill -TERM -- "-$session_pid" 2>/dev/null || kill -TERM "$session_pid" 2>/dev/null || true
      else
        kill -TERM "$session_pid" 2>/dev/null || true
      fi
      info "Stop signal sent to the REDMUX-managed desktop session (PID $session_pid)."
    else
      warn "The saved session PID is no longer a REDMUX process; it was not terminated."
    fi
    rm -f "$pid_file" "$group_file"
  else
    info "No active REDMUX-managed desktop session was found."
  fi
  x11_stop
  graphics_stop
}
session_status() {
  echo "REDMUX version : $REDMUX_VERSION"
  echo "Default distro : $REDMUX_DISTRO"
  echo "Default desktop: $REDMUX_DESKTOP"
  echo "Configured desktops: $REDMUX_DESKTOPS"
  echo "Display        : $REDMUX_DISPLAY"
  echo "Resolution     : ${REDMUX_RESOLUTION:-automatic}"
  echo "DPI            : ${REDMUX_DPI:-automatic}"
  echo "GPU mode       : $REDMUX_GPU_MODE"
  if command -v proot-distro >/dev/null; then echo "proot-distro   : available"; else echo "proot-distro   : not installed"; fi
  if x11_detect; then echo "Termux:X11 CLI : available"; else echo "Termux:X11 CLI : not installed"; fi
  local session_pid
  session_pid="$(cat "$REDMUX_DATA_DIR/session.pid" 2>/dev/null || true)"
  if session_process_matches "$session_pid"; then echo "Desktop session: running (PID $session_pid)"; else echo "Desktop session: not running"; fi
  if [[ -f "$REDMUX_DATA_DIR/x11.pid" ]]; then echo "Managed X11    : PID $(cat "$REDMUX_DATA_DIR/x11.pid")"; else echo "Managed X11    : not started by REDMUX"; fi
  if [[ -f "$REDMUX_DATA_DIR/graphics.pid" ]]; then echo "Managed graphics: PID $(cat "$REDMUX_DATA_DIR/graphics.pid")"; else echo "Managed graphics: not started by REDMUX"; fi
}

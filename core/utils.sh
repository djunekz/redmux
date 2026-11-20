#!/data/data/com.termux/files/usr/bin/bash
REDMUX_VERSION="1.0.0"
: "${REDMUX_HOME:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
REDMUX_CONFIG_DIR="${REDMUX_CONFIG_DIR:-$HOME/.config/redmux}"
REDMUX_DATA_DIR="${REDMUX_DATA_DIR:-$HOME/.local/share/redmux}"
REDMUX_LOG_DIR="${REDMUX_LOG_DIR:-$HOME/.local/state/redmux}"
REDMUX_CONFIG="$REDMUX_CONFIG_DIR/redmux.conf"
REDMUX_STATE="$REDMUX_DATA_DIR/install.state"
mkdir -p "$REDMUX_CONFIG_DIR" "$REDMUX_DATA_DIR" "$REDMUX_LOG_DIR"
LOG_FILE="$REDMUX_LOG_DIR/redmux.log"
: "${REDMUX_DISTRO:=debian}"
: "${REDMUX_DESKTOP:=xfce}"
: "${REDMUX_DESKTOPS:=$REDMUX_DESKTOP}"
: "${REDMUX_DISPLAY:=:1}"
: "${REDMUX_RESOLUTION:=}"
: "${REDMUX_DPI:=}"
: "${REDMUX_GPU_MODE:=auto}"
: "${REDMUX_VNC_DISPLAY:=:2}"
: "${REDMUX_VNC_RESOLUTION:=1280x720}"
: "${REDMUX_VNC_DEPTH:=24}"
: "${REDMUX_X11_LEGACY:=0}"
: "${REDMUX_X11_DEBUG:=0}"
load_config() {
  [[ -f "$REDMUX_CONFIG" ]] || return 0
  local key value
  while IFS='=' read -r key value || [[ -n "$key$value" ]]; do
    value="${value#\'}"
    value="${value%\'}"
    case "$key" in
      REDMUX_DISTRO)
        if [[ "$value" =~ ^(debian|ubuntu|kali)$ ]]; then REDMUX_DISTRO="$value"; fi
        ;;
      REDMUX_DESKTOP)
        if [[ "$value" =~ ^(xfce|kde|lxqt|mate|lxde|gnome|openbox|i3|cinnamon|dwm|bspwm|awesome|fluxbox|icewm|wmaker)$ ]]; then REDMUX_DESKTOP="$value"; fi
        ;;
      REDMUX_DESKTOPS)
        if [[ "$value" =~ ^(xfce|kde|lxqt|mate|lxde|gnome|openbox|i3|cinnamon|dwm|bspwm|awesome|fluxbox|icewm|wmaker)(,(xfce|kde|lxqt|mate|lxde|gnome|openbox|i3|cinnamon|dwm|bspwm|awesome|fluxbox|icewm|wmaker))*$ ]]; then REDMUX_DESKTOPS="$value"; fi
        ;;
      REDMUX_DISPLAY)
        if [[ "$value" =~ ^:[0-9]+$ ]]; then REDMUX_DISPLAY="$value"; fi
        ;;
      REDMUX_RESOLUTION)
        if [[ -z "$value" || "$value" =~ ^[0-9]+x[0-9]+$ ]]; then REDMUX_RESOLUTION="$value"; fi
        ;;
      REDMUX_DPI)
        if [[ -z "$value" || "$value" =~ ^([6-9][0-9]|[1-9][0-9]{2})$ ]]; then REDMUX_DPI="$value"; fi
        ;;
      REDMUX_GPU_MODE)
        if [[ "$value" =~ ^(auto|software|virgl|turnip)$ ]]; then REDMUX_GPU_MODE="$value"; fi
        ;;
      REDMUX_VNC_DISPLAY)
        if [[ "$value" =~ ^:[1-9][0-9]{0,2}$ ]]; then REDMUX_VNC_DISPLAY="$value"; fi
        ;;
      REDMUX_VNC_RESOLUTION)
        if [[ "$value" =~ ^[0-9]{3,4}x[0-9]{3,4}$ ]]; then REDMUX_VNC_RESOLUTION="$value"; fi
        ;;
      REDMUX_VNC_DEPTH)
        if [[ "$value" =~ ^(16|24|32)$ ]]; then REDMUX_VNC_DEPTH="$value"; fi
        ;;
      REDMUX_X11_LEGACY)
        if [[ "$value" =~ ^(0|1)$ ]]; then REDMUX_X11_LEGACY="$value"; fi
        ;;
      REDMUX_X11_DEBUG)
        if [[ "$value" =~ ^(0|1)$ ]]; then REDMUX_X11_DEBUG="$value"; fi
        ;;
    esac
  done < "$REDMUX_CONFIG"
}
load_config
validate_runtime_config() {
  [[ "$REDMUX_DISTRO" =~ ^(debian|ubuntu|kali)$ ]] || REDMUX_DISTRO=debian
  [[ "$REDMUX_DESKTOP" =~ ^(xfce|kde|lxqt|mate|lxde|gnome|openbox|i3|cinnamon|dwm|bspwm|awesome|fluxbox|icewm|wmaker)$ ]] || REDMUX_DESKTOP=xfce
  [[ "$REDMUX_DESKTOPS" =~ ^(xfce|kde|lxqt|mate|lxde|gnome|openbox|i3|cinnamon|dwm|bspwm|awesome|fluxbox|icewm|wmaker)(,(xfce|kde|lxqt|mate|lxde|gnome|openbox|i3|cinnamon|dwm|bspwm|awesome|fluxbox|icewm|wmaker))*$ ]] || REDMUX_DESKTOPS="$REDMUX_DESKTOP"
  [[ "$REDMUX_DISPLAY" =~ ^:[0-9]{1,3}$ ]] || REDMUX_DISPLAY=:1
  [[ -z "$REDMUX_RESOLUTION" || "$REDMUX_RESOLUTION" =~ ^[0-9]{3,4}x[0-9]{3,4}$ ]] || REDMUX_RESOLUTION=
  [[ -z "$REDMUX_DPI" || "$REDMUX_DPI" =~ ^([6-9][0-9]|[1-9][0-9]{2})$ ]] || REDMUX_DPI=
  [[ "$REDMUX_GPU_MODE" =~ ^(auto|software|virgl|turnip)$ ]] || REDMUX_GPU_MODE=auto
  [[ "$REDMUX_VNC_DISPLAY" =~ ^:[1-9][0-9]{0,2}$ ]] || REDMUX_VNC_DISPLAY=:2
  [[ "$REDMUX_VNC_RESOLUTION" =~ ^[0-9]{3,4}x[0-9]{3,4}$ ]] || REDMUX_VNC_RESOLUTION=1280x720
  [[ "$REDMUX_VNC_DEPTH" =~ ^(16|24|32)$ ]] || REDMUX_VNC_DEPTH=24
  [[ "$REDMUX_X11_LEGACY" =~ ^(0|1)$ ]] || REDMUX_X11_LEGACY=0
  [[ "$REDMUX_X11_DEBUG" =~ ^(0|1)$ ]] || REDMUX_X11_DEBUG=0
}
validate_runtime_config
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
  C_CYAN=$'\033[38;5;45m'; C_BLUE=$'\033[38;5;75m'; C_GREEN=$'\033[38;5;82m'
  C_YELLOW=$'\033[38;5;220m'; C_RED=$'\033[38;5;203m'; C_WHITE=$'\033[38;5;255m'
else
  C_RESET=''; C_BOLD=''; C_DIM=''; C_CYAN=''; C_BLUE=''; C_GREEN=''; C_YELLOW=''; C_RED=''; C_WHITE=''
fi
log() { printf '[%s] %s\n' "$(date '+%F %T')" "$*" | tee -a "$LOG_FILE"; }
info() { printf '%s●%s %s\n' "$C_CYAN" "$C_RESET" "$*"; }
warn() { printf '%s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
die() { printf '%s✖%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }
pause() { read -r -p "Press Enter to continue..." _; }
require_termux() {
  [[ -n "${PREFIX:-}" && "$PREFIX" == *com.termux* ]] || warn "REDMUX is designed for Termux. Continue only in a compatible environment."
  command -v pkg >/dev/null 2>&1 || die "The pkg command was not found. Run REDMUX inside Termux."
  command -v dpkg-query >/dev/null 2>&1 || die "dpkg-query was not found. Update your Termux installation."
}
confirm() { local answer; read -r -p "$1 [y/N] " answer; [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]]; }
choose() {
  local prompt="$1"; shift
  local -a opts=("$@")
  local n i
  while true; do
    printf '\n%s%s%s\n' "$C_BOLD$C_WHITE" "$prompt" "$C_RESET" >&2
    for i in "${!opts[@]}"; do printf '  %s%2d%s  %s\n' "$C_CYAN" "$((i+1))" "$C_RESET" "${opts[$i]}" >&2; done
    read -r -p "  Select an option: " n
    [[ "$n" =~ ^[0-9]+$ ]] && (( n>=1 && n<=${#opts[@]} )) && { printf '%s' "${opts[$((n-1))]}"; return 0; }
    warn "Invalid selection. Choose a number from 1 to ${#opts[@]}."
  done
}
terminal_width() {
  local width="${COLUMNS:-}"
  if command -v tput >/dev/null 2>&1; then
    width="$(tput cols 2>/dev/null || printf '%s' "${COLUMNS:-40}")"
  fi
  [[ "$width" =~ ^[0-9]+$ ]] || width=40
  (( width < 24 )) && width=24
  (( width > 80 )) && width=80
  printf '%s' "$width"
}

ui_banner() {
  local width
  width="$(terminal_width)"
  printf '\n'
  if (( width >= 64 )) && [[ -r "$REDMUX_HOME/assets/banner.txt" ]]; then
    printf '%s' "$C_CYAN"
    cat "$REDMUX_HOME/assets/banner.txt"
    printf '%s' "$C_RESET"
  else
    printf '  %sREDMUX%s\n' "$C_CYAN$C_BOLD" "$C_RESET"
  fi
  if (( width < 32 )); then
    printf '  %sTERMUX LINUX%s\n' "$C_DIM" "$C_RESET"
    printf '  %sv%s%s\n' "$C_BOLD" "$REDMUX_VERSION" "$C_RESET"
  elif (( width < 64 )); then
    printf '  %sTERMUX LINUX DESKTOP%s\n' "$C_DIM" "$C_RESET"
    printf '  %sv%s · Android%s\n' "$C_BOLD" "$REDMUX_VERSION" "$C_RESET"
  else
    printf '  %sTERMUX LINUX DESKTOP MANAGER%s  %sv%s%s\n' "$C_DIM" "$C_RESET" "$C_BOLD" "$REDMUX_VERSION" "$C_RESET"
    printf '  %sA cleaner way to build your Linux desktop on Android.%s\n' "$C_DIM" "$C_RESET"
  fi
  ui_rule "$width" '-'
}

ui_rule() {
  local width="$1" char="${2:--}"
  (( width < 1 )) && return 0
  printf '  %s+' "$C_BLUE"
  printf '%*s' "$((width - 4))" '' | tr ' ' "$char"
  printf '+%s\n' "$C_RESET"
}

ui_box_row() {
  local text="$1" width="$2" align="${3:-left}"
  local content=$((width - 6)) length padding_left padding_right
  (( content < 1 )) && content=1
  text="${text:0:content}"
  length=${#text}
  padding_left=0
  if [[ "$align" == center ]]; then
    padding_left=$(((content - length) / 2))
  fi
  padding_right=$((content - length - padding_left))
  printf '  %s|%s ' "$C_BLUE" "$C_RESET"
  printf '%*s' "$padding_left" ''
  printf '%s%s%s' "$C_CYAN" "$text" "$C_RESET"
  printf '%*s ' "$padding_right" ''
  printf '%s|%s\n' "$C_BLUE" "$C_RESET"
}

ui_status_line() {
  local width distro desktop gpu display
  width="$(terminal_width)"
  distro="${REDMUX_DISTRO^}"
  desktop="$(desktop_name "$REDMUX_DESKTOP" 2>/dev/null || printf '%s' "$REDMUX_DESKTOP")"
  gpu="$(graphics_mode_effective 2>/dev/null || printf '%s' "$REDMUX_GPU_MODE")"
  display="$REDMUX_DISPLAY"
  if (( width < 36 )); then
    ui_box_row "$distro / $REDMUX_DESKTOP" "$width"
    ui_box_row "GPU: $gpu" "$width"
  else
    ui_box_row "SYSTEM  $distro  |  $desktop" "$width"
    ui_box_row "DISPLAY  $display  |  GPU  $gpu" "$width"
  fi
}

ui_dashboard() {
  local width
  width="$(terminal_width)"
  printf '\n'
  ui_rule "$width" '-'
  if (( width < 32 )); then
    ui_box_row 'REDMUX CENTER' "$width" center
    ui_box_row 'TERMUX LINUX' "$width" center
  else
    ui_box_row 'REDMUX CONTROL CENTER' "$width" center
    ui_box_row 'LINUX DESKTOP MANAGER FOR TERMUX' "$width" center
  fi
  ui_rule "$width" '='
  ui_status_line
  ui_rule "$width" '-'
  ui_box_row 'INSTALLATION' "$width"
  ui_box_row '01  Install / Resume Linux' "$width"
  ui_box_row '' "$width"
  ui_box_row 'DESKTOP SESSION' "$width"
  ui_box_row '02  Start Desktop' "$width"
  ui_box_row '03  Stop Desktop' "$width"
  ui_box_row '04  Restart Desktop' "$width"
  ui_box_row '05  Open Linux Shell' "$width"
  ui_box_row '' "$width"
  ui_box_row 'ENVIRONMENT' "$width"
  ui_box_row '06  Linux Distributions' "$width"
  ui_box_row '07  Desktop Environments' "$width"
  ui_box_row '' "$width"
  ui_box_row 'DISPLAY & GRAPHICS' "$width"
  ui_box_row '08  Termux:X11 / VNC' "$width"
  ui_box_row '09  Graphics & GPU' "$width"
  ui_box_row '' "$width"
  ui_box_row 'SOFTWARE & PERSONALIZATION' "$width"
  ui_box_row '10  Linux Applications' "$width"
  ui_box_row '11  Themes & Icons' "$width"
  ui_box_row '12  Wine / Windows Apps' "$width"
  ui_box_row '13  Termux:API' "$width"
  ui_box_row '' "$width"
  ui_box_row 'SYSTEM MANAGEMENT' "$width"
  ui_box_row '14  Configuration' "$width"
  ui_box_row '15  System Tools' "$width"
  ui_box_row '16  Status & Diagnostics' "$width"
  ui_box_row '17  Activity Logs' "$width"
  ui_box_row '18  Uninstall' "$width"
  ui_rule "$width" '-'
  if (( width < 48 )); then
    printf '\n  %s00%s  Exit\n\n' "$C_YELLOW$C_BOLD" "$C_RESET"
  else
    printf '\n  %s00%s  Exit                         %sredmux help%s  Commands\n\n' "$C_YELLOW$C_BOLD" "$C_RESET" "$C_CYAN" "$C_RESET"
  fi
}

ui_submenu() {
  local title="$1" width="$2"
  shift 2
  printf '\n'
  ui_rule "$width" '-'
  ui_box_row "$title" "$width" center
  ui_rule "$width" '-'
  local item
  for item in "$@"; do ui_box_row "$item" "$width"; done
  ui_rule "$width" '-'
  printf '\n'
}

session_menu() {
  local choice width
  width="$(terminal_width)"
  while true; do
    ui_submenu 'DESKTOP SESSION' "$width" '01  Start Termux:X11' '02  Stop Termux:X11' '03  Restart Termux:X11' '04  Start VNC' '05  Stop VNC' '06  VNC Status' '07  Stop All REDMUX Displays' '00  Back'
    read -r -p "  ${C_CYAN}session${C_RESET} › " choice
    case "$choice" in
      1|01) session_start; pause;;
      2|02) session_stop; pause;;
      3|03) session_stop; session_start; pause;;
      4|04) vnc_start; pause;;
      5|05) vnc_stop; pause;;
      6|06) vnc_status; pause;;
      7|07) gui_manager --kill; pause;;
      0|00) return 0;;
      *) warn 'Choose 00–07.';;
    esac
  done
}

display_menu() {
  local choice width
  width="$(terminal_width)"
  while true; do
    ui_submenu 'DISPLAY & GRAPHICS' "$width" '01  Start Termux:X11' '02  Stop Termux:X11' '03  Install VNC Server' '04  Start VNC Server' '05  Stop VNC Server' '06  VNC Status' '07  Graphics Capability' '08  Graphics Profile Settings' '00  Back'
    read -r -p "  ${C_CYAN}display${C_RESET} › " choice
    case "$choice" in
      1|01) session_start; pause;;
      2|02) session_stop; pause;;
      3|03) vnc_install; pause;;
      4|04) vnc_start; pause;;
      5|05) vnc_stop; pause;;
      6|06) vnc_status; pause;;
      7|07) graphics_status; pause;;
      8|08) config_set_graphics; pause;;
      0|00) return 0;;
      *) warn 'Choose 00–08.';;
    esac
  done
}

software_menu() {
  local choice action package width
  width="$(terminal_width)"
  while true; do
    ui_submenu 'SOFTWARE & PERSONALIZATION' "$width" '01  Search Linux Packages' '02  Install Linux Packages' '03  Remove Linux Packages' '04  List Installed Packages' '05  Install Themes & Icons' '06  Install Wine / Winetricks' '07  Run Windows Executable' '08  Install Termux:API CLI' '00  Back'
    read -r -p "  ${C_CYAN}software${C_RESET} › " choice
    case "$choice" in
      1|01) read -r -p '  Search query: ' package; [[ -z "$package" ]] || apps_command search "$package"; pause;;
      2|02) read -r -p '  Package names: ' package; [[ -z "$package" ]] || { read -r -a _redmux_packages <<< "$package"; apps_command install "${_redmux_packages[@]}"; }; pause;;
      3|03) read -r -p '  Package names: ' package; [[ -z "$package" ]] || { read -r -a _redmux_packages <<< "$package"; apps_command remove "${_redmux_packages[@]}"; }; pause;;
      4|04) apps_command list; pause;;
      5|05) themes_install; pause;;
      6|06) wine_install; pause;;
      7|07) read -r -p '  Windows executable path: ' package; [[ -z "$package" ]] || wine_run "$package"; pause;;
      8|08) termux_api_install; pause;;
      0|00) return 0;;
      *) warn 'Choose 00–08.';;
    esac
  done
}

system_menu() {
  local choice width
  width="$(terminal_width)"
  while true; do
    ui_submenu 'SYSTEM MANAGEMENT' "$width" '01  Configuration' '02  Enable Autostart' '03  Disable Autostart' '04  Autostart Status' '05  Status' '06  Diagnostics' '07  Activity Logs' '08  Reset Configuration' '09  Uninstall' '00  Back'
    read -r -p "  ${C_CYAN}system${C_RESET} › " choice
    case "$choice" in
      1|01) config_menu; pause;;
      2|02) autostart_command enable; pause;;
      3|03) autostart_command disable; pause;;
      4|04) autostart_command status; pause;;
      5|05) session_status; pause;;
      6|06) diagnostics; pause;;
      7|07) show_logs; pause;;
      8|08) config_file_command reset; pause;;
      9|09) uninstall_menu; pause;;
      0|00) return 0;;
      *) warn 'Choose 00–09.';;
    esac
  done
}

config_set_graphics() {
  local value
  read -r -p '  Graphics profile [auto/software/virgl/turnip]: ' value
  if [[ "$value" =~ ^(auto|software|virgl|turnip)$ ]]; then
    REDMUX_GPU_MODE="$value"
    save_config
    graphics_status
  else
    warn 'Invalid graphics profile.'
  fi
}

ui_section() {
  local width label
  width="$(terminal_width)"
  label="${1:0:$((width - 8))}"
  printf '\n  %s-- %s --%s\n' "$C_BLUE$C_BOLD" "$label" "$C_RESET"
}
ui_step() {
  local width label
  width="$(terminal_width)"
  label="${1:0:$((width - 4))}"
  printf '\n  %s◆%s %s\n' "$C_BLUE" "$C_RESET" "$label"
}
ui_ok() { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$1"; }
ui_warn() { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$1" >&2; }
ui_fail() { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$1" >&2; }
ui_stage() {
  local current="$1" total="$2" label="$3" term_width bar_width label_width filled empty pct
  term_width="$(terminal_width)"
  bar_width=$((term_width - 9))
  label_width=$((term_width - 9))
  (( bar_width < 8 )) && bar_width=8
  filled=$(( current * bar_width / total ))
  empty=$(( bar_width - filled ))
  pct=$(( current * 100 / total ))
  printf '\n  %s%02d/%02d%s  %.*s\n  %s[' "$C_DIM" "$current" "$total" "$C_RESET" "$label_width" "$label" "$C_CYAN"
  printf '%*s' "$filled" '' | tr ' ' '#'
  printf '%*s' "$empty" '' | tr ' ' '-'
  printf ']%s %3d%%%s\n' "$C_RESET" "$pct" "$C_BOLD"
}
ui_summary() {
  local width
  width="$(terminal_width)"
  printf '\n'
  ui_rule "$width" '-'
  ui_box_row 'INSTALLATION PLAN' "$width" center
  if (( width < 32 )); then
    ui_box_row "Distro: $1" "$width"
    ui_box_row "Desktop: $2" "$width"
  else
    ui_box_row "Distribution: $1" "$width"
    ui_box_row "Desktop(s): $2" "$width"
  fi
  ui_rule "$width" '-'
}
ui_complete() {
  local width
  width="$(terminal_width)"
  printf '\n'
  ui_rule "$width" '='
  if (( width < 32 )); then ui_box_row 'SETUP COMPLETE' "$width" center; else ui_box_row 'INSTALLATION COMPLETE' "$width" center; fi
  if (( width < 32 )); then
    ui_box_row "Distro: $1" "$width"
    ui_box_row "Desktop: $2" "$width"
  else
    ui_box_row "Distribution: $1" "$width"
    ui_box_row "Desktop(s): $2" "$width"
  fi
  ui_rule "$width" '='
  printf '  Next steps\n'
  if (( width < 32 )); then
    printf '  1. Open X11.\n  2. Run %sredmux start%s.\n  3. Run %sredmux shell%s.\n\n' "$C_CYAN" "$C_RESET" "$C_CYAN" "$C_RESET"
  elif (( width < 48 )); then
    printf '  1. Open X11 app.\n  2. Run %sredmux start%s.\n  3. Run %sredmux shell%s.\n\n' "$C_CYAN" "$C_RESET" "$C_CYAN" "$C_RESET"
  else
    printf '  1. Install/open the Termux:X11 app.\n  2. Run %sredmux start%s.\n  3. Run %sredmux shell%s.\n\n' "$C_CYAN" "$C_RESET" "$C_CYAN" "$C_RESET"
  fi
}
run_stage() {
  local stage="$1" total="$2" label="$3"
  shift 3
  if state_has "$stage"; then
    info "Stage already completed; skipping: $label"
    return 0
  fi
  ui_stage "$stage" "$total" "$label"
  "$@" || { warn "Stage failed: $label. Run redmux install to resume."; return 1; }
  state_mark "$stage"
  ui_ok "$label completed"
}
state_init() {
  local distro="$1" desktops="$2"
  if [[ -f "$REDMUX_STATE" ]]; then
    local old_distro old_desktops
    old_distro="$(state_value distro)"
    old_desktops="$(state_value desktops)"
    if [[ "$old_distro" == "$distro" && "$old_desktops" == "$desktops" ]]; then
      info "A previous installation session was found. Resuming from the last completed stage."
      return 0
    fi
    if confirm "A different installation session exists ($old_distro / $old_desktops). Start a new session?"; then
      rm -f "$REDMUX_STATE"
    else
      return 1
    fi
  fi
  printf 'distro=%s\ndesktops=%s\ncompleted=\n' "$distro" "$desktops" > "$REDMUX_STATE"
  chmod 600 "$REDMUX_STATE"
}
state_value() { sed -n "s/^$1=//p" "$REDMUX_STATE" 2>/dev/null | tail -n 1; }
state_has() { case ",$(state_value completed)," in *,"$1",*) return 0;; *) return 1;; esac; }
state_mark() {
  local completed
  completed="$(state_value completed)"
  case ",$completed," in *,"$1",*) ;; *) completed="${completed:+$completed,}$1";; esac
  local distro desktops
  distro="$(state_value distro)"
  desktops="$(state_value desktops)"
  printf 'distro=%s\ndesktops=%s\ncompleted=%s\n' "$distro" "$desktops" "$completed" > "$REDMUX_STATE.tmp"
  mv "$REDMUX_STATE.tmp" "$REDMUX_STATE"
}
state_clear() { rm -f "$REDMUX_STATE" "$REDMUX_STATE.tmp"; }
save_config() {
  umask 077
  mkdir -p "$REDMUX_CONFIG_DIR"
  local temporary="$REDMUX_CONFIG.tmp"
  {
    printf 'REDMUX_DISTRO=%s\n' "$REDMUX_DISTRO"
    printf 'REDMUX_DESKTOP=%s\n' "$REDMUX_DESKTOP"
    printf 'REDMUX_DESKTOPS=%s\n' "$REDMUX_DESKTOPS"
    printf 'REDMUX_DISPLAY=%s\n' "$REDMUX_DISPLAY"
    printf 'REDMUX_RESOLUTION=%s\n' "$REDMUX_RESOLUTION"
    printf 'REDMUX_DPI=%s\n' "$REDMUX_DPI"
    printf 'REDMUX_GPU_MODE=%s\n' "$REDMUX_GPU_MODE"
    printf 'REDMUX_VNC_DISPLAY=%s\n' "$REDMUX_VNC_DISPLAY"
    printf 'REDMUX_VNC_RESOLUTION=%s\n' "$REDMUX_VNC_RESOLUTION"
    printf 'REDMUX_VNC_DEPTH=%s\n' "$REDMUX_VNC_DEPTH"
    printf 'REDMUX_X11_LEGACY=%s\n' "$REDMUX_X11_LEGACY"
    printf 'REDMUX_X11_DEBUG=%s\n' "$REDMUX_X11_DEBUG"
  } > "$temporary"
  chmod 600 "$temporary"
  mv "$temporary" "$REDMUX_CONFIG"
}
show_help() {
cat <<'EOF2'
REDMUX 1.0.0 — Termux Linux Desktop Manager

Usage: redmux [command]
  (no arguments)        Open the interactive control center
  install               Install or resume a Linux desktop
  start [distro]        Launch a desktop through Termux:X11
  stop                  Stop the active desktop session
  restart               Restart the desktop session
  shell [distro]        Open a Linux shell
  environments          List Linux distributions
  desktop               Choose the default desktop environment
  status                Show current configuration and session status
  config                Open configuration options
  config export PATH    Export validated configuration
  config import PATH    Import and validate configuration
  config reset          Reset REDMUX settings
  logs                  Show recent REDMUX logs
  diagnose              Check dependencies and installation state
  uninstall             Remove REDMUX or selected Linux environments
  setup                 Install the redmux command in Termux
  vnc-install           Install the optional VNC server in Linux
  vnc-start             Start the configured VNC desktop
  vnc-stop              Stop the configured VNC desktop
  vnc-status            Show VNC server status
  graphics              Show graphics capability and profile
  apps                  Search, install, remove, and list Linux packages
  themes                Install desktop themes and icon packages
  wine-install          Install Wine and Winetricks in the guest
  wine-run              Run a Windows executable through Wine
  api-install           Install the Termux:API command-line package
  autostart             Enable, disable, or inspect Termux:Boot startup
  reset                 Reset REDMUX settings without removing Linux environments
  gui                   Manage X11 and VNC display sessions
  tx11start             Start the X11 desktop with startup options
  tx11stop              Stop the REDMUX-managed X11 desktop
  version               Show version information
  help                  Show this help
EOF2
}

main_menu() {
  local choice
  while true; do
    clear 2>/dev/null || true
    ui_banner
    ui_dashboard
    read -r -p "  ${C_CYAN}redmux${C_RESET} › " choice
    case "$choice" in
      1|01) run_installer; pause;;
      2|02) session_start; pause;;
      3|03) session_stop; pause;;
      4|04) session_stop; session_start; pause;;
      5|05) distro_shell; pause;;
      6|06) distro_list; pause;;
      7|07) desktop_menu; pause;;
      8|08) display_menu;;
      9|09) graphics_status; pause;;
      10) software_menu;;
      11) themes_install; pause;;
      12) wine_install; pause;;
      13) termux_api_install; pause;;
      14) config_menu; pause;;
      15) system_menu;;
      16) session_status; diagnostics; pause;;
      17) show_logs; pause;;
      18) uninstall_menu; pause;;
      0|00) printf '\n  %sSee you next time.%s\n\n' "$C_CYAN" "$C_RESET"; return 0;;
      *) warn 'Invalid option. Choose 00 or 01–18.'; sleep 1;;
    esac
  done
}

show_logs() { [[ -f "$LOG_FILE" ]] && tail -n 100 "$LOG_FILE" || echo "No logs have been recorded yet."; }

#!/data/data/com.termux/files/usr/bin/bash
REDMUX_VERSION="1.0.0"
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
[[ -f "$REDMUX_CONFIG" ]] && source "$REDMUX_CONFIG"
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
  (( width < 32 )) && width=32
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
  if (( width < 48 )); then
    printf '  %sTERMUX LINUX DESKTOP%s\n' "$C_DIM" "$C_RESET"
    printf '  %sv%s · Linux on Android%s\n' "$C_BOLD" "$REDMUX_VERSION" "$C_RESET"
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

ui_dashboard() {
  local width
  width="$(terminal_width)"
  printf '\n'
  ui_rule "$width" '-'
  ui_box_row 'REDMUX DASHBOARD' "$width" center
  ui_rule "$width" '='
  ui_box_row 'INSTALL' "$width"
  if (( width < 36 )); then
    ui_box_row '01  Install Linux/Desktop' "$width"
    ui_box_row '02  Start Desktop' "$width"
  else
    ui_box_row '01  Install Linux + Desktop' "$width"
    ui_box_row '02  Start Desktop' "$width"
  fi
  ui_box_row '' "$width"
  ui_box_row 'SESSION' "$width"
  ui_box_row '03  Stop Desktop' "$width"
  ui_box_row '04  Open Linux Shell' "$width"
  ui_box_row '' "$width"
  ui_box_row 'LINUX & TOOLS' "$width"
  ui_box_row '05  Environments' "$width"
  ui_box_row '06  Desktop Selection' "$width"
  ui_box_row '' "$width"
  ui_box_row 'MANAGEMENT' "$width"
  if (( width < 36 )); then
    ui_box_row '07  Diagnostics & Status' "$width"
  else
    ui_box_row '07  Status & Diagnostics' "$width"
  fi
  ui_box_row '08  Configuration' "$width"
  ui_box_row '09  View Activity Logs' "$width"
  ui_box_row '10  Uninstall' "$width"
  ui_rule "$width" '-'
  printf '\n  %s00%s  Exit\n\n' "$C_YELLOW$C_BOLD" "$C_RESET"
}

ui_section() { printf '\n  %s-- %s --%s\n' "$C_BLUE$C_BOLD" "$1" "$C_RESET"; }
ui_step() { printf '\n%s◆%s %s\n' "$C_BLUE" "$C_RESET" "$1"; }
ui_ok() { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$1"; }
ui_warn() { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$1" >&2; }
ui_fail() { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$1" >&2; }
ui_stage() {
  local current="$1" total="$2" label="$3" width=28 filled empty pct
  filled=$(( current * width / total )); empty=$(( width - filled )); pct=$(( current * 100 / total ))
  printf '\n  %s%02d/%02d%s  %s\n  %s[' "$C_DIM" "$current" "$total" "$C_RESET" "$label" "$C_CYAN"
  printf '%.*s' "$filled" '############################'
  printf '%.*s' "$empty" '----------------------------'
  printf ']%s %3d%%%s\n' "$C_RESET" "$pct" "$C_BOLD"
}
ui_summary() {
  local width
  width="$(terminal_width)"
  printf '\n'
  ui_rule "$width" '-'
  ui_box_row 'INSTALLATION PLAN' "$width" center
  ui_box_row "Distribution: $1" "$width"
  ui_box_row "Desktop(s): $2" "$width"
  ui_rule "$width" '-'
}
ui_complete() {
  local width
  width="$(terminal_width)"
  printf '\n'
  ui_rule "$width" '='
  ui_box_row 'INSTALLATION COMPLETE' "$width" center
  ui_rule "$width" '='
  printf '  Distribution : %s\n  Desktop(s)    : %s\n\n' "$1" "$2"
  printf '  Next steps\n'
  if (( width < 40 )); then
    printf '  1. Open Termux:X11 app.\n  2. Run %sredmux start%s.\n  3. Run %sredmux shell%s.\n\n' "$C_CYAN" "$C_RESET" "$C_CYAN" "$C_RESET"
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
  progress_stage "$((stage))" "$total" "$label"
  "$@" || { warn "Stage failed: $label. Run redmux install to resume."; return 1; }
  state_mark "$stage"
  progress_stage "$((stage))" "$total" "$label selesai"
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
  cat > "$REDMUX_CONFIG" <<EOF2
REDMUX_DISTRO='$REDMUX_DISTRO'
REDMUX_DESKTOP='$REDMUX_DESKTOP'
REDMUX_DESKTOPS='$REDMUX_DESKTOPS'
REDMUX_DISPLAY='$REDMUX_DISPLAY'
REDMUX_RESOLUTION='$REDMUX_RESOLUTION'
EOF2
}
show_help() {
cat <<'EOF2'
REDMUX 1.0.0 — Termux Linux Desktop Manager

Usage: redmux [command]
  (no arguments)        Open the interactive dashboard
  install               Install or resume a Linux desktop
  start [distro]        Launch a desktop through Termux:X11
  stop                  Stop the active desktop session
  restart               Restart the desktop session
  shell [distro]        Open a Linux shell
  environments          List Linux distributions
  desktop               Choose the default desktop environment
  status                Show current configuration and session status
  config                Open configuration options
  logs                  Show recent REDMUX logs
  diagnose              Check dependencies and installation state
  uninstall             Remove REDMUX or selected Linux environments
  setup                 Install the redmux command in Termux
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
      1|01) run_installer; pause ;;
      2|02) session_start; pause ;;
      3|03) session_stop; pause ;;
      4|04) distro_shell; pause ;;
      5|05) distro_list; pause ;;
      6|06) desktop_menu; pause ;;
      7|07) session_status; diagnostics; pause ;;
      8|08) config_menu; pause ;;
      9|09) show_logs; pause ;;
      10) uninstall_menu; pause ;;
      0|00) printf '\n  %sSee you next time.%s\n\n' "$C_CYAN" "$C_RESET"; exit 0 ;;
      *) warn "Invalid menu option. Choose 00 to exit or 01–10."; sleep 1 ;;
    esac
  done
}

show_logs() { [[ -f "$LOG_FILE" ]] && tail -n 100 "$LOG_FILE" || echo "No logs have been recorded yet."; }

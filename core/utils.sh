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
ui_banner() {
  printf '\n%s' "$C_CYAN"
  cat "$REDMUX_HOME/assets/banner.txt" 2>/dev/null || printf 'REDMUX\n'
  printf '%s' "$C_RESET"
  printf '  %sTERMUX LINUX DESKTOP MANAGER%s  %sv%s%s\n' "$C_DIM" "$C_RESET" "$C_BOLD" "$REDMUX_VERSION" "$C_RESET"
  printf '  %sA cleaner way to build your Linux desktop on Android.%s\n\n' "$C_DIM" "$C_RESET"
}
ui_section() { printf '\n%s╭─ %s%s\n' "$C_BLUE$C_BOLD" "$1" "$C_RESET"; }
ui_step() { printf '\n%s◆%s %s\n' "$C_BLUE" "$C_RESET" "$1"; }
ui_ok() { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$1"; }
ui_warn() { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$1" >&2; }
ui_fail() { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$1" >&2; }
ui_stage() {
  local current="$1" total="$2" label="$3" width=28 filled empty pct
  filled=$(( current * width / total )); empty=$(( width - filled )); pct=$(( current * 100 / total ))
  printf '\n  %s%02d/%02d%s  %s\n  %s[' "$C_DIM" "$current" "$total" "$C_RESET" "$label" "$C_CYAN"
  printf '%.*s' "$filled" '████████████████████████████'
  printf '%.*s' "$empty" '────────────────────────────'
  printf ']%s %3d%%%s\n' "$C_RESET" "$pct" "$C_BOLD"
}
ui_summary() {
  printf '\n%s╭──────────────── INSTALLATION PLAN ────────────────╮%s\n' "$C_BLUE" "$C_RESET"
  printf '  Distribution : %s\n  Desktop(s)    : %s\n' "$1" "$2"
  printf '%s╰───────────────────────────────────────────────────╯%s\n' "$C_BLUE" "$C_RESET"
}
ui_complete() {
  printf '\n%s╭───────────────────────────────────────────────────╮%s\n' "$C_GREEN" "$C_RESET"
  printf '%s│              INSTALLATION COMPLETE                 │%s\n' "$C_GREEN$C_BOLD" "$C_RESET"
  printf '%s╰───────────────────────────────────────────────────╯%s\n' "$C_GREEN" "$C_RESET"
  printf '  Distribution : %s\n  Desktop(s)    : %s\n\n' "$1" "$2"
  printf '  Next steps\n  1. Install the Android Termux:X11 app if needed.\n  2. Run %sredmux start%s to launch your desktop.\n  3. Run %sredmux shell%s to open the Linux terminal.\n\n' "$C_CYAN" "$C_RESET" "$C_CYAN" "$C_RESET"
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
  while true; do
    clear 2>/dev/null || true
    ui_banner
    printf '%s╭────────────────────── DASHBOARD ──────────────────────╮%s\n' "$C_BLUE" "$C_RESET"
    printf '  %sINSTALL%s   1  Install Linux + Desktop\n' "$C_CYAN" "$C_RESET"
    printf '  %sSESSION%s   2  Start Desktop       3  Stop Desktop\n' "$C_CYAN" "$C_RESET"
    printf '  %sLINUX%s     4  Open Linux Shell    5  Environments\n' "$C_CYAN" "$C_RESET"
    printf '  %sDESKTOP%s   6  Desktop Selection\n' "$C_CYAN" "$C_RESET"
    printf '  %sTOOLS%s     7  Status & Diagnostics  8  Configuration\n' "$C_CYAN" "$C_RESET"
    printf '            9  Logs                10 Uninstall\n'
    printf '%s╰───────────────────────────────────────────────────────╯%s\n' "$C_BLUE" "$C_RESET"
    printf '  %s0  Exit%s\n\n' "$C_DIM" "$C_RESET"
    read -r -p "  redmux › " choice
    case "$choice" in
      1) run_installer; pause ;;
      2) session_start; pause ;;
      3) session_stop; pause ;;
      4) distro_shell; pause ;;
      5) distro_list; pause ;;
      6) desktop_menu; pause ;;
      7) session_status; diagnostics; pause ;;
      8) config_menu; pause ;;
      9) show_logs; pause ;;
      10) uninstall_menu; pause ;;
      0) printf '\n  See you next time.\n'; exit 0 ;;
      *) warn "Invalid menu option."; sleep 1 ;;
    esac
  done
}
show_logs() { [[ -f "$LOG_FILE" ]] && tail -n 100 "$LOG_FILE" || echo "No logs have been recorded yet."; }

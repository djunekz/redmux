#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"
export REDMUX_CONFIG_DIR="$TMP/config"
export REDMUX_DATA_DIR="$TMP/data"
export REDMUX_LOG_DIR="$TMP/log"
export REDMUX_HOME="$ROOT"
mkdir -p "$HOME" "$REDMUX_CONFIG_DIR"
printf '%s\n' \
  "REDMUX_DISTRO='ubuntu'" \
  'REDMUX_DESKTOP=gnome' \
  'REDMUX_DESKTOPS=xfce,gnome' \
  'REDMUX_DISPLAY=:2' \
  'REDMUX_RESOLUTION=1920x1080' \
  "touch $TMP/unexpected-command-ran" \
  'REDMUX_DISPLAY=invalid' > "$REDMUX_CONFIG_DIR/redmux.conf"
source "$ROOT/core/utils.sh"
[[ "$REDMUX_DISTRO" == ubuntu ]]
[[ "$REDMUX_DESKTOP" == gnome ]]
[[ "$REDMUX_DESKTOPS" == xfce,gnome ]]
[[ "$REDMUX_DISPLAY" == :2 ]]
[[ "$REDMUX_RESOLUTION" == 1920x1080 ]]
[[ ! -e "$TMP/unexpected-command-ran" ]]
REDMUX_DISPLAY=:3
save_config
unset REDMUX_DISPLAY
source "$ROOT/core/utils.sh"
[[ "$REDMUX_DISPLAY" == :3 ]]
printf 'Configuration validation tests passed.\n'

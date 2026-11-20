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
mkdir -p "$HOME"
source "$ROOT/core/utils.sh"
source "$ROOT/modules/configuration.sh"
source "$ROOT/core/autostart.sh"
REDMUX_DISTRO=ubuntu
REDMUX_DESKTOP=lxqt
REDMUX_DESKTOPS=lxqt,openbox
save_config
config_file_command export "$TMP/export.conf"
REDMUX_DISTRO=debian
REDMUX_DESKTOP=xfce
REDMUX_DESKTOPS=xfce
config_file_command import "$TMP/export.conf"
[[ "$REDMUX_DISTRO" == ubuntu ]]
[[ "$REDMUX_DESKTOP" == lxqt ]]
[[ "$REDMUX_DESKTOPS" == lxqt,openbox ]]
autostart_command enable
[[ -x "$HOME/.termux/boot/redmux" ]]
grep -q 'redmux start' "$HOME/.termux/boot/redmux"
autostart_command disable
[[ ! -e "$HOME/.termux/boot/redmux" ]]
printf 'Configuration import/export and autostart tests passed.\n'

#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"
export PREFIX="$TMP/prefix"
export REDMUX_CONFIG_DIR="$TMP/config"
export REDMUX_DATA_DIR="$TMP/data"
export REDMUX_LOG_DIR="$TMP/log"
export REDMUX_HOME="$ROOT"
mkdir -p "$HOME" "$PREFIX/share/vulkan/icd.d" "$REDMUX_DATA_DIR"
source "$ROOT/core/utils.sh"
source "$ROOT/core/graphics.sh"
source "$ROOT/core/desktop.sh"
[[ "$(graphics_mode_effective)" == software ]]
REDMUX_GPU_MODE=software
[[ "$(graphics_mode_effective)" == software ]]
REDMUX_GPU_MODE=turnip
[[ "$(graphics_mode_effective)" == unavailable ]]
printf '{}' > "$PREFIX/share/vulkan/icd.d/freedreno_icd.aarch64.json"
[[ "$(graphics_mode_effective)" == turnip ]]
[[ "$(desktop_name openbox)" == Openbox ]]
[[ "$(desktop_name i3)" == "i3 Window Manager" ]]
[[ "$(desktop_name cinnamon)" == Cinnamon ]]
[[ "$(desktop_name dwm)" == dwm ]]
[[ "$(desktop_name bspwm)" == bspwm ]]
[[ "$(desktop_name awesome)" == Awesome ]]
[[ "$(desktop_name fluxbox)" == Fluxbox ]]
[[ "$(desktop_name icewm)" == IceWM ]]
[[ "$(desktop_name wmaker)" == "Window Maker" ]]
[[ "$(desktop_command openbox)" == *openbox-session* ]]
[[ "$(desktop_command i3)" == *" i3" ]]
[[ "$(desktop_command cinnamon)" == *cinnamon-session* ]]
[[ "$(desktop_command bspwm)" == *bspwm* ]]
REDMUX_DISTRO=ubuntu
REDMUX_DESKTOPS=xfce,openbox,i3
REDMUX_DPI=180
REDMUX_GPU_MODE=auto
REDMUX_VNC_DISPLAY=:3
REDMUX_VNC_RESOLUTION=1600x900
REDMUX_VNC_DEPTH=32
REDMUX_X11_LEGACY=1
REDMUX_X11_DEBUG=1
save_config
unset REDMUX_DPI REDMUX_GPU_MODE REDMUX_VNC_DISPLAY REDMUX_VNC_RESOLUTION REDMUX_VNC_DEPTH REDMUX_X11_LEGACY REDMUX_X11_DEBUG
source "$ROOT/core/utils.sh"
[[ "$REDMUX_DPI" == 180 ]]
[[ "$REDMUX_GPU_MODE" == auto ]]
[[ "$REDMUX_VNC_DISPLAY" == :3 ]]
[[ "$REDMUX_VNC_RESOLUTION" == 1600x900 ]]
[[ "$REDMUX_VNC_DEPTH" == 32 ]]
[[ "$REDMUX_X11_LEGACY" == 1 ]]
[[ "$REDMUX_X11_DEBUG" == 1 ]]
printf 'Extended graphics, desktop, and configuration tests passed.\n'

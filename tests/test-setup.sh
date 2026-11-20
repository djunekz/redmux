#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"
export PREFIX="$TMP/data/data/com.termux/files/usr"
export REDMUX_CONFIG_DIR="$TMP/config"
export REDMUX_DATA_DIR="$TMP/data-home"
export REDMUX_LOG_DIR="$TMP/log"
mkdir -p "$HOME" "$PREFIX/bin" "$TMP/mock-bin"
printf '#!/usr/bin/env bash
exit 0
' > "$TMP/mock-bin/pkg"
chmod +x "$TMP/mock-bin/pkg"
export PATH="$TMP/mock-bin:$PATH"
bash "$ROOT/redmux" setup
[[ -x "$PREFIX/bin/redmux" ]]
[[ -x "$PREFIX/share/redmux/redmux" ]]
[[ -f "$PREFIX/share/redmux/assets/banner.txt" ]]
[[ ! -e "$PREFIX/share/redmux/assets/menu.svg" ]]
[[ ! -e "$PREFIX/share/redmux/assets/logo.svg" ]]
[[ -d "$PREFIX/share/redmux/core" ]]
[[ -d "$PREFIX/share/redmux/modules" ]]
[[ -f "$PREFIX/share/redmux/core/graphics.sh" ]]
[[ -f "$PREFIX/share/redmux/core/vnc.sh" ]]
[[ -f "$PREFIX/share/redmux/core/software.sh" ]]
[[ -f "$PREFIX/share/redmux/core/autostart.sh" ]]
printf 'Setup installation-boundary test passed.\n'

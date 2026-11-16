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
export NO_COLOR=1
mkdir -p "$HOME"
source "$ROOT/core/utils.sh"
for width in 32 36 40 64 80; do
  output="$TMP/dashboard-$width.txt"
  terminal_width() { printf '%s' "$TEST_WIDTH"; }
  TEST_WIDTH="$width" ui_banner > "$output"
  TEST_WIDTH="$width" ui_dashboard >> "$output"
  TEST_WIDTH="$width" ui_summary debian xfce >> "$output"
  TEST_WIDTH="$width" ui_complete debian xfce >> "$output"
  python3 - "$output" "$width" <<'PY'
import sys
path, expected = sys.argv[1], int(sys.argv[2])
lines = [line.rstrip("\n") for line in open(path, encoding="utf-8") if line.strip()]
for number, line in enumerate(lines, 1):
    if len(line) > expected:
        raise SystemExit(f"width {expected}: line {number} wraps ({len(line)} columns): {line!r}")
    if line.startswith("  +") or line.startswith("  |"):
        if len(line) != expected:
            raise SystemExit(f"width {expected}: border line {number} has {len(line)} columns: {line!r}")
if not any("REDMUX DASHBOARD" in line for line in lines):
    raise SystemExit(f"width {expected}: dashboard title missing")
if not any("10  Uninstall" in line for line in lines):
    raise SystemExit(f"width {expected}: final menu item missing")
if not any("00  Exit" in line for line in lines):
    raise SystemExit(f"width {expected}: exit option missing")
PY
done
printf 'Dashboard layout tests passed at widths: 32, 36, 40, 64, 80 columns.\n'

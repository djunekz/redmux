#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
cleanup() {
  if [[ -n "${UNRELATED_PID:-}" ]]; then kill "$UNRELATED_PID" 2>/dev/null || true; fi
  rm -rf "$TMP"
}
trap cleanup EXIT
export HOME="$TMP/home"
export REDMUX_CONFIG_DIR="$TMP/config"
export REDMUX_DATA_DIR="$TMP/data"
export REDMUX_LOG_DIR="$TMP/log"
export REDMUX_HOME="$ROOT"
mkdir -p "$HOME" "$REDMUX_DATA_DIR"
sleep 30 &
UNRELATED_PID=$!
printf '%s\n' "$UNRELATED_PID" > "$REDMUX_DATA_DIR/session.pid"
printf '1\n' > "$REDMUX_DATA_DIR/session.group"
printf '%s\n' "$UNRELATED_PID" > "$REDMUX_DATA_DIR/x11.pid"
source "$ROOT/core/utils.sh"
source "$ROOT/core/x11.sh"
source "$ROOT/core/graphics.sh"
source "$ROOT/core/session.sh"
session_stop
kill -0 "$UNRELATED_PID"
kill "$UNRELATED_PID"
wait "$UNRELATED_PID" 2>/dev/null || true
[[ ! -e "$REDMUX_DATA_DIR/session.pid" ]]
[[ ! -e "$REDMUX_DATA_DIR/x11.pid" ]]
printf 'Session safety test passed; unrelated processes were left running.\n'

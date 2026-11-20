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
mkdir -p "$HOME" "$TMP/empty-bin"
for tool in bash cat date dirname mkdir sed tee tr tail rm mv chmod cp base64 uname df awk grep sleep clear tput; do
  path="$(command -v "$tool" 2>/dev/null || true)"
  [[ -n "$path" ]] && ln -sf "$path" "$TMP/empty-bin/$tool"
done
export PATH="$TMP/empty-bin"
run() { bash "$ROOT/redmux" "$@" 2>&1 || true; }
expect_defined() {
  local output
  output="$(run "$@")"
  if grep -q 'command not found' <<< "$output"; then
    printf 'Entry point command is missing a function: redmux %s\n%s\n' "$*" "$output" >&2
    exit 1
  fi
}
expect_defined version
expect_defined help
expect_defined autostart status
expect_defined apps list
expect_defined apps
expect_defined themes install
expect_defined themes
expect_defined wine-install
expect_defined wine-run
expect_defined api-install
expect_defined gui --kill
expect_defined gui
expect_defined vnc-install
expect_defined vnc-start
expect_defined vnc-stop
expect_defined vnc-status
expect_defined graphics
expect_defined diagnose
expect_defined status
expect_defined logs
expect_defined environments
output="$(run start)"
if grep -q 'Unknown start option' <<< "$output"; then
  printf 'redmux start without arguments must not be treated as an unknown option.\n%s\n' "$output" >&2
  exit 1
fi
output="$(run version)"
grep -q '^REDMUX 1.0.0$' <<< "$output"
output="$(run autostart status)"
grep -q 'autostart is disabled' <<< "$output"
printf 'Entry point command dispatch tests passed.\n'
